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
using System.Collections.Generic;
using Models;

public partial class K_KIndex : PageBaseK1
{
    public string sUserName = "";
    public string sVehGroup = "";
    public string sPermission = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.Cookies["username"] != null)
        {
            sUserName = Request.Cookies["username"].Value;
            sUserName = System.Web.HttpUtility.UrlDecode(sUserName);
        }
        try
        {
            object sUserID = Session["userid"];
            if (sUserID == null)
            {
                Response.Write(BllCommon.TransferlocationK1());
                return;
            }
            if (!IsPostBack)
            {
                //获取车组
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

    protected void btnClearSessionCS_Click(object sender, EventArgs e)
    {
        Session["userid"] = null;
        Response.Redirect("Login.aspx", true);
    }
}
