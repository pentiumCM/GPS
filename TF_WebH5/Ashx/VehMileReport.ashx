<%@ WebHandler Language="C#" Class="VehMileReport" %>

using System;
using System.Web;
using System.Data;
using System.Collections.Generic;
using Models;

public class VehMileReport : IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string sVehID = context.Request["VehID"];
        string sBeginTime = context.Request["BeginTime"];
        string sEndTime = context.Request["EndTime"];
        string sUserType = context.Request["UseType"];
        string sDataType = context.Request["DataType"];
        string sCmdID = context.Request["iCmdID"];
        string sIsWorkTime = context.Request["bWorkTime"];
        string sWorkTimeBegin = context.Request["sWorkStart"];
        string sWorkTimeEnd = context.Request["sWorkEnd"];
        string sUserName = context.Request["UserName"];
        string sPwd = context.Request["Pwd"];
        string sFilter = context.Request["Filter"];
        if (sFilter == null)
        {
            sFilter = ""; 
        }
        string sBatch = System.Configuration.ConfigurationManager.AppSettings["Batch"];
        int iUserID = -1;

        if (string.IsNullOrEmpty(sUserName) || string.IsNullOrEmpty(sPwd) || string.IsNullOrEmpty(sVehID) || string.IsNullOrEmpty(sBeginTime) || string.IsNullOrEmpty(sEndTime) || string.IsNullOrEmpty(sUserType))
        {
            context.Response.Write("{\"result\":\"false\",\"err\":\"参数错误！\"}");
            return;
        }
        if (string.IsNullOrEmpty(sDataType) || string.IsNullOrEmpty(sCmdID) || string.IsNullOrEmpty(sIsWorkTime) || string.IsNullOrEmpty(sWorkTimeBegin) || string.IsNullOrEmpty(sWorkTimeEnd))
        {
            context.Response.Write("{\"result\":\"false\",\"err\":\"参数错误！\"}");
            return;
        }
        if (!SqlFilter.Filter.ProcessFilter(ref sUserName) || !SqlFilter.Filter.ProcessFilter(ref sPwd))
        {
            context.Response.Write("{\"result\":\"false\",\"err\":\"4002\"}");
            return; 
        }
        System.Collections.Generic.List<string> lstVeh = new System.Collections.Generic.List<string>();
        System.Collections.Generic.List<int> lstTaxino = new System.Collections.Generic.List<int>();
        if (sUserType == "2")
        {

        }
        else
        {

            //int iRun = BllSql.RunSqlScalar("select 1 from WxinUser where Openid = '" + sOpenID + "' ");
            //if (iRun <= 0)
            //{
            //    context.Response.Write("用户不存在！");
            //    return;
            //}
        }
        //string sSql = "SELECT Longitude, Latitude, Angle, Velocity, Alarm, RunMile, Component, Locate,[Time] ,oil ,m_OilScale,m_OilNum,Temperature1,Temperature2,Temperature3,temperature4,SensorSpeed,CommandID FROM @TableName where (VehID=@VehID) And ([time] >= ''@StartDate'' and [time] <= ''@EndDate'') order by [time]')";
        string sTableName = "Dyndata";
        if (sVehID.StartsWith("V"))
        {
            sVehID = sVehID.Substring(1);
            //DataSet ds = BllSql.RunSqlSelect("select ID,taxino from vehicle where ID = " + int.Parse(sVehID.ToString()).ToString());
            //if (ds == null || ds.Tables.Count == 0 || ds.Tables[0].Rows.Count)
            //{
            //    context.Response.Write("车辆不存在！");
            //    return;
            //}
            lstVeh.Add(sVehID);
            string sTaxino = sCmdID;// ds.Tables[0].Rows[0]["taxino"].ToString();
            int iCmdID = 128;
            if (sTaxino.IndexOf("DB44") > -1)
            {
                iCmdID = 42240;
            }
            if (sTaxino.IndexOf("GPRS_TQ型") > -1 | sTaxino.IndexOf("GPRS_CX型") > -1)
            {
                iCmdID = 43562;
            }
            else if (sTaxino.IndexOf("GB") > -1 || sTaxino.IndexOf("云镜") > -1 || sTaxino.IndexOf("部标") > -1 || sTaxino.IndexOf("国标") > -1)
            {
                iCmdID = 170;
            }
            else if (sTaxino.IndexOf("XWRJ") > -1)
            {
                iCmdID = 178;
            }
            lstTaxino.Add(iCmdID);
        }
        else
        {
            string sGroupID = sVehID.Substring(1);
            string sErrUser;
            System.Collections.Generic.List<Models.CSqlParameters> lstParUser = new System.Collections.Generic.List<Models.CSqlParameters>();
            Models.CSqlParameters parUser = new Models.CSqlParameters();
            parUser.iLen = sGroupID.Length;
            parUser.pDirection = System.Data.ParameterDirection.Input;
            parUser.sName = "GroupID";
            parUser.sqlDbType = System.Data.SqlDbType.Int;
            parUser.sValue = sGroupID;
            lstParUser.Add(parUser);

            Models.CSqlParameters par = new Models.CSqlParameters();
            par.iLen = sUserName.Length * 2;
            par.pDirection = System.Data.ParameterDirection.Input;
            par.sName = "UserName";
            par.sqlDbType = System.Data.SqlDbType.NVarChar;
            par.sValue = sUserName;
            lstParUser.Add(par);

            par = new Models.CSqlParameters();
            par.iLen = sPwd.Length * 2;
            par.pDirection = System.Data.ParameterDirection.Input;
            par.sName = "Pwd";
            par.sqlDbType = System.Data.SqlDbType.NVarChar;
            par.sValue = sPwd;
            lstParUser.Add(par);
            System.Data.DataSet ds = BllSql.RunSqlSelectProcedure(false, "GetAllVehIDFromGroup", lstParUser, out sErrUser);
            if (sErrUser.Length > 0)
            {
                context.Response.Write(sErrUser);
                return;
            }
            if (ds == null || ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0)
            {
                context.Response.Write("{\"result\":\"false\",\"err\":\"没有车辆数据！\"}");
                return;
            }
            foreach (System.Data.DataRow dr in ds.Tables[0].Rows)
            {
                lstVeh.Add(dr["ID"].ToString());
                string sTaxino = dr["taxino"].ToString();
                int iCmdID = 128;
                if (sTaxino.IndexOf("DB44") > -1)
                {
                    iCmdID = 42240;
                }
                if (sTaxino.IndexOf("GPRS_TQ型") > -1 | sTaxino.IndexOf("GPRS_CX型") > -1)
                {
                    iCmdID = 43562;
                }
                else if (sTaxino.IndexOf("GB") > -1 || sTaxino.IndexOf("云镜") > -1 || sTaxino.IndexOf("部标") > -1 || sTaxino.IndexOf("国标") > -1)
                {
                    iCmdID = 170;
                }
                else if (sTaxino.IndexOf("XWRJ") > -1)
                {
                    iCmdID = 178;
                }
                lstTaxino.Add(iCmdID);
            }
        }

        System.Collections.Generic.List<Models.CMile> lstMile = new System.Collections.Generic.List<Models.CMile>();
        string sSql = "";
        string sDbName = "Bee" + DateTime.Parse(sBeginTime).ToString("yyyyMMdd") + ".dbo.";
        sBatch = System.Configuration.ConfigurationManager.AppSettings["Batch"];
        for (int i = 0; i < lstVeh.Count; i++)
        {
            lstMile = QueryMileage(lstVeh[i], sBeginTime, sEndTime, sDataType, bool.Parse(sIsWorkTime), sWorkTimeBegin, sWorkTimeEnd, lstTaxino[i], sFilter);
            if (lstMile.Count > 0)
            {
                System.Data.DataSet ds = BllSql.RunSqlSelect("select Cph from Vehicle where Id = " + sVehID);
                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    string sCph = ds.Tables[0].Rows[0][0].ToString();
                    foreach (Models.CMile temp in lstMile)
                    {
                        temp.Cph = sCph;
                        temp.Oil = 0;
                        temp.OilPrice = 0;
                    }
                }
            }
            string sJson = JsonHelper.SerializeObject(lstMile);
            context.Response.Write("{\"result\":\"true\",\"err\":\"\",\"data\":" + sJson + "}");
            return;
        }
    }

    private System.Collections.Generic.List<Models.CMile> QueryMileage(string sVehID, string strStartDate, string strEndDate, string sDataType, bool bWorkTime, string sWorkStart, string sWorkEnd, int iCmdID, string sFilter)
    {
        int iDataType = int.Parse(sDataType);
        DateTime dtStart = Convert.ToDateTime(strStartDate);
        DateTime dtEnd = Convert.ToDateTime(strEndDate);
        DateTime dtWorkStart = DateTime.Parse(sWorkStart);
        DateTime dtWorkEnd = DateTime.Parse(sWorkEnd);
        int iUserID = 0;
        System.Data.DataSet pDtSet = new System.Data.DataSet();

        System.Data.DataTable table = new System.Data.DataTable();
        AddTableCol(ref table);
        bool pFirst = false;
        bool pLast = false;
        double dMileSetValue = 0.0;
        DateTime midTime;

        int i = 0;
        int iCount = 0;
        int iVehID;
        if (iDataType == 4)
        {
            iVehID = 0;
            iUserID = int.Parse(sVehID);
        }
        else
        {
            iVehID = int.Parse(sVehID);
        }
        bool bSat = sFilter.IndexOf("0") != -1;
        bool bSunday = sFilter.IndexOf("1") != -1;
        bool bHolidays = sFilter.IndexOf("2") != -1;
        DataRowCollection drsHoliday = null;
        if (bHolidays)
        {
            DataSet dsHoliday = BllSql.RunSqlSelect("select * from [Holidays] ");
            if (dsHoliday != null && dsHoliday.Tables.Count > 0 && dsHoliday.Tables[0].Rows.Count > 0)
            {
                drsHoliday = dsHoliday.Tables[0].Rows; 
            }
        }
        //''''''''''''''''全部使用存储过程的方式''''''''''''''''''''''
        if (iDataType == 4)
        {
            //QueryMileageStartEndByUserID(adoConn, table, iUserID, dtStart.ToString("yyyy-MM-dd HH:mm:ss"), dtEnd.ToString("yyyy-MM-dd HH:mm:ss"), 0)

        }
        else
        {
            TimeSpan stSpan = DateTime.Parse(dtEnd.ToString("yyyy-MM-dd 23:59:59")) - DateTime.Parse(dtStart.ToString("yyyy-MM-dd 00:00:01"));

            iCount = (int)Math.Truncate(stSpan.TotalDays);
            if (iCount == 0)
            {
                //如果是同一天
                sWorkStart = dtStart.ToString("yyyy-MM-dd HH:mm:ss");
                sWorkEnd = dtEnd.ToString("yyyy-MM-dd HH:mm:ss");
                if (bWorkTime)
                {
                    if (dtWorkStart.Hour > dtStart.Hour)
                    {
                        sWorkStart = dtStart.ToString("yyyy-MM-dd ") + dtWorkStart.ToString("HH:mm:ss");
                    }
                    else if (dtWorkStart.Hour == dtStart.Hour)
                    {
                        if (dtWorkStart.Minute > dtStart.Minute)
                        {
                            sWorkStart = dtStart.ToString("yyyy-MM-dd ") + dtWorkStart.ToString("HH:mm:ss");
                        }
                        else if (dtWorkStart.Minute == dtStart.Minute)
                        {
                            if (dtWorkStart.Second > dtStart.Second)
                            {
                                sWorkStart = dtStart.ToString("yyyy-MM-dd ") + dtWorkStart.ToString("HH:mm:ss");
                            }
                        }
                    }
                    if (dtEnd.Hour > dtWorkEnd.Hour)
                    {
                        sWorkEnd = dtEnd.ToString("yyyy-MM-dd ") + dtWorkEnd.ToString("HH:mm:ss");
                    }
                    else if (dtEnd.Hour == dtWorkEnd.Hour)
                    {
                        if (dtEnd.Minute > dtWorkEnd.Minute)
                        {
                            sWorkEnd = dtEnd.ToString("yyyy-MM-dd ") + dtWorkEnd.ToString("HH:mm:ss");
                        }
                        else if (dtEnd.Minute == dtWorkEnd.Minute)
                        {
                            if (dtEnd.Second > dtWorkEnd.Second)
                            {
                                sWorkEnd = dtEnd.ToString("yyyy-MM-dd ") + dtWorkEnd.ToString("HH:mm:ss");
                            }
                        }
                    }
                }
                if (!CheckHolidayFilter(DateTime.Parse(sWorkStart), bSat, bSunday, drsHoliday))
                {
                    QueryMileageStartEnd(ref table, iVehID, sWorkStart, sWorkEnd, iCmdID);
                }
            }
            else if (iCount >= 1)
            {
                sWorkStart = dtStart.ToString("yyyy-MM-dd HH:mm:ss");
                if (bWorkTime)
                {
                    if (dtWorkStart.Hour > dtStart.Hour)
                    {
                        sWorkStart = dtStart.ToString("yyyy-MM-dd ") + dtWorkStart.ToString("HH:mm:ss");
                    }
                    else if (dtWorkStart.Hour == dtStart.Hour)
                    {
                        if (dtWorkStart.Minute > dtStart.Minute)
                        {
                            sWorkStart = dtStart.ToString("yyyy-MM-dd ") + dtWorkStart.ToString("HH:mm:ss");
                        }
                        else if (dtWorkStart.Minute == dtStart.Minute)
                        {
                            if (dtWorkStart.Second > dtStart.Second)
                            {
                                sWorkStart = dtStart.ToString("yyyy-MM-dd ") + dtWorkStart.ToString("HH:mm:ss");
                            }
                        }
                    }
                }
                if (!CheckHolidayFilter(DateTime.Parse(sWorkStart), bSat, bSunday, drsHoliday))
                {
                    QueryMileageStartEnd(ref table, iVehID, sWorkStart, dtStart.ToString("yyyy-MM-dd ") + dtWorkEnd.ToString("HH:mm:ss"), iCmdID);
                }
                for (i = 1; i < iCount; i++)
                {
                    midTime = dtStart.AddDays(i);
                    if (!CheckHolidayFilter(DateTime.Parse(midTime.ToString("yyyy-MM-dd ") + dtWorkStart.ToString("HH:mm:ss")), bSat, bSunday, drsHoliday))
                    {
                        QueryMileageStartEnd(ref table, iVehID, midTime.ToString("yyyy-MM-dd ") + dtWorkStart.ToString("HH:mm:ss"), midTime.ToString("yyyy-MM-dd ") + dtWorkEnd.ToString("HH:mm:ss"), iCmdID);
                    }
                }
                if (dtEnd.Hour > dtWorkStart.Hour || (dtEnd.Hour == dtWorkStart.Hour && dtEnd.Minute > dtWorkStart.Minute) || (dtEnd.Hour == dtWorkStart.Hour && dtEnd.Minute == dtWorkStart.Minute && dtEnd.Second > dtWorkStart.Second))
                {
                    sWorkEnd = dtEnd.ToString("yyyy-MM-dd HH:mm:ss");
                    if (bWorkTime)
                    {
                        if (dtEnd.Hour > dtWorkEnd.Hour)
                        {
                            sWorkEnd = dtEnd.ToString("yyyy-MM-dd ") + dtWorkEnd.ToString("HH:mm:ss");
                        }
                        else if (dtEnd.Hour == dtWorkEnd.Hour)
                        {
                            if (dtEnd.Minute > dtWorkEnd.Minute)
                            {
                                sWorkEnd = dtEnd.ToString("yyyy-MM-dd ") + dtWorkEnd.ToString("HH:mm:ss");
                            }
                            else if (dtEnd.Minute == dtWorkEnd.Minute)
                            {
                                if (dtEnd.Second > dtWorkEnd.Second)
                                {
                                    sWorkEnd = dtEnd.ToString("yyyy-MM-dd ") + dtWorkEnd.ToString("HH:mm:ss");
                                }
                            }
                        }
                    }
                    if (!CheckHolidayFilter(DateTime.Parse(dtEnd.ToString("yyyy-MM-dd ") + dtWorkStart.ToString("HH:mm:ss")), bSat, bSunday, drsHoliday))
                    {
                        QueryMileageStartEnd(ref table, iVehID, dtEnd.ToString("yyyy-MM-dd ") + dtWorkStart.ToString("HH:mm:ss"), sWorkEnd, iCmdID);
                    }
                }
            }
        }

        if (table.Rows.Count > 0 && iDataType != 4)
        {
            pFirst = true;

            if (table.Rows.Count > 1)
            {
                pLast = true;
                System.Data.DataTable datatable = new System.Data.DataTable();
                datatable = table.Copy();
                datatable.Rows.RemoveAt(0);
                pDtSet.Tables.Add(datatable);
                for (i = table.Rows.Count - 1; i >= 1; i--)
                {
                    table.Rows.RemoveAt(i);
                }
            }
        }
        //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''        
        dMileSetValue = 0;
        if (iDataType != 4)
        {
            System.Data.DataSet ds = BllSql.RunSqlSelect("select MileValue from RunMileSet where VehID=" + iVehID.ToString());
            if (ds != null && ds.Tables[0].Rows.Count > 0)
            {
                dMileSetValue = double.Parse(ds.Tables[0].Rows[0][0].ToString());
            }
        }
        System.Collections.Generic.List<Models.CMile> lstReturn = new System.Collections.Generic.List<Models.CMile>();
        switch (iDataType)
        {
            case 0:
                lstReturn = MileResposeByDay(pFirst, pLast, table, pDtSet, iDataType, dMileSetValue);
                break;
            case 1:
                lstReturn = MileResponseByWeek(pFirst, pLast, table, pDtSet, iDataType, dMileSetValue);
                break;
            case 2:
                return MileResponseByMonth(pFirst, pLast, table, pDtSet, iDataType, dMileSetValue);
            case 3:
                return MileResponseByQuarter(pFirst, pLast, table, pDtSet, iDataType, dMileSetValue);
            //case 4:
            //    return MileResponseByUser(table);
            default:
                lstReturn = MileResposeByDay(pFirst, pLast, table, pDtSet, iDataType, dMileSetValue);
                break;
        }
        return lstReturn;
    }

    #region 返回的东西
    private System.Collections.Generic.List<Models.CMile> MileResposeByDay(bool pFirst, bool pLast, System.Data.DataTable table, System.Data.DataSet pDtSet, int iDataType, double dCheckValue)
    {
        int pRowCnt = 0;
        int pDtRowCnt = 0;
        if (pDtSet != null)
        {
            if (pDtSet.Tables.Count > 0)
            {
                pDtRowCnt = pDtSet.Tables[0].Rows.Count;
            }
        }
        pRowCnt = pDtRowCnt + table.Rows.Count;
        int iVehID;
        if (pRowCnt == 0)
        {
            return new System.Collections.Generic.List<Models.CMile>();
        }
        else
        {
            List<CMile> lstMile = new List<CMile>();
            CMile temp;
            DataRow thisrow;
            string iStartMile;
            string iEndMile;
            int iTotalMile;
            string sStartTime;
            string sEndTime;
            if (table.Rows.Count > 0 && pFirst)
            {
                thisrow = table.Rows[0];
                iVehID = Convert.ToInt32(thisrow["VehId"]);
                iStartMile = thisrow["StartMileage"].ToString();
                iEndMile = thisrow["EndMileage"].ToString();
                iTotalMile = (int)(Convert.ToInt32(thisrow["TotalMileage"]) + dCheckValue * (Convert.ToInt32(thisrow["TotalMileage"]) / 100));
                sStartTime = thisrow["StartTime"].ToString();
                sEndTime = thisrow["EndTime"].ToString();
                temp = new CMile();
                temp.Cph = "";
                temp.EndMile = iEndMile;
                temp.EndTime = sEndTime;
                temp.StartMile = iStartMile;
                temp.StartTime = sStartTime;
                temp.TotalMile = iTotalMile;
                temp.VehID = iVehID;
                lstMile.Add(temp);
            }


            if (pFirst)
            {
                int pEachRow;
                for (pEachRow = 0; pEachRow < pDtRowCnt; pEachRow++)
                {
                    thisrow = pDtSet.Tables[0].Rows[pEachRow];
                    iVehID = Convert.ToInt32(thisrow["VehID"]);
                    iStartMile = thisrow["StartMileage"].ToString();
                    iEndMile = thisrow["EndMileage"].ToString();
                    iTotalMile = (int)(Convert.ToInt32(thisrow["TotalMileage"]) + dCheckValue * (Convert.ToInt32(thisrow["TotalMileage"]) / 100));
                    sStartTime = thisrow["StartTime"].ToString();
                    sEndTime = thisrow["EndTime"].ToString();
                    temp = new CMile();
                    temp.Cph = "";
                    temp.EndMile = iEndMile;//+1
                    temp.EndTime = sEndTime;
                    temp.StartMile = iStartMile;
                    temp.StartTime = sStartTime;
                    temp.TotalMile = iTotalMile;
                    temp.VehID = iVehID;
                    lstMile.Add(temp);
                }
            }
            else
            {
                int pEachRow;
                for (pEachRow = 0; pEachRow < pDtRowCnt; pEachRow++)
                {
                    thisrow = pDtSet.Tables[0].Rows[pEachRow];
                    iVehID = Convert.ToInt32(thisrow["VehID"]);
                    iStartMile = thisrow["StartMileage"].ToString();
                    iEndMile = thisrow["EndMileage"].ToString();
                    iTotalMile = (int)(Convert.ToInt32(thisrow["TotalMileage"]) + dCheckValue * (Convert.ToInt32(thisrow["TotalMileage"]) / 100));
                    sStartTime = thisrow["StartTime"].ToString();
                    sEndTime = thisrow["EndTime"].ToString();
                    temp = new CMile();
                    temp.Cph = "";
                    temp.EndMile = iEndMile;
                    temp.EndTime = sEndTime;
                    temp.StartMile = iStartMile;
                    temp.StartTime = sStartTime;
                    temp.TotalMile = iTotalMile;
                    temp.VehID = iVehID;
                    lstMile.Add(temp);
                }
            }

            if (pFirst)
            {
                if (table.Rows.Count > 1)
                {
                    thisrow = table.Rows[1];
                    iVehID = Convert.ToInt32(thisrow["VehId"]);
                    iStartMile = thisrow["StartMileage"].ToString();
                    iEndMile = thisrow["EndMileage"].ToString();
                    iTotalMile = (int)(Convert.ToInt32(thisrow["TotalMileage"]) + dCheckValue * (Convert.ToInt32(thisrow["TotalMileage"]) / 100));
                    sStartTime = thisrow["StartTime"].ToString();
                    sEndTime = thisrow["EndTime"].ToString();
                    temp = new CMile();//-1
                    temp.Cph = "";
                    temp.EndMile = iEndMile;
                    temp.EndTime = sEndTime;
                    temp.StartMile = iStartMile;
                    temp.StartTime = sStartTime;
                    temp.TotalMile = iTotalMile;
                    temp.VehID = iVehID;
                    lstMile.Add(temp);
                }
            }
            else
            {
                if (pLast)
                {
                    if (table.Rows.Count > 0)
                    {
                        thisrow = table.Rows[0];
                        iVehID = Convert.ToInt32(thisrow["VehId"]);
                        iStartMile = thisrow["StartMileage"].ToString();
                        iEndMile = thisrow["EndMileage"].ToString();
                        iTotalMile = (int)(Convert.ToInt32(thisrow["TotalMileage"]) + dCheckValue * (Convert.ToInt32(thisrow["TotalMileage"]) / 100));
                        sStartTime = thisrow["StartTime"].ToString();
                        sEndTime = thisrow["EndTime"].ToString();
                        temp = new CMile();//-1
                        temp.Cph = "";
                        temp.EndMile = iEndMile;
                        temp.EndTime = sEndTime;
                        temp.StartMile = iStartMile;
                        temp.StartTime = sStartTime;
                        temp.TotalMile = iTotalMile;
                        temp.VehID = iVehID;
                        lstMile.Add(temp);
                    }
                }
            }
            return lstMile;
        }
    }

    public bool CheckHolidayFilter(DateTime dt, bool bSat, bool bSun, DataRowCollection drsHoliday)
    {
        //放假返回True
        try
        {
            string sWorkDay = "0000";
            if (drsHoliday != null)
            {
                string sThisDay = dt.Month.ToString() + "-" + dt.Day.ToString();
                foreach (DataRow dr in drsHoliday)
                {
                    if (dr["year"].ToString() == dt.Year.ToString())
                    {
                        string sHoliday = dr["days"].ToString();//放假
                        sWorkDay = dr["workdays"].ToString();//补班
                        if (sHoliday.IndexOf(sThisDay) == -1)//不是放假
                        {
                            if (sWorkDay.IndexOf(sThisDay) == -1)
                            {

                            }
                            else
                            {
                                return false; 
                            }
                        }
                        else
                        {
                            return true;
                        }
                        break;
                    }
                }
            }
            if (bSat) //不显示星期六
            {
                if (dt.DayOfWeek == DayOfWeek.Saturday)
                {
                    return true; 
                }
            }
            if (bSun)
            {
                if (dt.DayOfWeek == DayOfWeek.Sunday)
                {
                    return true; 
                } 
            }
            
            return false;
        }
        catch 
        {
            return false;
        }
    }

    private System.Collections.Generic.List<Models.CMile> MileResponseByWeek(bool pFirst, bool pLast, System.Data.DataTable table, System.Data.DataSet pDtSet, int iDataType, double dCheckValue)
    {
        int pRowCnt;
        int pDtRowCnt = 0;
        if (pDtSet != null)
        {
            if (pDtSet.Tables.Count > 0)
            {
                pDtRowCnt = pDtSet.Tables[0].Rows.Count;
            }
        }
        bool pFirstAdd;
        bool pLastAdd;
        List<CMile> mileReturn = new List<CMile>();
        if (table.Rows.Count > 0)
        {
            DataRow thisrow;
            thisrow = table.Rows[0];
            CMile temp = new CMile();
            temp.VehID = Convert.ToInt32(thisrow["VehId"]);
            temp.StartMile = thisrow["StartMileage"].ToString();
            temp.EndMile = thisrow["EndMileage"].ToString();
            temp.TotalMile = (int)(Convert.ToInt32(thisrow["TotalMileage"]) + dCheckValue * (Convert.ToInt32(thisrow["TotalMileage"]) / 100));
            temp.StartTime = thisrow["StartTime"].ToString();
            temp.EndTime = thisrow["EndTime"].ToString();
            mileReturn.Add(temp);
            int pEachRow;
            int pMileObjRow = 0;
            for (pEachRow = 0; pEachRow < pDtRowCnt; pEachRow++)
            {
                thisrow = pDtSet.Tables[0].Rows[pEachRow];
                DateTime sTableStartTime = Convert.ToDateTime(mileReturn[pMileObjRow].StartTime);
                DateTime spDtSetStartTime = Convert.ToDateTime(thisrow["StartTime"]);
                if ((sTableStartTime.Year == spDtSetStartTime.Year) && IsInSameWeek(sTableStartTime, spDtSetStartTime))
                {
                    //跟第一条数据求合
                    mileReturn[pMileObjRow].EndMile = thisrow["EndMileage"].ToString();
                    mileReturn[pMileObjRow].EndTime = thisrow["EndTime"].ToString();
                    mileReturn[pMileObjRow].TotalMile = (int)(Convert.ToInt32(thisrow["TotalMileage"]) + dCheckValue * (Convert.ToInt32(thisrow["TotalMileage"]) / 100) + mileReturn[pMileObjRow].TotalMile);
                }
                else
                {
                    //不需求合，记录数加1
                    pMileObjRow = pMileObjRow + 1;
                    temp = new CMile();
                    temp.VehID = Convert.ToInt32(thisrow["VehId"]);
                    temp.StartMile = thisrow["StartMileage"].ToString();
                    temp.EndMile = thisrow["EndMileage"].ToString();
                    temp.TotalMile = (int)((Convert.ToInt32(thisrow["TotalMileage"]) + dCheckValue * Convert.ToInt32(thisrow["TotalMileage"]) / 100));
                    temp.StartTime = thisrow["StartTime"].ToString();
                    temp.EndTime = thisrow["EndTime"].ToString();
                    mileReturn.Add(temp);
                }
            }
            return mileReturn;
        }
        else
        {
            return mileReturn;
        }
    }

    private System.Collections.Generic.List<Models.CMile> MileResponseByMonth(bool pFirst, bool pLast, System.Data.DataTable table, System.Data.DataSet pDtSet, int iDataType, double dCheckValue)
    {
        int pRowCnt;
        int pDtRowCnt = 0;
        if (pDtSet != null)
        {
            if (pDtSet.Tables.Count > 0)
            {
                pDtRowCnt = pDtSet.Tables[0].Rows.Count;
            }
        }
        bool pFirstAdd;
        bool pLastAdd;
        List<CMile> mileReturn = new List<CMile>();
        if (table.Rows.Count > 0)
        {
            DataRow thisrow;
            thisrow = table.Rows[0];
            CMile temp = new CMile();
            temp.VehID = Convert.ToInt32(thisrow["VehId"]);
            temp.StartMile = thisrow["StartMileage"].ToString();
            temp.EndMile = thisrow["EndMileage"].ToString();
            temp.TotalMile = (int)(Convert.ToInt32(thisrow["TotalMileage"]) + dCheckValue * (Convert.ToInt32(thisrow["TotalMileage"]) / 100));
            temp.StartTime = thisrow["StartTime"].ToString();
            temp.EndTime = thisrow["EndTime"].ToString();
            mileReturn.Add(temp);
            int pEachRow;
            int pMileObjRow = 0;
            for (pEachRow = 0; pEachRow < pDtRowCnt; pEachRow++)
            {
                thisrow = pDtSet.Tables[0].Rows[pEachRow];
                DateTime sTableStartTime = Convert.ToDateTime(mileReturn[pMileObjRow].StartTime);
                DateTime spDtSetStartTime = Convert.ToDateTime(thisrow["StartTime"]);
                if ((sTableStartTime.Year == spDtSetStartTime.Year) && IsInSameMonth(sTableStartTime, spDtSetStartTime))
                {
                    //跟第一条数据求合
                    mileReturn[pMileObjRow].EndMile = thisrow["EndMileage"].ToString();
                    mileReturn[pMileObjRow].EndTime = thisrow["EndTime"].ToString();
                    mileReturn[pMileObjRow].TotalMile = (int)(Convert.ToInt32(thisrow["TotalMileage"]) + dCheckValue * (Convert.ToInt32(thisrow["TotalMileage"]) / 100) + mileReturn[pMileObjRow].TotalMile);
                }
                else
                {
                    //不需求合，记录数加1
                    pMileObjRow = pMileObjRow + 1;
                    temp = new CMile();
                    temp.VehID = Convert.ToInt32(thisrow["VehId"]);
                    temp.StartMile = thisrow["StartMileage"].ToString();
                    temp.EndMile = thisrow["EndMileage"].ToString();
                    temp.TotalMile = (int)((Convert.ToInt32(thisrow["TotalMileage"]) + dCheckValue * Convert.ToInt32(thisrow["TotalMileage"]) / 100));
                    temp.StartTime = thisrow["StartTime"].ToString();
                    temp.EndTime = thisrow["EndTime"].ToString();
                    mileReturn.Add(temp);
                }
            }
            return mileReturn;
        }
        else
        {
            return mileReturn;
        }
    }

    private System.Collections.Generic.List<Models.CMile> MileResponseByQuarter(bool pFirst, bool pLast, System.Data.DataTable table, System.Data.DataSet pDtSet, int iDataType, double dCheckValue)
    {
        int pRowCnt;
        int pDtRowCnt = 0;
        if (pDtSet != null)
        {
            if (pDtSet.Tables.Count > 0)
            {
                pDtRowCnt = pDtSet.Tables[0].Rows.Count;
            }
        }
        bool pFirstAdd;
        bool pLastAdd;
        List<CMile> mileReturn = new List<CMile>();
        if (table.Rows.Count > 0)
        {
            DataRow thisrow;
            thisrow = table.Rows[0];
            CMile temp = new CMile();
            temp.VehID = Convert.ToInt32(thisrow["VehId"]);
            temp.StartMile = thisrow["StartMileage"].ToString();
            temp.EndMile = thisrow["EndMileage"].ToString();
            temp.TotalMile = (int)(Convert.ToInt32(thisrow["TotalMileage"]) + dCheckValue * (Convert.ToInt32(thisrow["TotalMileage"]) / 100));
            temp.StartTime = thisrow["StartTime"].ToString();
            temp.EndTime = thisrow["EndTime"].ToString();
            mileReturn.Add(temp);
            int pEachRow;
            int pMileObjRow = 0;
            for (pEachRow = 0; pEachRow < pDtRowCnt; pEachRow++)
            {
                thisrow = pDtSet.Tables[0].Rows[pEachRow];
                DateTime sTableStartTime = Convert.ToDateTime(mileReturn[pMileObjRow].StartTime);
                DateTime spDtSetStartTime = Convert.ToDateTime(thisrow["StartTime"]);
                if ((sTableStartTime.Year == spDtSetStartTime.Year) && IsInSameQuarter(sTableStartTime, spDtSetStartTime))
                {
                    //跟第一条数据求合
                    mileReturn[pMileObjRow].EndMile = thisrow["EndMileage"].ToString();
                    mileReturn[pMileObjRow].EndTime = thisrow["EndTime"].ToString();
                    mileReturn[pMileObjRow].TotalMile = (int)(Convert.ToInt32(thisrow["TotalMileage"]) + dCheckValue * (Convert.ToInt32(thisrow["TotalMileage"]) / 100) + mileReturn[pMileObjRow].TotalMile);
                }
                else
                {
                    //不需求合，记录数加1
                    pMileObjRow = pMileObjRow + 1;
                    temp = new CMile();
                    temp.VehID = Convert.ToInt32(thisrow["VehId"]);
                    temp.StartMile = thisrow["StartMileage"].ToString();
                    temp.EndMile = thisrow["EndMileage"].ToString();
                    temp.TotalMile = (int)((Convert.ToInt32(thisrow["TotalMileage"]) + dCheckValue * Convert.ToInt32(thisrow["TotalMileage"]) / 100));
                    temp.StartTime = thisrow["StartTime"].ToString();
                    temp.EndTime = thisrow["EndTime"].ToString();
                    mileReturn.Add(temp);
                }
            }
            return mileReturn;
        }
        else
        {
            return mileReturn;
        }
    }

    #endregion

    private void QueryMileageStartEnd(ref System.Data.DataTable table, int iVehID, string strStartDate, string strEndDate, int iCmdID)
    {
        try
        {
            string strSQL = "";
            if (iCmdID == 43562)
            {
                strSQL = "exec GetTQCarMileOneDay @VehID,'@StartTime','@EndTime',@CmdID";
            }
            else
            {
                strSQL = "exec GetCarMileOneDay @VehID,'@StartTime','@EndTime',@CmdID";
            }
            strSQL = strSQL.Replace("@VehID", iVehID.ToString());
            strSQL = strSQL.Replace("@StartTime", strStartDate);
            strSQL = strSQL.Replace("@EndTime", strEndDate);
            strSQL = strSQL.Replace("@CmdID", iCmdID.ToString());

            DataSet ds = BllSql.RunSqlSelect(strSQL);
            if (ds == null)
            {
                AddDataToTable(ref table, iVehID, "0", "0", 0, strStartDate, strEndDate);
                return;
            }

            int iTableCount = ds.Tables[0].Rows.Count;
            if (iTableCount == 0)
            {
                AddDataToTable(ref table, iVehID, "0", "0", 0, strStartDate, strEndDate);
                return; 
            }
            for (int i = 0; i < iTableCount; i++)
            {
                string iStartMile;
                string iEndMile;
                int iTotalMile;
                string sStartTime;
                string sEndTime;

                iStartMile = ds.Tables[0].Rows[i][1].ToString();
                iEndMile = ds.Tables[0].Rows[i + 1][1].ToString();
                if (Convert.ToInt32(ds.Tables[0].Rows[i][3]) > 0)
                {
                    iTotalMile = Convert.ToInt32(ds.Tables[0].Rows[i + 1][1]) - Convert.ToInt32(ds.Tables[0].Rows[i][4]) + Convert.ToInt32(ds.Tables[0].Rows[i][3]) - Convert.ToInt32(ds.Tables[0].Rows[i][1]);
                }
                else
                {
                    iTotalMile = Convert.ToInt32(ds.Tables[0].Rows[i + 1][1]) - Convert.ToInt32(ds.Tables[0].Rows[i][1]);
                }
                sStartTime = ds.Tables[0].Rows[i][2].ToString();
                sEndTime = ds.Tables[0].Rows[i + 1][2].ToString();
                AddDataToTable(ref table, iVehID, iStartMile, iEndMile, iTotalMile, sStartTime, sEndTime);
                i = i + 2;
            }
        }
        catch (Exception ex)
        {

        }
    }

    private void AddDataToTable(ref System.Data.DataTable table, int iVehID, string iStartMile, string iEndMile, int iTotalMile, string sStartTime, string sEndTime)
    {
        DataRow thisrow = table.NewRow();
        thisrow["VehId"] = iVehID;
        thisrow["StartMileage"] = iStartMile;
        thisrow["EndMileage"] = iEndMile;
        thisrow["TotalMileage"] = iTotalMile;
        thisrow["StartTime"] = sStartTime;
        thisrow["EndTime"] = sEndTime;
        table.Rows.Add(thisrow);
    }

    private void AddTableCol(ref System.Data.DataTable table)
    {
        DataColumn Col;
        Col = table.Columns.Add("VehId", typeof(System.Int32));
        Col = table.Columns.Add("StartMileage", typeof(System.String));
        Col = table.Columns.Add("EndMileage", typeof(System.String));
        Col = table.Columns.Add("TotalMileage", typeof(System.Int64));
        Col = table.Columns.Add("StartTime", typeof(System.String));
        Col = table.Columns.Add("EndTime", typeof(System.String));
    }

    private string AngleToString(int iAngle)
    {
        try
        {
            switch (iAngle / 90)
            {
                case 0:
                    if ((iAngle % 90) <= 45)
                        if ((iAngle % 90) == 0)
                            return "正北方";
                        else
                            return "北偏东" + (iAngle % 90).ToString() + "度";
                    else
                        return "东偏北" + (90 - (iAngle % 90)).ToString() + "度";

                case 1:
                    if ((iAngle % 90) <= 45)
                        if ((iAngle % 90) == 0)
                            return "正东方";
                        else
                            return "东偏南" + (iAngle % 90).ToString() + "度";
                    else
                        return "南偏东" + (90 - (iAngle % 90)).ToString() + "度";


                case 2:
                    if ((iAngle % 90) <= 45)
                        if ((iAngle % 90) == 0)
                            return "正南方";
                        else
                            return "南偏西" + (iAngle % 90).ToString() + "度";
                    else
                        return "西偏南" + (90 - (iAngle % 90)).ToString() + "度";


                case 3:
                    if ((iAngle % 90) <= 45)
                        if ((iAngle % 90) == 0)
                            return "正西方";
                        else
                            return "西偏北" + (iAngle % 90).ToString() + "度";
                    else
                        return "北偏西" + (90 - (iAngle % 90)).ToString() + "度";

                default:
                    return "";
            }
        }
        catch (Exception Ex)
        {
            return iAngle.ToString();
        }
    }

    /// <summary>   
    /// 判断两个日期是否在同一周   
    /// </summary>   
    /// <param name="dtmS">开始日期</param>   
    /// <param name="dtmE">结束日期</param>  
    /// <returns></returns>   
    private bool IsInSameWeek(DateTime dtmS, DateTime dtmE)
    {
        TimeSpan ts = dtmE - dtmS;
        double dbl = ts.TotalDays;
        int intDow = Convert.ToInt32(dtmE.DayOfWeek);
        if (intDow == 0) intDow = 7;
        if (dbl >= 7 || dbl >= intDow) return false;
        else return true;
    }

    //同一月
    private bool IsInSameMonth(DateTime dtmS, DateTime dtmE)
    {
        if (dtmS.Year == dtmE.Year && dtmS.Month == dtmE.Month)
        {
            return true;
        }
        return false;
    }

    //同一季度
    private bool IsInSameQuarter(DateTime dtmS, DateTime dtmE)
    {
        if (dtmS.Year == dtmE.Year)
        {
            if (dtmS.Month > 0 && dtmS.Month <= 3)
            {
                if (dtmE.Month > 0 && dtmE.Month <= 3)
                {
                    return true;
                }
            }
            else if (dtmS.Month > 3 && dtmS.Month <= 6)
            {
                if (dtmE.Month > 3 && dtmE.Month <= 6)
                {
                    return true;
                }
            }
            else if (dtmS.Month > 6 && dtmS.Month <= 9)
            {
                if (dtmE.Month > 6 && dtmE.Month <= 9)
                {
                    return true;
                }
            }
            else if (dtmS.Month > 9 && dtmS.Month <= 12)
            {
                if (dtmE.Month > 9 && dtmE.Month <= 12)
                {
                    return true;
                }
            }
            return true;
        }
        return false;
    }

    /// <summary>  
    /// 某日期是本月的第几周  
    /// </summary>  
    /// <param name="dtSel"></param>  
    /// <param name="sundayStart"></param>  
    /// <returns></returns>  
    private int WeekOfMonth(DateTime dtSel, bool sundayStart)
    {
        //如果要判断的日期为1号，则肯定是第一周了   
        if (dtSel.Day == 1) return 1;
        else
        {
            //得到本月第一天   
            DateTime dtStart = new DateTime(dtSel.Year, dtSel.Month, 1);
            //得到本月第一天是周几   
            int dayofweek = (int)dtStart.DayOfWeek;
            //如果不是以周日开始，需要重新计算一下dayofweek，详细风DayOfWeek枚举的定义   
            if (!sundayStart)
            {
                dayofweek = dayofweek - 1;
                if (dayofweek < 0) dayofweek = 7;
            }
            //得到本月的第一周一共有几天   
            int startWeekDays = 7 - dayofweek;
            //如果要判断的日期在第一周范围内，返回1   
            if (dtSel.Day <= startWeekDays) return 1;
            else
            {
                int aday = dtSel.Day + 7 - startWeekDays;
                return aday / 7 + (aday % 7 > 0 ? 1 : 0);
            }
        }
    }

    private struct MileReportEx
    {
        public int VehID;
        public double StartMileage;
        public double EndMileage;
        public double TotalMileage;
        public string StartDate;
        public string EndDate;
    }
    
    public bool IsReusable {
        get {
            return false;
        }
    }

}