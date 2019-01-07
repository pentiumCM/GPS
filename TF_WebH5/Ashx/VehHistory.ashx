<%@ WebHandler Language="C#" Class="VehHistory" %>

using System;
using System.Web;

public class VehHistory : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string sVehID = context.Request["VehID"];
        string sBeginTime = context.Request["BeginTime"];
        string sEndTime = context.Request["EndTime"];
        string sUserType = context.Request["UseType"];
        string sBatch = System.Configuration.ConfigurationManager.AppSettings["Batch"];
        int iUserID = -1;

        if (string.IsNullOrEmpty(sVehID) || string.IsNullOrEmpty(sBeginTime) || string.IsNullOrEmpty(sEndTime) || string.IsNullOrEmpty(sUserType))
        {
            context.Response.Write("参数错误！");
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
        if (sVehID.StartsWith("V"))
        {
            sVehID = sVehID.Substring(1); 
        }
        if (!sBatch.Equals("1"))
        {
            sTableName = "Dyndata" + sVehID;
        }
        string sSql = "SELECT Longitude, Latitude, Angle, Velocity, Component, Locate,[Time] FROM " + sTableName + " where (VehID=@VehID) And ([time] >= @StartDate and [time] <= @EndDate) order by [time]";
        sSql = "use Bee" + DateTime.Parse(sBeginTime).ToString("yyyyMMdd") + ";   " + sSql;
        
        System.Collections.Generic.List<Models.CSqlParameters> lstPar = new System.Collections.Generic.List<Models.CSqlParameters>();
        Models.CSqlParameters par = new Models.CSqlParameters();
        par.iLen = sVehID.Length;
        par.pDirection = System.Data.ParameterDirection.Input;
        par.sName = "VehID";
        par.sqlDbType = System.Data.SqlDbType.Int;
        par.sValue = sVehID;
        lstPar.Add(par);

        par = new Models.CSqlParameters();
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
        System.Data.DataSet dsHistory = BllSql.RunSqlSelectParameters(false, sSql, lstPar, out sErr);
        if (sErr.Length > 0)
        {
            context.Response.Write("{\"result\":\"false\",\"err\":\"" + sErr + "\"}");
            return;
        }
        if (dsHistory == null || dsHistory.Tables.Count == 0 || dsHistory.Tables[0].Rows.Count == 0)
        {
            System.Collections.Generic.List<Models.CVehHistory> lstReturn = new System.Collections.Generic.List<Models.CVehHistory>();
            string ssReturn = JsonHelper.SerializeObject(lstReturn);
            context.Response.Write("{\"result\":\"false\",\"data\":" + ssReturn + "}");
            return;
        }
        System.Data.DataRowCollection drs = dsHistory.Tables[0].Rows;
        System.Collections.Generic.List<Models.CVehHistory> lstHistory = new System.Collections.Generic.List<Models.CVehHistory>();
        Models.CVehHistory temp = new Models.CVehHistory();
        foreach (System.Data.DataRow dr in drs)
        {
            temp = new Models.CVehHistory();
            temp.Angle = Convert.ToInt32(dr["Angle"]);
            temp.Component = dr["Component"].ToString();
            temp.Latitude = Convert.ToDouble(dr["Latitude"]);
            temp.Locate = Convert.ToInt32(dr["Locate"]);
            temp.Longitude = Convert.ToDouble(dr["Longitude"]);
            double x1 = temp.Longitude;
            double y1 = temp.Latitude;
            //double x2, y2;
            //BaiduMapCorrect.GetBaiduCorrectFromGps(x1, y1, out x2, out y2);
            temp.Longitude = x1;
            temp.Latitude = y1;
            temp.Time = dr["Time"].ToString();
            temp.Velocity = Convert.ToInt32(dr["Velocity"]);
            lstHistory.Add(temp);
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