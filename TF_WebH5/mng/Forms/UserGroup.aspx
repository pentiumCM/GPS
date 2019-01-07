<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UserGroup.aspx.cs" Inherits="mng_Forms_UserGroup" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="renderer" content="webkit"> 
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title> <% =Resources.Lan.UserGroup %></title>
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
    <table style="width:100%;">
        <tr style="height:32px; ">
            <td style="text-align:left; background-color:White;" colspan="3">
                &nbsp;&nbsp;<a href="#;" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="return Save();"><% =Resources.Lan.Save %></a>
            </td>         
        </tr>
        <tr style="height:32px; text-align:left">
            <td style="width:120px; text-align:right;"><% =Resources.Lan.Name %><font color="red">*</font>：</td>
            <td style="width:150px;"><input id="txtName" class="easyui-textbox" style="width:140px;"></td>
            <td></td>
        </tr>
        <tr style="height:32px;">
            <td style="width:120px; text-align:right; vertical-align:top;"><% =Resources.Lan.Marks %><font color="red">*</font>：</td>
            <td style="width:150px;">
                <input id="txtMarks" class="easyui-textbox" data-options="multiline:true" style="width:140px; height:99%;">
            </td>
            <td></td>
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
		    if(!AntiSqlValid($("#txtMarks")[0]))
		    {
		        $(".datagrid-mask").remove();  
                $(".datagrid-mask-msg").remove(); 
                OpenInfo("<% =Resources.Lan.NotEnterIllegalCharacters %>");
                return false;
		    }
		    var sName = $("#txtName").val();
		    var sMarks = $("#txtMarks").val();
		    if(sName.length == 0)
		    {
		        $(".datagrid-mask").remove();  
                $(".datagrid-mask-msg").remove(); 
                OpenInfo("<% =Resources.Lan.Name %>,<% =Resources.Lan.NoEmpty %>");
                return false;
		    }
		    var sUserName = GetCookie("m_username");
            var sPwd = GetCookie("m_pwd");
            $.ajax({
                url: "../../Ashx/MngUserGroup.ashx",
                cache:false,
                type:"post",
                dataType:'json',
                data:{username:sUserName,Pwd:sPwd,Name:sName,DoType:sDoType,ID:sThisID,Marks:sMarks,OldName:sOldName},
                success:function(data){
                        if(data.result)
                        {
                            OpenInfo("<% =Resources.Lan.Successful %>");
		                    $(".datagrid-mask").remove();  
                            $(".datagrid-mask-msg").remove();
                            var sTempGroupID = "U" + data.err;
                            if(sDoType == "0")
                            {
                                sTempGroupID = "U" + sThisID;
                            } 
                            var pGroupID = "M_User";
                            var objReturn = {"DoType":sDoType,"ID":sTempGroupID,"Name":sName,"PID":pGroupID};
                             window.parent.window.UpdateTree("UserGroup", objReturn);
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
            sDoType = Request["dotype"];
            sThisID = Request["id"];
            sOldName = Request["oldName"];
            if(sDoType == "0" && sThisID != undefined)
            {
                GetGroupInfo();
            }
        })
        
        function GetGroupInfo()
        {
            var sUserName = GetCookie("m_username");
            var sPwd = GetCookie("m_pwd");
            $.ajax({
                url: "../../Ashx/MngUserGroup.ashx",
                cache:false,
                type:"post",
                dataType:'json',
                data:{username:sUserName,Pwd:sPwd,DoType:4,ID:sThisID},
                success:function(data){
                        if(data.result)
                        {
                            $("#txtName").textbox('setValue',data.data[0].Name);
                            sOldName = data.data[0].Name;
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
