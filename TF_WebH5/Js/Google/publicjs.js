//-----------------------------------
//*** 通用共公脚本
//*** 创建日期:2006-11-10
//*** 修改日期:2007-11-04
//------------------------------------
//公用变量
var open_width  = 1024;
var open_height = 768;
var xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP"); 
var XmlItem = new ActiveXObject("Microsoft.XMLDOM");
var XmlDom = new ActiveXObject("Microsoft.XMLDOM");
var dc = document.all;
XmlDom.async=false;//不是异步
var intCount = 0;//统计记录总数
var intFlag = 0;//标志位
//没有选中的颜色
var TempColor = "#ffffff"
//选中的颜色
var SelectColor = "#ff0000"
//鼠标经过的菜单样式
function MenuMove(obj)
{
	try
	{
		var RealObj = document.getElementById(obj);
		RealObj.style.cursor="hand";
		RealObj.style.borderLeftWidth = "1";
		RealObj.style.borderLeftStyle="outset";
		RealObj.style.borderLeftColor="ghostwhite";
		RealObj.style.borderTopColor="ghostwhite";
		RealObj.style.borderTopStyle="outset";
		RealObj.style.borderTopWidth="1";
		RealObj.style.borderBottomStyle="outset";
		RealObj.style.borderBottomColor="black";
		RealObj.style.borderBottomWidth="1";
		RealObj.style.borderRightStyle="outset";
		RealObj.style.borderRightColor="black";
		RealObj.style.borderRightWidth="1";
	}
	catch(Exception)
	{
	}
}
//鼠标移开的菜单样式
function MenuOut(obj)
{
	try
	{
		var RealObj = document.getElementById(obj);
		RealObj.style.cursor="";
		RealObj.style.borderLeftWidth = "0";
		RealObj.style.borderLeftStyle="";
		RealObj.style.borderLeftColor="";
		RealObj.style.borderTopColor="";
		RealObj.style.borderTopStyle="";
		RealObj.style.borderTopWidth="0";
		RealObj.style.borderBottomStyle="";
		RealObj.style.borderBottomColor="";
		RealObj.style.borderBottomWidth="0";
		RealObj.style.borderRightStyle="";
		RealObj.style.borderRightColor="";
		RealObj.style.borderRightWidth="0";	
	}
	catch(Exception)
	{
	
	}
}
//设置弹出窗口的宽度
function set_open_width(w)
{
	open_width = w;
}
//设置弹出窗口的高度
function set_open_height(h)
{
	open_height = h;
}
//打开一个新窗口
//filePaht为文件的URL
function openwin(filepath)
{
	var open_left = (screen.width-open_width)/2;
	var open_top  = (screen.height-open_height)/2-15;
	var newWindow = window.open(filepath,"","height="+open_height+",width="+open_width+",left="+open_left+",top="+open_top+",resizable=no,toolbar=no,status=no,help=no,menubar=no,location=no");
	newWindow.focus();
}

//打开一个模式窗口
//filePaht为文件的URL
function ShowModalForm(filepath)
{
	var open_left = (screen.width-open_width)/2;
	var open_top  = (screen.height-open_height)/2-15;
	var arrayObj = new Array(2);
	arrayObj[0]=filepath;  //要在模式窗口中显示的URL
	arrayObj[1]=window;


	window.showModalDialog("ShowModelForm.aspx",arrayObj,"dialogHeight:"+open_height+"px;dialogWidth:"+open_width+"px;dialogLeft:"+open_left+"px;dialogTop:"+open_top+"px;center:yes;resizable:no;toolbar:no;status:no;help:no;menubar:no;location:no;scroll:on");
	

	
	if(document.all.NeedShowForm != document.all.aabbcc)
	{
	    arrayObj[0]=document.all.NeedShowForm.value;
	    var open_width2=document.all.ShowFormWidth.value;
	    var open_height2=document.all.ShowFormHeight.value;
	    var open_left2 = (screen.width-open_width2)/2;
	    var open_top2  = (screen.height-open_height2)/2-15;
   
        while(document.all.NeedShowForm.value!="")
	    {
	        document.all.NeedShowForm.value="";
	        window.showModalDialog("ShowModelForm.aspx",arrayObj,"dialogHeight:"+open_height2+"px;dialogWidth:"+open_width2+"px;dialogLeft:"+open_left2+"px;dialogTop:"+open_top2+"px;center:yes;resizable:no;toolbar:no;status:no;help:no;menubar:no;location:no;status:no");
	    }
	}

}


//反选
function AllSel()
{
	var len = GridView1.rows.length;
	for(var i=1;i<len;i++)
	{
		GridView1.rows(i).cells(0).children[0].checked=!GridView1.rows(i).cells(0).children[0].checked;
	}
}
//是否输入的是数字
function IsNumric(curobj)
{
	reg = /\d$/;
	var testValue = curobj.value;
	if((event.keyCode != 13||event.keyCode!= 8)&&testValue!="")
	{
		if(!reg.test(testValue))
		{
			alert("请输入数字");
			curobj.value = "";
			curobj.focus();
			//event.returnValue = false;
		}
	}
}
//输入的是否是数字(可以带小数点)
function IsDecimal(obj)
{
	var tValue =  obj.value;
	if(isNaN(tValue))
	{
		alert("请输入数字");
		obj.value = "";
		obj.focus();
		event.returnValue = false;
	}
	//if(isNaN(tValue))
		//alert(sNaN(tValue));
}
//输入数字(没有任何提示的)
function IsDigit()
{
	if(event.keyCode<48||event.keyCode>57) 
		event.returnValue = false;
}
//***************************
//判断关键字是否存在 如果不存在则提示记录不存在
//tablename  表名
//keyField   主键
//fieldValue 字段内容
//obj        对象
//Msg        提示信息
//*****************************
function IsExistsKeyField(tablename,keyField,fieldValue,obj,Msg)
{
	var strSql = "select count("+keyField+") as "+keyField+" from "+tablename+" where "+keyField+"='"+fieldValue+"'";
	var str    = "<Root><funSql>"+strSql+"</funSql></Root>";
	xmlHTTP.open("POST","../../../IsKeyWord.aspx",false)
	xmlHTTP.send(str);
	if(xmlHTTP.statusText=="OK")
	{
		XmlDom.loadXML(xmlHTTP.responseText);
		if(XmlDom.parseError.errorCode == 0)
		{
			XmlItem=XmlDom.getElementsByTagName("tablename");
			if(XmlItem.item(0).selectSingleNode(keyField).text=="0")
			{
				alert(Msg);
				obj.value = "";
			}
		}
	}
}
function IsSpecExistsKeyField(tablename,keyField,fieldValue,obj,Msg,isDeleted)
{
    var strSql
    if(isDeleted)
        strSql = "select count("+keyField+") as "+keyField+" from "+tablename+" where "+keyField+"='"+fieldValue+"' AND isDeleted =0";
    else
        strSql = "select count("+keyField+") as "+keyField+" from "+tablename+" where "+keyField+"='"+fieldValue+"'";
	var str    = "<Root><funSql>"+strSql+"</funSql></Root>";
	xmlHTTP.open("POST","../../../IsKeyWord.aspx",false)
	xmlHTTP.send(str);
	if(xmlHTTP.statusText=="OK")
	{
		XmlDom.loadXML(xmlHTTP.responseText);
		if(XmlDom.parseError.errorCode == 0)
		{
			XmlItem=XmlDom.getElementsByTagName("tablename");
			if(XmlItem.item(0).selectSingleNode(keyField).text=="0")
			{
				alert(Msg);
				obj.value = "";
			}
		}
	}
}
function IsSpecExistsKeyField_New(fieldValue)
{
       var strSql
       strSql = fieldValue
       	var str    = "<Root><funSql>"+strSql+"</funSql></Root>";
       xmlHTTP.open("POST","../../../IsKeyWord1.aspx",false)
       xmlHTTP.send(str);
    // alert(fieldValue);
     if(xmlHTTP.statusText=="OK")
	{
	    var stext = xmlHTTP.responseText;
	    //alert(stext);	
			 addST1(stext)
	}
}
 function addST1(strxml)
     {
      // alert(strxml);
    //  var strSelectedValue = document.all.NurseInfoSearchDropDownList.value;
     //  var count=Form1.ddlTyreReplace.length;
     var count=document.all.ddlTyreReplace.length;
       for( var j=1;j<count;j++)
         {
             document.all.ddlTyreReplace.options.remove(1);
         }
        	var xmlDom=new ActiveXObject("MSXML2.DOMDocument.3.0");
                xmlDom.async="false";
                xmlDom.loadXML(strxml);
                var xmlObj=xmlDom.documentElement.childNodes;
           for(var i=0;i<xmlObj.length;i=i+1)
               {
   
                     if(xmlObj.item(i).hasChildNodes)
                    {
                      var  xmlSubNode=xmlObj.item(i).childNodes;
                      // var xmlSubNode1=xmlObj.item(i+1).childNodes;
                     //   var Name =xmlSubNode.item(0).text;
                     // var No=xmlSubNode.item(1).text;
                     //    var newObj=new Option(No,Name);
                   //  document.getElementById("ddlTyreReplace").add(newObj);
                     
                     
                   
                       var No =xmlSubNode.item(0).text;
                       var Name=xmlSubNode.item(1).text;
                         var e = document.createElement("OPTION");
                           e.innerText= Name;
                           e.value=No;
                            document.getElementById("ddlTyreReplace").appendChild(e);
                         //prov.appendChild(e);

                     }
        
               }

    }
//***********
//判断关键字是否存在 如果存在则提示记录存在
//tablename 表名
//keyField  主键
//fieldValue 字段值
//obj  对象
//Msg  提示信息
//is54 是否有isDelete条件
//***********
function IsRepeat(tablename,keyField,fieldValue,obj,Msg,isDelete)
{
    if(obj.defaultValue != fieldValue)
    {
	    if(isDelete)
		    strSql = "SELECT count("+keyField+") as "+keyField+" FROM "+tablename+" WHERE "+keyField+"='"+fieldValue+"' AND isDeleted =0";
	    else
		    strSql = "SELECT count("+keyField+") as "+keyField+" FROM "+tablename+" WHERE "+keyField+"='"+fieldValue+"'";
	    var str    = "<Root><funSql>"+strSql+"</funSql></Root>";
	    xmlHTTP.open("POST","../../../IsKeyWord.aspx",false)
	    xmlHTTP.send(str);
	    if(xmlHTTP.statusText=="OK")
	    {
		    XmlDom.loadXML(xmlHTTP.responseText);
		    if(XmlDom.parseError.errorCode == 0)
		    {
			    XmlItem=XmlDom.getElementsByTagName("tablename");
			    var count = XmlItem.length;
			    if((parseInt(XmlItem.item(0).selectSingleNode(keyField).text))>0)
			    {
				    alert(Msg);
				    obj.value = "";
				    obj.focus();
			    }
		    }
	    }
	}
}
//***********
//判断关键字是否存在 如果存在则提示记录存在,排除当前值
//tablename 表名
//keyField  主键
//fieldValue 字段值
//obj  对象
//Msg  提示信息
//is54 是否有isDelete条件
//CurrentField 当前对象ID字段
//CurrentFieldID 当前对象ID值
//***********
function IsCurrentRepeat(tablename,keyField,fieldValue,obj,Msg,isDelete,CurrentField,CurrentFieldID)
{
    if (fieldValue != '')
    {
        var CurrentValue = document.getElementById(CurrentFieldID).value;
        if (CurrentValue == "")
            CurrentValue = "0";
	    if(isDelete)
		    strSql = "SELECT count("+keyField+") as "+keyField+" FROM "+tablename+" WHERE "+keyField+"='"+fieldValue+"' AND isDeleted =0 AND "+CurrentField+"!="+CurrentValue;
	    else
		    strSql = "SELECT count("+keyField+") as "+keyField+" FROM "+tablename+" WHERE "+keyField+"='"+fieldValue+"' AND "+CurrentField+"!="+CurrentValue;
	    var str    = "<Root><funSql>"+strSql+"</funSql></Root>";
	    xmlHTTP.open("POST","../../../IsKeyWord.aspx",false)
	    xmlHTTP.send(str);
	    if(xmlHTTP.statusText=="OK")
	    {
		    XmlDom.loadXML(xmlHTTP.responseText);
		    if(XmlDom.parseError.errorCode == 0)
		    {
			    XmlItem=XmlDom.getElementsByTagName("tablename");
			    var count = XmlItem.length;
			    if((parseInt(XmlItem.item(0).selectSingleNode(keyField).text))>0)
			    {
				    alert(Msg);
				    obj.value = "";
				    obj.focus();
			    }
		    }
	    }
	}
}


//***********
//判断用户名是否存在于相同的应用程序（AppID相同） 如果存在则提示记录存在
//tablename 表名
//keyField  主键
//fieldValue 字段值
//obj  对象
//Msg  提示信息
//is54 是否有isDelete条件
//Lxwei,2007-01-31
//***********
function IsUserRepeat(tablename,keyField,fieldValue,obj,Msg,isDelete,AppIDValue)
{
	if(isDelete)
		strSql = "SELECT count("+keyField+") as "+keyField+" FROM "+tablename+" WHERE "+keyField+"='"+fieldValue+"' AND AppID = " +AppIDValue+ " AND isDeleted =0";
	else
		strSql = "SELECT count("+keyField+") as "+keyField+" FROM "+tablename+" WHERE "+keyField+"='"+fieldValue+"' AND AppID = " +AppIDValue;
	var str    = "<Root><funSql>"+strSql+"</funSql></Root>";
	xmlHTTP.open("POST","../../../IsKeyWord.aspx",false)
	xmlHTTP.send(str);
	if(xmlHTTP.statusText=="OK")
	{
		XmlDom.loadXML(xmlHTTP.responseText);
		if(XmlDom.parseError.errorCode == 0)
		{
			XmlItem=XmlDom.getElementsByTagName("tablename");
			var count = XmlItem.length;
			if((parseInt(XmlItem.item(0).selectSingleNode(keyField).text))>0)
			{
				alert(Msg);
				obj.value = "";
				obj.focus();
			}
		}
	}
}

//*****************
//填充下拉框
//strSql SQL语句
//sourceObj 下拉框名称
//text  显示页面text的字段名称
//value 页面值的字段名称
//**********************
function FillList(strSql,sourceObj,text,value)
{
	var str		="<ROOT><funSql>"+strSql+"</funSql></ROOT>";
	var curObj	= document.getElementById(sourceObj);
	xmlHTTP.open("POST","../../../IsKeyWord.aspx",false);
	xmlHTTP.send(str);
	XmlDom.async=false
	if(xmlHTTP.statusText == "OK")
	{
		XmlDom.loadXML(xmlHTTP.responseText);
		if(XmlDom.parseError.errorCode == 0)
		{
			XmlItem=XmlDom.getElementsByTagName("tablename");
			ret_count = XmlItem.length;
			
			while(curObj.options.length!=1)
			{
				curObj.options.remove(1);
			}
			if(ret_count>0)
			{
				for(var i=0;i<ret_count;i++)
				{
					op = document.createElement("option");
					op.value = XmlItem.item(i).selectSingleNode(value).text;
					op.text = XmlItem.item(i).selectSingleNode(text).text;
					curObj.add(op);
				}
			}
		}
	}
}
//*****************
//填充列表框
//strSql SQL语句
//sourceObj 列表框名称
//text  显示页面text的字段名称
//value 页面值的字段名称
//**********************
function FillListBox(strSql,sourceObj,text,value)
{
	var str		="<ROOT><funSql>"+strSql+"</funSql></ROOT>";
	var curObj	= document.getElementById(sourceObj);
	xmlHTTP.open("POST","../../../IsKeyWord.aspx",false);
	xmlHTTP.send(str);
	XmlDom.async=false
	if(xmlHTTP.statusText == "OK")
	{
		XmlDom.loadXML(xmlHTTP.responseText);
		if(XmlDom.parseError.errorCode == 0)
		{
			XmlItem=XmlDom.getElementsByTagName("tablename");
			ret_count = XmlItem.length;
			
			while(curObj.options.length!=0)
			{
				curObj.options.remove(0);
			}
			if(ret_count>0)
			{
				for(var i=0;i<ret_count;i++)
				{
					op = document.createElement("option");
					op.value = XmlItem.item(i).selectSingleNode(value).text;
					op.text = XmlItem.item(i).selectSingleNode(text).text;
					curObj.add(op);
				}
			}
		}
	}
}
//*****************
//填充列表框扩展
//strSql SQL语句
//sourceObj 列表框名称
//text  显示页面text的字段名称
//value 页面值的字段名称
//**********************
function FillListBoxSpec(strSql,sourceObj,text,value,delObj)
{
	var str		="<ROOT><funSql>"+strSql+"</funSql></ROOT>";
	var curObj	= document.getElementById(sourceObj);
	xmlHTTP.open("POST","../../IsKeyWord.aspx",false);
	xmlHTTP.send(str);
	XmlDom.async=false
	if(xmlHTTP.statusText == "OK")
	{
		XmlDom.loadXML(xmlHTTP.responseText);
		if(XmlDom.parseError.errorCode == 0)
		{
			XmlItem=XmlDom.getElementsByTagName("tablename");
			ret_count = XmlItem.length;
			
			while(curObj.options.length!=0)
			{
				curObj.options.remove(0);
			}
			if(ret_count>0)
			{
				for(var i=0;i<ret_count;i++)
				{
					op = document.createElement("option");
					op.value = XmlItem.item(i).selectSingleNode(value).text;
					op.text = XmlItem.item(i).selectSingleNode(text).text;
					curObj.add(op);
				}
			}
		}
	}
}
//***********************
//填充文本框
//strSql SQL语句
//sourceObj 下拉框名称
//value 字段值
//***********************
function FillValue(strSql,sourceObj,value)
{
	var str		="<ROOT><funSql>"+strSql+"</funSql></ROOT>";
	var curObj	= document.getElementById(sourceObj);
	xmlHTTP.open("POST","../../../IsKeyWord.aspx",false);
	xmlHTTP.send(str);
	XmlDom.async=false
	if(xmlHTTP.statusText == "OK")
	{
		XmlDom.loadXML(xmlHTTP.responseText);
		if(XmlDom.parseError.errorCode == 0)
		{
			XmlItem=XmlDom.getElementsByTagName("tablename");
			ret_count = XmlItem.length;
			if(ret_count>0)
			{
				for(var i=0;i<ret_count;i++)
				{
					curObj.value = XmlItem.item(i).selectSingleNode(value).text;
				}
			}
			else
			{
				curObj.value = "";
			}
		}
	}
}
function GetValue(strSql,value)
{ 
    var returnValue="";
    var str		="<ROOT><funSql>"+strSql+"</funSql></ROOT>";
	xmlHTTP.open("POST","../../../IsKeyWord.aspx",false);
	xmlHTTP.send(str);
	XmlDom.async=false
	if(xmlHTTP.statusText == "OK")
	{
		XmlDom.loadXML(xmlHTTP.responseText);
		if(XmlDom.parseError.errorCode == 0)
		{
			XmlItem=XmlDom.getElementsByTagName("tablename");
			ret_count = XmlItem.length;
			if(ret_count>0)
			{
				for(var i=0;i<ret_count;i++)
				{
					returnValue= XmlItem.item(i).selectSingleNode(value).text;
				}
			}
		}
	}
	return returnValue;
}
//***********************
//填充层
//strSql SQL语句
//sourceObj 下拉框名称
//value 字段值
//***********************
function FillDiv(strSql,sourceObj,value,name)
{
    var doc   =   window.frames["framHoldID"].document;
    var str		="<ROOT><funSql>"+strSql+"</funSql></ROOT>";
	var curObj	= doc.getElementById(sourceObj);
	xmlHTTP.open("POST","../../../IsKeyWord.aspx",false);
	xmlHTTP.send(str);
	var strHTML = "";
	XmlDom.async=false;
	if(xmlHTTP.statusText == "OK")
	{
		XmlDom.loadXML(xmlHTTP.responseText);
		if(XmlDom.parseError.errorCode == 0)
		{
			XmlItem=XmlDom.getElementsByTagName("tablename");
			ret_count = XmlItem.length;
			if(ret_count>0)
			{
			    intCount =0;
			    intFlag = 1;
			    for(var i=0;i<ret_count;i++)
			    {
			        strHTML +="<span style='width:100%;font-size:9pt' onmouseover='this.style.backgroundColor=\"blue\";this.style.color=\"white\";"+
			                  "this.style.cursor=\"default\"' onmouseout='this.style.backgroundColor=\"white\";this.style.color=\"black\";"+
			                  "this.style.cursor=\"default\"' name='spList' onclick='"+
                              "parent.document.all.txtHoldID.value = this.innerText;parent.document.all.txtHoldID.focus();"+
                              "var inputHoldID = document.getElementsByName(\"signSel\");"+
                              "parent.document.all.hit_HoldID.value=inputHoldID["+i+"].value;parent.document.all.framHoldID.style.display=\"none\";"+
                              "var xmlHTTP = new ActiveXObject(\"Microsoft.XMLHTTP\");"+
                              "var XmlItem = new ActiveXObject(\"Microsoft.XMLDOM\");"+
                              "var XmlDom = new ActiveXObject(\"Microsoft.XMLDOM\");"+
                              "var str		=\"<ROOT><funSql>select DeptNo,DeptName from std_DeptInfo where HoldID=\"+parent.document.all.hit_HoldID.value+\"</funSql></ROOT>\";"+
	                          "var curObj	= parent.document.getElementById(\"ddlDept\");"+
	                          "xmlHTTP.open(\"POST\",\"../../../IsKeyWord.aspx\",false);"+
	                          "xmlHTTP.send(str);"+
	                          "XmlDom.async=false;"+
	                          "if(xmlHTTP.statusText == \"OK\")"+
	                          "{"+
		                      "XmlDom.loadXML(xmlHTTP.responseText);"+
		                      "if(XmlDom.parseError.errorCode == 0)"+
		                      "{"+
			                  "XmlItem=XmlDom.getElementsByTagName(\"tablename\");"+
			                  "ret_count = XmlItem.length;"+
			                  "while(curObj.options.length!=1)"+
			                  "{"+
				              "curObj.options.remove(1);"+
			                  "}"+
			                  "if(ret_count>0)"+
			                  "{"+
				              "for(var i=0;i<ret_count;i++)"+
				              "{"+
					          "op = document.createElement(\"option\");"+
					          "op.value = XmlItem.item(i).selectSingleNode(\"DeptNo\").text;"+
					          "op.text = XmlItem.item(i).selectSingleNode(\"DeptName\").text;"+
					          "curObj.add(op);"+
				              "}"+
			                  "}"+
		                      "}"+
	                          "}"+
	                          "'"+
                              "><input type='hidden' name='signSel' "+
			                  "value='"+ XmlItem.item(i).selectSingleNode(value).text+"'>"+XmlItem.item(i).selectSingleNode(name).text+"</span>";
			        intCount++;
			    }
			}
			else
			    intFlag = 0;
		}
	}
	curObj.innerHTML = strHTML;
}

//***********************
//填充层
//strSql SQL语句
//sourceObj 下拉框名称
//value 字段值
//***********************
function FillDivEpassenger(strSql,sourceObj,value,name)
{
    var doc   =   window.frames["framHoldID"].document;
    var str		="<ROOT><funSql>"+strSql+"</funSql></ROOT>";
	var curObj	= doc.getElementById(sourceObj);
	xmlHTTP.open("POST","../../../IsKeyWord.aspx",false);
	xmlHTTP.send(str);
	var strHTML = "";
	XmlDom.async=false;
	if(xmlHTTP.statusText == "OK")
	{
		XmlDom.loadXML(xmlHTTP.responseText);
		if(XmlDom.parseError.errorCode == 0)
		{
			XmlItem=XmlDom.getElementsByTagName("tablename");
			ret_count = XmlItem.length;
			if(ret_count>0)
			{
			    intCount =0;
			    intFlag = 1;
			    for(var i=0;i<ret_count;i++)
			    {
			        strHTML +="<span style='width:100%;font-size:9pt' onmouseover='this.style.backgroundColor=\"blue\";this.style.color=\"white\";"+
			                  "this.style.cursor=\"default\"' onmouseout='this.style.backgroundColor=\"white\";this.style.color=\"black\";"+
			                  "this.style.cursor=\"default\"' name='spList' onclick='"+
                              "parent.document.all.txtHoldID.value = this.innerText;defaltObjectCode=this.innerText;parent.document.all.txtHoldID.focus();"+
                              "var inputHoldID = document.getElementsByName(\"signSel\");"+
                              "parent.document.all.hit_HoldID.value=inputHoldID["+i+"].value;myObjectID=inputHoldID["+i+"].value;parent.document.all.framHoldID.style.display=\"none\";"+
                              "var xmlHTTP = new ActiveXObject(\"Microsoft.XMLHTTP\");"+
                              "var XmlItem = new ActiveXObject(\"Microsoft.XMLDOM\");"+
                              "var XmlDom = new ActiveXObject(\"Microsoft.XMLDOM\");"+
                              "var str		=\"<ROOT><funSql>select DeptNo,DeptName from std_DeptInfo where HoldID=\"+parent.document.all.hit_HoldID.value+\"</funSql></ROOT>\";"+
	                          "var curObj	= parent.document.getElementById(\"ddlDept\");"+
	                          "xmlHTTP.open(\"POST\",\"../../../IsKeyWord.aspx\",false);"+
	                          "xmlHTTP.send(str);"+
	                          "XmlDom.async=false;"+
	                          "if(xmlHTTP.statusText == \"OK\")"+
	                          "{"+
		                      "XmlDom.loadXML(xmlHTTP.responseText);"+
		                      "if(XmlDom.parseError.errorCode == 0)"+
		                      "{"+
			                  "XmlItem=XmlDom.getElementsByTagName(\"tablename\");"+
			                  "ret_count = XmlItem.length;"+
			                  "while(curObj.options.length!=1)"+
			                  "{"+
				              "curObj.options.remove(1);"+
			                  "}"+
			                  "if(ret_count>0)"+
			                  "{"+
				              "for(var i=0;i<ret_count;i++)"+
				              "{"+
					          "op = document.createElement(\"option\");"+
					          "op.value = XmlItem.item(i).selectSingleNode(\"DeptNo\").text;"+
					          "op.text = XmlItem.item(i).selectSingleNode(\"DeptName\").text;"+
					          "curObj.add(op);"+
				              "}"+
			                  "}"+
		                      "}"+
	                          "}"+
	                          "'"+
                              "><input type='hidden' name='signSel' "+
			                  "value='"+ XmlItem.item(i).selectSingleNode(value).text+"'>"+XmlItem.item(i).selectSingleNode(name).text+"</span>";
			        intCount++;
			    }
			}
			else
			    intFlag = 0;
		}
	}
	curObj.innerHTML = strHTML;
}
//***********************
//填充层
//strSql SQL语句
//sourceObj 下拉框名称
//value 字段值
//***********************
function FillDivEpassenger1(strSql,sourceObj,value,name)
{
    var doc   =   window.frames["framHoldID"].document;
    var str		="<ROOT><funSql>"+strSql+"</funSql></ROOT>";
	var curObj	= doc.getElementById(sourceObj);
	xmlHTTP.open("POST","../../../IsKeyWord.aspx",false);
	xmlHTTP.send(str);
	var strHTML = "";
	XmlDom.async=false;
	if(xmlHTTP.statusText == "OK")
	{
		XmlDom.loadXML(xmlHTTP.responseText);
		if(XmlDom.parseError.errorCode == 0)
		{
			XmlItem=XmlDom.getElementsByTagName("tablename");
			ret_count = XmlItem.length;
			if(ret_count>0)
			{
			    intCount =0;
			    intFlag = 1;
			    for(var i=0;i<ret_count;i++)
			    {
			        strHTML +="<span style='width:100%;font-size:9pt' onmouseover='this.style.backgroundColor=\"blue\";this.style.color=\"white\";"+
			                  "this.style.cursor=\"default\"' onmouseout='this.style.backgroundColor=\"white\";this.style.color=\"black\";"+
			                  "this.style.cursor=\"default\"' name='spList' onclick='"+
                              "parent.document.all.txtHoldID.value = this.innerText;defaltObjectCode=this.innerText;parent.document.all.txtHoldID.focus();"+
                              "var inputHoldID = document.getElementsByName(\"signSel\");"+
                              "parent.document.all.hit_HoldID.value=inputHoldID["+i+"].value;myObjectID=inputHoldID["+i+"].value; parent.parent.frmLeft.fulltxt(myObjectID);parent.document.all.framHoldID.style.display=\"none\";"+
                              "var xmlHTTP = new ActiveXObject(\"Microsoft.XMLHTTP\");"+
                              "var XmlItem = new ActiveXObject(\"Microsoft.XMLDOM\");"+
                              "var XmlDom = new ActiveXObject(\"Microsoft.XMLDOM\");"+
                              "var str		=\"<ROOT><funSql>select DeptNo,DeptName from std_DeptInfo where HoldID=\"+parent.document.all.hit_HoldID.value+\"</funSql></ROOT>\";"+
	                          "var curObj	= parent.document.getElementById(\"ddlDept\");"+
	                          "xmlHTTP.open(\"POST\",\"../../../IsKeyWord.aspx\",false);"+
	                          "xmlHTTP.send(str);"+
	                          "XmlDom.async=false;"+
	                          "if(xmlHTTP.statusText == \"OK\")"+
	                          "{"+
		                      "XmlDom.loadXML(xmlHTTP.responseText);"+
		                      "if(XmlDom.parseError.errorCode == 0)"+
		                      "{"+
			                  "XmlItem=XmlDom.getElementsByTagName(\"tablename\");"+
			                  "ret_count = XmlItem.length;"+
			                  "while(curObj.options.length!=1)"+
			                  "{"+
				              "curObj.options.remove(1);"+
			                  "}"+
			                  "if(ret_count>0)"+
			                  "{"+
				              "for(var i=0;i<ret_count;i++)"+
				              "{"+
					          "op = document.createElement(\"option\");"+
					          "op.value = XmlItem.item(i).selectSingleNode(\"DeptNo\").text;"+
					          "op.text = XmlItem.item(i).selectSingleNode(\"DeptName\").text;"+
					          "curObj.add(op);"+
				              "}"+
			                  "}"+
		                      "}"+
	                          "}"+
	                          "'"+
                              "><input type='hidden' name='signSel' "+
			                  "value='"+ XmlItem.item(i).selectSingleNode(value).text+"'>"+XmlItem.item(i).selectSingleNode(name).text+"</span>";
			        intCount++;
			    }
			}
			else
			    intFlag = 0;
		}
	}
	curObj.innerHTML = strHTML;
}

function IsSpecExistsKeyField1(tablename,keyField,fieldValue,obj,Msg,isDeleted)
{
    var strSql
    if(isDeleted)
        strSql = "select count("+keyField+") as "+keyField+" from "+tablename+" where "+keyField+"='"+fieldValue+"' AND isDeleted =0";
    else
        strSql = "select count("+keyField+") as "+keyField+" from "+tablename+" where "+keyField+"='"+fieldValue+"'";
	var str    = "<Root><funSql>"+strSql+"</funSql></Root>";
	xmlHTTP.open("POST","../../../IsKeyWord.aspx",false)
	xmlHTTP.send(str);
	if(xmlHTTP.statusText=="OK")
	{
		XmlDom.loadXML(xmlHTTP.responseText);
		if(XmlDom.parseError.errorCode == 0)
		{
			XmlItem=XmlDom.getElementsByTagName("tablename");
			if(XmlItem.item(0).selectSingleNode(keyField).text=="0")
			{
				alert(Msg);
				obj.value = "";
			}
		}
	}
}

//***********************
//填充层
//strSql SQL语句
//sourceObj 下拉框名称
//value 字段值
//***********************
function FillDiv1(strSql,sourceObj,value,name)
{
    var doc   =   window.frames["framHoldID1"].document;
    var str		="<ROOT><funSql>"+strSql+"</funSql></ROOT>";
	var curObj	= doc.getElementById(sourceObj);
	xmlHTTP.open("POST","../../../IsKeyWord.aspx",false);
	xmlHTTP.send(str);
	var strHTML = "";
	XmlDom.async=false;
	if(xmlHTTP.statusText == "OK")
	{
		XmlDom.loadXML(xmlHTTP.responseText);
		if(XmlDom.parseError.errorCode == 0)
		{
			XmlItem=XmlDom.getElementsByTagName("tablename");
			ret_count = XmlItem.length;
			if(ret_count>0)
			{
			    intCount =0;
			    intFlag = 1;
			    for(var i=0;i<ret_count;i++)
			    {
			        strHTML +="<span style='width:100%;font-size:9pt' onmouseover='this.style.backgroundColor=\"blue\";this.style.color=\"white\";"+
			                  "this.style.cursor=\"default\"' onmouseout='this.style.backgroundColor=\"white\";this.style.color=\"black\";"+
			                  "this.style.cursor=\"default\"' name='spList' onclick='"+
                              "parent.document.all.txtHoldID1.value = this.innerText;parent.document.all.txtHoldID1.focus();"+
                              "var inputHoldID1 = document.getElementsByName(\"signSel1\");"+
                              "parent.document.all.hit_HoldID1.value=inputHoldID1["+i+"].value;parent.document.getElementById(\"txtEquipmentType\").disabled=\"false\";parent.document.all.framHoldID1.style.display=\"none\";"+
                              "var xmlHTTP = new ActiveXObject(\"Microsoft.XMLHTTP\");"+
                              "var XmlItem = new ActiveXObject(\"Microsoft.XMLDOM\");"+
                              "var XmlDom = new ActiveXObject(\"Microsoft.XMLDOM\");"+
                              "var str		=\"<ROOT><funSql>select top 1 equipmentid,equipmentType from D_ObjectEquipmentDetail where equipmentid=\"+parent.document.all.hit_HoldID1.value+\"</funSql></ROOT>\";"+
	                          "var curObj	= parent.document.getElementById(\"txtEquipmentType\");"+
	                          "xmlHTTP.open(\"POST\",\"../../../IsKeyWord.aspx\",false);"+
	                          "xmlHTTP.send(str);"+
	                          "XmlDom.async=false;"+
	                          "if(xmlHTTP.statusText == \"OK\")"+
	                          "{"+
		                      "XmlDom.loadXML(xmlHTTP.responseText);"+
		                      "if(XmlDom.parseError.errorCode == 0)"+
		                      "{"+
			                  "XmlItem=XmlDom.getElementsByTagName(\"tablename\"); parent.document.all.txtEquipmentType.value=XmlItem.item(0).selectSingleNode(\"equipmentType\").text;"+
                               
				                  //xmlHTTP.responseText; parent.document.getElementById(\"ddlDept\");"
		
			    
		                      "}"+
	                          "}"+
	                          "'"+
                              "><input type='hidden' name='signSel1' "+
			                  "value='"+ XmlItem.item(i).selectSingleNode(value).text+"'>"+XmlItem.item(i).selectSingleNode(name).text+"</span>";
			        intCount++;
			    }
			    
			
			}
			else
			    intFlag = 1;
   
		}
	}
	    strHTML +="<span style='width:100%;font-size:9pt' onmouseover='this.style.backgroundColor=\"blue\";this.style.color=\"white\";"+
			                  "this.style.cursor=\"default\"' onmouseout='this.style.backgroundColor=\"white\";this.style.color=\"black\";"+
			                  "this.style.cursor=\"default\"'  onclick='"+
                              "parent.document.all.txtHoldID1.focus();"+
                             
                              "parent.document.all.hit_HoldID1.value=\"-1\";parent.document.getElementById(\"txtEquipmentType\").disabled=\"\";parent.document.all.framHoldID1.style.display=\"none\";"+
                      
    //Visible txtEquipmentType
			                  "parent.document.all.txtEquipmentType.value=\"\";"+
	                          "'"+
                              ">"+"新增</span>";
	curObj.innerHTML = strHTML;
}
//***********************
//填充层
//strSql SQL语句
//sourceObj 下拉框名称
//value 字段值
//***********************
function FillDiv2(strSql,sourceObj,value,name,strSql1)
{
    var doc   =   window.frames["framHoldID1"].document;
    var str		="<ROOT><funSql>"+strSql+"</funSql></ROOT>";
	var curObj	= doc.getElementById(sourceObj);
	xmlHTTP.open("POST","../../../IsKeyWord.aspx",false);
	xmlHTTP.send(str);
	var strHTML = "";
	XmlDom.async=false;
	if(xmlHTTP.statusText == "OK")
	{
		XmlDom.loadXML(xmlHTTP.responseText);
		if(XmlDom.parseError.errorCode == 0)
		{
			XmlItem=XmlDom.getElementsByTagName("tablename");
			ret_count = XmlItem.length;
			if(ret_count>0)
			{
			    intCount =0;
			    intFlag = 1;
			    for(var i=0;i<ret_count;i++)
			    {
			        strHTML +="<span style='width:100%;font-size:9pt' onmouseover='this.style.backgroundColor=\"blue\";this.style.color=\"white\";"+
			                  "this.style.cursor=\"default\"' onmouseout='this.style.backgroundColor=\"white\";this.style.color=\"black\";"+
			                  "this.style.cursor=\"default\"' name='spList' onclick='"+
                              "parent.document.all.txtHoldID1.value = this.innerText;parent.document.all.txtHoldID1.focus();"+
                              "var inputHoldID1 = document.getElementsByName(\"signSel1\");"+
                              "parent.document.all.hit_HoldID1.value=inputHoldID1["+i+"].value;parent.document.getElementById(\"txtEquipmentType\").disabled=\"false\";parent.document.getElementById(\"txtRanktype\").disabled=\"false\";parent.document.getElementById(\"txtPeopleName\").disabled=\"false\";parent.document.all.framHoldID1.style.display=\"none\";"+
                              "var xmlHTTP = new ActiveXObject(\"Microsoft.XMLHTTP\");"+
                              "var XmlItem = new ActiveXObject(\"Microsoft.XMLDOM\");"+
                              "var XmlDom = new ActiveXObject(\"Microsoft.XMLDOM\");"+
                              "var str		=\"<ROOT><funSql>"+strSql1+"\"+parent.document.all.hit_HoldID1.value+\"</funSql></ROOT>\";"+
	                          "var curObj	= parent.document.getElementById(\"txtEquipmentType\");"+
	                          "var curObj1	= parent.document.getElementById(\"txtRanktype\");"+
	                          "var curObj2	= parent.document.getElementById(\"txtPeopleName\");"+
	                          "xmlHTTP.open(\"POST\",\"../../../IsKeyWord.aspx\",false);"+
	                          "xmlHTTP.send(str);"+
	                          "XmlDom.async=false;"+
	                          "if(xmlHTTP.statusText == \"OK\")"+
	                          "{"+
		                      "XmlDom.loadXML(xmlHTTP.responseText);"+
		                      "if(XmlDom.parseError.errorCode == 0)"+
		                      "{"+
			                  "XmlItem=XmlDom.getElementsByTagName(\"tablename\"); parent.document.all.txtEquipmentType.value=XmlItem.item(0).selectSingleNode(\"customerName\").text; parent.document.all.txtRanktype.value=XmlItem.item(0).selectSingleNode(\"Ranktype\").text;parent.document.all.txtPeopleName.value=XmlItem.item(0).selectSingleNode(\"Peoplename\").text;"+
                               
				                  //xmlHTTP.responseText; parent.document.getElementById(\"ddlDept\");"
		
			    
		                      "}"+
	                          "}"+
	                          "'"+
                              "><input type='hidden' name='signSel1' "+
			                  "value='"+ XmlItem.item(i).selectSingleNode(value).text+"'>"+XmlItem.item(i).selectSingleNode(name).text+"</span>";
			        intCount++;
			    }
			    
			
			}
			else
			    intFlag = 0;
   
		}
	}

	curObj.innerHTML = strHTML;
}
//***********************
//填充层
//strSql SQL语句
//sourceObj 下拉框名称
//value 字段值
//***********************
function FillDivGetMileage(strSql,sourceObj,value,name,strSql1)
{
    var doc   =   window.frames["framHoldID"].document;
    var str		="<ROOT><funSql>"+strSql+"</funSql></ROOT>";
	var curObj	= doc.getElementById(sourceObj);
	xmlHTTP.open("POST","../../../IsKeyWord.aspx",false);
	xmlHTTP.send(str);
	var strHTML = "";
	XmlDom.async=false;
	if(xmlHTTP.statusText == "OK")
	{
		XmlDom.loadXML(xmlHTTP.responseText);
		if(XmlDom.parseError.errorCode == 0)
		{
			XmlItem=XmlDom.getElementsByTagName("tablename");
			ret_count = XmlItem.length;
			if(ret_count>0)
			{
			    intCount =0;
			    intFlag = 1;
			    for(var i=0;i<ret_count;i++)
			    {
			        strHTML +="<span style='width:100%;font-size:9pt' onmouseover='this.style.backgroundColor=\"blue\";this.style.color=\"white\";"+
			                  "this.style.cursor=\"default\"' onmouseout='this.style.backgroundColor=\"white\";this.style.color=\"black\";"+
			                  "this.style.cursor=\"default\"' name='spList' onclick='"+
                              "parent.document.all.txtHoldID1.value = this.innerText;parent.document.all.txtHoldID1.focus();"+
                              "var inputHoldID1 = document.getElementsByName(\"signSel1\");"+
                              "parent.document.all.hit_HoldID1.value=inputHoldID1["+i+"].value;parent.document.getElementById(\"txtonemainMileage\").disabled=\"false\";parent.document.getElementById(\"txtTwoMainmileage\").disabled=\"false\";parent.document.all.framHoldID.style.display=\"none\";"+
                              "var xmlHTTP = new ActiveXObject(\"Microsoft.XMLHTTP\");"+
                              "var XmlItem = new ActiveXObject(\"Microsoft.XMLDOM\");"+
                              "var XmlDom = new ActiveXObject(\"Microsoft.XMLDOM\");"+
                              "var str		=\"<ROOT><funSql>"+strSql1+"\"+parent.document.all.hit_HoldID1.value+\"</funSql></ROOT>\";"+
	                          "var curObj	= parent.document.getElementById(\"txtonemainMileage\");"+
	                          "var curObj1	= parent.document.getElementById(\"txtTwoMainmileage\");"+
	                      
	                          "xmlHTTP.open(\"POST\",\"../../../IsKeyWord.aspx\",false);"+
	                          "xmlHTTP.send(str);"+
	                          "XmlDom.async=false;"+
	                          "if(xmlHTTP.statusText == \"OK\")"+
	                          "{"+
		                      "XmlDom.loadXML(xmlHTTP.responseText);"+
		                      "if(XmlDom.parseError.errorCode == 0)"+
		                      "{"+
			                  "XmlItem=XmlDom.getElementsByTagName(\"tablename\"); parent.document.all.txtonemainMileage.value=XmlItem.item(0).selectSingleNode(\"OneMainMileage\").text; parent.document.all.txtTwoMainmileage.value=XmlItem.item(0).selectSingleNode(\"TwoMainMileage\").text;"+
                               
				                  //xmlHTTP.responseText; parent.document.getElementById(\"ddlDept\");"
		
			    
		                      "}"+
	                          "}"+
	                          "'"+
                              "><input type='hidden' name='signSel1' "+
			                  "value='"+ XmlItem.item(i).selectSingleNode(value).text+"'>"+XmlItem.item(i).selectSingleNode(name).text+"</span>";
			        intCount++;
			    }
			    
			
			}
			else
			    intFlag = 0;
   
		}
	}

	curObj.innerHTML = strHTML;
}



//***********************
//填充层
//strSql SQL语句
//sourceObj 下拉框名称
//value 字段值
//***********************
function FillDiv4(strSql,sourceObj,value,name,strSql1)
{
    var doc   =   window.frames["framHoldID1"].document;
    var str		="<ROOT><funSql>"+strSql+"</funSql></ROOT>";
	var curObj	= doc.getElementById(sourceObj);
	xmlHTTP.open("POST","../../../IsKeyWord.aspx",false);
	xmlHTTP.send(str);
	var strHTML = "";
	XmlDom.async=false;
	if(xmlHTTP.statusText == "OK")
	{
		XmlDom.loadXML(xmlHTTP.responseText);
		if(XmlDom.parseError.errorCode == 0)
		{
			XmlItem=XmlDom.getElementsByTagName("tablename");
			ret_count = XmlItem.length;
			if(ret_count>0)
			{
			    intCount =0;
			    intFlag = 1;
			    for(var i=0;i<ret_count;i++)
			    {
			        strHTML +="<span style='width:100%;font-size:9pt' onmouseover='this.style.backgroundColor=\"blue\";this.style.color=\"white\";"+
			                  "this.style.cursor=\"default\"' onmouseout='this.style.backgroundColor=\"white\";this.style.color=\"black\";"+
			                  "this.style.cursor=\"default\"' name='spList' onclick='"+
                              "parent.document.all.txtHoldID1.value = this.innerText;parent.document.all.txtHoldID1.focus();"+
                              "var inputHoldID1 = document.getElementsByName(\"signSel1\");"+
                              "parent.document.all.hit_HoldID1.value=inputHoldID1["+i+"].value;parent.document.getElementById(\"txtRanktype\").disabled=\"false\";parent.document.getElementById(\"txtPeopleName\").disabled=\"false\";parent.document.all.framHoldID1.style.display=\"none\";parent.window.frames[\"iframeEpassenger\"].location.href=\"FrmImage.aspx?KeyWord=\"+inputHoldID1["+i+"].value;"+
                              "var xmlHTTP = new ActiveXObject(\"Microsoft.XMLHTTP\");"+
                              "var XmlItem = new ActiveXObject(\"Microsoft.XMLDOM\");"+
                              "var XmlDom = new ActiveXObject(\"Microsoft.XMLDOM\");"+
                              "var str		=\"<ROOT><funSql>"+strSql1+"\"+parent.document.all.hit_HoldID1.value+\"</funSql></ROOT>\";"+
	                       
	                          "var curObj1	= parent.document.getElementById(\"txtRanktype\");"+
	                          "var curObj2	= parent.document.getElementById(\"txtPeopleName\");"+
	                          "xmlHTTP.open(\"POST\",\"../../../IsKeyWord.aspx\",false);"+
	                          "xmlHTTP.send(str);"+
	                          "XmlDom.async=false;"+
	                          "if(xmlHTTP.statusText == \"OK\")"+
	                          "{"+
		                      "XmlDom.loadXML(xmlHTTP.responseText);"+
		                      "if(XmlDom.parseError.errorCode == 0)"+
		                      "{"+
			                  "XmlItem=XmlDom.getElementsByTagName(\"tablename\");  parent.document.all.txtRanktype.value=XmlItem.item(0).selectSingleNode(\"Ranktype\").text;parent.document.all.txtPeopleName.value=XmlItem.item(0).selectSingleNode(\"Peoplename\").text;"+
                               
				                  //xmlHTTP.responseText; parent.document.getElementById(\"ddlDept\");"
		
			    
		                      "}"+
	                          "}"+
	                          "'"+
                              "><input type='hidden' name='signSel1' "+
			                  "value='"+ XmlItem.item(i).selectSingleNode(value).text+"'>"+XmlItem.item(i).selectSingleNode(name).text+"</span>";
			        intCount++;
			    }
			    
			
			}
			else
			    intFlag = 0;
   
		}
	}

	curObj.innerHTML = strHTML;
}
//***********************
//填充层
//strSql SQL语句
//sourceObj 下拉框名称
//value 字段值
//***********************
function FillDiv3(strSql,sourceObj,value,name,strSql1)
{
    var doc   =   window.frames["framHoldID1"].document;
    var str		="<ROOT><funSql>"+strSql+"</funSql></ROOT>";
	var curObj	= doc.getElementById(sourceObj);
	xmlHTTP.open("POST","../../../IsKeyWord.aspx",false);
	xmlHTTP.send(str);
	var strHTML = "";
	XmlDom.async=false;
	if(xmlHTTP.statusText == "OK")
	{
		XmlDom.loadXML(xmlHTTP.responseText);
		if(XmlDom.parseError.errorCode == 0)
		{
			XmlItem=XmlDom.getElementsByTagName("tablename");
			ret_count = XmlItem.length;
			if(ret_count>0)
			{
			    intCount =0;
			    intFlag = 1;
			    for(var i=0;i<ret_count;i++)
			    {
			        strHTML +="<span style='width:100%;font-size:9pt' onmouseover='this.style.backgroundColor=\"blue\";this.style.color=\"white\";"+
			                  "this.style.cursor=\"default\"' onmouseout='this.style.backgroundColor=\"white\";this.style.color=\"black\";"+
			                  "this.style.cursor=\"default\"' name='spList' onclick='"+
                              "parent.document.all.txtHoldID1.value = this.innerText;parent.document.all.txtHoldID1.focus();"+
                              "var inputHoldID1 = document.getElementsByName(\"signSel1\");"+
                              "parent.document.all.hit_HoldID1.value=inputHoldID1["+i+"].value;parent.document.getElementById(\"txtEquipmentType\").disabled=\"false\";parent.document.getElementById(\"txtRanktype\").disabled=\"false\";parent.document.getElementById(\"txtTel\").disabled=\"false\";parent.document.all.framHoldID1.style.display=\"none\";"+
                              "var xmlHTTP = new ActiveXObject(\"Microsoft.XMLHTTP\");"+
                              "var XmlItem = new ActiveXObject(\"Microsoft.XMLDOM\");"+
                              "var XmlDom = new ActiveXObject(\"Microsoft.XMLDOM\");"+
                              "var str		=\"<ROOT><funSql>"+strSql1+"\"+parent.document.all.hit_HoldID1.value+\"</funSql></ROOT>\";"+
	                          "var curObj	= parent.document.getElementById(\"txtEquipmentType\");"+
	                          "var curObj1	= parent.document.getElementById(\"txtRanktype\");"+
	                          "var curObj2	= parent.document.getElementById(\"txtTel\");"+
	                          "xmlHTTP.open(\"POST\",\"../../../IsKeyWord.aspx\",false);"+
	                          "xmlHTTP.send(str);"+
	                          "XmlDom.async=false;"+
	                          "if(xmlHTTP.statusText == \"OK\")"+
	                          "{"+
		                      "XmlDom.loadXML(xmlHTTP.responseText);"+
		                      "if(XmlDom.parseError.errorCode == 0)"+
		                      "{"+
			                  "XmlItem=XmlDom.getElementsByTagName(\"tablename\"); parent.document.all.txtEquipmentType.value=XmlItem.item(0).selectSingleNode(\"customerName\").text; parent.document.all.txtRanktype.value=XmlItem.item(0).selectSingleNode(\"Ranktype\").text; parent.document.all.txtTel.value=XmlItem.item(0).selectSingleNode(\"Tel\").text;"+
                               
				                  //xmlHTTP.responseText; parent.document.getElementById(\"ddlDept\");"
		
			    
		                      "}"+
	                          "}"+
	                          "'"+
                              "><input type='hidden' name='signSel1' "+
			                  "value='"+ XmlItem.item(i).selectSingleNode(value).text+"'>"+XmlItem.item(i).selectSingleNode(name).text+"</span>";
			        intCount++;
			    }
			    
			
			}
			else
			    intFlag = 0;
   
		}
	}

	curObj.innerHTML = strHTML;
}
//**********************
//根据参数选中下拉框中的选项
//sourceObj 下拉框名称
//value      参数值
//**********************
function FillSelectValue(sourceObj,value)
{
	var curObj = document.getElementById(sourceObj);
	for(var j = 0 ;j<curObj.options.length;j++)
	{
		if(curObj.options[j].value == value)
		{
			curObj.options[j].selected = true;
			break;
		}
	}	
}
//************************
///校验时间格式：hh:mm:ss
//strTime 时间格式
//************************
function ValidTimeFormat(strTime)
{
  try
  {  
    var strH,strM,strS;
	strH = strTime.split(":")[0];
	strM = strTime.split(":")[1]; 
	strS = strTime.split(":")[2];  
	
	if(strH.indexOf('0') == 0  && strH.length>1)strH = strH.substring(1,2);
	if(strM.indexOf('0') == 0 && strM.length>1)strM = strM.substring(1,2);
	if(strS.indexOf('0') == 0 && strS.length>1)strS = strS.substring(1,2);
	
	var nHour,nMinute,nSecond,nTemp;
	nHour = parseInt(strH);
	nMinute = parseInt(strM);
	nSecond = parseInt(strS);
	
	if(nHour>=0 && nHour<=23 && nMinute>=0 && nMinute<=59 && nSecond>=0 && nSecond<=59)return true;
	else 
	{
		return false;
	}
  }
  catch(ex)
  {
		return false;
  }
}
//*******************
//时间相加
//strTime 时间
//strType 类型 H 小时  M分钟 S小时
//nValue 加上的数值
//*******************
function AddTime(strTime,strType,nValue)
{
	try
	{
		var strH,strM,strS;
		strH = strTime.split(":")[0];
		strM = strTime.split(":")[1]; 
		strS = strTime.split(":")[2];  

		if(strH.indexOf('0') == 0 && strH.length>1)strH = strH.substring(1,2);
		if(strM.indexOf('0') == 0 && strM.length>1)strM = strM.substring(1,2);
		if(strS.indexOf('0') == 0 && strS.length>1)strS = strS.substring(1,2);
		
		var nOldSec = parseInt(strH)*60*60+parseInt(strM)*60+parseInt(strS);

		var nNewSec = 0;
		if(strType == 'H')nNewSec = parseInt(nValue)*60*60;
		if(strType == 'M')nNewSec = parseInt(nValue)*60;
		if(strType == 'S')nNewSec = parseInt(nValue);
		nNewSec = nNewSec + nOldSec;
		var nHour,nMinute,nSecond,nTemp;
		nHour = parseInt(nNewSec/3600);
		nTemp = nNewSec%3600;
		nMinute = parseInt(nTemp/60);
		nTemp  = nTemp%60;
		nSecond = parseInt(nTemp);

		if(nHour>23)nHour = nHour - 24;
		if(nMinute>59)nMinute = nMinute - 59;
		if(nSecond>59)nSecond = nSecond - 59;

		var strHour,strMinute,strSecond;
		if(nHour<10)strHour = "0" + String(nHour);
		else strHour = String(nHour);
		if(nMinute<10)strMinute = "0" + String(nMinute);
		else strMinute = String(nMinute);
		if(nSecond<10)strSecond = "0" + String(nSecond);
		else strSecond = String(nSecond);		
		
		var str =  strHour + ':'+strMinute+':'+strSecond;
		return str;
	}
	catch(ex)
	{
		alert(ex);
		return "";
	}
	return strTime;
}
//*************
//把时间转换成秒
//strTime 时间
//************
function TimeToSec(strTime)
{
	if(strTime == "" || strTime == null || strTime == undefined)return 0;
	
	var strH="",strM="",strS="";
	
	strH = strTime.split(":")[0];
	strM = strTime.split(":")[1]; 
	strS = strTime.split(":")[2];  		

	if(strH.indexOf('0') == 0 && strH.length>1)strH = strH.substring(1,2);
	if(strM.indexOf('0') == 0 && strM.length>1)strM = strM.substring(1,2);
	if(strS.indexOf('0') == 0 && strS.length>1)strS = strS.substring(1,2);
	

	var nSec = parseInt(strH)*60*60+parseInt(strM)*60+parseInt(strS);
	return nSec;	
}
//***************
//是否是日期时间
//obj 对象
//***************
function chkDate(obj)
{
	var r = "d=isDate('"+obj.value+"')";
	window.execScript(r,"vbscript");
	try
	{
		if(!d&&obj.value!="")
		{
			alert("输入日期时间有误，请重新输入！");
			obj.focus();
			return false;
		}
	}
	catch(ex){}
	return true;
}
//*****************
//单击选中一行
//obj 对象
//type 类型
//*****************

function SelectRow(obj,type)
{
	TempColor = obj.bgColor
	var index = obj.rowIndex;
	curRow	= obj.rowIndex;
	var SelectTableBody = obj.parentElement;
	for(i=0 ; i< SelectTableBody.children.length ; ++i)
	{
	
		if(String(SelectTableBody.children[i].bgColor) == SelectColor)
		{
			SelectTableBody.children[i].bgColor = TempColor
			break;
		}
	}
	obj.bgColor = SelectColor
}
//********************
//验证时间格式
//obj 时间控件
//********************
function chkTimeFormat(obj)
{
	var reg = /^(([0-2]{1}\d{1})|(\d{1}))\:[0-5]{1}\d{1}\:[0-5]{1}\d{1}/;
	try
	{
		if(!reg.test(obj.value))
		{
			alert("时间格式输入不正确，应该输入如23:59:59或者09:10:10");
			obj.value = "";
			obj.focus();
			return false;
		}
	}
	catch(ex){}
	try
	{
		var strTime = obj.value;
		var nHour,nMinute,nSecond;
		nHour = parseInt(strTime.split(":")[0]);
		nMinute = parseInt(strTime.split(":")[1]);
		nSecond = parseInt(strTime.split(":")[2]);

		if(nHour<0 || nHour>23 || nMinute<0 || nMinute>59 || nSecond<0 || nSecond>59)
		{
			alert("时间格式输入不正确，应该输入如23:59:59或者09:10:10");
			obj.value = "";
			obj.focus();
			return false;
		}
	}
	catch(ex){}
	
	return true;
}
///*****************************
///对列表框进行操作方法
///*****************************
//加载角色功能
function initRole(index)
{
    var CanRoleIDs;
    var CanRoleNames;
    var AleadyRoleIDs;
    var AleadyRoleNames;
    var CanLen;
    var AleadyLen;
    var op ;
    if(index == 1)
    {
        CanRoleIDs      = ary1[0].split(",");
	    CanRoleNames    = ary1[1].split(",");
	    AleadyRoleIDs   = ary1[2].split(",");
	    AleadyRoleNames = ary1[3].split(",");
	    CanLen    = CanRoleIDs.length;
	    AleadyLen = AleadyRoleIDs.length;
	    for(var i =0 ;i<CanLen;i++)
	    {
		    var flag = true;
		    for(var j=0;j<AleadyLen;j++)
		    {
			    if(CanRoleIDs[i]==AleadyRoleIDs[j])
			    {
				    flag = false;
				    op = document.createElement("option");
				    op.value = CanRoleIDs[i];
				    op.text  = CanRoleNames[i];
				    if(document.getElementById("ObjectIDs").value == "")
					    document.getElementById("ObjectIDs").value += op.value;
				    else
					    document.getElementById("ObjectIDs").value += ","+op.value;
				    dc.LBAlreadyRole1.add(op);
				    break;
			    }//end if
		    }//end for
		    if(flag)
		    {
			    op = document.createElement("option");
			    op.value = CanRoleIDs[i];
			    op.text  = CanRoleNames[i];
			    dc.LBCanRole1.add(op);
		    }//end if
	    }//end for
    }
    else if (index == 2)//用于权限系统－已选
    {
	    CanRoleIDs      = ary[0].split(",");
	    CanRoleNames    = ary[1].split(",");
	    AleadyRoleIDs   = ary[2].split(",");
	    AleadyRoleNames = ary[3].split(",");
	    CanLen          = CanRoleIDs.length;
	    AleadyLen       = AleadyRoleIDs.length;
	    //添加已选，排除可选
	    for(var i=0;i<AleadyLen;i++)
	    {
            op = document.createElement("option");
	        op.value = AleadyRoleIDs[i];
	        op.text  = AleadyRoleNames[i];
	        if(document.getElementById("RoleIDS").value == "")
		        document.getElementById("RoleIDS").value += op.value;
	        else
		        document.getElementById("RoleIDS").value += ","+op.value;
	        dc.LBAlreadyRole.add(op);
		}
		var listbox = document.getElementById("LBCanRole");
		listbox.innerHTML = "";
		initRole(3);
	}
	else if (index == 3)//用于权限系统－可选
    {
	    CanRoleIDs      = ary[0].split(",");
	    CanRoleNames    = ary[1].split(",");
	    AleadyRoleIDs   = ary[2].split(",");
	    AleadyRoleNames = ary[3].split(",");
	    CanLen          = CanRoleIDs.length;
	    AleadyLen       = AleadyRoleIDs.length;
	    //排除已选，添加可选
	    for(var i =0 ;i<CanLen;i++)
	    {
		    var flag = true;
		    for(var j=0;j<AleadyLen;j++)
		    {
			    if(CanRoleIDs[i]==AleadyRoleIDs[j] || CanRoleIDs[i] =="")
				    flag = false;
		    }
		    if(flag)
		    {
			    op = document.createElement("option");
			    op.value = CanRoleIDs[i];
			    op.text  = CanRoleNames[i];
			    dc.LBCanRole.add(op);
		    }
	    }
	}
    else
    {
	    CanRoleIDs      = ary[0].split(",");
	    CanRoleNames    = ary[1].split(",");
	    AleadyRoleIDs   = ary[2].split(",");
	    AleadyRoleNames = ary[3].split(",");
	     CanLen    = CanRoleIDs.length;
	    AleadyLen = AleadyRoleIDs.length;
	    for(var i =0 ;i<CanLen;i++)
	    {
		    var flag = true;
		    for(var j=0;j<AleadyLen;j++)
		    {
			    if(CanRoleIDs[i]==AleadyRoleIDs[j])
			    {
				    flag = false;
				    op = document.createElement("option");
				    op.value = CanRoleIDs[i];
				    op.text  = CanRoleNames[i];
				    if(document.getElementById("RoleIDS").value == "")
					    document.getElementById("RoleIDS").value += op.value;
				    else
					    document.getElementById("RoleIDS").value += ","+op.value;
				    dc.LBAlreadyRole.add(op);
				    break;
			    }//end if
		    }//end for
		    if(flag)
		    {
			    op = document.createElement("option");
			    op.value = CanRoleIDs[i];
			    op.text  = CanRoleNames[i];
			    dc.LBCanRole.add(op);
		    }//end if
	    }//end for
	}
}//end function
//添加选中选项功能
function doselRoles(index)
{
    if(index == 1)
    {
        if(dc.LBCanRole1.options.length==0)
		    return;
	    if(dc.LBCanRole1.selectedIndex<0)
	    {
		    alert("请选择要添加的对象");
		    return ;
	    }
	    while(dc.LBCanRole1.selectedIndex!=-1)
	    {
		    op       = document.createElement("option");
		    op.value = dc.LBCanRole1.item(dc.LBCanRole1.selectedIndex).value;
		    op.text  = dc.LBCanRole1.item(dc.LBCanRole1.selectedIndex).text;
		    if(document.getElementById("ObjectIDs").value == "")
			    document.getElementById("ObjectIDs").value += op.value;
		    else
			    document.getElementById("ObjectIDs").value += ","+op.value;
		    dc.LBAlreadyRole1.add(op);
		    dc.LBCanRole1.remove(dc.LBCanRole1.selectedIndex);
	    }//end while
    }
    else
    {
        if(dc.LBCanRole.options.length==0)
		return;
	if(dc.LBCanRole.selectedIndex<0)
	{
		alert("请选择要添加的对象");
		return ;
	}
	while(dc.LBCanRole.selectedIndex!=-1)
	{
		op       = document.createElement("option");
		op.value = dc.LBCanRole.item(dc.LBCanRole.selectedIndex).value;
		op.text  = dc.LBCanRole.item(dc.LBCanRole.selectedIndex).text;
		if(document.getElementById("RoleIDS").value == "")
			document.getElementById("RoleIDS").value += op.value;
		else
			document.getElementById("RoleIDS").value += ","+op.value;
		dc.LBAlreadyRole.add(op);
		dc.LBCanRole.remove(dc.LBCanRole.selectedIndex);
	}//end while
    }
}
//添加全部选项功能
function doSelAllRoles(index)
{
    if(index == 1)
    {
        if(dc.LBCanRole1.options.length==0)
		return;
	    var len = dc.LBCanRole1.options.length;
	    for(var i=0;i<len;i++)
	    {
		    op = document.createElement("option");
		    op.value = dc.LBCanRole1.item(i).value;
		    op.text  = dc.LBCanRole1.item(i).text;
		    if(document.getElementById("ObjectIDs").value == "")
			    document.getElementById("ObjectIDs").value += op.value;
		    else
			    document.getElementById("ObjectIDs").value += ","+op.value;
		    dc.LBAlreadyRole1.add(op);
	    }//end for
	    for(var i=0;i<len;i++)
	    {
		    dc.LBCanRole1.remove(0);
	    }
    }
    else
    {
        if(dc.LBCanRole.options.length==0)
		return;
	    var len = dc.LBCanRole.options.length;
	    for(var i=0;i<len;i++)
	    {
		    op = document.createElement("option");
		    op.value = dc.LBCanRole.item(i).value;
		    op.text  = dc.LBCanRole.item(i).text;
		    if(document.getElementById("RoleIDS").value == "")
			    document.getElementById("RoleIDS").value += op.value;
		    else
			    document.getElementById("RoleIDS").value += ","+op.value;
		    dc.LBAlreadyRole.add(op);
	    }//end for
	    for(var i=0;i<len;i++)
	    {
		    dc.LBCanRole.remove(0);
	    }
    }
}//end function
//双击添加选中的选项功能
function Dbselect(index)
{
    if(index == 1)
    {
        if(dc.LBCanRole1.options.length==0)
		return;
	    if(dc.LBCanRole1.selectedIndex<0)
		    return;
	    op = document.createElement("option");
	    op.value = dc.LBCanRole1.item(dc.LBCanRole1.selectedIndex).value;
	    op.text  = dc.LBCanRole1.item(dc.LBCanRole1.selectedIndex).text;
	    if(document.getElementById("ObjectIDs").value == "")
		    document.getElementById("ObjectIDs").value += op.value;
	    else
		    document.getElementById("ObjectIDs").value += ","+op.value;
	    dc.LBAlreadyRole1.add(op);
	    dc.LBCanRole1.remove(dc.LBCanRole1.selectedIndex);
    }
    else
    {
        if(dc.LBCanRole.options.length==0)
		return;
	    if(dc.LBCanRole.selectedIndex<0)
		    return;
	    op = document.createElement("option");
	    op.value = dc.LBCanRole.item(dc.LBCanRole.selectedIndex).value;
	    op.text  = dc.LBCanRole.item(dc.LBCanRole.selectedIndex).text;
	    if(document.getElementById("RoleIDS").value == "")
		    document.getElementById("RoleIDS").value += op.value;
	    else
		    document.getElementById("RoleIDS").value += ","+op.value;
	    dc.LBAlreadyRole.add(op);
	    dc.LBCanRole.remove(dc.LBCanRole.selectedIndex);
    }
}
//删除选中的选项功能
function doDelRoles(index)
{
    if(index == 1)
    {
        if(dc.LBAlreadyRole1.length==0)
		    return;
	    if(dc.LBAlreadyRole1.selectedIndex<0)
	    {
		    alert("请选择要删除的对象");
		    return;
	    }
	    document.getElementById("ObjectIDs").value = "";
	    while(dc.LBAlreadyRole1.selectedIndex!=-1)
	    {
		    op = document.createElement("option");
		    op.value = dc.LBAlreadyRole1.item(dc.LBAlreadyRole1.selectedIndex).value;
		    op.text  = dc.LBAlreadyRole1.item(dc.LBAlreadyRole1.selectedIndex).text;
		    dc.LBCanRole1.add(op);
		    dc.LBAlreadyRole1.remove(dc.LBAlreadyRole1.selectedIndex);
	    }//end while
	    len = dc.LBAlreadyRole1.options.length;
	    for(var i = 0 ;i< len;i++)
	    {
		    if(document.getElementById("ObjectIDs").value == "")
			    document.getElementById("ObjectIDs").value += dc.LBAlreadyRole1.item(i).value;
		    else
			    document.getElementById("ObjectIDs").value += ","+dc.LBAlreadyRole1.item(i).value;
	    }
    }
    else
    {
        if(dc.LBAlreadyRole.length==0)
		    return;
	    if(dc.LBAlreadyRole.selectedIndex<0)
	    {
		    alert("请选择要删除的对象");
		    return;
	    }
	    document.getElementById("RoleIDS").value = "";
	    while(dc.LBAlreadyRole.selectedIndex!=-1)
	    {
		    op = document.createElement("option");
		    op.value = dc.LBAlreadyRole.item(dc.LBAlreadyRole.selectedIndex).value;
		    op.text  = dc.LBAlreadyRole.item(dc.LBAlreadyRole.selectedIndex).text;
		    dc.LBCanRole.add(op);
		    dc.LBAlreadyRole.remove(dc.LBAlreadyRole.selectedIndex);
	    }//end while
	    len = dc.LBAlreadyRole.options.length;
	    for(var i = 0 ;i< len;i++)
	    {
		    if(document.getElementById("RoleIDS").value == "")
			    document.getElementById("RoleIDS").value += dc.LBAlreadyRole.item(i).value;
		    else
			    document.getElementById("RoleIDS").value += ","+dc.LBAlreadyRole.item(i).value;
	    }
    }
}
//删除全部选项
function doDelAllRoles(index)
{
    if(index == 1)
    {
        if(dc.LBAlreadyRole1.length==0)
		    return;
	    var len = dc.LBAlreadyRole1.length;
	    for(var i =0 ;i<len ;i++ )
	    {
		    op = document.createElement("option");
		    op.value = dc.LBAlreadyRole1.item(i).value;
		    op.text  = dc.LBAlreadyRole1.item(i).text;
		    dc.LBCanRole1.add(op);
	    }
	    for(var i = 0 ;i<len ; i++ )
	    {
		    dc.LBAlreadyRole1.remove(0);
	    }
	    document.getElementById("ObjectIDs").value = "";
    }
    else
    {
        if(dc.LBAlreadyRole.length==0)
		    return;
	    var len = dc.LBAlreadyRole.length;
	    for(var i =0 ;i<len ;i++ )
	    {
		    op = document.createElement("option");
		    op.value = dc.LBAlreadyRole.item(i).value;
		    op.text  = dc.LBAlreadyRole.item(i).text;
		    dc.LBCanRole.add(op);
	    }
	    for(var i = 0 ;i<len ; i++ )
	    {
		    dc.LBAlreadyRole.remove(0);
	    }
	    document.getElementById("RoleIDS").value = "";
    }
	
}
//双击删除选中的选项功能
function DbDelRoles(index)
{
    if(index == 1)
    {
        if(dc.LBAlreadyRole1.length==0)
		    return;
	    if(dc.LBAlreadyRole1.selectedIndex<0)
		    return;
	    document.getElementById("ObjectIDs").value = "";
	    op = document.createElement("option");
	    op.value = dc.LBAlreadyRole1.item(dc.LBAlreadyRole1.selectedIndex).value;
	    op.text  = dc.LBAlreadyRole1.item(dc.LBAlreadyRole1.selectedIndex).text;
	    dc.LBCanRole1.add(op);
	    dc.LBAlreadyRole1.remove(dc.LBAlreadyRole1.selectedIndex);
	    len = dc.LBAlreadyRole1.options.length;
	    for(var i = 0 ;i< len;i++)
	    {
		    if(document.getElementById("ObjectIDs").value == "")
			    document.getElementById("ObjectIDs").value += dc.LBAlreadyRole1.item(i).value;
		    else
			    document.getElementById("ObjectIDs").value += ","+dc.LBAlreadyRole1.item(i).value;
	    }
    }
    else
    {
        if(dc.LBAlreadyRole.length==0)
		    return;
	    if(dc.LBAlreadyRole.selectedIndex<0)
		    return;
	    document.getElementById("RoleIDS").value = "";
	    op = document.createElement("option");
	    op.value = dc.LBAlreadyRole.item(dc.LBAlreadyRole.selectedIndex).value;
	    op.text  = dc.LBAlreadyRole.item(dc.LBAlreadyRole.selectedIndex).text;
	    dc.LBCanRole.add(op);
	    dc.LBAlreadyRole.remove(dc.LBAlreadyRole.selectedIndex);
	    len = dc.LBAlreadyRole.options.length;
	    for(var i = 0 ;i< len;i++)
	    {
		    if(document.getElementById("RoleIDS").value == "")
			    document.getElementById("RoleIDS").value += dc.LBAlreadyRole.item(i).value;
		    else
			    document.getElementById("RoleIDS").value += ","+dc.LBAlreadyRole.item(i).value;
	    }
    }
}

//从列表里查找目标
function Research(strValue,intType)
{
    if(strValue == "")
        alert("请填写车牌号码!");
    else
    {
        var objvalue = strValue;
        var objType = intType;//对象类型,1."-"分隔;
        var op = document.getElementsByTagName('option');
        var flag = 0;//车辆是否存在,0不存在;1存在
        for (i=0;i<op.length;i++)
        {
            if(objType==1)//用'-'分隔
            {
                var TextArray;
                TextArray = op[i].innerText.split("-");
                var len = TextArray.length;
                var strText = TextArray[len-1];
                if(strText == objvalue)
                {
                    op[i].selected = "selected";
                    flag = 1;
                }
            }
            else//没有分隔符
            {
                if(op[i].text == objvalue)
                {
                    op[i].selected = "selected";
                    flag = 1;
                }
            }
        }
        if(flag == 0)
            alert("该车辆不在列表里,请重新输入!");
    }
}

function OpenID(id,strHoldID)
{
    openwin("Operation.aspx?KeyWord=" + id + "&HoldID=" +strHoldID);
}
function OpenIDBrows(id,strHoldID)
{
    openwin("OperationBrows.aspx?KeyWord=" + id + "&HoldID=" +strHoldID);
}
function OpenIDModalForm(id,strHoldID)
{
    ShowModalForm("Operation.aspx?KeyWord=" + id + "&HoldID=" +strHoldID);
}


//日历
function openCande(objID)
{
    var obj=document.getElementById(objID);
    var lf=event.x-390;
    var tp=event.y-200;
    var strLeft=(screen.availWidth-360)/2;
    var strTop=(screen.availHeight-270)/2;
    var sFeatures="dialogHeight:330px;dialogWidth:336px;dialogLeft="+ strLeft +";dialogTop="+ strTop +";center:no;help:no;scroll:no;status:no;resizable:no";
    var sDate=window.showModalDialog("../../../CalenderFrame.aspx?oDate="+obj.value,"",sFeatures);
   if(sDate != "" && sDate !=null && sDate != undefined)
        obj.value=sDate;
}
function openSearch(objID,objName,oType)
{
    var obj=document.getElementById(objID);
    var strLeft=(screen.availWidth-690)/2;
    var strTop=(screen.availHeight-900)/2;
    var sFeatures="dialogHeight:900px;dialogWidth:690px;dialogLeft="+ strLeft +";dialogTop="+ strTop +";center:no;help:no;scroll:no;status:no;resizable:no";
    var sDate=window.showModalDialog("../../CurrencySearchFrame.aspx?oType="+oType,"",sFeatures);
   if(sDate != "" && sDate !=null && sDate != undefined)
   {
        //alert(sDate.split(",")[1]);
        obj.value=sDate.split(",")[0];
        objName.value = sDate.split(",")[1];
   }
   else
   {
        obj.value = "";
        objName.value = "";
   }
}

//检测输入框长度
function ValidateLength(source, arguments)
  {
    var str=arguments.Value;   
    var   totallength=0;   
    for     (var     i=0;i<str.length;i++)   
      {   
            var   intCode=str.charCodeAt(i);   
                    
            if     (intCode>=0   &&   intCode<=128)     
            {
                    //continue;   
                    totallength=totallength+1;   
            }   
            else
            {   
                    totallength=totallength+2;   
             }   
      }     //end     for   
     arguments.IsValid=(totallength<=source.maxLength); 
}

//去字符前后空格
String.prototype.Trim = function()
{
    return this.replace(/(^\s*)|(\s*$)/g, "");
}
String.prototype.LTrim = function()
{
    return this.replace(/(^\s*)/g, "");
}
String.prototype.Rtrim = function()
{
    return this.replace(/(\s*$)/g, "");
}
//改变输入框背景色
 function Changetxtbg(obj)
 {
    obj.style.backgroundColor="#E5FDE5";
 }
 //改变输入框背景色
 function Renewtxtbg(obj)
 {
    obj.style.backgroundColor="#ffffff";
 }
//*********************
function CommonCheck(strSql)
{
    var str    = "<Root><funSql>"+strSql+"</funSql></Root>";
	xmlHTTP.open("POST","../../../IsKeyWord.aspx",false)
	xmlHTTP.send(str);
	if(xmlHTTP.statusText=="OK")
	{
	    XmlDom.loadXML(xmlHTTP.responseText);
		if(XmlDom.parseError.errorCode == 0)
		{
			XmlItem=XmlDom.getElementsByTagName("tablename");
			var count = XmlItem.length;
			if(count>0)
			    return true;
		    else
		        return false;
		 }
	}
}


//去除字符串前后空格
String.prototype.trim = function()
{
   return this.replace(/(^\s+)|\s+$/g,"");
 }
//过滤非法字符
function FliterString(inputString)
{
    inputString = inputString.trim();
    inputString = inputString.replace("'","");
    inputString = inputString.replace("--","");
    inputString = inputString.toLowerCase().replace("drop","");
    return inputString;
}

String.prototype.fliter = function()
{
    return FliterString(this);
}



//获取URL参数
function getQuery(name)
{
    var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)");
    var r = window.location.search.substr(1).match(reg);
    if (r!=null) return unescape(r[2]); return null;
} 




//除法函数，用来得到精确的除法结果
//说明：javascript的除法结果会有误差，在两个浮点数相除的时候会比较明显。这个函数返回较为精确的除法结果。
//调用：accDiv(arg1,arg2)
//返回值：arg1除以arg2的精确结果
function accDiv(arg1,arg2){
    var t1=0,t2=0,r1,r2;
    try{t1=arg1.toString().split(".")[1].length}catch(e){}
    try{t2=arg2.toString().split(".")[1].length}catch(e){}
    with(Math){
        r1=Number(arg1.toString().replace(".",""))
        r2=Number(arg2.toString().replace(".",""))
        return (r1/r2)*pow(10,t2-t1);
    }
}

//给Number类型增加一个div方法，调用起来更加方便。
Number.prototype.div = function (arg){
    return accDiv(this, arg);
}

//乘法函数，用来得到精确的乘法结果
//说明：javascript的乘法结果会有误差，在两个浮点数相乘的时候会比较明显。这个函数返回较为精确的乘法结果。
//调用：accMul(arg1,arg2)
//返回值：arg1乘以arg2的精确结果
function accMul(arg1,arg2)
{
    var m=0,s1=arg1.toString(),s2=arg2.toString();
    try{m+=s1.split(".")[1].length}catch(e){}
    try{m+=s2.split(".")[1].length}catch(e){}
    return Number(s1.replace(".",""))*Number(s2.replace(".",""))/Math.pow(10,m)
}

//给Number类型增加一个mul方法，调用起来更加方便。
Number.prototype.mul = function (arg){
    return accMul(arg, this);
}

//加法函数，用来得到精确的加法结果
//说明：javascript的加法结果会有误差，在两个浮点数相加的时候会比较明显。这个函数返回较为精确的加法结果。
//调用：accAdd(arg1,arg2)
//返回值：arg1加上arg2的精确结果
function accAdd(arg1,arg2){
    var r1,r2,m;
    try{r1=arg1.toString().split(".")[1].length}catch(e){r1=0}
    try{r2=arg2.toString().split(".")[1].length}catch(e){r2=0}
    m=Math.pow(10,Math.max(r1,r2))
    //return (arg1*m+arg2*m)/m
    return (accMul(arg1,m)+accMul(arg2,m))/m
}

//给Number类型增加一个add方法，调用起来更加方便。
Number.prototype.add = function (arg){
    return accAdd(arg,this);
}



function accDed(arg1,arg2){
    var r1,r2,m;
    try{r1=arg1.toString().split(".")[1].length}catch(e){r1=0}
    try{r2=arg2.toString().split(".")[1].length}catch(e){r2=0}
    m=Math.pow(10,Math.max(r1,r2))
    //return (arg1*m+arg2*m)/m
    return (accMul(arg1,m)-accMul(arg2,m))/m
}

//给Number类型增加一个add方法，调用起来更加方便。
Number.prototype.ded = function (arg){
    return accDed(this,arg);
}

//获取俩控件从属位置
function SetControlPosition(AbsoluteObjID,RelateObjID)
{
    var tempobj = document.getElementById(AbsoluteObjID);
    var pos = getAbsolutePosition(tempobj);
    var Divobj = document.getElementById(RelateObjID);
    Divobj.style.left = pos.x-2;
    Divobj.style.top = pos.y + tempobj.offsetHeight-2;
    Divobj.style.position = "absolute";
    Divobj.width = tempobj.offsetWidth-4;
    Divobj.height = 100;
}
//获取绝对位置函数
function getAbsolutePosition(obj)
{position = new Object();
position.x = 0;position.y = 0;
var tempobj = obj;
while(tempobj!=null && tempobj!=document.body)
{position.x += tempobj.offsetLeft + tempobj.clientLeft;position.y += tempobj.offsetTop + tempobj.clientTop;tempobj = tempobj.offsetParent;}
return position;}




 //根据传入信息解析是否报警
 //参数：MDTStatus：报警数据信息；按位判断是那种报警 此位为 1：报警；0：无报警
 //      ValidAlarm：有效报警的数组，数组元素为 1：有效报警；0：无效报警
 //返回是否报警：0，不报警；1报警
 function  getAlarmType(MDTStatus,ValidAlarm)   
 {
 
     var isAlarm = 0;
     var n =  MDTStatus.length;
     var t=0x01;
     //debugger;
     //数据第一位
     if ((((MDTStatus.charCodeAt(1)) >> 3) & t) == 1)//剪线报警
     {
        if(ValidAlarm[0]==1)
        {
           isAlarm = 1;
        }   
      }
      if ((((MDTStatus.charCodeAt(1)) >> 2) & t) == 1)//密码输入错误
      {
          if(ValidAlarm[1]==1)
          {
              isAlarm = 1;
          }
      }
      if ((((MDTStatus.charCodeAt(1)) >> 1) & t) == 1)//翻车报警
      {
          if(ValidAlarm[2]==1)
          {
              isAlarm = 1;
          }
      }
      if (((MDTStatus.charCodeAt(1)) & t) == 1)//劫警
      {
          if(ValidAlarm[3]==1)
          {
              isAlarm = 1;
          }
      }
      //数据第二位
      if ((((MDTStatus.charCodeAt(2)) >> 3) & t) == 1)//超出线路报警
      {
          if(ValidAlarm[4]==1)
          {
              isAlarm = 1;
          }
      }
      if ((((MDTStatus.charCodeAt(2)) >> 2) & t) == 1)//盗警
      {
          if(ValidAlarm[5]==1)
          {
              isAlarm = 1;
          }
      }
      if ((((MDTStatus.charCodeAt(2)) >> 1) & t) == 1)//LCD故障
      {
          if(ValidAlarm[6]==1)
          {
              isAlarm = 1;
          }
      }
      if (((MDTStatus.charCodeAt(2)) & t) == 1)//GPS接收机故障
      {
          if(ValidAlarm[7]==1)
          {
              isAlarm = 1;
          }
      }
      //数据第三位
      if ((((MDTStatus.charCodeAt(3)) >> 3) & t) == 1)//车载喇叭响
      {
          if(ValidAlarm[8]==1)
          {
              isAlarm = 1;
          }
      }
      if ((((MDTStatus.charCodeAt(3)) >> 1) & t) == 1)//超速报警
      {
          if(ValidAlarm[9]==1)
          {
              isAlarm = 1;
          }
      }
      if (((MDTStatus.charCodeAt(3)) & t) == 1)//报警器断电
      {
          if(ValidAlarm[10]==1)
          {
              isAlarm = 1;
          }
      }
      //数据第四位
      if ((((MDTStatus.charCodeAt(4)) >> 3) & t) == 1)//碰撞报警
      {
          if(ValidAlarm[11]==1)
          {
              isAlarm = 1;
          }
      }
      if ((((MDTStatus.charCodeAt(4)) >> 1) & t) == 1)//ACC线故障
      {
          if(ValidAlarm[12]==1)
          {
              isAlarm = 1;
          }
      }
      if (((MDTStatus.charCodeAt(4)) & t) == 1)//电瓶拆除报警
      {
          if(ValidAlarm[13]==1)
          {
              isAlarm = 1;
          }
      }
      //数据第五位
      if ((((MDTStatus.charCodeAt(5)) >> 3) & t) == 1)//出范围报警
      {
          if(ValidAlarm[14]==1)
          {
              isAlarm = 1;
          }
      }
      if ((((MDTStatus.charCodeAt(5)) >> 2) & t) == 1)//进范围报警
      {
          if(ValidAlarm[15]==1)
          {
              isAlarm = 1;
          }
      }
      //数据第六位
      if ((((MDTStatus.charCodeAt(6)) >> 3) & t) == 1)//手柄故障
     {
          if(ValidAlarm[16]==1)
          {
              isAlarm = 1;
          }
      }
      if ((((MDTStatus.charCodeAt(6)) >> 2) & t) == 1)//锁车电路故障
      {
          if(ValidAlarm[17]==1)
          {
              isAlarm = 1;
          }
      }
      if ((((MDTStatus.charCodeAt(6)) >> 1) & t) == 1)//GSM模块故障
      {
          if(ValidAlarm[18]==1)
          {
              isAlarm = 1;
          }
      }
      if (((MDTStatus.charCodeAt(6)) & t) == 1)//总线故障
      {
          if(ValidAlarm[19]==1)
          {
              isAlarm = 1;
          }
      }
      //数据第七位
      if ((((MDTStatus.charCodeAt(7)) >> 2) & t) == 1)//越站报警
      {
          if(ValidAlarm[20]==1)
          {
              isAlarm = 1;
          }
      }
      if ((((MDTStatus.charCodeAt(7)) >> 1) & t) == 1)//停车休息时间不足
      {
          if(ValidAlarm[21]==1)
          {
              isAlarm = 1;
          }
      }
      if (((MDTStatus.charCodeAt(7)) & t) == 1)//非法时间段行驶
      {
          if(ValidAlarm[22]==1)
          {
              isAlarm = 1;
          }
      }
      //数据第九位
      if ((((MDTStatus.charCodeAt(9)) >> 3) & t) == 1)//低油量报警
      {
          if(ValidAlarm[23]==1)
          {
              isAlarm = 1;
          }
      }
      //数据第十位
      if ((((MDTStatus.charCodeAt(10)) >> 3) & t) == 1)//油量异常下降报警
      {
          if(ValidAlarm[24]==1)
          {
              isAlarm = 1;
          }
      }
      if ((((MDTStatus.charCodeAt(10)) >> 2) & t) == 1)//低电压报警
      {
          if(ValidAlarm[25]==1)
          {
              isAlarm = 1;
          }
      }
      if ((((MDTStatus.charCodeAt(10)) >> 1) & t) == 1)//油量异常上升报警
      {
          if(ValidAlarm[26]==1)
          {
              isAlarm = 1;
          }
      }
      if (((MDTStatus.charCodeAt(10)) & t) == 1)//非法点火报警
      {
          if(ValidAlarm[27]==1)
          {
              isAlarm = 1;
          }
      }
     return isAlarm;
 }
 
 //初始化页面时焦点定位
 //strID:待定位的控件ID
 function InitPageFocus(strID)
 {
    document.getElementById(strID).focus();
 }
 