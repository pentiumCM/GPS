<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Mobile_Login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />	<meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title> <% =Resources.Lan.Title %></title>
    <link rel="stylesheet" type="text/css" href="../EasyUI/themes/metro/easyui.css" />     <link rel="stylesheet" type="text/css" href="../EasyUI/themes/mobile.css" />    <link rel="stylesheet" type="text/css" href="../EasyUI/themes/color.css" />    <link rel="stylesheet" type="text/css" href="../EasyUI/themes/icon.css" />
    <script type="text/javascript" src="../Js/JsBase64.js"></script>  
    <script type="text/javascript" src="../Js/jquery-1.8.0.min.js"></script>    <script type="text/javascript" src="../Js/JsCookies.js"></script>     <script type="text/javascript" src="../EasyUI/jquery.easyui.min.js"></script>  
    <script type="text/javascript" src="../EasyUI/jquery.easyui.mobile.js"></script>
    <style type="text/css">	   
        .mycode {
                display: inline-block;
                width: 80px;
                height: 40px;
                vertical-align: middle;
                border: solid #999999 1px;
                border-radius: 10px;
                box-shadow: #000000 inset 0px 0px 2px;
            }
        .cright{
	        z-index:500;float:right;position:absolute;right:10px;top:5px;
        }
    </style>
</head>
<body onkeydown="keyLogin();">
    <div class="easyui-navpanel" id="divMain">		<header>			<div class="m-toolbar" id="divT1">				<span class="m-title"><% =Resources.Lan.Welcome%></span>				<span class="m-right"><a id="btn-edit" href="#;" class="easyui-menubutton" data-options="menu:'#mm1',iconCls:'icon-language'"><% =Resources.Lan.LanChange %></a></span>			</div>		</header>		<div id="divT2" style="margin:20px auto;width:100px;height:100px;border-radius:100px;overflow:hidden">			<img alt="" src="../Img/user.png" style="margin:0;width:100%;height:100%;" />		</div>		<div id="divT3" style="padding:0 20px">			<div style="margin-bottom:10px">				<input type="text" id="txtUserID"  class="easyui-textbox"  data-options="prompt:'<% =Resources.Lan.EnterAccount %>',iconCls:'icon-man'" style="width:100%;height:38px" />			</div>			<div>				<input type="password" id="txtPwd" class="easyui-textbox" data-options="prompt:'<% =Resources.Lan.EnterPassword %>',iconCls:'icon-lock'" style="width:100%;height:38px" />			</div>			<div style="display:none;">			    <input type="text" id="inputCode" style="width:150px;" placeholder="<% =Resources.Lan.EndterVerificationCode %>"/>
				<span id="code" class="mycode"></span>			</div>			<div>			    <input type="checkbox" style="vertical-align:middle;" name="chkRember" id="chkRember"  value="<% =Resources.Lan.Rember %>" />&nbsp;<% =Resources.Lan.Rember %>			</div>			<%--<div class="easyui-navpanel" >			    <ul class="m-list" >			        <li >			            <span>默认以公司账号登录</span>			            <div class="m-right"  plain="true" outline="true"><input id="chkSwitch" class="easyui-switchbutton" checked data-options="onText:'是',offText:'否'"></div>			        </li>			    </ul>							</div>--%>			<div style="text-align:center;margin-top:50px">				<a href="#"  id="btnCompany" onclick="return CodeValidate(1);" class="easyui-linkbutton c6"plain="true" outline="true" style="width:150px;height:35px"><span style="font-size:16px"><% =Resources.Lan.CompanyLogin %></span></a> 
			    <a href="#" id="btnVeh" onclick="return CodeValidate(2);" class="easyui-linkbutton c6"plain="true" outline="true" style="width:150px;height:35px"><span style="font-size:16px"><% =Resources.Lan.VehLogin %></span></a> 			</div>			<div style="width:0px; height:0px; display:none;">
                <form id="cs" runat="server">
                    <asp:Button ID="btnLoginCS" Width="0" Height="0" runat="server" Text="" OnClick="btnLoginCS_Click" />
                </form>
			</div>		</div>
        <div id="mm1" style="width:150px;">
		    <div onclick="ChangeLan('zh-CN')">中文</div>
		    <div onclick="ChangeLan('en-US')">English</div>
	    </div>	</div>   
	<div class="easyui-navpanel" id="p2">
	</div>
</body>
</html>

<%--<script type="text/javascript" src="../Js/com.js"></script>
<script type="text/javascript" src="../js/js.KinerCode.js"></script>
<script type="text/javascript" src="../js/AuthCode.js"></script--%>>
<!--[if IE 6]>
<script language="javascript" type="text/javascript" src="./script/ie6_png.js"></script>
<script language="javascript" type="text/javascript">
DD_belatedPNG.fix(".png");
</script>
<![endif]-->
<script type="text/javascript">
    function GoBack()
    {
        
    }
        
    function keyLogin(){
      if (event.keyCode==13)   //回车键的键值为13
         $("#btnCompany")[0].click();  //调用登录按钮的登录事件
    }
    var arrErr = new Array();
    arrErr.push({ "key": "4001","value":"<% =Resources.Lan.EnterAccountAndPassword %>"});
    arrErr.push({ "key": "4002","value":"<% =Resources.Lan.NotEnterIllegalCharacters %>"});
    arrErr.push({ "key": "4004","value":"<% =Resources.Lan.AccountNotExist %>"});
    arrErr.push({ "key": "4005","value":"<% =Resources.Lan.AccountOverdue %>"});
    arrErr.push({ "key": "4006","value":"<% =Resources.Lan.UnknownError %>"});

    function GetErr(key)
    {
        for(var i = 0; i < arrErr.length; i++)
        {
            if(arrErr[i].key == key)
            {
                return arrErr[i].value;
            }
        }
        return key;
    }

    function ChangeLan(lan)
    {
        window.location.href = 'Login.aspx?lan=' + lan;
    }
    
    function aa()
    {
        window.location.href = 'http://www.baidu.com';
    }

    function CodeValidate(doType)
    {
//        if(!c.validate())
//        {
//            alert("验证码错误！");
//            return false;
//        }
        login(doType);
        return true;
    }
    
    function login(doType){            $("#divPng").css({display: "none"});		    $("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: "100%", zIndex: 99999 }).appendTo("body");  
            $("<div class=\"datagrid-mask-msg\"></div>").html("<% =Resources.Lan.Loding %>").appendTo("body").css({ display: "block", left: ($(document.body).outerWidth(true) - 190) / 2, top: ($(window).height() - 45) / 2 });  		    if(!AntiSqlValid($("#txtUserID")[0]))		    {
		        $(".datagrid-mask").remove();  
                $(".datagrid-mask-msg").remove(); 
                OpenInfo("<% =Resources.Lan.AccountNotEnterIllegalCharacters %>");                return;		    }		    if(!AntiSqlValid($("#txtPwd")[0]))		    {
		        $(".datagrid-mask").remove();  
                $(".datagrid-mask-msg").remove(); 
                OpenInfo("<% =Resources.Lan.PwdNotEnterIllegalCharacters %>");                return;		    }		    var txtUserID = $("#txtUserID").val();		    var txtPwd = $("#txtPwd").val();//		    var Request = new Object();
//            Request = GetRequest();
//            var sOpenid = Request["openid"];		    if(txtUserID.length == 0 || txtPwd.length == 0)		    {
		        $(".datagrid-mask").remove();  
                $(".datagrid-mask-msg").remove(); 
                OpenInfo("<% =Resources.Lan.EnterAccountAndPassword %>");                return;		    }            $.ajax({
                url: "../Ashx/Login.ashx",
                cache:false,
                type:"post",
                dataType:'json',
                data:{username:txtUserID,Pwd:txtPwd,loginDefaultType:doType},
                success:function(data){
                        if(data.result == "true")
                        {
                            SetCookie("rember",$("#chkRember")[0].checked);
                            SetCookie("userid",data.userid);
                            SetCookie("username",txtUserID);
                            SetCookie("pwd",txtPwd);
                            SetCookie("logintype",doType);
//                                delCookie("pwd");
//                            window.location.href = 'Index.aspx';
//                            OpenInfo("绑定成功！");
                            $("#btnLoginCS")[0].click();
                        }
                        else
                        {
                            OpenInfo(GetErr(data.err));
		                    $(".datagrid-mask").remove();  
                            $(".datagrid-mask-msg").remove(); 
                        }
                },
                error: function(e) { 
		            $(".datagrid-mask").remove();  
                    $(".datagrid-mask-msg").remove(); 
                    OpenInfo(e.responseText); 
                } 
            })        }                function OpenInfo(info)        {            var data = "<div>" + info + "</div>";//            $("#dlgInfo").html("<p>" + info + "</p>");//            $("#dlg1").dialog('open').dialog('center');               $.messager.alert('<% =Resources.Lan.Prompt %>',data,'question');        }
        
        $(document).ready(function() { 
            var sUrl=location.search.toLowerCase();
            var sQuery=sUrl.substring(sUrl.indexOf("=")+1);
            re=/select|update|delete|truncate|join|union|exec|insert|drop|count|’|"|;|>|</i;
            if(re.test(sQuery))
            {
                OpenInfo("<% =Resources.Lan.NotEnterIllegalCharacters %>");
                location.href=sUrl.replace(sQuery,"");
            }            var rember = GetCookie("rember");
            if(rember != undefined)
            {
                if(rember == "true")
                {
                    $("#chkRember")[0].checked = true;
                    var username = GetCookie("username");
                    if(username != undefined)
                    {
                        $("#txtUserID").textbox('setValue',username);                    }                    var pwd = GetCookie("pwd");
                    if(pwd != undefined)                    {		                $("#txtPwd").textbox('setValue',pwd);
		            }
                }
            }            var Request = GetRequest();
            var sRUser = Request["rUser"];
            var sRPwd = Request["rPwd"];            if(sRUser != undefined && sRPwd  != undefined)            {                $("#txtUserID").textbox('setValue',utf8to16(base64decode(sRUser)));		        $("#txtPwd").textbox('setValue',utf8to16(base64decode(sRPwd)));		        $("#divT1").css('display','none'); 		        $("#divT2").css('display','none'); 		        $("#divT3").css('display','none'); 		        $("#divmm1").css('display','none'); //		        $.mobile.go('#p2');		        CodeValidate(1);            }            else            {                        }        })
        
        //防止SQL注入
       function AntiSqlValid(oField)
       {
           re= /select|update|delete|insert|exec|count|’|"|=|;|>|</i;
           if ( re.test(oField.value) )
           {
               return false;
           }
           return true;
       }
       
       function GetRequest() {  
          var url = location.search; //获取url中"?"符后的字串
           var theRequest = new Object();
           if (url.indexOf("?") != -1) {
              var str = url.substr(1);
              strs = str.split("&");
              for(var i = 0; i < strs.length; i ++) {
                 theRequest[strs[i].split("=")[0]]=(strs[i].split("=")[1]);
              }
           }
           return theRequest;
    }
    
    
</script>
