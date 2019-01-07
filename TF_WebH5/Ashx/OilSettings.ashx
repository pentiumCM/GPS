<%@ WebHandler Language="C#" Class="OilSettings" %>

using System;
using System.Web;

public class OilSettings : IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        try
        {
            //System.Globalization.CultureInfo s = new System.Globalization.CultureInfo("en - US");//zh-CN,en-US 是设置语言类型
            //System.Threading.Thread.CurrentThread.CurrentUICulture = s;
            string sUserName = context.Request["username"];
            string sPwd = context.Request["Pwd"];
            int iDotype = Convert.ToInt32(context.Request["DoType"]);
            //"StealOil":sStealOil,"IsPresent":sChkPresent,"Oils":sOil,"Vehs":sVehs,"Names":sName
            string sStealOil = context.Request["StealOil"];
            string sIsPresent = context.Request["IsPresent"];
            string sOils = context.Request["Oils"];
            string sVehs = context.Request["Vehs"];
            string sNames = context.Request["Names"];
            if (string.IsNullOrEmpty(sUserName) || string.IsNullOrEmpty(sPwd))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4001\"}");
            }
            else if (string.IsNullOrEmpty(sStealOil) || string.IsNullOrEmpty(sIsPresent) || string.IsNullOrEmpty(sOils) || string.IsNullOrEmpty(sVehs) || string.IsNullOrEmpty(sNames))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4012\"}");
            }
            else
            {
                if (!SqlFilter.Filter.ProcessFilter(ref sUserName) || !SqlFilter.Filter.ProcessFilter(ref sPwd))
                {
                    context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                }
                else if (!SqlFilter.Filter.ProcessFilter(ref sStealOil) || !SqlFilter.Filter.ProcessFilter(ref sIsPresent) || !SqlFilter.Filter.ProcessFilter(ref sOils) || !SqlFilter.Filter.ProcessFilter(ref sVehs) || !SqlFilter.Filter.ProcessFilter(ref sNames))
                {
                    context.Response.Write("{\"result\":false,\"err\":\"4012\"}");
                }
                else
                {
                    int iUserID = -1;
                    string sErr = "";
                    if (!BllCommon.IsUserLogin(sUserName, sPwd, out iUserID, out sErr))
                    {
                        if (sErr.Length > 0)
                        {
                            context.Response.Write("{\"result\":false,\"err\":\"" + sErr + "\"}");
                        }
                        else
                        {
                            context.Response.Write("{\"result\":false,\"err\":\"4007\"}");
                        }
                    }
                    else
                    {
                        //这里开始获取车辆数据
                        if (iDotype == 2)
                        {
                            if (string.IsNullOrEmpty(sUserName) || string.IsNullOrEmpty(sPwd))
                            {
                                context.Response.Write("{\"result\":false,\"err\":\"4001\"}");
                            }
                            else
                            {
                                sErr = "";
                                string sSql = "delete from [Vehyh_Table] where VehID in (" + sVehs + ")";
                                string[] arrVeh = sVehs.Split(',');
                                string[] arrCph = sNames.Split(',');
                                string[] arrScale = sOils.Split(';');
                                for(int i = 0; i < arrVeh.Length;i++)
                                {
                                    for(int j =0;j < arrScale.Length;j++)
                                    {
                                        sSql += " INSERT INTO Vehyh_Table(VehID, Veh_Cph, YH_Scale, YH_Number, oilminu, oilpercent) VALUES ("
                                            + arrVeh[i] + ",'" + arrCph[i] + "'," + arrScale[j].Split(',')[0] + "," + arrScale[j].Split(',')[1] + ",0," + sStealOil + ") ";
                                    }
                                }
                                if (!BllSql.RunSqlNonQueryParameters(true, sSql, new System.Collections.Generic.List<Models.CSqlParameters>(), out sErr))
                                {
                                    Models.CErr cErr = new Models.CErr();
                                    cErr.result = false;
                                    cErr.err = sErr;
                                    string sJson = JsonHelper.SerializeObject(cErr);
                                    context.Response.Write(sJson);
                                }
                                else
                                {
                                    context.Response.Write("{\"result\":true,\"err\":\"\"}"); 
                                }
                            }
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            context.Response.Write("{\"result\":false,\"err\":\"" + ex.Message + "\"}");
        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}