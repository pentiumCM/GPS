<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Test.aspx.cs" Inherits="Mobile_Test" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title><% =Resources.Lan.Title %></title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />	
    <%--<link href="../Css/index.css" rel="stylesheet" type="text/css" />--%>
	<link rel="stylesheet" type="text/css" href="../EasyUI/themes/metro/easyui.css" />
    <link rel="stylesheet" type="text/css" href="../EasyUI/themes/mobile.css" />
    <link rel="stylesheet" type="text/css" href="../EasyUI/themes/color.css" />
    <%--<link rel="stylesheet" type="text/css" href="../EasyUI/themes/icon.css" />--%>  
    <script type="text/javascript" src="../EasyUI/jquery.min.js"></script>  
    <script type="text/javascript" src="../EasyUI/jquery.easyui.min.js"></script> 
    <script type="text/javascript" src="../EasyUI/jquery.easyui.mobile.js"></script>
    <script type="text/javascript" src="../Js/GenerageGuid.js"></script> 
    <script type="text/javascript" src="../Js/JsCookies.js"></script>  
    <script type="text/javascript" src="../Js/GridTreeMulSelect.js"></script> 
    
</head>
<body >
    <%--顶层--%>
    <div class="easyui-navpanel" >
            <div id="divSeartch"  class="m-leftNoHeight"><!--m-rightbottom-->
					<a href="javascript:void(0)" class="easyui-menubutton" data-options="iconCls:'icon-onlineVeh',menu:'#mm',menuAlign:'right',hasDownArrow:false"></a>
						        </div>	        <div title="<% =Resources.Lan.BaiduMap  %>" style="overflow:hidden; float:left" id="home">
			            <iframe name="mapmainFrame" frameborder="0"  src="../Htmls/FormBaiduMap.aspx" style="width:100%;height:100%;"></iframe>
            	        
		            </div>	
            <footer style="padding:2px 3px">
                <div id="divState" style="width:100%;height:32px;font-weight: bold;"></div>
            </footer>
	</div>
    <%--导航菜单--%>
     <div id="p2" class="easyui-navpanel">
            4444
     </div>
     <%--内容--%>
     <div id="p3" class="easyui-navpanel">
        2
     </div>
    
    <div id="mm" class="easyui-menu" style="width:150px;">
		<div id="mm-tabclose"><% =Resources.Lan.Close %></div>
		<div id="mm-tabcloseall"><% =Resources.Lan.CloseAll %></div>
		<div id="mm-tabcloseother"><% =Resources.Lan.ClosedAllButThis %></div>
		<div class="menu-sep"></div>
		<div id="mm-tabcloseright"><% =Resources.Lan.ClosedRightSide %></div>
		<div id="mm-tabcloseleft"><% =Resources.Lan.ClosedLeftSide %></div>
		<div class="menu-sep"></div>
		<div id="mm-exit"><% =Resources.Lan.Exit %></div>
	</div>	
</body>
</html>
