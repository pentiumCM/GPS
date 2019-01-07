<%@ WebHandler Language="C#" Class="MngBinQuery" %>

using System;
using System.Web;

public class MngBinQuery : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        int CheckResult = 0;
        try
        {
            int iExeType = Convert.ToInt32(context.Request["DoType"]);   //请求类型
            string strName = context.Request["Name"];
            string sIP = context.Request.ServerVariables.Get("Remote_Addr").ToString();
            string sUserName = context.Request["username"];
            string sPwd = context.Request["Pwd"];
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
            int iUserType = 3;

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
                                iUserType = Convert.ToInt32(ds.Tables[0].Rows[0]["UserTypeID"]);
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

            if (iExeType == 1) //获取车组
            {
                if (iUserID == 1)
                {
                    strSQL = "SELECT VehGroupMain.VehGroupID, VehGroupMain.VehGroupName, "
                                + "     VehGroupMain.Address, VehGroupDetail.fVehGroupID "
                                + " FROM VehGroupMain left JOIN "
                                + "      VehGroupDetail ON "
                                + "            VehGroupMain.VehGroupID = VehGroupDetail.VehGroupID where (VehGroupMain.delflag=1)";

                }
                else
                {
                    //取所有列表ID
                    string strGroupList = BllVehicle.GetAllVehGroupByUserID(iUserID);

                    if (strGroupList.Trim().Length == 0)
                    {
                        strGroupList = "0";
                    }

                    strSQL = "SELECT VehGroupMain.VehGroupID, VehGroupMain.VehGroupName, "
                                + "     VehGroupMain.Address, VehGroupDetail.fVehGroupID "
                                + " FROM VehGroupMain left JOIN "
                                + "      VehGroupDetail ON "
                                + "            VehGroupMain.VehGroupID = VehGroupDetail.VehGroupID "
                               + "WHERE (VehGroupMain.VehGroupID IN (" + strGroupList + ")) and (VehGroupMain.delflag=1)";
                }
                System.Data.DataSet ds = BllSql.RunSqlSelect(strSQL);
                if (ds == null || ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0)
                {
                    System.Collections.Generic.List<Models.CVehGroupDetail> lstGroup = new System.Collections.Generic.List<Models.CVehGroupDetail>();
                    string ss = JsonHelper.SerializeObject(lstGroup);
                    context.Response.Write("{\"result\":true,\"data\":" + ss + "}");
                    return;
                }
                else
                {
                    System.Collections.Generic.List<Models.CVehGroupDetail> lstGroup = new System.Collections.Generic.List<Models.CVehGroupDetail>();
                    Models.CVehGroupDetail cDetail = new Models.CVehGroupDetail();
                    foreach (System.Data.DataRow dr in ds.Tables[0].Rows)
                    {
                        cDetail = new Models.CVehGroupDetail();
                        cDetail.Address = dr["Address"].ToString();
                        cDetail.Contact = "";
                        cDetail.sTel1 = "";
                        cDetail.sTel2 = "";
                        cDetail.VehGroupID = Convert.ToInt32(dr["VehGroupID"]);
                        cDetail.VehGroupName = dr["VehGroupName"].ToString();
                        cDetail.PID = Convert.ToInt32(dr["fVehGroupID"]);
                        lstGroup.Add(cDetail);
                    }
                    string ss = JsonHelper.SerializeObject(lstGroup);
                    context.Response.Write("{\"result\":true,\"data\":" + ss + "}");
                    return;
                }
            }
            else if (iExeType == 2) //获取车辆
            {
                if (iUserID == 1)
                {
                    strSQL = "SELECT Id, Deviceid, IpAddress, Cph, OwnNo,ProductCode, "
                         + "  TaxiNo, Marks, VehicleDetail.VehGroupID  from Vehicle INNER JOIN VehicleDetail ON Vehicle.Id = VehicleDetail.VehID where (Vehicle.delflag is null) or (Vehicle.delflag=1)";
                }
                else
                {
                    //取所有列表ID
                    string strGroupList = BllVehicle.GetAllVehGroupByUserID(iUserID);

                    if (strGroupList.Trim().Length == 0)
                    {
                        strGroupList = "0";
                    }

                    strSQL = "SELECT Id, Deviceid, IpAddress, Cph, OwnNo,ProductCode, "
                         + "  TaxiNo, Marks,  VehicleDetail.VehGroupID  from Vehicle INNER JOIN VehicleDetail ON Vehicle.Id = VehicleDetail.VehID where VehicleDetail.VehGroupID in (" + strGroupList + ") and ((Vehicle.delflag is null) or (Vehicle.delflag=1))";
                }
                System.Data.DataSet ds = BllSql.RunSqlSelect(strSQL);
                if (ds == null || ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0)
                {
                    System.Collections.Generic.List<Models.CVehicle> lstGroup = new System.Collections.Generic.List<Models.CVehicle>();
                    string ss = JsonHelper.SerializeObject(lstGroup);
                    context.Response.Write("{\"result\":true,\"data\":" + ss + "}");
                    return;
                }
                else
                {
                    System.Collections.Generic.List<Models.CVehicle> lstGroup = new System.Collections.Generic.List<Models.CVehicle>();
                    Models.CVehicle cDetail = new Models.CVehicle();
                    foreach (System.Data.DataRow dr in ds.Tables[0].Rows)
                    {
                        cDetail = new Models.CVehicle();
                        cDetail.customid = dr["ProductCode"].ToString();
                        cDetail.GID = dr["VehGroupID"].ToString();
                        cDetail.id = dr["Id"].ToString();
                        cDetail.ipaddress = dr["IpAddress"].ToString();
                        cDetail.name = dr["Cph"].ToString();
                        cDetail.sim = dr["Deviceid"].ToString();
                        cDetail.taxino = dr["TaxiNo"].ToString();
                        lstGroup.Add(cDetail);
                    }
                    string ss = JsonHelper.SerializeObject(lstGroup);
                    context.Response.Write("{\"result\":true,\"data\":" + ss + "}");
                    return;
                }
            }
            else if (iExeType == 3) //获取用户组
            {
                if (iUserType != 1)
                {
                    context.Response.Write("{\"result\":false,\"err\":\"4015\"}");
                    return;
                }
                strSQL = "select UserGroupID,UserGroupName,UserGroupMemo from UserGroupMain where DelFlag=1";
                System.Data.DataSet ds = BllSql.RunSqlSelect(strSQL);
                if (ds == null || ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0)
                {
                    System.Collections.Generic.List<Models.CUserGroup> lstGroup = new System.Collections.Generic.List<Models.CUserGroup>();
                    string ss = JsonHelper.SerializeObject(lstGroup);
                    context.Response.Write("{\"result\":true,\"data\":" + ss + "}");
                    return;
                }
                else
                {
                    System.Collections.Generic.List<Models.CUserGroup> lstGroup = new System.Collections.Generic.List<Models.CUserGroup>();
                    Models.CUserGroup cDetail = new Models.CUserGroup();
                    foreach (System.Data.DataRow dr in ds.Tables[0].Rows)
                    {
                        cDetail = new Models.CUserGroup();
                        cDetail.HasChild = 0;
                        cDetail.id = dr["UserGroupID"].ToString();
                        cDetail.name = dr["UserGroupName"].ToString();
                        cDetail.PID = "M_User";
                        cDetail.Root = 0;
                        lstGroup.Add(cDetail);
                    }
                    string ss = JsonHelper.SerializeObject(lstGroup);
                    context.Response.Write("{\"result\":true,\"data\":" + ss + "}");
                    return;
                }
            }
            else if (iExeType == 4) //获取用户
            {
                if (iUserType != 1)
                {
                    context.Response.Write("{\"result\":false,\"err\":\"4015\"}");
                    return;
                }
                if (iUserID == 1)
                {
                    strSQL = "SELECT UserMain.userid, UserMain.UserName, "
                        + " UserMain.UserTypeID, UserGroupDetail.UserGroupID FROM UserMain LEFT OUTER  JOIN "
                        + " UserGroupDetail ON UserMain.UserID = UserGroupDetail.UserID where (DelPurview = 1 ) ";
                }
                else
                {
                    strSQL = "SELECT UserMain.userid, UserMain.UserName, "
                        + " UserMain.UserTypeID,UserGroupDetail.UserGroupID FROM UserMain LEFT OUTER  JOIN "
                        + " UserGroupDetail ON UserMain.UserID = UserGroupDetail.UserID where (DelPurview = 1 ) and UserGroupDetail.UserGroupID=(select top 1 UserGroupID from UserGroupDetail where UserID=" + iUserID.ToString() + ") ";
                }
                System.Data.DataSet ds = BllSql.RunSqlSelect(strSQL);
                if (ds == null || ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0)
                {
                    System.Collections.Generic.List<Models.CUser> lstGroup = new System.Collections.Generic.List<Models.CUser>();
                    string ss = JsonHelper.SerializeObject(lstGroup);
                    context.Response.Write("{\"result\":true,\"data\":" + ss + "}");
                    return;
                }
                else
                {
                    System.Collections.Generic.List<Models.CUser> lstGroup = new System.Collections.Generic.List<Models.CUser>();
                    Models.CUser cDetail = new Models.CUser();
                    foreach (System.Data.DataRow dr in ds.Tables[0].Rows)
                    {
                        cDetail = new Models.CUser();
                        cDetail.HasChild = 0;
                        cDetail.id = dr["userid"].ToString();
                        cDetail.name = dr["UserName"].ToString();
                        cDetail.PID = dr["UserGroupID"].ToString();
                        lstGroup.Add(cDetail);
                    }
                    string ss = JsonHelper.SerializeObject(lstGroup);
                    context.Response.Write("{\"result\":true,\"data\":" + ss + "}");
                    return;
                }
            }
            else if (iExeType == 5) //回收车组
            {
                if (iUserType == 3)
                {
                    context.Response.Write("{\"result\":false,\"err\":\"4015\"}");
                    return;
                }
                string sErr = "";
                int iGroupID = Convert.ToInt32(context.Request["ID"]);
                int iOpType = Convert.ToInt32(context.Request["OpType"]);
                string sOperName = context.Request["OperName"];
                if (string.IsNullOrEmpty(sOperName))
                {
                    context.Response.Write("{\"result\":false,\"err\":\"4012\"}");
                    return;
                }
                if (!SqlFilter.Filter.ProcessFilter(ref sOperName))
                {
                    context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                    return;
                }

                System.Collections.Generic.List<Models.CSqlParameters> lstPar = new System.Collections.Generic.List<Models.CSqlParameters>();
                Models.CSqlParameters par = new Models.CSqlParameters();
                par.iLen = 4;
                par.pDirection = System.Data.ParameterDirection.Input;
                par.sName = "GroupID";
                par.sqlDbType = System.Data.SqlDbType.Int;
                par.sValue = iGroupID;
                lstPar.Add(par);
                par = new Models.CSqlParameters();
                par.iLen = 4;
                par.pDirection = System.Data.ParameterDirection.Input;
                par.sName = "OpType";
                par.sqlDbType = System.Data.SqlDbType.Int;
                par.sValue = iOpType;
                lstPar.Add(par);
                object oResult = BllSql.RunSqlScalarProcedureParameters(true, "op_RecycleVehGroup", lstPar, out sErr);
                if (sErr.Length > 0)
                {
                    context.Response.Write("{\"result\":false,\"err\":\"4006\"}");
                    return;
                }
                int iResult = 0;
                if (!int.TryParse(oResult.ToString(), out iResult))
                {
                    context.Response.Write("{\"result\":false,\"err\":\"4017\"}");
                    return;
                }
                if (iResult != 1 && iResult != 2)
                {
                    context.Response.Write("{\"result\":false,\"err\":\"4006\"}");
                    return;
                }
                BllCommon.AddOpNoteFromVehMgr("RecycleVehGroup", 0, "", "", sUserName, sIP, iUserID, new object[] { iOpType, sOperName });
                
                context.Response.Write("{\"result\":true,\"err\":" + iResult.ToString() + "}");
                
                return;
            }
            else if (iExeType == 6) //回收车辆
            {
                if (iUserType == 3)
                {
                    context.Response.Write("{\"result\":false,\"err\":\"4015\"}");
                    return;
                }
                string sErr = "";
                int iGroupID = Convert.ToInt32(context.Request["ID"]);
                int iOpType = Convert.ToInt32(context.Request["OpType"]);
                int iPID = Convert.ToInt32(context.Request["PID"]);
                string sOperName = context.Request["OperName"];
                if (string.IsNullOrEmpty(sOperName))
                {
                    context.Response.Write("{\"result\":false,\"err\":\"4012\"}");
                    return;
                }
                if (!SqlFilter.Filter.ProcessFilter(ref sOperName))
                {
                    context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                    return;
                }

                System.Collections.Generic.List<Models.CSqlParameters> lstPar = new System.Collections.Generic.List<Models.CSqlParameters>();
                Models.CSqlParameters par = new Models.CSqlParameters();
                par.iLen = 4;
                par.pDirection = System.Data.ParameterDirection.Input;
                par.sName = "VehID";
                par.sqlDbType = System.Data.SqlDbType.Int;
                par.sValue = iGroupID;
                lstPar.Add(par);
                par = new Models.CSqlParameters();
                par.iLen = 4;
                par.pDirection = System.Data.ParameterDirection.Input;
                par.sName = "ToGroupID";
                par.sqlDbType = System.Data.SqlDbType.Int;
                par.sValue = iPID;
                lstPar.Add(par);
                par = new Models.CSqlParameters();
                par.iLen = 4;
                par.pDirection = System.Data.ParameterDirection.Input;
                par.sName = "OpType";
                par.sqlDbType = System.Data.SqlDbType.Int;
                par.sValue = iOpType;
                lstPar.Add(par);
                object oResult = BllSql.RunSqlScalarProcedureParameters(true, "op_RecycleVehicle", lstPar, out sErr);
                if (sErr.Length > 0)
                {
                    context.Response.Write("{\"result\":false,\"err\":\"4006\"}");
                    return;
                }
                int iResult = 0;
                if (!int.TryParse(oResult.ToString(), out iResult) || iResult == 0)
                {
                    context.Response.Write("{\"result\":false,\"err\":\"4016\"}");
                    return;
                }
                if (iResult != 1 && iResult != 2)
                {
                    context.Response.Write("{\"result\":false,\"err\":\"4006\"}");
                    return;
                }
                BllCommon.AddOpNoteFromVehMgr("RecycleVehicle", 0, "", "", sUserName, sIP, iUserID, new object[] { iOpType, sOperName });

                context.Response.Write("{\"result\":true,\"err\":" + iResult.ToString() + "}");

                return;
            }
            else if (iExeType == 7) //回收用户组
            {
                if (iUserType != 1)
                {
                    context.Response.Write("{\"result\":false,\"err\":\"4015\"}");
                    return;
                }
                string sErr = "";
                int iGroupID = Convert.ToInt32(context.Request["ID"]);
                int iOpType = Convert.ToInt32(context.Request["OpType"]);
                string sOperName = context.Request["OperName"];
                if (string.IsNullOrEmpty(sOperName))
                {
                    context.Response.Write("{\"result\":false,\"err\":\"4012\"}");
                    return;
                }
                if (!SqlFilter.Filter.ProcessFilter(ref sOperName))
                {
                    context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                    return;
                }

                System.Collections.Generic.List<Models.CSqlParameters> lstPar = new System.Collections.Generic.List<Models.CSqlParameters>();
                Models.CSqlParameters par = new Models.CSqlParameters();
                par.iLen = 4;
                par.pDirection = System.Data.ParameterDirection.Input;
                par.sName = "GroupID";
                par.sqlDbType = System.Data.SqlDbType.Int;
                par.sValue = iGroupID;
                lstPar.Add(par);
                par = new Models.CSqlParameters();
                par.iLen = 4;
                par.pDirection = System.Data.ParameterDirection.Input;
                par.sName = "OpType";
                par.sqlDbType = System.Data.SqlDbType.Int;
                par.sValue = iOpType;
                lstPar.Add(par);
                object oResult = BllSql.RunSqlScalarProcedureParameters(true, "op_RecycleUserGroup", lstPar, out sErr);
                if (sErr.Length > 0)
                {
                    context.Response.Write("{\"result\":false,\"err\":\"4006\"}");
                    return;
                }
                int iResult = 0;
                if (!int.TryParse(oResult.ToString(), out iResult) || iResult == 0)
                {
                    context.Response.Write("{\"result\":false,\"err\":\"4018\"}");
                    return;
                }
                if (iResult != 1 && iResult != 2)
                {
                    context.Response.Write("{\"result\":false,\"err\":\"4006\"}");
                    return;
                }
                BllCommon.AddOpNoteFromVehMgr("RecycleUserGroup", 0, "", "", sUserName, sIP, iUserID, new object[] { iOpType, sOperName });

                context.Response.Write("{\"result\":true,\"err\":" + iResult.ToString() + "}");

                return;
            }
            else if (iExeType == 8) //回收用户
            {
                if (iUserType != 1)
                {
                    context.Response.Write("{\"result\":false,\"err\":\"4015\"}");
                    return;
                }
                string sErr = "";
                int iGroupID = Convert.ToInt32(context.Request["ID"]);
                int iOpType = Convert.ToInt32(context.Request["OpType"]);
                int iPID = Convert.ToInt32(context.Request["PID"]);
                string sOperName = context.Request["OperName"];
                if (string.IsNullOrEmpty(sOperName))
                {
                    context.Response.Write("{\"result\":false,\"err\":\"4012\"}");
                    return;
                }
                if (!SqlFilter.Filter.ProcessFilter(ref sOperName))
                {
                    context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                    return;
                }

                System.Collections.Generic.List<Models.CSqlParameters> lstPar = new System.Collections.Generic.List<Models.CSqlParameters>();
                Models.CSqlParameters par = new Models.CSqlParameters();
                par.iLen = 4;
                par.pDirection = System.Data.ParameterDirection.Input;
                par.sName = "UserID";
                par.sqlDbType = System.Data.SqlDbType.Int;
                par.sValue = iGroupID;
                lstPar.Add(par);
                par = new Models.CSqlParameters();
                par.iLen = 4;
                par.pDirection = System.Data.ParameterDirection.Input;
                par.sName = "ToGroupID";
                par.sqlDbType = System.Data.SqlDbType.Int;
                par.sValue = iPID;
                lstPar.Add(par);
                par = new Models.CSqlParameters();
                par.iLen = 4;
                par.pDirection = System.Data.ParameterDirection.Input;
                par.sName = "OpType";
                par.sqlDbType = System.Data.SqlDbType.Int;
                par.sValue = iOpType;
                lstPar.Add(par);
                object oResult = BllSql.RunSqlScalarProcedureParameters(true, "op_RecycleUser", lstPar, out sErr);
                if (sErr.Length > 0)
                {
                    context.Response.Write("{\"result\":false,\"err\":\"4006\"}");
                    return;
                }
                int iResult = 0;
                if (!int.TryParse(oResult.ToString(), out iResult) || iResult == 0)
                {
                    context.Response.Write("{\"result\":false,\"err\":\"4019\"}");
                    return;
                }
                if (iResult != 1 && iResult != 2)
                {
                    context.Response.Write("{\"result\":false,\"err\":\"4006\"}");
                    return;
                }
                BllCommon.AddOpNoteFromVehMgr("op_RecycleUser", 0, "", "", sUserName, sIP, iUserID, new object[] { iOpType, sOperName });

                context.Response.Write("{\"result\":true,\"err\":" + iResult.ToString() + "}");

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
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}