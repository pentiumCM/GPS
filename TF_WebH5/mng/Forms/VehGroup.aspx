<%@ Page Language="C#" AutoEventWireup="true" CodeFile="VehGroup.aspx.cs" Inherits="mng_Forms_VehGroup" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="renderer" content="webkit"> 
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title> <% =Resources.Lan.VehGroupMng %></title>
    <link href="../../Css/index.css" rel="stylesheet" type="text/css" />
    <%--<link rel="stylesheet" type="text/css" href="../../css/style2.0.css" />--%>
	<link rel="stylesheet" type="text/css" href="../../EasyUI/themes/default/easyui.css">    <link rel="stylesheet" type="text/css" href="../../EasyUI/themes/color.css" />    <link rel="stylesheet" type="text/css" href="../../EasyUI/themes/icon.css" />  
    <script type="text/javascript" src="../../js/jquery-1.8.0.min.js"></script>    <script type="text/javascript" src="../../Js/JsCookies.js"></script> 
    <script type="text/javascript" src="../../Js/JsBase64.js"></script>      <script type="text/javascript" src="../../EasyUI/jquery.easyui.min.js"></script>  
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
            <td style="width:120px; text-align:right;"><% =Resources.Lan.VehGroupName %><font color="red">*</font>：</td>
            <td style="width:150px;"><input id="txtGroupName" class="easyui-textbox" style="width:140px;"></td>
            <td style="text-align:left; width:430px;" >
                <% =Resources.Lan.QuicklyLocateTheTeam %>：
                <input id="txtVeh" style="width:275px;" name = "txtVeh" type="text" value="" />
            </td>       
            <td></td>     
            <td></td>
        </tr>
        <tr style="height:32px;">
            <td style="width:120px; text-align:right;"><% =Resources.Lan.Contact %><font color="red">*</font>：</td>
            <td style="width:150px;"><input id="txtContact" class="easyui-textbox" style="width:140px;"></td>
            <td style="vertical-align:top;" colspan="3" rowspan="4">
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
            </td>
        </tr>
        <tr style="height:32px;">
            <td style="width:120px; text-align:right;"><% =Resources.Lan.Tel1 %>：</td>
            <td style="width:150px;"><input id="txtTel1" class="easyui-textbox" style="width:140px;"></td>
        </tr>
        <tr style="height:32px;">
            <td style="width:120px; text-align:right;"><% =Resources.Lan.Tel2 %>：</td>
            <td style="width:150px;"><input id="txtTel2" class="easyui-textbox" style="width:140px;"></td>
        </tr>
        <tr >
            <td style="width:120px; text-align:right; vertical-align:top;"><% =Resources.Lan.Marks %>：</td>
            <td style="width:150px; vertical-align:top;"><input id="txtMarks" class="easyui-textbox" data-options="multiline:true" style="width:140px; height:99%;"></td>
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
    
    function Save(){		    $("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: "100%", zIndex: 99999 }).appendTo("body");  
            $("<div class=\"datagrid-mask-msg\"></div>").html("<% =Resources.Lan.Loding %>").appendTo("body").css({ display: "block", left: ($(document.body).outerWidth(true) - 190) / 2, top: ($(window).height() - 45) / 2 });  		    if(!AntiSqlValid($("#txtGroupName")[0]))		    {
		        $(".datagrid-mask").remove();  
                $(".datagrid-mask-msg").remove(); 
                OpenInfo("<% =Resources.Lan.NotEnterIllegalCharacters %>");                return false;		    }		    if(!AntiSqlValid($("#txtContact")[0]))		    {
		        $(".datagrid-mask").remove();  
                $(".datagrid-mask-msg").remove(); 
                OpenInfo("<% =Resources.Lan.NotEnterIllegalCharacters %>");                return false;		    }		    if(!AntiSqlValid($("#txtMarks")[0]))		    {
		        $(".datagrid-mask").remove();  
                $(".datagrid-mask-msg").remove(); 
                OpenInfo("<% =Resources.Lan.NotEnterIllegalCharacters %>");                return false;		    }		    if(!AntiSqlValid($("#txtTel1")[0]))		    {
		        $(".datagrid-mask").remove();  
                $(".datagrid-mask-msg").remove(); 
                OpenInfo("<% =Resources.Lan.NotEnterIllegalCharacters %>");                return false;		    }		    if(!AntiSqlValid($("#txtTel2")[0]))		    {
		        $(".datagrid-mask").remove();  
                $(".datagrid-mask-msg").remove(); 
                OpenInfo("<% =Resources.Lan.NotEnterIllegalCharacters %>");                return false;		    }		    var sGroupName = $("#txtGroupName").val();		    var sContact = $("#txtContact").val();		    var sTel1 = $("#txtTel1").val();		    var sTel2 = $("#txtTel2").val();		    var sMarks = $("#txtMarks").val();		    var pGroupID = "-1";		    $("input[id^='check_']:checked").each(function(){		        pGroupID = this.id.substring(7);		    });		    if(sGroupName.length == 0)		    {
		        $(".datagrid-mask").remove();  
                $(".datagrid-mask-msg").remove(); 
                OpenInfo("<% =Resources.Lan.VehGroupName %>,<% =Resources.Lan.NoEmpty %>");                return false;		    }		    if(sContact.length == 0)		    {
		        $(".datagrid-mask").remove();  
                $(".datagrid-mask-msg").remove(); 
                OpenInfo("<% =Resources.Lan.Contact %>,<% =Resources.Lan.NoEmpty %>");                return false;		    }		    var sUserName = GetCookie("m_username");
            var sPwd = GetCookie("m_pwd");            $.ajax({
                url: "../../Ashx/MngVehGroup.ashx",
                cache:false,
                type:"post",
                dataType:'json',
                data:{username:sUserName,Pwd:sPwd,GroupName:sGroupName,Contact:sContact,DoType:sDoType,GroupID:thisRID,Pid:pGroupID,Tel1:sTel1,Tel2:sTel2,Marks:sMarks,OldName:sOldName},
                success:function(data){
                        if(data.result)
                        {
                            OpenInfo("<% =Resources.Lan.Successful %>");
		                    $(".datagrid-mask").remove();  
                            $(".datagrid-mask-msg").remove();
                            var sTempGroupID = "G" + data.err;
                            if(sDoType == "0")
                            {
                                sTempGroupID = "G" + thisRID;
                            } 
                            if(pGroupID == "-1")
                            {
                                 pGroupID = "T_Veh"
                            }
                            else
                            {
                                pGroupID = "G" + pGroupID;
                            }
                            var objReturn = {"DoType":sDoType,"GroupID":sTempGroupID,"Name":sGroupName,"PID":pGroupID};
                             window.parent.window.UpdateTree("VehGroup", objReturn);
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
            });            return false;        }                function OpenInfo(info)        {            var data = "<div>" + info + "</div>";//            $("#dlgInfo").html("<p>" + info + "</p>");//            $("#dlg1").dialog('open').dialog('center');               $.messager.alert('<% =Resources.Lan.Prompt %>',data,'question');        }
        
        var thisRID="";
        var thisRPID = "";
        var sDoType = "1";
        var sOldName = "";
        $(document).ready(function() { 
            $('#DivAutoComplete').hide();
            var sUrl=location.search.toLowerCase();
            var sQuery=sUrl.substring(sUrl.indexOf("=")+1);
            re=/select|update|delete|truncate|join|union|exec|insert|drop|count|’|"|;|>|</i;
            if(re.test(sQuery))
            {
                OpenInfo("<% =Resources.Lan.NotEnterIllegalCharacters %>");
                location.href=sUrl.replace(sQuery,"");
            }            var Request = GetRequest();
            thisRID = Request["id"];
            thisRPID = Request["pid"];            sDoType = Request["dotype"];            if(sDoType == "0")            {                GetGroupInfo();            }            window.parent.window.InitVehAndGroup("<% =Resources.Lan.VehGroupMng %>");            AutoText("txtVeh",jsonVehGroup);        })
        
        function GetGroupInfo()
        {
            var sUserName = GetCookie("m_username");
            var sPwd = GetCookie("m_pwd");            $.ajax({
                url: "../../Ashx/MngVehGroup.ashx",
                cache:false,
                type:"post",
                dataType:'json',
                data:{username:sUserName,Pwd:sPwd,GroupName:'1',Contact:'1',DoType:4,GroupID:thisRID,Pid:0,Tel1:'',Tel2:'',Marks:''},
                success:function(data){
                        if(data.result)
                        {
                            $("#txtGroupName").textbox('setValue',data.data[0].VehGroupName);
                            sOldName = data.data[0].VehGroupName;
                            $("#txtContact").textbox('setValue',data.data[0].Contact);
                            $("#txtTel1").textbox('setValue',data.data[0].sTel1);
                            $("#txtTel2").textbox('setValue',data.data[0].sTel2);
                            $("#txtMarks").textbox('setValue',data.data[0].Address);
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
            if(sDoType == "0" && thisRID != undefined && thisRID.length > 0)
            {
                $("#tgVeh").treegrid("remove","G" + thisRID);  
            }
            $('#tgVeh').treegrid('expandAll',0);
            if(sDoType == "1" && thisRID != undefined && thisRID.length > 0)
            {
                $('#check_G'+thisRID)[0].checked = true;
                $('#tgVeh').treegrid('select','G' + thisRID);
                $('html, body').animate({  
                        scrollTop: $(".datagrid-row-selected").offset().top  
                    }, 2000);
            }
            else if(sDoType == "0" && thisRPID != undefined && thisRPID.length > 0 && thisRPID != "-1")
            {
                $('#check_G'+thisRPID)[0].checked = true;
                $('#tgVeh').treegrid('select','G' + thisRPID);
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
