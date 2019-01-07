<%@ WebHandler Language="C#" Class="Province" %>

using System;
using System.Web;

public class Province : IHttpHandler
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
                        if (iDotype == 1)
                        {
                            System.Collections.Generic.List<Models.CVehProvince> lstVeh = new System.Collections.Generic.List<Models.CVehProvince>();
                            System.Data.DataSet ds = BllVehicle.GetVehicleProvice(iUserID);
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
                                    Models.CVehProvince model = new Models.CVehProvince();
                                    model.City = dr["City"].ToString();
                                    model.Province = dr["Province"].ToString();
                                    model.VehID = Convert.ToInt32(dr["VehID"]);
                                    lstVeh.Add(model);
                                }
                                string sJson = JsonHelper.SerializeObject(lstVeh);
                                context.Response.Write("{\"result\":\"true\",\"err\":\"\",\"data\":" + sJson + "}");
                            }
                        }
                        else if (iDotype == 2)
                        {
                            string sProvince = context.Request["P"];
                            string sCity = context.Request["C"];
                            int iVeh = Convert.ToInt32(context.Request["VehID"].ToString().Substring(1));
                            int iGID = Convert.ToInt32(context.Request["GID"].ToString().Substring(1));
                            if (string.IsNullOrEmpty(sUserName) || string.IsNullOrEmpty(sPwd))
                            {
                                context.Response.Write("{\"result\":\"false\",\"err\":\"4001\"}");
                            }
                            else
                            {
                                if (!SqlFilter.Filter.ProcessFilter(ref sProvince) || !SqlFilter.Filter.ProcessFilter(ref sCity))
                                {
                                    context.Response.Write("{\"result\":\"false\",\"err\":\"4002\"}");
                                }
                                else
                                {                                    
                                    sErr = "";
                                    string sSql = "delete from [VehProvince] where VehID = " + iVeh.ToString();
                                    sSql += " insert into [VehProvince](VehID,Province,City,[Date],[GID]) values(";
                                    sSql += iVeh.ToString() + ",'" + sProvince + "','" + sCity + "','" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "'," + iGID.ToString() + ") ";
                                    int iResult = BllSql.RunSqlExecute(sSql, out sErr);
                                    if(iResult > 0)
                                    {
                                           context.Response.Write("{\"result\":\"true\",\"err\":\"\"}"); 
                                    }
                                    else
                                    {
                                        Models.CErr cErr = new Models.CErr();
                                        cErr.result = false;
                                        cErr.err = sErr;
                                        string sJson = JsonHelper.SerializeObject(cErr);
                                        context.Response.Write(sJson);
                                    }
                                }
                            }
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