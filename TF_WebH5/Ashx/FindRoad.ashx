<%@ WebHandler Language="C#" Class="FindRoad" %>

using System;
using System.Web;

public class FindRoad : IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        try
        {
            string sType = context.Request["type"];
            string sLat = context.Request["Lat"];
            string sLng = context.Request["Lng"];
            string sContent = context.Request["des"];
            string sCoordtype = context.Request["coordtype"];
            if (sCoordtype == null)
            {
                sCoordtype = "wgs84ll";
            }
            System.Net.WebClient client = new System.Net.WebClient();
            client.Proxy = null;
            htKeys.Clear();
            KeyEnable keyEnable = new KeyEnable();
            keyEnable.sKey = "3fKkuWx3EqszuruAx6MkknpE";
            keyEnable.bEnable = true;
            htKeys.Add(1, keyEnable);
            keyEnable = new KeyEnable();
            keyEnable.sKey = "j946cQnOPWg29PAngVOrutxv";
            keyEnable.bEnable = true;
            htKeys.Add(2, keyEnable);
            keyEnable = new KeyEnable();
            keyEnable.sKey = "mNB3eEn91rNd2GeIsbEdCzYd";
            keyEnable.bEnable = true;
            htKeys.Add(3, keyEnable);
            keyEnable = new KeyEnable();
            keyEnable.sKey = "l4zKPgF3ihF8lciY2QGmpsvW";
            keyEnable.bEnable = true;
            htKeys.Add(4, keyEnable);
            if (sType.Equals("FromXY"))
            {
                Models.CData cData = new Models.CData();
                cData.result = "true";
                cData.data = sSetValue(double.Parse(sLat), double.Parse(sLng));
                string sJson = JsonHelper.SerializeObject(cData);
                context.Response.Write(sJson);
                return;
            }
            else if (sType.Equals("FromDes"))
            {
                string sReturn = GetXYFromDes(HttpUtility.UrlEncode(sContent)).Trim();
                if (sReturn.Length == 0)
                {
                    string sJson = "{\"status\":1}";
                    context.Response.Write(sJson);
                }
                else
                {
                    context.Response.Write(sReturn);
                }
                return;
                //http://api.map.baidu.com/geocoder/v2/?address=北京市海淀区上地十街10号&output=json&ak=E4805d16520de693a3fe707cdc962045&callback=showLocation 
            }
            context.Response.Write("{\"result\":\"false\",\"err\":\"" + Resources.Lan.UnknownError + "\"}");
        }
        catch (Exception ex)
        {
            context.Response.Write("{\"result\":\"false\",\"err\":\"" + ex.Message + "\"}");
        }
    }

    System.Collections.Hashtable htKeys = new System.Collections.Hashtable();
    System.Collections.Hashtable htAddressFromWeb = new System.Collections.Hashtable();
    public string sSetValue(double Lat, double Lng)
    {
        string sLatLng = "";
        try
        {
            if (htAddressFromWeb.ContainsKey(Lat.ToString("0.0000") + "-" + Lng.ToString("0.0000")))
            {
                return (string)htAddressFromWeb[Lat.ToString("0.0000") + "-" + Lng.ToString("0.0000")];
            }
            //string url = "http://api.map.baidu.com/geocoder?output=xml&location=" + Lat.ToString() + "," + Lng.ToString() + "&key=689E5E7D89D8A46BC41B01D3EA154BEE1147B17C";
            string sKey = GetBaiduKey();
            if (sKey.Length == 0)
            {
                return " "; 
            }
            string url = "http://api.map.baidu.com/geocoder/v2/?ak=" + sKey + "&coordtype=bd09ll&callback=renderReverse&location=" + Lat.ToString() + "," + Lng.ToString() + "&output=xml&pois=1";
            System.Net.WebClient webClientBaidu = new System.Net.WebClient();
            webClientBaidu.Proxy = null;
            byte[] buff = webClientBaidu.DownloadData(url);
            string content = System.Text.Encoding.UTF8.GetString(buff);
            System.Xml.XmlDocument doc = new System.Xml.XmlDocument();//创 建XML文 档 
            if (!string.IsNullOrEmpty(content))
            {
                //把“&” 编码为 “&amp;”把“<” 编码为“&lt;” 把“>” 编码为 “&gt;”把“'” 编码为 “&apos;”把“"” 编码为 “&quot;” 
                if (content.IndexOf("&amp;") == -1 && content.IndexOf("&lt;") == -1 && content.IndexOf("&gt;") == -1 && content.IndexOf("&apos;") == -1 && content.IndexOf("&quot;") == -1)
                {
                    content = content.Replace("&", "&amp;").Replace("'", "&apos;");
                }
                doc.LoadXml(content);//加载xml字符
                string xpath = @"GeocoderSearchResponse/status";
                System.Xml.XmlNode node = doc.SelectSingleNode(xpath);
                string status = node.InnerText.ToString();
                if (status == "OK" || status == "0")
                {
                    xpath = @"GeocoderSearchResponse/result/formatted_address";
                    node = doc.SelectSingleNode(xpath);
                    sLatLng = node.InnerText.ToString();

                    xpath = @"GeocoderSearchResponse/result/pois/poi";
                    string sExtendAddress = "";
                    bool bExist = false;
                    if (!bExist)
                    {
                        //node = doc.SelectSingleNode(xpath);
                        System.Xml.XmlNodeList nodeList = doc.SelectNodes(xpath);
                        if (nodeList != null && nodeList.Count > 0)
                        {
                            int iDistanceMin = 1100;
                            foreach (System.Xml.XmlNode thisNode in nodeList)
                            {
                                int iThisDistance = int.Parse(thisNode["distance"].InnerText);
                                if (iThisDistance < iDistanceMin)
                                {
                                    sExtendAddress = thisNode["addr"].InnerText + " " + thisNode["name"].InnerText;
                                    iDistanceMin = iThisDistance;
                                }
                            }
                        }
                    }
                    sLatLng = sExtendAddress;
                    if (sLatLng.Trim().Length > 0)
                    {
                        lock (htAddressFromWeb)
                        {
                            if (!htAddressFromWeb.ContainsKey(Lat.ToString("0.0000") + "-" + Lng.ToString("0.0000")))
                            {
                                htAddressFromWeb.Add(Lat.ToString("0.0000") + "-" + Lng.ToString("0.0000"), sLatLng);
                            }
                        }
                    }
                }
                else
                {
                    SetBaiduKeyUnable(sKey);
                    sSetValue(Lat, Lng);
                }
            }
        }
        catch
        {
            sLatLng = "";
        }
        return sLatLng;
    }

    public string GetXYFromDes(string sDes)
    {
        string sLatLng = "";
        try
        {
            string sKey = GetBaiduKey();
            if (sKey.Length == 0)
            {
                return "";
            }
            string url = "http://api.map.baidu.com/geocoder/v2/?address=" + sDes + "&output=json&ak=" + sKey;
            System.Net.WebClient webClientBaidu = new System.Net.WebClient();
            webClientBaidu.Proxy = null;
            byte[] buff = webClientBaidu.DownloadData(url);
            string content = System.Text.Encoding.UTF8.GetString(buff);
            System.Xml.XmlDocument doc = new System.Xml.XmlDocument();//创 建XML文 档 
            if (!string.IsNullOrEmpty(content))
            {
                if (content.StartsWith("{\"status\":0,"))
                {
                    return content;
                }
                else
                {
                    SetBaiduKeyUnable(sKey);
                    GetXYFromDes(sDes);
                }
            }
        }
        catch
        {
            sLatLng = "";
        }
        return sLatLng;
    }

    private string GetBaiduKey()
    {
        string sKey = "";// "3fKkuWx3EqszuruAx6MkknpE";//iTSdV5zPvQnn9EiWXYfP0IAl
        try
        {
            lock (htKeys)
            {
                KeyEnable keyEnable = (KeyEnable)htKeys[1];
                if (keyEnable.bEnable)
                {
                    return keyEnable.sKey;
                }
                keyEnable = (KeyEnable)htKeys[2];
                if (keyEnable.bEnable)
                {
                    return keyEnable.sKey;
                }
                keyEnable = (KeyEnable)htKeys[3];
                if (keyEnable.bEnable)
                {
                    return keyEnable.sKey;
                }
                keyEnable = (KeyEnable)htKeys[4];
                if (keyEnable.bEnable)
                {
                    return keyEnable.sKey;
                }
            }
        }
        catch { }
        return sKey;
    }

    private void SetBaiduKeyUnable(string sKey)
    {
        try
        {
            lock (htKeys)
            {
                KeyEnable keyEnable = (KeyEnable)htKeys[1];
                if (keyEnable.sKey.Equals(sKey))
                {
                    keyEnable.bEnable = false;
                    htKeys[1] = keyEnable;
                    return;
                }
                keyEnable = (KeyEnable)htKeys[2];
                if (keyEnable.sKey.Equals(sKey))
                {
                    keyEnable.bEnable = false;
                    htKeys[2] = keyEnable;
                    return;
                }
                keyEnable = (KeyEnable)htKeys[3];
                if (keyEnable.bEnable)
                {
                    keyEnable.bEnable = false;
                    htKeys[3] = keyEnable;
                    return;
                }
                keyEnable = (KeyEnable)htKeys[4];
                if (keyEnable.bEnable)
                {
                    keyEnable.bEnable = false;
                    htKeys[4] = keyEnable;
                    return;
                }
            }
        }
        catch { }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    public struct KeyEnable
    {
        public string sKey;
        public bool bEnable;
    }
}