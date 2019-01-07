<%@ WebHandler Language="C#" Class="Place" %>

using System;
using System.Web;

public class Place : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        try
            {
                string sType = context.Request["type"];
                string sLat = context.Request["Lat"];
                string sLng = context.Request["Lng"];
                string sCoordtype = context.Request["coordtype"];
                if (sCoordtype == null)
                {
                    sCoordtype = "wgs84ll"; 
                }
                System.Net.WebClient client = new System.Net.WebClient();
                client.Proxy = null;
                if (sType.Equals("baidu"))
                {
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
                    //string url = @"http://api.map.baidu.com/geocoder/v2/?ak=l4zKPgF3ihF8lciY2QGmpsvW&callback=renderReverse&coordtype=wgs84ll&location=" + sLat + "," + sLng + "&output=json&pois=1";

                    //byte[] buff = client.DownloadData(url);
                    //string content = System.Text.Encoding.UTF8.GetString(buff);
                    //content = content.Replace("renderReverse&&renderReverse(", "");
                    //content = content.Substring(0, content.Length - 1);
                    Models.CData cData = new Models.CData();
                    cData.result = "true";
                    cData.data = sSetValue(double.Parse(sLat), double.Parse(sLng), sCoordtype);
                    string sJson = JsonHelper.SerializeObject(cData); 
                    context.Response.Write(sJson);
                    return;
                }
                else if(sType.Equals("google"))
                {
                    string url = "http://maps.google.cn/maps/api/geocode/json?latlng=" + sLat + "," + sLng + "&language=en-US&sensor=false";
                    byte[] buff = client.DownloadData(url);
                    string content = System.Text.Encoding.UTF8.GetString(buff);
                    string sResult = "OK";
                    Newtonsoft.Json.Linq.JObject jsonRoot = (Newtonsoft.Json.Linq.JObject)Newtonsoft.Json.JsonConvert.DeserializeObject(content);
                   if (jsonRoot.Count > 0)
                   {
                       if ("OK".Equals(jsonRoot["status"].ToString()))
                       {
                           //SetLocation(user["result"]["formatted_address"]);
                           if (true) //!System.Threading.Thread.CurrentThread.CurrentUICulture.Name.Equals("zh-CN"))
                           {
                               Newtonsoft.Json.Linq.JArray jsonResults = (Newtonsoft.Json.Linq.JArray)jsonRoot["results"];
                               if (jsonResults.Count > 0)
                               {
                                   Newtonsoft.Json.Linq.JObject jsonAdd = (Newtonsoft.Json.Linq.JObject)jsonResults[0];
                                   content = jsonAdd["formatted_address"].ToString().Replace("号", "");
                               }
                           }
                       }
                       else
                       {
                           content = "";
                       }
                   }
                   else
                   {
                       content = ""; 
                   }
                    Models.CData cData = new Models.CData();
                    cData.result = "true";
                    cData.data = content;
                    string sJson = JsonHelper.SerializeObject(cData);
                    context.Response.Write(sJson);
                    return;
                }
                context.Response.Write("{\"result\":\"false\",\"err\":\"" + Resources.Lan.UnknownError + "\"}");
            }
            catch(Exception ex)
            {
                context.Response.Write("{\"result\":\"false\",\"err\":\"" + ex.Message + "\"}");
            }
    }

    System.Collections.Hashtable htKeys = new System.Collections.Hashtable();
    System.Collections.Hashtable htAddressFromWeb = new System.Collections.Hashtable();
    public string sSetValue(double Lat, double Lng, string sCoordtype)
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
            //bd09ll
            string url = "http://api.map.baidu.com/geocoder/v2/?ak=" + sKey + "&coordtype=" + sCoordtype + "&callback=renderReverse&location=" + Lat.ToString() + "," + Lng.ToString() + "&output=xml&pois=1";
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
                                    sExtendAddress = " 距离" + thisNode["name"].InnerText + thisNode["distance"].InnerText + "米";
                                    iDistanceMin = iThisDistance;
                                }
                            }
                        }
                    }
                    sLatLng = sLatLng + sExtendAddress;
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
                    return sSetValue(Lat, Lng, sCoordtype);
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