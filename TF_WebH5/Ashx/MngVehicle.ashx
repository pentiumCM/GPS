<%@ WebHandler Language="C#" Class="MngVehicle" %>

using System;
using System.Web;

public class MngVehicle : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        int CheckResult = 0;
        try
        {
            int iExeType = Convert.ToInt32(context.Request["DoType"]);   //请求类型
            string sUserName = context.Request["username"];
            string sPwd = context.Request["Pwd"];
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
            if (iExeType == 2) //删除
            {
                string sID = context.Request["ID"];
                string sName = context.Request["Name"];
                if (string.IsNullOrEmpty(sID) || string.IsNullOrEmpty(sName))
                {
                    context.Response.Write("{\"result\":false,\"err\":\"4012\"}");
                    return;
                }
                if (!SqlFilter.Filter.ProcessFilter(ref sID) || !SqlFilter.Filter.ProcessFilter(ref sName))
                {
                    context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                    return;
                }
                string strSQL2 = " select top 1 GunID from Gun where IsDel = 0 and ((VehID1 > 0 and VehID1 = " + sID + ") or (VehID2 > 0 and VehID2 = " + sID + ")) ";
                int iGunID = BllSql.RunSqlScalar(strSQL2);
                int iResult = 0;
                string strResult = "";
                if (iGunID > 0)
                {
                    iResult = 0;
                    strResult = "该定位器被物资编号【" + iGunID.ToString() + "】占用了，请先删除枪支或解除绑定关系！";
                }

                strSQL2 = "UPDATE Vehicle SET DelFlag =1,State=" + iUserID.ToString() + ", UpdateTime='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "' where Id =" + sID + " and  Cph ='" + sName + "'";

                if (strResult.Length == 0)
                {
                    string sErr = "";
                    iResult = BllSql.RunSqlExecute(strSQL2, out sErr);
                    strResult = sErr;
                }
                Models.CErr cReturn = new Models.CErr();
                cReturn.result = iResult > 0;
                cReturn.err = strResult;
                BllCommon.AddOpNoteFromVehMgr("DelVeh", int.Parse(sID), "", "", sUserName, sIP, iUserID, new object[] { sID, sName });
                string ss = JsonHelper.SerializeObject(cReturn);
                context.Response.Write(ss);
                return;
            }
            string txtPlateNO = context.Request["PlateNO"];
            string txtIpAddress = context.Request["IpAddress"];
            string txtSim = context.Request["Sim"];
            string txtTaxiNo = context.Request["TaxiNo"];
            string VehID = context.Request["VehID"];
            int iVehID = int.Parse(VehID);
            string sGID = context.Request["GID"];
            int iVehGroupID = int.Parse(sGID);
            string sOldName = context.Request["OldName"];
            //基本资料
            string txtCustomNum = context.Request["CustomNum"];
            string txtVendorCode = "";
            string txtServerPwd = context.Request["ServerPwd"];
            string txtPlateColor = context.Request["PlateColor"];
            string txtCarColor = context.Request["CarColor"];
            string txtCarType = context.Request["CarType"];
            string txtEngineNumber = context.Request["EngineNumber"];
            string txtFrameNumber = context.Request["FrameNumber"];
            string txtInstallDate = context.Request["InstallDate"];
            string txtPowerType = context.Request["PowerType"];
            //其它资料
            string txtOwnerName = context.Request["OwnerName"];
            string txtSex = context.Request["Sex"];
            string txtTel = context.Request["Tel"];
            string txtEmail = context.Request["Email"];
            string txtContact1 = context.Request["Contact1"];
            string txtTel1 = context.Request["Tel1"];
            string txtContact2 = context.Request["Contact2"];
            string txtTel2 = context.Request["Tel2"];
            string txtIdentityCard = context.Request["IdentityCard"];
            string txtPostalCode = context.Request["PostalCode"];
            string txtWorkUnit = context.Request["WorkUnit"];
            string txtDriverName = context.Request["DriverName"];
            string txtAddress = context.Request["Address"];
            //中心资料
            string txtInstallPerson = context.Request["InstallPerson"];
            string txtTonOrSeats = context.Request["TonOrSeats"];
            string txtOperationRoute = context.Request["OperationRoute"];
            string txtTransportLicenseID = context.Request["TransportLicenseID"];
            string txtMoney = context.Request["Money"];
            string txtPurchaseDate = context.Request["PurchaseDate"];
            string txtServerEndTime = context.Request["ServerEndTime"];
            string txtEnrolDate = context.Request["EnrolDate"];
            string txtAnnualInspectionRepairTime = context.Request["AnnualInspectionRepairTime"];
            string txtVehLevel2MaintenanceTime = context.Request["VehLevel2MaintenanceTime"];
            //备注
            string txtMarks = context.Request["Marks"];
            System.Collections.Generic.List<Models.CKeyValue> lstKV = new System.Collections.Generic.List<Models.CKeyValue>();
            if (!SetNull(context, ref txtPlateNO))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            if (!SetNull(context, ref sOldName))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            if (!SetNull(context, ref txtIpAddress))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            if (!SetNull(context, ref txtSim))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            if (!SetNull(context, ref txtTaxiNo))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            //基本资料
            if (!SetNull(context, ref txtCustomNum))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            if (!SetNull(context, ref txtVendorCode))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            if (!SetNull(context, ref txtServerPwd))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            if (!SetNull(context, ref txtPlateColor))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            if (!SetNull(context, ref txtCarColor))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            if (!SetNull(context, ref txtCarType))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            if (!SetNull(context, ref txtEngineNumber))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            if (!SetNull(context, ref txtFrameNumber))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            if (!SetNull(context, ref txtInstallDate))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            if (!SetNull(context, ref txtPowerType))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            //其它资料
            if (!SetNull(context, ref txtOwnerName))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            if (!SetNull(context, ref txtSex))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            if (!SetNull(context, ref txtTel))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            if (!SetNull(context, ref txtEmail))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            if (!SetNull(context, ref txtContact1))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            if (!SetNull(context, ref txtTel1))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            if (!SetNull(context, ref txtContact2))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            if (!SetNull(context, ref txtTel2))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            if (!SetNull(context, ref txtIdentityCard))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            if (!SetNull(context, ref txtPostalCode))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            if (!SetNull(context, ref txtWorkUnit))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            if (!SetNull(context, ref txtDriverName))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            if (!SetNull(context, ref txtAddress))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            //中心资料
            if (!SetNull(context, ref txtInstallPerson))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            if (!SetNull(context, ref txtTonOrSeats))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            if (!SetNull(context, ref txtOperationRoute))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            if (!SetNull(context, ref txtTransportLicenseID))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            if (!SetNull(context, ref txtMoney))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            if (!SetNull(context, ref txtPurchaseDate))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            if (!SetNull(context, ref txtServerEndTime))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            if (!SetNull(context, ref txtEnrolDate))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            if (!SetNull(context, ref txtAnnualInspectionRepairTime))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            if (!SetNull(context, ref txtVehLevel2MaintenanceTime))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            //备注
            if (!SetNull(context, ref txtMarks))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            DateTime dt = DateTime.Now;
            if (!DateTime.TryParse(txtAnnualInspectionRepairTime, out dt))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            txtAnnualInspectionRepairTime = dt.ToString("yyyy-MM-dd HH:mm:ss");
            if (!DateTime.TryParse(txtVehLevel2MaintenanceTime, out dt))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            txtVehLevel2MaintenanceTime = dt.ToString("yyyy-MM-dd HH:mm:ss");
            if (!DateTime.TryParse(txtEnrolDate, out dt))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            txtEnrolDate = dt.ToString("yyyy-MM-dd HH:mm:ss");
            if (!DateTime.TryParse(txtServerEndTime, out dt))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            txtServerEndTime = dt.ToString("yyyy-MM-dd HH:mm:ss");
            if (!DateTime.TryParse(txtPurchaseDate, out dt))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            txtPurchaseDate = dt.ToString("yyyy-MM-dd HH:mm:ss");
            if (!DateTime.TryParse(txtInstallDate, out dt))
            {
                context.Response.Write("{\"result\":false,\"err\":\"4002\"}");
                return;
            }
            txtInstallDate = dt.ToString("yyyy-MM-dd HH:mm:ss");
            
            int iExeResult = 0;    //执行结果
            string strExeResult = "";

            string strSQL = "";
            string strVehIP = "";
            if( txtTaxiNo == "GPRS_TZ型" || txtTaxiNo == "TQ_BXG型" || txtTaxiNo == "TQ_规格型")
            {
                strVehIP = txtIpAddress.PadLeft(12, '0');
            }
            else if(txtTaxiNo == "GPRS_HB型")
            {
                    strVehIP = txtIpAddress.PadLeft(12,'0');
            }
            else if( txtTaxiNo == "DB44_YT型" || txtTaxiNo == "DB44_GM型" || txtTaxiNo == "DB44_YW型" )
            {
                    strVehIP = txtIpAddress.PadLeft(12,'0');
            }
            else
            {
                    strVehIP = txtIpAddress.PadLeft(12,'0');
            }
            if (txtTaxiNo.IndexOf("GB") == -1 && txtTaxiNo.IndexOf("_YJ云镜") == -1 && txtTaxiNo.IndexOf("XWRJ") == -1 && txtTaxiNo.IndexOf("-Lx") == -1)
            {
                strVehIP = ConvertMobileTo145IPAddress(txtIpAddress);
            }
            //txtIpAddress = strVehIP;
            if (iExeType == 0) //编辑
            {
                //更新车辆资料表
                string sSQLAddVehUser = ""; //自动添加车辆对应的用户
                if (txtServerPwd.Trim().Length > 0)
                {
                    sSQLAddVehUser = " exec AddVehLoginUser '" + iVehID.ToString() + "OnlyVehUser'," + iVehGroupID.ToString() + " ";
                }

                //IP_Exband by Onedoor
                strSQL = "if not exists(select id from vehicle where (cph='" + txtPlateNO + "' or deviceid='" + txtSim + "' or ownno='" + txtIpAddress + "' or IpAddress='" + strVehIP + "') and id!=" + iVehID.ToString() + "  ) begin UPDATE Vehicle "
                         + " SET DrvID=@司机ID,Cph=@车牌号码,DeCph=@车牌颜色 ,ownno=@终端编号, deviceid=@SIM卡号, ProductCode=@自定编号, "
                         + " TaxiNo=@终端类型, Type=@通信方式, webpass=@服务密码, Color=@车辆颜色, VehicleType=@车辆种类,  "
                         + " EngineNo=@发动机编号, FrameNo=@车架编号, EnrolDate=@安装日期, OwnerName=@车主姓名, "
                         + " Byzd=@性别, Contact3=@联系电话, ContactPhone3=@EMAIL, Yyzh=@身份证号, Contact1=@联系人1, "
                         + " AlarmLinkTel=@联系电话1, Contact2=@联系人2, LinkTel2=@联系电话2, LogoutCause=@联系地址, "
                         + " DistrictCode=@邮政编码, Seller=@工作单位, InstallPerson=@安装人员, BusinessPerson=@吨数, "
                         + "  RecordPerson=@运营线路, InstallAddress=@道路运输证号, PurchaseDate=@服务起始时间, "
                         + "PowerType='" + txtPowerType + "', "
                         + " ServerEndTime=@服务结束时间, ServerMoney=@金额, Marks=@备注, IpAddress=@伪IP,UpdateTime=@UpdateTime,RepairTime=@RepairTime,InsuranceTime=@InsuranceTime,inserttime='" + txtVehLevel2MaintenanceTime + "' "
                         + ",iAccStatues=0,SetMarks='', YhRzMm='" + txtDriverName + "'  where id=" + iVehID.ToString() + " "
                         + " " + sSQLAddVehUser
                         + " select '1' end else begin declare @Return varchar(200) set @Return=''  if exists(select id from vehicle where cph='" + txtPlateNO + "' and id!=" + iVehID.ToString() + " ) set @Return=@Return+' 车牌' "
                         + " if exists(select id from vehicle where deviceid='" + txtSim + "' and id!=" + iVehID.ToString() + " ) set @Return=@Return+' SIM卡号' "
                         + " if exists(select id from vehicle where (ownno='" + txtIpAddress + "' or IpAddress='" + strVehIP + "') and id!=" + iVehID.ToString() + " ) set @Return=@Return+' 终端编号' "
                         + " select @Return end";
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
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@司机ID", "0"));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@车牌号码", txtPlateNO));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@车牌颜色", txtPlateColor));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@终端编号", txtIpAddress));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@SIM卡号", txtSim));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@自定编号", txtCustomNum));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@终端类型", txtTaxiNo));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@通信方式", "UDP"));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@服务密码", txtServerPwd));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@车辆颜色", txtCarColor));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@车辆种类", txtCarType));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@发动机编号", txtEngineNumber));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@车架编号", txtFrameNumber));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@安装日期", txtInstallDate));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@车主姓名", txtOwnerName));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@性别", txtSex));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@联系电话", txtTel));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@EMAIL", txtEmail));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@身份证号", txtIdentityCard));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@联系人1", txtContact1));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@联系电话1", txtTel1));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@联系人2", txtContact2));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@联系电话2", txtTel2));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@联系地址", txtAddress));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@邮政编码", txtPostalCode));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@工作单位", txtWorkUnit));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@安装人员", txtInstallPerson));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@吨数", txtTonOrSeats));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@运营线路", txtOperationRoute));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@道路运输证号", txtTransportLicenseID));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@服务起始时间", txtPurchaseDate));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@服务结束时间", txtServerEndTime));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@金额", txtMoney));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@备注", txtMarks));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@伪IP", strVehIP));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@UpdateTime", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@RepairTime", txtAnnualInspectionRepairTime));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@InsuranceTime", txtEnrolDate));
                    System.Data.SqlClient.SqlDataReader da = sqlCmd.ExecuteReader();
                    int iResult = 0;
                    string strInfo = "";
                    while (da.Read())
                    {
                        try
                        {
                            iResult = int.Parse(da[0].ToString());
                            break;
                        }
                        catch (Exception ex1)
                        {
                            iResult = 0;
                            strInfo = "数据库或回收站中存在相同的" + da[0].ToString();
                            da.Close();
                            break;
                        }
                    }
                    da.Close();
                    bool blnResult = false;
                    if (iResult == 1 && txtMarks != "枪支Gun")
                    {
                        //更新车组
                        //先查询是否更新车组
                        int iOldGroupID;

                        strSQL = "select VehGroupID FROM VehicleDetail where VehID=" + iVehID.ToString();
                        sqlCmd.CommandText = strSQL;
                        iOldGroupID = Convert.ToInt32(sqlCmd.ExecuteScalar());
                        if (iOldGroupID != iVehGroupID)
                        {
                            strSQL = "exec UpdateUserVersion @GroupID = " + iVehGroupID.ToString();
                            strSQL = strSQL + " exec UpdateUserVersion @GroupID = " + iOldGroupID.ToString();
                            sqlCmd.CommandText = strSQL;
                            sqlCmd.ExecuteNonQuery();
                        }

                        //先删除旧的车组关系
                        strSQL = "DELETE FROM VehicleDetail where VehID=" + iVehID.ToString();
                        sqlCmd.CommandText = strSQL;
                        sqlCmd.ExecuteNonQuery();

                        //插入新的车组关系
                        strSQL = "INSERT INTO VehicleDetail (VehID, VehGroupID) VALUES (@VehID,@VehGroupID)";
                        sqlCmd.CommandText = strSQL;
                        sqlCmd.Parameters.Add("@VehID", System.Data.SqlDbType.Int, 4).Value = iVehID;
                        sqlCmd.Parameters.Add("@VehGroupID", System.Data.SqlDbType.Int).Value = iVehGroupID;
                        sqlCmd.ExecuteNonQuery();
                        strInfo = "编辑成功完成！";
                        blnResult = true;
                    }
                    else if (iResult == 1 && txtMarks == "枪支Gun")
                    {
                        strSQL = "DELETE FROM GunCardVehDetail where VehID=" + iVehID.ToString();
                        sqlCmd.CommandText = strSQL;
                        sqlCmd.ExecuteNonQuery();

                        //插入新的车组关系
                        strSQL = "INSERT INTO GunCardVehDetail (VehID, CardKey) VALUES (@VehID,@VehGroupID)";
                        sqlCmd.CommandText = strSQL;
                        sqlCmd.Parameters.Add("@VehID", System.Data.SqlDbType.Int, 4).Value = iVehID;
                        sqlCmd.Parameters.Add("@VehGroupID", System.Data.SqlDbType.Int).Value = iVehGroupID;
                        sqlCmd.ExecuteNonQuery();
                        strInfo = "编辑成功完成！";
                        blnResult = true;
                    }
                    else
                    {
                        iVehID = 0;
                        blnResult = false;
                    }
                    trans.Commit();
                    Models.CErr cReturn = new Models.CErr();
                    cReturn.result = blnResult;
                    cReturn.err = strInfo;
                    BllCommon.AddOpNoteFromVehMgr("EditVeh", iVehID, "", "", sUserName, sIP, iUserID, new object[] { 0, sOldName, iVehID, txtPlateNO });
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
            else if (iExeType == 1) //添加
            {
                //插入车辆资料表
                string sSQLAddVehUser = "";
                if (txtServerPwd.Trim().Length > 0)
                {
                    sSQLAddVehUser = " declare @UserInfo nvarchar(15) set @UserInfo = convert(nvarchar(10),@@IDENTITY) + 'OnlyVehUser'  exec AddVehLoginUser @UserInfo," + iVehGroupID.ToString() + " ";
                }

                strSQL = "if not exists(select id from vehicle where cph='" + txtPlateNO + "' or deviceid='" + txtSim + "' or ownno='" + txtIpAddress + "' or IpAddress='" + strVehIP + "' ) begin INSERT INTO Vehicle "
                        + "(DrvID,Cph,DeCph,ownno,deviceid,ProductCode,TaxiNo,Type,webpass,Color,VehicleType,EngineNo,FrameNo,EnrolDate,OwnerName,Byzd,Contact3,ContactPhone3,Yyzh,Contact1,AlarmLinkTel,Contact2,LinkTel2,LogoutCause,DistrictCode,Seller,InstallPerson,BusinessPerson,RecordPerson,InstallAddress,PurchaseDate,ServerEndTime,ServerMoney,Marks,IpAddress,RepairTime,InsuranceTime,inserttime,iAccStatues,SetMarks,PowerType) "
                        + " Values "
                        + "   (@司机ID,@车牌号码,@车牌颜色,@终端编号,@SIM卡号,@自定编号,@终端类型,@通信方式,@服务密码,@车辆颜色,@车辆种类,@发动机编号,@车架编号,@安装日期,@车主姓名,@性别,@联系电话,@EMAIL,@身份证号,@联系人1,@联系电话1,@联系人2,@联系电话2,@联系地址,@邮政编码,@工作单位,@安装人员,@吨数,@运营线路,@道路运输证号,@服务起始时间,@服务结束时间,@金额,@备注,@伪IP,@RepairTime,@InsuranceTime,'" + txtVehLevel2MaintenanceTime + "',0,'','" + txtPowerType + "') "
                        + " declare @ReturnIdentity int  set @ReturnIdentity = @@IDENTITY "
                        + " " + sSQLAddVehUser
                        + " select @ReturnIdentity end "
                        + " else begin declare @Return varchar(200) set @Return='' if exists(select id from vehicle where cph='" + txtPlateNO + "') set @Return=@Return+' 车牌' "
                        + " if exists(select id from vehicle where deviceid='" + txtSim + "') set @Return=@Return+' SIM卡号' "
                        + " if exists(select id from vehicle where ownno='" + txtIpAddress + "' or IpAddress='" + strVehIP + "') set @Return=@Return+' 终端编号' "
                        + " select @Return end";
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
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@司机ID", "0"));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@车牌号码", txtPlateNO));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@车牌颜色", txtPlateColor));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@终端编号", txtIpAddress));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@SIM卡号", txtSim));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@自定编号", txtCustomNum));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@终端类型", txtTaxiNo));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@通信方式", "UDP"));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@服务密码", txtServerPwd));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@车辆颜色", txtCarColor));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@车辆种类", txtCarType));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@发动机编号", txtEngineNumber));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@车架编号", txtFrameNumber));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@安装日期", txtInstallDate));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@车主姓名", txtOwnerName));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@性别", txtSex));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@联系电话", txtTel));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@EMAIL", txtEmail));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@身份证号", txtIdentityCard));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@联系人1", txtContact1));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@联系电话1", txtTel1));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@联系人2", txtContact2));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@联系电话2", txtTel2));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@联系地址", txtAddress));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@邮政编码", txtPostalCode));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@工作单位", txtWorkUnit));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@安装人员", txtInstallPerson));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@吨数", txtTonOrSeats));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@运营线路", txtOperationRoute));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@道路运输证号", txtTransportLicenseID));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@服务起始时间", txtPurchaseDate));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@服务结束时间", txtServerEndTime));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@金额", txtMoney));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@备注", txtMarks));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@伪IP", strVehIP));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@RepairTime", txtAnnualInspectionRepairTime));
                    sqlCmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@InsuranceTime", txtEnrolDate));
                    System.Data.SqlClient.SqlDataReader da = sqlCmd.ExecuteReader();
                    int iResult = 0;
                    string strInfo = "";
                    while (da.Read())
                    {
                        try
                        {
                            iVehID = int.Parse(da[0].ToString());
                            iResult = 1;
                            break;
                        }
                        catch (Exception ex1)
                        {
                            iResult = 0;
                            strInfo = "数据库或回收站中存在相同的" + da[0].ToString();
                            da.Close();
                            break;
                        }
                    }
                    da.Close();
                    bool blnResult = false;
                    if (iResult == 1 && txtMarks != "枪支Gun")
                    {
                        //先删除旧的车组关系
                        strSQL = "DELETE FROM VehicleDetail where VehID=" + iVehID.ToString();
                        sqlCmd.CommandText = strSQL;
                        sqlCmd.ExecuteNonQuery();

                        //插入新的车组关系
                        strSQL = "INSERT INTO VehicleDetail (VehID, VehGroupID) VALUES (@VehID,@VehGroupID)";
                        sqlCmd.CommandText = strSQL;
                        sqlCmd.Parameters.Add("@VehID", System.Data.SqlDbType.Int, 4).Value = iVehID;
                        sqlCmd.Parameters.Add("@VehGroupID", System.Data.SqlDbType.Int).Value = iVehGroupID;
                        sqlCmd.ExecuteNonQuery();
                        strInfo = "添加车辆成功完成！";
                        blnResult = true;
                        string sBatch = System.Configuration.ConfigurationManager.AppSettings["Batch"];
                        strSQL = "if exists(select name From master..sysdatabases where name='Bee" + DateTime.Now.ToString("yyyyMMdd") + "') exec HCreateTable 'Bee" + DateTime.Now.ToString("yyyyMMdd") + "','DynData" + iVehID.ToString() + "' if exists(select name From master..sysdatabases where name='Bee" + DateTime.Now.AddDays(1).ToString("yyyyMMdd") + "')  exec HCreateTable 'Bee" + DateTime.Now.AddDays(1).ToString("yyyyMMdd") + "','DynData" + iVehID.ToString() + "'";
                        if (sBatch.Equals("1"))
                        {
                            strSQL = "if exists(select name From master..sysdatabases where name='Bee" + DateTime.Now.ToString("yyyyMMdd") + "') exec HCreateView 'Bee" + DateTime.Now.ToString("yyyyMMdd") + "','DynData" + iVehID.ToString() + "'," + iVehID.ToString() + " if exists(select name From master..sysdatabases where name='Bee" + DateTime.Now.AddDays(1).ToString("yyyyMMdd") + "')  exec HCreateView 'Bee" + DateTime.Now.AddDays(1).ToString("yyyyMMdd") + "','DynData" + iVehID.ToString() + "'," + iVehID.ToString();
                        }

                        sqlCmd.CommandText = strSQL;
                        sqlCmd.ExecuteNonQuery();
                    }
                    else if (iResult == 1 && txtMarks == "枪支Gun")
                    {
                        //先删除旧的车组关系
                        strSQL = "DELETE FROM GunCardVehDetail where VehID=" + iVehID.ToString();
                        sqlCmd.CommandText = strSQL;
                        sqlCmd.ExecuteNonQuery();

                        //插入新的车组关系
                        strSQL = "INSERT INTO GunCardVehDetail (VehID, CardKey) VALUES (@VehID,@VehGroupID)";
                        sqlCmd.CommandText = strSQL;
                        sqlCmd.Parameters.Add("@VehID", System.Data.SqlDbType.Int, 4).Value = iVehID;
                        sqlCmd.Parameters.Add("@VehGroupID", System.Data.SqlDbType.Int).Value = iVehGroupID;
                        sqlCmd.ExecuteNonQuery();
                        strInfo = "添加定位器成功完成！";
                        blnResult = true;

                        string sBatch = System.Configuration.ConfigurationManager.AppSettings["Batch"];
                        strSQL = "if exists(select name From master..sysdatabases where name='Bee" + DateTime.Now.ToString("yyyyMMdd") + "') exec HCreateTable 'Bee" + DateTime.Now.ToString("yyyyMMdd") + "','DynData" + iVehID.ToString() + "' if exists(select name From master..sysdatabases where name='Bee" + DateTime.Now.AddDays(1).ToString("yyyyMMdd") + "')  exec HCreateTable 'Bee" + DateTime.Now.AddDays(1).ToString("yyyyMMdd") + "','DynData" + iVehID.ToString() + "'";
                        if (sBatch == "1")
                        {
                            strSQL = "if exists(select name From master..sysdatabases where name='Bee" + DateTime.Now.ToString("yyyyMMdd") + "') exec HCreateView 'Bee" + DateTime.Now.ToString("yyyyMMdd") + "','DynData" + iVehID.ToString() + "'," + iVehID.ToString() + " if exists(select name From master..sysdatabases where name='Bee" + DateTime.Now.AddDays(1).ToString("yyyyMMdd") + "')  exec HCreateView 'Bee" + DateTime.Now.AddDays(1).ToString("yyyyMMdd") + "','DynData" + iVehID.ToString() + "'," + iVehID.ToString();
                        }
                        sqlCmd.CommandText = strSQL;
                        sqlCmd.ExecuteNonQuery();

                        strSQL = "if exists(select name From master..sysdatabases where name='Bee" + DateTime.Now.AddDays(2).ToString("yyyyMMdd") + "') exec HCreateTable 'Bee" + DateTime.Now.AddDays(2).ToString("yyyyMMdd") + "','DynData" + iVehID.ToString() + "' ";
                        if (sBatch == "1")
                        {
                            strSQL = "if exists(select name From master..sysdatabases where name='Bee" + DateTime.Now.AddDays(2).ToString("yyyyMMdd") + "') exec HCreateView 'Bee" + DateTime.Now.AddDays(2).ToString("yyyyMMdd") + "','DynData" + iVehID.ToString() + "'," + iVehID.ToString();
                        }
                        sqlCmd.CommandText = strSQL;
                        sqlCmd.ExecuteNonQuery();
                    }
                    else
                    {
                        blnResult = false;
                    }
                    trans.Commit();
                    Models.CErr cReturn = new Models.CErr();
                    cReturn.result = blnResult;
                    cReturn.err = strInfo;
                    if (blnResult)
                    {
                        cReturn.err = iVehID.ToString();
                    }
                    BllCommon.AddOpNoteFromVehMgr("EditVeh", iVehID, "", "", sUserName, sIP, iUserID, new object[] { 1, sOldName, iVehID, txtPlateNO });
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
    
    private string ConvertMobileTo145IPAddress(string simNum ) 
    {
        string terNum;
        terNum = simNum.PadLeft(12, '0');
        try
        {
            simNum = simNum.Substring(1);
            if (double.Parse(simNum) < 4200000000)
            {
                return terNum;
            }
            else
            {
                int iFirst;
                iFirst = int.Parse(simNum.Substring(0, 2));
                if ((iFirst - 30) < 0x10)
                {
                    return terNum;
                }
                else
                {
                    //溢出重新计算
                    do
                    {
                        iFirst = iFirst - 16;
                    } while ((iFirst - 30) >= 0x10);
                    terNum = "1" + iFirst.ToString().PadLeft(2, '0') + simNum.Substring(2);
                    terNum = terNum.PadLeft(12, '0');
                }
            }
            return terNum;
        }
        catch (Exception ex)
        {
            return terNum;
        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}