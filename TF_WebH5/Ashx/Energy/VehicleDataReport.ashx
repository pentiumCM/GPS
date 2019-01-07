<%@ WebHandler Language="C#" Class="VehicleDataReport" %>

using System;
using System.Web;

public class VehicleDataReport : IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string sVehID = context.Request["VehID"];
        string sBeginTime = context.Request["BeginTime"];
        string sEndTime = context.Request["EndTime"];
        string sUserType = context.Request["UseType"];
        string sUserName = context.Request["UserName"];
        string sPwd = context.Request["Pwd"];
        string sBatch = System.Configuration.ConfigurationManager.AppSettings["Batch"];
        int iUserID = -1;

        if (string.IsNullOrEmpty(sUserName) || string.IsNullOrEmpty(sPwd) || string.IsNullOrEmpty(sVehID) || string.IsNullOrEmpty(sBeginTime) || string.IsNullOrEmpty(sEndTime) || string.IsNullOrEmpty(sUserType))
        {
            context.Response.Write("参数错误！");
            return;
        }
        if (!SqlFilter.Filter.ProcessFilter(ref sUserName) || !SqlFilter.Filter.ProcessFilter(ref sPwd) || !SqlFilter.Filter.ProcessFilter(ref sVehID) || !SqlFilter.Filter.ProcessFilter(ref sBeginTime) || !SqlFilter.Filter.ProcessFilter(ref sEndTime))
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
        System.Collections.Generic.List<Models.CVehicleData> lstHistory = new System.Collections.Generic.List<Models.CVehicleData>();
        foreach (string sThisVeh in lstVehs)
        {
            string sSql = "SELECT [VehID],[Time],[VehSate],[RunModel],[ChargeState],[Speed],[Mile],[Voltage],[Current],[SOC],[DCDC],[Drive],[Braking],[Gear],[Resistor],[AcceleratorPedalStrokeMile],[AcceleratorPedalStrokeState] from Energy where (VehID=@VehID) And ([time] >= @StartDate and [time] <= @EndDate) order by [Time]";
            sSql = "use Bee" + DateTime.Parse(sBeginTime).ToString("yyyyMMdd") + ";   " + sSql;

            if (!sBatch.Equals("1"))
            {
                
            }
            else
            {
                string sLstVeh = "0";
                foreach (string sThisTemp in lstVehs)
                {
                    sLstVeh += "," + sThisTemp; 
                }
                sSql = "SELECT [VehID],[Time],[VehSate],[RunModel],[ChargeState],[Speed],[Mile],[Voltage],[Current],[SOC],[DCDC],[Drive],[Braking],[Gear],[Resistor],[AcceleratorPedalStrokeMile],[AcceleratorPedalStrokeState] from Energy where VehID in (" + sLstVeh + ") And ([time] >= @StartDate and [time] <= @EndDate) order by VehID,[Time]";
                sSql = "use Bee" + DateTime.Parse(sBeginTime).ToString("yyyyMMdd") + ";   " + sSql;
            }
            System.Collections.Generic.List<Models.CSqlParameters> lstPar = new System.Collections.Generic.List<Models.CSqlParameters>();
            Models.CSqlParameters par = new Models.CSqlParameters();
            par.iLen = sThisVeh.Length;
            par.pDirection = System.Data.ParameterDirection.Input;
            par.sName = "VehID";
            par.sqlDbType = System.Data.SqlDbType.Int;
            par.sValue = sThisVeh;
            if (!sBatch.Equals("1"))
            {
                lstPar.Add(par);
            }

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
                if (sBatch.Equals("1"))
                {
                    break;
                }
                else
                {
                    continue;
                }
                //context.Response.Write("{\"result\":\"false\",\"err\":\"" + sErr + "\"}");
                //return;
            }
            if (dsHistory == null || dsHistory.Tables.Count == 0 || dsHistory.Tables[0].Rows.Count == 0)
            {
                if (sBatch.Equals("1"))
                {
                    break;
                }
                else
                {
                    continue;
                }
                //System.Collections.Generic.List<Models.COverSpeed> lstReturn = new System.Collections.Generic.List<Models.COverSpeed>();
                //string ssReturn = JsonHelper.SerializeObject(lstReturn);
                //context.Response.Write("{\"result\":\"false\",\"data\":" + ssReturn + "}");
                //return;
            }
            System.Data.DataRowCollection drs = dsHistory.Tables[0].Rows;
            Models.CVehicleData temp = new Models.CVehicleData();
            for (int i = 0; i < drs.Count; i++)
            {
                //[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]
                System.Data.DataRow dr = drs[i];
                temp = new Models.CVehicleData();
                temp.AcceleratorPedalStrokeMile = Convert.ToInt32(dr["AcceleratorPedalStrokeMile"]);
                temp.AcceleratorPedalStrokeState = Convert.ToInt32(dr["AcceleratorPedalStrokeState"]);
                temp.Braking = Convert.ToInt32(dr["Braking"]);
                temp.ChargeState = dr["ChargeState"].ToString();
                temp.Current = Convert.ToInt32(dr["Current"]);
                temp.DCDC = dr["DCDC"].ToString();
                temp.Drive = Convert.ToInt32(dr["Drive"]);
                temp.Gear = dr["Gear"].ToString();
                temp.Mile = Convert.ToInt64(dr["Mile"]);
                temp.Resistor = Convert.ToInt32(dr["Resistor"]);
                temp.RunModel = dr["RunModel"].ToString();
                temp.SOC = Convert.ToInt32(dr["SOC"]);
                temp.Speed = Convert.ToInt32(dr["Speed"]);
                temp.Time = dr["Time"].ToString();
                temp.id = Convert.ToInt32(dr["VehID"]);
                temp.VehState = dr["VehSate"].ToString();
                temp.Voltage = Convert.ToInt32(dr["Voltage"]);               
                lstHistory.Add(temp);
            }         
            if (sBatch.Equals("1"))
            {
                break; 
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