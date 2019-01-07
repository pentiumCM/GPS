<%@ WebHandler Language="C#" Class="ReportPhoto" %>

using System;
using System.Web;

public class ReportPhoto : IHttpHandler
{
    
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
        string sTableName = "H5ImgTable";
        string sSql = "SELECT imgID, getTime, src, VehID FROM " + sTableName + " where (VehID=@VehID) And ([getTime] >= @StartDate and [getTime] <= @EndDate) order by VehID,[getTime]";
        sSql = "use Bee" + DateTime.Parse(sBeginTime).ToString("yyyyMMdd") + ";   " + sSql;
        
        System.Collections.Generic.List<Models.CSqlParameters> lstPar = new System.Collections.Generic.List<Models.CSqlParameters>();
        Models.CSqlParameters par = new Models.CSqlParameters();
        par.iLen = sVehID.Length;
        par.pDirection = System.Data.ParameterDirection.Input;
        par.sName = "VehID";
        par.sqlDbType = System.Data.SqlDbType.Int;
        par.sValue = sVehID.Substring(1);
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
            System.Collections.Generic.List<Models.CPhoto> lstReturn = new System.Collections.Generic.List<Models.CPhoto>();
            string ssReturn = JsonHelper.SerializeObject(lstReturn);
            context.Response.Write("{\"result\":\"false\",\"data\":" + ssReturn + "}");
            return;
        }
        System.Data.DataRowCollection drs = dsHistory.Tables[0].Rows;
        System.Collections.Generic.List<Models.CPhoto> lstHistory = new System.Collections.Generic.List<Models.CPhoto>();
        Models.CPhoto temp = new Models.CPhoto();
        foreach (System.Data.DataRow dr in drs)
        {
            temp = new Models.CPhoto();
            temp.getTime = dr["getTime"].ToString();
            temp.imgID = sBeginTime + dr["imgID"].ToString();
            temp.src = "../../" + dr["src"].ToString();
            temp.VehID = Convert.ToInt32(dr["VehID"]);           
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