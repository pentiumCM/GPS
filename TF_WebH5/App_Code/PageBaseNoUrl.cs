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
public class PageBaseNoUrl : System.Web.UI.Page
{
    public PageBaseNoUrl()
    {
        //
        //TODO: 在此处添加构造函数逻辑
        //
    }

    private void PageBase_Load(object sender, EventArgs e)
    {

    }

    private void PageBase_PreRender(object sender, EventArgs e)
    {
 
    }

    private void PageBase_Error(object sender, EventArgs e)
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
        //if (Session["userid"] != null)
        //{
        //    object sUserid = Session["userid"];
        //    //Response.Redirect("/" + sRoot + "Login.aspx", true);

        //}
        //else
        //{
        //    Response.Write("<script>if (top.location !== self.location) {top.location='/" + sRoot + "Login.aspx';} else {self.location='/" + sRoot + "Login.aspx';}</script>");
        //    //Server.Transfer("Login.aspx", false);
        //    //Response.Redirect("/" + sRoot + "Login.aspx", true);
        //}
        base.OnInit(e);
    }
}
