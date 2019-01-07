var XMLFile="51DiTu_E_China.xml";
var xmlDoc=null;
var xmldocAddr= new XmlDOM();
LoadXMLDOC(XMLFile);

function LoadXMLDOC(XMLFilePath)
{
    xmlDoc = new XmlDOM();
    xmlDoc.async = false;
    xmlDoc.setProperty("SelectionLanguage", "XPath");

}

function sendRequest(url,callback,postData,errorCallBack) {//debugger;
	var req = createXMLHTTPObject();
	if (!req) return;
	var method = (postData) ? "POST" : "GET";
	req.open(method,url,true);
	req.setRequestHeader('User-Agent','XMLHTTP/1.0');
	if (postData)
		req.setRequestHeader('Content-type','text/xml');
	req.onreadystatechange = function () {
		if (req.readyState != 4) return;
		if (req.status == 200 || req.status == 304) {
			callback(req);
		}
		else
		{
		    if(typeof(errorCallBack) != 'undefined')
		    {
		        errorCallBack();
		    }
		}
		 
//		 req.onreadystatechange = null;
//		 req = null;
	}
	if (req.readyState == 4) return;
	req.send(postData);
}

var XMLHttpFactories = [
    //Mozilla浏览器
	function () {return new XMLHttpRequest()},
	//IE
	function () {return new ActiveXObject("Msxml2.XMLHTTP")},
	function () {return new ActiveXObject("Msxml3.XMLHTTP")},
	function () {return new ActiveXObject("Microsoft.XMLHTTP")}
];

function createXMLHTTPObject() {

	var xmlhttp = false;
	for (var i=0;i<XMLHttpFactories.length;i++) {
		try {
			xmlhttp = XMLHttpFactories[i]();
		}
		catch (e) {
			continue;
		}
		break;
	}
	return xmlhttp;
}


function GetAddrFrom51Ditu_ByClient(oLon,oLat)
{
    var strAddr="";
    
    var dituLon=Math.floor(Number(oLon).mul(100000));
    var dituLat=Math.floor(Number(oLat).mul(100000));
    var strURL="http://ls.vip.51ditu.com/mosp/gc?pos="+dituLon+","+dituLat;

	xmlHTTP.open("POST",strURL,false);
	xmlHTTP.send();
	if(xmlHTTP.statusText=="OK")
	{
	    xmldocAddr.loadXML(xmlHTTP.responseText);
		if(xmldocAddr.parseError.errorCode == 0)
		{
				var NodeCode = xmldocAddr.selectSingleNode("/R/code");
	            if(NodeCode)
	            {
	                if(NodeCode.text=="0")
	                {
	                    var Nodemsg = xmldocAddr.selectSingleNode("/R/msg");
	                    if(Nodemsg)
	                    {
	                        strAddr=Nodemsg.text;
	                    }
	                }
	            }

		}

	}

     return strAddr;

}




function XmlDOM() {
    //通过对象/属性检测法，判断是IE来是Mozilla
    if (window.ActiveXObject) 
    {
        var arrSignatures = ["MSXML2.DOMDocument.5.0", "MSXML2.DOMDocument.4.0",
                             "MSXML2.DOMDocument.3.0", "MSXML2.DOMDocument",
                             "Microsoft.XmlDom"];
                         
        for (var i=0; i < arrSignatures.length; i++)
        {
            try 
            {
                var oXmlDom = new ActiveXObject(arrSignatures[i]);
                return oXmlDom;
            } 
            catch (oError) 
            {
                //ignore
            }
        }          

        throw new Error("MSXML is not installed on your system."); 
    }
}