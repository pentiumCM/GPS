using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Globalization;
using System.Threading;

/// <summary>
///PageBase 的摘要说明
/// </summary>
public class PageBaseK1 : System.Web.UI.Page
{
    public PageBaseK1()
    {
        //
        //TODO: 在此处添加构造函数逻辑
        //
    }

    private void PageBaseK1_Load(object sender, EventArgs e)
    {

    }

    private void PageBaseK1_PreRender(object sender, EventArgs e)
    {
 
    }

    private void PageBaseK1_Error(object sender, EventArgs e)
    {
 
    }

    protected override void OnInit(EventArgs e)
    {
        string sLan = Request.QueryString["lan"];
        if (string.IsNullOrEmpty(sLan))
        {
            if (Request.Cookies["lana"] != null)
            {
                sLan = Request.Cookies["lana"].Value;
            }
            else
            {
                sLan = "zh-CN";
            }
        }
        CultureInfo s = new CultureInfo(sLan);//zh-CN,en-US 是设置语言类型
        Thread.CurrentThread.CurrentUICulture = s;
        string sRoot = ConfigurationManager.AppSettings["Root"];
        if (sRoot.Length > 0)
        {
            sRoot += "/";
        }
        if (Session["userid"] != null)
        {
            object sUserid = Session["userid"];
            //Response.Redirect("/" + sRoot + "Login.aspx", true);

        }
        else
        {
            string sNoSession = System.Configuration.ConfigurationManager.AppSettings["NoSession"];
            if (sNoSession == "1")
            {
                Response.Write("<script>if (top.location !== self.location) {top.location='/" + sRoot + "K/Login.aspx';} else {self.location='/" + sRoot + "K/Login.aspx';}</script>");
            }
            //Server.Transfer("Login.aspx", false);
            //Response.Redirect("/" + sRoot + "Login.aspx", true);
        }
        base.OnInit(e);
    }
}
