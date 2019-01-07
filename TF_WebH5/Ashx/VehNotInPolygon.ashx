<%@ WebHandler Language="C#" Class="VehNotInPolygon" %>

using System;
using System.Web;

public class VehNotInPolygon : IHttpHandler
{    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        try
        {
            //System.Globalization.CultureInfo s = new System.Globalization.CultureInfo("en - US");//zh-CN,en-US 是设置语言类型
            //System.Threading.Thread.CurrentThread.CurrentUICulture = s;
            string sUserName = context.Request["username"];
            string sPwd = context.Request["Pwd"];
            string sLoginDefaultType = "1";// context.Request["loginDefaultType"];
            string sType = "GetNotInPolygons";// context.Request["DoType"];
            string sBeginTime = context.Request["BeginTime"];
            string sEndTime = context.Request["EndTime"];

            if (string.IsNullOrEmpty(sUserName) || string.IsNullOrEmpty(sPwd) || string.IsNullOrEmpty(sType) || string.IsNullOrEmpty(sLoginDefaultType) || string.IsNullOrEmpty(sBeginTime) || string.IsNullOrEmpty(sEndTime))
            {
                context.Response.Write("{\"result\":\"false\",\"err\":\"4001\"}");
            }
            else
            {
                if (!SqlFilter.Filter.ProcessFilter(ref sUserName) || !SqlFilter.Filter.ProcessFilter(ref sPwd) || !SqlFilter.Filter.ProcessFilter(ref sLoginDefaultType) || !SqlFilter.Filter.ProcessFilter(ref sBeginTime) || !SqlFilter.Filter.ProcessFilter(ref sEndTime))
                {
                    context.Response.Write("{\"result\":\"false\",\"err\":\"4002\"}");
                }
                else
                {
                    if (sType == "GetNotInPolygons")
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
                                                strSQL = "select [VehID],[Time],[Lng],[Lat],[Acc],[PolygonID],PolygonType from Bee" + DateTime.Parse(sBeginTime).ToString("yyyyMMdd") + ".dbo.[NotInPolygonAlarm] where ([Time] >= '" + sBeginTime + "' and [Time] <= '" + sEndTime + "')";
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
                                                strSQL = "select c.[VehID],[Time],[Lng],[Lat],[Acc],[PolygonID],PolygonType from Bee" + DateTime.Parse(sBeginTime).ToString("yyyyMMdd") + ".dbo.[NotInPolygonAlarm] as NotInPolygonAlarm inner join VehicleDetail as c on c.VehID = NotInPolygonAlarm.VehID where c.VehGroupID in (" + strGroupList + ") AND ([Time] >= '" + sBeginTime + "' and [Time] <= '" + sEndTime + "')";
                                                
                                            }
                                            System.Data.DataSet dsReturn = BllSql.RunSqlSelect(strSQL);
                                            if (dsReturn == null || dsReturn.Tables.Count == 0)
                                            {
                                                context.Response.Write("{\"result\":\"false\",\"err\":\"4004\"}");
                                            }
                                            else
                                            {
                                                System.Collections.Generic.List<Models.CNotInPolygn> lstHistory = new System.Collections.Generic.List<Models.CNotInPolygn>();
                                                Models.CNotInPolygn temp = new Models.CNotInPolygn();
                                                foreach (System.Data.DataRow dr in dsReturn.Tables[0].Rows)
                                                {
                                                    temp = new Models.CNotInPolygn();
                                                    temp.id = Convert.ToInt32(dr["VehID"]);
                                                    temp.Acc = Convert.ToInt32(dr["Acc"]);
                                                    temp.Latitude = Convert.ToDouble(dr["Lat"]);
                                                    temp.Longitude = Convert.ToDouble(dr["Lng"]);
                                                    temp.PolygonID = Convert.ToInt32(dr["PolygonID"]);
                                                    temp.PolygonType = Convert.ToInt32(dr["PolygonType"]);
                                                    temp.Time = dr["Time"].ToString();
                                                    double x1 = temp.Longitude;
                                                    double y1 = temp.Latitude;
                                                    //double x2, y2;
                                                    //BaiduMapCorrect.GetBaiduCorrectFromGps(x1, y1, out x2, out y2);
                                                    temp.Longitude = x1;
                                                    temp.Latitude = y1;
                                                    lstHistory.Add(temp);
                                                }
                                                string sJson = JsonHelper.SerializeObject(lstHistory);
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