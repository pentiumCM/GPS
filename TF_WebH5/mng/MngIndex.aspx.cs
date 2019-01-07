using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Globalization;
using System.Threading;
using Models;
using System.Collections.Generic;

public partial class mng_MngIndex : PageBaseAdmin
{
    public string sUserName = "";
    public string sVehGroup = "";
    public string sUserGroup = "";
    public string sUser = "";
    public string sUserType = "3";

    protected void Page_Load(object sender, EventArgs e)
    {
        //http://localhost:12358/TF_WebH5/login.aspx?rUser=d3lz&rPwd=d3lz
        if (Request.Cookies["m_username"] != null)
        {
            sUserName = Request.Cookies["m_username"].Value;
            sUserName = System.Web.HttpUtility.UrlDecode(sUserName);
        }
        try
        {
            string sLoginType = "1";
            if (Request.Cookies["m_logintype"] != null)
            {
                sLoginType = Request.Cookies["m_logintype"].Value;
            }
            object sUserID = Session["m_userid"];
            if (sUserID == null)
            {
                Response.Write(BllCommon.Transferlocation());
                return;
            }
            if (!IsPostBack)
            {
                //获取车组
                if (sLoginType == "1")
                {
                    DataSet ds = BllVehicle.GetVehGroupFromLogin(Convert.ToInt32(sUserID));
                    List<CVehGroup> lstVehGroup = new List<CVehGroup>();
                    Hashtable htGroupPID = new Hashtable();
                    Hashtable htGroupID = new Hashtable();
                    if (ds != null && ds.Tables.Count > 0)
                    {
                        foreach (DataRow dr in ds.Tables[0].Rows)
                        {
                            string id = "G" + dr["VehGroupID"];
                            string PID = "G" + dr["fVehGroupID"];
                            if (!htGroupPID.ContainsKey(PID))
                            {
                                htGroupPID.Add(PID, id);
                            }
                            if (!htGroupID.ContainsKey(id))
                            {
                                htGroupID.Add(id, PID);
                            }
                        }
                        foreach (DataRow dr in ds.Tables[0].Rows)
                        {
                            CVehGroup vehGroup = new CVehGroup();
                            vehGroup.id = "G" + dr["VehGroupID"];
                            vehGroup.name = dr["VehGroupName"].ToString();
                            vehGroup.PID = "G" + dr["fVehGroupID"];
                            vehGroup.HasChild = 0;
                            vehGroup.Root = 0;
                            if (htGroupPID.ContainsKey(vehGroup.id))
                            {
                                vehGroup.HasChild = 1;
                            }
                            if (!htGroupID.ContainsKey(vehGroup.PID))
                            {
                                vehGroup.Root = 1;
                            }
                            lstVehGroup.Add(vehGroup);
                        }
                    }
                    string json5 = JsonHelper.SerializeObject(lstVehGroup);
                    sVehGroup = json5;

                    //获取用户信息
                    int iGroupID = -1;
                    DataSet dsUserGroup = BllVehicle.GetUserGroupFromLogin(Convert.ToInt32(sUserID));
                    if (dsUserGroup == null || dsUserGroup.Tables.Count == 0 || dsUserGroup.Tables[0].Rows.Count == 0)
                    {
                        CUserGroup cModel = new CUserGroup();
                        cModel.HasChild = 0;
                        cModel.id = "U_User";
                        cModel.name = "用户管理";
                        cModel.PID = "";
                        cModel.Root = 1;
                        List<CUserGroup> lstUserGroup = new List<CUserGroup>();
                        lstUserGroup.Add(cModel);
                        string jsonUserGroup = JsonHelper.SerializeObject(lstUserGroup);
                        sUserGroup = jsonUserGroup;
                    }
                    else
                    {
                        List<CUserGroup> lstUserGroup = new List<CUserGroup>();
                        CUserGroup cModel = new CUserGroup();
                        cModel.HasChild = 0;
                        cModel.id = "M_User";
                        cModel.name = "用户管理";
                        cModel.PID = "";
                        cModel.Root = 1;
                        lstUserGroup.Add(cModel);
                        foreach (DataRow dr in dsUserGroup.Tables[0].Rows)
                        {
                            cModel = new CUserGroup();
                            cModel.HasChild = 0;
                            iGroupID = Convert.ToInt32(dr["UserGroupID"]);
                            cModel.id = "U" + dr["UserGroupID"].ToString();
                            cModel.name = dr["UserGroupName"].ToString();
                            cModel.PID = "M_User";
                            cModel.Root = 1;
                            lstUserGroup.Add(cModel);
                        }
                        string jsonUserGroup = JsonHelper.SerializeObject(lstUserGroup);
                        sUserGroup = jsonUserGroup;
                    }
                    //获取用户
                    DataSet dsUser = BllVehicle.GetUserFromLogin(Convert.ToInt32(sUserID), iGroupID);
                    if (dsUser == null || dsUser.Tables.Count == 0 || dsUser.Tables[0].Rows.Count == 0)
                    {
                        List<CUser> lstUser = new List<CUser>();
                        string jsonUser = JsonHelper.SerializeObject(lstUser);
                        sUser = jsonUser;
                    }
                    else
                    {
                        List<CUser> lstUser = new List<CUser>();
                        foreach (DataRow dr in dsUser.Tables[0].Rows)
                        {
                            if (sUserID.Equals(dr["UserID"].ToString()))
                            {
                                sUserType = dr["UserTypeID"].ToString();
                                break;
                            }
                        }
                        foreach (DataRow dr in dsUser.Tables[0].Rows)
                        {
                            if (sUserType == "1" || sUserID.Equals(dr["UserID"].ToString()))
                            {
                                CUser cModel = new CUser();
                                cModel.HasChild = 0;
                                cModel.id = "R" + dr["UserID"].ToString();
                                cModel.name = dr["UserName"].ToString();
                                cModel.PID = "U" + dr["UserGroupID"].ToString();
                                lstUser.Add(cModel);
                            }
                        }
                        string jsonUser = JsonHelper.SerializeObject(lstUser);
                        sUser = jsonUser;
                    }
                }
                else
                {
                    List<CVehGroup> lstVehGroup = new List<CVehGroup>();
                    CVehGroup vehGroup = new CVehGroup();
                    vehGroup.id = "G0";
                    vehGroup.name = "我的车辆";
                    vehGroup.PID = "G-1";
                    vehGroup.HasChild = 0;
                    vehGroup.Root = 1;
                    lstVehGroup.Add(vehGroup);
                    string json5 = JsonHelper.SerializeObject(lstVehGroup);
                    sVehGroup = json5;
                }
            }
        }
        catch (Exception Exception)
        {

        }
    }

    private void AddCookie(string sName, string sValue)
    {
        HttpCookie cookie = new HttpCookie(sName);
        cookie.Value = sValue;
        cookie.Expires = DateTime.Now.AddDays(30);
        HttpContext.Current.Response.Cookies.Add(cookie); 
    }

    private string ReadCookie(string sName)
    {
        if (Request.Cookies[sName] != null)
        {
            //Response.Write("Cookie中键值为userid的值:" + Request.Cookies["MyCook"]["userid"]);//整行
            //Response.Write("Cookie中键值为userid2的值" + Request.Cookies["MyCook"]["userid2"]);
            return HttpContext.Current.Request.Cookies[sName].Value;
        }
        return null;
    }

    private void ModifyCookie(string sName, string sValue)
    {
        if (Request.Cookies[sName] != null)
        {
            //修改Cookie的两种方法
            Request.Cookies[sName].Value = sValue;
            Request.Cookies[sName].Expires = DateTime.Now.AddDays(30);
            //cok.Values["userid"] = "alter-value";
            Response.AppendCookie(Request.Cookies[sName]);
        }  
    }

    private void DelCookie(string sName)
    {
        HttpCookie cok = Request.Cookies[sName];
        if (cok != null)
        {
            cok.Expires = DateTime.Now.AddDays(-1);
            Response.AppendCookie(cok);
        }
    }

    protected void btnClearSessionCS_Click(object sender, EventArgs e)
    {
        Session["m_userid"] = null;
        Response.Redirect("MngIndex.aspx", true);
    }
}
