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

public partial class Login : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        //http://localhost:12358/TF_WebH5/login.aspx?rUser=d3lz&rPwd=d3lz
        string sLan = Request.QueryString["lan"];
        //string str = @"\u63a8\u9001\u8bf7\u6c42\u5931\u8d25";
        //string[] temp = str.Split(new string[] { "\\u" }, StringSplitOptions.RemoveEmptyEntries);
        //for (int i = 0; i < temp.Length; i++)
        //    temp[i] = ((char)Convert.ToInt32(temp[i], 16)).ToString();
        //string result = string.Join("", temp);
        //string sPar = "V=1";
        //byte[] bytes = System.Text.Encoding.Default.GetBytes(sPar);
        //sPar = Convert.ToBase64String(bytes);
        //string sUrl = System.Web.HttpUtility.UrlEncode(System.Web.HttpUtility.HtmlEncode("http://www.tecofirst.com/wxcc/Pages/FormHuoZhen.aspx?rurl=Pages/FormLoginCompany.html"), System.Text.Encoding.GetEncoding("gb2312"));
        if (string.IsNullOrEmpty(sLan))
        {
            if (Request.Cookies["lana"] != null)
            {
                sLan = Request.Cookies["lana"].Value;
            }
            else
            {
                sLan = "zh-CN";
                AddCookie("lana", sLan);
            }
        }
        else
        {
            if (Request.Cookies["lana"] != null)
            {
                ModifyCookie("lana", sLan);
            }
            else
            {
                AddCookie("lana", sLan);
            }
        }
        CultureInfo s = new CultureInfo(sLan);//zh-CN,en-US 是设置语言类型
        Thread.CurrentThread.CurrentUICulture = s;


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

    protected void btnLoginCS_Click(object sender, EventArgs e)
    {
        if (Request.Cookies["userid"] != null)
        {
            Session["userid"] = Request.Cookies["userid"].Value;
            Response.Redirect("Index.aspx", true);
        }
    }
}
