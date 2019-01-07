<%@ WebHandler Language="C#" Class="VehicleUsage" %>

using System;
using System.Web;

public class VehicleUsage : IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        try
        {
            //System.Globalization.CultureInfo s = new System.Globalization.CultureInfo("en - US");//zh-CN,en-US 是设置语言类型
            //System.Threading.Thread.CurrentThread.CurrentUICulture = s;
            string sUserName = context.Request["username"];
            string sPwd = context.Request["Pwd"];
            string sTime = context.Request["time"];

            if (string.IsNullOrEmpty(sUserName) || string.IsNullOrEmpty(sPwd) || string.IsNullOrEmpty(sTime))
            {
                context.Response.Write("{\"result\":\"false\",\"err\":\"4001\"}");
            }
            else
            {
                if (!SqlFilter.Filter.ProcessFilter(ref sUserName) || !SqlFilter.Filter.ProcessFilter(ref sPwd) || !SqlFilter.Filter.ProcessFilter(ref sTime))
                {
                    context.Response.Write("{\"result\":\"false\",\"err\":\"4002\"}");
                }
                else
                {
                    int iUserID = -1;
                    string sErr = "";
                    if (!BllCommon.IsUserLogin(sUserName, sPwd, out iUserID, out sErr))
                    {
                        if (sErr.Length > 0)
                        {
                            context.Response.Write("{\"result\":\"false\",\"err\":\"" + sErr + "\"}");
                        }
                        else
                        {
                            context.Response.Write("{\"result\":\"false\",\"err\":\"4007\"}");
                        }
                    }
                    else
                    {
                        //这里开始获取车辆数据
                        string arrGroup = "-1";
                        System.Collections.Generic.List<Models.CVehUsage> lstVeh = new System.Collections.Generic.List<Models.CVehUsage>();
                        DateTime dt = DateTime.Parse(sTime).AddDays(-6);
                        for (int i = 0; i < 6; i++)
                        {
                            int iCount = BllVehicle.GetVehicleUsage(iUserID, "Bee" + dt.ToString("yyyyMMdd"), ref arrGroup);
                            if (iCount < 0)
                            {
                                iCount = 0;
                            }
                            Models.CVehUsage model = new Models.CVehUsage();
                            model.Date = dt.ToString("yyyy-MM-dd");
                            model.Value = iCount;
                            lstVeh.Add(model);
                            dt = dt.AddDays(1);
                        }                       
                        
                        string sJson = JsonHelper.SerializeObject(lstVeh);
                        context.Response.Write("{\"result\":\"true\",\"err\":\"\",\"data\":" + sJson + "}");
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