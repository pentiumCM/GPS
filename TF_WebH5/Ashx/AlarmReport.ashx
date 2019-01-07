<%@ WebHandler Language="C#" Class="AlarmReport" %>

using System;
using System.Web;

public class AlarmReport : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string sVehID = context.Request["VehID"];
        string sBeginTime = context.Request["BeginTime"];
        string sEndTime = context.Request["EndTime"];
        string sUserType = context.Request["UseType"];
        string sAlarm = context.Request["sAlarm"];
        string sUserName = context.Request["UserName"];
        string sPwd = context.Request["Pwd"];
        string sBatch = System.Configuration.ConfigurationManager.AppSettings["Batch"];
        int iUserID = -1;

        if (string.IsNullOrEmpty(sUserName) || string.IsNullOrEmpty(sPwd) || string.IsNullOrEmpty(sVehID) || string.IsNullOrEmpty(sAlarm) || string.IsNullOrEmpty(sBeginTime) || string.IsNullOrEmpty(sEndTime) || string.IsNullOrEmpty(sUserType))
        {
            context.Response.Write("参数错误！");
            return;
        }
        if (!SqlFilter.Filter.ProcessFilter(ref sUserName) || !SqlFilter.Filter.ProcessFilter(ref sPwd) || !SqlFilter.Filter.ProcessFilter(ref sVehID) || !SqlFilter.Filter.ProcessFilter(ref sAlarm) || !SqlFilter.Filter.ProcessFilter(ref sBeginTime) || !SqlFilter.Filter.ProcessFilter(ref sEndTime))
        {
            context.Response.Write("{\"result\":\"false\",\"err\":\"4002\"}");
            return;
        }
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
        System.Collections.Generic.List<string> lstVehs = new System.Collections.Generic.List<string>();
        if (sVehID.StartsWith("V"))
        {
            sVehID = sVehID.Substring(1);
            lstVehs.Add(sVehID);
        }
        else
        {
            string sGroupID = sVehID.Substring(1);
            string sErrUser;
            System.Collections.Generic.List<Models.CSqlParameters> lstPar = new System.Collections.Generic.List<Models.CSqlParameters>();
            Models.CSqlParameters par = new Models.CSqlParameters();
            par.iLen = sGroupID.Length;
            par.pDirection = System.Data.ParameterDirection.Input;
            par.sName = "GroupID";
            par.sqlDbType = System.Data.SqlDbType.Int;
            par.sValue = sGroupID;
            lstPar.Add(par);

            par = new Models.CSqlParameters();
            par.iLen = sUserName.Length * 2;
            par.pDirection = System.Data.ParameterDirection.Input;
            par.sName = "UserName";
            par.sqlDbType = System.Data.SqlDbType.NVarChar;
            par.sValue = sUserName;
            lstPar.Add(par);

            par = new Models.CSqlParameters();
            par.iLen = sPwd.Length * 2;
            par.pDirection = System.Data.ParameterDirection.Input;
            par.sName = "Pwd";
            par.sqlDbType = System.Data.SqlDbType.NVarChar;
            par.sValue = sPwd;
            lstPar.Add(par);
            System.Data.DataSet ds = BllSql.RunSqlSelectProcedure(false, "GetAllVehIDFromGroup", lstPar, out sErrUser);
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
                lstVehs.Add(dr["ID"].ToString());
            }
        }
        System.Collections.Generic.List<Models.CAlarmReport> lstHistory = new System.Collections.Generic.List<Models.CAlarmReport>();
        string sID = "-1";
        foreach (string sThisVeh in lstVehs)
        {
            sID += "," + sThisVeh;
        }
        sTableName = "AlarmDataTable";
        string sSqlCmd = "select VehID,Time,Note,Longitude,Latitude,Velocity,Angle,'','' from " + sTableName + " where time <'" + sEndTime + "' and time>'" + sBeginTime + "' and vehid in (" + sID + ") ";
        sSqlCmd = "use Bee" + DateTime.Parse(sBeginTime).ToString("yyyyMMdd") + ";   " + sSqlCmd;
        string[] sAlarmType = sAlarm.Split(',');
        if (sAlarmType.Length > 0)
        {
            sSqlCmd = sSqlCmd + " and (";
            int iType;
            for (iType = 0; iType < sAlarmType.Length - 1; iType++)
            {
                if (sAlarmType[iType] == "劫警(应急按钮)")
                {
                    sSqlCmd = sSqlCmd + "  CHARINDEX('" + "紧急报警" + "',note,1)>0 or";
                    sSqlCmd = sSqlCmd + "  CHARINDEX('" + "劫警报警" + "',note,1)>0 or";
                    sSqlCmd = sSqlCmd + "  CHARINDEX('" + "应急报警" + "',note,1)>0 or";
                    sSqlCmd = sSqlCmd + "  CHARINDEX('" + "盗警" + "',note,1)>0 or";
                    sSqlCmd = sSqlCmd + "  CHARINDEX('" + "劫警" + "',note,1)>0  or";
                }
                else if (sAlarmType[iType] == "震动报警")
                {
                    sSqlCmd = sSqlCmd + "  CHARINDEX('" + "震动报警" + "',note,1)>0 or";
                    sSqlCmd = sSqlCmd + "  CHARINDEX('" + "振动报警" + "',note,1)>0 or";
                }
                else if (sAlarmType[iType] == "震动报警")
                {
                    sSqlCmd = sSqlCmd + "  CHARINDEX('" + "震动报警" + "',note,1)>0 or";
                    sSqlCmd = sSqlCmd + "  CHARINDEX('" + "振动报警" + "',note,1)>0 or";
                }
                else if (sAlarmType[iType] == "入界报警")
                {
                    sSqlCmd = sSqlCmd + "  CHARINDEX('" + "入界报警" + "',note,1)>0 or";
                    sSqlCmd = sSqlCmd + "  CHARINDEX('" + "入区域报警" + "',note,1)>0 or";
                    sSqlCmd = sSqlCmd + "  CHARINDEX('" + "驶入区域报警" + "',note,1)>0  or";
                }
                else if (sAlarmType[iType] == "越界报警")
                {
                    sSqlCmd = sSqlCmd + "  CHARINDEX('" + "越界报警" + "',note,1)>0 or";
                    sSqlCmd = sSqlCmd + "  CHARINDEX('" + "出区域报警" + "',note,1)>0 or";
                    sSqlCmd = sSqlCmd + "  CHARINDEX('" + "驶出区域报警" + "',note,1)>0  or";
                }
                else if (sAlarmType[iType] == "主电源掉电")
                {
                    sSqlCmd = sSqlCmd + "  CHARINDEX('" + "断电报警" + "',note,1)>0 or";
                    sSqlCmd = sSqlCmd + "  CHARINDEX('" + "主电源断电" + "',note,1)>0 or";
                    sSqlCmd = sSqlCmd + "  CHARINDEX('" + "主电源掉电" + "',note,1)>0 or";
                }
                else if (sAlarmType[iType] == "超时驾驶报警")
                {
                    sSqlCmd = sSqlCmd + "  CHARINDEX('" + "疲劳驾驶报警" + "',note,1)>0 or";
                    sSqlCmd = sSqlCmd + "  CHARINDEX('" + "超时驾驶报警" + "',note,1)>0 or";
                }
                else if (sAlarmType[iType] == "电池电压报警")
                {
                    sSqlCmd = sSqlCmd + "  CHARINDEX('" + "电池电压报警" + "',note,1)>0 or";
                    sSqlCmd = sSqlCmd + "  CHARINDEX('" + "主电源过高或过低" + "',note,1)>0 or";
                }
                else
                {
                    sSqlCmd = sSqlCmd + "  CHARINDEX('" + sAlarmType[iType] + "',note,1)>0 or";
                }
            }
            if (sAlarmType[iType] == "劫警(应急按钮)")
            {
                sSqlCmd = sSqlCmd + "  CHARINDEX('" + "紧急报警" + "',note,1)>0 or";
                sSqlCmd = sSqlCmd + "  CHARINDEX('" + "劫警报警" + "',note,1)>0 or";
                sSqlCmd = sSqlCmd + "  CHARINDEX('" + "应急报警" + "',note,1)>0 or";
                sSqlCmd = sSqlCmd + "  CHARINDEX('" + "盗警" + "',note,1)>0 or";
                sSqlCmd = sSqlCmd + "  CHARINDEX('" + "劫警" + "',note,1)>0  )";
            }
            else if (sAlarmType[iType] == "震动报警")
            {
                sSqlCmd = sSqlCmd + "  CHARINDEX('" + "震动报警" + "',note,1)>0 or";
                sSqlCmd = sSqlCmd + "  CHARINDEX('" + "振动报警" + "',note,1)>0 )";
            }
            else if (sAlarmType[iType] == "震动报警")
            {
                sSqlCmd = sSqlCmd + "  CHARINDEX('" + "震动报警" + "',note,1)>0 or";
                sSqlCmd = sSqlCmd + "  CHARINDEX('" + "振动报警" + "',note,1)>0 )";
            }
            else if (sAlarmType[iType] == "入界报警")
            {
                sSqlCmd = sSqlCmd + "  CHARINDEX('" + "入界报警" + "',note,1)>0 or";
                sSqlCmd = sSqlCmd + "  CHARINDEX('" + "入区域报警" + "',note,1)>0 or";
                sSqlCmd = sSqlCmd + "  CHARINDEX('" + "驶入区域报警" + "',note,1)>0  )";
            }
            else if (sAlarmType[iType] == "越界报警")
            {
                sSqlCmd = sSqlCmd + "  CHARINDEX('" + "越界报警" + "',note,1)>0 or";
                sSqlCmd = sSqlCmd + "  CHARINDEX('" + "出区域报警" + "',note,1)>0 or";
                sSqlCmd = sSqlCmd + "  CHARINDEX('" + "驶出区域报警" + "',note,1)>0  )";
            }
            else if (sAlarmType[iType] == "主电源掉电")
            {
                sSqlCmd = sSqlCmd + "  CHARINDEX('" + "断电报警" + "',note,1)>0 or";
                sSqlCmd = sSqlCmd + "  CHARINDEX('" + "主电源断电" + "',note,1)>0 or";
                sSqlCmd = sSqlCmd + "  CHARINDEX('" + "主电源掉电" + "',note,1)>0 )";
            }
            else if (sAlarmType[iType] == "超时驾驶报警")
            {
                sSqlCmd = sSqlCmd + "  CHARINDEX('" + "疲劳驾驶报警" + "',note,1)>0 or";
                sSqlCmd = sSqlCmd + "  CHARINDEX('" + "超时驾驶报警" + "',note,1)>0 )";
            }
            else
            {
                sSqlCmd = sSqlCmd + "  CHARINDEX('" + sAlarmType[iType] + "',note,1)>0 )";
            }
        }
        if (true)
        {
            System.Collections.Generic.List<Models.CSqlParameters> lstPar = new System.Collections.Generic.List<Models.CSqlParameters>();

            Models.CSqlParameters par = new Models.CSqlParameters();
            par.iLen = 8;
            par.pDirection = System.Data.ParameterDirection.Input;
            par.sName = "StartDate";
            par.sqlDbType = System.Data.SqlDbType.DateTime;
            par.sValue = DateTime.Parse(sBeginTime);
            lstPar.Add(par);

            par = new Models.CSqlParameters();
            par.iLen = 8;
            par.pDirection = System.Data.ParameterDirection.Input;
            par.sName = "EndDate";
            par.sqlDbType = System.Data.SqlDbType.DateTime;
            par.sValue = DateTime.Parse(sEndTime);
            lstPar.Add(par);
            string sErr;
            System.Data.DataSet dsHistory = BllSql.RunSqlSelectParameters(false, sSqlCmd, lstPar, out sErr);
            if (sErr.Length > 0)
            {
                context.Response.Write("{\"result\":\"false\",\"err\":\"" + sErr + "\"}");
                return;
            }
            if (dsHistory == null || dsHistory.Tables.Count == 0 || dsHistory.Tables[0].Rows.Count == 0)
            {
                System.Collections.Generic.List<Models.CAlarmReport> lstReturn = new System.Collections.Generic.List<Models.CAlarmReport>();
                string ssReturn = JsonHelper.SerializeObject(lstReturn);
                context.Response.Write("{\"result\":\"false\",\"data\":" + ssReturn + "}");
                return;
            }
            System.Data.DataRowCollection drs = dsHistory.Tables[0].Rows;
            Models.CAlarmReport temp = new Models.CAlarmReport();
            bool pStart = false;
            bool pEnd = false;
            string pStartTime = "";
            string pEndTime = "";
            int pVehID = -1;
            for (int i = 0; i < drs.Count; i++)
            {
                System.Data.DataRow dr = drs[i];
                temp = new Models.CAlarmReport();
                temp.time = dr["Time"].ToString();
                temp.id = int.Parse(dr["VehID"].ToString());
                string sNote = dr["Note"].ToString();
                string sReturnNote = "";//1劫警2超速3进围栏4出围栏
                if (sNote.IndexOf("劫警") > -1)
                {
                    sReturnNote = "1";
                }
                else
                {
                    sReturnNote = "0";
                }
                if (sNote.IndexOf("超速报警") > -1)
                {
                    sReturnNote += "1";
                }
                else 
                {
                    sReturnNote += "0";
                }
                if (sNote.IndexOf("进入多边形区域报警") > -1)
                {
                    sReturnNote += "1";
                }
                else
                {
                    sReturnNote += "0";
                }
                if (sNote.IndexOf("离开多边形区域报警") > -1)
                {
                    sReturnNote += "1";
                }
                else
                {
                    sReturnNote += "0";
                }
                if (sNote.IndexOf("进入行政区域报警") > -1)
                {
                    sReturnNote += "1";
                }
                else
                {
                    sReturnNote += "0";
                }
                if (sNote.IndexOf("出行政区域报警") > -1)
                {
                    sReturnNote += "1";
                }
                else
                {
                    sReturnNote += "0";
                }
                if (sNote.IndexOf("终端拆除") > -1)
                {
                    sReturnNote += "1";
                }
                else
                {
                    sReturnNote += "0";
                }
                temp.alarmtype = sReturnNote;// dr["Note"].ToString();
                temp.angle = Convert.ToInt32(dr["Angle"]);
                temp.speed = Convert.ToInt32(dr["Velocity"]);
                temp.Latitude = Convert.ToDouble(dr["Latitude"]);
                temp.Longitude = Convert.ToDouble(dr["Longitude"]);
                lstHistory.Add(temp);
            }
        }
        string ss = JsonHelper.SerializeObject(lstHistory);
        context.Response.Write("{\"result\":\"true\",\"data\":" + ss + "}");
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}