<%@ WebHandler Language="C#" Class="ServerTime" %>

using System;
using System.Web;

public class ServerTime : IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        try
        {
            //System.Globalization.CultureInfo s = new System.Globalization.CultureInfo("en - US");//zh-CN,en-US 是设置语言类型
            //System.Threading.Thread.CurrentThread.CurrentUICulture = s;
            string sUserName = context.Request["username"];
            string sPwd = context.Request["Pwd"];
            int iDay = Convert.ToInt32(context.Request["Day"]);
            if (string.IsNullOrEmpty(sUserName) || string.IsNullOrEmpty(sPwd))
            {
                context.Response.Write("{\"result\":\"false\",\"err\":\"4001\"}");
            }
            else
            {
                if (!SqlFilter.Filter.ProcessFilter(ref sUserName) || !SqlFilter.Filter.ProcessFilter(ref sPwd))
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
                        System.Collections.Generic.List<Models.CServerTime> lstVeh = new System.Collections.Generic.List<Models.CServerTime>();
                        DateTime dtNow = DateTime.Now.AddDays(iDay + 1);
                        System.Data.DataSet ds = BllVehicle.GetServerTime(iUserID, dtNow);
                        if (ds == null || ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0)
                        {
                            string sJson = JsonHelper.SerializeObject(lstVeh);
                            context.Response.Write("{\"result\":\"true\",\"err\":\"\",\"data\":" + sJson + "}");
                            return;
                        }
                        else
                        {
                            foreach (System.Data.DataRow dr in ds.Tables[0].Rows)
                            {
                                Models.CServerTime model = new Models.CServerTime();
                                model.timebegin = dr["ServerBeginTime"].ToString();
                                model.timeend = dr["ServerEndTime"].ToString();
                                model.VehID = Convert.ToInt32(dr["Id"]);
                                model.daysur = ((int)DateTime.Parse(model.timeend).Subtract(DateTime.Now).TotalDays).ToString();
                                if (int.Parse(model.daysur) <= iDay)
                                {
                                    lstVeh.Add(model);
                                }
                                if (int.Parse(model.daysur) < 0)
                                {
                                    model.daysur = "已过服务时间";
                                }
                            }
                            string sJson = JsonHelper.SerializeObject(lstVeh);
                            context.Response.Write("{\"result\":\"true\",\"err\":\"\",\"data\":" + sJson + "}");
                        }
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