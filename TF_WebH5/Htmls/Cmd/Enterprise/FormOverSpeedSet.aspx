<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FormOverSpeedSet.aspx.cs" Inherits="Htmls_Cmd_Enterprise_FormOverSpeedSet" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title><% =Resources.Lan.OverSpeedSetting %></title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="../../../Css/index.css" rel="stylesheet" type="text/css" />
	<link rel="stylesheet" type="text/css" href="../../../EasyUI/themes/default/easyui.css" />
    <link rel="stylesheet" type="text/css" href="../../../EasyUI/themes/color.css" />
    <link rel="stylesheet" type="text/css" href="../../../EasyUI/themes/icon.css" />  
    <script type="text/javascript" src="../../../EasyUI/jquery.min.js"></script>  
    <script type="text/javascript" src="../../../EasyUI/jquery.easyui.min.js"></script> 
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
                var sMaxSpeed = $.trim($('#txtMaxSpeed').val());
                var iMaxSpeed = Number(sMaxSpeed);
                if(iMaxSpeed < 0 || iMaxSpeed > 255)
                {
                    ShowInfo("<% =Resources.Lan.MaxSpeed %> <% =Resources.Lan.FillInError %>");
                    return;
                }
                window.parent.window.SendCmdText("OverSpeed",sMaxSpeed, 1, "<% =Resources.Lan.OverSpeedSetting %>", "<% =Resources.Lan.OverSpeedSetting %>")
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
    <div style="float:left; height:100%" id="divList">
        <ul class="easyui-datalist" id="ulList" title="<% =Resources.Lan.VehList %>" lines="true" style="width:140px; height:300px">
		    <li value=""></li>
        </ul>
    </div>
    <div style="float:left">
        <div class="easyui-panel" title="<% =Resources.Lan.OverSpeedSetting %>" style="width:280px; height:300px">
		    <div>
	            <form id="ff" method="post">
	    	         <table cellpadding="5" width="100%">
	    		    <tr>
	    			    <td width="80"></td>
	    			    <td ></td>
	    		    </tr>
	    		    <tr>
	    			    <td></td>
	    			    <td></td>
	    		    </tr>
	    		    <tr>
	    			    <td style="text-align:right"><% =Resources.Lan.MaxSpeed %>:</td>
	    			    <td><input style="width:80px" class="easyui-textbox" type="text" id="txtMaxSpeed" value="80" name="txtMaxSpeed" />&nbsp;<% =Resources.Lan.KmHour %></td>
	    		    </tr>
	    		    <tr>
	    			    <td></td>
	    			    <td></td>
	    		    </tr>
	    		    <tr>
	    			    <td></td>
	    			    <td>
    	    				
	    		        </td>
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
</body>
</html>
