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
using System.Text;

public partial class Mobile_Index : PageMobileBase
{
    public string sUserName = "";
    public string sVehGroup = "";
    public string sPermission = "";
    public string sOil = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.Cookies["username"] != null)
        {
            sUserName = Request.Cookies["username"].Value;
            sUserName = System.Web.HttpUtility.UrlDecode(sUserName);
        }
        try
        {
            string sLoginType = "1";
            if (Request.Cookies["logintype"] != null)
            {
                sLoginType = Request.Cookies["logintype"].Value;
            }
            object sUserID = Session["userid"];
            if(sUserID == null)
            {
                Response.Write(BllCommon.TransferMobilelocation());
                return;
            }
            string sGroups = "0";
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
                            if (sUserID != "1")
                            {
                                sGroups = sGroups + "," + dr["VehGroupID"].ToString();
                            }
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
                    //ViewState["VehGroup"] = json5;
                    sVehGroup = json5;
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
                    //ViewState["VehGroup"] = json5;
                    sVehGroup = json5;
                }
                //if (Request.Cookies["VehGroup"] == null)
                //{
                //    AddCookie("VehGroup", json5);
                //}
                //else
                //{
                //    ModifyCookie("VehGroup", json5);
                //}
                if (sLoginType == "1")
                {
                    if (sUserID.ToString() == "1")
                    {

                    }
                    else
                    {
                        DataSet dsPermission = BllSql.RunSqlSelect("select FuncID from UserPermission where UserID = " + sUserID.ToString());
                        if (dsPermission != null && dsPermission.Tables.Count > 0 && dsPermission.Tables[0].Rows.Count > 0)
                        {
                            sPermission = dsPermission.Tables[0].Rows[0][0].ToString();
                        }
                    }
                }
                else
                {
                    sPermission = "5006";
                }
                List<COil> lstOil = new List<COil>();
                if (sLoginType == "1")
                {
                    DataSet dsOil = null;
                    if (sUserID.ToString() == "1")
                    {
                        dsOil = BllSql.RunSqlSelect("SELECT Vehyh_Table.r_id, Vehyh_Table.VehID, Vehyh_Table.Veh_Cph, Vehyh_Table.YH_Scale, Vehyh_Table.YH_Number, Vehyh_Table.oilminu, Vehyh_Table.oilpercent  FROM Vehyh_Table INNER JOIN VehicleDetail ON Vehyh_Table.VehID = VehicleDetail.VehID");
                    }
                    else
                    {
                        dsOil = BllSql.RunSqlSelect("SELECT Vehyh_Table.r_id, Vehyh_Table.VehID, Vehyh_Table.Veh_Cph, Vehyh_Table.YH_Scale, Vehyh_Table.YH_Number, Vehyh_Table.oilminu, Vehyh_Table.oilpercent  FROM Vehyh_Table INNER JOIN VehicleDetail ON Vehyh_Table.VehID = VehicleDetail.VehID where VehicleDetail.VehGroupID in(" + sGroups + ")");
                    }
                    if (dsOil != null && dsOil.Tables.Count > 0 && dsOil.Tables[0].Rows.Count > 0)
                    {
                        foreach (DataRow dr in dsOil.Tables[0].Rows)
                        {
                            string sVeh = "V" + dr["VehID"].ToString();
                            COil cOil = new COil();
                            foreach (COil item in lstOil)
                            {
                                if (item.VehID == sVeh)
                                {
                                    cOil = item;
                                    break;
                                }
                            }
                            cOil.Cph = dr["Veh_Cph"].ToString();
                            cOil.id = Convert.ToInt32(dr["r_id"]);
                            COilDetail cDetail = new COilDetail();
                            cDetail.OilValue = Convert.ToDouble(dr["YH_Number"]);
                            cDetail.Scale = Convert.ToDouble(dr["YH_Scale"]);
                            cOil.lstDetail.Add(cDetail);
                            cOil.StealOil = Convert.ToInt32(dr["oilpercent"]);
                            cOil.VehID = "V" + dr["VehID"].ToString();
                            lstOil.Add(cOil);
                        }
                    }
                }
                else
                {
                    DataSet dsOil = BllSql.RunSqlSelect("SELECT Vehyh_Table.r_id, Vehyh_Table.VehID, Vehyh_Table.Veh_Cph, Vehyh_Table.YH_Scale, Vehyh_Table.YH_Number, Vehyh_Table.oilminu, Vehyh_Table.oilpercent  FROM Vehyh_Table INNER JOIN VehicleDetail ON Vehyh_Table.VehID = VehicleDetail.VehID where Vehyh_Table.VehID =" + sUserID);
                    if (dsOil != null && dsOil.Tables.Count > 0 && dsOil.Tables[0].Rows.Count > 0)
                    {
                        foreach (DataRow dr in dsOil.Tables[0].Rows)
                        {
                            string sVeh = "V" + dr["VehID"].ToString();
                            COil cOil = new COil();
                            foreach (COil item in lstOil)
                            {
                                if (item.VehID == sVeh)
                                {
                                    cOil = item;
                                    break;
                                }
                            }
                            cOil.Cph = dr["Veh_Cph"].ToString();
                            cOil.id = Convert.ToInt32(dr["r_id"]);
                            COilDetail cDetail = new COilDetail();
                            cDetail.OilValue = Convert.ToDouble(dr["YH_Number"]);
                            cDetail.Scale = Convert.ToDouble(dr["YH_Scale"]);
                            cOil.lstDetail.Add(cDetail);
                            cOil.StealOil = Convert.ToInt32(dr["oilpercent"]);
                            cOil.VehID = "V" + dr["VehID"].ToString();
                            lstOil.Add(cOil);
                        }
                    }
                }
                string jsonOil = JsonHelper.SerializeObject(lstOil);
                sOil = jsonOil;
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
        //StringBuilder sb = new StringBuilder();
        //sb.Append("<script language='javascript'>");
        //sb.AppendLine("var Days = 3;");
        //sb.AppendLine("var exp = new Date();");
        //sb.AppendLine("exp.setTime(exp.getTime() + Days * 24 * 60 * 60 * 1000);");
        //sb.AppendLine("document.cookie = " + sName + "=escape(" + sValue + ") ;expires=exp.toGMTString();");
        //sb.Append("</script>");
        //ClientScript.RegisterStartupScript(this.GetType(), "LoadPicScript", sb.ToString()); 
    }

    protected void btnClearSessionCS_Click(object sender, EventArgs e)
    {
        Session["userid"] = null;
        Response.Redirect("Index.aspx", true);
    }
}
