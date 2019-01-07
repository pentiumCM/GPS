<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="K_Login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="renderer" content="webkit"> 
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title> <% =Resources.Lan.K1Title2 %></title>
    <link rel="stylesheet" type="text/css" href="../css/style2.0.css" />
    <%--<link rel="stylesheet" type="text/css" href="EasyUI/themes/metro/easyui.css" /> --%>
	<link rel="stylesheet" type="text/css" href="../EasyUI/themes/default/easyui.css">    <link rel="stylesheet" type="text/css" href="../EasyUI/themes/color.css" />
	<!--<link rel="stylesheet" type="text/css" href="EasyUI/themes/demo.css" />-->    <link rel="stylesheet" type="text/css" href="../EasyUI/themes/icon.css" />  
<script type="text/javascript" src="../js/jquery-1.8.0.min.js"></script>    <script type="text/javascript" src="../Js/JsCookies.js"></script> 
    <script type="text/javascript" src="../Js/JsBase64.js"></script>      <%--<script type="text/javascript" src="EasyUI/jquery.min.js"></script>--%>      <script type="text/javascript" src="../EasyUI/jquery.easyui.min.js"></script>  
    <style type="text/css">
	    ul li{font-size: 30px;color:#2ec0f6;}
	    .tyg-div{z-index:-1000;float:left;position:absolute;left:5%;top:20%;}
	    .tyg-p{
		    font-size: 14px;
	        font-family: 'microsoft yahei';
	        position: absolute;
	        top: 135px;
	        left: 80px;
	    }
	    .tyg-div-denglv{
		    z-index:500;float:right;position:absolute;right:3%;top:10%;
	    }
	    .tyg-div-form{
		    background-color: #23305a;
		    width:300px;
		    height:auto;
		    margin:120px auto 0 auto;
		    color:#2ec0f6;
	    }
	    .tyg-div-form form {padding:10px;}
	    .tyg-div-form form input[type="text"]{
		    width: 270px;
	        height: 30px;
	        margin: 25px 10px 0px 0px;
	    }
	    .tyg-div-form form button {
	        cursor: pointer;
	        width: 270px;
	        height: 44px;
	        margin-top: 25px;
	        padding: 0;
	        background: #2ec0f6;
	        -moz-border-radius: 6px;
	        -webkit-border-radius: 6px;
	        border-radius: 6px;
	        border: 1px solid #2ec0f6;
	        -moz-box-shadow:
	            0 15px 30px 0 rgba(255,255,255,.25) inset,
	            0 2px 7px 0 rgba(0,0,0,.2);
	        -webkit-box-shadow:
	            0 15px 30px 0 rgba(255,255,255,.25) inset,
	            0 2px 7px 0 rgba(0,0,0,.2);
	        box-shadow:
	            0 15px 30px 0 rgba(255,255,255,.25) inset,
	            0 2px 7px 0 rgba(0,0,0,.2);
	        font-family: 'PT Sans', Helvetica, Arial, sans-serif;
	        font-size: 14px;
	        font-weight: 700;
	        color: #fff;
	        text-shadow: 0 1px 2px rgba(0,0,0,.1);
	        -o-transition: all .2s;
	        -moz-transition: all .2s;
	        -webkit-transition: all .2s;
	        -ms-transition: all .2s;
        }
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
    <div style="display:none; width:0; height:0">
        <iframe id="ifCookie" name="ifCookie" frameborder="0"  src="../SetCookie.aspx" style="width:100%;height:100%;"></iframe>
    </div>
    <div id="dis3" class="cright">
    <div class="easyui-panel" style="padding:5px; margin-top:32px;">
    <a id="btn-VehMsg" href="../mng/Login.aspx?k=2" target="_blank" class="easyui-linkbutton" data-options="iconCls:'icon-setting'"><% =Resources.Lan.BackEnd %></a>
    <%--<a id="btn-edit" href="#;" class="easyui-menubutton" data-options="menu:'#mm1',iconCls:'icon-language'"><% =Resources.Lan.LanChange %></a>--%>
    </div>
</div>
<div id="mm1" style="width:150px;">
		<!--<div data-options="iconCls:'icon-undo'">Undo</div>-->
		<div onclick="ChangeLan('zh-CN')">中文</div>
		<div onclick="ChangeLan('en-US')">English</div>
	</div>
<div id="dis1" class="tyg-div">
	<ul><!--让数据改变生活-->
    	<li><% =Resources.Lan.Welcome_1 %></li>
    	<li><div style="margin-left:20px;"><% =Resources.Lan.Welcome_2 %></div></li>
    	<li><div style="margin-left:40px;"><% =Resources.Lan.Welcome_3 %></div></li>
    	<li><div style="margin-left:60px;"><% =Resources.Lan.Welcome_4 %></div></li>
    	<li><div style="margin-left:80px;"><% =Resources.Lan.Welcome_5 %></div></li>
    	<li><div style="margin-left:100px;"><% =Resources.Lan.Welcome_6 %></div></li>
    	<li><div style="margin-left:120px;"><% =Resources.Lan.Welcome_7 %></div></li>
    	<li><div style="margin-left:140px;"><% =Resources.Lan.Welcome_8 %></div></li>
    </ul>
</div> 
<div id="contPar" class="contPar">
	<div id="page1"  style="z-index:1;">
		<div class="title0"><% =Resources.Lan.K1Title2 %></div>
		<div class="title1"><% =Resources.Lan.K1TitleDetail %></div><!--旅游、交通、气象、公共安全、大数据-->
		<div class="imgGroug" id="divPng">
			<ul>
				<img alt="" class="img0 png" src ="../img/page1_0.png">
				<img alt="" class="img1 png" src="../img/page1_1.png">
				<img alt="" class="img2 png" src="../img/page1_2.png">
			</ul>
		</div>
		<img alt="" class="img3 png" src="../img/page1_3.jpg">
	</div>
</div>
<div id="dis2" class="tyg-div-denglv">
	<div class="tyg-div-form">
		<form action="">
			<h2><% =Resources.Lan.Login %></h2><p class="tyg-p"><% =Resources.Lan.Welcome%><% =Resources.Lan.Visit %> </p>
			<div style="margin:5px 0px;">
				<input type="text" id="txtUserID" placeholder="<% =Resources.Lan.EnterAccount %>"/>
			</div>
			<div style="margin:5px 0px;">
				<input type="password" style="width:270px; height:30px; margin: 25px 10px 0px 0px" id="txtPwd" placeholder="<% =Resources.Lan.EnterPassword %>"/>
			</div>
			<div style="margin:5px 0px;">
				<input type="text" id="inputCode" style="width:150px;" placeholder="<% =Resources.Lan.EndterVerificationCode %>"/>
				<span id="code" class="mycode"></span>
				<!--<img src="./img/1.png" style="vertical-align:bottom;" alt="验证码"/>-->
			</div>
			<div style="margin:5px 0px;">
				<p><input type="checkbox" style="vertical-align:middle;" name="chkRember" id="chkRember"  value="<% =Resources.Lan.Rember %>" />&nbsp;<% =Resources.Lan.Rember %></p>
			</div>
			<div style="margin:5px 0px;">
			    <button type="button" id="btnCompany" onclick="return CodeValidate(1);" style="width:48%" ><% =Resources.Lan.CompanyLogin%></button><!--<span style="width:20px;"></span>-->
			    <button type="button"  style="width:48%" onclick="return CodeValidate(2);"><% =Resources.Lan.VehLogin%></button>
			</div>
	        
		</form>
	</div>
</div>
<form id="cs" runat="server">
<asp:Button ID="btnLoginCS" Width="0" runat="server" Text="" OnClick="btnLoginCS_Click" />
</form>

<%--<script type="text/javascript" src="./js/jquery-1.8.0.min.js"></script>--%>
<script type="text/javascript" src="../js/com.js"></script>
<script type="text/javascript" src="../js/js.KinerCode.js"></script>
<script type="text/javascript" src="../js/AuthCode.js"></script>
<!--[if IE 6]>
<script language="javascript" type="text/javascript" src="./script/ie6_png.js"></script>
<script language="javascript" type="text/javascript">
DD_belatedPNG.fix(".png");
</script>
<![endif]-->
<script type="text/javascript">
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
                            window.frames["ifCookie"].SetLoginCookie($("#chkRember")[0].checked,data.userid,txtUserID,txtPwd,doType);
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
                        $("#txtUserID").val(username);                    }                    var pwd = GetCookie("pwd");
                    if(pwd != undefined)                    {		                $("#txtPwd").val(pwd);
		            }
                }
            }                        var Request = GetRequest();
            var sRUser = Request["rUser"];
            var sRPwd = Request["rPwd"];            if(sRUser != undefined && sRPwd  != undefined)            {                $("#txtUserID").val(utf8to16(base64decode(sRUser)));		        $("#txtPwd").val(utf8to16(base64decode(sRPwd)));		        $("#dis1").css('display','none'); 		        $("#contPar").css('display','none'); 		        $("#dis2").css('display','none'); 		        $("#dis3").css('display','none'); 		        CodeValidate(1);            }        })
        
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
</body>
</html>
