using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;

/// <summary>
///Common 的摘要说明
/// </summary>
public class BllCommon
{
    public BllCommon()
    {
        //
        //TODO: 在此处添加构造函数逻辑
        //
    }

    public static string Transferlocation()
    {
        string sRoot = ConfigurationManager.AppSettings["Root"];
        if (sRoot.Length > 0)
        {
            sRoot += "/";
        }
        return "<script>if (top.location !== self.location) {top.location='/" + sRoot + "Login.aspx';} else {self.location='/" + sRoot + "Login.aspx';}</script>";
    }

    public static string TransferlocationK1()
    {
        string sRoot = ConfigurationManager.AppSettings["Root"];
        if (sRoot.Length > 0)
        {
            sRoot += "/";
        }
        sRoot = sRoot + "K/";
        return "<script>if (top.location !== self.location) {top.location='/" + sRoot + "Login.aspx';} else {self.location='/" + sRoot + "Login.aspx';}</script>";
    }

    public static string TransferMobilelocation()
    {
        string sRoot = ConfigurationManager.AppSettings["Root"];
        if (sRoot.Length > 0)
        {
            sRoot += "/";
        }
        return "<script>if (top.location !== self.location) {top.location='/" + sRoot + "Mobile/Login.aspx';} else {self.location='/" + sRoot + "Mobile/Login.aspx';}</script>";
    }

    public static void AddOpNoteFromVehMgr(string sType, int iVehID, string sOpDetail, string sMark, string sUserName, string sIpDetail, int iUserID, object[] arrOther)
    {
        try
        {
            string sOpTime = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
            int iOpType = 0;
            string sDBName = "Bee" + DateTime.Now.ToString("yyyyMMdd") + "..OptNotes";
            string strSQL = "";
            if (sType == "EditUser")
            {
                int iEditUserID = iUserID;
                int blnIsEdit = Convert.ToInt32(arrOther[0]);
                if (blnIsEdit == 1)
                {
                    sOpDetail = "用户【" + sUserName + "】编辑用户【" + arrOther[1].ToString() + "】信息";
                    sMark = "编辑用户信息";
                }
                else
                {
                    sOpDetail = "用户【" + sUserName + "】添加用户【" + arrOther[1] + "】信息";
                    sMark = "添加用户信息";
                }
            }
            else if (sType == "DelUser")
            {
                sOpDetail = "用户【" + sUserName + "】删除用户【" + arrOther[0].ToString() + "】信息";
                sMark = "删除用户信息";
            }
            else if (sType == "EditUserGroup")
            {
                int bInIsEdit = Convert.ToInt32(arrOther[0]);
                string sEditUserGroupString = arrOther[1].ToString();
                if (bInIsEdit == 1)
                {
                    sOpDetail = "用户【" + sUserName + "】添加用户组【" + sEditUserGroupString + "】信息";
                    sMark = "添加用户组信息";
                }
                else
                {
                    sOpDetail = "用户【" + sUserName + "】编辑用户组" + arrOther[1].ToString() + "为【" + arrOther[2].ToString() + "】信息";
                    //sOpDetail = "用户【" + sUserName + "】" + sEditUserGroupString
                    sMark = "编辑用户组信息";
                }
            }
            else if (sType == "DelUserGroup")
            {
                sOpDetail = "用户【" + sUserName + "】删除用户组【" + arrOther[0].ToString() + " ID：" + arrOther[1].ToString() + "】信息";

                sMark = "删除用户组信息";
            }
            else if (sType == "EditVeh")
            {
                int bInIsEdit = Convert.ToInt32(arrOther[0]);
                string sOldEditVeh = arrOther[1].ToString();
                if (bInIsEdit == 0)
                {
                    iVehID = Convert.ToInt32(arrOther[2]);
                    sOpDetail = "用户【" + sUserName + "】编辑车辆" + sOldEditVeh + "为【" + arrOther[3].ToString() + "】信息";

                    sMark = "编辑车辆信息";
                }
                else
                {
                    sOpDetail = "用户【" + sUserName + "】添加车辆【" + arrOther[3].ToString() + "】信息";
                    sMark = "添加车辆信息";
                }
            }
            else if (sType == "EditVehGroup")
            {
                int bInIsEdit = Convert.ToInt32(arrOther[0]);
                if (bInIsEdit == 0)
                {
                    string sOldGroupName = arrOther[1].ToString();
                    sOpDetail = "用户【" + sUserName + "】编辑车组" + sOldGroupName + "为【" + arrOther[2].ToString() + "】";
                    sMark = "编辑车组信息";
                }
                else
                {
                    string sOldGroupName = arrOther[1].ToString();
                    sOpDetail = "用户【" + sUserName + "】添加车组【" + arrOther[2].ToString() + "】信息";
                    sMark = "添加车组信息";
                }
            }
            else if (sType == "DeleteVehGroup")
            {
                sOpDetail = "用户【" + sUserName + "】删除车组【" + arrOther[0].ToString() + " ID：" + arrOther[1].ToString() + "】信息";
                sMark = "删除车组信息";
            }
            else if (sType == "DelVeh")
            {
                iVehID = Convert.ToInt32(arrOther[0]);
                sOpDetail = "用户【" + sUserName + "】删除车辆【" + arrOther[1].ToString() + "】信息";
                sMark = "删除车辆信息";
            }
            else if (sType == "RecycleVehicle")
            {
                int iOpRecycleVehicleType = Convert.ToInt32(arrOther[0]);
                if (iOpRecycleVehicleType == 1)
                {
                    sOpDetail = "用户【" + sUserName + "】恢复车辆【" + arrOther[1].ToString() + "】信息";
                    sMark = "恢复车辆信息";
                }
                else if (iOpRecycleVehicleType == 2)
                {
                    sOpDetail = "用户【" + sUserName + "】彻底删除车辆【" + arrOther[1].ToString() + "】信息";
                    sMark = "彻底删除车辆信息";
                }
            }
            else if (sType == "RecycleVehGroup")
            {
                int iOpRecycleVehGroupType = Convert.ToInt32(arrOther[0]);
                if (iOpRecycleVehGroupType == 1)
                {
                    sOpDetail = "用户【" + sUserName + "】恢复车组【" + arrOther[1].ToString() + "】信息";
                    sMark = "恢复车组信息";
                }
                else if (iOpRecycleVehGroupType == 2)
                {
                    sOpDetail = "用户【" + sUserName + "】彻底删除车组【" + arrOther[1].ToString() + "】信息";
                    sMark = "彻底删除车组信息";
                }
            }
            else if (sType == "RecycleUser")
            {
                int iOpRecycleUserType = Convert.ToInt32(arrOther[0]);
                if (iOpRecycleUserType == 1)
                {
                    sOpDetail = "用户【" + sUserName + "】恢复用户【" + arrOther[1].ToString() + "】信息";
                    sMark = "恢复用户信息";
                }
                else if (iOpRecycleUserType == 2)
                {
                    sOpDetail = "用户【" + sUserName + "】彻底删除用户【" + arrOther[1].ToString() + "】信息";
                    sMark = "彻底删除用户信息";
                }
            }
            else if (sType == "RecycleUserGroup")
            {
                int iOpRecycleUserGroupType = Convert.ToInt32(arrOther[0]);
                if (iOpRecycleUserGroupType == 1)
                {
                    sOpDetail = "用户【" + sUserName + "】恢复用户组【" + arrOther[1].ToString() + "】信息";
                    sMark = "恢复用户组信息";
                }
                else if (iOpRecycleUserGroupType == 2)
                {
                    sOpDetail = "用户【" + sUserName + "】彻底删除用户组【" + arrOther[1].ToString() + "】信息";
                    sMark = "彻底删除用户组信息";
                }
            }

            strSQL = " insert into " + sDBName + "(UserID,UserLoginDetail,OpTime,VehID,OpType,OpDetail,Mark) "
                                        + " values(" + iUserID.ToString() + ",'" + sIpDetail + "',getdate()," + iVehID.ToString() + "," + iOpType.ToString() + ",'" + sOpDetail + "','" + sMark + "') ";
            string sErr = "";
            BllSql.RunSqlExecute(strSQL, out sErr);
        }
        catch (Exception ex)
        {

        }
    }

    // 递归遍历一个车组下的所有子车组
    public static bool RecursiveVehGroup(int iGroupID, ref string strGroupID)
    {
        string strSQL;
        int n;
        System.Collections.Generic.List<Models.CVehGroup> db = new System.Collections.Generic.List<Models.CVehGroup>();

        try
        {
            //一次性查出所有的车组关系
            strSQL = "SELECT VehGroupID,fVehGroupID FROM VehGroupDetail ";
            DataSet ds = BllSql.RunSqlSelect(strSQL);
            n = ds.Tables[0].Rows.Count;
            //如果有数据
            if (n >= 1)
            {
                //复制下来
                string id;
                string pid;
                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    id = ds.Tables[0].Rows[i]["VehGroupID"].ToString();
                    pid = ds.Tables[0].Rows[i]["fVehGroupID"].ToString();
                    Models.CVehGroup model = new Models.CVehGroup();
                    model.id = id;
                    model.PID = pid;
                    db.Add(model);
                }
                string sGroupIDTemp = iGroupID.ToString();
                for (int i = 0; i < db.Count; i++)
                {
                    //找到它的子节点
                    if (db[i].PID == sGroupIDTemp)
                    {
                        strGroupID += db[i].id + ",";
                        getChileVehGroup(db, db[i].id, ref strGroupID);
                    }
                }
                if (strGroupID.Length >= 1)
                {
                    if (strGroupID.Substring(strGroupID.Length - 1, 1) == ",")
                    {
                        strGroupID = strGroupID.Substring(0, strGroupID.Length - 1);
                    }
                }
            }
            return true;
        }
        catch (Exception ex)
        {
            return false;
        }
        finally
        {

        }
    }

    private static void getChileVehGroup(System.Collections.Generic.List<Models.CVehGroup> db, string iID, ref string s)
    {
        for (int i = 0; i < db.Count; i++)
        {
            //找到它的子节点
            if (db[i].PID == iID)
            {
                if (CheckHaveChild(iID, s) == true)
                {
                    s += db[i].id + ",";
                    getChileVehGroup(db, db[i].id, ref s);
                }
            }
        }
    }

    //递归遍历一个车组下的所有子车组
    public static bool RecursiveVehParentGroup(int iGroupID, ref string strGroupID)
    {
        string strSQL;
        int n;
        System.Collections.Generic.List<Models.CVehGroup> db = new System.Collections.Generic.List<Models.CVehGroup>();
        try
        {
            //一次性查出所有的车组关系
            strSQL = "SELECT VehGroupID,fVehGroupID FROM VehGroupDetail ";
            DataSet ds = BllSql.RunSqlSelect(strSQL);
            n = ds.Tables[0].Rows.Count;
            //如果有数据
            if (n >= 1)
            {
                //复制下来
                string id;
                string pid;

                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    id = ds.Tables[0].Rows[i]["VehGroupID"].ToString();
                    pid = ds.Tables[0].Rows[i]["fVehGroupID"].ToString();
                    Models.CVehGroup model = new Models.CVehGroup();
                    model.PID = pid;
                    model.id = id;
                    db.Add(model);
                }
                string sGroupIDTemp = iGroupID.ToString();
                for (int i = 0; i < db.Count; i++)
                {
                    //找到它的子节点
                    if (db[i].id == sGroupIDTemp)
                    {
                        if (db[i].PID == "-1")
                        {
                            break;
                        }
                        strGroupID += db[i].PID + ",";
                        getParentVehGroup(db, db[i].PID, ref strGroupID);
                    }
                }
                if (strGroupID.Length >= 1)
                {
                    if (strGroupID.Substring(strGroupID.Length - 1, 1) == ",")
                    {
                        strGroupID = strGroupID.Substring(0, strGroupID.Length - 1);
                    }
                }
            }
            return true;
        }
        catch (Exception ex)
        {
            return false;
        }
    }

    //判断节点是否己加入
    private static bool CheckHaveChild(string id, string s)
    {
        try
        {
            bool blnResult = false;
            string[] astrTemp = s.Split(',');
            int iTemp;
            for (int i = 0; i < astrTemp.Length; i++)
            {
                if (int.TryParse(astrTemp[i], out iTemp))
                {
                    if (astrTemp[i] == id)
                    {
                        blnResult = true;
                        break;
                    }
                }
            }
            return blnResult;
        }
        catch (Exception ex)
        {
            return true;
        }
    }

    private static void getParentVehGroup(System.Collections.Generic.List<Models.CVehGroup> db, string iID, ref string s)
    {
        for (int i = 0; i < db.Count; i++)
        {
            //找到它的子节点
            if (db[i].id == iID)
            {
                if (db[i].PID == "-1")
                {
                    break;
                }
                s += db[i].PID + ",";
                getParentVehGroup(db, db[i].PID, ref s);
            }
        }
    }

    public static bool IsUserLogin(string sUserName, string sPwd, out int iUserID, out string sErr)
    {
        iUserID = -1;
        sErr = "";
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
        string sSql = "select ExpirationTime,UserID from usermain where username = @UserName and password = @Password and DelPurview = 0 ";
        System.Data.DataSet ds = BllSql.RunSqlSelectParameters(false, sSql, lstPar, out sErr);
        if (sErr.Length > 0)
        {
            return false;
        }
        else
        {
            if (ds == null || ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0)
            {
                sErr = "4004";
                return false;
            }
            else
            {
                try
                {
                    DateTime dtTime = DateTime.Parse(ds.Tables[0].Rows[0]["ExpirationTime"].ToString());
                    if (dtTime.Subtract(DateTime.Now).TotalMinutes > 0)
                    {
                        iUserID = Convert.ToInt32(ds.Tables[0].Rows[0]["UserID"]);
                        return true;
                    }
                    else
                    {
                        sErr = "4005";
                        return false;
                    }
                    return false;
                }
                catch { }
                sErr = "4006";
                return false;
            }
        }
    }

    public static bool IsVehLogin(string sUserName, string sPwd, out int iUserID, out string sErr)
    {
        iUserID = -1;
        sErr = "";
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
        string sSql = "select Id from Vehicle where Cph = @UserName and WebPass = @Password and DelFlag = 0 ";
        System.Data.DataSet ds = BllSql.RunSqlSelectParameters(false, sSql, lstPar, out sErr);
        if (sErr.Length > 0)
        {
            return false;
        }
        else
        {
            if (ds == null || ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0)
            {
                sErr = "4004";
                return false;
            }
            else
            {
                try
                {
                    iUserID = Convert.ToInt32(ds.Tables[0].Rows[0]["Id"]);
                    return true;
                }
                catch { }
                sErr = "4006";
                return false;
            }
        }
    }
}
