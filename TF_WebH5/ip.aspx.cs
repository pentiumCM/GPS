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

public partial class ip : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string sIP = Request.ServerVariables["REMOTE_ADDR"];
        Response.Write(sIP);
    }
}
