<%@ WebHandler Language="C#" Class="MngUser" %>

using System;
using System.Web;

public class MngUser : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        int CheckResult = 0;
        try
        {
            int iExeType = Convert.ToInt32(context.Request["DoType"]);   //请求类型
            string sOldName = context.Request["OldName"];
            string sIP = context.Request.ServerVariables.Get("Remote_Addr").ToString();
            string sUserName = context.Request["username"];
            string sPwd = context.Request["Pwd"];

            string strName = context.Request["Name"];
            int iID = Convert.ToInt32(context.Request["ID"]);   //ID
            string sNewPwd = context.Request["NewPwd"];
            int sUserGroupID = Convert.ToInt32(context.Request["UserGroupID"]);
            string sCompanyName = context.Request["CompanyName"];
            string sTel = context.Request["Tel"];
            int sAccountType = Convert.ToInt32(context.Request["AccountType"]);
            string sExpirationTime = context.Request["ExpirationTime"];
            string sPermission = context.Request["Permission"];
            string sGroups = context.Request["Groups"];
            int iRoleID = 1;
            int iUserID = 0;
            if (string.IsNullOrEmpty(sUserName) || string.IsNullOrEmpty(strName) || string.IsNullOrEmpty(sPwd) || string.IsNullOrEmpty(sNewPwd))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4012\"}");
                return;
            }
            if (!SqlFilter.Filter.ProcessFilter(ref sUserName) || !SqlFilter.Filter.ProcessFilter(ref strName) || !SqlFilter.Filter.ProcessFilter(ref sPwd) || !SqlFilter.Filter.ProcessFilter(ref sNewPwd))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            if (!SetNull(context, ref sOldName))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            if (!SetNull(context, ref sCompanyName))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            if (!SetNull(context, ref sTel))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            if (!SetNull(context, ref sExpirationTime))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            if (!SetNull(context, ref sPermission))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            if (!SetNull(context, ref sGroups))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            DateTime dt;
            if (!DateTime.TryParse(sExpirationTime, out dt))
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
                string sSql = "select ExpirationTime,UserID,UserTypeID from usermain where username = @UserName and password = @Password and DelPurview = 0 ";
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
                                if (Convert.ToInt32(ds.Tables[0].Rows[0]["UserTypeID"]) == 3)
                                {
                                    context.Response.Write("{\"result\":false,\"err\":\"4015\"}");
                                    return;
                                }
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
                strSQL = "select 1 from usermain where username='" + strName + "' and UserID !=" + iID.ToString();
                if (BllSql.RunSqlScalar(strSQL) > 0)
                {
                    context.Response.Write("{\"result\":false,\"err\":\"4012\"}");//"查询失败
                    return;
                }
                System.Collections.Generic.List<Models.CSqlParameters> lstPar = new System.Collections.Generic.List<Models.CSqlParameters>();
                Models.CSqlParameters par = new Models.CSqlParameters();
                par.iLen = 4;
                par.pDirection = System.Data.ParameterDirection.Input;
                par.sName = "UserID";
                par.sqlDbType = System.Data.SqlDbType.Int;
                par.sValue = iID;
                lstPar.Add(par);
                par = new Models.CSqlParameters();
                par.iLen = strName.Length;
                par.pDirection = System.Data.ParameterDirection.Input;
                par.sName = "UserName";
                par.sqlDbType = System.Data.SqlDbType.NVarChar;
                par.sValue = strName;
                lstPar.Add(par);
                par = new Models.CSqlParameters();
                par.iLen = sNewPwd.Length;
                par.pDirection = System.Data.ParameterDirection.Input;
                par.sName = "Password";
                par.sqlDbType = System.Data.SqlDbType.NVarChar;
                par.sValue = sNewPwd;
                lstPar.Add(par);
                par = new Models.CSqlParameters();
                par.iLen = 4;
                par.pDirection = System.Data.ParameterDirection.Input;
                par.sName = "UserTypeID";
                par.sqlDbType = System.Data.SqlDbType.Int;
                par.sValue = sAccountType;
                lstPar.Add(par);
                par = new Models.CSqlParameters();
                par.iLen = sCompanyName.Length;
                par.pDirection = System.Data.ParameterDirection.Input;
                par.sName = "OwnerName";
                par.sqlDbType = System.Data.SqlDbType.NVarChar;
                par.sValue = sCompanyName;
                lstPar.Add(par);
                par = new Models.CSqlParameters();
                par.iLen = sTel.Length;
                par.pDirection = System.Data.ParameterDirection.Input;
                par.sName = "sTel";
                par.sqlDbType = System.Data.SqlDbType.NVarChar;
                par.sValue = sTel;
                lstPar.Add(par);
                par = new Models.CSqlParameters();
                par.iLen = 2;
                par.pDirection = System.Data.ParameterDirection.Input;
                par.sName = "sMemo";
                par.sqlDbType = System.Data.SqlDbType.NVarChar;
                par.sValue = "1";
                lstPar.Add(par);
                par = new Models.CSqlParameters();
                par.iLen = 8;
                par.pDirection = System.Data.ParameterDirection.Input;
                par.sName = "timelimit";
                par.sqlDbType = System.Data.SqlDbType.DateTime;
                par.sValue = DateTime.Now;
                lstPar.Add(par);
                par = new Models.CSqlParameters();
                par.iLen = 8;
                par.pDirection = System.Data.ParameterDirection.Input;
                par.sName = "birthday";
                par.sqlDbType = System.Data.SqlDbType.DateTime;
                par.sValue = DateTime.Now;
                lstPar.Add(par);
                par = new Models.CSqlParameters();
                par.iLen = 4;
                par.pDirection = System.Data.ParameterDirection.Input;
                par.sName = "SignLimit";
                par.sqlDbType = System.Data.SqlDbType.Int;
                par.sValue = 0;
                lstPar.Add(par);
                par = new Models.CSqlParameters();
                par.iLen = sPermission.Length;
                par.pDirection = System.Data.ParameterDirection.Input;
                par.sName = "FunList";
                par.sqlDbType = System.Data.SqlDbType.VarChar;
                par.sValue = sPermission;
                lstPar.Add(par);
                par = new Models.CSqlParameters();
                par.iLen = sGroups.Length;
                par.pDirection = System.Data.ParameterDirection.Input;
                par.sName = "VGrouPIDList";
                par.sqlDbType = System.Data.SqlDbType.VarChar;
                par.sValue = sGroups;
                lstPar.Add(par);
                par = new Models.CSqlParameters();
                par.iLen = 4;
                par.pDirection = System.Data.ParameterDirection.Input;
                par.sName = "UserGroupID";
                par.sqlDbType = System.Data.SqlDbType.Int;
                par.sValue = sUserGroupID;
                lstPar.Add(par);
                par = new Models.CSqlParameters();
                par.iLen = 2;
                par.pDirection = System.Data.ParameterDirection.Input;
                par.sName = "GunGroupList";
                par.sqlDbType = System.Data.SqlDbType.VarChar;
                par.sValue = "";
                lstPar.Add(par);
                par = new Models.CSqlParameters();
                par.iLen = 8;
                par.pDirection = System.Data.ParameterDirection.Input;
                par.sName = "ExpirationTime";
                par.sqlDbType = System.Data.SqlDbType.DateTime;
                par.sValue = dt;
                lstPar.Add(par);
                par = new Models.CSqlParameters();
                par.iLen = 4;
                par.pDirection = System.Data.ParameterDirection.Input;
                par.sName = "RoleID";
                par.sqlDbType = System.Data.SqlDbType.Int;
                par.sValue = iRoleID;
                lstPar.Add(par);
                string sErr;
                Models.CErr cReturn = new Models.CErr();
                cReturn.result = BllSql.RunSqlProcedure(true, "Up_User", lstPar, out sErr);
                cReturn.err = sErr;
                BllCommon.AddOpNoteFromVehMgr("EditUser", 0, "", "", sUserName, sIP, iUserID, new object[] { 1, strName });
                string ss = JsonHelper.SerializeObject(cReturn);
                context.Response.Write(ss);
                return;

            }
            else if (iExeType == 4)
            {
                strSQL = "SELECT UserMain.UserID, UserMain.UserName, UserMain.Password, "
                    + "  UserMain.UserTypeID, UserMain.OwnerName, UserMain.sTel, UserMain.sMemo, "
                    + "   UserGroupDetail.UserGroupID, UserPermission.FuncID,UserMain.ExpirationTime,RoleID FROM UserMain"
                    + " inner join UserRole on UserRole.ID = UserMain.RoleID left JOIN "
                    + "   UserGroupDetail ON UserMain.UserID = UserGroupDetail.UserID left JOIN  UserPermission ON UserGroupDetail.UserID = UserPermission.UserID"
                    + "  WHERE (UserMain.UserID =" + iID.ToString() + ") ";
                System.Data.DataSet ds = BllSql.RunSqlSelect(strSQL);
                if (ds == null || ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0)
                {
                    context.Response.Write("{\"result\":false,\"err\":\"4012\"}");//"查询失败
                    return;
                }
                else
                {
                    Models.CUserDetail cDetail = new Models.CUserDetail();
                    cDetail.id = ds.Tables[0].Rows[0]["UserID"].ToString();
                    cDetail.name = ds.Tables[0].Rows[0]["UserName"].ToString();
                    cDetail.pwd = ds.Tables[0].Rows[0]["Password"].ToString();
                    cDetail.company = ds.Tables[0].Rows[0]["OwnerName"].ToString();
                    cDetail.tel = ds.Tables[0].Rows[0]["sTel"].ToString();
                    cDetail.userType = int.Parse(ds.Tables[0].Rows[0]["UserTypeID"].ToString());
                    cDetail.usergroup = int.Parse(ds.Tables[0].Rows[0]["UserGroupID"].ToString());
                    cDetail.permission = ds.Tables[0].Rows[0]["FuncID"].ToString();
                    cDetail.expirationTime = DateTime.Parse(ds.Tables[0].Rows[0]["ExpirationTime"].ToString()).ToString("yyyy-MM-dd HH:mm:ss");
                    cDetail.role = int.Parse(ds.Tables[0].Rows[0]["RoleID"].ToString());
                    cDetail.groups = "";
                    strSQL = "SELECT UserID, VehGroupID FROM User_VehGroup WHERE (UserID = " + iID.ToString() + ")";
                    ds = BllSql.RunSqlSelect(strSQL);
                    if (ds == null || ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0)
                    {

                    }
                    else
                    {
                        foreach (System.Data.DataRow dr in ds.Tables[0].Rows)
                        {
                            cDetail.groups = cDetail.groups + "," + dr["VehGroupID"].ToString();
                        }
                    }
                    if (cDetail.groups.Length > 0)
                    {
                        cDetail.groups = cDetail.groups.Substring(1);
                    }

                    string ss = JsonHelper.SerializeObject(cDetail);
                    context.Response.Write("{\"result\":true,\"data\":[" + ss + "]}");
                    return;
                }
            }
            else if (iExeType == 2)//删除
            {
                if (iID == 1 || strName.ToLower() == "system")
                {
                    context.Response.Write("{\"result\":false,\"err\":\"4015\"}");//"查询失败
                    return;
                }
                if (iID == iUserID)
                {
                    context.Response.Write("{\"result\":false,\"err\":\"4015\"}");//"查询失败
                    return;
                }
                strSQL = "UPDATE UserMain SET DelPurview = 1,UpdateTime='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "' where userid=" + iID.ToString() + " and userName='" + strName + "'";
                Models.CErr cReturn = new Models.CErr();
                string sErr;
                cReturn.result = BllSql.RunSqlExecute(strSQL, out sErr) > 0;
                cReturn.err = sErr;
                BllCommon.AddOpNoteFromVehMgr("DelUser", 0, "", "", sUserName, sIP, iUserID, new object[] { strName });
                string ss = JsonHelper.SerializeObject(cReturn);
                context.Response.Write(ss);
                return;
            }
            else if (iExeType == 1)//新添
            {
                string sErr = "";
                strSQL = "select 1 from usermain where username='" + strName + "'";
                if (BllSql.RunSqlScalar(strSQL) > 0)
                {
                    context.Response.Write("{\"result\":false,\"err\":\"4008\"}");//"查询失败
                    return;
                }
                System.Collections.Generic.List<Models.CSqlParameters> lstPar = new System.Collections.Generic.List<Models.CSqlParameters>();
                Models.CSqlParameters par = new Models.CSqlParameters();
                par.iLen = strName.Length;
                par.pDirection = System.Data.ParameterDirection.Input;
                par.sName = "UserName";
                par.sqlDbType = System.Data.SqlDbType.VarChar;
                par.sValue = strName;
                lstPar.Add(par);
                par = new Models.CSqlParameters();
                par.iLen = sNewPwd.Length;
                par.pDirection = System.Data.ParameterDirection.Input;
                par.sName = "Password";
                par.sqlDbType = System.Data.SqlDbType.VarChar;
                par.sValue = sNewPwd;
                lstPar.Add(par);
                par = new Models.CSqlParameters();
                par.iLen = 4;
                par.pDirection = System.Data.ParameterDirection.Input;
                par.sName = "UserTypeID";
                par.sqlDbType = System.Data.SqlDbType.Int;
                par.sValue = sAccountType;
                lstPar.Add(par);
                par = new Models.CSqlParameters();
                par.iLen = sCompanyName.Length + 2;
                par.pDirection = System.Data.ParameterDirection.Input;
                par.sName = "OwnerName";
                par.sqlDbType = System.Data.SqlDbType.VarChar;
                par.sValue = sCompanyName;
                lstPar.Add(par);
                par = new Models.CSqlParameters();
                par.iLen = sTel.Length + 2;
                par.pDirection = System.Data.ParameterDirection.Input;
                par.sName = "sTel";
                par.sqlDbType = System.Data.SqlDbType.VarChar;
                par.sValue = sTel;
                lstPar.Add(par);
                par = new Models.CSqlParameters();
                par.iLen = 2;
                par.pDirection = System.Data.ParameterDirection.Input;
                par.sName = "sMemo";
                par.sqlDbType = System.Data.SqlDbType.VarChar;
                par.sValue = "";
                lstPar.Add(par);
                par = new Models.CSqlParameters();
                par.iLen = 32;
                par.pDirection = System.Data.ParameterDirection.Input;
                par.sName = "timelimit";
                par.sqlDbType = System.Data.SqlDbType.VarChar;
                par.sValue = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                lstPar.Add(par);
                par = new Models.CSqlParameters();
                par.iLen = 32;
                par.pDirection = System.Data.ParameterDirection.Input;
                par.sName = "birthday";
                par.sqlDbType = System.Data.SqlDbType.VarChar;
                par.sValue = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                lstPar.Add(par);
                par = new Models.CSqlParameters();
                par.iLen = 4;
                par.pDirection = System.Data.ParameterDirection.Input;
                par.sName = "SignLimit";
                par.sqlDbType = System.Data.SqlDbType.Int;
                par.sValue = 0;
                lstPar.Add(par);
                par = new Models.CSqlParameters();
                par.iLen = sPermission.Length + 2;
                par.pDirection = System.Data.ParameterDirection.Input;
                par.sName = "FunList";
                par.sqlDbType = System.Data.SqlDbType.VarChar;
                par.sValue = sPermission;
                lstPar.Add(par);
                par = new Models.CSqlParameters();
                par.iLen = sGroups.Length + 2;
                par.pDirection = System.Data.ParameterDirection.Input;
                par.sName = "VGrouPIDList";
                par.sqlDbType = System.Data.SqlDbType.VarChar;
                par.sValue = sGroups;
                lstPar.Add(par);
                par = new Models.CSqlParameters();
                par.iLen = 4;
                par.pDirection = System.Data.ParameterDirection.Input;
                par.sName = "UserGroupID";
                par.sqlDbType = System.Data.SqlDbType.Int;
                par.sValue = sUserGroupID;
                lstPar.Add(par);
                par = new Models.CSqlParameters();
                par.iLen = 2;
                par.pDirection = System.Data.ParameterDirection.Input;
                par.sName = "GunGroup";
                par.sqlDbType = System.Data.SqlDbType.VarChar;
                par.sValue = "";
                lstPar.Add(par);
                par = new Models.CSqlParameters();
                par.iLen = 32;
                par.pDirection = System.Data.ParameterDirection.Input;
                par.sName = "ExpirationTime";
                par.sqlDbType = System.Data.SqlDbType.VarChar;
                par.sValue = dt.ToString("yyyy-MM-dd HH:mm:ss");
                lstPar.Add(par);
                par = new Models.CSqlParameters();
                par.iLen = 4;
                par.pDirection = System.Data.ParameterDirection.Input;
                par.sName = "RoleID";
                par.sqlDbType = System.Data.SqlDbType.Int;
                par.sValue = iRoleID;
                lstPar.Add(par);
                Models.CErr cReturn = new Models.CErr();
                object iNewID = BllSql.RunSqlScalarProcedureParameters(true, "Add_User", lstPar, out sErr);
                if (sErr.Length > 0)
                {
                    cReturn.result = false;
                    cReturn.err = sErr;
                }
                else
                {
                    cReturn.result = true;
                    cReturn.err = iNewID.ToString();
                }
                BllCommon.AddOpNoteFromVehMgr("EditUser", 0, "", "", sUserName, sIP, iUserID, new object[] { 0, strName });
                string ss = JsonHelper.SerializeObject(cReturn);
                context.Response.Write(ss);
                return;

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

    private bool SetNull(HttpContext context, ref string sName)
    {
        if (string.IsNullOrEmpty(sName))
        {
            sName = "";
            return true;
        }
        return SqlFilter.Filter.ProcessFilter(ref sName);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}