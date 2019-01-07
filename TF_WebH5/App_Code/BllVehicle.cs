using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Text;

/// <summary>
///BllVehicle 的摘要说明
/// </summary>
public class BllVehicle
{
    public BllVehicle()
    {
        //
        //TODO: 在此处添加构造函数逻辑
        //
    }

    public static string GetChildUserID(int iUserID)
    {
        try
        {
            string strSQL = "select UserID from UserGroupDetail where usergroupid=" + iUserID.ToString();
            string result = iUserID.ToString();
            DataSet ds = BllSql.RunSqlSelect(strSQL);
            if (ds == null || ds.Tables.Count == 0)
            {
                return result;
            }
            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                result += "," + ds.Tables[0].Rows[i]["UserID"].ToString();
            }
            return result;
        }
        catch (Exception ex)
        {
            return iUserID.ToString();
        }
    }

    public static DataSet GetUserGroupFromLogin(int iUserID)
    {
        string strSQL = "";
        string strGroupList = "";
        try
        {
            if (iUserID == 1)
            {
                strSQL = "SELECT UserGroupID,UserGroupName "
                              + " FROM UserGroupMain where UserGroupName != '车辆登录专用' and DelFlag = 0";
            }
            else
            {
                strSQL = "SELECT UserGroupMain.UserGroupID,UserGroupMain.UserGroupName "
                            + " FROM UserGroupMain inner JOIN "
                            + "      UserGroupDetail ON "
                            + "            UserGroupMain.UserGroupID = UserGroupDetail.UserGroupID "
                            + "WHERE UserGroupDetail.UserID = " + iUserID.ToString() + " and UserGroupName != '车辆登录专用' and DelFlag = 0 ";
            }

            DataSet ds = BllSql.RunSqlSelect(strSQL);
            return ds;
        }
        catch (Exception ex)
        {
            return null;
        }
    }

    public static DataSet GetUserFromLogin(int iUserID, int iGroupID)
    {
        string strSQL = "";
        string strGroupList = "";
        try
        {
            if (iUserID == 1)
            {
                strSQL = "SELECT UserMain.UserID,UserMain.UserName,UserGroupDetail.UserGroupID,UserMain.UserTypeID "
                              + " FROM UserMain inner join UserGroupDetail on UserGroupDetail.UserID = UserMain.UserID where DelPurview = 0";
            }
            else
            {
                strSQL = "SELECT UserMain.UserID,UserMain.UserName,UserGroupDetail.UserGroupID,UserMain.UserTypeID "
                              + " FROM UserMain inner join UserGroupDetail on UserGroupDetail.UserID = UserMain.UserID where UserMain.UserID > 1 and DelPurview = 0 and UserGroupDetail.UserGroupID = " + iGroupID.ToString();
            }

            DataSet ds = BllSql.RunSqlSelect(strSQL);
            return ds;
        }
        catch (Exception ex)
        {
            return null;
        }
    }

    public static DataSet GetVehGroupFromLogin(int iUserID)
    {
        string strSQL = "";
        string strGroupList = "";
        try
        {
            if (iUserID == 1)
            {
                strSQL = "SELECT VehGroupMain.VehGroupID, VehGroupMain.VehGroupName, "
                            + "VehGroupDetail.fVehGroupID "
                              + " FROM VehGroupMain left JOIN "
                              + "      VehGroupDetail ON "
                              + "            VehGroupMain.VehGroupID = VehGroupDetail.VehGroupID ";
            }
            else
            {
                //取所有列表ID
                //If sVersion = "SZHZ" Then
                //    strGroupList = GetAllVehGroupByGroup_UserID(adoConn, iUserID, sUserName)
                strGroupList = GetAllVehGroupByUserID(iUserID);

                if (strGroupList.Trim().Length == 0)
                {
                    strGroupList = "0";
                }

                strSQL = "SELECT VehGroupMain.VehGroupID, VehGroupMain.VehGroupName, "
                            + "VehGroupDetail.fVehGroupID "
                            + " FROM VehGroupMain left JOIN "
                            + "      VehGroupDetail ON "
                            + "            VehGroupMain.VehGroupID = VehGroupDetail.VehGroupID "
                            + "WHERE (VehGroupMain.VehGroupID IN (" + strGroupList + ")) ";
            }

            if (iUserID == 1)
            {
                strSQL = strSQL + " where (VehGroupMain.delflag Is null Or VehGroupMain.delflag = 0)";
            }
            else
            {
                strSQL = strSQL + " and (VehGroupMain.delflag Is null Or VehGroupMain.delflag = 0)";
            }
            DataSet ds = BllSql.RunSqlSelect(strSQL);
            return ds;
        }
        catch (Exception ex)
        {
            return null;
        }
    }

    //<summary>
    //按用户ID取
    //</summary>
    //<param name="iUserID"></param>
    //<returns></returns>
    //<remarks></remarks>
    public static string GetAllVehGroupByUserID(int iUserID) 
    {
        string strSQL = "";
        string strGroupIDList = "";
        StringBuilder sb = new StringBuilder();
        try
        {
            //查出用户名下的所有根车组
            if (iUserID == 1)
            {
                strSQL = "SELECT DISTINCT(VehGroupID) FROM VehGroupmain ";
            }
            else
            {
                strSQL = "exec GetAllVehGroupByUserID " + iUserID.ToString();
            }
            DataSet ds = BllSql.RunSqlSelect(strSQL);
            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    sb.Append(ds.Tables[0].Rows[i][0].ToString() + ",");
                }
                strGroupIDList = sb.ToString();
                strGroupIDList = strGroupIDList.Substring(0, strGroupIDList.Length - 1);
            }
            else
            {
                return "";
            }
            return strGroupIDList;
        }
        catch(Exception ex)
        {
            return "";
        }
    }

    public static DataSet GetVehicleFromLogin(int iUserID)
    {
        string strSQL = "";
        string strGroupList = "";
        try
        {
            if (iUserID == 1)
            {
                strSQL = "SELECT Id,Deviceid, IpAddress, Cph,OwnNo, TaxiNo,VehGroupID,ProductCode,OwnerName,Contact3,Seller  from Vehicle INNER JOIN VehicleDetail ON Vehicle.Id = VehicleDetail.VehID ";
            }
            else
            {
                //取所有列表ID
                //If sVersion = "SZHZ" Then
                //    strGroupList = GetAllVehGroupByGroup_UserID(adoConn, iUserID, sUserName)
                strGroupList = GetAllVehGroupByUserID(iUserID);

                if (strGroupList.Trim().Length == 0)
                {
                    strGroupList = "0";
                }

                strSQL = "SELECT Id,Deviceid, IpAddress, Cph, OwnNo,TaxiNo,VehGroupID,ProductCode,OwnerName,Contact3,Seller from Vehicle INNER JOIN VehicleDetail ON Vehicle.Id = VehicleDetail.VehID where VehicleDetail.VehGroupID in (" + strGroupList + ") ";
            }

            if (iUserID == 1)
            {
                strSQL = strSQL + " where (Vehicle.delflag is null) or (Vehicle.delflag=0)";
            }
            else
            {
                strSQL = strSQL + "  and ((Vehicle.delflag is null) or (Vehicle.delflag=0))";
            }
            DataSet ds = BllSql.RunSqlSelect(strSQL);
            return ds;
        }
        catch (Exception ex)
        {
            return null;
        }
    }
    
    public static DataSet GetServerTime(int iUserID, DateTime dt)
    {
        string strSQL = "";
        string strGroupList = "";
        try
        {
            if (iUserID == 1)
            {
                strSQL = "SELECT Id,PurchaseDate as ServerBeginTime,ServerEndTime  from Vehicle INNER JOIN VehicleDetail ON Vehicle.Id = VehicleDetail.VehID ";
            }
            else
            {
                //取所有列表ID
                strGroupList = GetAllVehGroupByUserID(iUserID);

                if (strGroupList.Trim().Length == 0)
                {
                    strGroupList = "0";
                }

                strSQL = "SELECT Id,PurchaseDate as ServerBeginTime,ServerEndTime from Vehicle INNER JOIN VehicleDetail ON Vehicle.Id = VehicleDetail.VehID where VehicleDetail.VehGroupID in (" + strGroupList + ") ";
            }

            if (iUserID == 1)
            {
                strSQL = strSQL + " where ServerEndTime <= '" + dt.ToString("yyyy-MM-dd HH:mm:ss") + "' and (Vehicle.delflag is null) or (Vehicle.delflag=0) order by ServerEndTime";
            }
            else
            {
                strSQL = strSQL + "  and ServerEndTime <= '" + dt.ToString("yyyy-MM-dd HH:mm:ss") + "' and ((Vehicle.delflag is null) or (Vehicle.delflag=0)) order by ServerEndTime";
            }
            DataSet ds = BllSql.RunSqlSelect(strSQL);
            return ds;
        }
        catch (Exception ex)
        {
            return null;
        }
    }

    public static DataSet GetAnnual(int iUserID, DateTime dt)
    {
        string strSQL = "";
        string strGroupList = "";
        try
        {
            if (iUserID == 1)
            {
                strSQL = "SELECT Id,RepairTime  from Vehicle INNER JOIN VehicleDetail ON Vehicle.Id = VehicleDetail.VehID ";
            }
            else
            {
                //取所有列表ID
                strGroupList = GetAllVehGroupByUserID(iUserID);

                if (strGroupList.Trim().Length == 0)
                {
                    strGroupList = "0";
                }

                strSQL = "SELECT Id,RepairTime from Vehicle INNER JOIN VehicleDetail ON Vehicle.Id = VehicleDetail.VehID where VehicleDetail.VehGroupID in (" + strGroupList + ") ";
            }

            if (iUserID == 1)
            {
                strSQL = strSQL + " where RepairTime <= '" + dt.ToString("yyyy-MM-dd HH:mm:ss") + "' and (Vehicle.delflag is null) or (Vehicle.delflag=0) order by RepairTime";
            }
            else
            {
                strSQL = strSQL + " and RepairTime <= '" + dt.ToString("yyyy-MM-dd HH:mm:ss") + "' and ((Vehicle.delflag is null) or (Vehicle.delflag=0)) order by RepairTime";
            }
            DataSet ds = BllSql.RunSqlSelect(strSQL);
            return ds;
        }
        catch (Exception ex)
        {
            return null;
        }
    }

    public static DataSet GetVehicleProvice(int iUserID)
    {
        string strSQL = "";
        string strGroupList = "";
        try
        {
            string sTime = DateTime.Now.AddDays(-30).ToString("yyyy-MM-dd HH:mm:ss");
            if (iUserID == 1)
            {
                strSQL = "SELECT VehID,Province,City from VehProvince where [Date] >= '" + sTime + "' ";
            }
            else
            {
                //取所有列表ID
                strGroupList = GetAllVehGroupByUserID(iUserID);

                if (strGroupList.Trim().Length == 0)
                {
                    strGroupList = "0";
                }

                strSQL = "SELECT VehProvince.VehID,Province,City from VehProvince INNER JOIN VehicleDetail ON VehProvince.VehId = VehicleDetail.VehID where  [Date] >= '" + sTime + "' and VehicleDetail.VehGroupID in (" + strGroupList + ") ";
            }

            DataSet ds = BllSql.RunSqlSelect(strSQL);
            return ds;
        }
        catch (Exception ex)
        {
            return null;
        }
    }

    public static int GetVehicleUsage(int iUserID, string sDbName, ref string strGroupList)
    {
        string strSQL = "";
        try
        {
            if (iUserID == 1)
            {
                strSQL = "SELECT count(1) from " + sDbName + ".dbo.VehOnline  ";
            }
            else
            {
                //取所有列表ID
                //If sVersion = "SZHZ" Then
                //    strGroupList = GetAllVehGroupByGroup_UserID(adoConn, iUserID, sUserName)
                if (strGroupList == "-1")
                {
                    strGroupList = GetAllVehGroupByUserID(iUserID);
                    if (strGroupList.Trim().Length == 0)
                    {
                        strGroupList = "0";
                    }
                }
                strSQL = "SELECT count(1) from VehicleDetail INNER JOIN " + sDbName + ".dbo.VehOnline as a ON VehicleDetail.VehID = a.VehID where VehicleDetail.VehGroupID in (" + strGroupList + ") ";
            }

            int iCount = BllSql.RunSqlScalar(strSQL);
            return iCount;
        }
        catch (Exception ex)
        {
            return 0;
        }
    }

    public static DataSet GetVehicleByID(string sVehID)
    {
        string strSQL = "";
        try
        {
            strSQL = "SELECT Id,Deviceid, IpAddress, Cph, OwnNo,TaxiNo,ProductCode,Decph,OwnerName,Contact1,AlarmLinkTel,Contact2,LinkTel2,Contact3,ContactPhone3,YyZh,ByZd,FrameNo,EngineNo,VehicleType,Color,PurchaseDate,ServerEndTime,EnrolDate,ServerMoney,Seller,LogOutCause,InstallPerson,InstallAddress,RecordPerson,BusinessPerson,PowerType,Marks,RepairTime,InsuranceTime,DistrictCode,WebPass,InsertTime  from Vehicle where Id = " + sVehID;

            DataSet ds = BllSql.RunSqlSelect(strSQL);
            return ds;
        }
        catch (Exception ex)
        {
            return null;
        }
    }

    public static DataSet GetAllVehicleByTeamID(int iTeamID)
    {
        string strSQL = "";
        try
        {
            strSQL = "SELECT Id,Deviceid, IpAddress, Cph, OwnNo,TaxiNo,ProductCode,Decph,OwnerName,Contact1,AlarmLinkTel,Contact2,LinkTel2,Contact3,ContactPhone3,YyZh,ByZd,FrameNo,EngineNo,VehicleType,Color,PurchaseDate,ServerEndTime,EnrolDate,ServerMoney,Seller,LogOutCause,InstallPerson,InstallAddress,RecordPerson,BusinessPerson,PowerType,Marks,RepairTime,InsuranceTime,DistrictCode,WebPass,InsertTime  from Vehicle inner join VehicleDetail on VehicleDetail.VehID = Vehicle.Id where VehGroupID = " + iTeamID.ToString();

            DataSet ds = BllSql.RunSqlSelect(strSQL);
            return ds;
        }
        catch (Exception ex)
        {
            return null;
        }
    }
}
