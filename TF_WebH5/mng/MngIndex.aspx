<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MngIndex.aspx.cs" Inherits="mng_MngIndex" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="renderer" content="webkit"> 
    <title> <% =Resources.Lan.BackEnd %></title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="../Css/index.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" type="text/css" href="../css/style2.0.css" />
	<link rel="stylesheet" type="text/css" href="../EasyUI/themes/default/easyui.css">
    <link rel="stylesheet" type="text/css" href="../EasyUI/themes/color.css" />
    <link rel="stylesheet" type="text/css" href="../EasyUI/themes/icon.css" />  
<script type="text/javascript" src="../js/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="../Js/JsCookies.js"></script> 
    <script type="text/javascript" src="../Js/JsBase64.js"></script>  
    <script type="text/javascript" src="../EasyUI/jquery.easyui.min.js"></script>     <script type="text/javascript" src="../Js/GenerageGuid.js"></script>     
    
</head>
<body  oncontextmenu="return false" id="bodyLayout" class="easyui-layout" style="overflow-y: hidden; scroll:no">
    <div region="north" split="false" border="false" style="overflow: hidden; height: 30px;
        background: url(../Img/layout-browser-hd-bg.gif) #7f99be repeat-x center 50%;
        line-height: 20px;color: #fff; font-family: Verdana, 微软雅黑,黑体">
        <span style="float:right; padding-right:20px;" class="head">
        <% =Resources.Lan.User %> <% = sUserName%><span style="color:#E0ECFF; font-weight:bold "> /</span> <%--<a href="#;" id="editpass">修改密码</a> <span style="color:#E0ECFF; font-weight:bold "> / </span>--%><a href="javascript:JsExit();" id="loginOut"><% =Resources.Lan.Exit  %></a></span>
        <span style="padding-left:10px; font-size: 16px; "><img src="../Img/blocks.gif" width="20" height="20" align="absmiddle" /> <% =Resources.Lan.BackEnd %></span>
	    <form id="formcs" runat="server">
	        <div style="display:none">
                <asp:Button ID="btnClearSessionCS" Height="0" Width="0" runat="server" Text="" OnClick="btnClearSessionCS_Click" />
            </div>
        </form>
    </div>
    <div id="mainMax" region="center" style="background: #eee; overflow-y:hidden">
        <div class="easyui-layout" id="CenterMaxLayout" style="width:100%;height:100%;">            
            <div region="north" split="false" border="true" style="overflow: hidden; height: 35px;color: #fff; font-family: Verdana, 微软雅黑,黑体; ">
                <div style="height:35px; margin:3px;">
                    <a id="btnAdd" href="javascript:MenuAdd();" class="easyui-linkbutton" data-options="iconCls:'icon-add',disabled:true"><% =Resources.Lan.Add %></a>
                    <a id="btnAddChild" href="javascript:MenuAddChild();" class="easyui-linkbutton" data-options="iconCls:'icon-add',disabled:true"><% =Resources.Lan.AddChildGroup %></a>
                    <a id="btnModify" href="javascript:MenuModify();" class="easyui-linkbutton" data-options="iconCls:'icon-edit',disabled:true"><% =Resources.Lan.Modify %></a>
                    <a id="btnDel" href="javascript:MenuDel();" class="easyui-linkbutton" data-options="iconCls:'icon-no',disabled:true"><% =Resources.Lan.Del %></a>
                    <a id="btnRecycleMng" href="javascript:MenuRecycle();" class="easyui-linkbutton" data-options="iconCls:'icon-recycle'"><% =Resources.Lan.RecycleBinManagement %></a>
                </div>
            </div>        
        
            <%--车辆列表--%>
            <div region="west" split="true" title="<% =Resources.Lan.InformationBar  %>" style="width:255px;" id="west">
                <div id="tabNavigation" class="easyui-tabs" data-options="onSelect:VehonSelect" tabPosition="bottom" fit="true" border="false" >
		            <div title="<% =Resources.Lan.List %>" style="overflow:auto; height:100%"><%--style="overflow:hidden;"--%>
			      <table id="tgVeh" class="easyui-treegrid" style="height:100%"
			                data-options="
				                <%--url: 'treegrid_data1.json',--%>
				                method: 'get',
				                lines: false,
				                rownumbers: false,
				                idField: 'id',
				                treeField: 'name',
				                singleSelect: true,
				                onBeforeExpand :treeonBeforeLoad,
				                onContextMenu: onVehMenu,
				                onClickRow: treeonClickRow
			                ">
		                <thead>
			                <tr>
				                <th data-options="field:'name'" width="220px"><% =Resources.Lan.TeamOrPlate%></th>
				            </tr>
		                </thead>
	                </table>
		      </div>
		        </div>    
            </div>
            <div id="mainPanle" region="center" style="background: #eee; overflow-y:hidden">
            <div class="easyui-layout" id="CenterLayout" style="width:100%;height:100%;">
                <%-- 内容中间--%>
                <div id="tabs" class="easyui-tabs" fit="true" border="false" >
		        </div>
		    </div>
         </div>
        </div>
    </div>
    <%--底部--%>
    <div region="south" split="true" style="height: 30px; background: #D2E0F2; ">
        <div id="divState" style="float:left; color: red;line-height: 23px;font-weight: bold;"></div><%--color: #15428B;--%>
        <div class="footer" style="position:absolute; left:0; width:100%">©2016</div>
    </div>
    <div id="MenuRight" class="easyui-menu unselectable" >
		<div id="RightAdd" onclick="MenuAdd();" data-options="iconCls:'icon-add'"><% =Resources.Lan.Add %></div>
		<div id="RightModify" onclick="MenuModify();" data-options="iconCls:'icon-edit'"><% =Resources.Lan.Modify%></div>
		<div id="RightDel" onclick="MenuDel();" data-options="iconCls:'icon-no'"><% =Resources.Lan.Del %></div>
		    
	</div>
    
<script type="text/javascript">    
    function InitVehAndGroup(tabTitle)
    {
        var sContent = $('#tabs').tabs('getTab',tabTitle).panel('options').content;
	    var iFrame = $(sContent).find("iframe");
	    window.frames[iFrame[0].name].InitVehAndGroup(jsonVehGroup, jsonVehs);
    }
    
    function GetUserGroup()
    {
        return jsonUserGroup;
    }
    
    function UpdateTree(DoType, row)
    {
        try
        {
            switch(DoType)
            {
                case "VehGroup":
                    if(row.DoType == "0") //更新车组
                    {
                        $.each(jsonVehGroup,function(i,value){
                            if(value.id == row.GroupID)
                            {
                                value.name = row.Name;  
                                $('#tgVeh').treegrid('update',{
    	                            id: value.id,
    	                            row: {
    		                            name: value.name,
    		                            iconCls: 'icon-team'
    	                            }
                                });
                                var addPID = row.PID;
                                var addRoot = 0;
                                if(addPID == "T_Veh")
                                {
                                    addPID = "G-1";
                                    addRoot = 1;
                                }
                                value.Root = addRoot;    
                                if(value.PID != addPID)
                                {
                                    value.PID = addPID;
                                    var n2 = $("#tgVeh").treegrid("pop",value.id);  
                                    n2._parentId = row.PID;
                                    $("#tgVeh").treegrid("append",{parent: row.PID,data:[n2]});
                                }
                                return false;
                            }
                        });
                    }
                    else if(row.DoType == "1")
                    {
                        var addPID = row.PID;
                        var addRoot = 0;
                        if(addPID == "T_Veh")
                        {
                            addPID = "G-1";
                            addRoot = 1;
                        }
                        else
                        {
                            var bExists = false;
                            $.each(jsonVehGroup,function(i,value){
                                if(value.id == addPID)
                                {
                                    bExists = true;
                                    return false;
                                }
                            });
                            if(!bExists)
                            {
                                addPID = "G-1";    
                                addRoot = 1;                            
                            }
                        }                
                        var AddItem = {"id":row.GroupID,"name":row.Name,"PID":addPID,"HasChild":0,"Root":addRoot};
                        jsonVehGroup.push(AddItem);
                        var aaJson =new Array();
                        var rowUserGroup = { id: AddItem.id, name: AddItem.name, state: '', cid: '', iconCls: "icon-team" , _parentId: row.PID };
                        aaJson.push(rowUserGroup);
                        $("#tgVeh").treegrid("append",{parent: row.PID,data:aaJson});                        
                    }
                    break;
                case "Vehicle":
                    if(row.DoType == "0") //更新车辆
                    {
                        $.each(jsonVehs,function(i,value){
                            if(value.id == row.ID)
                            {
                                value.name = row.Name;
                                $('#tgVeh').treegrid('update',{
    	                            id: value.id,
    	                            row: {
    		                            name: value.name,
    		                            iconCls: 'icon-offine'
    	                            }
                                });  
                                if(value.PID != row.PID)
                                {
                                    $.each(jsonVehGroup,function(j,valuej){
                                        if(valuej.id == row.PID)
                                        {
                                            value.team = valuej.name;
                                            return false;
                                        }
                                    });
                                    value.PID = row.PID;
                                    var n2 = $("#tgVeh").treegrid("pop",value.id);  
                                    n2._parentId = row.PID;
                                    $("#tgVeh").treegrid("append",{parent: row.PID,data:[n2]});
                                }
                                return false;
                            }
                        });
                    }
                    else if(row.DoType == "1")
                    {
                        var addPID = row.PID;   
                        $.each(jsonVehGroup,function(j,valuej){
                            if(valuej.id == row.PID)
                            {
                                row.team = valuej.name;
                                return false;
                            }
                        });      
                        var AddItem = {"id":row.ID,"name":row.Name,"PID":addPID,"customid":row.customid,"ipaddress":row.ipaddress,"sim":row.sim,"taxino":row.taxino,"team":row.team};
                        jsonVehs.push(AddItem);
                        var aaJson =new Array();
                        var rowUserGroup = { id: AddItem.id, name: AddItem.name, state: '', cid: '', iconCls: "icon-offine" , _parentId: row.PID };
                        aaJson.push(rowUserGroup);
                        $("#tgVeh").treegrid("append",{parent: row.PID,data:aaJson});                        
                    }
                    break;
                case "UserGroup":
                    if(row.DoType == "0") //更新用户组
                    {
                        $.each(jsonUserGroup,function(i,value){
                            if(value.id == row.ID)
                            {
                                value.name = row.Name;
                                $('#tgVeh').treegrid('update',{
    	                            id: value.id,
    	                            row: {
    		                            name: value.name,
    		                            iconCls: 'icon-usermng'
    	                            }
                                });  
                                return false;
                            }
                        });
                    }
                    else if(row.DoType == "1")//添加 
                    {   
                        var AddItem = {"id":row.ID,"name":row.Name,"PID":row.PID,"HasChild":0,"Root":0};
                        jsonUserGroup.push(AddItem);
                        var aaJson =new Array();
                        var rowUserGroup = { id: AddItem.id, name: AddItem.name, state: '', cid: '', iconCls: "icon-usermng" , _parentId: row.PID };
                        aaJson.push(rowUserGroup);
                        $("#tgVeh").treegrid("append",{parent: row.PID,data:aaJson});                        
                    }
                    break;
                case "User":
                    if(row.DoType == "0") //更新用户
                    {
                        $.each(jsonUser,function(i,value){
                            if(value.id == row.ID)
                            {
                                value.name = row.Name;
                                $('#tgVeh').treegrid('update',{
    	                            id: value.id,
    	                            row: {
    		                            name: value.name,
    		                            iconCls: 'icon-user'
    	                            }
                                });
                                var addPID = row.PID;
//                                value.Root = addRoot;    
                                if(value.PID != addPID)
                                {
                                    value.PID = addPID;
                                    var n2 = $("#tgVeh").treegrid("pop",value.id);  
                                    n2._parentId = row.PID;
                                    $("#tgVeh").treegrid("append",{parent: row.PID,data:[n2]});
                                }  
                                return false;
                            }
                        });
                    }
                    else if(row.DoType == "1")//添加 
                    {   
                        var AddItem = {"id":row.ID,"name":row.Name,"PID":row.PID,"HasChild":0};
                        jsonUser.push(AddItem);
                        var aaJson =new Array();
                        var rowUserGroup = { id: AddItem.id, name: AddItem.name, state: '', cid: '', iconCls: "icon-user" , _parentId: row.PID };
                        aaJson.push(rowUserGroup);
                        $("#tgVeh").treegrid("append",{parent: row.PID,data:aaJson});                        
                    }
                    break;
            }
        }
        catch(e)
        {
            
        }
        try
        {
            //资料中心同步
            connectSocketServer();
        }
        catch(e)
        {
        
        }
    } 
    
    function connectSocketServer() {
        var support = "MozWebSocket" in window ? 'MozWebSocket' : ("WebSocket" in window ? 'WebSocket' : null);

        if (support == null) {
            $("#divState").text("<% =Resources.Lan.BrowserNotSupport %>");
            return;
        }

        $("#divState").text("<% =Resources.Lan.ConnectingServer %>");
        // create a new websocket and connect
        ws = new window[support]('<% =ConfigurationManager.AppSettings["WebPort"] %>');
        ws.onmessage = function (evt) {
            
        };

        // when the connection is established, this method is called
        ws.onopen = function () {
            $("#divState").text("<% =Resources.Lan.SuccessfulConnectionCenter %>");
            var sUserName = GetCookie("username");
            var sPwd = GetCookie("pwd");
            if(sUserName == undefined || sPwd == undefined)
            {
                $("#divState").text("<% =Resources.Lan.PleaseLogin %>");
                return;
            }
            var sLogin = "[{'key':'1_3','ver':1,'rows':1,'cols':2,data:[{'name':'" + sUserName + "','pwd':'" + sPwd + "','type':96}]}]";
            ws.send(sLogin);
        };

        // when the connection is closed, this method is called
        ws.onclose = function () {
            $("#divState").text('<% =Resources.Lan.SynComplete %>');
        }
    }
    
    var arrErr = new Array();
    arrErr.push({ "key": "4001","value":"<% =Resources.Lan.EnterAccountAndPassword %>"});
    arrErr.push({ "key": "4002","value":"<% =Resources.Lan.NotEnterIllegalCharacters %>"});
    arrErr.push({ "key": "4004","value":"<% =Resources.Lan.AccountNotExist %>"});
    arrErr.push({ "key": "4005","value":"<% =Resources.Lan.AccountOverdue %>"});
    arrErr.push({ "key": "4006","value":"<% =Resources.Lan.UnknownError %>"});
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
    
        function OpenInfo(info)
        {
            var data = "<div>" + info + "</div>";
//            $("#dlgInfo").html("<p>" + info + "</p>");
//            $("#dlg1").dialog('open').dialog('center');
               $.messager.alert('<% =Resources.Lan.Prompt %>',data,'question');
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
    
    //-------------------------------功能区------------------------------------------
    function MenuAdd()
    {
        var rows = $("#tgVeh").treegrid('getSelections');
        if(rows == undefined || rows.length == 0)
        {
            return;
        }
        if(rows[0].id[0] == 'G')
        {
            var pid = rows[0].id;
            if(pid != undefined && pid.length > 0)
            {
                pid = pid.substring(1);
            }
            else
            {
                pid = "-1";
            }
            addTab("<% =Resources.Lan.VehicleMng %>","Forms/Vehicle.aspx?dotype=1&pid=" + pid + "&k=" + m_k);
            
        }
        else if(rows[0].id[0] == 'U')
        {
            var pid = rows[0].id;
            if(pid != undefined && pid.length > 0)
            {
                pid = pid.substring(1);
            }
            else
            {
                return;
            }
            addTab("<% =Resources.Lan.UserMng %>","Forms/User.aspx?dotype=1&pid=" + pid + "&utype=" + iUserType);
            
        }
        else if(rows[0].id == "T_Veh")
        {
             addTab("<% =Resources.Lan.VehGroupMng %>","Forms/VehGroup.aspx?dotype=1");
        }
        else if(rows[0].id == "M_User")
        {
             addTab("<% =Resources.Lan.UserGroup %>","Forms/UserGroup.aspx?dotype=1");
        }
    }
    
    function MenuAddChild()
    {
        var rows = $("#tgVeh").treegrid('getSelections');
        if(rows == undefined || rows.length == 0)
        {
            return;
        }
        if(rows[0].id == "T_Veh" || rows[0].id[0] == 'G')
        {
            if(rows[0].id[0] == 'G')
            {
                var pid = rows[0]._parentId;
                if(pid != undefined && pid.length > 0)
                {
                    pid = pid.substring(1);
                }
                else
                {
                    pid = "-1";
                }
                addTab("<% =Resources.Lan.VehGroupMng %>","Forms/VehGroup.aspx?dotype=1&id=" + rows[0].id.substring(1) + "&pid=" + pid);
            }
            else
            {
                addTab("<% =Resources.Lan.VehGroupMng %>","Forms/VehGroup.aspx?dotype=1");
            }
        }
    }
    
    function MenuModify()
    {
        var rows = $("#tgVeh").treegrid('getSelections');
        if(rows == undefined || rows.length == 0)
        {
            return;
        }
        if(rows[0].id[0] == 'G')
        {
            var pid = rows[0]._parentId;
            if(pid == "T_Veh")
            {
                pid = "-1";
            }
            else if(pid != undefined && pid.length > 0)
            {
                pid = pid.substring(1);
            }
            else
            {
                pid = "-1";
            }
            addTab("<% =Resources.Lan.VehGroupMng %>","Forms/VehGroup.aspx?dotype=0&&id=" + rows[0].id.substring(1) + "&pid=" + pid);
        }        
        else if(rows[0].id[0] == 'V')
        {
            var id = rows[0].id;
            if(id != undefined && id.length > 0)
            {
                id = id.substring(1);
            }
            else
            {
                return;
            }
            var pid = rows[0]._parentId;
            if(pid != undefined && pid.length > 0)
            {
                pid = pid.substring(1);
            }
            else
            {
                return;
            }
            addTab("<% =Resources.Lan.VehicleMng %>","Forms/Vehicle.aspx?dotype=0&id=" + id + "&pid=" + pid + "&oldName=" + rows[0].name + "&k=" + m_k);
            
        }
        else if(rows[0].id[0] == "U")
        {
            var id = rows[0].id;
            if(id != undefined && id.length > 0)
            {
                id = id.substring(1);
            }
            else
            {
                return;
            }
             addTab("<% =Resources.Lan.UserGroup %>","Forms/UserGroup.aspx?dotype=0&id=" + id);
        }     
        else if(rows[0].id[0] == 'R')
        {
            var id = rows[0].id;
            if(id != undefined && id.length > 0)
            {
                id = id.substring(1);
            }
            else
            {
                return;
            }
            var pid = rows[0]._parentId;
            if(pid != undefined && pid.length > 0)
            {
                pid = pid.substring(1);
            }
            else
            {
                return;
            }
            addTab("<% =Resources.Lan.UserMng %>","Forms/User.aspx?dotype=0&id=" + id + "&pid=" + pid + "&oldName=" + rows[0].name + "&utype=" + iUserType);
            
        }
    }
   
    function MenuDel()
    {
        var rows = $("#tgVeh").treegrid('getSelections');
        if(rows == undefined || rows.length == 0)
        {
            return;
        }
        if(rows[0].id[0] == 'G')
        {
            var sGroupID = rows[0].id.substring(1);
            var sName = rows[0].name;
            $.messager.defaults.ok = "<% =Resources.Lan.Confirm %>";  
            $.messager.defaults.cancel = "<% =Resources.Lan.Cancel %>";
            //$.messager.defaults = { ok: "<% =Resources.Lan.Confirm %>", cancel: "<% =Resources.Lan.Cancel %>" }; 
            $.messager.confirm('<% =Resources.Lan.Prompt %>', '<% =Resources.Lan.Del %> <% =Resources.Lan.Team %>', function(r){
			    if (r){
				    try
                    {
                        var sUserName = GetCookie("m_username");
                        var sPwd = GetCookie("m_pwd");
                        $.ajax({
                            url: "../Ashx/MngVehGroup.ashx",
                            cache:false,
                            type:"post",
                            dataType:'json',
                            async:true, 
                            data:{username:sUserName,Pwd:sPwd,GroupName:sName,Contact:'1',DoType:2,GroupID:sGroupID,Pid:0,Tel1:'',Tel2:'',Marks:'',OldName:''},
                            success:function(data){
                                    if(data.result)
                                    {                                        
                                        $.messager.alert('<% =Resources.Lan.Prompt %>','<% =Resources.Lan.Successful %>');
                                        for(var i=0;i<jsonVehGroup.length;i++)
                                        {
                                            if(jsonVehGroup[i].id == "G" + sGroupID)
                                            {
                                                jsonVehGroup.splice(i,1);
                                                break;
                                            }
                                        }
                                        DelVehGroup("G" + sGroupID);
                                        $("#tgVeh").treegrid("remove","G" + sGroupID);
                                    }
                                    else
                                    {
                                        $.messager.alert('<% =Resources.Lan.Prompt %>','<% =Resources.Lan.Fault %>');
                                    }
                            },
                            error: function(e) { 
                                $.messager.alert('<% =Resources.Lan.Prompt %>',e.responseText);
                            } 
                        }) ;   
                    }
                    catch(e)
                    {}
			    }
			});
        }
        else if(rows[0].id[0] == 'V')
        {
            var sID = rows[0].id.substring(1);
            var sName = rows[0].name;
            $.messager.defaults.ok = "<% =Resources.Lan.Confirm %>";  
            $.messager.defaults.cancel = "<% =Resources.Lan.Cancel %>";
            //$.messager.defaults = { ok: "<% =Resources.Lan.Confirm %>", cancel: "<% =Resources.Lan.Cancel %>" }; 
            $.messager.confirm('<% =Resources.Lan.Prompt %>', '<% =Resources.Lan.Del %> <% =Resources.Lan.Vehicle %>', function(r){
			    if (r){
				    try
                    {
                        var sUserName = GetCookie("m_username");
                        var sPwd = GetCookie("m_pwd");
                        $.ajax({
                            url: "../Ashx/MngVehicle.ashx",
                            cache:false,
                            type:"post",
                            dataType:'json',
                            async:true, 
                            data:{username:sUserName,Pwd:sPwd,Name:sName,DoType:2,ID:sID},
                            success:function(data){
                                    if(data.result)
                                    {                                        
                                        $.messager.alert('<% =Resources.Lan.Prompt %>','<% =Resources.Lan.Successful %>');
                                        for(var i=0;i<jsonVehs.length;i++)
                                        {
                                            if(jsonVehs[i].id == "V" + sID)
                                            {
                                                jsonVehs.splice(i,1);
                                                break;
                                            }
                                        }
                                        $("#tgVeh").treegrid("remove","V" + sID);
                                    }
                                    else
                                    {
                                        $.messager.alert('<% =Resources.Lan.Prompt %>','<% =Resources.Lan.Fault %>');
                                    }
                            },
                            error: function(e) { 
                                $.messager.alert('<% =Resources.Lan.Prompt %>',e.responseText);
                            } 
                        }) ;   
                    }
                    catch(e)
                    {}
			    }
			});
        }
        else if(rows[0].id[0] == 'U')
        {
            var sID = rows[0].id.substring(1);
            var sName = rows[0].name;
            $.messager.defaults.ok = "<% =Resources.Lan.Confirm %>";  
            $.messager.defaults.cancel = "<% =Resources.Lan.Cancel %>";
            //$.messager.defaults = { ok: "<% =Resources.Lan.Confirm %>", cancel: "<% =Resources.Lan.Cancel %>" }; 
            $.messager.confirm('<% =Resources.Lan.Prompt %>', '<% =Resources.Lan.Del %> <% =Resources.Lan.UserGroup %>', function(r){
			    if (r){
				    try
                    {
                        var sUserName = GetCookie("m_username");
                        var sPwd = GetCookie("m_pwd");
                        $.ajax({
                            url: "../Ashx/MngUserGroup.ashx",
                            cache:false,
                            type:"post",
                            dataType:'json',
                            async:true, 
                            data:{username:sUserName,Pwd:sPwd,Name:sName,DoType:2,ID:sID},
                            success:function(data){
                                    if(data.result)
                                    {                                        
                                        $.messager.alert('<% =Resources.Lan.Prompt %>','<% =Resources.Lan.Successful %>');
                                        for(var i=0;i<jsonUserGroup.length;i++)
                                        {
                                            if(jsonUserGroup[i].id == "U" + sID)
                                            {
                                                jsonUserGroup.splice(i,1);
                                                break;
                                            }
                                        }
                                        for(var i=0;i<jsonUser.length;i++)
                                        {
                                            if(jsonUser[i].PID == "U" + sID)
                                            {
                                                jsonUser.splice(i,1);
                                                i = i - 1;
                                            }
                                        }
                                        $("#tgVeh").treegrid("remove","U" + sID);
                                    }
                                    else
                                    {
                                        $.messager.alert('<% =Resources.Lan.Prompt %>','<% =Resources.Lan.Fault %>');
                                    }
                            },
                            error: function(e) { 
                                $.messager.alert('<% =Resources.Lan.Prompt %>',e.responseText);
                            } 
                        }) ;   
                    }
                    catch(e)
                    {}
			    }
			});
        }
        else if(rows[0].id[0] == 'R')
        {
            var sID = rows[0].id.substring(1);
            var sName = rows[0].name;
            $.messager.defaults.ok = "<% =Resources.Lan.Confirm %>";  
            $.messager.defaults.cancel = "<% =Resources.Lan.Cancel %>";
            //$.messager.defaults = { ok: "<% =Resources.Lan.Confirm %>", cancel: "<% =Resources.Lan.Cancel %>" }; 
            $.messager.confirm('<% =Resources.Lan.Prompt %>', '<% =Resources.Lan.Del %> <% =Resources.Lan.User2 %>', function(r){
			    if (r){
				    try
                    {
                        var sUserName = GetCookie("m_username");
                        var sPwd = GetCookie("m_pwd");
                        $.ajax({
                            url: "../Ashx/MngUser.ashx",
                            cache:false,
                            type:"post",
                            dataType:'json',
                            async:true, 
                            data:{username:sUserName,Pwd:sPwd,Name:sName,NewPwd:'1',DoType:2,ID:sID,UserGroupID:'0',CompanyName:'',Tel:'',AccountType:'3',ExpirationTime:'2017-01-13 00:00:01',OldName:sName,Permission:'',Groups:'1'},
                            success:function(data){
                                    if(data.result)
                                    {                                        
                                        $.messager.alert('<% =Resources.Lan.Prompt %>','<% =Resources.Lan.Successful %>');
                                        for(var i=0;i<jsonUser.length;i++)
                                        {
                                            if(jsonUser[i].id == "R" + sID)
                                            {
                                                jsonUser.splice(i,1);
                                                break;
                                            }
                                        }
                                        $("#tgVeh").treegrid("remove","R" + sID);
                                    }
                                    else
                                    {
                                        $.messager.alert('<% =Resources.Lan.Prompt %>','<% =Resources.Lan.Fault %>');
                                    }
                            },
                            error: function(e) { 
                                $.messager.alert('<% =Resources.Lan.Prompt %>',e.responseText);
                            } 
                        }) ;   
                    }
                    catch(e)
                    {}
			    }
			});
        }
    }
    
    function MenuRecycle()
    {
        addTab("<% =Resources.Lan.RecycleBinManagement %>","Forms/RecycleMng.aspx?UserType=" + iUserType);
    }
    
    function DelVehGroup(pid)
    {
        DelVehFromGroup(pid);
        var arrID =new Array();
        for(var i=0;i<jsonVehGroup.length;i++)
        {
            if(jsonVehGroup[i].PID == pid)
            {
                arrID.push(jsonVehGroup[i].id);
                DelVehFromGroup(jsonVehGroup[i].id);
                jsonVehGroup.splice(i,1);
            }
        }
        for(var i=0;i<arrID.length;i++)
        {
            DelVehGroup(arrID[i]);
        }
    }
    
    function DelVehFromGroup(gid)
    {
        for(var i=0;i<jsonVehs.length;i++)
        {
            if(jsonVehs[i].GID == gid)
            {
                jsonVehs.splice(i,1);
            }
        }
    }
    
    function JsExit()
    {
        $("#btnClearSessionCS")[0].click();
    }
    
    function VehonSelect(title,index)
        {
            if(index == 1)
            {
                var row = $('#tgVeh').datagrid('getSelected');  
                if(row == undefined )
                {
//                    $("#tableVehDetail").datagrid('loadData',[{'name':'<% =Resources.Lan.Tip %>','value':'<% =Resources.Lan.NoVeh %>'}]);

                }
                else
                {
                    if(row.id[0] == 'G')
                    {
//                        $("#tableVehDetail").datagrid('loadData',[{'name':'<% =Resources.Lan.Tip %>','value':'<% =Resources.Lan.NoVeh %>'}]);
                    }
                    else
                    {
                        var iDoType = 2;
                        var sLoginType = GetCookie("m_logintype");
                        if(sLoginType == "2")
                        {
                            iDoType = 4;
                        }
//                        $("#tableVehDetail").datagrid('loadData',[{}]);
                        var sUserName = GetCookie("m_username");
                        var sPwd = GetCookie("m_pwd");
                        $.ajax({
                            url: "Ashx/Vehicle.ashx",
                            cache:false,
                            type:"post",
                            dataType:'json',
                            async:true, 
                            data:{username:sUserName,Pwd:sPwd,doType:iDoType,ID:row.id.substring(1)},
                            success:function(data){
                                    if(data.result == "true")
                                    {
//                                          $.each(data.data,function(i,value)
//                                          {
//                                            value.name = GetArrVehDetail(value.name);
//                                          });
//                                          $("#tableVehDetail").datagrid('loadData',data.data);
                                    }
                                    else
                                    {
	                                       $("#divState").text(GetErr(data.err));
                                    }
                            },
                            error: function(e) { 
	                             $("#divState").text(e.responseText);
                            } 
                        }) ;
                    }
                }
            }
        }
        
        var bIsRightKey = 1;
        function treeonClickRow(row)
        {
            $('#btnAdd').find('.l-btn-text').html("<% =Resources.Lan.Add %>")
            if(row.id != 'M_User' && row.id != 'T_Veh' && bIsRightKey == 1)
            {
                MenuModify();
            }
            bIsRightKey = 1;
            if(row.id == 'M_User')
            {
                if(iUserType == 1)
                {
                    $('#btnAdd').linkbutton('enable');
                    $('#btnAdd').attr('href', 'javascript:MenuAdd();');
                    $('#MenuRight').menu('enableItem', $('#RightAdd'));
                    $('#RightAdd').show();
                }
                else
                {
                    $('#btnAdd').linkbutton('disable');
                    $('#MenuRight').menu('disableItem', $('#RightAdd'));
                    $('#RightAdd').hide();
                }
                $('#btnModify').linkbutton('disable');
                $('#btnDel').linkbutton('disable');
                $('#btnAddChild').linkbutton('disable');
                $('#MenuRight').menu('disableItem', $('#RightModify'));
                $('#RightModify').hide();
                $('#MenuRight').menu('disableItem', $('#RightDel'));
                $('#RightDel').hide();
            }
            else if(row.id == 'T_Veh')
            {
                $('#btnAdd').linkbutton('enable');
                $('#btnAdd').attr('href', 'javascript:MenuAdd();');
                $('#btnModify').linkbutton('disable');
                $('#btnDel').linkbutton('disable');
                $('#btnAddChild').linkbutton('disable');
                $('#MenuRight').menu('enableItem', $('#RightAdd'));
                $('#RightAdd').show();
                $('#MenuRight').menu('disableItem', $('#RightModify'));
                $('#RightModify').hide();
                $('#MenuRight').menu('disableItem', $('#RightDel'));
                $('#RightDel').hide();
            }
            else if(row.id[0] == 'U')
            {
                $('#btnAdd').linkbutton('enable');
                $('#btnAdd').attr('href', 'javascript:MenuAdd();');
                $('#btnModify').linkbutton('enable');
                $('#btnModify').attr('href', 'javascript:MenuModify();');
                $('#btnDel').linkbutton('enable');
                $('#btnDel').attr('href', 'javascript:MenuDel();');
                $('#btnAddChild').linkbutton('disable');
                $('#MenuRight').menu('enableItem', $('#RightAdd'));
                $('#RightAdd').show();
                $('#MenuRight').menu('enableItem', $('#RightModify'));
                $('#RightModify').show();
                $('#MenuRight').menu('enableItem', $('#RightDel'));
                $('#RightDel').show();
            }
            else if(row.id[0] == 'R')
            {
                $('#btnAdd').linkbutton('disable');
                $('#btnModify').linkbutton('enable');
                $('#btnModify').attr('href', 'javascript:MenuModify();');
                $('#btnDel').linkbutton('enable');
                $('#btnDel').attr('href', 'javascript:MenuDel();');
                $('#btnAddChild').linkbutton('disable');
                $('#MenuRight').menu('disableItem', $('#RightAdd'));
                $('#RightAdd').hide();
                $('#MenuRight').menu('enableItem', $('#RightModify'));
                $('#RightModify').show();
                $('#MenuRight').menu('enableItem', $('#RightDel'));
                $('#RightDel').show();
            }
            else if(row.id[0] == 'G')
            {
                $('#btnAdd').linkbutton('enable');
                $('#btnAdd').attr('href', 'javascript:MenuAdd();');
                $('#btnAdd').find('.l-btn-text').html("<% =Resources.Lan.AddVehicle %>")
                $('#btnModify').linkbutton('enable');
                $('#btnModify').attr('href', 'javascript:MenuModify();');
                $('#btnDel').linkbutton('enable');
                $('#btnDel').attr('href', 'javascript:MenuDel();');
                $('#btnAddChild').linkbutton('enable');
                $('#btnAddChild').attr('href', 'javascript:MenuAddChild();');
                $('#MenuRight').menu('enableItem', $('#RightAdd'));
                $('#RightAdd').show();
                $('#MenuRight').menu('enableItem', $('#RightModify'));
                $('#RightModify').show();
                $('#MenuRight').menu('enableItem', $('#RightDel'));
                $('#RightDel').show();
            }
            else if(row.id[0] == 'V')
            {
                $('#btnAdd').linkbutton('disable');
                $('#btnModify').linkbutton('enable');
                $('#btnModify').attr('href', 'javascript:MenuModify();');
                $('#btnDel').linkbutton('enable');
                $('#btnAddChild').linkbutton('disable');
                $('#MenuRight').menu('disableItem', $('#RightAdd'));
                $('#RightAdd').hide();
                $('#MenuRight').menu('enableItem', $('#RightModify'));
                $('#RightModify').show();
                $('#MenuRight').menu('enableItem', $('#RightDel'));
                $('#RightDel').show();
            }
            else
            {
                $('#btnAdd').linkbutton('disable');
                $('#btnModify').linkbutton('disable');
                $('#btnDel').linkbutton('disable');
                $('#btnAddChild').linkbutton('disable');
                $('#MenuRight').menu('disableItem', $('#RightAdd'));
                $('#RightAdd').hide();
                $('#MenuRight').menu('disableItem', $('#RightModify'));
                $('#RightModify').hide();
                $('#MenuRight').menu('disableItem', $('#RightDel'));
                $('#RightDel').hide();
            }
        }
        
        function treeonBeforeLoad(row)
        {
            if($("#tgVeh").treegrid("getChildren",row.id).length == 0)
            {
                    var attchJson = new Array();
                    if(row.id[0] == 'G')
                    {
                        $.each(jsonVehs,function(i,value){
                            if(value.GID == row.id)
                            {
                                var rowVeh = { id: value.id, team: value.team, name: value.name, iconCls: "icon-offine", _parentId: value.GID };
                                attchJson.push(rowVeh);
                            }
                        });
                    }
                    else
                    {
                        $.each(jsonUser,function(i,value){
                            if(value.PID == row.id)
                            {
                                var rowUserGroup = { id: value.id, name: value.name, state: '', cid: '', iconCls: "icon-user" , _parentId: value.PID };
                                attchJson.push(rowUserGroup);
                            }
                        });
                    }
                    if(attchJson.length > 0)
                    {
                        $('#tgVeh').treegrid('append',{
	                        parent: row.id,  // the node has a 'id' value that defined through 'idField' property
	                        data: attchJson
                        });
                    }
            }
            else
            {
                var bAdd = false;
                if(row.id == "T_Veh" || row.id == "M_User")
                {
                    return;
                }
                var bVeh = true;
                $.each($("#tgVeh").treegrid("getChildren",row.id), function(i, value){
                    if(value.id[0] == "V")
                    {
                        bAdd = true;
                        bVeh = true;
                        return false;
                    }
                    else if(value.id[0] == "U")
                    {
                        bAdd = true;
                        bVeh = false;
                        return false;
                    }
                });
                if(!bAdd)
                {
                    var attchJson = new Array();
                    if(bVeh)
                    {
                        $.each(jsonVehs,function(i,value){
                            if(value.GID == row.id)
                            {
                                var rowVeh = { id: value.id, name: value.name,team: value.team, iconCls: "icon-offine", _parentId: value.GID };
                                attchJson.push(rowVeh);
                            }
                        });
                    }
                    else
                    {
                        $.each(jsonUser,function(i,value){
                            if(value.PID == row.id)
                            {
                                var rowUserGroup = { id: value.id, name: value.name, state: '', cid: '', iconCls: "icon-user" , _parentId: value.PID };
                                attchJson.push(rowUserGroup);
                            }
                        });
                    }
                    if(attchJson.length > 0)
                    {
                        $('#tgVeh').treegrid('append',{
	                        parent: row.id,  // the node has a 'id' value that defined through 'idField' property
	                        data: attchJson
                        });
                    }
                }
            }
        }
        
        function onVehMenu(e,row){
			e.preventDefault();
			bIsRightKey = 2;
			if(e.button == 1)
			{
			    bIsRightKey = 1;
			}
            var rows = $(this).treegrid('getSelections');
            if(rows == undefined)
            {
                $(this).treegrid('select', row.id);
            }
            else if(rows.length == 0)
            {
                $(this).treegrid('select', row.id);
            }
            else
            {
                var bExist = false;
                for(var i = 0; i < rows.length; i++)
                {
                    if(rows[i].id == row.id)
                    {
                        bExist = true;
                        break;
                    }
                }
                if(!bExist)
                {
                    $(this).treegrid('select', row.id);
                }
            }
            treeonClickRow(row);
            $('#MenuRight').menu('show',{
			    left: e.pageX,
			    top: e.pageY
			});
		}
		
        function addTab(subtitle,url){
            try
            {
	            if(!$('#tabs').tabs('exists',subtitle)){
		            $('#tabs').tabs('add',{
			            title:subtitle,
			            content:createFrame(url),
			            closable:true,
			            width:'100%',
			            height:'100%'
		            });
	            }else{
		            $('#tabs').tabs('select',subtitle);
		            var tab = $('#tabs').tabs('getSelected');  // get selected panel
                    $('#tabs').tabs('update', {
	                    tab: tab,
	                    options: {
		                    title: subtitle,
		                    content:createFrame(url),
			                closable:true,
			                width:'100%',
			                height:'100%'
	                    }
                    });
	            }
	            tabClose();
	        }
	        catch(e)
	        {}
        }
        
        
        function createFrame(url)
        {
//        name="mainFrame"
           var sGuid =  Guid.NewGuid();
            var s = '<div title="createFrame" style="overflow:hidden; height:100%; width:100%" >';
	        s = s + '<iframe name="' + sGuid.ToString("N") + '" scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe></div>';
	        return s;
        }
        
        function tabClose()
        {
	        /*双击关闭TAB选项卡*/
	        $(".tabs-inner").dblclick(function(){
		        var subtitle = $(this).children("span").text();
		        $('#tabs').tabs('close',subtitle);
	        })

	        $(".tabs-inner").bind('contextmenu',function(e){
		        $('#mm').menu('show', {
			        left: e.pageX,
			        top: e.pageY,
		        });
        		
		        var subtitle =$(this).children("span").text();
		        $('#mm').data("currtab",subtitle);
        		
		        return false;
	        });
        }
        //绑定右键菜单事件
        function tabCloseEven()
        {
	        //关闭当前
	        $('#mm-tabclose').click(function(){
		        var currtab_title = $('#mm').data("currtab");
		        $('#tabs').tabs('close',currtab_title);
	        })
	        //全部关闭
	        $('#mm-tabcloseall').click(function(){
		        $('.tabs-inner span').each(function(i,n){
			        var t = $(n).text();
			        $('#tabs').tabs('close',t);
		        });	
	        });
	        //关闭除当前之外的TAB
	        $('#mm-tabcloseother').click(function(){
		        var currtab_title = $('#mm').data("currtab");
		        $('.tabs-inner span').each(function(i,n){
			        var t = $(n).text();
			        if(t!=currtab_title)
				        $('#tabs').tabs('close',t);
		        });	
	        });
	        //关闭当前右侧的TAB
	        $('#mm-tabcloseright').click(function(){
		        var nextall = $('.tabs-selected').nextAll();
		        if(nextall.length==0){
			        //msgShow('系统提示','后边没有啦~~','error');
//			        ShowInfo('后边没有啦~~');
			        return false;
		        }
		        nextall.each(function(i,n){
			        var t=$('a:eq(0) span',$(n)).text();
			        $('#tabs').tabs('close',t);
		        });
		        return false;
	        });
	        //关闭当前左侧的TAB
	        $('#mm-tabcloseleft').click(function(){
		        var prevall = $('.tabs-selected').prevAll();
		        if(prevall.length==0){
//			        ShowInfo('到头了，前边没有啦~~');
			        return false;
		        }
		        prevall.each(function(i,n){
			        var t=$('a:eq(0) span',$(n)).text();
			        $('#tabs').tabs('close',t);
		        });
		        return false;
	        });

	        //退出
	        $("#mm-exit").click(function(){
		        $('#mm').menu('hide');
	        })
        }
        
        //绑定右键菜单事件
        function tabCloseEven()
        {
	        //关闭当前
	        $('#mm-tabclose').click(function(){
		        var currtab_title = $('#mm').data("currtab");
		        $('#tabs').tabs('close',currtab_title);
	        })
	        //全部关闭
	        $('#mm-tabcloseall').click(function(){
		        $('.tabs-inner span').each(function(i,n){
			        var t = $(n).text();
			        $('#tabs').tabs('close',t);
		        });	
	        });
	        //关闭除当前之外的TAB
	        $('#mm-tabcloseother').click(function(){
		        var currtab_title = $('#mm').data("currtab");
		        $('.tabs-inner span').each(function(i,n){
			        var t = $(n).text();
			        if(t!=currtab_title)
				        $('#tabs').tabs('close',t);
		        });	
	        });
	        //关闭当前右侧的TAB
	        $('#mm-tabcloseright').click(function(){
		        var nextall = $('.tabs-selected').nextAll();
		        if(nextall.length==0){
			        //msgShow('系统提示','后边没有啦~~','error');
//			        ShowInfo('后边没有啦~~');
			        return false;
		        }
		        nextall.each(function(i,n){
			        var t=$('a:eq(0) span',$(n)).text();
			        $('#tabs').tabs('close',t);
		        });
		        return false;
	        });
	        //关闭当前左侧的TAB
	        $('#mm-tabcloseleft').click(function(){
		        var prevall = $('.tabs-selected').prevAll();
		        if(prevall.length==0){
//			        ShowInfo('到头了，前边没有啦~~');
			        return false;
		        }
		        prevall.each(function(i,n){
			        var t=$('a:eq(0) span',$(n)).text();
			        $('#tabs').tabs('close',t);
		        });
		        return false;
	        });

	        //退出
	        $("#mm-exit").click(function(){
		        $('#mm').menu('hide');
	        })
        }
        
        //弹出信息窗口 title:标题 msgString:提示信息 msgType:信息类型 [error,info,question,warning]
        function msgShow(title, msgString, msgType) {
	        $.messager.alert(title, msgString, msgType);
        }
		
        var jsonVehGroup;
        var jsonVehs;
        var jsonUserGroup;
        var jsonUser;
        var iUserType;
        var m_k = "0";
        
		$(document).ready(function() { 
            var sUrl=location.search.toLowerCase();
            var sQuery=sUrl.substring(sUrl.indexOf("=")+1);
            re=/select|update|delete|truncate|join|union|exec|insert|drop|count|’|"|;|>|</i;
            if(re.test(sQuery))
            {
                OpenInfo("<% =Resources.Lan.NotEnterIllegalCharacters %>");
                location.href=sUrl.replace(sQuery,"");
            }
            $(".datagrid-header").hide();
//            tabClose();
//	        tabCloseEven();
//	        var sLan = "<% =Resources.Lan.Language  %>";//            addTab('<% =Resources.Lan.BaiduMap  %>','Htmls/FormBaiduMap.aspx');
	        var sTempVehGroup = '<% =sVehGroup %>';
	        iUserType = '<% =sUserType %>';
	        jsonVehGroup = $.parseJSON(sTempVehGroup);
            if(jsonVehGroup == undefined)
            {
                return;
            }
            var sTempUserGroup = '<% =sUserGroup %>';
	        jsonUserGroup = $.parseJSON(sTempUserGroup);
            if(jsonUserGroup == undefined || jsonUserGroup.length == 0)
            {
                jsonUserGroup = $.parseJSON("[{'id':'M_User','name':'用户管理','PID':'','Root':1,'HasChild':0}]");
            }
            var sTempUser = '<% =sUser %>';
	        jsonUser = $.parseJSON(sTempUser);
            var sLoginType = GetCookie("m_logintype");
            m_k = GetCookie("m_k");
            if(sLoginType == "2")
            {
                return;
            }
            //获取车辆数据
	        $("#divState").text("<% =Resources.Lan.LoadingVehicleData %>");
//	        $('#tgVeh').treegrid('onExpand',treeonBeforeLoad);
	        GetVeh();
        });
        
        function GetVeh()
        {
            var sUserName = GetCookie("m_username");
            var sPwd = GetCookie("m_pwd");
            var sLoginType = GetCookie("m_logintype");
            var sUserID = GetCookie("m_userid");
            var iDoType = 1;
            if(sLoginType == "2")
            {
                iDoType = 3;
            }
            $.ajax({
                url: "../Ashx/Vehicle.ashx",
                cache:false,
                type:"post",
                dataType:'json',
                async:true, 
                data:{username:sUserName,Pwd:sPwd,doType:iDoType},
                success:function(data){
                        if(data.result == "true")
                        {
//                            OpenInfo("绑定成功！");
                               var dsVeh = data.data;
                               jsonVehs = dsVeh;
                               var attchJson = {"total":0,"rows":[]};
                               var arrVehGroup = AddVehGroup();
                               if(arrVehGroup == undefined)
                               {
                                    return;
                               }
                               $.each(arrVehGroup, function(i, value){
                                    if(value.state == "closed")
                                    {
                                        $.each(dsVeh, function(j, value2){
                                            if(value2.GID == value.id)
                                            {
                                                value2["team"] = value.name;
                                                //return false;//true=continue,false=break
                                            }
                                       });
                                    }
                                    else
                                    {
                                        $.each(dsVeh, function(j, value2){
                                            if(value2.GID == value.id)
                                            {
                                                value.state = "closed";
                                                value2["team"] = value.name;
                                            }
                                       });
                                    }
                                    attchJson.rows.push(value);
                               });
                               $('#tgVeh').treegrid('loadData',attchJson);
//                               if(iDoType == 3)
//                               {
//                                    $('#tgVeh').treegrid('expandAll',0);
//                               }
//                               else
//                               {
//                                    $('#tgVeh').treegrid('collapseAll',0);
//                               }
                               $("#divState").text("<% =Resources.Lan.LoadVehComplete %>");
                               return;
                        }
                        else
                        {
	                           $("#divState").text(GetErr(data.err));
                        }
                },
                error: function(e) { 
	                 $("#divState").text(e.responseText);
                } 
            })
        }
        
        function AddVehGroup()
        {
            if(jsonVehGroup == undefined)
            {
                return undefined;
            }
//            if(jsonVehGroup.length == 0)
//            {
//                return undefined;
//            }
            var sUserID = GetCookie("m_userid");
           var aaJson = new Array();
           //添加用户管理
           $.each(jsonUserGroup,function(i,value){
                if(value.id == "M_User")
                {
                    var rowUserGroup = { id: value.id, name: value.name, state: '', cid: '', iconCls: "icon-usermng" };
                    aaJson.push(rowUserGroup);
                }
                else
                {
                    var sClosed = "";
                    $.each(jsonUser,function(j,valuej){
                        if(valuej.PID == value.id)
                        {
                            sClosed = "closed";
                            return false;
                        }
                    });
                    var rowUserGroup = { id: value.id, name: value.name, state: sClosed, cid: '', iconCls: "icon-usermng" , _parentId: value.PID };
                    aaJson.push(rowUserGroup);
                }
           });
           if(sUserID == "1")
           {
//                $.each(jsonUser,function(i,value){
//                    var rowUserGroup = { id: value.id, name: value.name, state: '', cid: '', iconCls: "icon-user" , _parentId: value.PID };
//                    aaJson.push(rowUserGroup);
//                });
           }
           else
           {
                $.each(jsonUser,function(i,value){
                    var rowUserGroup = { id: value.id, name: value.name, state: '', cid: '', iconCls: "icon-user" , _parentId: value.PID };
                    aaJson.push(rowUserGroup);
                });
           }
           //添加车辆管理
           var rowGroup = { id: 'T_Veh', name: '车辆管理', state: '', cid: '', iconCls: "icon-vehmsg" };
           aaJson.push(rowGroup);
            for (var i = 0; i < jsonVehGroup.length; i++) {
                if(jsonVehGroup[i].Root == 1)
                {
                    var sState = "";
                    if(jsonVehGroup[i].HasChild == 1)
                    {
                        sState = "closed";
                    }
                    var row = { id: jsonVehGroup[i].id, name: jsonVehGroup[i].name, state: sState, cid: '', iconCls: "icon-team" , _parentId: 'T_Veh'};
                    aaJson.push(row);
                }
                else
                {
                    var sState = "";
                    if(jsonVehGroup[i].HasChild == 1)
                    {
                        sState = "closed";
                    }
                    var row = { id: jsonVehGroup[i].id, name: jsonVehGroup[i].name, state: sState, cid: '', iconCls: "icon-team", _parentId: jsonVehGroup[i].PID };
                    aaJson.push(row);
                }
            }
            return aaJson;
        }
    //------------------------------------------------------------------------------------
</script>
</body>
</html>
