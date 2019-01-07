<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FormTimeComesBack.aspx.cs" Inherits="MHtmls_Cmd_K1_FormTimeComesBack" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title><% =Resources.Lan.TimingTimeComesBack %></title>
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
                var sText = $.trim($('#txtInterval').val());
                var iSecond = Number(sText);
                if(iSecond < 2 || iSecond > 65535)
                {
                    ShowInfo("<% =Resources.Lan.Interval %> <% =Resources.Lan.FillInError %>");
                    return;
                }
                var sTimes = $.trim($('#txtTimes').val());
                var iTimes = Number(sTimes);
                if(iTimes < 1 || iTimes > 65535)
                {
                    ShowInfo("<% =Resources.Lan.Interval %> <% =Resources.Lan.FillInError %>");
                    return;
                }
                window.parent.window.SendCmdText("TimeComesBack",sText + "," + sTimes, 5, "<% =Resources.Lan.TimingTimeComesBack %>", "<% =Resources.Lan.TimingTimeComesBack %>")
                closeForm();
            }
            catch(e)
            {
                ShowInfo(e.message);
            }
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
        function ShowInfo(info)
        {
            $.messager.alert('<% =Resources.Lan.Tip %>',info,'info');
        }
    </script>
</head>
<body>
    <div class="easyui-navpanel" style="-webkit-overflow-scrolling: touch;">
        <div style="float:left; height:100%; display:none;" id="divList">
        <ul class="easyui-datalist" id="ulList" title="<% =Resources.Lan.VehList %>" lines="true" style="width:140px; height:300px">
		    <li value=""></li>
        </ul>
    </div>
        <div style="float:left">
        <div class="easyui-panel" title="<% =Resources.Lan.TimingTimeComesBack %>" style="width:280px; height:300px">
		    <div>
	            <form id="ff" method="post">
	    	         <table cellpadding="5" width="100%">
	    		    <tr>
	    			    <td width="80"></td>
	    			    <td ></td>
	    		    </tr>
	    		    <tr>
	    			    <td></td>
	    			    <td><% =Resources.Lan.Range %>：2-65535&nbsp;<% =Resources.Lan.Second %></td>
	    		    </tr>
	    		    <tr>
	    			    <td style="text-align:right"><% =Resources.Lan.Interval %>:</td>
	    			    <td><input style="width:80px" class="easyui-textbox" type="text" id="txtInterval" value="30" name="txtInterval" />&nbsp;<% =Resources.Lan.Second %></td>
	    		    </tr>
	    		    <tr>
	    			    <td></td>
	    			    <td><% =Resources.Lan.Range %>：1-65535&nbsp;<% =Resources.Lan.Times %></td>
	    		    </tr>
	    		    <tr>
	    			    <td style="text-align:right"><% =Resources.Lan.Interval %>:</td>
	    			    <td><input style="width:80px" class="easyui-textbox" type="text" id="txtTimes" value="1" name="txtTimes" />&nbsp;<% =Resources.Lan.Times %></td>
	    		    </tr>
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
