<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FormBindPolygonVeh.aspx.cs" Inherits="Htmls_Cmd_FormBindPolygonVeh" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title><% =Resources.Lan.FenceBindVehicle %></title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="../../Css/index.css" rel="stylesheet" type="text/css" />
	<link rel="stylesheet" type="text/css" href="../../EasyUI/themes/default/easyui.css" />
    <link rel="stylesheet" type="text/css" href="../../EasyUI/themes/color.css" />
    <link rel="stylesheet" type="text/css" href="../../EasyUI/themes/icon.css" />  
    <script type="text/javascript" src="../../EasyUI/jquery.min.js"></script>  
    <script type="text/javascript" src="../../EasyUI/jquery.easyui.min.js"></script> 
    <script type="text/javascript" src="../../Js/GenerageGuid.js"></script> 
    <script type="text/javascript" src="../../Js/JsCookies.js"></script>  
    <script type="text/javascript" src="../../Js/GridTreeMulSelect.js"></script> 
    <script type="text/javascript">
        $(document).ready(function() { 
            var bSms = '<%=System.Configuration.ConfigurationManager.AppSettings["Sms"] %>';
            if(bSms == 1)
            {
            
            }
            else
            {
                $('#trSms1').hide();
                $('#trSms2').hide();
            }
            window.parent.window.InitVehAndGroupCmd("<% =Resources.Lan.FenceBindVehicle  %>");   
        });
        
        function OpenInfoCmd(url,thisWidth,thisHeight,thisTitle)        {
              window.parent.window.OpenInfoCmd(url,thisWidth,thisHeight,thisTitle);        }
        
        function send()
        {
            try
            {
                $.messager.show({
			        title:'<% =Resources.Lan.Prompt %>',
			        msg:'<% =Resources.Lan.Loding %>',
				    timeout:1000,
			        showType:'show',
			        style:{
			            right:'',
			            bottom:''
			        }
			    });
                var sVeh = "";
                $("input:checked").each(function(){
                    if(this.id.indexOf("check_V") > -1)
                    {
                        if(sVeh.length == 0)
                        {
                            sVeh = this.id.substring(7);
                        }
                        else
                        {
                            sVeh = sVeh + "," + this.id.substring(7);
                        }
                    }
                });
                var sFenceType= $('#txtFenceType').combobox('getValue');
                var sStartTime = "1900-01-01 00:00:01";
                var sEndTime = "1900-01-01 23:59:59";
                var bCheckTime = $('#chkTime')[0].checked;
                var bWeekEnd = $('#chkWeekEnd')[0].checked?1:0;
                var bHolidays = $('#chkHolidays')[0].checked?1:0;
		        var sSms = $("#txtSms").val();
                if($('#chkTime')[0].checked)
                {
                    var sHour1 = $('#txtStartTime').timespinner('getHours');
                    var sMinute1 = $('#txtStartTime').timespinner('getMinutes');
                    var sSecond1 = $('#txtStartTime').timespinner('getSeconds');
                    var sHour2 = $('#txtEndTime').timespinner('getHours');
                    var sMinute2 = $('#txtEndTime').timespinner('getMinutes');
                    var sSecond2 = $('#txtEndTime').timespinner('getSeconds');
                    if(sHour2 < sHour1)
                    {
                        OpenInfo("<% =Resources.Lan.StartTimeNotGreaterEndTime %>");
                        return;
                    }
                    else if(sHour2 == sHour1)
                    {
                        if(sMinute2 < sMinute1)
                        {
                            OpenInfo("<% =Resources.Lan.StartTimeNotGreaterEndTime %>");
                            return;
                        }
                        else if(sMinute2 == sMinute1)
                        {
                            if(sSecond2 < sSecond1)
                            {
                                OpenInfo("<% =Resources.Lan.StartTimeNotGreaterEndTime %>");
                                return;
                            }
                        }
                    }
                    sStartTime = "1900-01-01 " + (Array(2>sHour1?(2-(''+sHour1).length+1):0).join(0)+sHour1) + ":" + (Array(2>sMinute1?(2-(''+sMinute1).length+1):0).join(0)+sMinute1)+ ":" + (Array(2>sSecond1?(2-(''+sSecond1).length+1):0).join(0)+sSecond1);
                    sEndTime = "1900-01-01 " + (Array(2>sHour2?(2-(''+sHour2).length+1):0).join(0)+sHour2) + ":" + (Array(2>sMinute2?(2-(''+sMinute2).length+1):0).join(0)+sMinute2)+ ":" + (Array(2>sSecond2?(2-(''+sSecond2).length+1):0).join(0)+sSecond2);
                }
                else if(sFenceType == 4) // || sSms.length > 0)
                {
                    OpenInfo("<% =Resources.Lan.Time %> <% =Resources.Lan.NoEmpty %>");
                    return;
                }
                if(sSms.length > 0)
                {
                    var arrSms = sSms.split(",");
                    for(var i = 0; i < arrSms.length; i++)
                    {
                        if(arrSms[i].length < 11 || arrSms[i].length > 13)
                        {
                            OpenInfo("<% =Resources.Lan.SmsNotice %> <% =Resources.Lan.ParameterError %>");
                            return;
                        }
                    }
                }
                $.each(jsonPolygonInfo.lstVeh,function(i,value){
                    if($(('#check_V'+value.VehID)).length == 0)
                    {
                        if(sVeh.length == 0)
                        {
                            sVeh = value.VehID;
                        }
                        else
                        {
                            sVeh = sVeh + "," + value.VehID;
                        }
                    }
                });
                var txtID = $('#txtId').val();
                if(txtID.length == 0)
                {
                    OpenInfo("ID <% =Resources.Lan.NoEmpty %>");
                    return;
                }
                var sUserName = GetCookie("username");
                var sPwd = GetCookie("pwd");
                $.ajax({
                    url: "../../Ashx/FenceRegion.ashx",
                    cache:false,
                    type:"post",
                    dataType:'json',
                    async:true, 
                    data:{username:sUserName,Pwd:sPwd,doType:'SavePolygonVeh',loginDefaultType:1,cid:txtID,vehs: sVeh,InOrOut: sFenceType,IsTime:bCheckTime,StartTime: sStartTime, EndTime: sEndTime, Sms: sSms, WeekEnd:bWeekEnd, Holidays:bHolidays},
                    success:function(data){
                            if(data.result == "true")
                            {
                                jsonPolygonInfo.lstVeh.length = 0;
                                var arrVeh = sVeh.split(',');
                                $.each(arrVeh,function(i,value){
                                    jsonPolygonInfo.lstVeh.push({"VehID":value,"InOrOut":sFenceType,"IsTime": bCheckTime,"StartTime":sStartTime,"EndTime":sEndTime,"Sms":sSms,"WeekEnd":bWeekEnd,"Holidays":bHolidays});
                                });
                                window.parent.window.PolygonSync();
                                OpenInfo("<% =Resources.Lan.Successful %>");
                            }
                            else
                            {
                                OpenInfo("<% =Resources.Lan.Fault %>");
                            }
                    },
                    error: function(e) { 
                        OpenInfo(e.responseText);
                    } 
                }) ;   
            }
            catch(e)
            {
                OpenInfo(e.message);
            }
        }
        
        function OpenInfo(info)
        {
            $.messager.show({
			    title:'<% =Resources.Lan.Prompt %>',
			    msg:info,
			    showType:'fade',
			    style:{
			        right:'',
			        bottom:''
			    }
			});
        }
        
        var jsonVehGroup = "";
        var jsonVehs = "";
        var jsonPolygonInfo = new Array();
        function InitVehAndGroup(VehGroup, Vehs, PolygonVehs)
        {
            jsonPolygonInfo = PolygonVehs;
            $('#txtId').textbox('setValue',jsonPolygonInfo.id.substring(1));
            $('#txtName').textbox('setValue',jsonPolygonInfo.text);
            if(jsonPolygonInfo.lstVeh.length > 0)
            {
                if(jsonPolygonInfo.lstVeh[0].WeekEnd == 1)
                {
                    $('#chkWeekEnd')[0].checked = true;
                }
                else
                {
                    $('#chkWeekEnd')[0].checked = false;
                }
                if(jsonPolygonInfo.lstVeh[0].Holidays == 1)
                {
                    $('#chkHolidays')[0].checked = true;
                }
                else
                {
                    $('#chkHolidays')[0].checked = false;
                }
                $('#txtFenceType').combobox('setValues',jsonPolygonInfo.lstVeh[0].InOrOut.toString());
                $('#chkTime')[0].checked = jsonPolygonInfo.lstVeh[0].IsTime;
                $('#txtSms').textbox('setValue',jsonPolygonInfo.lstVeh[0].Sms);
                if(jsonPolygonInfo.lstVeh[0].IsTime)
                {
                    $("#txtStartTime").timespinner({ disabled: false });
                    $("#txtEndTime").timespinner({ disabled: false });
                    $('#txtStartTime').timespinner('setValue', jsonPolygonInfo.lstVeh[0].StartTime.substring(11));
                    $('#txtEndTime').timespinner('setValue', jsonPolygonInfo.lstVeh[0].EndTime.substring(11));
                }
            }
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
//            var Request = GetRequest();
//            var sVehidTemp = Request["VehID"];
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
            $('#tgVeh').treegrid('loadData',attchJson);
            $('#tgVeh').treegrid('collapseAll',0);
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
        
        function formatVehcheckbox(val,row){
            return "<input type='checkbox' onclick=showVehcheck('"+row.id+"') id='check_"+row.id+"' "+(row.checked?'checked':'')+"/>" + row.name;
        }
        
        function showVehcheck(checkid){
          var s = '#check_'+checkid;
          //alert( $(s).attr("id"));
          // alert($(s)[0].checked);
          /*选子节点*/
           var nodes = $("#tgVeh").treegrid("getChildren",checkid);
           if(checkid[0] == 'V')
           {
           
           }
           else
           {
//                $("#tgVeh").treegrid("collapse",checkid);
                $("#tgVeh").treegrid("expand",checkid);
           }
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
                     else
                     {
                        
                     }    
              }
              else
              {
              
              } 
           }
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
        
        function treeonBeforeLoad(row)
        {
            if($("#tgVeh").treegrid("getChildren",row.id).length == 0)
            {
                    var attchJson = new Array();
                    $.each(jsonVehs,function(i,value){
                        if(value.GID == row.id)
                        {
                            var carIcon = "icon-offine";
                            if(value["online"])
                            {
                                carIcon = "icon-online";
                            }
                            var rowVeh = { id: value.id, team: value.team, online: value.online, name: value.name, sim: value.sim, taxino: value.taxino, ipaddress: value.ipaddress, iconCls: carIcon, _parentId: value.GID };
                            attchJson.push(rowVeh);
                        }
                    });
                    if(attchJson.length > 0)
                    {
                        $('#tgVeh').treegrid('append',{
	                        parent: row.id,  // the node has a 'id' value that defined through 'idField' property
	                        data: attchJson
                        });
                        $.each(jsonPolygonInfo.lstVeh,function(i,value){
                            $.each(attchJson,function(j,value2){
                                if("V" + value.VehID == value2.id)
                                {
                                    $(('#check_'+value2.id))[0].checked = true;
                                    return false;
                                }
                            });
                        });
                    }
            }
            else
            {
                var bAdd = false;
                $.each($("#tgVeh").treegrid("getChildren",row.id), function(i, value){
                    if(value.id[0] == "V")
                    {
                        bAdd = true;
                        return false;
                    }
                });
                if(!bAdd)
                {
                    var attchJson = new Array();
                    $.each(jsonVehs,function(i,value){
                        if(value.GID == row.id)
                        {
                            var carIcon = "icon-offine";
                            if(value["online"])
                            {
                                carIcon = "icon-online";
                            }
                            var rowVeh = { id: value.id, name: value.name, online: value.online,team: value.team, sim: value.sim, taxino: value.taxino, ipaddress: value.ipaddress,iconCls: carIcon, _parentId: value.GID };
                            attchJson.push(rowVeh);
                        }
                    });
                    if(attchJson.length > 0)
                    {
                        $('#tgVeh').treegrid('append',{
	                        parent: row.id,  // the node has a 'id' value that defined through 'idField' property
	                        data: attchJson
                        });
                        $.each(jsonPolygonInfo.lstVeh,function(i,value){
                            $.each(attchJson,function(j,value2){
                                if("V" + value.VehID == value2.id)
                                {
                                    $(('#check_'+value2.id))[0].checked = true;
                                    return false;
                                }
                            });
                        });
                    }
                }
            }
        }
        
        function closeForm()
        {
            window.parent.window.CloseInfoCmd();
        }
        
        function TimeDisabled(owner)
        {
            if(owner.checked)
            {
                $("#txtStartTime").timespinner({ disabled: false });
                $("#txtEndTime").timespinner({ disabled: false });
            }
            else
            {
                $("#txtStartTime").timespinner({ disabled: true });
                $("#txtEndTime").timespinner({ disabled: true });
            }
        }
    </script>
</head>
<body oncontextmenu="return false">
    <div style="float:left; height:100%" id="divList">
        <table id="tgVeh" class="easyui-treegrid" style=" float:left; height:405px; width:240px" 
		            data-options="
		                method: 'get',
		                lines: false,
		                rownumbers: false,
		                idField: 'id',
		                treeField: 'name',
		                singleSelect: true,
		                onBeforeExpand :treeonBeforeLoad
		            ">
		        <thead>
		            <tr>
		                <th data-options="field:'name'" formatter="formatVehcheckbox" width="220px"><% =Resources.Lan.TeamOrPlate%></th>
		                <th data-options="field:'sim'" width="90"><% =Resources.Lan.Sim %></th>
		                <th data-options="field:'taxino'" width="100"><% =Resources.Lan.TaxiNo %></th>
		                <th data-options="field:'ipaddress'" width="94"><% =Resources.Lan.IpAddress %></th>
		            </tr>
		        </thead>
	        </table>
    </div>
    <div style="float:left">
        <div class="easyui-panel" title="<% =Resources.Lan.FenceBindVehicle %>" style="width:280px; height:405px">
		    <div>
	            <form id="ff" method="post">
	    	         <table cellpadding="5" width="100%">
	    		    <tr>
	    			    <td width="80" style="text-align:right">ID:</td>
	    			    <td >
	    			        <input style="width:80px" readonly="readonly" class="easyui-textbox" type="text" id="txtId" value="" name="txtId" />
	    			    </td>
	    		    </tr>
	    		    <tr>
	    			    <td style="text-align:right"><% =Resources.Lan.Name %>:</td>
	    			    <td>
	    			        <input style="width:80px" readonly="readonly" class="easyui-textbox" type="text" id="txtName" value="" name="txtName" />
	    			    </td>
	    		    </tr>
	    		    <tr>
	    			    <td style="text-align:right"><% =Resources.Lan.FenceType %>:</td>
	    			    <td>
	    			        <select class="easyui-combobox" name="txtFenceType" id="txtFenceType" style="width:170px">
		                        <option value="2"><% =Resources.Lan.LeaveFenceAreaAlarm%></option>
		                        <option value="1"><% =Resources.Lan.EnterFenceAreaAlarm %></option>
		                        <option value="4"><% =Resources.Lan.VehicleLeaveFenceScheduleTimeAlarm %></option>
                            </select>
	    			    </td>
	    		    </tr>
	    		    <tr>
	    			    <td  style="text-align:right"><input type="checkbox" onclick="TimeDisabled(this);" id="chkTime" name="chkTime" value="<% =Resources.Lan.StartTime %>" /><% =Resources.Lan.StartTime%>:</td>
	    			    <td>
    	    				<input id="txtStartTime" disabled="disabled" class="easyui-timespinner" data-options="min:'00:00:00',max:'23:59:59',showSeconds:true" value="17:00:00" style="width:170px;" />

	    		        </td>
	    		    </tr>
	    		    <tr>
	    			    <td  style="text-align:right"><% =Resources.Lan.EndTime %>:</td>
	    			    <td>
    	    				<input id="txtEndTime" disabled="disabled" class="easyui-timespinner" data-options="min:'00:00:00',max:'23:59:59',showSeconds:true" value="18:00:00" style="width:170px;" />

	    		        </td>
	    		    </tr>
	    		    <tr>
	    			    <td  style="text-align:right"><% =Resources.Lan.LeaveFenceAreaAlarm%>:</td>
	    			    <td>
	    		            <input type="checkbox" id="chkWeekEnd" name="chkWeekEnd" value="<% =Resources.Lan.WeekEnd %>" /><% =Resources.Lan.WeekEnd %>
	    		            <input type="checkbox" id="chkHolidays" name="chkHolidays" value="<% =Resources.Lan.Holidays %>" /><% =Resources.Lan.Holidays%>
	    		            <a href="#;" class="easyui-linkbutton" data-options="iconCls:'icon-setting'" onclick="OpenInfoCmd('Htmls/Reports/FormHolidaysSetting.aspx',600,400,'<% =Resources.Lan.Holidays%>');"></a>   
	    		        </td>
	    		    </tr>
	    		    <tr id="trSms1">
	    			    <td  style="text-align:right"><% =Resources.Lan.SmsNotice%>:</td>
	    			    <td>
	    		            <input id="txtSms" class="easyui-textbox" data-options="multiline:true" style="width:170px; height:99%;">
	    		        </td>
	    		    </tr>
	    		    <tr id="trSms2">
	    			    <td  style="text-align:right"></td>
	    			    <td>
	    			        <div style="width:160px;word-break:break-all">
    	    				    <% =Resources.Lan.SimSeparated %>
	    			        </div>
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
