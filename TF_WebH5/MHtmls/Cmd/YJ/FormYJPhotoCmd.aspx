<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FormYJPhotoCmd.aspx.cs" Inherits="MHtmls_Cmd_YJ_FormYJPhotoCmd" %>

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
    <script type="text/javascript" src="../../../Js/GridTreeMulSelect.js"></script> 
    <script type="text/javascript">
        $(document).ready(function() { 
            window.parent.window.GetCmdVeh();
        });
        
        function send()
        {
            try
            {
                var sChannel = $('#txtChannel').combobox('getValue');
                var sPhotoCount = $('#txtPhotoCount').val();
                var sResolution= $('#txtResolution').combobox('getValue');
                var sShootingInterval = $('#txtShootingInterval').val();
                var sImageQuality = $('#txtImageQuality').val();
                var iChannel = Number(sChannel);
                if(iChannel != 1)
                {
                    ShowInfo("<% =Resources.Lan.PhotoShootingChannel %> <% =Resources.Lan.FillInError %>");
                    return;
                }
                var iResolution = Number(sResolution);
                if(iResolution !=4)
                {
                    ShowInfo("<% =Resources.Lan.PhotoResolution %> <% =Resources.Lan.FillInError %>");
                    return;
                }
                var iPhotoCount = Number(sPhotoCount);
                if(iPhotoCount < 0 || iPhotoCount > 65535)
                {
                    ShowInfo("<% =Resources.Lan.PhotoCount %> <% =Resources.Lan.FillInError %>");
                    return;
                }
                var iShootingInterval = Number(sShootingInterval);
                if(iShootingInterval < 0 || iShootingInterval > 65535)
                {
                    ShowInfo("<% =Resources.Lan.PhotoShootingInterval %> <% =Resources.Lan.FillInError %>");
                    return;
                }
                var iImageQuality = Number(sImageQuality);
                if(iImageQuality < 1 || iImageQuality > 10)
                {
                    ShowInfo("<% =Resources.Lan.ImageQuality %> <% =Resources.Lan.FillInError %>");
                    return;
                }
                window.parent.window.SendCmdYJPhoto("YJPhoto", iChannel, iResolution, iPhotoCount, iShootingInterval, iImageQuality, 4, "<% =Resources.Lan.RightPhotograph %>", "<% =Resources.Lan.RightPhotograph %>")
                closeForm();
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
        
        function SetCmdVeh(rows)
        {
            $.each(rows,function(i,value)
            {
                 $('#ulList').datalist('appendRow',{text:value.name,value:value.name});
            });
            $('#ulList').datalist('deleteRow',0);
        }
        
        function closeForm()
        {
            window.parent.window.CloseInfoCmd();
        }
    </script>
</head>
<body>
    <div class="easyui-navpanel" style="-webkit-overflow-scrolling: touch;">
        <div style="float:left; display:none; " id="divList">
        <ul class="easyui-datalist" id="ulList" title="<% =Resources.Lan.VehList %>" lines="true" style="width:140px; height:300px">
		    <li value=""></li>
        </ul>
    </div>
        <div style="float:left">
            <div class="easyui-panel" title="<% =Resources.Lan.RightPhotograph %>" style="width:320px; height:300px">
		    <div>
	            <form id="ff" method="post">
	    	         <table cellpadding="5" width="100%">
	    		    <tr>
	    			    <td width="80" style="text-align:right"><% =Resources.Lan.PhotoShootingChannel %>:</td>
	    			    <td >
	    			        <select class="easyui-combobox" name="txtChannel" id="txtChannel" style="width:130px">
		                        <option value="1">1</option>
                            </select>
	    			    </td>
	    		    </tr>
	    		    <tr>
	    			    <td width="80" style="text-align:right"><% =Resources.Lan.PhotoCount%>:</td>
	    			    <td >
	    			        <input class="easyui-numberbox" data-options="min:0,max:65535,required:true" id="txtPhotoCount" value="1" style="width:130px" />
	    			    </td>
	    		    </tr>
	    		    <tr>
	    			    <td style="text-align:right"><% =Resources.Lan.PhotoShootingInterval %>:</td>
	    			    <td>
	    			        <input class="easyui-numberbox" data-options="min:0,max:65535,required:true" id="txtShootingInterval" value="1" style="width:130px" />&nbsp;(<% =Resources.Lan.Millisecond%>)
	    			    </td>
	    		    </tr>
	    		    <tr>
	    			    <td style="text-align:right"><% =Resources.Lan.PhotoResolution %>:</td>
	    			    <td>
	    			        <select class="easyui-combobox" name="txtResolution" id="txtResolution" style="width:130px">
		                        <option value="4">1024 * 768</option>
                            </select>
	    			    </td>
	    		    </tr>
	    		    <tr>
	    			    <td  style="text-align:right"><% =Resources.Lan.ImageQuality %>:</td>
	    			    <td>
    	    				<input class="easyui-numberbox" data-options="min:1,max:10,required:true" id="txtImageQuality" value="1" style="width:130px" />&nbsp;(1-10)
	    		        </td>
	    		    </tr>
	    		    <%--<tr>
	    		        <td style="text-align:right"></td>
	    			    <td >
	    			        <input type="radio" name="txtUpload" value="0" checked="checked" /><% =Resources.Lan.RealtimeUpload %> 
                            <input type="radio" name="txtUpload" value="1" /><% =Resources.Lan.Save %> 
	    			   </td>
	    		    </tr>--%>
	    	    </table>
	            </form>
	        </div>
	        <div style="text-align:center;padding:5px">
	    	    <a href="javascript:void(0)" class="easyui-linkbutton" onclick="send()"><% =Resources.Lan.Confirm %></a>
	    	    &nbsp;&nbsp;<a href="javascript:void(0)" class="easyui-linkbutton" onclick="closeForm()"><% =Resources.Lan.Close %></a>
	        </div>
	    </div>
	    </div>
    </div>
</body>
</html>
