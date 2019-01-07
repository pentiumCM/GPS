<%@ WebHandler Language="C#" Class="datagrid_to_excel" %>

using System;
using System.Web;
using System.IO;
using System.Text;

public class datagrid_to_excel : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        //context.Response.ContentType = "text/plain";
        DateTime dtNow = DateTime.Now;
        if (!Directory.Exists(context.Server.MapPath("../Download")))
        {
            Directory.CreateDirectory(context.Server.MapPath("../Download"));
        }
        if (!Directory.Exists(context.Server.MapPath("../Download/Excel")))
        {
            Directory.CreateDirectory(context.Server.MapPath("../Download/Excel"));
        }
        DirectoryInfo TheFolder = new DirectoryInfo(context.Server.MapPath("../Download/Excel"));
        foreach (DirectoryInfo NextFolder in TheFolder.GetDirectories())
        {
            if (NextFolder.Name != dtNow.ToString("yyyy-MM-dd") && NextFolder.Name != dtNow.AddDays(-1).ToString("yyyy-MM-dd"))
            {
                if (NextFolder.Name.Equals(".svn"))
                {
                    continue; 
                }
                NextFolder.Delete(true);
            }
        }
        string fn = "../Download/Excel/" + dtNow.ToString("yyyy-MM-dd");

        if (!Directory.Exists(context.Server.MapPath(fn)))
        {
            Directory.CreateDirectory(context.Server.MapPath(fn));
        }
        fn = fn + "/" + dtNow.ToString("yyyyMMddHHmmssfff") + ".xls";
        string data = context.Request.Form["data"];
        File.WriteAllText(context.Server.MapPath(fn), data, Encoding.UTF8);//如果是gb2312的xml申明，第三个编码参数修改为Encoding.GetEncoding(936)
        fn = "Download/Excel/" + dtNow.ToString("yyyy-MM-dd") + "/" + dtNow.ToString("yyyyMMddHHmmssfff") + ".xls";
        
        context.Response.Write(fn);//返回文件名提供下载
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}