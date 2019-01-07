<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RecycleMng.aspx.cs" Inherits="mng_Forms_RecycleMng" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="renderer" content="webkit"> 
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title> <% =Resources.Lan.RecycleBinManagement %></title>
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
<body oncontextmenu="return false">
    <table style="width:100%; height:100%;">
        <tr style="height:32px; ">
            <td style="text-align:left; background-color:White;">
                &nbsp;&nbsp;<a href="#;" class="easyui-linkbutton" data-options="iconCls:'icon-team'" onclick="return BinTeam();"><% =Resources.Lan.Team %></a>
                <a href="#;" class="easyui-linkbutton" data-options="iconCls:'icon-online'" onclick="return BinVeh();"><% =Resources.Lan.Vehicle %></a>
                <a href="#;" id="btnUserGroup" class="easyui-linkbutton" data-options="iconCls:'icon-usermng'" onclick="return BinUserGroup();"><% =Resources.Lan.UserGroup %></a>
                <a href="#;" id="btnUser" class="easyui-linkbutton" data-options="iconCls:'icon-user'" onclick="return BinUser();"><% =Resources.Lan.User2 %></a>
            </td>         
        </tr>
        <tr style="text-align:left; vertical-align:top">
            <td>
                <table id="tableBin" class="easyui-datagrid" style="width:100%; height:auto;  " data-options="striped:true,nowrap:false,singleSelect:true,collapsible:true,onRowContextMenu: onGridMenu">
		             <thead>
			             <tr>
			                <th data-options="field:'id',width:115,align:'left'" >ID</th>
				            <th data-options="field:'name',width:200,align:'left'" ><% =Resources.Lan.Name %></th>
				            <th data-options="field:'marks',align:'left',width:330" ><% =Resources.Lan.Marks %></th>
				         </tr>
		             </thead>
	             </table>
            </td>
        </tr>   
    </table>
	<div id="divGrid" class="easyui-menu"  style="width:120px;">
		<div data-options="iconCls:'icon-add'" onclick="SaveBin(1);"><% =Resources.Lan.Recover %></div>
		<div data-options="iconCls:'icon-remove'" onclick="SaveBin(2);"><% =Resources.Lan.CompletelyDelete %></div>
    </div>

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
    arrErr.push({ "key": "4019","value":"<% =Resources.Lan.NotExistsUserGroup %>"});

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
    
    function onGridMenu(e, rowIndex, rowData)
    {
        $("#tableBin").datagrid('selectRow',rowIndex);
        $('#divGrid').menu('show',{
			    left: e.pageX,
			    top: e.pageY
		    });
    }
    
    var DoType = 1;
    function BinTeam()
    {
        DoType = 1;
        $("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: "100%", zIndex: 99999 }).appendTo("body");  
        $("<div class=\"datagrid-mask-msg\"></div>").html("<% =Resources.Lan.Loding %>").appendTo("body").css({ display: "block", left: ($(document.body).outerWidth(true) - 190) / 2, top: ($(window).height() - 45) / 2 });  
		$("#tableBin").datagrid('loadData',[{}]);
		var sUserName = GetCookie("m_username");
        var sPwd = GetCookie("m_pwd");
        $.ajax({
            url: "../../Ashx/MngBinQuery.ashx",
            cache:false,
            type:"post",
            dataType:'json',
            data:{username:sUserName,Pwd:sPwd,DoType:1},
            success:function(data){
                    if(data.result)
                    {
                        $.each(data.data,function(i,value){
                            value["name"] = value.VehGroupName;
                            value["id"] = value.VehGroupID;
                            value["marks"] = value.Address;
                        });
		                $(".datagrid-mask").remove();  
                        $(".datagrid-mask-msg").remove();
                        $("#tableBin").datagrid('loadData',data.data);
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
    }
    
    
    function BinVeh()
    {
        DoType = 2;
        $("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: "100%", zIndex: 99999 }).appendTo("body");  
        $("<div class=\"datagrid-mask-msg\"></div>").html("<% =Resources.Lan.Loding %>").appendTo("body").css({ display: "block", left: ($(document.body).outerWidth(true) - 190) / 2, top: ($(window).height() - 45) / 2 });  
		$("#tableBin").datagrid('loadData',[{}]);
		var sUserName = GetCookie("m_username");
        var sPwd = GetCookie("m_pwd");
        $.ajax({
            url: "../../Ashx/MngBinQuery.ashx",
            cache:false,
            type:"post",
            dataType:'json',
            data:{username:sUserName,Pwd:sPwd,DoType:2},
            success:function(data){
                    if(data.result)
                    {
                        $.each(data.data,function(i,value){
                            value.PID = value.GID;
                            value["marks"] = "<% =Resources.Lan.IpAddress %>:" + value.ipaddress + ", <% =Resources.Lan.Sim %>:" + value.sim;
                        });
		                $(".datagrid-mask").remove();  
                        $(".datagrid-mask-msg").remove();
                        $("#tableBin").datagrid('loadData',data.data);
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
    }
    
    function BinUserGroup()
    {
        DoType = 3;
        $("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: "100%", zIndex: 99999 }).appendTo("body");  
        $("<div class=\"datagrid-mask-msg\"></div>").html("<% =Resources.Lan.Loding %>").appendTo("body").css({ display: "block", left: ($(document.body).outerWidth(true) - 190) / 2, top: ($(window).height() - 45) / 2 });  
		$("#tableBin").datagrid('loadData',[{}]);
		var sUserName = GetCookie("m_username");
        var sPwd = GetCookie("m_pwd");
        $.ajax({
            url: "../../Ashx/MngBinQuery.ashx",
            cache:false,
            type:"post",
            dataType:'json',
            data:{username:sUserName,Pwd:sPwd,DoType:3},
            success:function(data){
                    if(data.result)
                    {
                        $.each(data.data,function(i,value){
                            value["marks"] = "";
                        });
		                $(".datagrid-mask").remove();  
                        $(".datagrid-mask-msg").remove();
                        $("#tableBin").datagrid('loadData',data.data);
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
    }
    
    function BinUser()
    {
        DoType = 4;
        $("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: "100%", zIndex: 99999 }).appendTo("body");  
        $("<div class=\"datagrid-mask-msg\"></div>").html("<% =Resources.Lan.Loding %>").appendTo("body").css({ display: "block", left: ($(document.body).outerWidth(true) - 190) / 2, top: ($(window).height() - 45) / 2 });  
		$("#tableBin").datagrid('loadData',[{}]);
		var sUserName = GetCookie("m_username");
        var sPwd = GetCookie("m_pwd");
        $.ajax({
            url: "../../Ashx/MngBinQuery.ashx",
            cache:false,
            type:"post",
            dataType:'json',
            data:{username:sUserName,Pwd:sPwd,DoType:4},
            success:function(data){
                    if(data.result)
                    {
                        $.each(data.data,function(i,value){
                            value["marks"] = "";
                        });
		                $(".datagrid-mask").remove();  
                        $(".datagrid-mask-msg").remove();
                        $("#tableBin").datagrid('loadData',data.data);
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
    }
    
    function SaveBin(operation){
		    $("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: "100%", zIndex: 99999 }).appendTo("body");  
            $("<div class=\"datagrid-mask-msg\"></div>").html("<% =Resources.Lan.Loding %>").appendTo("body").css({ display: "block", left: ($(document.body).outerWidth(true) - 190) / 2, top: ($(window).height() - 45) / 2 });  
		    var row = $("#tableBin").datagrid('getSelected');
		    if(row == undefined)
		    {
		        $(".datagrid-mask").remove();  
                $(".datagrid-mask-msg").remove();
                return;
		    }
		    var sDo = "5";
		    if(DoType == 1)
		    {
		        sDo = "5";
		    }
		    else if(DoType == 2)
		    {
		        sDo = "6";
		    }
		    else if(DoType == 3)
		    {
		        sDo = "7";
		    }
		    else if(DoType == 4)
		    {
		        sDo = "8";
		    }
		    var sUserName = GetCookie("m_username");
            var sPwd = GetCookie("m_pwd");
            $.ajax({
                url: "../../Ashx/MngBinQuery.ashx",
                cache:false,
                type:"post",
                dataType:'json',
                data:{username:sUserName,Pwd:sPwd,DoType:sDo,ID:row.id,OpType:operation,OperName:row.name,PID:row.PID},
                success:function(data){
                        if(data.result)
                        {
                            OpenInfo("<% =Resources.Lan.Successful %>");
		                    $(".datagrid-mask").remove();  
                            $(".datagrid-mask-msg").remove();
                            var iRowIndex = $("#tableBin").datagrid('getRowIndex',row);
                            $("#tableBin").datagrid('deleteRow',iRowIndex);
                            if(sDo == "5")//车组
                            {
                                if(operation == 1)
                                {
                                    var sTempGroupID = "G" + row.id;
                                    var pGroupID =  "G" + row.PID;
                                    if(row.PID == "-1")
                                    {
                                         pGroupID = "T_Veh"
                                    }
                                    var objReturn = {"DoType":1,"GroupID":sTempGroupID,"Name":row.name,"PID":pGroupID};
                                    window.parent.window.UpdateTree("VehGroup", objReturn);
                                }
                            }
                            else if(sDo == "6")//车辆
                            {
                                if(operation == 1)
                                {
                                    var sTempVehID = "V" + row.id;
                                    var objReturn = {"DoType":1,"ID":sTempVehID,"Name":row.name,"PID":('G' + row.GID),"customid":row.customid,"ipaddress":row.ipaddress,"sim":row.sim,"taxino":row.taxino,"team":""};
                                    window.parent.window.UpdateTree("Vehicle", objReturn);
                                }
                            }
                            else if(sDo == "7")//用户组
                            {
                                if(operation == 1)
                                {
                                    var sTempGroupID = "U" + row.id;
                                    var pGroupID = "M_User";
                                    var objReturn = {"DoType":1,"ID":sTempGroupID,"Name":row.name,"PID":pGroupID};
                                    window.parent.window.UpdateTree("UserGroup", objReturn);
                                }
                            }
                            else if(sDo == "8")//用户
                            {
                                if(operation == 1)
                                {
                                    var sTempGroupID = "R" + row.id;
                                    pGroupID = "U" + row.PID;
                                    var objReturn = {"DoType":1,"ID":sTempGroupID,"Name":row.name,"PID":pGroupID};
                                    window.parent.window.UpdateTree("User", objReturn);
                                }
                            }
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
        
        var sDoType = "1";
        var sOldName = "";
        var sThisID = "";
        $(document).ready(function() { 
            var sUrl=location.search.toLowerCase();
            var sQuery=sUrl.substring(sUrl.indexOf("=")+1);
            re=/select|update|delete|truncate|join|union|exec|insert|drop|count|’|"|;|>|</i;
            if(re.test(sQuery))
            {
                OpenInfo("<% =Resources.Lan.NotEnterIllegalCharacters %>");
                location.href=sUrl.replace(sQuery,"");
            }
            var Request = GetRequest();
            var iUserType = Request["UserType"];
            if(iUserType == undefined || iUserType != "1")
            {
                $("#btnUserGroup").hide();
                $("#btnUser").hide();
            }
        })
        
        
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
