<%@ WebHandler Language="C#" Class="MngVehGroup" %>

using System;
using System.Web;

public class MngVehGroup : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        int CheckResult = 0;
        try
        {
            int iExeType = Convert.ToInt32(context.Request["DoType"]);   //请求类型
            int iGroupID = Convert.ToInt32(context.Request["GroupID"]);   //ID
            int pGroupID = Convert.ToInt32(context.Request["Pid"]);   //父车组
            string strGroupName = context.Request["GroupName"];
            string strContact = context.Request["Contact"];
            string strTel1 = context.Request["Tel1"];
            string strTel2 = context.Request["Tel2"];
            string strAddress = context.Request["Marks"];
            string sUserName = context.Request["UserName"];
            string sPwd = context.Request["Pwd"];
            string sOldName = context.Request["OldName"];
            string sIP = context.Request.ServerVariables.Get("Remote_Addr").ToString(); 
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
            if (string.IsNullOrEmpty(strGroupName) || string.IsNullOrEmpty(strContact))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4012\"}");
                return;
            }
            if (!SqlFilter.Filter.ProcessFilter(ref strGroupName) || !SqlFilter.Filter.ProcessFilter(ref strContact) || !SqlFilter.Filter.ProcessFilter(ref strTel1) || !SqlFilter.Filter.ProcessFilter(ref strTel2) || !SqlFilter.Filter.ProcessFilter(ref strAddress) || !SqlFilter.Filter.ProcessFilter(ref sOldName))
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
                //判断车组名是否存在
                strSQL = "if exists(SELECT VehGroupID FROM VehGroupMain Where VehGroupName='" + strGroupName + "' and VehGroupID!=" + iGroupID.ToString() + ") select 1 else "
                         + " begin  if exists(SELECT VehGroupID FROM VehGroupMain Where  VehGroupID=" + iGroupID.ToString() + ") select 0  else select 2 end";
                CheckResult = BllSql.RunSqlScalar(strSQL);

                if (CheckResult == 1)
                {
                    context.Response.Write("{\"result\":false,\"err\":\"4008\"}");//"数据库中存在同样的车组名！"
                    return;
                }
                else if (CheckResult == 2)
                {
                    context.Response.Write("{\"result\":false,\"err\":\"4009\"}");//"数据库中不存在此车组，可能已经被其他用户删除了！
                    return;
                }

                //判断车组是不是在自己名下，
                if (iGroupID == pGroupID)
                {
                    pGroupID = -1;
                }
                else
                {
                    string strChild = BllVehicle.GetChildUserID(iGroupID);
                    string[] astrTemp;
                    if (strChild.Length > 0)
                    {
                        astrTemp = strChild.Split(',');
                        for (int i = 0; i < astrTemp.Length; i++)
                        {
                            if (astrTemp[i].Trim() == pGroupID.ToString())
                            {
                                context.Response.Write("{\"result\":false,\"err\":\"4010\"}");//"编辑失败，不允许将自己添加到自己下面的车队！
                                return;
                            }
                        }
                    }
                }
                //更新父子关系表
                int iOldParentGroup;
                strSQL = "select fVehGroupID from VehGroupDetail where VehGroupID = " + iGroupID.ToString();
                iOldParentGroup = BllSql.RunSqlScalar(strSQL);
                //更新基本信息
                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                sb.Append("UPDATE VehGroupMain SET VehGroupName ='" + strGroupName
                            + "', Contact ='" + strContact
                            + "', sTel1 ='" + strTel1
                            + "', sTel2 ='" + strTel2
                            + "', Address ='" + strAddress
                            + "' ,UpdateTime='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "' where  VehGroupID =" + iGroupID.ToString());

                //更新父子关系表
                if (iOldParentGroup != pGroupID)
                {
                    sb.AppendLine(" exec UpdateUserVersion @GroupID = " + iGroupID.ToString());
                }

                sb.AppendLine(" DELETE FROM VehGroupDetail WHERE (VehGroupID = " + iGroupID.ToString() + ")");

                sb.AppendLine(" INSERT INTO VehGroupDetail(VehGroupID, fVehGroupID) "
                         + " VALUES(" + iGroupID.ToString() + "," + pGroupID.ToString() + " )");


                sb.AppendLine(" exec UpdateUserVersion @GroupID = " + iGroupID.ToString());
                string sErr = "";
                if (BllSql.RunSqlNonQueryParameters(true, sb.ToString(), new System.Collections.Generic.List<Models.CSqlParameters>(), out sErr))
                {
                    iExeResult = 1;
                    //g_IsUpdateData = True
                }
                else
                {
                    iExeResult = 0;
                }
                Models.CErr cReturn = new Models.CErr();
                cReturn.result = iExeResult == 1;
                cReturn.err = "4006";
                if (cReturn.result)
                {
                    BllCommon.AddOpNoteFromVehMgr("EditVehGroup", 0, "", "", sUserName, sIP, iUserID, new object[] { 0, sOldName, strGroupName });
                }
                string ss = JsonHelper.SerializeObject(cReturn);
                context.Response.Write(ss);
                return;
            }
            else if (iExeType == 4)
            {
                strSQL = "select VehGroupID,VehGroupName,Contact,sTel1,sTel2,Address from VehGroupMain where VehGroupID = " + iGroupID.ToString();
                System.Data.DataSet ds = BllSql.RunSqlSelect(strSQL);
                if (ds == null || ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0)
                {
                    context.Response.Write("{\"result\":false,\"err\":\"4012\"}");//"编辑失败，不允许将自己添加到自己下面的车队！
                    return;
                }
                else
                {
                    Models.CVehGroupDetail cDetail = new Models.CVehGroupDetail();
                    cDetail.Address = ds.Tables[0].Rows[0]["Address"].ToString();
                    cDetail.Contact = ds.Tables[0].Rows[0]["Contact"].ToString();
                    cDetail.sTel1 = ds.Tables[0].Rows[0]["sTel1"].ToString();
                    cDetail.sTel2 = ds.Tables[0].Rows[0]["sTel2"].ToString();
                    cDetail.VehGroupID = Convert.ToInt32(ds.Tables[0].Rows[0]["VehGroupID"]);
                    cDetail.VehGroupName = ds.Tables[0].Rows[0]["VehGroupName"].ToString();
                    string ss = JsonHelper.SerializeObject(cDetail);
                    context.Response.Write("{\"result\":true,\"data\":[" + ss + "]}");
                    return;
                }
            }
            else if (iExeType == 2)//删除
            {
                string strGroupList = "";
                string strVehList = "";
                BllCommon.RecursiveVehGroup(iGroupID, ref strGroupList);
                if (strGroupList.Length > 0)
                {
                    strGroupList +=  "," + iGroupID.ToString();
                }
                else
                {
                    strGroupList = iGroupID.ToString();
                }
                string arrParentGroupID = "";
                BllCommon.RecursiveVehParentGroup(iGroupID, ref arrParentGroupID);
                //读出所有车组名下的车辆
                strSQL = "SELECT Vehicle.Id FROM Vehicle INNER JOIN VehicleDetail ON Vehicle.Id = VehicleDetail.VehID WHERE VehicleDetail.VehGroupID in ( " + strGroupList + ") ";
                System.Data.SqlClient.SqlConnection sqlCon = null;
                System.Data.SqlClient.SqlTransaction trans = null;
                try
                {
                    sqlCon = new System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings["conn"]);
                    System.Data.SqlClient.SqlCommand sqlCmd = new System.Data.SqlClient.SqlCommand(strSQL, sqlCon);
                    sqlCmd.CommandType = System.Data.CommandType.Text;//设置调用的类型为存储过程  
                    sqlCon.Open();
                    trans = sqlCon.BeginTransaction();
                    sqlCmd.Transaction = trans;
                    System.Data.SqlClient.SqlDataAdapter da = new System.Data.SqlClient.SqlDataAdapter(sqlCmd);
                    System.Data.DataSet ds = new System.Data.DataSet();
                    da.Fill(ds, "table");
                    if (ds == null || ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0)
                    {
                        
                    }
                    else
                    {
                        for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                        {
                            if (strVehList.Trim() == "")
                            {
                                strVehList = ds.Tables[0].Rows[i]["id"].ToString();
                            }
                            else
                            {
                                strVehList = strVehList + "," + ds.Tables[0].Rows[i]["id"].ToString();
                            }
                        }
                    }
                    //在车组表按车组ID，删除这指车组记录
                    strSQL = "UPDATE VehGroupMain SET DelFlag = 1,UpdateTime='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "' Where Vehgroupid in(" + strGroupList + ")";

                    sqlCmd.CommandText = strSQL;
                    sqlCmd.ExecuteNonQuery();

                    //在车组关系表中删除这批车组记录
                    if (arrParentGroupID.Length > 0)
                    {
                        strGroupList = strGroupList + "," + arrParentGroupID;
                    }
                    strSQL = "update usermain set Version = Version + 1 where UserID in (select UserID from User_VehGroup where VehGroupID in(" + strGroupList + "))";
                    sqlCmd.CommandText = strSQL;
                    sqlCmd.ExecuteNonQuery();


                    //在车辆表删除这批车
                    if (strVehList.Length > 0)
                    {
                        strSQL = "UPDATE Vehicle SET DelFlag = 1,UpdateTime='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "' WHERE ID In(" + strVehList + ")";
                        sqlCmd.CommandText = strSQL;
                        sqlCmd.ExecuteNonQuery();
                    }
                    trans.Commit();
                    Models.CErr cReturn = new Models.CErr();
                    cReturn.result = true;
                    cReturn.err = "";
                    BllCommon.AddOpNoteFromVehMgr("DelUserGroup", 0, "", "", sUserName, sIP, iUserID, new object[] { strGroupName, iGroupID });
                    string ss = JsonHelper.SerializeObject(cReturn);
                    context.Response.Write(ss);
                    return;
                    //strInfo = "操作成功完成！"
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
                //判断车组名是否存在
                strSQL = "SELECT VehGroupID FROM VehGroupMain Where VehGroupName='" + strGroupName + "'";
                System.Data.DataSet ds = BllSql.RunSqlSelect(strSQL);
                if (ds == null || ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0)
                {

                }
                else
                {
                    context.Response.Write("{\"result\":false,\"err\":\"4011\"}");//"编辑失败，不允许将自己添加到自己下面的车队！
                    return;
                }
                iGroupID = 1;

                //插入基本信息
                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                sb.Append("INSERT INTO VehGroupMain (VehGroupName, Contact, sTel1, sTel2, Address) "
                         + " VALUES('" + strGroupName + "' ,'" + strContact + "' , '" + strTel1 + "','" + strTel2 + "' , '" + strAddress + "') set @return = @@IDENTITY");

                //插入父子关系表

                sb.AppendLine(" INSERT INTO VehGroupDetail(VehGroupID, fVehGroupID) "
                         + " VALUES(@return," + pGroupID.ToString() + " )");

                if (pGroupID < 1)
                {
                    sb.AppendLine(" insert into User_VehGroup(UserID,VehGroupID) values(" + iUserID.ToString() + ",@return)");
                }

                sb.AppendLine(" exec UpdateUserVersion @GroupID = @return");
                string sErr = "";
                System.Collections.Generic.List<Models.CSqlParameters> lstPar = new System.Collections.Generic.List<Models.CSqlParameters>();
                Models.CSqlParameters par = new Models.CSqlParameters();
                par.iLen = 4;
                par.pDirection = System.Data.ParameterDirection.Output;
                par.sName = "return";
                par.sqlDbType = System.Data.SqlDbType.Int;
                lstPar.Add(par);
                if (BllSql.RunSqlNonQueryParameters(true, sb.ToString(), lstPar, out sErr))
                {
                    iExeResult = 1;
                    iGroupID = int.Parse(sErr);
                    //g_IsUpdateData = True
                    //strExeResult = "添加车组资料成功完成！" 
                }
                else
                {
                    iExeResult = 0;
                }
                Models.CErr cReturn = new Models.CErr();
                cReturn.result = iExeResult == 1;
                cReturn.err = "4006";
                if (cReturn.result)
                {
                    cReturn.err = iGroupID.ToString();
                    BllCommon.AddOpNoteFromVehMgr("EditVehGroup", 0, "", "", sUserName, sIP, iUserID, new object[] { 1, strGroupName, strGroupName });
                }
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
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}