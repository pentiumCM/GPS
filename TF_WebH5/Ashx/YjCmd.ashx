<%@ WebHandler Language="C#" Class="YjCmd" %>

using System;
using System.Web;

public class YjCmd : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        try
        {
            //System.Globalization.CultureInfo s = new System.Globalization.CultureInfo("en - US");//zh-CN,en-US 是设置语言类型
            //System.Threading.Thread.CurrentThread.CurrentUICulture = s;
            string sLat = context.Request["lat"];
            string sLng = context.Request["lng"];
            string sDes = context.Request["des"];
            string sType = context.Request["type"];
            string sCph = context.Request["cph"];
            string sCid = context.Request["cid"];
            if (sType == "savepic")
            {
                string sSrc = context.Request["src"];
                string sTime = context.Request["stime"];
                if (string.IsNullOrEmpty(sCph) || string.IsNullOrEmpty(sSrc) || string.IsNullOrEmpty(sTime))
                {
                    Models.CYunJing cReturn = new Models.CYunJing();
                    cReturn.error = "31";
                    cReturn.data = "";
                    cReturn.errormsg = "参数错误！";
                    string sJson = JsonHelper.SerializeObject(cReturn);
                    context.Response.Write(sJson);
                    return;
                }
                if (!SqlFilter.Filter.ProcessFilter(ref sSrc) || !SqlFilter.Filter.ProcessFilter(ref sTime))
                {
                    Models.CYunJing cReturn = new Models.CYunJing();
                    cReturn.error = "31";
                    cReturn.data = "";
                    cReturn.errormsg = "参数错误！";
                    string sJson = JsonHelper.SerializeObject(cReturn);
                    context.Response.Write(sJson);
                    return;
                }
                context.Response.Write(SaveImg(int.Parse(sCph),sTime, sSrc));
                return;
            }

            if ((string.IsNullOrEmpty(sCph) && string.IsNullOrEmpty(sCid)) || string.IsNullOrEmpty(sLat) || string.IsNullOrEmpty(sLng) || string.IsNullOrEmpty(sType) || string.IsNullOrEmpty(sDes))
            {
                Models.CYunJing cReturn = new Models.CYunJing();
                cReturn.error = "31";
                cReturn.data = "";
                cReturn.errormsg = "参数错误！";
                string sJson = JsonHelper.SerializeObject(cReturn);
                context.Response.Write(sJson);
                return;
            }
            else
            {
                if (!SqlFilter.Filter.ProcessFilter(ref sCph) || !SqlFilter.Filter.ProcessFilter(ref sCid))
                {
                    Models.CYunJing cReturn = new Models.CYunJing();
                    cReturn.error = "31";
                    cReturn.data = "";
                    cReturn.errormsg = "参数错误！";
                    string sJson = JsonHelper.SerializeObject(cReturn);
                    context.Response.Write(sJson);
                    return;
                }
                else
                {
                    //sDes = System.Web.HttpUtility.UrlDecode(sDes);
                    //sCph = System.Web.HttpUtility.UrlDecode(sCph);
                    if (sType == "photo")
                    {
                        context.Response.Write(TaskPic(sCid));
                        return;
                    }
                    else if (sType == "video")
                    {
                        context.Response.Write(TaskVideo(sCid));
                        return; 
                    }
                    string sImie = sCid;
                    if (string.IsNullOrEmpty(sCid))
                    {
                        System.Collections.Generic.List<Models.CSqlParameters> lstPar = new System.Collections.Generic.List<Models.CSqlParameters>();
                        Models.CSqlParameters par = new Models.CSqlParameters();
                        par.iLen = sCph.Length;
                        par.pDirection = System.Data.ParameterDirection.Input;
                        par.sName = "cph";
                        par.sqlDbType = System.Data.SqlDbType.NVarChar;
                        par.sValue = sCph;
                        lstPar.Add(par);
                        string sErr = "";
                        object oIMIE = BllSql.RunSqlScalarParameters(false, "select top 1 ProductCode from vehicle where Cph = @cph", lstPar, out sErr);
                        if (sErr.Length > 0)
                        {
                            Models.CYunJing cReturn = new Models.CYunJing();
                            cReturn.error = "32";
                            cReturn.data = "";
                            cReturn.errormsg = "获取IMEI失败！";
                            string sJson = JsonHelper.SerializeObject(cReturn);
                            context.Response.Write(sJson);
                            return;
                        }
                        sImie = oIMIE.ToString();
                    }
                    switch (sType)
                    {
                        case "road":
                            context.Response.Write(NavigationRoad(sImie, sLng, sLat, sDes));
                            return;
                    } 
                }
            }
            Models.CYunJing cReturn2 = new Models.CYunJing();
            cReturn2.error = "34";
            cReturn2.data = "";
            cReturn2.errormsg = "未知指令";
            string sJson2 = JsonHelper.SerializeObject(cReturn2);
            context.Response.Write(sJson2);
            return;
        }
        catch (Exception ex)
        {
            Models.CYunJing cReturn = new Models.CYunJing();
            cReturn.error = "33";
            cReturn.data = "";
            cReturn.errormsg = ex.Message;
            string sJson = JsonHelper.SerializeObject(cReturn);
            context.Response.Write(sJson);
            return;
        }
    }

    public string SaveImg(int iCph, string sTime, string sSrc)
    {
        string sDetailJpg = DateTime.Now.ToString("HHmmssfff");
        string sSavePath = AppDomain.CurrentDomain.BaseDirectory + "Download\\" + iCph.ToString() + "\\" + DateTime.Now.ToString("yyyyMMdd") + "\\" + sDetailJpg + ".jpg";
        if(!System.IO.Directory.Exists(AppDomain.CurrentDomain.BaseDirectory + "Download\\" + iCph.ToString()))
        {
            System.IO.Directory.CreateDirectory(AppDomain.CurrentDomain.BaseDirectory + "Download\\" + iCph.ToString());
        }
        if (!System.IO.Directory.Exists(AppDomain.CurrentDomain.BaseDirectory + "Download\\" + iCph.ToString() + "\\" + DateTime.Now.ToString("yyyyMMdd")))
        {
            System.IO.Directory.CreateDirectory(AppDomain.CurrentDomain.BaseDirectory + "Download\\" + iCph.ToString()+ "\\" + DateTime.Now.ToString("yyyyMMdd"));
        }
        DownloadPicture(sSrc, sSavePath, 1000 * 30);
        System.Collections.Generic.List<Models.CSqlParameters> lstPar = new System.Collections.Generic.List<Models.CSqlParameters>();
        Models.CSqlParameters par = new Models.CSqlParameters();
        par.iLen = 4;
        par.pDirection = System.Data.ParameterDirection.Input;
        par.sName = "VehID";
        par.sqlDbType = System.Data.SqlDbType.Int;
        par.sValue = iCph;
        lstPar.Add(par);

        par = new Models.CSqlParameters();
        par.iLen = sTime.Length * 2;
        par.pDirection = System.Data.ParameterDirection.Input;
        par.sName = "getTime";
        par.sqlDbType = System.Data.SqlDbType.NVarChar;
        par.sValue = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
        lstPar.Add(par);

        string sSrcPhoto = "Download\\" + iCph.ToString() + "\\" + DateTime.Now.ToString("yyyyMMdd") + "\\" + sDetailJpg + ".jpg";
        par = new Models.CSqlParameters();
        par.iLen = sSrcPhoto.Length * 2;
        par.pDirection = System.Data.ParameterDirection.Input;
        par.sName = "src";
        par.sqlDbType = System.Data.SqlDbType.NVarChar;
        par.sValue = sSrcPhoto;
        lstPar.Add(par);
        string sErr = "";
        string sDbName = "Bee" + DateTime.Now.ToString("yyyyMMdd");
        string sSql = "INSERT INTO [" + sDbName + "].[dbo].[H5ImgTable]([getTime],[camera],[src] ,[type],[VehID]) VALUES "
                        + " (@getTime,1,@src,'云镜拍照',@VehID) ";
        if (BllSql.RunSqlNonQueryParameters(false, sSql, lstPar, out sErr))
        {
            Models.CYunJing cReturn2 = new Models.CYunJing();
            cReturn2.error = "0";
            cReturn2.data = "";
            cReturn2.errormsg = "";
            string sJson2 = JsonHelper.SerializeObject(cReturn2);
            return sJson2;
        }
        else
        {
            Models.CYunJing cReturn2 = new Models.CYunJing();
            cReturn2.error = "2";
            cReturn2.data = "";
            cReturn2.errormsg = sErr;
            string sJson2 = JsonHelper.SerializeObject(cReturn2);
            return sJson2; 
        }
    }

    public bool DownloadPicture(string picUrl, string savePath, int timeOut)
    {
        bool value = false;
        System.Net.WebResponse response = null;
        System.IO.Stream stream = null;
        try
        {
            System.Net.HttpWebRequest request = (System.Net.HttpWebRequest)System.Net.WebRequest.Create(picUrl);
            if (timeOut != -1) request.Timeout = timeOut;
            response = request.GetResponse();
            stream = response.GetResponseStream();
            if (!response.ContentType.ToLower().StartsWith("text/"))
                value = SaveBinaryFile(response, savePath);
        }
        finally
        {
            if (stream != null) stream.Close();
            if (response != null) response.Close();
        }
        return value;
    }
    
    private bool SaveBinaryFile(System.Net.WebResponse response, string savePath)
    {
        bool value = false;
        byte[] buffer = new byte[1024];
        System.IO.Stream outStream = null;
        System.IO.Stream inStream = null;
        try
        {
            if (System.IO.File.Exists(savePath)) System.IO.File.Delete(savePath);
            outStream = System.IO.File.Create(savePath);
            inStream = response.GetResponseStream();
            int l;
            do
            {
                l = inStream.Read(buffer, 0, buffer.Length);
                if (l > 0) outStream.Write(buffer, 0, l);
            } while (l > 0);
            value = true;
        }
        finally
        {
            if (outStream != null) outStream.Close();
            if (inStream != null) inStream.Close();
        }
        return value;
    }

    public string NavigationRoad(string sImei,string sLon, string sLat, string sDes)
    {
        string[] arr = {
					"imei",
					"appkey",
					"timestamp",
                    "lon",
                    "lat",
                    "dest"
				};
        int iTimestamp = ConvertDateTimeInt(DateTime.Now);
        string[] arrDes = sDes.Split(' ');
        for(int i = 0; i < arrDes.Length; i++)
        {
            if (arrDes[i].Trim().Length > 0)
            {
                sDes = arrDes[i]; 
            }
        }
        System.Collections.Hashtable ht = new System.Collections.Hashtable();
        ht.Add("imei", sImei);//"459432808115092");
        ht.Add("appkey", "xrycy20160518001");
        ht.Add("timestamp", iTimestamp);//1474960363);//);
        ht.Add("lon", sLon);//"118.12159604895663");
        ht.Add("lat", sLat);//"24.666454800990966");
        ht.Add("dest", sDes);//福建省厦门市同安区美禾九路151号
        Array.Sort(arr);     //字典排序
        string sUrl = "";
        string sUrlEncoding = "";
        for (int i = 0; i < arr.Length; i++)
        {
            sUrlEncoding += UrlEncode(arr[i] + "=");
            if (arr[i] == "dest")
            {
                sUrlEncoding += System.Web.HttpUtility.UrlEncode((string)ht[arr[i]]).ToUpper();//UrlEncode((string)ht[arr[i]], System.Text.Encoding.Default);// 
            }
            else
            {
                sUrlEncoding += UrlEncode(ht[arr[i]].ToString());
            }
            //sUrl += arr[i] + "=" + ht[arr[i]];
        }
        sUrlEncoding += UrlEncode("secret=43DA77A0E95CAD60B8F163E29F6E2698");
        string sEncoding = sUrlEncoding;// UrlEncode(sUrl);// System.Web.HttpUtility.UrlEncode(sUrl, Encoding.GetEncoding("utf-8"));//.ToUpper();
        string sMd5 = System.Web.Security.FormsAuthentication.HashPasswordForStoringInConfigFile(sEncoding, "MD5");
        string sign = sMd5;
        string sPost = "";
        for (int i = 0; i < arr.Length; i++)
        {
            if (i == 0)
            {
                sPost += arr[i] + "=" + ht[arr[i]];
            }
            else
            {
                sPost += "&" + arr[i] + "=" + ht[arr[i]];
            }
        }
        sPost += "&sign=" + sign;
        System.Net.HttpWebResponse response = CreatePostHttpResponse("http://papi.rmtonline.cn/api/v1/pushdest", sPost, System.Text.Encoding.GetEncoding("utf-8"));
        //打印返回值  
        System.IO.Stream stream = response.GetResponseStream();   //获取响应的字符串流  
        System.IO.StreamReader sr = new System.IO.StreamReader(stream); //创建一个stream读取流  
        string html = sr.ReadToEnd();   //从头读到尾，放到字符串html  
        return html;
    }

    private string UrlEncode(string temp, System.Text.Encoding encoding)
    {
        System.Text.StringBuilder stringBuilder = new System.Text.StringBuilder();
        for (int i = 0; i < temp.Length; i++)
        {
            string t = temp[i].ToString();
            string k = HttpUtility.UrlEncode(t, encoding);
            if (t == k)
            {
                stringBuilder.Append(t);
            }
            else
            {
                stringBuilder.Append(k.ToUpper());
            }
        }
        return stringBuilder.ToString();
    }


    public string TaskPic(string sImei)
    {
        string[] arr = {
					"imei",
					"appkey",
					"timestamp"
				};
        int iTimestamp = ConvertDateTimeInt(DateTime.Now);
        System.Collections.Hashtable ht = new System.Collections.Hashtable();
        ht.Add("imei", sImei);//"459432807339859");
        ht.Add("appkey", "xrycy20160518001");
        ht.Add("timestamp", iTimestamp.ToString());//1474623224);
        Array.Sort(arr);     //字典排序
        string sUrl = "";
        for (int i = 0; i < arr.Length; i++)
        {
            sUrl += arr[i] + "=" + ht[arr[i]];
        }
        sUrl += "secret=43DA77A0E95CAD60B8F163E29F6E2698";
        string sEncoding = UrlEncode(sUrl);// System.Web.HttpUtility.UrlEncode(sUrl, Encoding.GetEncoding("utf-8"));//.ToUpper();

        string sMd5 = System.Web.Security.FormsAuthentication.HashPasswordForStoringInConfigFile(sEncoding, "MD5");
        string sign = sMd5;
        //Models.CYunJing cReturn = new Models.CYunJing();
        //cReturn.error = "32";
        //cReturn.data = sEncoding;
        //cReturn.errormsg = sMd5;
        //string sJson = JsonHelper.SerializeObject(cReturn);
        //return sJson; 
        string sPost = "";
        for (int i = 0; i < arr.Length; i++)
        {
            if (i == 0)
            {
                sPost += arr[i] + "=" + ht[arr[i]];
            }
            else
            {
                sPost += "&" + arr[i] + "=" + ht[arr[i]];
            }
        }
        sPost += "&sign=" + sign;
        System.Net.HttpWebResponse response = CreatePostHttpResponse("http://papi.rmtonline.cn/api/v1/takepic", sPost, System.Text.Encoding.GetEncoding("utf-8"));
        //打印返回值  
        System.IO.Stream stream = response.GetResponseStream();   //获取响应的字符串流  
        System.IO.StreamReader sr = new System.IO.StreamReader(stream); //创建一个stream读取流  
        string html = sr.ReadToEnd();   //从头读到尾，放到字符串html  
        return html;
        //http://36.250.69.195:8002/api/Files?fileType=1&imei=459432808115092
    }

    public string TaskVideo(string sImei)
    {
        string[] arr = {
					"imei",
					"appkey",
					"timestamp"
				};
        int iTimestamp = ConvertDateTimeInt(DateTime.Now);
        System.Collections.Hashtable ht = new System.Collections.Hashtable();
        ht.Add("imei", sImei);//"459432807339859");
        ht.Add("appkey", "xrycy20160518001");
        ht.Add("timestamp", iTimestamp);//1474623224);
        Array.Sort(arr);     //字典排序
        string sUrl = "";
        for (int i = 0; i < arr.Length; i++)
        {
            sUrl += arr[i] + "=" + ht[arr[i]];
        }
        sUrl += "secret=43DA77A0E95CAD60B8F163E29F6E2698";
        string sEncoding = UrlEncode(sUrl);// System.Web.HttpUtility.UrlEncode(sUrl, Encoding.GetEncoding("utf-8"));//.ToUpper();
        string sMd5 = System.Web.Security.FormsAuthentication.HashPasswordForStoringInConfigFile(sEncoding, "MD5");
        string sign = sMd5;
        string sPost = "";
        for (int i = 0; i < arr.Length; i++)
        {
            if (i == 0)
            {
                sPost += arr[i] + "=" + ht[arr[i]];
            }
            else
            {
                sPost += "&" + arr[i] + "=" + ht[arr[i]];
            }
        }
        sPost += "&sign=" + sign;
        System.Net.HttpWebResponse response = CreatePostHttpResponse("http://papi.rmtonline.cn/api/v1/shootvideo", sPost, System.Text.Encoding.GetEncoding("utf-8"));
        //打印返回值  
        System.IO.Stream stream = response.GetResponseStream();   //获取响应的字符串流  
        System.IO.StreamReader sr = new System.IO.StreamReader(stream); //创建一个stream读取流  
        string html = sr.ReadToEnd();   //从头读到尾，放到字符串html  
        return html;
    }

    private string UrlEncode(string value)
    {
        System.Text.StringBuilder result = new System.Text.StringBuilder();

        string unreservedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.~";
        foreach (char symbol in value)
        {
            if (unreservedChars.IndexOf(symbol) != -1)
            {
                result.Append(symbol);
            }
            else
            {
                result.Append('%' + String.Format("{0:X2}", (int)symbol));
            }
        }

        return result.ToString();
    }

    private readonly string DefaultUserAgent = "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; SV1; .NET CLR 1.1.4322; .NET CLR 2.0.50727)";
    private System.Net.HttpWebResponse CreatePostHttpResponse(string url, string parameters, System.Text.Encoding charset)
    {
        System.Net.HttpWebRequest request = null;
        //HTTPSQ请求  
        System.Net.ServicePointManager.ServerCertificateValidationCallback = new System.Net.Security.RemoteCertificateValidationCallback(CheckValidationResult);
        request = System.Net.WebRequest.Create(url) as System.Net.HttpWebRequest;
        request.ProtocolVersion = System.Net.HttpVersion.Version10;
        request.Method = "POST";
        request.ContentType = "application/x-www-form-urlencoded";
        request.UserAgent = DefaultUserAgent;
        //如果需要POST数据     
        if (!string.IsNullOrEmpty(parameters))
        {
            byte[] data = charset.GetBytes(parameters);
            using (System.IO.Stream stream = request.GetRequestStream())
            {
                stream.Write(data, 0, data.Length);
            }
        }
        return request.GetResponse() as System.Net.HttpWebResponse;
    }

    private string GetSrc(int iType, string sImei)
    {
        System.Net.HttpWebRequest httpRequest = (System.Net.HttpWebRequest)System.Net.WebRequest.Create("http://36.250.69.195:8002/api/Files?fileType=" + iType.ToString() + "&imei=" + sImei);
        httpRequest.Timeout = 2000;
        httpRequest.Method = "GET";
        System.Net.HttpWebResponse httpResponse = (System.Net.HttpWebResponse)httpRequest.GetResponse();
        System.IO.StreamReader sr = new System.IO.StreamReader(httpResponse.GetResponseStream(), System.Text.Encoding.GetEncoding("gb2312"));
        string html = sr.ReadToEnd();        
        System.Xml.XmlDocument doc = new System.Xml.XmlDocument();//创 建XML文 档 
        if (!string.IsNullOrEmpty(html))
        {
            doc.LoadXml(html);//加载xml字符
            string xpath = @"ResponseResultOfYCY_BEIDOU_MULTIMEDIAYW0TZMTK/Status";
            System.Xml.XmlNode node = doc.SelectSingleNode(xpath);
            string status = node.InnerText.ToString();
            if (status == "1")
            {
                Models.CYunJing cReturn = new Models.CYunJing();
                cReturn.error = "0";
                cReturn.data = "";
                cReturn.errormsg = "ok！";
                string sJson = JsonHelper.SerializeObject(cReturn);
                return sJson;
            }
            else
            {
                Models.CYunJing cReturn = new Models.CYunJing();
                cReturn.error = "2";
                cReturn.data = "";
                cReturn.errormsg = "拍照失败！";
                string sJson = JsonHelper.SerializeObject(cReturn);
                return sJson;
            }
        }
        else
        {
            Models.CYunJing cReturn = new Models.CYunJing();
            cReturn.error = "2";
            cReturn.data = "";
            cReturn.errormsg = "拍照失败！";
            string sJson = JsonHelper.SerializeObject(cReturn);
            return sJson; 
        }
    }

    /// <summary>  
    /// DateTime时间格式转换为Unix时间戳格式  
    /// </summary>  
    /// <param name="time"> DateTime时间格式</param>  
    /// <returns>Unix时间戳格式</returns>  
    public int ConvertDateTimeInt(System.DateTime time)
    {
        System.DateTime startTime = TimeZone.CurrentTimeZone.ToLocalTime(new System.DateTime(1970, 1, 1));
        return (int)(time - startTime).TotalSeconds;
    }

    private static bool CheckValidationResult(object sender, System.Security.Cryptography.X509Certificates.X509Certificate certificate, System.Security.Cryptography.X509Certificates.X509Chain chain, System.Net.Security.SslPolicyErrors errors)
    {
        return true; //总是接受     
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}