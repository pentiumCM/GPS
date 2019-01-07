<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FormGBPhotoList.aspx.cs" Inherits="MHtmls_Cmd_GB_FormGBPhotoList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title><% =Resources.Lan.RightPhotograph %></title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="../../../Css/index.css" rel="stylesheet" type="text/css" />
	<link rel="stylesheet" type="text/css" href="../../../EasyUI/themes/metro/easyui.css" />    <link rel="stylesheet" type="text/css" href="../../../EasyUI/themes/mobile.css" />
    <link rel="stylesheet" type="text/css" href="../../../EasyUI/themes/color.css" />
    <link rel="stylesheet" type="text/css" href="../../../EasyUI/themes/icon.css" />  
    <script type="text/javascript" src="../../../EasyUI/jquery.min.js"></script>  
    <script type="text/javascript" src="../../../EasyUI/jquery.easyui.min.js"></script> 
    <script type="text/javascript" src="../../../EasyUI/jquery.easyui.mobile.js"></script>
    <script type="text/javascript" src="../../../Js/GenerageGuid.js"></script> 
    <script type="text/javascript" src="../../../Js/JsCookies.js"></script>  

    <script type="text/javascript">
        var iTry = 0;
        $(document).ready(function() { 
            
        });      
        
        
        function Zoom(img)
        {            $.mobile.go('#divDetail');
            $('#imgZoom').attr("src",img.src);
//            window.parent.window.OpenInfoPhoto('<img alt="" src = "' + img.src + '" width="800px" height="480px" />');
        }
        
        function SetSrc(sUrl)
        {
            try
            {
                $("#panelPic").prepend('<img alt="" ondblclick="Zoom(this)" src = "../../../' + sUrl + '" width="200px" height="200px"  style="padding:3px" />');
            }
            catch(e)
            {
                ShowInfo(e.message);
            }
        }       
        
       function ShowInfo(info)
       {
           $.messager.alert('<% =Resources.Lan.Tip %>',info,'info');
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
        
        function closeForm()
        {
            window.parent.window.CloseInfoCmd();
        }
        
        function OpenInfoPhoto(info)
        {
            $("#dlgInfoPhoto").html("<p>" + info + "</p>");
            $("#dlgPhoto").dialog('open').dialog('center');
        }
    </script>
</head>
<body>
    <div class="easyui-navpanel"  id="divData" style="-webkit-overflow-scrolling: touch;">
        <div id="panelPic" class="easyui-panel" data-options="fit:true,iconCls:'icon-photo',tools:'#tt'" title="<% =Resources.Lan.RightPhotograph %>" style="width:100%; height:100%">
    	    
	    </div>
        <div id="tt">
		    <a href="javascript:void(0)" class="icon-add" onclick="javascript:window.parent.window.TaskPic('#G1602',2)"></a>
	    </div>  
    </div>
    <%--图片放大--%>
    <div class="easyui-navpanel" id="divDetail" style="-webkit-overflow-scrolling: touch;">
        <header>
            <div class="m-toolbar">
                <div class="m-left">
                    <a href="#;" onclick="$.mobile.go('#divData');" class="easyui-linkbutton m-back" plain="true" outline="true"><% =Resources.Lan.Back %></a>
                </div>
            </div>
        </header>
        <img id="imgZoom" title="" alt=""  src="" width="99%" height="80%" />
    </div>
    <div id="dlgPhoto" class="easyui-dialog" style="padding:20px 6px;width:250px; height:250px;" data-options="inline:true,modal:true,closed:true,title:'<% =Resources.Lan.Prompt %>'">
		<div id="dlgInfoPhoto">This is a message dialog.</div>
		
	</div>
</body>
</html>
