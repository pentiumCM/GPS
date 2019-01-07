<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Vehicle.aspx.cs" Inherits="mng_Forms_Vehicle" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="renderer" content="webkit"> 
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title> <% =Resources.Lan.VehicleMng %></title>
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
        
        fieldset legend {
            color:#1E7ACE;
            font-weight:bold;
            padding:3px 10px 3px 10px;
            border:1px solid #1E7ACE;
            background:#fff;
        }

    </style>
</head>
<body>
    <div id="DivAutoComplete" class="panel combo-p" style="z-index: 110003; position: absolute; display: none; height: 300px; ">
        <div style="float:right; "><img alt="" title="" src="../../EasyUI/themes/icons/cancel.png" onclick="VehClose();" /></div>
        <div style="float:left">
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
		                <th data-options="field:'name'" formatter="formatVehcheckbox" width="350px"><% =Resources.Lan.TheSuperiorTeam %></th>
                        
		            </tr>
		        </thead>
	        </table>
        </div>
    </div>
    <table style="height:100%; width:100%;">
        <tr style="height:28px; ">
            <td style="text-align:left; background-color:White;" colspan="5">
                &nbsp;&nbsp;<a href="#;" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="return Save();"><% =Resources.Lan.Save %></a>
            </td>         
        </tr>
        <tr>
            <td valign="top" style="width:310px;">
                <fieldset id="reqire" style="border-width: 1px; border-color: #3B9CFF; ">
                    <legend><font color="red">*<% =Resources.Lan.VehRequired %>*</font> </legend>
                    <table>                        
                        <tr style="height:28px;">
                            <td style="width:150px; text-align:right;"><% =Resources.Lan.VehPlateNO %><font color="red">*</font>：</td>
                            <td style="width:150px;">
                                <input id="txtPlateNO" class="easyui-textbox" style="width:140px;" />
                             </td>
                        </tr>
                        <tr>
                            <td style="width:150px; text-align:right;"><% =Resources.Lan.Team %><font color="red">*</font>：</td>
                            <td style="text-align:left; width:150px;" >
                                <input id="txtVeh" style="width:114px;" name = "txtVeh" type="text" value="" />
                               <img alt="" title="" src="../../EasyUI/themes/icons/search.png" onclick="ShowDivVehTree();" /> 
                            </td>
                        </tr>
                        <tr style="height:28px;">
                            <td style="width:150px; text-align:right;"><% =Resources.Lan.IpAddress %><font color="red">*</font>：</td>
                            <td style="width:150px;"><input id="txtIpAddress" class="easyui-textbox" style="width:140px;" /></td>
                      </tr>
                        <tr style="height:28px;">
                            <td style="width:150px; text-align:right;"><% =Resources.Lan.Sim %><font color="red">*</font>：</td>
                            <td style="width:150px;"><input id="txtSim" class="easyui-textbox" style="width:140px;" /></td>
                        </tr>
                        <tr style="height:28px;">
                            <td style="width:150px; text-align:right;"><% =Resources.Lan.TaxiNo%><font color="red">*</font>：</td>
                            <td style="width:150px;">
                                <select class="easyui-combobox" name="txtTaxiNo" id="txtTaxiNo" style="width:140px;" data-options="valueField: 'value',textField: 'label'">
		                            <option value="GPRS_GB北斗型">GPRS_GBBD</option>		                            <option value="GPRS_M6型">GPRS_M6</option>		                            <option value="GPRS_K1型">GPRS_K1</option>		                            <option value="GPRS_YJ云镜型">GPRS_YJ</option>		                            <%--<option value="GPRS_GB型">GPRS_GB</option>--%>                                </select>
                            </td>
                        </tr>
                        <tr style="height:28px;">
                            <td></td>
                            <td></td>
                        </tr>
                        <tr style="height:32px;">
                            <td></td>
                            <td></td>
                        </tr>
                    </table>
                </fieldset>
            </td>
            <td valign="top">
                <fieldset id="OtherInfo" style="border-width: 1px; border-color: #3B9CFF; ">
                    <legend><% =Resources.Lan.VehOtherInfo %> </legend>
                    <table>  
                        <tr style="height:28px;">
                            <td style="width:120px; text-align:right;"><% =Resources.Lan.VehOwnerName %>：</td>
                            <td style="width:150px;"><input id="txtOwnerName" class="easyui-textbox" style="width:140px;" /></td>
                            <td style="width:150px; text-align:right;"><% =Resources.Lan.Sex %>：</td>
                            <td style="width:150px;">
                                <select class="easyui-combobox" name="txtSex" id="txtSex" style="width:140px;">
		                            <option value="<% =Resources.Lan.VehMan %>"><% =Resources.Lan.VehMan %></option>		                            <option value="<% =Resources.Lan.VehFemale %>"><% =Resources.Lan.VehFemale%></option>		                        </select>
                            </td>
                        </tr>  
                        <tr style="height:28px;">
                            <td style="width:120px; text-align:right;"><% =Resources.Lan.VehTel%>：</td>
                            <td style="width:150px;"><input id="txtTel" class="easyui-textbox" style="width:140px;" /></td>
                            <td style="width:150px; text-align:right;"><% =Resources.Lan.VehEmail %>：</td>
                            <td style="width:150px;"><input id="txtEmail" class="easyui-textbox" style="width:140px;" /></td>
                        </tr>
                        <tr style="height:28px;">
                            <td style="width:120px; text-align:right;"><% =Resources.Lan.VehContact1 %>：</td>
                            <td style="width:150px;"><input id="txtContact1" class="easyui-textbox" style="width:140px;" /></td>
                            <td style="width:150px; text-align:right;"><% =Resources.Lan.VehTel1 %>：</td>
                            <td style="width:150px;"><input id="txtTel1" class="easyui-textbox" style="width:140px;" /></td>
                        </tr>
                        <tr style="height:28px;">
                            <td style="width:120px; text-align:right;"><% =Resources.Lan.VehContact2 %>：</td>
                            <td style="width:150px;"><input id="txtContact2" class="easyui-textbox" style="width:140px;" /></td>
                            <td style="width:150px; text-align:right;"><% =Resources.Lan.VehTel2 %>：</td>
                            <td style="width:150px;"><input id="txtTel2" class="easyui-textbox" style="width:140px;" /></td>
                        </tr>
                        <tr style="height:28px;">
                            <td style="width:120px; text-align:right;"><% =Resources.Lan.VehIdentityCard %>：</td>
                            <td style="width:150px;"><input id="txtIdentityCard" class="easyui-textbox" style="width:140px;" /></td>
                            <td style="width:150px; text-align:right;"><% =Resources.Lan.VehPostalCode %>：</td>
                            <td style="width:150px;"><input id="txtPostalCode" class="easyui-textbox" style="width:140px;" /></td>
                        </tr>
                        <tr style="height:28px;">
                            <td style="width:120px; text-align:right;"><% =Resources.Lan.VehWorkUnit%>：</td>
                            <td style="width:150px;"><input id="txtWorkUnit" class="easyui-textbox" style="width:140px;" /></td>
                            <td style="width:150px; text-align:right; visibility:hidden;"><% =Resources.Lan.VehDriverName %>：</td>
                            <td style="width:150px; visibility:hidden;"><input id="txtDriverName" class="easyui-textbox" style="width:140px;" /></td>
                        </tr>
                        <tr style="height:28px;">
                            <td style="width:120px; text-align:right;"><% =Resources.Lan.VehAddress %>：</td>
                            <td colspan="3">
                                <input id="txtAddress" class="easyui-textbox" style="width:450px;" />
                            </td>
                        </tr>
                    </table>
                 </fieldset>
            </td>
        </tr>  
        <tr>            
            <td valign="top">
                <fieldset id="Fieldset1" style="border-width: 1px; border-color: #3B9CFF; ">
                    <legend><% =Resources.Lan.VehInfo %> </legend>
                    <table>  
                        <tr >
                            <td style="width:150px; text-align:right; vertical-align:top;"><% =Resources.Lan.VehCustomNum %>：</td>
                            <td style="width:150px; vertical-align:top;">
                                <input id="txtCustomNum" class="easyui-textbox" style="width:140px;" />
                                <%--<input id="txtMarks" class="easyui-textbox" data-options="multiline:true" style="width:140px; height:99%;">--%>
                            </td>
                        </tr>   
                        <%--<tr style="height:0px; visibility:hidden;">
                            <td style="width:150px; text-align:right; visibility:hidden;"><% =Resources.Lan.VehVendorCode %>：</td>
                            <td style="width:150px; visibility:hidden;"><input id="txtVendorCode" class="easyui-textbox" style="width:140px;" /></td>
                        </tr> --%>                  
                        <tr style="height:28px;">
                            <td style="width:150px; text-align:right;"><% =Resources.Lan.VehServerPwd %>：</td>
                            <td style="width:150px;"><input id="txtServerPwd" class="easyui-textbox" style="width:140px;" /></td>
                        </tr>
                        <tr style="height:28px;">
                            <td style="width:150px; text-align:right;"><% =Resources.Lan.VehPlateColor %>：</td>
                            <td style="width:150px;">
                                <select class="easyui-combobox" name="txtPlateColor" id="txtPlateColor" style="width:140px;">
		                            <option value="<% =Resources.Lan.ColorWhite %>"><% =Resources.Lan.ColorWhite %></option>		                            <option value="<% =Resources.Lan.ColorBlack %>"><% =Resources.Lan.ColorBlack%></option>		                            <option value="<% =Resources.Lan.ColorRed %>"><% =Resources.Lan.ColorRed%></option>		                            <option value="<% =Resources.Lan.ColorBlue %>"><% =Resources.Lan.ColorBlue%></option>		                            <option value="<% =Resources.Lan.ColorGreen %>"><% =Resources.Lan.ColorGreen%></option>		                            <option value="<% =Resources.Lan.ColorYellow %>"><% =Resources.Lan.ColorYellow%></option>		                            <option value="<% =Resources.Lan.ColorOrange %>"><% =Resources.Lan.ColorOrange%></option>		                            <option value="<% =Resources.Lan.ColorGray %>"><% =Resources.Lan.ColorGray%></option>                                </select>
                            </td>
                      </tr>
                        <tr style="height:28px;">
                            <td style="width:150px; text-align:right;"><% =Resources.Lan.VehCarColor%>：</td>
                            <td style="width:150px;">
                                <select class="easyui-combobox" name="txtCarColor" id="txtCarColor" style="width:140px;">
		                            <option value="<% =Resources.Lan.ColorWhite %>"><% =Resources.Lan.ColorWhite %></option>		                            <option value="<% =Resources.Lan.ColorBlack %>"><% =Resources.Lan.ColorBlack%></option>		                            <option value="<% =Resources.Lan.ColorRed %>"><% =Resources.Lan.ColorRed%></option>		                            <option value="<% =Resources.Lan.ColorBlue %>"><% =Resources.Lan.ColorBlue%></option>		                            <option value="<% =Resources.Lan.ColorGreen %>"><% =Resources.Lan.ColorGreen%></option>		                            <option value="<% =Resources.Lan.ColorYellow %>"><% =Resources.Lan.ColorYellow%></option>		                            <option value="<% =Resources.Lan.ColorOrange %>"><% =Resources.Lan.ColorOrange%></option>		                            <option value="<% =Resources.Lan.ColorGray %>"><% =Resources.Lan.ColorGray%></option>                                </select>
                            </td>
                        </tr>
                        <tr style="height:28px;">
                            <td style="width:150px; text-align:right;"><% =Resources.Lan.VehCarType%>：</td>
                            <td style="width:150px;">
                                <select class="easyui-combobox" name="txtCarType" id="txtCarType" style="width:140px;">
		                            <option value="<% =Resources.Lan.VehTruck %>"><% =Resources.Lan.VehTruck%></option>		                            <option value="<% =Resources.Lan.VehBus %>"><% =Resources.Lan.VehBus%></option>		                            <option value="<% =Resources.Lan.VehDumpTruck %>"><% =Resources.Lan.VehDumpTruck%></option>		                            <option value="<% =Resources.Lan.VehMixersCar %>"><% =Resources.Lan.VehMixersCar %></option>		                            <option value="<% =Resources.Lan.VehDangerousCar %>"><% =Resources.Lan.VehDangerousCar%></option>		                            <option value="<% =Resources.Lan.VehCar %>"><% =Resources.Lan.VehCar%></option>                                </select>
                            </td>
                        </tr>
                        <tr >
                            <td style="width:150px; text-align:right; vertical-align:top;"><% =Resources.Lan.VehEngineNumber %>：</td>
                            <td style="width:150px; vertical-align:top;">
                                <input id="txtEngineNumber" class="easyui-textbox" style="width:140px;" />
                                <%--<input id="txtMarks" class="easyui-textbox" data-options="multiline:true" style="width:140px; height:99%;">--%>
                            </td>
                        </tr>
                        <tr style="height:26px;">
                            <td style="width:150px; text-align:right;"><% =Resources.Lan.VehFrameNumber %>：</td>
                            <td style="width:150px;"><input id="txtFrameNumber" class="easyui-textbox" style="width:140px;" /></td>
                        </tr>
                        <tr style="height:26px;">
                            <td style="width:150px; text-align:right;"><% =Resources.Lan.VehInstallDate%>：</td>
                            <td style="width:150px;">
                                <input id="txtInstallDate"  editable="false" class="easyui-datebox" style="width:140px;" name="txtInstallDate" data-options="formatter:dateformatter,parser:mydateparser" />
                            </td>
                        </tr>
                        <tr style="height:26px;">
                            <td style="width:150px; text-align:right;"><% =Resources.Lan.VehPowerType %>：</td>
                            <td style="width:150px;">
                                <select class="easyui-combobox" name="txtPowerType" id="txtPowerType" style="width:140px;">
		                            <option value="<% =Resources.Lan.VehPowerOil %>"><% =Resources.Lan.VehPowerOil %></option>		                            <option value="<% =Resources.Lan.VehPowerBlend %>"><% =Resources.Lan.VehPowerBlend%></option>		                            <option value="<% =Resources.Lan.VehPowerElectric %>"><% =Resources.Lan.VehPowerElectric%></option>		                            <option value="<% =Resources.Lan.VehPowerGas %>"><% =Resources.Lan.VehPowerGas %></option>		                        </select>
                            </td>
                        </tr>
                    </table>
                </fieldset> 
            </td>
            <td valign="top">
                <fieldset id="Fieldset2"  style="border-width: 1px; border-color: #3B9CFF; ">
                    <legend><% =Resources.Lan.VehCenterInfo %> </legend>
                    <table>  
                        <tr >
                            <td style="width:120px; text-align:right; vertical-align:top;"><% =Resources.Lan.VehInstallPerson%>：</td>
                            <td style="width:150px; vertical-align:top;">
                                <input id="txtInstallPerson" class="easyui-textbox" style="width:140px;" />
                            </td>
                            <td style="width:150px; text-align:right; vertical-align:top;"><% =Resources.Lan.VehTonnage %>/<% =Resources.Lan.VehSeats%>：</td>
                            <td style="width:150px; vertical-align:top;">
                                <input id="txtTonOrSeats" class="easyui-textbox" style="width:140px;" />
                            </td>
                        </tr>   
                        <tr >
                            <td style="width:120px; text-align:right; vertical-align:top;"><% =Resources.Lan.VehOperationRoute%>：</td>
                            <td style="width:150px; vertical-align:top;">
                                <input id="txtOperationRoute" class="easyui-textbox" style="width:140px;" />
                            </td>
                            <td style="width:150px; text-align:right; vertical-align:top;"><% =Resources.Lan.VehicleTransportLicenseID%>：</td>
                            <td style="width:150px; vertical-align:top;">
                                <input id="txtTransportLicenseID" class="easyui-textbox" style="width:140px;" />
                            </td>
                        </tr>      
                        <tr >
                            <td style="width:120px; text-align:right; vertical-align:top;"><% =Resources.Lan.PurchaseDate %>：</td>
                            <td style="width:150px; vertical-align:top;">
                                <input id="txtPurchaseDate"  editable="false" class="easyui-datebox" style="width:140px;"  data-options="formatter:dateformatter,parser:mydateparser"/>
                            </td>
                            <td style="width:150px; text-align:right; vertical-align:top;"><% =Resources.Lan.ServerEndTime %>：</td>
                            <td style="width:150px; vertical-align:top;">
                                <input id="txtServerEndTime"  editable="false" class="easyui-datebox" style="width:140px;"  data-options="formatter:dateformatter,parser:mydateparser"/>
                            </td>
                        </tr>        
                        <tr >
                            <td style="width:120px; text-align:right; vertical-align:top;"><% =Resources.Lan.EnrolDate %>：</td>
                            <td style="width:150px; vertical-align:top;">
                                <input id="txtEnrolDate"   editable="false" class="easyui-datebox" style="width:140px;"  data-options="formatter:dateformatter,parser:mydateparser"/>
                            </td>
                            <td style="width:150px; text-align:right; vertical-align:top;"><% =Resources.Lan.AnnualInspectionRepairTime %>：</td>
                            <td style="width:150px; vertical-align:top;">
                                <input id="txtAnnualInspectionRepairTime"   editable="false" class="easyui-datebox" style="width:140px;"  data-options="formatter:dateformatter,parser:mydateparser"/>
                            </td>
                        </tr>         
                        <tr >
                            <td style="width:120px; text-align:right; vertical-align:top;"><% =Resources.Lan.VehMoney %>：</td>
                            <td style="width:150px; vertical-align:top;">
                                <input id="txtMoney" class="easyui-textbox" style="width:140px;" value="0" />
                            </td>
                            <td style="width:150px; text-align:right; vertical-align:top;"><% =Resources.Lan.VehLevel2MaintenanceTime %>：</td>
                            <td style="width:150px; vertical-align:top;">
                                <input id="txtLevel2MaintenanceTime"  editable="false" class="easyui-datebox" style="width:140px;"  data-options="formatter:dateformatter,parser:mydateparser"/>
                            </td>
                        </tr>
                    </table>
                </fieldset>
                <br />
                <fieldset id="Fieldset3" style="border-width: 1px; border-color: #3B9CFF; ">
                    <legend><% =Resources.Lan.Marks%> </legend>
                    <input id="txtMarks" class="easyui-textbox" data-options="multiline:true" style="width:575px; height:99%;">
               </fieldset>
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
    arrErr.push({ "key": "4013","value":"<% =Resources.Lan.AddFailureExistsUserGroup %>"});
    arrErr.push({ "key": "4014","value":"<% =Resources.Lan.EditFailureExistsUserGroup %>"});
    arrErr.push({ "key": "4015","value":"<% =Resources.Lan.PermissionDenied %>"});
    arrErr.push({ "key": "4016","value":"<% =Resources.Lan.VehGroupNotExists %>"});
    arrErr.push({ "key": "4017","value":"<% =Resources.Lan.GroupExistsChild %>"});
    arrErr.push({ "key": "4018","value":"<% =Resources.Lan.UserGroupHasChild %>"});
    arrErr.push({ "key": "4018","value":"<% =Resources.Lan.NotExistsUserGroup %>"});

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
		    if(!AntiSqlValid($("#txtPlateNO")[0]))
		    {
		        $(".datagrid-mask").remove();  
                $(".datagrid-mask-msg").remove(); 
                OpenInfo("<% =Resources.Lan.NotEnterIllegalCharacters %>");
                return false;
		    }
		    if(!AntiSqlValid($("#txtIpAddress")[0]))
		    {
		        $(".datagrid-mask").remove();  
                $(".datagrid-mask-msg").remove(); 
                OpenInfo("<% =Resources.Lan.NotEnterIllegalCharacters %>");
                return false;
		    }
		    if(!AntiSqlValid($("#txtSim")[0]))
		    {
		        $(".datagrid-mask").remove();  
                $(".datagrid-mask-msg").remove(); 
                OpenInfo("<% =Resources.Lan.NotEnterIllegalCharacters %>");
                return false;
		    }
		    if(iSearchID == undefined || iSearchID.length == 0)
		    {
		        $(".datagrid-mask").remove();  
                $(".datagrid-mask-msg").remove(); 
                OpenInfo("<% =Resources.Lan.Team %>,<% =Resources.Lan.NoEmpty %>");
                return false;
		    }
		    var iGroupID = iSearchID.substring(1);
		    var iVehID = 0;
		    if(sDoType == "0" && thisVehID != undefined && thisVehID.length > 0)
            {
                iVehID = thisVehID;
            }
		    var txtPlateNO = $("#txtPlateNO").val();
		    var txtIpAddress = $("#txtIpAddress").val();
		    var txtSim = $("#txtSim").val();
		    var txtTaxiNo = $('#txtTaxiNo').combobox('getValue');
		    //基本资料
		    var txtCustomNum = $("#txtCustomNum").val();
		    var txtVendorCode = "";//$("#txtVendorCode").val();
		    var txtServerPwd = $("#txtServerPwd").val();
		    var txtPlateColor = $('#txtPlateColor').combobox('getValue');
		    var txtCarColor = $('#txtCarColor').combobox('getValue');
		    var txtCarType = $('#txtCarType').combobox('getValue');
		    var txtEngineNumber = $("#txtEngineNumber").val();
		    var txtFrameNumber = $("#txtFrameNumber").val();
		    var dateSave = new Date();
		    var hour = dateSave.getHours() < 10 ? "0" + dateSave.getHours() : dateSave.getHours();
            var minute = dateSave.getMinutes() < 10 ? "0" + dateSave.getMinutes() : dateSave.getMinutes();
            var second = dateSave.getSeconds() < 10 ? "0" + dateSave.getSeconds() : dateSave.getSeconds();
		    var hhmmss = " " + hour + ":" + minute + ":" + second;
		    var txtInstallDate = $('#txtInstallDate').datebox('getValue');
		    txtInstallDate = txtInstallDate + hhmmss;
		    var txtPowerType = $('#txtPowerType').combobox('getValue');
		    //其它资料
		    var txtOwnerName = $("#txtOwnerName").val();
		    var txtSex = $('#txtSex').combobox('getValue');
		    var txtTel = $("#txtTel").val();
		    var txtEmail = $("#txtEmail").val();
		    var txtContact1 = $("#txtContact1").val();
		    var txtTel1 = $("#txtTel1").val();
		    var txtContact2 = $("#txtContact2").val();
		    var txtTel2 = $("#txtTel2").val();
		    var txtIdentityCard = $("#txtIdentityCard").val();
		    var txtPostalCode = $("#txtPostalCode").val();
		    var txtWorkUnit = $("#txtWorkUnit").val();
		    var txtDriverName = $("#txtDriverName").val();
		    var txtAddress = $("#txtAddress").val();
		    //中心资料
		    var txtInstallPerson = $("#txtInstallPerson").val();
		    var txtTonOrSeats = $("#txtTonOrSeats").val();
		    var txtOperationRoute = $("#txtOperationRoute").val();
		    var txtTransportLicenseID = $("#txtTransportLicenseID").val();
		    var txtMoney = $("#txtMoney").val();
		    var txtPurchaseDate = $('#txtPurchaseDate').datebox('getValue');
		    txtPurchaseDate = txtPurchaseDate + hhmmss;
		    var txtServerEndTime = $('#txtServerEndTime').datebox('getValue');
		    txtServerEndTime = txtServerEndTime + hhmmss;
		    var txtEnrolDate = $('#txtEnrolDate').datebox('getValue');
		    txtEnrolDate = txtEnrolDate + hhmmss;
		    var txtAnnualInspectionRepairTime = $('#txtAnnualInspectionRepairTime').datebox('getValue');
		    txtAnnualInspectionRepairTime = txtAnnualInspectionRepairTime + hhmmss;
		    var txtVehLevel2MaintenanceTime = $('#txtLevel2MaintenanceTime').datebox('getValue');
		    txtVehLevel2MaintenanceTime = txtVehLevel2MaintenanceTime + hhmmss;
		    //备注
		    var txtMarks = $("#txtMarks").val();
		    if(txtPlateNO.length == 0)
		    {
		        $(".datagrid-mask").remove();  
                $(".datagrid-mask-msg").remove(); 
                OpenInfo("<% =Resources.Lan.VehPlateNO %>,<% =Resources.Lan.NoEmpty %>");
                return false;
		    }
		    if(txtIpAddress.length == 0)
		    {
		        $(".datagrid-mask").remove();  
                $(".datagrid-mask-msg").remove(); 
                OpenInfo("<% =Resources.Lan.IpAddress %>,<% =Resources.Lan.NoEmpty %>");
                return false;
		    }		    
		    if(txtIpAddress.length != 11)
		    {
		        $(".datagrid-mask").remove();  
                $(".datagrid-mask-msg").remove(); 
                OpenInfo("<% =Resources.Lan.IpAddress %>,<% =Resources.Lan.ParameterError %>");
                return false;
		    }
		    if(txtSim.length == 0)
		    {
		        $(".datagrid-mask").remove();  
                $(".datagrid-mask-msg").remove(); 
                OpenInfo("<% =Resources.Lan.Sim %>,<% =Resources.Lan.NoEmpty %>");
                return false;
		    }
		    
		    var sUserName = GetCookie("m_username");
            var sPwd = GetCookie("m_pwd");
            $.ajax({
                url: "../../Ashx/MngVehicle.ashx",
                cache:false,
                type:"post",
                dataType:'json',
                data:{username:sUserName,VehID:iVehID,GID:iGroupID,Pwd:sPwd,DoType:sDoType,PlateNO:txtPlateNO,IpAddress:txtIpAddress,Sim:txtSim,TaxiNo:txtTaxiNo,CustomNum:txtCustomNum,VendorCode:txtVendorCode,ServerPwd:txtServerPwd,PlateColor:txtPlateColor,CarColor:txtCarColor,CarType:txtCarType,EngineNumber:txtEngineNumber,FrameNumber:txtFrameNumber,InstallDate:txtInstallDate,PowerType:txtPowerType,OwnerName:txtOwnerName,Sex:txtSex,Tel:txtTel,Email:txtEmail,Contact1:txtContact1,Tel1:txtTel1,Contact2:txtContact2,Tel2:txtTel2,IdentityCard:txtIdentityCard,PostalCode:txtPostalCode,WorkUnit:txtWorkUnit,DriverName:txtDriverName,Address:txtAddress,InstallPerson:txtInstallPerson,TonOrSeats:txtTonOrSeats,OperationRoute:txtOperationRoute,TransportLicenseID:txtTransportLicenseID,Money:txtMoney,PurchaseDate:txtPurchaseDate,ServerEndTime:txtServerEndTime,EnrolDate:txtEnrolDate,AnnualInspectionRepairTime:txtAnnualInspectionRepairTime,VehLevel2MaintenanceTime:txtVehLevel2MaintenanceTime,Marks:txtMarks,OldName:sOldName},
                success:function(data){
                        if(data.result)
                        {
                            OpenInfo("<% =Resources.Lan.Successful %>");
		                    $(".datagrid-mask").remove();  
                            $(".datagrid-mask-msg").remove();
                            var sTempVehID = "V" + data.err;
                            if(sDoType == "0")
                            {
                                sTempVehID = "V" + thisVehID;
                            } 
                            var sTempGID = iSearchID;
                            var objReturn = {"DoType":sDoType,"ID":sTempVehID,"Name":txtPlateNO,"PID":sTempGID,"customid":txtCustomNum,"ipaddress":txtIpAddress,"sim":txtSim,"taxino":txtTaxiNo,"team":""};
                             window.parent.window.UpdateTree("Vehicle", objReturn);
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
        
        var thisGID="";
        var sDoType = "1";
        var sOldName = "";
        var thisVehID = "";
        $(document).ready(function() { 
            $('#DivAutoComplete').hide();
            $('#txtTaxiNo').combobox({
                editable:false
            });
            $('#txtSex').combobox({
                editable:false
            });
            $('#txtPlateColor').combobox('setValue','<% =Resources.Lan.ColorBlue %>');
            var myDate = new Date();
            $('#txtInstallDate').datebox('setValue', formatter1(myDate));
            $('#txtPurchaseDate').datebox('setValue', formatter1(myDate));
            var dateNext = new Date();
            dateNext.setFullYear(dateNext.getFullYear() + 1);
            $('#txtServerEndTime').datebox('setValue', formatter1(dateNext));
            $('#txtEnrolDate').datebox('setValue', formatter1(dateNext));
            $('#txtAnnualInspectionRepairTime').datebox('setValue', formatter1(dateNext));
            $('#txtLevel2MaintenanceTime').datebox('setValue', formatter1(dateNext));
            var sUrl=location.search.toLowerCase();
            var sQuery=sUrl.substring(sUrl.indexOf("=")+1);
            re=/select|update|delete|truncate|join|union|exec|insert|drop|count|’|"|;|>|</i;
            if(re.test(sQuery))
            {
                OpenInfo("<% =Resources.Lan.NotEnterIllegalCharacters %>");
                location.href=sUrl.replace(sQuery,"");
            }
            var Request = GetRequest();
            thisGID = Request["pid"];
            iSearchID = 'G' + thisGID;
            sDoType = Request["dotype"];
            thisVehID = Request["id"];            
            var IsK = Request["k"];
            if(IsK == "2")
            {
                var arrTaxino = new Array();
                var row = {"label":"GPRS_K1","value":"GPRS_K1型"};
                arrTaxino.push(row);
                var row = {"label":"GPRS_M6","value":"GPRS_M6型"};
                arrTaxino.push(row);
                var row = {"label":"GPRS_GBBD","value":"GPRS_GB北斗型"};
                arrTaxino.push(row);
                $('#txtTaxiNo').combobox('loadData', arrTaxino);
                $('#txtTaxiNo').combobox('setValue', arrTaxino[1].value);
            }
            if(sDoType == "0" && thisVehID != undefined && thisVehID.length > 0)
            {
                GetVehInfo();
            }
            window.parent.window.InitVehAndGroup("<% =Resources.Lan.VehicleMng %>");
            if(thisGID != undefined)
            {
                var thisG = 'G' + thisGID;
                $.each(jsonVehGroup,function(i,value){
                    if(value.id == thisG)
                    {
                        $('#txtVeh').val(value.name);
                        return false;
                    }
                });
            }
            AutoText("txtVeh",jsonVehGroup);
        })
        
        function GetVehInfo()
        {
            var sUserName = GetCookie("m_username");
            var sPwd = GetCookie("m_pwd");
            $.ajax({
                url: "../../Ashx/Vehicle.ashx",
                cache:false,
                type:"post",
                dataType:'json',
                data:{username:sUserName,Pwd:sPwd,DoType:5,ID:thisVehID},
                success:function(data){
                        if(data.result == "true")
                        {
                            $("#txtPlateNO").textbox('setValue',data.data[0].PlateNO);
                            sOldName = data.data[0].PlateNO;
		                    $("#txtIpAddress").textbox('setValue',data.data[0].IpAddress);
		                    $("#txtSim").textbox('setValue',data.data[0].Sim);
		                    $('#txtTaxiNo').combobox('setValue',data.data[0].TaxiNo);	                    
		                    $("#txtCustomNum").textbox('setValue',data.data[0].CustomNum);
		                    $("#txtVendorCode").textbox('setValue',data.data[0].VendorCode);
		                    $("#txtServerPwd").textbox('setValue',data.data[0].ServerPwd);
		                    $('#txtPlateColor').textbox('setValue',data.data[0].PlateColor);
		                    $('#txtCarColor').textbox('setValue',data.data[0].CarColor);
		                    $('#txtCarType').textbox('setValue',data.data[0].CarType);
		                    $("#txtEngineNumber").textbox('setValue',data.data[0].EngineNumber);
		                    $("#txtFrameNumber").textbox('setValue',data.data[0].FrameNumber);
		                    var strDate =data.data[0].InstallDate;
                            strDate = strDate.replace(/-/g,"/");
                            var returndate = new Date(strDate);
		                    $('#txtInstallDate').datebox('setValue',formatter1(returndate));
		                    $('#txtPowerType').combobox('setValue',data.data[0].PowerType);
		                    //其它资料
		                     $("#txtOwnerName").textbox('setValue',data.data[0].OwnerName);
		                    $('#txtSex').combobox('setValue',data.data[0].Sex);
		                    $("#txtTel").textbox('setValue',data.data[0].Tel);
		                    $("#txtEmail").textbox('setValue',data.data[0].Email);
		                    $("#txtContact1").textbox('setValue',data.data[0].Contact1);
		                    $("#txtTel1").textbox('setValue',data.data[0].Tel1);
		                    $("#txtContact2").textbox('setValue',data.data[0].Contact2);
		                    $("#txtTel2").textbox('setValue',data.data[0].Tel2);
		                    $("#txtIdentityCard").textbox('setValue',data.data[0].IdentityCard);
		                    $("#txtPostalCode").textbox('setValue',data.data[0].PostalCode);
		                    $("#txtWorkUnit").textbox('setValue',data.data[0].WorkUnit);
		                    $("#txtDriverName").textbox('setValue',data.data[0].DriverName);
		                    $("#txtAddress").textbox('setValue',data.data[0].Address);
		                    //中心资料
		                    $("#txtInstallPerson").textbox('setValue',data.data[0].InstallPerson);
		                    $("#txtTonOrSeats").textbox('setValue',data.data[0].TonOrSeats);
		                    $("#txtOperationRoute").textbox('setValue',data.data[0].OperationRoute);
		                    $("#txtTransportLicenseID").textbox('setValue',data.data[0].TransportLicenseID);
		                    $("#txtMoney").textbox('setValue',data.data[0].Money);
		                    strDate =data.data[0].PurchaseDate;
                            strDate = strDate.replace(/-/g,"/");
                            returndate = new Date(strDate);
		                    $('#txtPurchaseDate').datebox('setValue',formatter1(returndate));
		                    strDate =data.data[0].ServerEndTime;
                            strDate = strDate.replace(/-/g,"/");
                            returndate = new Date(strDate);
		                    $('#txtServerEndTime').datebox('setValue',formatter1(returndate));
		                    strDate =data.data[0].EnrolDate;
                            strDate = strDate.replace(/-/g,"/");
                            returndate = new Date(strDate);
		                    $('#txtEnrolDate').datebox('setValue',formatter1(returndate));
		                    strDate =data.data[0].AnnualInspectionRepairTime;
                            strDate = strDate.replace(/-/g,"/");
                            returndate = new Date(strDate);
		                    $('#txtAnnualInspectionRepairTime').datebox('setValue',formatter1(returndate));
		                    strDate =data.data[0].Level2MaintenanceTime;
                            strDate = strDate.replace(/-/g,"/");
                            returndate = new Date(strDate);
		                    $('#txtLevel2MaintenanceTime').datebox('setValue',formatter1(returndate));
		                    //备注
		                    $("#txtMarks").textbox('setValue',data.data[0].Marks);
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
            $('#check_'+thisID)[0].checked = true;
            showVehcheck(thisID);
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
            if(jsonVehGroup == undefined)
            {
                return;
            }
            if(jsonVehGroup.length == 0)
            {
                return;
            }
            
            var attchJson = {"total":0,"rows":[]};
            var arrVehGroup = AddVehGroup(jsonVehGroup);
            if(arrVehGroup == undefined)
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
            if(thisGID != undefined && thisGID.length > 0)
            {
                $('#check_G'+thisGID)[0].checked = true;
                $('#tgVeh').treegrid('select','G' + thisGID);
                $('html, body').animate({  
                        scrollTop: $(".datagrid-row-selected").offset().top  
                    }, 2000);
            }
        }
        
         function formatVehcheckbox(val,row){
             return "<input type='checkbox' onclick=showVehcheck('"+row.id+"') id='check_"+row.id+"' "+(row.checked?'checked':'')+"/>" + row.name;
        }
        
        function showVehcheck(checkid){
           var s = 'check_'+checkid;
            $("input[id^='check_']:checked").each(function(){
                if(this.id == s)
                {
                    
                }
                else
                {
                    $(this).attr("checked", false);
                }
            });
           if(checkid[0] == 'V')
           {
            
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
        
        function ShowDivVehTree()
		{
		    //设置下拉列表的位置，然后显示下拉列表 
		    var $searchInput = $('#txtVeh');
		    var $autocompleteParrent = $('#DivAutoComplete');
            var ypos = $searchInput.position().top;
            ypos = getAbsoluteTop($searchInput[0]);
            var xpos = $searchInput.position().left;
            xpos = getAbsoluteLeft($searchInput[0]);
//            $autocompleteParrent.css('width', $searchInput[0].offsetWidth);//.css('width'));
            //$autocomplete.css('width', $searchInput[0].offsetWidth);//.css('width'));
            $autocompleteParrent.css({
                'position': 'absolute',
                'left': (xpos) + "px",
                'top': (ypos + $searchInput[0].offsetHeight) + "px"
            });
//            $autocomplete.addClass("combo-panel");
//            $autocomplete.addClass("panel-body");
//            $autocomplete.addClass("panel-body-noheader");
            //显示下拉列表 
            $autocompleteParrent.show();
            $('#tgVeh').treegrid('resize',{width:'350px',height:'300px'});
		}
		
		var iSearchID = "";
		function VehClose()
		{
		    $('#txtVeh').val("");
		    iSearchID = "";
		    $("input:checked").each(function(){
                var id = $(this).attr("id");              
                if(id.indexOf("check_V")>-1 || id.indexOf("check_G")>-1)
                {
                    $('#tgVeh').treegrid('select',id.substring(6));
                    var row = $('#tgVeh').treegrid('getSelected');
                    iSearchID = id.substring(6);
                    $('#txtVeh').val(row.name);                    
                }
            });
            $('#DivAutoComplete').hide();
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
		
		function formatterSearch(date,HHmmss){
			var y = date.getFullYear();
			var m = date.getMonth()+1;
			var d = date.getDate();
			return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d)+' '+ HHmmss;
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
		
		function dateformatter(date){
			var y = date.getFullYear();
			var m = date.getMonth()+1;
			var d = date.getDate();
			return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
		}
		function mydateparser(s){
			if (!s) return new Date();
			var ss = (s.split('-'));
			var y = parseInt(ss[0],10);
			var m = parseInt(ss[1],10);
			var d = parseInt(ss[2],10);
			if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
				return new Date(y,m-1,d);
			} else {
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
