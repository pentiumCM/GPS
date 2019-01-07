<%@ WebHandler Language="C#" Class="Holidays" %>

using System;
using System.Web;

public class Holidays : IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string sSave = context.Request["Save"];
        if (sSave == null)
        {
            string sSql = "SELECT year, days,workdays FROM Holidays";

            System.Collections.Generic.List<Models.CSqlParameters> lstPar = new System.Collections.Generic.List<Models.CSqlParameters>();

            string sErr;
            System.Data.DataSet dsHolidays = BllSql.RunSqlSelectParameters(false, sSql, lstPar, out sErr);
            if (sErr.Length > 0)
            {
                context.Response.Write("{\"result\":\"false\",\"err\":\"" + sErr + "\"}");
                return;
            }
            if (dsHolidays == null || dsHolidays.Tables.Count == 0 || dsHolidays.Tables[0].Rows.Count == 0)
            {
                System.Collections.Generic.List<Models.CVehHistory> lstReturn = new System.Collections.Generic.List<Models.CVehHistory>();
                string ssReturn = JsonHelper.SerializeObject(lstReturn);
                context.Response.Write("{\"result\":\"false\",\"data\":" + ssReturn + "}");
                return;
            }
            System.Data.DataRowCollection drs = dsHolidays.Tables[0].Rows;
            System.Collections.Generic.List<Models.CHolidays> lstHolidays = new System.Collections.Generic.List<Models.CHolidays>();
            Models.CHolidays temp = new Models.CHolidays();
            foreach (System.Data.DataRow dr in drs)
            {
                temp = new Models.CHolidays();
                temp.year = dr["year"].ToString();
                temp.days = dr["days"].ToString();
                temp.workdays = dr["workdays"].ToString();
                temp.text = temp.year;
                lstHolidays.Add(temp);
            }
            string ss = JsonHelper.SerializeObject(lstHolidays);
            context.Response.Write("{\"result\":\"true\",\"data\":" + ss + "}");
        }
        else
        {
            if (sSave.Length == 0)
            {
                context.Response.Write("{\"result\":\"true\",\"err\":\"\"}"); 
            }
            else if (!SqlFilter.Filter.ProcessFilter(ref sSave))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            else
            {
                System.Collections.Generic.List<Models.CHolidaysJson> lstSave = JsonHelper.DeserializeJsonToObject<System.Collections.Generic.List<Models.CHolidaysJson>>(sSave);
                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                foreach (Models.CHolidaysJson cHoliday in lstSave)
                {
                    if (cHoliday.Do == "I")
                    {
                        sb.AppendLine("insert into [Holidays] values('" + cHoliday.Year + "','" + cHoliday.Days + "','" + cHoliday.workdays + "') "); 
                    }
                    else if (cHoliday.Do == "D")
                    {
                        sb.AppendLine("delete from [Holidays] where year = '" + cHoliday.Year + "' ");
                    }
                    else if (cHoliday.Do == "U")
                    {
                        sb.AppendLine("update [Holidays] set days='" + cHoliday.Days + "',workdays='" + cHoliday.workdays + "' where year = '" + cHoliday.Year + "' ");
                    }
                }
                string sSql = sb.ToString();
                if (sSql.Length > 0)
                {
                    string sErr;
                    if (BllSql.RunSqlNonQueryParameters(false, sSql, new System.Collections.Generic.List<Models.CSqlParameters>(), out sErr))
                    {
                        context.Response.Write("{\"result\":\"true\",\"err\":\"\"}");
                    }
                    else
                    {
                        context.Response.Write("{\"result\":\"false\",\"err\":\"" + sErr + "\"}");  
                    }                 
                }
                else
                {
                    context.Response.Write("{\"result\":\"true\",\"err\":\"\"}"); 
                }
            }
        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}