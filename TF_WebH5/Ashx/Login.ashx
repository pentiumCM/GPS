<%@ WebHandler Language="C#" Class="Login" %>

using System;
using System.Web;

public class Login : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        try
        {
            //System.Globalization.CultureInfo s = new System.Globalization.CultureInfo("en - US");//zh-CN,en-US 是设置语言类型
            //System.Threading.Thread.CurrentThread.CurrentUICulture = s;
            string sUserName = context.Request["username"];
            string sPwd = context.Request["Pwd"];
            string sLoginDefaultType = context.Request["loginDefaultType"];
            string iIsAdmin = context.Request["IsAdmin"];

            if (string.IsNullOrEmpty(sUserName) || string.IsNullOrEmpty(sPwd) || string.IsNullOrEmpty(sLoginDefaultType))
            {
                context.Response.Write("{\"result\":\"false\",\"err\":\"4001\"}");
            }
            else
            {
                if (!SqlFilter.Filter.ProcessFilter(ref sUserName) || !SqlFilter.Filter.ProcessFilter(ref sPwd) || !SqlFilter.Filter.ProcessFilter(ref sLoginDefaultType))
                {
                    context.Response.Write("{\"result\":\"false\",\"err\":\"4002\"}");
                }
                else
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
                        string sSql = "select ExpirationTime,UserID,UserTypeID from usermain where username = @UserName and password = @Password and DelPurview = 0 ";
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
                                        if (iIsAdmin == "2")
                                        {
                                            if (ds.Tables[0].Rows[0]["UserTypeID"].ToString() == "3")
                                            {
                                                context.Response.Write("{\"result\":\"false\",\"err\":\"4015\",\"userid\":\"" + ds.Tables[0].Rows[0]["UserID"].ToString() + "\"}");
                                                return;
                                            }
                                        }                                            
                                        context.Response.Write("{\"result\":\"true\",\"err\":\"\",\"userid\":\"" + ds.Tables[0].Rows[0]["UserID"].ToString() + "\"}");
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
                        string sSql = "select Id from vehicle where cph = @UserName and WebPass = @Password and DelFlag = 0 ";
                        object obj = BllSql.RunSqlScalarParameters(false, sSql, lstPar, out sErr);
                        if (sErr.Length > 0)
                        {
                            context.Response.Write("{\"result\":\"false\",\"err\":\"" + sErr + "\"}");
                        }
                        else
                        {
                            if (obj == null)
                            {
                                context.Response.Write("{\"result\":\"false\",\"err\":\"4004\"}");
                            }
                            else
                            {
                                context.Response.Write("{\"result\":\"true\",\"err\":\"\",\"userid\":\"" + obj.ToString() + "\"}");
                            }
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