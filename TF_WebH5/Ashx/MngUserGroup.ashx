<%@ WebHandler Language="C#" Class="MngUserGroup" %>

using System;
using System.Web;

public class MngUserGroup : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        int CheckResult = 0;
        try
        {
            int iExeType = Convert.ToInt32(context.Request["DoType"]);   //请求类型
            int iUserGroupID = Convert.ToInt32(context.Request["ID"]);   //ID
            string strName = context.Request["Name"];
            string sOldName = context.Request["OldName"];
            string sIP = context.Request.ServerVariables.Get("Remote_Addr").ToString();
            string sUserName = context.Request["username"];
            string sPwd = context.Request["Pwd"];
            string sMarks = context.Request["Marks"];
            int iUserID = 0;
            if (string.IsNullOrEmpty(sUserName) || string.IsNullOrEmpty(sPwd))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4012\"}");
                return;
            }
            if (!SqlFilter.Filter.ProcessFilter(ref sUserName) || !SqlFilter.Filter.ProcessFilter(ref sPwd))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }

            if (true)
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
                string sSql = "select ExpirationTime,UserID from usermain where username = @UserName and password = @Password and DelPurview = 0 ";
                System.Data.DataSet ds = BllSql.RunSqlSelectParameters(false, sSql, lstPar, out sErr);
                if (sErr.Length > 0)
                {
                    context.Response.Write("{\"result\":false,\"err\":\"4006\",\"err2\":\"" + sErr + "\"}");
                    return;
                }
                else
                {
                    if (ds == null || ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0)
                    {
                        context.Response.Write("{\"result\":false,\"err\":\"4004\"}");
                        return;
                    }
                    else
                    {
                        try
                        {
                            iUserID = Convert.ToInt32(ds.Tables[0].Rows[0]["UserID"]);
                            DateTime dtTime = DateTime.Parse(ds.Tables[0].Rows[0]["ExpirationTime"].ToString());
                            if (dtTime.Subtract(DateTime.Now).TotalMinutes > 0)
                            {

                            }
                            else
                            {
                                context.Response.Write("{\"result\":false,\"err\":\"4005\"}");
                                return;
                            }
                        }
                        catch { }
                    }
                }
            }
            int iExeResult = 0;    //执行结果
            string strExeResult = "";

            string strSQL = "";

            if (iExeType == 0) //编辑
            {
                if (sMarks == null)
                {
                    sMarks = "";
                }
                if (string.IsNullOrEmpty(strName) || string.IsNullOrEmpty(sOldName))
                {
                    context.Response.Write("{\"result\":false,\"err\":\"4012\"}");
                    return;
                }
                if (!SqlFilter.Filter.ProcessFilter(ref strName) || !SqlFilter.Filter.ProcessFilter(ref sMarks) || !SqlFilter.Filter.ProcessFilter(ref sOldName))
                {
                    context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                    return;
                }

                System.Data.SqlClient.SqlConnection sqlCon = null;
                System.Data.SqlClient.SqlTransaction trans = null;
                try
                {
                    strSQL = "SELECT top 1 UserGroupID FROM UserGroupMain WHERE (UserGroupID = " + iUserGroupID.ToString() + ")";
                    sqlCon = new System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings["conn"]);
                    System.Data.SqlClient.SqlCommand sqlCmd = new System.Data.SqlClient.SqlCommand(strSQL, sqlCon);
                    sqlCmd.CommandType = System.Data.CommandType.Text;//设置调用的类型为存储过程  
                    sqlCon.Open();
                    trans = sqlCon.BeginTransaction();
                    sqlCmd.Transaction = trans;
                    if (Convert.ToInt32(sqlCmd.ExecuteScalar()) == 0)
                    {
                        context.Response.Write("{\"result\":false,\"err\":\"4013\"}");
                        return;
                    }
                    strSQL = "SELECT top 1 UserGroupName UserGroupID FROM UserGroupMain WHERE UserGroupName ='" + strName + "' and (UserGroupID != " + iUserGroupID.ToString() + ")";
                    sqlCmd.CommandText = strSQL;
                    if (Convert.ToInt32(sqlCmd.ExecuteScalar()) > 0)
                    {
                        context.Response.Write("{\"result\":false,\"err\":\"4013\"}");
                        return;
                    }
                    strSQL = "update UserGroupMain set UserGroupName='" + strName + "', UserTypeID=0, UserGroupMemo='" + sMarks + "',UpdateTime='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "' where UserGroupID=" + iUserGroupID.ToString();
                    sqlCmd.CommandText = strSQL;
                    sqlCmd.ExecuteNonQuery();

                    //权限串表
                    strSQL = "delete  UserGroup_Permission   where UserGroupID=" + iUserGroupID.ToString();
                    sqlCmd.CommandText = strSQL;
                    sqlCmd.ExecuteNonQuery();

                    //权限串表
                    strSQL = "INSERT INTO UserGroup_Permission(UserGroupID, FuncID) VALUES (" + iUserGroupID.ToString() + ",'')";
                    sqlCmd.CommandText = strSQL;
                    sqlCmd.ExecuteNonQuery();

                    trans.Commit();
                    Models.CErr cReturn = new Models.CErr();
                    cReturn.result = true;
                    cReturn.err = iUserGroupID.ToString();
                    BllCommon.AddOpNoteFromVehMgr("EditUserGroup", 0, "", "", sUserName, sIP, iUserID, new object[] { 0, sOldName, strName });
                    string ss = JsonHelper.SerializeObject(cReturn);
                    context.Response.Write(ss);
                    return;
                }
                catch (Exception exDel)
                {
                    try
                    {
                        if (trans != null)
                        {
                            trans.Rollback();
                        }
                    }
                    catch { }
                    context.Response.Write("{\"result\":false,\"err\":\"4012\"}");
                    return;
                }
                finally
                {
                    try
                    {
                        if (sqlCon != null && sqlCon.State == System.Data.ConnectionState.Open)
                        {
                            sqlCon.Close();
                        }
                    }
                    catch { }
                }
            }
            else if (iExeType == 4)
            {
                strSQL = "select UserGroupID,UserGroupName,UserGroupMemo from UserGroupMain where UserGroupID = " + iUserGroupID.ToString();
                System.Data.DataSet ds = BllSql.RunSqlSelect(strSQL);
                if (ds == null || ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0)
                {
                    context.Response.Write("{\"result\":false,\"err\":\"4012\"}");//"查询失败，不允许将自己添加到自己下面的车队！
                    return;
                }
                else
                {
                    Models.CUserGroupDetail cDetail = new Models.CUserGroupDetail();
                    cDetail.id = ds.Tables[0].Rows[0]["UserGroupID"].ToString();
                    cDetail.Name = ds.Tables[0].Rows[0]["UserGroupName"].ToString();
                    cDetail.Marks = ds.Tables[0].Rows[0]["UserGroupMemo"].ToString();
                    string ss = JsonHelper.SerializeObject(cDetail);
                    context.Response.Write("{\"result\":true,\"data\":[" + ss + "]}");
                    return;
                }
            }
            else if (iExeType == 2)//删除
            {
                System.Data.SqlClient.SqlConnection sqlCon = null;
                System.Data.SqlClient.SqlTransaction trans = null;
                try
                {
                    strSQL = "SELECT UserGroupMain.UserGroupID FROM UserGroupMain INNER JOIN UserGroupDetail ON " 
                     + "  UserGroupMain.UserGroupID = UserGroupDetail.UserGroupID INNER JOIN " 
                     + " UserMain ON UserGroupDetail.UserID = UserMain.UserID " 
                     + "  WHERE (UserMain.UserID = 1) and UserGroupMain.UserGroupID=" + iUserGroupID.ToString();
                    sqlCon = new System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings["conn"]);
                    System.Data.SqlClient.SqlCommand sqlCmd = new System.Data.SqlClient.SqlCommand(strSQL, sqlCon);
                    sqlCmd.CommandType = System.Data.CommandType.Text;//设置调用的类型为存储过程  
                    sqlCon.Open();
                    trans = sqlCon.BeginTransaction();
                    sqlCmd.Transaction = trans;
                    if (Convert.ToInt32(sqlCmd.ExecuteScalar()) > 0)
                    {
                        context.Response.Write("{\"result\":false,\"err\":\"4015\"}");
                        return;
                    }
                   strSQL = "SELECT UserGroupDetail.UserID FROM UserGroupMain INNER JOIN UserGroupDetail ON " 
                          + " UserGroupMain.UserGroupID = UserGroupDetail.UserGroupID WHERE (UserGroupMain.UserGroupID = " + iUserGroupID.ToString() + ") and UserGroupDetail.UserID = " + iUserID.ToString();
                    sqlCmd.CommandText = strSQL;
                    if (Convert.ToInt32(sqlCmd.ExecuteScalar()) > 0)
                    {
                        context.Response.Write("{\"result\":false,\"err\":\"4015\"}");
                        return;
                    }
                    //将名下的所有帐号，打上删除标记
                    strSQL = "UPDATE UserMain SET DelPurview =1,UpdateTime='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "' where userid in(SELECT UserGroupDetail.UserID FROM UserGroupMain INNER JOIN UserGroupDetail ON "
                              + "  UserGroupMain.UserGroupID = UserGroupDetail.UserGroupID WHERE (UserGroupMain.UserGroupID = " + iUserGroupID.ToString() + "))";
                    sqlCmd.CommandText = strSQL;
                    sqlCmd.ExecuteNonQuery();

                    strSQL = "UPDATE UserGroupMain SET DelFlag = 1,UpdateTime='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "' WHERE (UserGroupID = " + iUserGroupID.ToString() + ")";
                    sqlCmd.CommandText = strSQL;
                    sqlCmd.ExecuteNonQuery();
                    trans.Commit();
                    Models.CErr cReturn = new Models.CErr();
                    cReturn.result = true;
                    cReturn.err = iUserGroupID.ToString();
                    BllCommon.AddOpNoteFromVehMgr("DelUserGroup", 0, "", "", sUserName, sIP, iUserID, new object[] { strName, iUserGroupID.ToString() });
                    string ss = JsonHelper.SerializeObject(cReturn);
                    context.Response.Write(ss);
                    return;
                }
                catch (Exception exDel)
                {
                    try
                    {
                        if (trans != null)
                        {
                            trans.Rollback();
                        }
                    }
                    catch { }
                    context.Response.Write("{\"result\":false,\"err\":\"4012\"}");
                    return;
                }
                finally
                {
                    try
                    {
                        if (sqlCon != null && sqlCon.State == System.Data.ConnectionState.Open)
                        {
                            sqlCon.Close();
                        }
                    }
                    catch { }
                }
            }
            else if (iExeType == 1)//新添
            {
                if (sMarks == null)
                {
                    sMarks = "";
                }
                if (string.IsNullOrEmpty(strName))
                {
                    context.Response.Write("{\"result\":false,\"err\":\"4012\"}");
                    return;
                }
                if (!SqlFilter.Filter.ProcessFilter(ref strName) || !SqlFilter.Filter.ProcessFilter(ref sMarks))
                {
                    context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                    return;
                }

                System.Data.SqlClient.SqlConnection sqlCon = null;
                System.Data.SqlClient.SqlTransaction trans = null;
                try
                {
                    strSQL = "SELECT top 1 UserGroupID FROM UserGroupMain WHERE (UserGroupName  = '" + strName + "')";
                    sqlCon = new System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings["conn"]);
                    System.Data.SqlClient.SqlCommand sqlCmd = new System.Data.SqlClient.SqlCommand(strSQL, sqlCon);
                    sqlCmd.CommandType = System.Data.CommandType.Text;//设置调用的类型为存储过程  
                    sqlCon.Open();
                    trans = sqlCon.BeginTransaction();
                    sqlCmd.Transaction = trans;
                    if (Convert.ToInt32(sqlCmd.ExecuteScalar()) > 0)
                    {
                        context.Response.Write("{\"result\":false,\"err\":\"4013\"}");
                        return;
                    }
                    //插入基本信息
                    strSQL = "INSERT INTO UserGroupMain(UserGroupName, UserTypeID, UserGroupMemo) "
                             + "  VALUES('" + strName + "',0 ,'" + sMarks + "') select @@IDENTITY ";
                    sqlCmd.CommandText = strSQL;

                    iUserGroupID = Convert.ToInt32(sqlCmd.ExecuteScalar());

                    //插入权限串表
                    strSQL = "INSERT INTO UserGroup_Permission(UserGroupID, FuncID) VALUES (" + iUserGroupID.ToString() + ",'')";
                    sqlCmd.CommandText = strSQL;
                    sqlCmd.ExecuteNonQuery();

                    trans.Commit();
                    Models.CErr cReturn = new Models.CErr();
                    cReturn.result = true;
                    cReturn.err = iUserGroupID.ToString();
                    BllCommon.AddOpNoteFromVehMgr("EditUserGroup", 0, "", "", sUserName, sIP, iUserID, new object[] { 1, strName });
                    string ss = JsonHelper.SerializeObject(cReturn);
                    context.Response.Write(ss);
                    return;
                }
                catch (Exception exDel)
                {
                    try
                    {
                        if (trans != null)
                        {
                            trans.Rollback();
                        }
                    }
                    catch { }
                    context.Response.Write("{\"result\":false,\"err\":\"4012\"}");
                    return;
                }
                finally
                {
                    try
                    {
                        if (sqlCon != null && sqlCon.State == System.Data.ConnectionState.Open)
                        {
                            sqlCon.Close();
                        }
                    }
                    catch { }
                }
            }
            else
            {
                context.Response.Write("{\"result\":false,\"err\":\"4012\"}");
                return;
            }
        }
        catch (Exception ex)
        {
            context.Response.Write("{\"result\":false,\"err\":\"4012\"}");
            return;
        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}