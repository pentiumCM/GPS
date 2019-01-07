<%@ Page Language="C#" AutoEventWireup="true" CodeFile="User.aspx.cs" Inherits="mng_Forms_User" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="renderer" content="webkit"> 
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title> <% =Resources.Lan.UserMng %></title>
    <link href="../../Css/index.css" rel="stylesheet" type="text/css" />
    <%--<link rel="stylesheet" type="text/css" href="../../css/style2.0.css" />--%>
	<link rel="stylesheet" type="text/css" href="../../EasyUI/themes/default/easyui.css">
    <link rel="stylesheet" type="text/css" href="../../EasyUI/themes/color.css" />
    <link rel="stylesheet" type="text/css" href="../../EasyUI/themes/icon.css" />  
    <script type="text/javascript" src="../../js/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="../../Js/JsCookies.js"></script> 
    <script type="text/javascript" src="../../Js/JsBase64.js"></script>  
    <script type="text/javascript" src="../../EasyUI/jquery.easyui.min.js"></script>  
    <script type="text/javascript" src="../../Js/AutoComplete.js"></script> 
    <style type="text/css">
        html,body{

        width:100%; 

        height:100%;

        }  

        body {
        margin-left: 0px;
        margin-top: 0px;
        margin-right: 0px;
        margin-bottom: 0px;
        }
    </style>
</head>
<body>
    <div id="DivAutoComplete" class="panel combo-p" style="z-index: 110003; position: absolute; display: none; height: 300px; ">
    </div>
    <table style="height:100%; width:100%;">
        <tr style="height:32px; ">
            <td style="text-align:left; background-color:White;" colspan="5">
                &nbsp;&nbsp;<a href="#;" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="return Save();"><% =Resources.Lan.Save %></a>
            </td>         
        </tr>
        <tr style="height:32px;">
            <td style="width:120px; text-align:right;"><% =Resources.Lan.UserName %><font color="red">*</font>：</td>
            <td style="width:300px;"><input id="txtName" class="easyui-textbox" style="width:290px;"></td>
            <td style="text-align:left; width:350px;" >
                <% =Resources.Lan.QuicklyLocateTheTeam %>：
                <input id="txtVeh" style="width:275px;" name = "txtVeh" type="text" value="" />
            </td>       
            <td></td>     
            <td></td>
        </tr>
        <tr style="height:32px;">
            <td style="width:120px; text-align:right;"><% =Resources.Lan.Password %><font color="red">*</font>：</td>
            <td style="width:300px;"><input id="txtPassword" class="easyui-textbox" style="width:290px;"></td>
            <td style="vertical-align:top;" colspan="3" rowspan="7">
                <table id="tgVeh" class="easyui-treegrid" style=" float:left; height:99%; width:99%" 
		            data-options="
		                method: 'get',
		                lines: false,
		                rownumbers: false,
		                idField: 'id',
		                treeField: 'name',
		                singleSelect: true
		            ">
		            <thead>
		                <tr>
		                    <th data-options="field:'name'" formatter="formatVehcheckbox" width="350px"><% =Resources.Lan.Team %></th>
    		                
		                </tr>
		            </thead>
	            </table>
            </td>
        </tr>
        <tr style="height:32px;">
            <td style="width:120px; text-align:right;"><% =Resources.Lan.CompanyName %>：</td>
            <td style="width:300px;"><input id="txtCompanyName" class="easyui-textbox" style="width:290px;"></td>
        </tr>
        <tr style="height:32px;">
            <td style="width:120px; text-align:right;"><% =Resources.Lan.VehTel %>：</td>
            <td style="width:300px;"><input id="txtTel" class="easyui-textbox" style="width:290px;"></td>
        </tr>
        <tr style="height:32px;">
            <td style="width:120px; text-align:right; vertical-align:top;"><% =Resources.Lan.AccountType %>：</td>
            <td style="width:300px; vertical-align:top;">
                <select class="easyui-combobox" name="txtAccountType" id="txtAccountType" style="width:290px;" data-options="valueField: 'label',textField: 'value'">
		             <option value="2"><% =Resources.Lan.DataOperator %></option>		             <option value="3"><% =Resources.Lan.Monitoring %></option>                 </select>
            </td>
        </tr>
        <tr style="height:32px;">
            <td style="width:120px; text-align:right; vertical-align:top;"><% =Resources.Lan.UserGroup %>：</td>
            <td style="width:300px; vertical-align:top;">
                <select class="easyui-combobox" name="txtUserGroup" id="txtUserGroup" style="width:290px;" data-options="valueField: 'label',textField: 'value'">
		        </select>
            </td>
        </tr>
        <tr style="height:32px;">
            <td style="width:120px; text-align:right; vertical-align:top;"><% =Resources.Lan.ExpirationTime %>：</td>
            <td style="width:300px; vertical-align:top;">
                <input id="txtExpirationTime"  editable="false" class="easyui-datetimebox" style="width:149px;" name="txtExpirationTime" data-options="formatter:formatter1,parser:parser1,showSeconds:true"  value="2016-04-02 23:59:59"/>
            </td>
        </tr>
        <tr >
            <td style="width:120px; text-align:right; vertical-align:top;"><% =Resources.Lan.PermissionsDetail %>：</td>
            <td style="width:300px; vertical-align:top;">
                <table id="tgPermission" class="easyui-treegrid" style=" float:left; height:99%; width:290px" 
		            data-options="
		                method: 'get',
		                lines: false,
		                rownumbers: false,
		                idField: 'id',
		                treeField: 'name',
		                singleSelect: true
		            ">
		            <thead>
		                <tr>
		                    <th data-options="field:'name'" formatter="formatPermissioncheckbox" width="280px"><% =Resources.Lan.PermissionsDetail %></th>
    		                
		                </tr>
		            </thead>
	            </table>
            </td>
        </tr>
    </table>

<script type="text/javascript">
    var arrErr = new Array();
    arrErr.push({ "key": "4001","value":"<% =Resources.Lan.EnterAccountAndPassword %>"});
    arrErr.push({ "key": "4002","value":"<% =Resources.Lan.NotEnterIllegalCharacters %>"});
    arrErr.push({ "key": "4004","value":"<% =Resources.Lan.AccountNotExist %>"});
    arrErr.push({ "key": "4005","value":"<% =Resources.Lan.AccountOverdue %>"});
    arrErr.push({ "key": "4006","value":"<% =Resources.Lan.UnknownError %>"});
    arrErr.push({ "key": "4008","value":"<% =Resources.Lan.HasSameName %>"});
    arrErr.push({ "key": "4009","value":"<% =Resources.Lan.NotExistsVehicleGroup %>"});
    arrErr.push({ "key": "4010","value":"<% =Resources.Lan.EditFailureSelfTteam %>"});
    arrErr.push({ "key": "4011","value":"<% =Resources.Lan.AddFailureExistsMotorcade %>"});
    arrErr.push({ "key": "4012","value":"<% =Resources.Lan.ParameterError %>"});
    arrErr.push({ "key": "4015","value":"<% =Resources.Lan.PermissionDenied %>"});

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
    
    function Save(){
		    $("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: "100%", zIndex: 99999 }).appendTo("body");  
            $("<div class=\"datagrid-mask-msg\"></div>").html("<% =Resources.Lan.Loding %>").appendTo("body").css({ display: "block", left: ($(document.body).outerWidth(true) - 190) / 2, top: ($(window).height() - 45) / 2 });  
		    if(!AntiSqlValid($("#txtName")[0]))
		    {
		        $(".datagrid-mask").remove();  
                $(".datagrid-mask-msg").remove(); 
                OpenInfo("<% =Resources.Lan.NotEnterIllegalCharacters %>");
                return false;
		    }
		    if(!AntiSqlValid($("#txtPassword")[0]))
		    {
		        $(".datagrid-mask").remove();  
                $(".datagrid-mask-msg").remove(); 
                OpenInfo("<% =Resources.Lan.NotEnterIllegalCharacters %>");
                return false;
		    }
		    if(!AntiSqlValid($("#txtCompanyName")[0]))
		    {
		        $(".datagrid-mask").remove();  
                $(".datagrid-mask-msg").remove(); 
                OpenInfo("<% =Resources.Lan.NotEnterIllegalCharacters %>");
                return false;
		    }
		    if(!AntiSqlValid($("#txtTel")[0]))
		    {
		        $(".datagrid-mask").remove();  
                $(".datagrid-mask-msg").remove(); 
                OpenInfo("<% =Resources.Lan.NotEnterIllegalCharacters %>");
                return false;
		    }
		    var sName = $("#txtName").val();
		    var sPassword = $("#txtPassword").val();
		    var sTel = $("#txtTel").val();
		    var sCompanyName = $("#txtCompanyName").val();
		    var sAccountType = $('#txtAccountType').combobox('getValue');
		    var sUserGroup = $('#txtUserGroup').combobox('getValue');
		    var sExpirationTime = $('#txtExpirationTime').datetimebox('getValue');
		    var pGroupID = "";
		    $("input[id^='check_G']:checked").each(function(){
		        var bGroupExists = false;
		        var thisIDTemp = this.id.substring(6);
		        $.each(jsonVehGroup,function(i,value){
		            if(value.id == thisIDTemp)
		            {
		                if(value.PID != 'G-1')
		                {
		                    bGroupExists = $(('#check_' + value.PID))[0].checked;
		                }
		                return false;
		            }
		        });
		        if(bGroupExists)
		        {
		            
		        }
		        else
		        {
		            if(pGroupID.length == 0)
		            {
		                pGroupID = this.id.substring(7);
		            }
		            else
		            {
		                pGroupID = pGroupID + ',' + this.id.substring(7);
		            }
		        }
		    });
		    
		    var arrPermissionTemp = new Array();
		    $("input[id^='check_C']:checked").each(function(){		        
//		        if(sPermissionTemp.length == 0)
//		        {
//		            sPermissionTemp = this.id.substring(7);
//		        }
//		        else
//		        {
//		            sPermissionTemp = sPermissionTemp + ',' + this.id.substring(7);
//		        }
                arrPermissionTemp.push(this.id.substring(7));
                var thiscontrol = $("#tgPermission").treegrid('find',this.id.substring(6));
		        var pPermissionID = thiscontrol.pid;
		        if(typeof(pPermissionID)=="undefined")
		        {
		        
		        }
		        else
		        {
		            if(true)
		            {
		                if(pPermissionID != 'N')
		                {
		                    var sTemp2 = pPermissionID.substring(1);
		                    var arrTemp2 = sTemp2.split('_');
		                    for(var i = 0; i < arrTemp2.length; i++)
		                    {
		                        var bExists = false;
		                        for(var j = 0; j < arrPermissionTemp.length; j++)
		                        {
		                            if(arrPermissionTemp[j] == arrTemp2[i])
		                            {
		                                bExists = true;
		                                break;
		                            }
		                        }    
		                        if(bExists)
		                        {
    		                    
		                        }
		                        else
		                        {
		                            arrPermissionTemp.push(arrTemp2[i]);
		                        }
		                    }
		                }
		                var control = $("#tgPermission").treegrid('find',thiscontrol._parentId);
		                if(typeof(control) != "undefined" && typeof(control.pid) == "undefined")
		                {
		                    var sTemp = control.id.substring(1);
		                    var arrTemp = sTemp.split('_');
		                     for(var i = 0; i < arrTemp.length; i++)
		                    {
		                        var bExists = false;
		                        for(var j = 0; j < arrPermissionTemp.length; j++)
		                        {
		                            if(arrPermissionTemp[j] == arrTemp[i])
		                            {
		                                bExists = true;
		                                break;
		                            }
		                        }    
		                        if(bExists)
		                        {
    		                    
		                        }
		                        else
		                        {
		                            arrPermissionTemp.push(arrTemp[i]);
		                        }
		                    }
		                }
		                var bLast = false;
		                while(typeof(control) != "undefined" && typeof(control.pid) != "undefined")
		                {
		                    var sLastPid = control._parentId;
		                    var sTemp = sLastPid.substring(1);
		                    var arrTemp = sTemp.split('_');
		                    var sPP = control.pid;//.substring(1).split('_');
		                    if(sPP != 'N')
		                    {
		                        var sTemp3 = sPP.substring(1);
		                        var arrTemp3 = sTemp3.split('_');
		                        for(var i = 0; i < arrTemp3.length; i++)
		                        {
		                            var bExists = false;
		                            for(var j = 0; j < arrPermissionTemp.length; j++)
		                            {
		                                if(arrPermissionTemp[j] == arrTemp3[i])
		                                {
		                                    bExists = true;
		                                    break;
		                                }
		                            }    
		                            if(bExists)
		                            {
        		                    
		                            }
		                            else
		                            {
		                                arrPermissionTemp.push(arrTemp3[i]);
		                            }
		                        }
		                    }
		                    
		                    control =   $("#tgPermission").treegrid('find',control._parentId);
		                    bLast = true;
		                    for(var i = 0; i < arrTemp.length; i++)
		                    {
		                        var bExists = false;
		                        for(var j = 0; j < arrPermissionTemp.length; j++)
		                        {
		                            if(arrPermissionTemp[j] == arrTemp[i])
		                            {
		                                bExists = true;
		                                break;
		                            }
		                        }    
		                        if(bExists)
		                        {
    		                    
		                        }
		                        else
		                        {
		                            arrPermissionTemp.push(arrTemp[i]);
		                        }
		                    }
		                }
		                if(bLast)
		                {
		                    var sTemp = control.id.substring(1);
		                    var arrTemp = sTemp.split('_');
		                    for(var i = 0; i < arrTemp.length; i++)
		                    {
		                        var bExists = false;
		                        for(var j = 0; j < arrPermissionTemp.length; j++)
		                        {
		                            if(arrPermissionTemp[j] == arrTemp[i])
		                            {
		                                bExists = true;
		                                break;
		                            }
		                        }    
		                        if(bExists)
		                        {
    		                    
		                        }
		                        else
		                        {
		                            arrPermissionTemp.push(arrTemp[i]);
		                        }
		                    }
		                }
		            }
		        } 
		    });
		    var sPermissionTemp = "";
		    $.each(arrPermissionTemp,function(i,value){
		        if(sPermissionTemp.length == 0)
		        {
		            sPermissionTemp = value;
		        }
		        else
		        {
		            sPermissionTemp = sPermissionTemp + "," + value;
		        }
		    });
		    var sPer = "";
		    var arrPerIni = "1,53,5006,2002,2003,14,1418,13,1308,1312,1307,1302,1303,4,20,1601,50,5001,1602,2,201,202,204,5004,5005,406,65".split(',');
		    $.each(sOldPermission,function(i,value){
		        var bExist = false;
		        $.each(arrPerIni,function(j,valuej){
		            if(value == valuej)
		            {
		                bExist = true;
		                return false;
		            }
		        });
		        if(bExist)
		        {
		        
		        }
		        else
		        {
		            if(sPer.length == 0)
		            {
		                sPer = value;
		            }
		            else
		            {
		                sPer = sPer + "," + value;
		            }
		        }
		    });
		    if(sPer.length > 0)
		    {
		        sPer = sPer + "," + sPermissionTemp;
		    }
		    else
		    {
		        sPer = sPermissionTemp;
		    }
		    if(sName.length == 0)
		    {
		        $(".datagrid-mask").remove();  
                $(".datagrid-mask-msg").remove(); 
                OpenInfo("<% =Resources.Lan.UserName %>,<% =Resources.Lan.NoEmpty %>");
                return false;
		    }
		    if(sPassword.length == 0)
		    {
		        $(".datagrid-mask").remove();  
                $(".datagrid-mask-msg").remove(); 
                OpenInfo("<% =Resources.Lan.Password %>,<% =Resources.Lan.NoEmpty %>");
                return false;
		    }
		    var sUserName = GetCookie("m_username");
            var sPwd = GetCookie("m_pwd");
            $.ajax({
                url: "../../Ashx/MngUser.ashx",
                cache:false,
                type:"post",
                dataType:'json',
                data:{username:sUserName,Pwd:sPwd,Name:sName,NewPwd:sPassword,DoType:sDoType,ID:thisRID,UserGroupID:sUserGroup,CompanyName:sCompanyName,Tel:sTel,AccountType:sAccountType,ExpirationTime:sExpirationTime,OldName:sOldName,Permission:sPer,Groups:pGroupID},
                success:function(data){
                        if(data.result)
                        {
                            OpenInfo("<% =Resources.Lan.Successful %>");
		                    $(".datagrid-mask").remove();  
                            $(".datagrid-mask-msg").remove();
                            var sTempGroupID = "R" + data.err;
                            if(sDoType == "0")
                            {
                                sTempGroupID = "R" + thisRID;
                            } 
                            pGroupID = "U" + sUserGroup;
                            var objReturn = {"DoType":sDoType,"ID":sTempGroupID,"Name":sName,"PID":pGroupID};
                             window.parent.window.UpdateTree("User", objReturn);
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
            });
            return false;
        }
        
        function OpenInfo(info)
        {
            var data = "<div>" + info + "</div>";
//            $("#dlgInfo").html("<p>" + info + "</p>");
//            $("#dlg1").dialog('open').dialog('center');
               $.messager.alert('<% =Resources.Lan.Prompt %>',data,'question');
        }
        
        var thisRID="";
        var thisRPID = "";
        var sDoType = "1";
        var sOldName = "";
        var arrPermission = {"total":0,"rows":[]};
        var sOldPermission = new Array();
        $(document).ready(function() { 
            $('#DivAutoComplete').hide();
            $('#txtAccountType').combobox({
                editable:false
            });
            $('#txtUserGroup').combobox({
                editable:false
            });
            $('#tgPermission').parent().find(".datagrid-header").hide();    
            var now = new Date();
            $('#txtExpirationTime').datetimebox('setValue', '2099-12-31 23:59:59');
            //------------通用功能----------------------------
            //1,53,5006,14,1418,13,1308,1312,1307,1302,1303,4,20,1601,50,5001,1602,2,201,202,204,5004,5005,406,65        
            var rowPermission = {"id":'P1_53',state: '', "name":"<% =Resources.Lan.BasicFunction %>"};
            arrPermission.rows.push(rowPermission);
            rowPermission = {"id":'C5006', pid:'P53',state: '', "name":"<% =Resources.Lan.RightTrackPlayback %>", '_parentId': 'P1_53'};
            arrPermission.rows.push(rowPermission);
            rowPermission = { id: 'C1418', pid:'P14', name: '<% =Resources.Lan.FenceRegionManage %>', state: '', '_parentId': 'P1_53' };
            arrPermission.rows.push(rowPermission);
            //------------报表功能----------------------------------
            rowPermission = {"id":'P13',state: '', "name":"<% =Resources.Lan.ReportFunction %>"};
            arrPermission.rows.push(rowPermission);
            rowPermission = { id: 'C1308', pid:'N', name: '<% =Resources.Lan.ImageReport %>', state: '', '_parentId': 'P13' };
            arrPermission.rows.push(rowPermission);
            rowPermission = { id: 'C1312', pid:'N', name: '<% =Resources.Lan.MileageReport %>', state: '', '_parentId': 'P13' };
            arrPermission.rows.push(rowPermission);
            rowPermission = { id: 'C1307', pid:'N', name: '<% =Resources.Lan.ReportSpeedSift %>', state: '', '_parentId': 'P13' };
            arrPermission.rows.push(rowPermission);
            rowPermission = { id: 'C1302', pid:'N', name: '<% =Resources.Lan.ReportAcc %>', state: '', '_parentId': 'P13' };
            arrPermission.rows.push(rowPermission);
            rowPermission = { id: 'C1303', pid:'N', name: '<% =Resources.Lan.ReportAlarm %>', state: '', '_parentId': 'P13' };
            arrPermission.rows.push(rowPermission);
            //-------------终端功能---------------------------------
            rowPermission = {"id":'P20_4',state: '', "name":"<% =Resources.Lan.RightTerminalControl %>"};
            arrPermission.rows.push(rowPermission);
            rowPermission = { id: 'C1601', pid:'P16_50_5001', name: '<% =Resources.Lan.RightCallName %>', state: '', '_parentId': 'P20_4' };
            arrPermission.rows.push(rowPermission);
            rowPermission = { id: 'C2002', pid:'N', name: '<% =Resources.Lan.OilCutOff %>', state: '', '_parentId': 'P20_4' };
            arrPermission.rows.push(rowPermission);
            rowPermission = { id: 'C2003', pid:'N', name: '<% =Resources.Lan.OilOpen %>', state: '', '_parentId': 'P20_4' };
            arrPermission.rows.push(rowPermission);
            rowPermission = { id: 'C1602', pid:'P50', name: '<% =Resources.Lan.RightPhotograph %>', state: '', '_parentId': 'P20_4' };
            arrPermission.rows.push(rowPermission);
            rowPermission = { id: 'P2', name: '<% =Resources.Lan.RightTerminalSettings %>', state: '', '_parentId': 'P20_4' };
            arrPermission.rows.push(rowPermission);
            rowPermission = { id: 'C201', pid:'N', name: '<% =Resources.Lan.RightAccOnTimingInterval %>', state: '', '_parentId': 'P2' };
            arrPermission.rows.push(rowPermission);
            rowPermission = { id: 'C202', pid:'N', name: '<% =Resources.Lan.RightAccOffTimingInterval %>', state: '', '_parentId': 'P2' };
            arrPermission.rows.push(rowPermission);
            rowPermission = { id: 'C204', pid:'N', name: '<% =Resources.Lan.OverSpeedSetting %>', state: '', '_parentId': 'P2' };
            arrPermission.rows.push(rowPermission);
            rowPermission = { id: 'C2006', pid:'N', name: '<% =Resources.Lan.Shutdown %>', state: '', '_parentId': 'P20_4' };
            arrPermission.rows.push(rowPermission);
            rowPermission = { id: 'C5004', pid:'P50', name: '<% =Resources.Lan.SendSchedulingInformation %>', state: '', '_parentId': 'P2' };
            arrPermission.rows.push(rowPermission);
            rowPermission = { id: 'C5005', pid:'P50', name: '<% =Resources.Lan.OilTestingParametersSetting %>', state: '', '_parentId': 'P2' };
            arrPermission.rows.push(rowPermission);
            rowPermission = { id: 'C406', pid:'P4', name: '<% =Resources.Lan.Restart %>', state: '', '_parentId': 'P2' };
            arrPermission.rows.push(rowPermission);
            rowPermission = { id: 'C65', pid:'N', name: '<% =Resources.Lan.RealtimeVideoMonitoring %>', state: '', '_parentId': 'P2' };
            arrPermission.rows.push(rowPermission);
            
            //-------------------------------------------------------------
            $("#tgPermission").treegrid("loadData",arrPermission);
            $(('#check_C5006'))[0].checked = true;
            $(('#check_C1601'))[0].checked = true;
            $(('#check_C1312'))[0].checked = true;
            $(('#check_C1307'))[0].checked = true;
            $(('#check_C1302'))[0].checked = true;
            $(('#check_C1303'))[0].checked = true;
            
            var sUrl=location.search.toLowerCase();
            var sQuery=sUrl.substring(sUrl.indexOf("=")+1);
            re=/select|update|delete|truncate|join|union|exec|insert|drop|count|’|"|;|>|</i;
            if(re.test(sQuery))
            {
                OpenInfo("<% =Resources.Lan.NotEnterIllegalCharacters %>");
                location.href=sUrl.replace(sQuery,"");
            }
            var Request = GetRequest();
            thisRID = Request["id"];
            thisRPID = Request["pid"];
            sDoType = Request["dotype"];
            var iutype = Request["utype"];
            if(iutype == "1")
            {
                var arrAccount = new Array();
                var row = {"value":"<% =Resources.Lan.System %>","label":1};
                arrAccount.push(row);
                var row = {"value":"<% =Resources.Lan.DataOperator %>","label":2};
                arrAccount.push(row);
                var row = {"value":"<% =Resources.Lan.Monitoring %>","label":3};
                arrAccount.push(row);
                $('#txtAccountType').combobox('loadData', arrAccount);
                $('#txtAccountType').combobox('setValue', arrAccount[0].label);
            }
            var jsonUserGroup = window.parent.window.GetUserGroup();
            
            var arrUserGroup = new Array();
            $.each(jsonUserGroup,function(i,value){
                if(value.id == "M_User")
                {
                    return true;
                }
                var row = {"value":value.name,"label":value.id.substring(1)};
                arrUserGroup.push(row);
            });
            if(arrUserGroup.length > 0)
            {
                $('#txtUserGroup').combobox('loadData', arrUserGroup);
                $('#txtUserGroup').combobox('setValue', arrUserGroup[0].label);
            }
            window.parent.window.InitVehAndGroup("<% =Resources.Lan.UserMng %>");
            AutoText("txtVeh",jsonVehGroup);
            if(sDoType == "0")
            {
                GetGroupInfo();
            }
        })
        
        function GetGroupInfo()
        {
            $("input[id^='check_C']:checked").each(function(){
		        this.checked = false;
		    });
            var sUserName = GetCookie("m_username");
            var sPwd = GetCookie("m_pwd");
            $.ajax({
                url: "../../Ashx/MngUser.ashx",
                cache:false,
                type:"post",
                dataType:'json',
                data:{username:sUserName,Pwd:sPwd,Name:'1',NewPwd:'1',DoType:4,ID:thisRID,UserGroupID:'1',CompanyName:'',Tel:'',AccountType:'1',ExpirationTime:'2017-01-13 00:00:01',OldName:sOldName,Permission:'',Groups:''},
                success:function(data){
                        if(data.result)
                        {
                            $("#txtName").textbox('setValue',data.data[0].name);
                            sOldName = data.data[0].name;
                            $("#txtPassword").textbox('setValue',data.data[0].pwd);
                            $("#txtTel").textbox('setValue',data.data[0].tel);
                            $("#txtCompanyName").textbox('setValue',data.data[0].company);
                            $('#txtAccountType').combobox('setValue',data.data[0].userType);
                            $('#txtUserGroup').combobox('setValue',data.data[0].usergroup);
                            
                            sOldPermission = data.data[0].permission.split(',');
                            $.each(sOldPermission,function(i,value){
                                var findC = $(('#check_C' + value));
                                if(findC.length > 0)
                                {
                                    findC[0].checked = true;
                                    showPermissioncheck('C' + value);
                                }
                            });
                            $("#txtExpirationTime").textbox('setValue',data.data[0].expirationTime);
                            var sGroups = data.data[0].groups.split(',');
                            $.each(sGroups,function(i,value){
                                var findG = $(('#check_G' + value));
                                if(findG.length > 0)
                                {
                                    findG[0].checked = true;
                                    showVehcheck('G' + value);
                                }
                            });
                        }
                        else
                        {
                            OpenInfo(GetErr(data.err));
                        }
                },
                error: function(e) { 
                    OpenInfo(e.responseText); 
                } 
            });
        }
        
        function SearchReturn(thisID)
        {
            var iPid = "G-1";
            $.each(jsonVehGroup,function(i,value){
                if(value.id == thisID)
                {
                    iPid = value.PID;
                    return false;
                }
            });
            sExpendIDs = "";
            if(iPid != "G-1")
            {
                GetExpendID(iPid);
                if(sExpendIDs.length > 0)
                {
                    var arrExpendIDs = sExpendIDs.split(',');
                    for(var i = arrExpendIDs.length - 1; i >=0; i--)
                    {
                        $('#tgVeh').treegrid('expand',arrExpendIDs[i]);
                    }
                }
            }
            $('#tgVeh').treegrid('select',thisID);
            $('html, body').animate({  
                    scrollTop: $(".datagrid-row-selected").offset().top  
                }, 2000);
        }
        
        var sExpendIDs = "";
        function GetExpendID(pid)
        {
            $.each(jsonVehGroup,function(i,value){
                if(value.id == pid)
                {
                    if(value.PID == "G-1")
                    {
                        if(sExpendIDs.length == 0)
                        {
                            sExpendIDs = value.id;
                        }
                        else
                        {
                            sExpendIDs = sExpendIDs + "," + value.id;
                        }
                    }
                    else
                    {
                        if(sExpendIDs.length == 0)
                        {
                            sExpendIDs = value.id;
                        }
                        else
                        {
                            sExpendIDs = sExpendIDs + "," + value.id;
                        }
                        GetExpendID(value.PID);
                    }
                    return false;
                }
            });
        }
        
        var jsonVehGroup = "";
        var jsonVehs = "";
        function InitVehAndGroup(VehGroup, Vehs)
        {
            jsonVehGroup = VehGroup;
            jsonVehs = Vehs;
            if(typeof(jsonVehGroup) == "undefined")
            {
                return;
            }
            if(jsonVehGroup.length == 0)
            {
                return;
            }
            
            var attchJson = {"total":0,"rows":[]};
            var arrVehGroup = AddVehGroup(jsonVehGroup);
            if(typeof(arrVehGroup) == "undefined")
            {
                 return;
            }
            
            $.each(arrVehGroup, function(i, value){
                 if(value.state == "closed")
                 {
//                     $.each(jsonVehs, function(j, value2){
//                         if(value2.GID == value.id)
//                         {
//                             value2["team"] = value.name;
//                             //return false;//true=continue,false=break
//                         }
//                    });
                 }
                 else
                 {
//                     $.each(jsonVehs, function(j, value2){
//                         if(value2.GID == value.id)
//                         {
//                             value.state = "closed";
//                             value2["team"] = value.name;
//                             //return false;//true=continue,false=break
//                         }
//                    });
                 }
                 attchJson.rows.push(value);
            });
            $('#tgVeh').treegrid('loadData',attchJson);
            $('#tgVeh').treegrid('expandAll',0);
//            if(sDoType == "1" && thisRID != undefined && thisRID.length > 0)
//            {
//                $('#check_G'+thisRID)[0].checked = true;
//                $('#tgVeh').treegrid('select','G' + thisRID);
//                $('html, body').animate({  
//                        scrollTop: $(".datagrid-row-selected").offset().top  
//                    }, 2000);
//            }
//            else if(sDoType == "0" && thisRPID != undefined && thisRPID.length > 0 && thisRPID != "-1")
//            {
//                $('#check_G'+thisRPID)[0].checked = true;
//                $('#tgVeh').treegrid('select','G' + thisRPID);
//                $('html, body').animate({  
//                        scrollTop: $(".datagrid-row-selected").offset().top  
//                    }, 2000);
//            }
        }
        
         function formatVehcheckbox(val,row){
             return "<input type='checkbox' onclick=showVehcheck('"+row.id+"') id='check_"+row.id+"' "+(row.checked?'checked':'')+"/>" + row.name;
        }
        
        function formatPermissioncheckbox(val,row){
             return "<input type='checkbox' onclick=showPermissioncheck('"+row.id+"') id='check_"+row.id+"' "+(row.checked?'checked':'')+"/>" + row.name;
        }
        
        function showVehcheck(checkid){
           var s = '#check_'+checkid;
          //ShowInfo( $(s).attr("id"));
          // ShowInfo($(s)[0].checked);
          /*选子节点*/
           var nodes = $("#tgVeh").treegrid("getChildren",checkid);
           $("#tgVeh").treegrid("expand",checkid);
           for(i=0;i<nodes.length;i++){
              $(('#check_'+nodes[i].id))[0].checked = $(s)[0].checked;
              if($(s)[0].checked)
              {
                    if(nodes[i].id[0] == 'G')
                    {
                        $(('#check_'+nodes[i].id))[0].checked = true;
//                        $("#tgVeh").treegrid("collapse",nodes[i].id);
                        $("#tgVeh").treegrid("expand",nodes[i].id);
                     } 
              }
           }
           return;
           //选上级节点
           if(!$(s)[0].checked){
             var parent = $("#tgVeh").treegrid("getParent",checkid);
             if(parent != undefined)
             {
                $(('#check_'+parent.id))[0].checked  = false;
             }
             while(parent != undefined){
               parent = $("#tgVeh").treegrid("getParent",parent.id);
               if(parent != undefined)
               {
                    $(('#check_'+parent.id))[0].checked  = false;
                }
             }
           }else{
//             if(checkid[0] == 'G' && nodes.length == 0){
//                $('#tgVeh').treegrid('expandTo',checkid).treegrid('select',checkid);
//                var nodeSelect = $('#tgVeh').treegrid('getSelected');
//                if (nodeSelect){
//				    $('#tgVeh').treegrid('expand', nodeSelect.id);
//			    }
//             }
             var parent = $("#tgVeh").treegrid("getParent",checkid);
             if(parent == undefined)
             {
                return;
             }
             var flag= true;
             var arrSon = "";
             for(j = 0 ; j<parent.children.length; j++)
             {
                if(j==0)
                {
                    arrSon = parent.children[j].id;
                }
                else
                {
                    arrSon = arrSon + "," + parent.children[j].id;
                }
             }
             var sons = arrSon.split(','); // parent.id.split(',');         
             for(j=0;j<sons.length;j++){
                if(!$(('#check_'+sons[j]))[0].checked){
                flag = false;
                break;
                }
             }
             if(flag)
             $(('#check_'+parent.id))[0].checked  = true;
             while(flag && parent != undefined){
                 parent = $("#tgVeh").treegrid("getParent",parent.id);
                if(parent != undefined){
                    arrSon = "";
                     for(j = 0 ; j<parent.children.length; j++)
                     {
                        if(j==0)
                        {
                            arrSon = parent.children[j].id;
                        }
                        else
                        {
                            arrSon = arrSon + "," + parent.children[j].id;
                        }
                     }
                     sons = arrSon.split(','); // parent.id.split(',');      
    //            sons = parent.id.split(',');
                for(j=0;j<sons.length;j++){
                if(!$(('#check_'+sons[j]))[0].checked){
                flag = false;
                break;
                }
               }
             }
              if(flag && parent != undefined)
             $(('#check_'+parent.id))[0].checked  = true;
             }
           }
        }
        
        function showPermissioncheck(checkid){
           var s = '#check_'+checkid;
          //ShowInfo( $(s).attr("id"));
          // ShowInfo($(s)[0].checked);
          /*选子节点*/
           var nodes = $("#tgPermission").treegrid("getChildren",checkid);
           $("#tgPermission").treegrid("expand",checkid);
           for(i=0;i<nodes.length;i++){
              $(('#check_'+nodes[i].id))[0].checked = $(s)[0].checked;
              if($(s)[0].checked)
              {
                    if(nodes[i].id[0] == 'P')
                    {
                        $(('#check_'+nodes[i].id))[0].checked = true;
//                        $("#tgPermission").treegrid("collapse",nodes[i].id);
                        $("#tgPermission").treegrid("expand",nodes[i].id);
                     } 
              }
           }
           //选上级节点
           if(!$(s)[0].checked){
             var parent = $("#tgPermission").treegrid("getParent",checkid);
             if(parent != undefined)
             {
                $(('#check_'+parent.id))[0].checked  = false;
             }
             while(parent != undefined){
               parent = $("#tgPermission").treegrid("getParent",parent.id);
               if(parent != undefined)
               {
                    $(('#check_'+parent.id))[0].checked  = false;
                }
             }
           }else{
//             if(checkid[0] == 'G' && nodes.length == 0){
//                $('#tgPermission').treegrid('expandTo',checkid).treegrid('select',checkid);
//                var nodeSelect = $('#tgPermission').treegrid('getSelected');
//                if (nodeSelect){
//				    $('#tgPermission').treegrid('expand', nodeSelect.id);
//			    }
//             }
             var parent = $("#tgPermission").treegrid("getParent",checkid);
             if(parent == undefined)
             {
                return;
             }
             var flag= true;
             var arrSon = "";
             for(j = 0 ; j<parent.children.length; j++)
             {
                if(j==0)
                {
                    arrSon = parent.children[j].id;
                }
                else
                {
                    arrSon = arrSon + "," + parent.children[j].id;
                }
             }
             var sons = arrSon.split(','); // parent.id.split(',');         
             for(j=0;j<sons.length;j++){
                if(!$(('#check_'+sons[j]))[0].checked){
                flag = false;
                break;
                }
             }
             if(flag)
             $(('#check_'+parent.id))[0].checked  = true;
             while(flag && parent != undefined){
                 parent = $("#tgPermission").treegrid("getParent",parent.id);
                if(parent != undefined){
                    arrSon = "";
                     for(j = 0 ; j<parent.children.length; j++)
                     {
                        if(j==0)
                        {
                            arrSon = parent.children[j].id;
                        }
                        else
                        {
                            arrSon = arrSon + "," + parent.children[j].id;
                        }
                     }
                     sons = arrSon.split(','); // parent.id.split(',');      
    //            sons = parent.id.split(',');
                for(j=0;j<sons.length;j++){
                if(!$(('#check_'+sons[j]))[0].checked){
                flag = false;
                break;
                }
               }
             }
              if(flag && parent != undefined)
             $(('#check_'+parent.id))[0].checked  = true;
             }
           }
        }
        
        function AddVehGroup(VehGroup)
        {
            jsonVehGroup = VehGroup;
            if(jsonVehGroup == undefined)
            {
                return undefined;
            }
            if(jsonVehGroup.length == 0)
            {
                return undefined;
            }
           var aaJson = new Array();
            for (var i = 0; i < jsonVehGroup.length; i++) {
                if(jsonVehGroup[i].Root == 1)
                {
                    var sState = "";
                    $.each(jsonVehGroup,function(j,valuej){
                        if(valuej.PID == jsonVehGroup[i].id)
                        {
                            sState = "closed";
                            return false;
                        }
                    });
                    var row = { id: jsonVehGroup[i].id, name: jsonVehGroup[i].name, state: sState, iconCls: "icon-team" };
                    aaJson.push(row);
                }
                else
                {
                    var sState = "";
                    $.each(jsonVehGroup,function(j,valuej){
                        if(valuej.PID == jsonVehGroup[i].id)
                        {
                            sState = "closed";
                            return false;
                        }
                    });
                    var row = { id: jsonVehGroup[i].id, name: jsonVehGroup[i].name, state: sState, iconCls: "icon-team", _parentId: jsonVehGroup[i].PID };
                    aaJson.push(row);
                }
            }
            return aaJson;
        }
        
        function formatter1(date){
			var y = date.getFullYear();
			var m = date.getMonth()+1;
			var d = date.getDate();
			var h = date.getHours();
			var f = date.getMinutes();
			var s = date.getSeconds();
			return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d)+' '+ (h<10?('0'+h):h)+':'+(f<10?('0'+f):f)+':'+(s<10?('0'+s):s);
		}
		
		function parser1(s){
			if (!s) {
			    return new Date();
			}
			if(s  instanceof Date)
			{
			    return s;
			}
			try
			{
			    var dh = s.split(' ');
			    var ss = (dh[0].split('-'));
			    var hms = (dh[1].split(':'));
			    var y = parseInt(ss[0],10);
			    var m = parseInt(ss[1],10);
			    var d = parseInt(ss[2],10);
			    var h = parseInt(hms[0],10);
			    var f = parseInt(hms[1],10);
			    var s = parseInt(hms[2],10);
			    if (!isNaN(y) && !isNaN(m) && !isNaN(d) && !isNaN(h) && !isNaN(f) && !isNaN(s)){
				    return new Date(y,m-1,d,h,f,s);
			    } else {
				    return new Date();
			    }
			}
			catch(e)
			{
			    return new Date();
			}
		}
        
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
