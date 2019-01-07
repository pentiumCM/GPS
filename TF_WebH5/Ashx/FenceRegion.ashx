<%@ WebHandler Language="C#" Class="FenceRegion" %>

using System;
using System.Web;

public class FenceRegion : IHttpHandler
{    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        try
        {
            //System.Globalization.CultureInfo s = new System.Globalization.CultureInfo("en - US");//zh-CN,en-US 是设置语言类型
            //System.Threading.Thread.CurrentThread.CurrentUICulture = s;
            string sUserName = context.Request["username"];
            string sPwd = context.Request["Pwd"];
            string sLoginDefaultType = context.Request["loginDefaultType"];
            string sType = context.Request["DoType"];

            if (string.IsNullOrEmpty(sUserName) || string.IsNullOrEmpty(sPwd) || string.IsNullOrEmpty(sType) || string.IsNullOrEmpty(sLoginDefaultType))
            {
                context.Response.Write("{\"result\":\"false\",\"err\":\"4001\"}");
            }
            else
            {
                if (!SqlFilter.Filter.ProcessFilter(ref sUserName) || !SqlFilter.Filter.ProcessFilter(ref sPwd) || !SqlFilter.Filter.ProcessFilter(ref sLoginDefaultType))
                {
                    context.Response.Write("{\"result\":\"false\",\"err\":\"4002\"}");
                }
                else
                {
                    if (sType == "GetPolygons")
                    {
                        System.Collections.Generic.List<Models.CSqlParameters> lstPar = new System.Collections.Generic.List<Models.CSqlParameters>();
                        Models.CSqlParameters par = new Models.CSqlParameters();
                        par.iLen = sUserName.Length * 2;
                        par.pDirection = System.Data.ParameterDirection.Input;
                        par.sName = "UserName";
                        par.sqlDbType = System.Data.SqlDbType.NVarChar;
                        par.sValue = sUserName;
                        lstPar.Add(par);

                        par = new Models.CSqlParameters();
                        par.iLen = sPwd.Length * 2;
                        par.pDirection = System.Data.ParameterDirection.Input;
                        par.sName = "Password";
                        par.sqlDbType = System.Data.SqlDbType.NVarChar;
                        par.sValue = sPwd;
                        lstPar.Add(par);
                        string sErr = "";
                        if (sLoginDefaultType == "1") //登录公司账号
                        {
                            string sSql = "select ExpirationTime,UserID from usermain where username = @UserName and password = @Password and DelPurview = 0 ";
                            System.Data.DataSet ds = BllSql.RunSqlSelectParameters(false, sSql, lstPar, out sErr);
                            if (sErr.Length > 0)
                            {
                                context.Response.Write("{\"result\":\"false\",\"err\":\"" + sErr + "\"}");
                            }
                            else
                            {
                                if (ds == null || ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0)
                                {
                                    context.Response.Write("{\"result\":\"false\",\"err\":\"4004\"}");
                                }
                                else
                                {
                                    try
                                    {
                                        DateTime dtTime = DateTime.Parse(ds.Tables[0].Rows[0]["ExpirationTime"].ToString());
                                        if (dtTime.Subtract(DateTime.Now).TotalMinutes > 0)
                                        {
                                            string strSQL = "";
                                            //context.Response.Write("{\"result\":\"true\",\"err\":\"\",\"userid\":\"" + ds.Tables[0].Rows[0]["UserID"].ToString() + "\"}");
                                            if (ds.Tables[0].Rows[0]["UserID"].ToString() == "1")
                                            {
                                                strSQL = "select a.CID,a.PolygonName,a.PolygonType,b.VehID,b.InOrOut,isnull(b.IsTime,'false') as IsTime,isnull(b.StartTime,'1900-01-01 00:00:01') as StartTime,isnull(b.EndTime,'1900-01-01 23:59:59') as EndTime,isnull(Sms,'') as Sms,isnull(WeekEnd,0) as WeekEnd,isnull(Holidays,0) as Holidays from [PolygonMain] as a left join [Polygon_Veh] as b on a.CID = b.PolygonID order by a.CID";
                                            }
                                            else
                                            {
                                                lstPar = new System.Collections.Generic.List<Models.CSqlParameters>();
                                                par = new Models.CSqlParameters();
                                                par.iLen = 4;
                                                par.pDirection = System.Data.ParameterDirection.Input;
                                                par.sName = "UserID";
                                                par.sqlDbType = System.Data.SqlDbType.Int;
                                                par.sValue = ds.Tables[0].Rows[0]["UserID"].ToString();
                                                lstPar.Add(par);
                                                System.Data.DataSet dsGroup = BllSql.RunSqlSelectProcedure(false, "GetAllVehGroupByUserID", lstPar, out sErr);
                                                if (sErr.Length > 0 || dsGroup == null || dsGroup.Tables.Count == 0)
                                                {
                                                    context.Response.Write("{\"result\":\"false\",\"err\":\"4004\"}");
                                                    return;
                                                }
                                                string strGroupList = "-1";
                                                for (int i = 0; i < dsGroup.Tables[0].Rows.Count; i++)
                                                {
                                                    if (i == 0)
                                                    {
                                                        strGroupList = dsGroup.Tables[0].Rows[i]["VehGroupID"].ToString();
                                                    }
                                                    else
                                                    {
                                                        strGroupList += "," + dsGroup.Tables[0].Rows[i]["VehGroupID"].ToString();
                                                    }
                                                }
                                                strSQL = "select a.CID,a.PolygonName,a.PolygonType,b.VehID,b.InOrOut,isnull(b.IsTime,'false') as IsTime,isnull(b.StartTime,'1900-01-01 00:00:01') as StartTime,isnull(b.EndTime,'1900-01-01 23:59:59') as EndTime,isnull(Sms,'') as Sms,isnull(WeekEnd,0) as WeekEnd,isnull(Holidays,0) as Holidays from PolygonMain as a left join Polygon_Veh as b on a.CID = b.PolygonID where b.VehID is null and a.UserID = " + ds.Tables[0].Rows[0]["UserID"].ToString();
                                                strSQL = strSQL + " union all select a.CID,a.PolygonName,a.PolygonType,b.VehID,b.InOrOut,isnull(b.IsTime,'false') as IsTime,isnull(b.StartTime,'1900-01-01 00:00:01') as StartTime,isnull(b.EndTime,'1900-01-01 23:59:59') as EndTime,isnull(Sms,'') as Sms,isnull(WeekEnd,0) as WeekEnd,isnull(Holidays,0) as Holidays from PolygonMain as a inner join Polygon_Veh as b on a.CID = b.PolygonID inner join VehicleDetail as c on c.VehID = b.VehID where c.VehGroupID in (" + strGroupList + ") order by a.CID ";
                                            }
                                            System.Data.DataSet dsReturn = BllSql.RunSqlSelect(strSQL);
                                            if (dsReturn == null || dsReturn.Tables.Count == 0)
                                            {
                                                context.Response.Write("{\"result\":\"false\",\"err\":\"4004\"}");
                                            }
                                            else
                                            {
                                                System.Collections.Generic.List<Models.CPolygon> lstPolygon = new System.Collections.Generic.List<Models.CPolygon>();
                                                foreach (System.Data.DataRow dr in dsReturn.Tables[0].Rows)
                                                {
                                                    bool bExist = false;
                                                    foreach (Models.CPolygon item in lstPolygon)
                                                    {
                                                        if (item.id.ToString() == "P" + dr["CID"].ToString())
                                                        {
                                                            bExist = true;
                                                            Models.CPolygonVeh cVeh = new Models.CPolygonVeh();
                                                            if (dr["InOrOut"] == System.DBNull.Value || dr["VehId"] == System.DBNull.Value)
                                                            {
                                                                break;
                                                            }
                                                            cVeh.InOrOut = Convert.ToInt32(dr["InOrOut"]);
                                                            cVeh.VehID = Convert.ToInt32(dr["VehId"]);
                                                            cVeh.IsTime = Convert.ToBoolean(dr["IsTime"]);
                                                            cVeh.StartTime = Convert.ToDateTime(dr["StartTime"]).ToString("yyyy-MM-dd HH:mm:ss");
                                                            cVeh.EndTime = Convert.ToDateTime(dr["EndTime"]).ToString("yyyy-MM-dd HH:mm:ss");
                                                            cVeh.Sms = dr["Sms"].ToString();
                                                            cVeh.WeekEnd = Convert.ToInt32(dr["WeekEnd"]);
                                                            cVeh.Holidays = Convert.ToInt32(dr["Holidays"]);
                                                            item.lstVeh.Add(cVeh);
                                                            break;
                                                        }
                                                    }
                                                    if (!bExist)
                                                    {
                                                        Models.CPolygon cPoly = new Models.CPolygon();
                                                        cPoly.id = "P" + dr["CID"].ToString();
                                                        cPoly.text = dr["PolygonName"].ToString();
                                                        cPoly.PolygonType = Convert.ToInt32(dr["PolygonType"]);
                                                        Models.CPolygonVeh cVeh = new Models.CPolygonVeh();
                                                        if (dr["InOrOut"] == System.DBNull.Value || dr["VehId"] == System.DBNull.Value)
                                                        {

                                                        }
                                                        else
                                                        {
                                                            cVeh.InOrOut = Convert.ToInt32(dr["InOrOut"]);
                                                            cVeh.VehID = Convert.ToInt32(dr["VehId"]);
                                                            cVeh.IsTime = Convert.ToBoolean(dr["IsTime"]);
                                                            cVeh.StartTime = Convert.ToDateTime(dr["StartTime"]).ToString("yyyy-MM-dd HH:mm:ss");
                                                            cVeh.EndTime = Convert.ToDateTime(dr["EndTime"]).ToString("yyyy-MM-dd HH:mm:ss");
                                                            cVeh.Sms = dr["Sms"].ToString();
                                                            cVeh.WeekEnd = Convert.ToInt32(dr["WeekEnd"]);
                                                            cVeh.Holidays = Convert.ToInt32(dr["Holidays"]);
                                                            cPoly.lstVeh.Add(cVeh);
                                                        }
                                                        lstPolygon.Add(cPoly);

                                                    }
                                                }
                                                string sJson = JsonHelper.SerializeObject(lstPolygon);
                                                context.Response.Write("{\"result\":\"true\",\"data\":" + sJson + "}");
                                            }
                                        }
                                        else
                                        {
                                            context.Response.Write("{\"result\":\"false\",\"err\":\"4005\"}");
                                        }
                                        return;
                                    }
                                    catch { }
                                    context.Response.Write("{\"result\":\"false\",\"err\":\"4006\"}");
                                }
                            }
                        }
                        else if (sLoginDefaultType == "2") //车辆登录
                        {

                        }
                        else
                        {
                            context.Response.Write("{\"result\":\"false\",\"err\":\"4002\"}");
                        }
                    }
                    else if (sType == "GetAdministrativeAreasFence")
                    {
                        System.Collections.Generic.List<Models.CSqlParameters> lstPar = new System.Collections.Generic.List<Models.CSqlParameters>();
                        Models.CSqlParameters par = new Models.CSqlParameters();
                        par.iLen = sUserName.Length * 2;
                        par.pDirection = System.Data.ParameterDirection.Input;
                        par.sName = "UserName";
                        par.sqlDbType = System.Data.SqlDbType.NVarChar;
                        par.sValue = sUserName;
                        lstPar.Add(par);

                        par = new Models.CSqlParameters();
                        par.iLen = sPwd.Length * 2;
                        par.pDirection = System.Data.ParameterDirection.Input;
                        par.sName = "Password";
                        par.sqlDbType = System.Data.SqlDbType.NVarChar;
                        par.sValue = sPwd;
                        lstPar.Add(par);
                        string sErr = "";
                        if (sLoginDefaultType == "1") //登录公司账号
                        {
                            string sSql = "select ExpirationTime,UserID from usermain where username = @UserName and password = @Password and DelPurview = 0 ";
                            System.Data.DataSet ds = BllSql.RunSqlSelectParameters(false, sSql, lstPar, out sErr);
                            if (sErr.Length > 0)
                            {
                                context.Response.Write("{\"result\":\"false\",\"err\":\"" + sErr + "\"}");
                            }
                            else
                            {
                                if (ds == null || ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0)
                                {
                                    context.Response.Write("{\"result\":\"false\",\"err\":\"4004\"}");
                                }
                                else
                                {
                                    try
                                    {
                                        DateTime dtTime = DateTime.Parse(ds.Tables[0].Rows[0]["ExpirationTime"].ToString());
                                        if (dtTime.Subtract(DateTime.Now).TotalMinutes > 0)
                                        {
                                            string strSQL = "";
                                            //context.Response.Write("{\"result\":\"true\",\"err\":\"\",\"userid\":\"" + ds.Tables[0].Rows[0]["UserID"].ToString() + "\"}");
                                            if (ds.Tables[0].Rows[0]["UserID"].ToString() == "1")
                                            {
                                                strSQL = "select a.CID,a.RegionTrueName as 'CrawlName',a.RegionName,b.VehID,b.InOrOut,a.[Province],a.[City] from RegionalismMain as a left join Regionalism_Veh as b on a.CID = b.RegionID order by a.CID";
                                            }
                                            else
                                            {
                                                lstPar = new System.Collections.Generic.List<Models.CSqlParameters>();
                                                par = new Models.CSqlParameters();
                                                par.iLen = 4;
                                                par.pDirection = System.Data.ParameterDirection.Input;
                                                par.sName = "UserID";
                                                par.sqlDbType = System.Data.SqlDbType.Int;
                                                par.sValue = ds.Tables[0].Rows[0]["UserID"].ToString();
                                                lstPar.Add(par);
                                                System.Data.DataSet dsGroup = BllSql.RunSqlSelectProcedure(false, "GetAllVehGroupByUserID", lstPar, out sErr);
                                                if (sErr.Length > 0 || dsGroup == null || dsGroup.Tables.Count == 0)
                                                {
                                                    context.Response.Write("{\"result\":\"false\",\"err\":\"4004\"}");
                                                    return;
                                                }
                                                string strGroupList = "-1";
                                                for (int i = 0; i < dsGroup.Tables[0].Rows.Count; i++)
                                                {
                                                    if (i == 0)
                                                    {
                                                        strGroupList = dsGroup.Tables[0].Rows[i]["VehGroupID"].ToString();
                                                    }
                                                    else
                                                    {
                                                        strGroupList += "," + dsGroup.Tables[0].Rows[i]["VehGroupID"].ToString();
                                                    }
                                                }
                                                strSQL = "select a.CID,a.RegionTrueName as 'CrawlName',a.RegionName,b.VehID,b.InOrOut,a.[Province],a.[City] from RegionalismMain as a left join Regionalism_Veh as b on a.CID = b.RegionID where b.VehID is null and a.UserID = " + ds.Tables[0].Rows[0]["UserID"].ToString() 
                                                    + " union all select a.CID,a.RegionTrueName as 'CrawlName',a.RegionName,b.VehID,b.InOrOut,a.[Province],a.[City] from RegionalismMain as a inner join Regionalism_Veh as b on a.CID = b.RegionID inner join VehicleDetail as c on c.VehID = b.VehID where c.VehGroupID in (" + strGroupList + ") order by a.CID ";
                                            }
                                            System.Data.DataSet dsReturn = BllSql.RunSqlSelect(strSQL);
                                            if (dsReturn == null || dsReturn.Tables.Count == 0)
                                            {
                                                context.Response.Write("{\"result\":\"false\",\"err\":\"4004\"}");
                                            }
                                            else
                                            {
                                                System.Collections.Generic.List<Models.CAdministrativeAreasFence> lstPolygon = new System.Collections.Generic.List<Models.CAdministrativeAreasFence>();
                                                foreach (System.Data.DataRow dr in dsReturn.Tables[0].Rows)
                                                {
                                                    bool bExist = false;
                                                    foreach (Models.CAdministrativeAreasFence item in lstPolygon)
                                                    {
                                                        if (item.id.ToString() == "X" + dr["CID"].ToString())
                                                        {
                                                            bExist = true;
                                                            Models.CPolygonVeh cVeh = new Models.CPolygonVeh();
                                                            if (dr["InOrOut"] == System.DBNull.Value || dr["VehId"] == System.DBNull.Value)
                                                            {
                                                                break;
                                                            }
                                                            cVeh.InOrOut = Convert.ToInt32(dr["InOrOut"]);
                                                            cVeh.VehID = Convert.ToInt32(dr["VehId"]);
                                                            cVeh.IsTime = false;// Convert.ToBoolean(dr["IsTime"]);
                                                            cVeh.StartTime = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");// Convert.ToDateTime(dr["StartTime"]).ToString("yyyy-MM-dd HH:mm:ss");
                                                            cVeh.EndTime = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");// Convert.ToDateTime(dr["EndTime"]).ToString("yyyy-MM-dd HH:mm:ss");
                                                            cVeh.Holidays = 0;
                                                            cVeh.WeekEnd = 0;
                                                            item.lstVeh.Add(cVeh);
                                                            break;
                                                        }
                                                    }
                                                    if (!bExist)
                                                    {
                                                        Models.CAdministrativeAreasFence cPoly = new Models.CAdministrativeAreasFence();
                                                        cPoly.id = "X" + dr["CID"].ToString();
                                                        cPoly.text = dr["CrawlName"].ToString();
                                                        cPoly.PolygonType = 4;// Convert.ToInt32(dr["PolygonType"]);
                                                        cPoly.City = dr["City"].ToString();
                                                        cPoly.Province = dr["Province"].ToString();
                                                        cPoly.Area = dr["RegionName"].ToString();
                                                        Models.CPolygonVeh cVeh = new Models.CPolygonVeh();
                                                        if (dr["InOrOut"] == System.DBNull.Value || dr["VehId"] == System.DBNull.Value)
                                                        {

                                                        }
                                                        else
                                                        {
                                                            cVeh.InOrOut = Convert.ToInt32(dr["InOrOut"]);
                                                            cVeh.VehID = Convert.ToInt32(dr["VehId"]);
                                                            cVeh.IsTime = false;// Convert.ToBoolean(dr["IsTime"]);
                                                            cVeh.StartTime = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");// Convert.ToDateTime(dr["StartTime"]).ToString("yyyy-MM-dd HH:mm:ss");
                                                            cVeh.EndTime = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");// Convert.ToDateTime(dr["EndTime"]).ToString("yyyy-MM-dd HH:mm:ss");
                                                            cVeh.Holidays = 0;
                                                            cVeh.WeekEnd = 0;
                                                            cPoly.lstVeh.Add(cVeh);
                                                        }
                                                        lstPolygon.Add(cPoly);

                                                    }
                                                }
                                                string sJson = JsonHelper.SerializeObject(lstPolygon);
                                                context.Response.Write("{\"result\":\"true\",\"data\":" + sJson + "}");
                                            }
                                        }
                                        else
                                        {
                                            context.Response.Write("{\"result\":\"false\",\"err\":\"4005\"}");
                                        }
                                        return;
                                    }
                                    catch { }
                                    context.Response.Write("{\"result\":\"false\",\"err\":\"4006\"}");
                                }
                            }
                        }
                        else if (sLoginDefaultType == "2") //车辆登录
                        {

                        }
                        else
                        {
                            context.Response.Write("{\"result\":\"false\",\"err\":\"4002\"}");
                        }
                    }
                    else if (sType == "GetPolygonPoint")
                    {
                        string sCid = context.Request["cid"];
                        if (string.IsNullOrEmpty(sCid))
                        {
                            context.Response.Write("{\"result\":\"false\",\"err\":\"4001\"}");
                        }
                        else
                        {
                            int iCid = int.Parse(sCid);
                            string sSql = "select dLat,dLng from PolygonDetail where CID = " + sCid;
                            System.Data.DataSet dsReturn = BllSql.RunSqlSelect(sSql);
                            if (dsReturn == null || dsReturn.Tables.Count == 0 || dsReturn.Tables[0].Rows.Count == 0)
                            {
                                context.Response.Write("{\"result\":\"false\",\"err\":\"4004\"}");
                            }
                            else
                            {
                                System.Collections.Generic.List<Models.CPoint> lstPoint = new System.Collections.Generic.List<Models.CPoint>();
                                foreach (System.Data.DataRow dr in dsReturn.Tables[0].Rows)
                                {
                                    Models.CPoint cPoint = new Models.CPoint();
                                    cPoint.lat = Convert.ToDouble(dr["dLat"]);
                                    cPoint.lng = Convert.ToDouble(dr["dLng"]);
                                    lstPoint.Add(cPoint);
                                }
                                string sJson = JsonHelper.SerializeObject(lstPoint);
                                context.Response.Write("{\"result\":\"true\",\"data\":" + sJson + "}");
                            }
                        }
                    }
                    else if (sType == "SavePolygonName")
                    {
                        string sName = context.Request["name"];
                        string sCid = context.Request["cid"];
                        if (string.IsNullOrEmpty(sCid) || string.IsNullOrEmpty(sName) || !SqlFilter.Filter.ProcessFilter(ref sName))
                        {
                            context.Response.Write("{\"result\":\"false\",\"err\":\"4001\"}");
                        }
                        else
                        {
                            string sErr;
                            int iCid = int.Parse(sCid);
                            string sSql = "update PolygonMain set PolygonName = @name where CID = @cid";
                            System.Collections.Generic.List<Models.CSqlParameters>  lstPar = new System.Collections.Generic.List<Models.CSqlParameters>();
                            Models.CSqlParameters par = new Models.CSqlParameters();
                            par.iLen = 4;
                            par.pDirection = System.Data.ParameterDirection.Input;
                            par.sName = "cid";
                            par.sqlDbType = System.Data.SqlDbType.Int;
                            par.sValue = iCid;
                            lstPar.Add(par);
                            par = new Models.CSqlParameters();
                            par.iLen = sName.Length;
                            par.pDirection = System.Data.ParameterDirection.Input;
                            par.sName = "name";
                            par.sqlDbType = System.Data.SqlDbType.NVarChar;
                            par.sValue = sName;
                            lstPar.Add(par);
                            if (BllSql.RunSqlNonQueryParameters(false, sSql, lstPar, out sErr))
                            {
                                context.Response.Write("{\"result\":\"true\",\"err\":\"\"}");
                            }
                            else
                            {
                                context.Response.Write("{\"result\":\"false\",\"err\":\"4004\"}");
                            }
                        }
                    }
                    else if (sType == "SaveAdministrativeAreasFenceName")
                    {
                        string sName = context.Request["name"];
                        string sCid = context.Request["cid"];
                        if (string.IsNullOrEmpty(sCid) || string.IsNullOrEmpty(sName) || !SqlFilter.Filter.ProcessFilter(ref sName))
                        {
                            context.Response.Write("{\"result\":\"false\",\"err\":\"4012\"}");
                        }
                        else
                        {
                            string sErr;
                            int iCid = int.Parse(sCid);
                            string sSql = "update RegionalismMain set RegionTrueName = @name where CID = @cid";
                            System.Collections.Generic.List<Models.CSqlParameters> lstPar = new System.Collections.Generic.List<Models.CSqlParameters>();
                            Models.CSqlParameters par = new Models.CSqlParameters();
                            par.iLen = 4;
                            par.pDirection = System.Data.ParameterDirection.Input;
                            par.sName = "cid";
                            par.sqlDbType = System.Data.SqlDbType.Int;
                            par.sValue = iCid;
                            lstPar.Add(par);
                            par = new Models.CSqlParameters();
                            par.iLen = sName.Length;
                            par.pDirection = System.Data.ParameterDirection.Input;
                            par.sName = "name";
                            par.sqlDbType = System.Data.SqlDbType.NVarChar;
                            par.sValue = sName;
                            lstPar.Add(par);
                            if (BllSql.RunSqlNonQueryParameters(false, sSql, lstPar, out sErr))
                            {
                                context.Response.Write("{\"result\":\"true\",\"err\":\"\"}");
                            }
                            else
                            {
                                context.Response.Write("{\"result\":\"false\",\"err\":\"4004\"}");
                            }
                        }
                    }
                    else if (sType == "SaveAdministrativeAreasFence")
                    {
                        string sName = context.Request["name"];
                        string sPoints = context.Request["points"];
                        string sProvince = context.Request["Province"];
                        string sCity = context.Request["City"];
                        string sArea = context.Request["Area"];
                        string sUserid = context.Request["userid"];
                        int iUserID = int.Parse(sUserid);
                        if (string.IsNullOrEmpty(sName) || string.IsNullOrEmpty(sPoints) || string.IsNullOrEmpty(sProvince) || string.IsNullOrEmpty(sCity) || string.IsNullOrEmpty(sArea))
                        {
                            context.Response.Write("{\"result\":\"false\",\"err\":\"4012\"}");
                            return;
                        }
                        else if (!SqlFilter.Filter.ProcessFilter(ref sName) || !SqlFilter.Filter.ProcessFilter(ref sPoints) || !SqlFilter.Filter.ProcessFilter(ref sProvince) || !SqlFilter.Filter.ProcessFilter(ref sCity) || !SqlFilter.Filter.ProcessFilter(ref sArea))
                        {
                            context.Response.Write("{\"result\":\"false\",\"err\":\"4002\"}");
                            return;
                        }
                        else
                        {
                            string sErr;
                            string sSql = " insert into [RegionalismMain]([RegionTrueName],[RegionName],[InsertTime],[UpdateTime],[UserID],[Province],[City]) ";
                            sSql = sSql + " values('" + sName + "','" + sArea + "','" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "','" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "','" + iUserID.ToString() + "','" + sProvince + "','" + sCity + "') ";
                            sSql = sSql + " declare @cid int set @cid = @@identity ";
                            string[] sLatLngMulGroup = sPoints.Split('-');
                            for (int i = 0; i < sLatLngMulGroup.Length; i++)
                            {
                                string[] arrLatLng = sLatLngMulGroup[i].Split(';');
                                for (int j = 0; j < arrLatLng.Length; j++)
                                {
                                    string[] sLatLng = arrLatLng[j].Split(',');
                                    string dLat = sLatLng[0];
                                    string dLng = sLatLng[1];
                                    sSql = sSql + " insert into [RegionalismDetail]([CID],[dLat],[dLng],MulIndex) values(@cid," + dLat.ToString() + "," + dLng + "," + i.ToString() + ") ";
                                }
                            }
                            sSql = sSql + " select @cid ";
                            object cid = BllSql.RunSqlScalarParameters(true, sSql, new System.Collections.Generic.List<Models.CSqlParameters>(), out sErr);
                            if (sErr.Length > 0)
                            {
                                context.Response.Write("{\"result\":\"false\",\"err\":\"\",'\"err2\":\"" + sErr + "\"}");
                            }
                            else
                            {
                                Models.CAdministrativeAreasFence cPolygon = new Models.CAdministrativeAreasFence();
                                cPolygon.id = "X" + cid.ToString();
                                cPolygon.PolygonType = 4;
                                cPolygon.text = sName;
                                cPolygon.City = sCity;
                                cPolygon.Area = sArea;
                                cPolygon.lstVeh = new System.Collections.Generic.List<Models.CPolygonVeh>();
                                cPolygon.Province = sProvince;
                                //cPolygon.
                                string sJson = JsonHelper.SerializeObject(cPolygon);
                                context.Response.Write("{\"result\":\"true\",\"data\":" + sJson + "}");
                            }
                        }
                    }
                    else if (sType == "DelPolygon")
                    {
                        string sCid = context.Request["cid"];
                        if (string.IsNullOrEmpty(sCid))
                        {
                            context.Response.Write("{\"result\":\"false\",\"err\":\"4001\"}");
                        }
                        else
                        {
                            string sErr;
                            int iCid = int.Parse(sCid);
                            string sSql = "delete from [PolygonMain] where CID = @cid";
                            sSql += " delete from [Regionalism_Veh] where RegionID = @cid";
                            sSql += " delete from RegionalismDetail where CID = @cid";
                            System.Collections.Generic.List<Models.CSqlParameters> lstPar = new System.Collections.Generic.List<Models.CSqlParameters>();
                            Models.CSqlParameters par = new Models.CSqlParameters();
                            par.iLen = 4;
                            par.pDirection = System.Data.ParameterDirection.Input;
                            par.sName = "cid";
                            par.sqlDbType = System.Data.SqlDbType.Int;
                            par.sValue = iCid;
                            lstPar.Add(par);
                            if (BllSql.RunSqlNonQueryParameters(true, sSql, lstPar, out sErr))
                            {
                                context.Response.Write("{\"result\":\"true\",\"err\":\"\"}");
                            }
                            else
                            {
                                context.Response.Write("{\"result\":\"false\",\"err\":\"4004\"}");
                            }
                        }
                    }
                    else if (sType == "DelAdministrativeAreasFence")
                    {
                        string sCid = context.Request["cid"];
                        if (string.IsNullOrEmpty(sCid))
                        {
                            context.Response.Write("{\"result\":\"false\",\"err\":\"4001\"}");
                        }
                        else
                        {
                            string sErr;
                            int iCid = int.Parse(sCid);
                            string sSql = "delete from [RegionalismMain] where CID = @cid";
                            sSql += " delete from [Polygon_Veh] where PolygonID = @cid";
                            sSql += " delete from PolygonDetail where CID = @cid";
                            System.Collections.Generic.List<Models.CSqlParameters> lstPar = new System.Collections.Generic.List<Models.CSqlParameters>();
                            Models.CSqlParameters par = new Models.CSqlParameters();
                            par.iLen = 4;
                            par.pDirection = System.Data.ParameterDirection.Input;
                            par.sName = "cid";
                            par.sqlDbType = System.Data.SqlDbType.Int;
                            par.sValue = iCid;
                            lstPar.Add(par);
                            if (BllSql.RunSqlNonQueryParameters(true, sSql, lstPar, out sErr))
                            {
                                context.Response.Write("{\"result\":\"true\",\"err\":\"\"}");
                            }
                            else
                            {
                                context.Response.Write("{\"result\":\"false\",\"err\":\"4004\"}");
                            }
                        }
                    }
                    else if (sType == "SavePolygon")
                    {
                        string sName = context.Request["name"];
                        string sPoints = context.Request["points"];
                        string sUserid = context.Request["userid"];
                        if (string.IsNullOrEmpty(sName) || string.IsNullOrEmpty(sName) || string.IsNullOrEmpty(sUserid))
                        {
                            context.Response.Write("{\"result\":\"false\",\"err\":\"4001\"}");
                        }
                        else if (!SqlFilter.Filter.ProcessFilter(ref sName) || !SqlFilter.Filter.ProcessFilter(ref sPoints))
                        {
                            context.Response.Write("{\"result\":\"false\",\"err\":\"4001\"}");
                        }
                        else
                        {
                            string sErr;
                            string sSql = "declare @cid int insert into [PolygonMain](PolygonName,PolygonType,InsertTime,UpdateTime,UserID) values(@Name,2,'" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "','" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "'," + int.Parse(sUserid).ToString() + ")";
                            sSql += " select @cid = @@IDENTITY select @return = @@IDENTITY";
                            string[] arrLngLat = sPoints.Split(';');
                            foreach (string item in arrLngLat)
                            {
                                string[] sLngLat = item.Split(',');
                                string x = sLngLat[0];
                                string y = sLngLat[1];
                                sSql += " insert into PolygonDetail(CID,dLat,dLng) values(@cid," + y + "," + x + ")";
                            }
                            System.Collections.Generic.List<Models.CSqlParameters> lstPar = new System.Collections.Generic.List<Models.CSqlParameters>();
                            Models.CSqlParameters par = new Models.CSqlParameters();
                            par.iLen = sName.Length;
                            par.pDirection = System.Data.ParameterDirection.Input;
                            par.sName = "Name";
                            par.sqlDbType = System.Data.SqlDbType.NVarChar;
                            par.sValue = sName;
                            lstPar.Add(par);
                            par = new Models.CSqlParameters();
                            par.iLen = 4;
                            par.pDirection = System.Data.ParameterDirection.Output;
                            par.sName = "return";
                            par.sqlDbType = System.Data.SqlDbType.Int;
                            lstPar.Add(par);
                            if (BllSql.RunSqlNonQueryParameters(true, sSql, lstPar, out sErr))
                            {
                                Models.CPolygon cPolygon = new Models.CPolygon();
                                cPolygon.id = "G" + sErr;
                                cPolygon.PolygonType = 2;
                                cPolygon.text = sName;
                                string sJson = JsonHelper.SerializeObject(cPolygon);
                                context.Response.Write("{\"result\":\"true\",\"data\":" + sJson + "}");
                            }
                            else
                            {
                                context.Response.Write("{\"result\":\"false\",\"err\":\"4004\"}");
                            }
                        }
                    }
                    else if (sType == "SavePolygonVeh")
                    {
                        string sVeh = context.Request["vehs"];
                        string sCid = context.Request["cid"];
                        string sInOrOut = context.Request["InOrOut"];
                        string sIsTime = context.Request["IsTime"];
                        string sStartTime = context.Request["StartTime"];
                        string sEndTime = context.Request["EndTime"];
                        string sSms = context.Request["Sms"];
                        string sWeekEnd = context.Request["WeekEnd"];
                        string sHolidays = context.Request["Holidays"];
                        
                        DateTime dtTime;
                        if (string.IsNullOrEmpty(sVeh))
                        {
                            sVeh = "";
                        }
                        if (string.IsNullOrEmpty(sCid) || string.IsNullOrEmpty(sInOrOut) || string.IsNullOrEmpty(sIsTime) || string.IsNullOrEmpty(sStartTime) || string.IsNullOrEmpty(sEndTime) || string.IsNullOrEmpty(sWeekEnd) || string.IsNullOrEmpty(sHolidays))
                        {
                            context.Response.Write("{\"result\":\"false\",\"err\":\"4001\"}");
                        }
                        else if (!SqlFilter.Filter.ProcessFilter(ref sCid) || !SqlFilter.Filter.ProcessFilter(ref sVeh) || !SqlFilter.Filter.ProcessFilter(ref sSms) || !SqlFilter.Filter.ProcessFilter(ref sWeekEnd) || !SqlFilter.Filter.ProcessFilter(ref sHolidays))
                        {
                            context.Response.Write("{\"result\":\"false\",\"err\":\"4001\"}");
                        }
                        else if (!DateTime.TryParse(sStartTime, out dtTime) || !DateTime.TryParse(sEndTime, out dtTime))
                        {
                            context.Response.Write("{\"result\":\"false\",\"err\":\"4001\"}");
                        }
                        else
                        {
                            int iWeekEnd = int.Parse(sWeekEnd);
                            int iHoliday = int.Parse(sHolidays);
                            int iInOrOut = int.Parse(sInOrOut);
                            string sErr;
                            string sSql = "delete from Polygon_Veh where PolygonID = @cid";
                            foreach (string item in sVeh.Split(','))
                            {
                                if (item.Length > 0)
                                {
                                    sSql += " insert into Polygon_Veh(VehID,PolygonID,InOrOut,IsTime,StartTime,EndTime,Sms,WeekEnd,Holidays) values(" + item + ",@cid,@InOrOut,@IsTime,@StartTime,@EndTime,@Sms,@WeekEnd,@Holidays) ";
                                }
                            }
                            System.Collections.Generic.List<Models.CSqlParameters> lstPar = new System.Collections.Generic.List<Models.CSqlParameters>();
                            Models.CSqlParameters par = new Models.CSqlParameters();
                            par.iLen = 4;
                            par.pDirection = System.Data.ParameterDirection.Input;
                            par.sName = "cid";
                            par.sqlDbType = System.Data.SqlDbType.NVarChar;
                            par.sValue = sCid;
                            lstPar.Add(par);
                            par = new Models.CSqlParameters();
                            par.iLen = 4;
                            par.pDirection = System.Data.ParameterDirection.Input;
                            par.sName = "InOrOut";
                            par.sqlDbType = System.Data.SqlDbType.Int;
                            par.sValue = iInOrOut;
                            lstPar.Add(par);
                            par = new Models.CSqlParameters();
                            par.iLen = 1;
                            par.pDirection = System.Data.ParameterDirection.Input;
                            par.sName = "IsTime";
                            par.sqlDbType = System.Data.SqlDbType.Bit;
                            par.sValue = sIsTime;
                            lstPar.Add(par);
                            par = new Models.CSqlParameters();
                            par.iLen = 8;
                            par.pDirection = System.Data.ParameterDirection.Input;
                            par.sName = "StartTime";
                            par.sqlDbType = System.Data.SqlDbType.DateTime;
                            par.sValue = sStartTime;
                            lstPar.Add(par);
                            par = new Models.CSqlParameters();
                            par.iLen = 8;
                            par.pDirection = System.Data.ParameterDirection.Input;
                            par.sName = "EndTime";
                            par.sqlDbType = System.Data.SqlDbType.DateTime;
                            par.sValue = sEndTime;
                            lstPar.Add(par);
                            par = new Models.CSqlParameters();
                            par.iLen = sSms.Length;
                            par.pDirection = System.Data.ParameterDirection.Input;
                            par.sName = "Sms";
                            par.sqlDbType = System.Data.SqlDbType.VarChar;
                            par.sValue = sSms;
                            lstPar.Add(par);
                            par = new Models.CSqlParameters();
                            par.iLen = 4;
                            par.pDirection = System.Data.ParameterDirection.Input;
                            par.sName = "WeekEnd";
                            par.sqlDbType = System.Data.SqlDbType.Int;
                            par.sValue = iWeekEnd;
                            lstPar.Add(par);
                            par = new Models.CSqlParameters();
                            par.iLen = 4;
                            par.pDirection = System.Data.ParameterDirection.Input;
                            par.sName = "Holidays";
                            par.sqlDbType = System.Data.SqlDbType.Int;
                            par.sValue = iHoliday;
                            lstPar.Add(par);
                            if (BllSql.RunSqlNonQueryParameters(true, sSql, lstPar, out sErr))
                            {
                                context.Response.Write("{\"result\":\"true\",\"err\":\"\"}");
                            }
                            else
                            {
                                context.Response.Write("{\"result\":\"false\",\"err\":\"4004\"}");
                            }
                        }
                    }
                    else if (sType == "SaveAdministrativeAreasFenceVeh")
                    {
                        string sVeh = context.Request["vehs"];
                        string sCid = context.Request["cid"];
                        string sInOrOut = context.Request["InOrOut"];
                        string sIsTime = context.Request["IsTime"];
                        string sStartTime = context.Request["StartTime"];
                        string sEndTime = context.Request["EndTime"];
                        DateTime dtTime;
                        if (string.IsNullOrEmpty(sVeh))
                        {
                            sVeh = "";
                        }
                        if (string.IsNullOrEmpty(sCid) || string.IsNullOrEmpty(sInOrOut) || string.IsNullOrEmpty(sIsTime) || string.IsNullOrEmpty(sStartTime) || string.IsNullOrEmpty(sEndTime))
                        {
                            context.Response.Write("{\"result\":\"false\",\"err\":\"4001\"}");
                        }
                        else if (!SqlFilter.Filter.ProcessFilter(ref sCid) || !SqlFilter.Filter.ProcessFilter(ref sVeh))
                        {
                            context.Response.Write("{\"result\":\"false\",\"err\":\"4001\"}");
                        }
                        else if (!DateTime.TryParse(sStartTime, out dtTime) || !DateTime.TryParse(sEndTime, out dtTime))
                        {
                            context.Response.Write("{\"result\":\"false\",\"err\":\"4001\"}");
                        }
                        else
                        {
                            int iInOrOut = int.Parse(sInOrOut);
                            string sErr;
                            string sSql = "delete from Regionalism_Veh where RegionID = @cid";
                            foreach (string item in sVeh.Split(','))
                            {
                                if (item.Length > 0)
                                {
                                    sSql += " insert into Regionalism_Veh(VehID,RegionID,InOrOut) values(" + item + ",@cid,@InOrOut) ";
                                }
                            }
                            System.Collections.Generic.List<Models.CSqlParameters> lstPar = new System.Collections.Generic.List<Models.CSqlParameters>();
                            Models.CSqlParameters par = new Models.CSqlParameters();
                            par.iLen = 4;
                            par.pDirection = System.Data.ParameterDirection.Input;
                            par.sName = "cid";
                            par.sqlDbType = System.Data.SqlDbType.NVarChar;
                            par.sValue = sCid;
                            lstPar.Add(par);
                            par = new Models.CSqlParameters();
                            par.iLen = 4;
                            par.pDirection = System.Data.ParameterDirection.Input;
                            par.sName = "InOrOut";
                            par.sqlDbType = System.Data.SqlDbType.Int;
                            par.sValue = iInOrOut;
                            lstPar.Add(par);
                            if (BllSql.RunSqlNonQueryParameters(true, sSql, lstPar, out sErr))
                            {
                                context.Response.Write("{\"result\":\"true\",\"err\":\"\"}");
                            }
                            else
                            {
                                context.Response.Write("{\"result\":\"false\",\"err\":\"4004\"}");
                            }
                        }
                    }
                    else
                    {
                        context.Response.Write("{\"result\":\"false\",\"err\":\"4002\"}");
                    }
                }
            }
        }
        catch (Exception ex)
        {
            context.Response.Write("{\"result\":\"false\",\"err\":\"" + ex.Message + "\"}");
        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}