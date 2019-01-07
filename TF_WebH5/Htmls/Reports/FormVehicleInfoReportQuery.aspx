<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FormVehicleInfoReportQuery.aspx.cs" Inherits="Htmls_Reports_FormVehicleInfoReportQuery" %>

<!DOCTYPE html>
<html>
<head >
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <%--<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />--%>
    <title><% =Resources.Lan.VehicleInformation %></title>
    <style type="text/css">
        body, html {width: 100%;height: 100%;overflow: hidden;margin:0;}
	    
	    #webfont {
		    font: 24px/150% BaiduCar;
		    width: 300px;
	    }
	    /* 以下为自动提示框*/
	    .search{ 
            text-align: left; 
            position:relative; 
        } 
        .autocomplete{ 
            border: 1px solid #9ACCFB; 
            background-color: white; 
            text-align: left; 
        } 
        .autocomplete li{ 
            list-style-type: none; 
            font-size:14px;
            padding:2px;
        } 
        .autocomplete ul{ 
            list-style-type: none; 
        } 
        .clickable { 
            cursor: default; 
        } 
        .highlight { 
            background-color: #9ACCFB; 
        } 
    </style>  
    <link href="../../Css/index.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" type="text/css" href="../../EasyUI/themes/default/easyui.css" />  
    <link rel="stylesheet" type="text/css" href="../../EasyUI/themes/color.css"/> 
    <link rel="stylesheet" type="text/css" href="../../EasyUI/themes/icon.css"/> 
    <script type="text/javascript" src="../../EasyUI/jquery.min.js"></script>  
    <script type="text/javascript" src="../../EasyUI/jquery.easyui.min.js"></script> 
    <script type="text/javascript" src="../../Js/AutoComplete.js"></script> 
    <script type="text/javascript" src="../../Js/JsCookies.js"></script>  
    <script type="text/javascript" src="../../Js/JExcel.js"></script> 
    <script language="javascript" type="text/javascript" src="../../Js/Google/GoogleLatLngCorrect.js"></script>
    <%--<script type="text/javascript" src="../EasyUI/easyui-lang-zh_CN.js"></script> --%>
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
//        dynamicLoading.js("../EasyUI/easyui-lang-zh_CN.js");
        var sLan = "<% =Resources.Lan.Language  %>";
        if(sLan == "zh")
        {
            document.write("<script src='../../EasyUI/easyui-lang-zh_CN.js'><\/script>");
        }
        
        $(document).ready(function() { 
            $('#txtTeam').combobox({
                editable:false
            });
            window.parent.window.InitVehAndGroup("<% =Resources.Lan.VehicleInformation %>");    
               
        });
        
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
            var Request = GetRequest();
            var attchJson = {"total":0,"rows":[]};
            var arrVehGroup = AddVehGroup(jsonVehGroup);
            if(arrVehGroup == undefined)
            {
                 return;
            }
            $.each(arrVehGroup, function(i, value){
                 if(value.state == "closed")
                 {
                     $.each(jsonVehs, function(j, value2){
                         if(value2.GID == value.id)
                         {
                             value2["team"] = value.name;
                             //return false;//true=continue,false=break
                         }
                    });
                 }
                 else
                 {
                     $.each(jsonVehs, function(j, value2){
                         if(value2.GID == value.id)
                         {
                             value.state = "closed";
                             value2["team"] = value.name;
                             //return false;//true=continue,false=break
                         }
                    });
                 }
                 attchJson.rows.push(value);
            });
            var arrTeam = new Array();
            $.each(jsonVehGroup,function(i,value){
                var row = {"label":value.name,"value":value.id};
                arrTeam.push(row);
            });
            $('#txtTeam').combobox('loadData', arrTeam);
            $('#txtTeam').combobox('setValue', arrTeam[0].value);
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
                    if(jsonVehGroup[i].HasChild == 1)
                    {
                        sState = "closed";
                    }
                    var row = { id: jsonVehGroup[i].id, name: jsonVehGroup[i].name, state: sState, iconCls: "icon-team" };
                    aaJson.push(row);
                }
                else
                {
                    var sState = "";
                    if(jsonVehGroup[i].HasChild == 1)
                    {
                        sState = "closed";
                    }
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
        
        function Query()
        {            
            var sUserName = GetCookie("username");
            var sPwd = GetCookie("pwd");
            var txtTeam = $('#txtTeam').combobox('getValue');
            if(txtTeam.length == 0)
		    {
		        $(".datagrid-mask").remove();  
                $(".datagrid-mask-msg").remove(); 
                OpenInfo("<% =Resources.Lan.Team %>,<% =Resources.Lan.NoEmpty %>");
                return false;
		    }
            if(!AntiSqlValid(txtTeam))
		    {
		        $(".datagrid-mask").remove();  
                $(".datagrid-mask-msg").remove(); 
                OpenInfo("<% =Resources.Lan.NotEnterIllegalCharacters %>");
                return false;
		    }
            $.ajax({
                url: "../../Ashx/Vehicle.ashx",
                cache:false,
                type:"post",
                dataType:'json',
                data:{username:sUserName,Pwd:sPwd,DoType:6,ID:txtTeam.substring(1)},
                success:function(data){
                        if(data.result == "true")
                        {
                            var sName = "";
                            $.each(jsonVehGroup,function(j,vaulej){
                                if(txtTeam == vaulej.id)
                                {
                                    sName = vaulej.name;
                                    return false;
                                }
                            });
                            $.each(data.data,function(i,value){
                                value["Team"] = sName;
                                value["blank"] = "";
                                $.each(jsonVehs,function(j,valuej){
                                    var bExists = false;
                                    if(valuej.name == value.PlateNO)
                                    {
                                        bExists = true;
                                        if(valuej["online"] == undefined)
                                        {
                                            value["online"] = "<% =Resources.Lan.Offline%>";
                                        }
                                        else if(valuej["online"] == false)
                                        {
                                            value["online"] = "<% =Resources.Lan.Offline%>";
                                        }
                                        else
                                        {
                                            value["online"] = "<% =Resources.Lan.Online%>";
                                        }
                                        return false;
                                    }
                                    if(!bExists)
                                    {
                                        value["online"] = "<% =Resources.Lan.Offline%>";
                                    }
                                });
                            });
                            $('#GridReport').datagrid('loadData',data.data); 
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
        
        function OpenInfo(info)
        {
            $("#dlgInfo").html("<p>" + info + "</p>");
            $("#dlg1").dialog('open').dialog('center');
        }
        
        function OpenLoding(value)
        {
            $("#dlgLoding").dialog('open').dialog('center');
//            var value = $('#p').progressbar('getValue');
			$('#p').progressbar('setValue', value);
        }
         
         function ClearHistoryTable()
        {
            $('#GridReport').datagrid('loadData', { total: 0, rows: [] });  
        }
        
        function InfoFormater(value, row, index) 
        {   
            var content = '';   
            var abValue = value +'';   
            if(value != undefined)
            {      
                content = '<img alt="" src = "' + abValue + '" width="100px" height="100px" />'      
             }   
             return content;
         }
         
         
         function Export()
         {
            //getExcelXML有一个JSON对象的配置，配置项看了下只有title配置，为excel文档的标题
            var data = $('#GridReport').datagrid('getExcelXml', { title: 'datagrid import to excel' }); //获取datagrid数据对应的excel需要的xml格式的内容
            //用ajax发动到动态页动态写入xls文件中
            var url = '../../Ashx/datagrid_to_excel.ashx'; //如果为asp注意修改后缀
            $.ajax({ url: url, data: { data: data }, type: 'POST', dataType: 'text', 
                success: function (fn) {
                    ShowInfo('<% =Resources.Lan.Successful %>');
                    window.location = "../../" + fn; //执行下载操作
                },
                error: function (xhr) {
                    ShowInfo('<% =Resources.Lan.Fault %>\nstatus：' + xhr.status + '\nresponseText：' + xhr.responseText)
                }
            });
            return false;
         }
       function ShowInfo(info)
       {
           $.messager.alert('<% =Resources.Lan.Tip %>',info,'info');
       }
       
    </script>
</head><%--oncontextmenu="return false" --%>
<body class="easyui-layout" id="bodyLayout" style="overflow-y: hidden; scroll:"no">    		
    <div region="north" split="true" border="true" style="overflow: hidden; font-family: Verdana, 微软雅黑,黑体; padding:2px; height:43px">
        <div>
                <table>
                    <tr>
                        <td style="text-align:right; width:80px;">
                            <% =Resources.Lan.Team %>：
                        </td>
                        <td>
                            <select class="easyui-combobox" name="txtTeam" id="txtTeam" style="width:200px;" data-options="valueField: 'value',textField: 'label'">
		                                                      </select>
                        </td>
                        <td style="width:240px">
                             <a href="#;" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="Query();"><% =Resources.Lan.Query %></a>   
                            <%--<a href="#;" id="btnAllPlace" class="easyui-linkbutton" disabled="disabled" data-options="iconCls:'icon-LineRoad1'" onclick="GetAllPlaceInfo();"><% =Resources.Lan.DisplayAllTrackPosition %></a>--%>
                            <a href="#;" class="easyui-linkbutton" data-options="iconCls:'icon-report'" onclick="return Export();"><% =Resources.Lan.Export %></a>   
                        </td>
                    </tr>
                </table>    
		</div>
    </div>
    <%--中间--%>
    <div region="center" style="background: #eee; overflow-y:hidden">
            <table id="GridReport" class="easyui-datagrid" style="height:100%" data-options="idField:'id',singleSelect:true,collapsible:true,remoteSort: false">
		        <thead>
			        <tr>
			            <th data-options="field:'PlateNO',width:120,sortable:true,order:'desc',remoteSort:false"><% =Resources.Lan.Plate %></th>
			            <th data-options="field:'Team',width:120,sortable:true,order:'desc',remoteSort:false"><% =Resources.Lan.Team %></th>
                        <th data-options="field:'online',width:120,sortable:true,order:'desc',remoteSort:false"><% =Resources.Lan.OnlineState %></th>
                        <th data-options="field:'Sim',width:120"><% =Resources.Lan.Sim%></th><%--手机号码--%>
                        <th data-options="field:'IpAddress',width:120"><% =Resources.Lan.IpAddress%></th><%--终端编号--%>
                        <th data-options="field:'TaxiNo',width:120"><% =Resources.Lan.TaxiNo%></th><%--终端类型，GB--%>
                        <th data-options="field:'Address',width:130"><% =Resources.Lan.VehAddress %></th> <%--联系地址--%>
                        <th data-options="field:'CarColor',width:120"><% =Resources.Lan.VehCarColor%></th><%--车辆颜色--%>
                        <th data-options="field:'CarType',width:120"><% =Resources.Lan.VehCarType%></th><%--车辆类型，轿车--%>
                        <th data-options="field:'InstallDate',width:130"><% =Resources.Lan.VehInstallDate%></th><%--安装日期--%>
                        <th data-options="field:'OwnerName',width:120"><% =Resources.Lan.VehOwnerName%></th><%--车主--%>
                        <th data-options="field:'PlateColor',width:120"><% =Resources.Lan.VehPlateColor%></th><%--车牌颜色--%>
                        <th data-options="field:'Contact1',width:120"><% =Resources.Lan.VehContact1%></th><%--联系人1--%>
                        <th data-options="field:'Contact2',width:120"><% =Resources.Lan.VehContact2%></th><%--联系人2--%>
                        <th data-options="field:'CustomNum',width:120"><% =Resources.Lan.VehCustomNum%></th><%--自定编号--%>
                        <th data-options="field:'Email',width:120"><% =Resources.Lan.VehEmail%></th><%--邮箱--%>
                        <th data-options="field:'EngineNumber',width:120"><% =Resources.Lan.VehEngineNumber%></th><%--发动机号--%>
                        <th data-options="field:'FrameNumber',width:140"><% =Resources.Lan.VehFrameNumber%></th><%--VIN--%>                        
                        <th data-options="field:'IdentityCard',width:140"><% =Resources.Lan.VehIdentityCard%></th><%--证件--%>
                        <th data-options="field:'InstallPerson',width:120"><% =Resources.Lan.VehInstallPerson%></th><%--安装人员--%>
                        <th data-options="field:'Sex',width:120"><% =Resources.Lan.Sex%></th><%--性别--%>
                        <th data-options="field:'Tel',width:120"><% =Resources.Lan.VehTel%></th><%--联系电话--%>
                        <th data-options="field:'Tel1',width:120"><% =Resources.Lan.VehTel1%></th><%--联系电话1--%>
                        <th data-options="field:'Tel2',width:120"><% =Resources.Lan.Tel2%></th><%--电话2--%>
                        <th data-options="field:'Money',width:120"><% =Resources.Lan.VehMoney%></th><%--金额--%>
                        <th data-options="field:'OperationRoute',width:120"><% =Resources.Lan.VehOperationRoute%></th><%--运营路线--%>
                        <th data-options="field:'PostalCode',width:120"><% =Resources.Lan.VehPostalCode%></th><%--邮政编码--%>
                        <th data-options="field:'PowerType',width:120"><% =Resources.Lan.VehPowerType%></th><%--动类型--%>
                        <th data-options="field:'TransportLicenseID',width:120"><% =Resources.Lan.VehicleTransportLicenseID%></th><%--道路运输证号--%>
                        <th data-options="field:'WorkUnit',width:120"><% =Resources.Lan.VehWorkUnit%></th><%--工作单位--%>
                        <th data-options="field:'PurchaseDate',width:130"><% =Resources.Lan.PurchaseDate%></th><%--服务开始时间--%>
                        <th data-options="field:'ServerEndTime',width:120"><% =Resources.Lan.ServerEndTime%></th><%--服务终止时间--%>
                        <th data-options="field:'AnnualInspectionRepairTime',width:130"><% =Resources.Lan.AnnualInspectionRepairTime%></th><%--年检--%>
                        <th data-options="field:'EnrolDate',width:130"><% =Resources.Lan.EnrolDate%></th><%--保险时间--%>
                        <th data-options="field:'Level2MaintenanceTime',width:130"><% =Resources.Lan.VehLevel2MaintenanceTime%></th><%--二级维护时间--%>
                        <th data-options="field:'TonOrSeats',width:120"><% =Resources.Lan.VehTonnage%>/<% =Resources.Lan.VehSeats%></th><%--吨位--%>
                        <th data-options="field:'Marks',width:120"><% =Resources.Lan.Marks%></th><%--备注--%>
                        <th data-options="field:'blank',width:30">&nbsp;</th> <%--占位用--%>
			        </tr>
		        </thead>
	        </table>
     </div>
     <%--进度条--%>
	<div id="dlgLoding" class="easyui-dialog" style="padding:20px 6px;width:200px; text-align:center;" data-options="inline:true,modal:true,closed:true,title:'<% =Resources.Lan.Loading %>'">
		<div id="p" class="easyui-progressbar" style="width:100%;"></div>
	</div>
	<div id="dlg1" class="easyui-dialog" style="padding:20px 6px;width:200px;" data-options="inline:true,modal:true,closed:true,title:'<% =Resources.Lan.Prompt %>'">
		<div id="dlgInfo">This is a message dialog.</div>
		<div class="dialog-button">
			<a href="javascript:void(0)" class="easyui-linkbutton" style="width:100%;height:35px" onclick="$('#dlg1').dialog('close')"><% =Resources.Lan.Confirm %></a>
		</div>
	</div>
</body>
</html>
