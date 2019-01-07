using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using Models;
using System.Data.SqlClient;
using System.Text.RegularExpressions;

/// <summary>
///BllSql 的摘要说明
/// </summary>
public class BllSql
{
    public BllSql()
    {
        //
        //TODO: 在此处添加构造函数逻辑
        //
    }

    public static DataSet RunSqlSelect(string sSql)
    {
        SqlConnection conn = null;
        try
        {
            DataSet ds = new DataSet();
            conn = new SqlConnection(ConfigurationManager.AppSettings["conn"]);
            conn.Open();
            SqlDataAdapter command = new SqlDataAdapter(sSql, conn);
            command.Fill(ds, "ds");
            return ds;
        }
        catch (Exception ex)
        {
            return null;
        }
        finally
        {
            try
            {
                if (conn != null && conn.State == ConnectionState.Open)
                {
                    conn.Close();
                }
            }
            catch { }
        }
    }

    public static DataSet RunSqlSelectParameters(bool bTrans, string sSql, System.Collections.Generic.List<CSqlParameters> lstPar, out string sErr)
    {
        sErr = "";
        SqlConnection sqlCon = null;
        SqlTransaction trans = null;
        try
        {
            sqlCon = new SqlConnection(ConfigurationManager.AppSettings["conn"]);
            SqlCommand sqlCmd = new SqlCommand(sSql, sqlCon);
            sqlCmd.CommandType = CommandType.Text;//设置调用的类型为存储过程  
            if (lstPar.Count > 0)
            {
                SqlParameter sqlParme;
                foreach (CSqlParameters par in lstPar)
                {
                    //参数1  
                    sqlParme = sqlCmd.Parameters.Add(par.sName, par.sqlDbType, par.iLen);
                    sqlParme.Direction = par.pDirection;
                    sqlParme.Value = par.sValue;
                }
            }
            sqlCon.Open();
            if (bTrans)
            {
                trans = sqlCon.BeginTransaction();
                sqlCmd.Transaction = trans;
            }
            SqlDataAdapter da = new SqlDataAdapter(sqlCmd);
            DataSet ds = new DataSet();
            da.Fill(ds, "table");
            if (bTrans)
            {
                trans.Commit();
            }
            sqlCon.Close();
            return ds;
        }
        catch (Exception ex)
        {
            sErr = ex.Message;
            try
            {
                if (bTrans && trans != null)
                {
                    trans.Rollback();
                }
            }
            catch { }
            return null;
        }
        finally
        {
            try
            {
                if (sqlCon != null && sqlCon.State == ConnectionState.Open)
                {
                    sqlCon.Close();
                }
            }
            catch { }
        }
    }

    public static bool RunSqlNonQueryParameters(bool bTrans, string sSql, System.Collections.Generic.List<CSqlParameters> lstPar, out string sErr)
    {
        sErr = "";
        SqlConnection sqlCon = null;
        SqlTransaction trans = null;
        try
        {
            sqlCon = new SqlConnection(ConfigurationManager.AppSettings["conn"]);
            SqlCommand sqlCmd = new SqlCommand(sSql, sqlCon);
            sqlCmd.CommandType = CommandType.Text;//设置调用的类型为存储过程  
            if (lstPar.Count > 0)
            {
                SqlParameter sqlParme;
                foreach (CSqlParameters par in lstPar)
                {
                    //参数1  
                    sqlParme = sqlCmd.Parameters.Add(par.sName, par.sqlDbType, par.iLen);
                    sqlParme.Direction = par.pDirection;
                    sqlParme.Value = par.sValue;
                }
            }
            sqlCon.Open();
            if (bTrans)
            {
                trans = sqlCon.BeginTransaction();
                sqlCmd.Transaction = trans;
            }
            sqlCmd.ExecuteNonQuery();
            foreach (CSqlParameters par in lstPar)
            {
                //参数1  
                if (par.sName == "@return")
                {
                    sErr = sqlCmd.Parameters["@return"].Value.ToString();
                }
            }
            if (bTrans)
            {
                trans.Commit();
            }
            sqlCon.Close();
            return true;
        }
        catch (Exception ex)
        {
            sErr = ex.Message;
            try
            {
                if (bTrans && trans != null)
                {
                    trans.Rollback();
                }
            }
            catch { }
            return false;
        }
        finally
        {
            try
            {
                if (sqlCon != null && sqlCon.State == ConnectionState.Open)
                {
                    sqlCon.Close();
                }
            }
            catch { }
        }
    }

    public static int RunSqlScalar(string sSql)
    {
        SqlConnection conn = null;
        try
        {
            conn = new SqlConnection(ConfigurationManager.AppSettings["conn"]);
            conn.Open();
            SqlCommand command = new SqlCommand(sSql, conn);
            int i = Convert.ToInt32(command.ExecuteScalar());
            return i;
        }
        catch (Exception ex)
        {
            return -2;
        }
        finally
        {
            try
            {
                if (conn != null && conn.State == ConnectionState.Open)
                {
                    conn.Close();
                }
            }
            catch { }
        }
    }

    public static int RunSqlExecute(string sSql, out string sErr)
    {
        sErr = "";
        SqlConnection conn = null;
        try
        {
            conn = new SqlConnection(ConfigurationManager.AppSettings["conn"]);
            conn.Open();
            SqlCommand command = new SqlCommand(sSql, conn);
            int i = command.ExecuteNonQuery();
            return i;
        }
        catch (Exception ex)
        {
            sErr = ex.Message;
            return 0;
        }
        finally
        {
            try
            {
                if (conn != null && conn.State == ConnectionState.Open)
                {
                    conn.Close();
                }
            }
            catch { }
        }
    }

    public static object RunSqlScalarParameters(bool bTrans, string sSql, System.Collections.Generic.List<CSqlParameters> lstPar, out string sErr)
    {
        sErr = "";
        SqlConnection sqlCon = null;
        SqlTransaction trans = null;
        try
        {
            sqlCon = new SqlConnection(ConfigurationManager.AppSettings["conn"]);
            SqlCommand sqlCmd = new SqlCommand(sSql, sqlCon);
            sqlCmd.CommandType = CommandType.Text;//设置调用的类型为存储过程  
            if (lstPar.Count > 0)
            {
                SqlParameter sqlParme;
                foreach (CSqlParameters par in lstPar)
                {
                    //参数1  
                    sqlParme = sqlCmd.Parameters.Add(par.sName, par.sqlDbType, par.iLen);
                    sqlParme.Direction = par.pDirection;
                    sqlParme.Value = par.sValue;
                }
            }
            sqlCon.Open();
            if (bTrans)
            {
                trans = sqlCon.BeginTransaction();
                sqlCmd.Transaction = trans;
            }
            object i = sqlCmd.ExecuteScalar();
            if (bTrans)
            {
                trans.Commit();
            }
            sqlCon.Close();
            return i;
        }
        catch (Exception ex)
        {
            sErr = ex.Message;
            try
            {
                if (bTrans && trans != null)
                {
                    trans.Rollback();
                }
            }
            catch { }
            return null;
        }
        finally
        {
            try
            {
                if (sqlCon != null && sqlCon.State == ConnectionState.Open)
                {
                    sqlCon.Close();
                }
            }
            catch { }
        }
    }

    public static object RunSqlScalarProcedureParameters(bool bTrans, string sSql, System.Collections.Generic.List<CSqlParameters> lstPar, out string sErr)
    {
        sErr = "";
        SqlConnection sqlCon = null;
        SqlTransaction trans = null;
        try
        {
            sqlCon = new SqlConnection(ConfigurationManager.AppSettings["conn"]);
            SqlCommand sqlCmd = new SqlCommand(sSql, sqlCon);
            sqlCmd.CommandType = CommandType.StoredProcedure;//设置调用的类型为存储过程  
            if (lstPar.Count > 0)
            {
                SqlParameter sqlParme;
                foreach (CSqlParameters par in lstPar)
                {
                    //参数1  
                    sqlParme = sqlCmd.Parameters.Add(par.sName, par.sqlDbType, par.iLen);
                    sqlParme.Direction = par.pDirection;
                    sqlParme.Value = par.sValue;
                }
            }
            sqlCon.Open();
            if (bTrans)
            {
                trans = sqlCon.BeginTransaction();
                sqlCmd.Transaction = trans;
            }
            object i = sqlCmd.ExecuteScalar();
            if (bTrans)
            {
                trans.Commit();
            }
            sqlCon.Close();
            return i;
        }
        catch (Exception ex)
        {
            sErr = ex.Message;
            try
            {
                if (bTrans && trans != null)
                {
                    trans.Rollback();
                }
            }
            catch { }
            return null;
        }
        finally
        {
            try
            {
                if (sqlCon != null && sqlCon.State == ConnectionState.Open)
                {
                    sqlCon.Close();
                }
            }
            catch { }
        }
    }

    public static bool RunSqlProcedure(bool bTrans, string sProcedureName, System.Collections.Generic.List<CSqlParameters> lstPar, out string sErr)
    {
        sErr = "";
        SqlTransaction trans = null;
        SqlConnection sqlCon = null;
        try
        {
            sqlCon = new SqlConnection(ConfigurationManager.AppSettings["conn"]);
            SqlCommand sqlCmd = new SqlCommand(sProcedureName, sqlCon);
            sqlCmd.CommandType = CommandType.StoredProcedure;//设置调用的类型为存储过程  
            if (lstPar.Count > 0)
            {
                SqlParameter sqlParme;
                foreach (CSqlParameters par in lstPar)
                {
                    //参数1  
                    sqlParme = sqlCmd.Parameters.Add(par.sName, par.sqlDbType, par.iLen);
                    sqlParme.Direction = par.pDirection;
                    sqlParme.Value = par.sValue;
                }
            }
            sqlCon.Open();
            if (bTrans)
            {
                trans = sqlCon.BeginTransaction();
                sqlCmd.Transaction = trans;
            }
            sqlCmd.ExecuteNonQuery();
            if (bTrans)
            {
                trans.Commit();
            }
            sqlCon.Close();
            return true;
        }
        catch (Exception ex)
        {
            sErr = ex.Message;
            try
            {
                if (bTrans && trans != null)
                {
                    trans.Rollback();
                }
            }
            catch { }
            return false;
        }
        finally
        {
            try
            {
                if (sqlCon != null && sqlCon.State == ConnectionState.Open)
                {
                    sqlCon.Close();
                }
            }
            catch { }
        }
    }

    public static DataSet RunSqlSelectProcedure(bool bTrans, string sProcedureName, System.Collections.Generic.List<CSqlParameters> lstPar, out string sErr)
    {
        sErr = "";
        SqlTransaction trans = null;
        SqlConnection sqlCon = null;
        try
        {
            sqlCon = new SqlConnection(ConfigurationManager.AppSettings["conn"]);
            SqlCommand sqlCmd = new SqlCommand(sProcedureName, sqlCon);
            sqlCmd.CommandType = CommandType.StoredProcedure;//设置调用的类型为存储过程  
            if (lstPar.Count > 0)
            {
                SqlParameter sqlParme;
                foreach (CSqlParameters par in lstPar)
                {
                    //参数1  
                    sqlParme = sqlCmd.Parameters.Add(par.sName, par.sqlDbType, par.iLen);
                    sqlParme.Direction = par.pDirection;
                    sqlParme.Value = par.sValue;
                }
            }
            sqlCon.Open();
            if (bTrans)
            {
                trans = sqlCon.BeginTransaction();
                sqlCmd.Transaction = trans;
            }
            SqlDataAdapter ad = new SqlDataAdapter();
            ad.SelectCommand = sqlCmd;
            DataSet ds = new DataSet();
            ad.Fill(ds);
            if (bTrans)
            {
                trans.Commit();
            }
            sqlCon.Close();
            return ds;
        }
        catch (Exception ex)
        {
            sErr = ex.Message;
            try
            {
                if (bTrans && trans != null)
                {
                    trans.Rollback();
                }
            }
            catch { }
            return null;
        }
        finally
        {
            try
            {
                if (sqlCon != null && sqlCon.State == ConnectionState.Open)
                {
                    sqlCon.Close();
                }
            }
            catch { }
        }
    }

    #region sql敏感字
    /// 
    /// 判断字符串中是否有SQL攻击代码
    /// 
    /// 传入用户提交数据
    /// true-安全；false-有注入攻击现有；
    //public static bool ProcessSqlStr(string inputString)
    //{            
    //    //string SqlStr = @"and|or|exec|execute|insert|select|delete|update|alter|create|drop|count|\*|chr|char|asc|mid|substring|master|truncate|declare|xp_cmdshell|restore|backup|net +user|net +localgroup +administrators";
    //    string SqlStr = @"exec|execute|insert|select|delete|update|alter|create|drop|count|\*|substring|master|truncate|declare|xp_cmdshell|restore|backup|net +user|net +localgroup +administrators";
    //    try
    //    {
    //        if ((inputString != null) && (inputString != String.Empty))
    //        {
    //            string str_Regex = @"\b(" + SqlStr + @")\b";

    //            Regex Regex = new Regex(str_Regex, RegexOptions.IgnoreCase);
    //            //string s = Regex.Match(inputString).Value; 
    //            if (true == Regex.IsMatch(inputString))
    //                return false;

    //        }
    //    }
    //    catch
    //    {
    //        return false;
    //    }
    //    return true;
    //}

    /// 
    /// 将输入字符串中的sql敏感字，替换成"[敏感字]"，要求输出时，替换回来
    /// 
    /// 
    /// 
    public static string MyEncodeInputString(string inputString)
    {
        //要替换的敏感字
        //string SqlStr = @"and|or|exec|execute|insert|select|delete|update|alter|create|drop|count|\*|chr|char|asc|mid|substring|master|truncate|declare|xp_cmdshell|restore|backup|net +user|net +localgroup +administrators";
        string SqlStr = @"exec|execute|insert|select|delete|update|alter|create|drop|count|\*|substring|master|truncate|declare|xp_cmdshell|restore|backup|net +user|net +localgroup +administrators";
        try
        {
            if ((inputString != null) && (inputString != String.Empty))
            {
                string str_Regex = @"\b(" + SqlStr + @")\b";

                Regex Regex = new Regex(str_Regex, RegexOptions.IgnoreCase);
                //string s = Regex.Match(inputString).Value; 
                MatchCollection matches = Regex.Matches(inputString);
                for (int i = 0; i < matches.Count; i++)
                    inputString = inputString.Replace(matches[i].Value, "[" + matches[i].Value + "]");

            }
        }
        catch
        {
            return "";
        }
        return inputString;

    }

    /// 
    /// 将已经替换成的"[敏感字]"，转换回来为"敏感字"
    /// 
    /// 
    /// 
    public static string MyDecodeOutputString(string outputstring)
    {
        //要替换的敏感字
        //string SqlStr = @"and|or|exec|execute|insert|select|delete|update|alter|create|drop|count|\*|chr|char|asc|mid|substring|master|truncate|declare|xp_cmdshell|restore|backup|net +user|net +localgroup +administrators";
        string SqlStr = @"exec|execute|insert|select|delete|update|alter|create|drop|count|\*|substring|master|truncate|declare|xp_cmdshell|restore|backup|net +user|net +localgroup +administrators";
        try
        {
            if ((outputstring != null) && (outputstring != String.Empty))
            {
                string str_Regex = @"\[\b(" + SqlStr + @")\b\]";
                Regex Regex = new Regex(str_Regex, RegexOptions.IgnoreCase);
                MatchCollection matches = Regex.Matches(outputstring);
                for (int i = 0; i < matches.Count; i++)
                    outputstring = outputstring.Replace(matches[i].Value, matches[i].Value.Substring(1, matches[i].Value.Length - 2));

            }
        }
        catch
        {
            return "";
        }
        return outputstring;
    }
    #endregion
}
