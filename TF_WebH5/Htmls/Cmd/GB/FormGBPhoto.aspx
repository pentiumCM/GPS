<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FormGBPhoto.aspx.cs" Inherits="Htmls_Cmd_GB_FormGBPhoto" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title><% =Resources.Lan.RightPhotograph %></title>
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
                var sChannel = $('#txtChannel').combobox('getValue');
                var sCmd = $('#txtCmd').val();
                var sResolution= $('#txtResolution').combobox('getValue');
                var sUpload = $('#ff input[name="txtUpload"]:checked ').val();
                var sHour = $('#txtInterval').timespinner('getHours');
                var sMinute = $('#txtInterval').timespinner('getMinutes');
                var sSecond = $('#txtInterval').timespinner('getSeconds');
//                ShowInfo(sChannel + "  " + sCmd + "  " + sResolution + "  " + sUpload + "  " + sHour);
                var iSecond = Number(sHour) * 60 * 60 + Number(sMinute) * 60 + Number(sSecond);
                var iChannel = Number(sChannel);
                if(iChannel < 1 || iChannel > 5)
                {
                    ShowInfo("<% =Resources.Lan.PhotoShootingChannel %> <% =Resources.Lan.FillInError %>");
                    return;
                }
                var iResolution = Number(sResolution);
                if(iResolution < 1 || iResolution > 8)
                {
                    ShowInfo("<% =Resources.Lan.PhotoResolution %> <% =Resources.Lan.FillInError %>");
                    return;
                }
                var iCmd = Number(sCmd);
                if(iCmd < 0 || iCmd > 65535)
                {
                    ShowInfo("<% =Resources.Lan.PhotoShootingCommand %> <% =Resources.Lan.FillInError %>");
                    return;
                }
                window.parent.window.SendCmdGbPhoto("GBPhoto", iChannel, iResolution, iCmd, iSecond, sUpload, 2, "<% =Resources.Lan.RightPhotograph %>", "<% =Resources.Lan.RightPhotograph %>")
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
    <div style="float:left; height:100%" id="divList">
        <ul class="easyui-datalist" id="ulList" title="<% =Resources.Lan.VehList %>" lines="true" style="width:140px; height:300px">
		    <li value=""></li>
        </ul>
    </div>
    <div style="float:left">
        <div class="easyui-panel" title="<% =Resources.Lan.RightPhotograph %>" style="width:280px; height:300px">
		    <div>
	            <form id="ff" method="post">
	    	         <table cellpadding="5" width="100%">
	    		    <tr>
	    			    <td width="80" style="text-align:right"><% =Resources.Lan.PhotoShootingChannel %>:</td>
	    			    <td >
	    			        <select class="easyui-combobox" name="txtChannel" id="txtChannel" style="width:130px">
		                        <option value="1">1</option>
		                        <option value="2">2</option>
		                        <option value="3">3</option>
		                        <option value="4">4</option>                            </select>
	    			    </td>
	    		    </tr>
	    		    <tr>
	    			    <td style="text-align:right"><% =Resources.Lan.PhotoShootingCommand %>:</td>
	    			    <td>
	    			        <input class="easyui-numberbox" data-options="min:0,max:65535,required:true" id="txtCmd" value="1" style="width:130px" />	    			    </td>
	    		    </tr>
	    		    <tr>
	    			    <td style="text-align:right"><% =Resources.Lan.PhotoResolution %>:</td>
	    			    <td>
	    			        <select class="easyui-combobox" name="txtResolution" id="txtResolution" style="width:130px">
		                        <option value="1">320 * 240</option>
		                        <option value="2">640 * 480</option>
		                        <option value="3">800 * 600</option>
		                        <option value="4">1024 * 768</option>
		                        <option value="5">176 * 144 (QCIF)</option>
		                        <option value="6">352 * 288 (CIF)</option>
		                        <option value="7">704 * 288 (HALF D1)</option>
		                        <option value="8">704 * 576 (D1)</option>                            </select>
	    			    </td>
	    		    </tr>
	    		    <tr>
	    			    <td  style="text-align:right"><% =Resources.Lan.PhotoShootingInterval %>:</td>
	    			    <td>
    	    				<input id="txtInterval" class="easyui-timespinner" data-options="min:'00:00:00',max:'23:59:59',showSeconds:true" value="00:00:00" style="width:130px;" />
	    		        </td>
	    		    </tr>
	    		    <tr>
	    		        <td style="text-align:right"></td>
	    			    <td >
	    			        <input type="radio" name="txtUpload" value="0" checked="checked" /><% =Resources.Lan.RealtimeUpload %> 
                            <input type="radio" name="txtUpload" value="1" /><% =Resources.Lan.Save %> 
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
