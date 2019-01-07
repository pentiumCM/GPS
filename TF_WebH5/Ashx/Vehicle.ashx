<%@ WebHandler Language="C#" Class="Vehicle" %>

using System;
using System.Web;

public class Vehicle : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        try
        {
            //System.Globalization.CultureInfo s = new System.Globalization.CultureInfo("en - US");//zh-CN,en-US 是设置语言类型
            //System.Threading.Thread.CurrentThread.CurrentUICulture = s;
            string sUserName = context.Request["username"];
            string sPwd = context.Request["Pwd"];
            string sDoType = context.Request["doType"];

            if (string.IsNullOrEmpty(sUserName) || string.IsNullOrEmpty(sPwd) || string.IsNullOrEmpty(sDoType))
            {
                context.Response.Write("{\"result\":\"false\",\"err\":\"4001\"}");
            }
            else
            {
                if (!SqlFilter.Filter.ProcessFilter(ref sUserName) || !SqlFilter.Filter.ProcessFilter(ref sPwd) || !SqlFilter.Filter.ProcessFilter(ref sDoType))
                {
                    context.Response.Write("{\"result\":\"false\",\"err\":\"4002\"}");
                }
                if (!SqlFilter.Filter.ProcessFilter(ref sUserName) || !SqlFilter.Filter.ProcessFilter(ref sPwd) || !SqlFilter.Filter.ProcessFilter(ref sDoType))
                {
                    context.Response.Write("{\"result\":\"false\",\"err\":\"4002\"}");
                }
                else
                {
                    int iUserID = -1;
                    string sErr = "";
                    if (sDoType != "3" && sDoType != "4" && !BllCommon.IsUserLogin(sUserName, sPwd, out iUserID, out sErr))
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
                    else if ((sDoType == "3" || sDoType == "4") && !BllCommon.IsVehLogin(sUserName, sPwd, out iUserID, out sErr))
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
                        if (sDoType == "1")
                        {
                            //这里开始获取车辆数据
                            System.Data.DataSet ds = BllVehicle.GetVehicleFromLogin(iUserID);
                            System.Collections.Generic.List<Models.CVehicle> lstVeh = new System.Collections.Generic.List<Models.CVehicle>();
                            if (ds != null && ds.Tables.Count > 0)
                            {
                                foreach (System.Data.DataRow dr in ds.Tables[0].Rows)
                                {
                                    Models.CVehicle cVehicle = new Models.CVehicle();
                                    cVehicle.id = "V" + dr["Id"].ToString();
                                    cVehicle.name = dr["Cph"].ToString();
                                    cVehicle.GID = "G" + dr["VehGroupID"];
                                    cVehicle.ipaddress = dr["IpAddress"].ToString();
                                    cVehicle.ownno = dr["OwnNo"].ToString();
                                    cVehicle.sim = dr["Deviceid"].ToString();
                                    cVehicle.taxino = dr["TaxiNo"].ToString();
                                    cVehicle.customid = dr["ProductCode"].ToString();
                                    cVehicle.contact3 = dr["Contact3"].ToString();
                                    cVehicle.ownername = dr["OwnerName"].ToString();
                                    cVehicle.seller = dr["Seller"].ToString();
                                    lstVeh.Add(cVehicle);
                                }
                            }
                            string sJson = JsonHelper.SerializeObject(lstVeh);
                            context.Response.Write("{\"result\":\"true\",\"err\":\"\",\"data\":" + sJson + "}");
                        }
                        else if (sDoType == "3")
                        {
                            System.Data.DataSet ds = BllVehicle.GetVehicleByID(iUserID.ToString());
                            System.Collections.Generic.List<Models.CVehicle> lstVeh = new System.Collections.Generic.List<Models.CVehicle>();
                            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                            {
                                System.Data.DataRow dr = ds.Tables[0].Rows[0];
                                Models.CVehicle cVehicle = new Models.CVehicle();
                                cVehicle.id = "V" + dr["Id"].ToString();
                                cVehicle.name = dr["Cph"].ToString();
                                cVehicle.GID = "G0";
                                cVehicle.ipaddress = dr["IpAddress"].ToString();
                                cVehicle.ownno = dr["OwnNo"].ToString();
                                cVehicle.sim = dr["Deviceid"].ToString();
                                cVehicle.taxino = dr["TaxiNo"].ToString();
                                cVehicle.customid = dr["ProductCode"].ToString();
                                cVehicle.contact3 = dr["Contact3"].ToString();
                                cVehicle.ownername = dr["OwnerName"].ToString();
                                cVehicle.seller = dr["Seller"].ToString();
                                lstVeh.Add(cVehicle);
                            }                            
                            string sJson = JsonHelper.SerializeObject(lstVeh);
                            context.Response.Write("{\"result\":\"true\",\"err\":\"\",\"data\":" + sJson + "}");
                        }
                        else if (sDoType == "2" || sDoType == "4") //通过ID获取车辆信息
                        {
                            string sVehID = context.Request["ID"];
                            if (string.IsNullOrEmpty(sVehID))
                            {
                                context.Response.Write("{\"result\":\"false\",\"err\":\"4001\"}");
                            }
                            else if (!SqlFilter.Filter.ProcessFilter(ref sVehID))
                            {
                                context.Response.Write("{\"result\":\"false\",\"err\":\"4002\"}");
                            }
                            //这里开始获取车辆数据
                            System.Data.DataSet ds = BllVehicle.GetVehicleByID(sVehID);
                            System.Collections.Generic.List<Models.CKeyValue> lstVeh = new System.Collections.Generic.List<Models.CKeyValue>();
                            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                            {
                                Models.CKeyValue cKeyValue = new Models.CKeyValue();
                                System.Data.DataRow dr = ds.Tables[0].Rows[0];
                                cKeyValue.name = "id";
                                cKeyValue.value = dr["Id"].ToString();
                                lstVeh.Add(cKeyValue);
                                cKeyValue = new Models.CKeyValue();
                                cKeyValue.name = "Cph";
                                cKeyValue.value = dr["Cph"].ToString();
                                lstVeh.Add(cKeyValue);
                                cKeyValue = new Models.CKeyValue();
                                cKeyValue.name = "IpAddress";
                                cKeyValue.value = dr["IpAddress"].ToString();
                                lstVeh.Add(cKeyValue);
                                cKeyValue = new Models.CKeyValue();
                                cKeyValue.name = "ownno";
                                cKeyValue.value = dr["OwnNo"].ToString();
                                lstVeh.Add(cKeyValue);
                                cKeyValue = new Models.CKeyValue();
                                cKeyValue.name = "Deviceid";
                                cKeyValue.value = dr["Deviceid"].ToString();
                                lstVeh.Add(cKeyValue);
                                cKeyValue = new Models.CKeyValue();
                                cKeyValue.name = "TaxiNo";
                                cKeyValue.value = dr["TaxiNo"].ToString();
                                lstVeh.Add(cKeyValue);
                                cKeyValue = new Models.CKeyValue();
                                cKeyValue.name = "ProductCode";
                                cKeyValue.value = dr["ProductCode"].ToString();
                                lstVeh.Add(cKeyValue);
                                cKeyValue = new Models.CKeyValue();
                                cKeyValue.name = "Decph";
                                cKeyValue.value = dr["Decph"].ToString();
                                lstVeh.Add(cKeyValue);
                                cKeyValue = new Models.CKeyValue();
                                cKeyValue.name = "OwnerName";
                                cKeyValue.value = dr["OwnerName"].ToString();
                                lstVeh.Add(cKeyValue);
                                cKeyValue = new Models.CKeyValue();
                                cKeyValue.name = "Contact3";
                                cKeyValue.value = dr["Contact3"].ToString();
                                lstVeh.Add(cKeyValue);
                                cKeyValue = new Models.CKeyValue();
                                cKeyValue.name = "ContactPhone3";
                                cKeyValue.value = dr["ContactPhone3"].ToString();
                                lstVeh.Add(cKeyValue);
                                cKeyValue = new Models.CKeyValue();
                                cKeyValue.name = "Contact1";
                                cKeyValue.value = dr["Contact1"].ToString();
                                lstVeh.Add(cKeyValue);
                                cKeyValue = new Models.CKeyValue();
                                cKeyValue.name = "AlarmLinkTel";
                                cKeyValue.value = dr["AlarmLinkTel"].ToString();
                                lstVeh.Add(cKeyValue);
                                cKeyValue = new Models.CKeyValue();
                                cKeyValue.name = "Contact2";
                                cKeyValue.value = dr["Contact2"].ToString();
                                lstVeh.Add(cKeyValue);
                                cKeyValue = new Models.CKeyValue();
                                cKeyValue.name = "LinkTel2";
                                cKeyValue.value = dr["LinkTel2"].ToString();
                                lstVeh.Add(cKeyValue);
                                cKeyValue = new Models.CKeyValue();
                                cKeyValue.name = "YyZh";
                                cKeyValue.value = dr["YyZh"].ToString();
                                lstVeh.Add(cKeyValue);
                                cKeyValue = new Models.CKeyValue();
                                cKeyValue.name = "ByZd";
                                cKeyValue.value = dr["ByZd"].ToString();
                                lstVeh.Add(cKeyValue);
                                cKeyValue = new Models.CKeyValue();
                                cKeyValue.name = "FrameNo";
                                cKeyValue.value = dr["FrameNo"].ToString();
                                lstVeh.Add(cKeyValue);
                                cKeyValue = new Models.CKeyValue();
                                cKeyValue.name = "EngineNo";
                                cKeyValue.value = dr["EngineNo"].ToString();
                                lstVeh.Add(cKeyValue);
                                cKeyValue = new Models.CKeyValue();
                                cKeyValue.name = "VehicleType";
                                cKeyValue.value = dr["VehicleType"].ToString();
                                lstVeh.Add(cKeyValue);
                                cKeyValue = new Models.CKeyValue();
                                cKeyValue.name = "Color";
                                cKeyValue.value = dr["Color"].ToString();
                                lstVeh.Add(cKeyValue);
                                cKeyValue = new Models.CKeyValue();
                                cKeyValue.name = "PurchaseDate";
                                cKeyValue.value = DateTime.Parse(dr["PurchaseDate"].ToString()).ToString("yyyy-MM-dd HH:mm:ss");
                                lstVeh.Add(cKeyValue);
                                cKeyValue = new Models.CKeyValue();
                                cKeyValue.name = "ServerEndTime";
                                cKeyValue.value = DateTime.Parse(dr["ServerEndTime"].ToString()).ToString("yyyy-MM-dd HH:mm:ss");
                                lstVeh.Add(cKeyValue);
                                cKeyValue = new Models.CKeyValue();
                                cKeyValue.name = "EnrolDate";
                                cKeyValue.value = DateTime.Parse(dr["EnrolDate"].ToString()).ToString("yyyy-MM-dd HH:mm:ss");
                                lstVeh.Add(cKeyValue);
                                cKeyValue = new Models.CKeyValue();
                                cKeyValue.name = "ServerMoney";
                                cKeyValue.value = dr["ServerMoney"].ToString();
                                lstVeh.Add(cKeyValue);
                                cKeyValue = new Models.CKeyValue();
                                cKeyValue.name = "Seller";
                                cKeyValue.value = dr["Seller"].ToString();
                                lstVeh.Add(cKeyValue);
                                cKeyValue = new Models.CKeyValue();
                                cKeyValue.name = "LogOutCause";
                                cKeyValue.value = dr["LogOutCause"].ToString();
                                lstVeh.Add(cKeyValue);
                                cKeyValue = new Models.CKeyValue();
                                cKeyValue.name = "InstallPerson";
                                cKeyValue.value = dr["InstallPerson"].ToString();
                                lstVeh.Add(cKeyValue);
                                cKeyValue = new Models.CKeyValue();
                                cKeyValue.name = "InstallAddress";
                                cKeyValue.value = dr["InstallAddress"].ToString();
                                lstVeh.Add(cKeyValue);
                                cKeyValue = new Models.CKeyValue();
                                cKeyValue.name = "RecordPerson";
                                cKeyValue.value = dr["RecordPerson"].ToString();
                                lstVeh.Add(cKeyValue);
                                cKeyValue = new Models.CKeyValue();
                                cKeyValue.name = "BusinessPerson";
                                cKeyValue.value = dr["BusinessPerson"].ToString();
                                lstVeh.Add(cKeyValue);
                                cKeyValue = new Models.CKeyValue();
                                cKeyValue.name = "PowerType";
                                cKeyValue.value = dr["PowerType"].ToString();
                                lstVeh.Add(cKeyValue);
                                cKeyValue = new Models.CKeyValue();
                                cKeyValue.name = "Marks";
                                cKeyValue.value = dr["Marks"].ToString();
                                lstVeh.Add(cKeyValue);

                            }
                            string sJson = JsonHelper.SerializeObject(lstVeh);
                            context.Response.Write("{\"result\":\"true\",\"err\":\"\",\"data\":" + sJson + "}");
                        }
                        else if (sDoType == "5") //通过ID获取车辆信息(加车)
                        {
                            string sVehID = context.Request["ID"];
                            if (string.IsNullOrEmpty(sVehID))
                            {
                                context.Response.Write("{\"result\":\"false\",\"err\":\"4001\"}");
                            }
                            else if (!SqlFilter.Filter.ProcessFilter(ref sVehID))
                            {
                                context.Response.Write("{\"result\":\"false\",\"err\":\"4002\"}");
                            }
                            //这里开始获取车辆数据
                            System.Data.DataSet ds = BllVehicle.GetVehicleByID(sVehID);
                            System.Collections.Generic.List<Models.CVehicleDetail> lstVeh = new System.Collections.Generic.List<Models.CVehicleDetail>();
                            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                            {
                                System.Data.DataRow dr = ds.Tables[0].Rows[0];
                                Models.CVehicleDetail cData = new Models.CVehicleDetail();
                                cData.Address = dr["LogOutCause"].ToString();
                                cData.ownno = dr["OwnNo"].ToString();
                                cData.AnnualInspectionRepairTime = Convert.ToDateTime(dr["RepairTime"]).ToString("yyyy-MM-dd HH:mm:ss");
                                cData.CarColor = dr["Color"].ToString();
                                cData.CarType = dr["VehicleType"].ToString();
                                cData.Contact1 = dr["Contact1"].ToString();
                                cData.Contact2 = dr["Contact2"].ToString();
                                cData.CustomNum = dr["ProductCode"].ToString();
                                cData.DriverName = "";
                                cData.Email = dr["ContactPhone3"].ToString();
                                cData.EngineNumber = dr["EngineNo"].ToString();
                                cData.EnrolDate = Convert.ToDateTime(dr["InsuranceTime"].ToString()).ToString("yyyy-MM-dd HH:mm:ss");//保险
                                cData.FrameNumber = dr["FrameNo"].ToString();
                                cData.IdentityCard = dr["YyZh"].ToString();
                                cData.InstallDate = Convert.ToDateTime(dr["EnrolDate"].ToString()).ToString("yyyy-MM-dd HH:mm:ss");
                                cData.InstallPerson = dr["InstallPerson"].ToString();
                                cData.IpAddress = dr["IpAddress"].ToString();
                                if (cData.IpAddress.Length == 12)
                                {
                                    cData.IpAddress = cData.IpAddress.Substring(1); 
                                }
                                cData.Marks = dr["Marks"].ToString();
                                cData.Money = dr["ServerMoney"].ToString();
                                cData.OperationRoute = dr["RecordPerson"].ToString();
                                cData.OwnerName = dr["OwnerName"].ToString();
                                cData.PlateColor = dr["DeCph"].ToString();
                                cData.PlateNO = dr["Cph"].ToString();
                                cData.PostalCode = dr["DistrictCode"].ToString();
                                cData.PowerType = dr["PowerType"].ToString();
                                cData.PurchaseDate = Convert.ToDateTime(dr["PurchaseDate"]).ToString("yyyy-MM-dd HH:mm:ss");
                                cData.ServerEndTime = Convert.ToDateTime(dr["ServerEndTime"]).ToString("yyyy-MM-dd HH:mm:ss");
                                cData.ServerPwd = dr["WebPass"].ToString();
                                cData.Sex = dr["ByZd"].ToString();
                                cData.Sim = dr["Deviceid"].ToString();
                                cData.TaxiNo = dr["TaxiNo"].ToString();
                                cData.Tel = dr["Contact3"].ToString();
                                cData.Tel1 = dr["AlarmLinkTel"].ToString();
                                cData.Tel2 = dr["LinkTel2"].ToString();
                                cData.TonOrSeats = dr["BusinessPerson"].ToString();
                                cData.TransportLicenseID = dr["InstallAddress"].ToString();
                                cData.Level2MaintenanceTime = Convert.ToDateTime(dr["InsertTime"]).ToString("yyyy-MM-dd HH:mm:ss");
                                cData.VendorCode = "";
                                cData.WorkUnit = dr["Seller"].ToString();
                                lstVeh.Add(cData);

                            }
                            string sJson = JsonHelper.SerializeObject(lstVeh);
                            context.Response.Write("{\"result\":\"true\",\"err\":\"\",\"data\":" + sJson + "}");
                        }
                        else if (sDoType == "6") //通过车组ID获取车辆信息
                        {
                            string sTeamID = context.Request["ID"];
                            if (string.IsNullOrEmpty(sTeamID))
                            {
                                context.Response.Write("{\"result\":\"false\",\"err\":\"4001\"}");
                            }
                            else if (!SqlFilter.Filter.ProcessFilter(ref sTeamID))
                            {
                                context.Response.Write("{\"result\":\"false\",\"err\":\"4002\"}");
                            }
                            int iTeam = int.Parse(sTeamID);
                            //这里开始获取车辆数据
                            System.Data.DataSet ds = BllVehicle.GetAllVehicleByTeamID(iTeam);
                            System.Collections.Generic.List<Models.CVehicleDetail> lstVeh = new System.Collections.Generic.List<Models.CVehicleDetail>();
                            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                            {
                                foreach (System.Data.DataRow dr in ds.Tables[0].Rows)
                                {
                                    Models.CVehicleDetail cData = new Models.CVehicleDetail();
                                    cData.Address = dr["LogOutCause"].ToString();
                                    cData.AnnualInspectionRepairTime = Convert.ToDateTime(dr["RepairTime"]).ToString("yyyy-MM-dd HH:mm:ss");
                                    cData.CarColor = dr["Color"].ToString();
                                    cData.CarType = dr["VehicleType"].ToString();
                                    cData.Contact1 = dr["Contact1"].ToString();
                                    cData.Contact2 = dr["Contact2"].ToString();
                                    cData.CustomNum = dr["ProductCode"].ToString();
                                    cData.DriverName = "";
                                    cData.Email = dr["ContactPhone3"].ToString();
                                    cData.EngineNumber = dr["EngineNo"].ToString();
                                    cData.EnrolDate = Convert.ToDateTime(dr["InsuranceTime"].ToString()).ToString("yyyy-MM-dd HH:mm:ss");//保险
                                    cData.FrameNumber = dr["FrameNo"].ToString();
                                    cData.IdentityCard = dr["YyZh"].ToString();
                                    cData.InstallDate = Convert.ToDateTime(dr["EnrolDate"].ToString()).ToString("yyyy-MM-dd HH:mm:ss");
                                    cData.InstallPerson = dr["InstallPerson"].ToString();
                                    cData.IpAddress = dr["IpAddress"].ToString();
                                    cData.ownno = dr["OwnNo"].ToString();
                                    if (cData.IpAddress.Length == 12)
                                    {
                                        cData.IpAddress = cData.IpAddress.Substring(1);
                                    }
                                    cData.Marks = dr["Marks"].ToString();
                                    cData.Money = dr["ServerMoney"].ToString();
                                    cData.OperationRoute = dr["RecordPerson"].ToString();
                                    cData.OwnerName = dr["OwnerName"].ToString();
                                    cData.PlateColor = dr["DeCph"].ToString();
                                    cData.PlateNO = dr["Cph"].ToString();
                                    cData.PostalCode = dr["DistrictCode"].ToString();
                                    cData.PowerType = dr["PowerType"].ToString();
                                    cData.PurchaseDate = Convert.ToDateTime(dr["PurchaseDate"]).ToString("yyyy-MM-dd HH:mm:ss");
                                    cData.ServerEndTime = Convert.ToDateTime(dr["ServerEndTime"]).ToString("yyyy-MM-dd HH:mm:ss");
                                    cData.ServerPwd = dr["WebPass"].ToString();
                                    cData.Sex = dr["ByZd"].ToString();
                                    cData.Sim = dr["Deviceid"].ToString();
                                    cData.TaxiNo = dr["TaxiNo"].ToString();
                                    cData.Tel = dr["Contact3"].ToString();
                                    cData.Tel1 = dr["AlarmLinkTel"].ToString();
                                    cData.Tel2 = dr["LinkTel2"].ToString();
                                    cData.TonOrSeats = dr["BusinessPerson"].ToString();
                                    cData.TransportLicenseID = dr["InstallAddress"].ToString();
                                    cData.Level2MaintenanceTime = Convert.ToDateTime(dr["InsertTime"]).ToString("yyyy-MM-dd HH:mm:ss");
                                    cData.VendorCode = "";
                                    cData.WorkUnit = dr["Seller"].ToString();
                                    lstVeh.Add(cData);
                                }
                            }
                            string sJson = JsonHelper.SerializeObject(lstVeh);
                            context.Response.Write("{\"result\":\"true\",\"err\":\"\",\"data\":" + sJson + "}");
                        }
                        else
                        {
                            context.Response.Write("{\"result\":\"false\",\"err\":\"" + Resources.Lan.UnknownError + "\"}");
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