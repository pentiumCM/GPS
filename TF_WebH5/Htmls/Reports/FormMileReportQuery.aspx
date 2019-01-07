<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FormMileReportQuery.aspx.cs" Inherits="Htmls_Reports_FormMileReportQuery" %>

<!DOCTYPE html>
<html>
<head >
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <%--<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />--%>
    <title><% =Resources.Lan.MileageReport%></title>
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
    <script type="text/javascript" src="../../Js/AutoComplete.js"></script>     <script type="text/javascript" src="../../Js/JsCookies.js"></script>  
    <script type="text/javascript" src="../../Js/JExcel.js?v=3"></script> 
    <%--<script type="text/javascript" src="../EasyUI/easyui-lang-zh_CN.js"></script> --%>
    <script type="text/javascript">
//        dynamicLoading.js("../EasyUI/easyui-lang-zh_CN.js");
        var sLan = "<% =Resources.Lan.Language  %>";
        if(sLan == "zh")
        {
            document.write("<script src='../../EasyUI/easyui-lang-zh_CN.js'><\/script>");
        }
        
        $(document).ready(function() { 
            var sMileVersion = '<% =System.Configuration.ConfigurationManager.AppSettings["MileReport"]  %>';
            if(sMileVersion == "2")
            {
                $('#GridReport').datagrid('hideColumn','StartMile'); 
                $('#GridReport').datagrid('hideColumn','EndMile'); 
                $('#GridReport').datagrid('hideColumn','Oil'); 
                $('#GridReport').datagrid('hideColumn','OilPrice'); 
            }
            $('#DivAutoComplete').hide();
            var myDate = new Date();
            $('#txtBeginTime').datetimebox('setValue', formatterSearch(myDate,"00:00:01"));
            $('#txtEndTime').datetimebox('setValue', formatterSearch(myDate,"23:59:59"));
            window.parent.window.InitVehAndGroup("<% =Resources.Lan.MileageReport  %>");    
            AutoText("txtVeh",jsonVehs);        
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
            var sVehidTemp = Request["VehID"];
		    if(sVehidTemp == undefined || sVehidTemp == null)
		    {
		        window.parent.window.SetTreeVeh("<% =Resources.Lan.MileageReport  %>");
		    }
		    else
		    {
                $.each(jsonVehs, function(j, item){
                     if(item.id == sVehidTemp)
                     {
                        iSearchID = sVehidTemp.substring(1);
                        $('#txtVeh').val(item.name); 
                        return false; 
                     }
                });
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
                function SetTreeVeh(vehID,cph)        {            iSearchID = vehID;
            $('#txtVeh').val(cph);        }        
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
//            if(row.id[0] == 'G')
//            {
//                return row.name;
//            }      
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
                    }
                }
            }
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
		
		var iSearchID = "-1";
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
		//轨迹查询
		var dtTime1 = new Date();
        var dtTime2 = new Date();
        var dataHistory = new Array();
        var TotalDay = 0;
        var sWorkTimeBegin = "1900-01-01 00:00:01";
        var sWorkTimeEnd = "1900-01-01 23:59:59";
        var arrVehQuery = new Array();
        var iVehIndex  =0;
        function Query()
        {
            arrVehQuery.length = 0;
            ClearHistoryTable();
            iVehIndex = 0;
//            $("#btnAllPlace").linkbutton({disabled:true});
            dataHistory.length = 0;
            var sBegin = $.trim($('#txtBeginTime').datetimebox('getValue'));
            var sEnd = $.trim($('#txtEndTime').datetimebox('getValue'));
            var sVeh = $.trim($('#txtVeh').val());
            var sUserName = GetCookie("username");
            var sPwd = GetCookie("pwd");
            var sStatistical= $('#txtStatistical').combobox('getValue');
            var arrFilter = $('#txtDateFilter').combobox('getValues');
            var sFilter = "";
            $.each(arrFilter,function(i,value){
                if(sFilter == "")
                {
                    sFilter = value;
                }
                else
                {
                    sFilter = sFilter + "," + value;
                }
            });
            if(sVeh.length == 0)
            {
                OpenInfo("<% =Resources.Lan.Plate %><% =Resources.Lan.NoEmpty %>");
                return;
            }
            if(iSearchID.length <= 0)
            {
                OpenInfo("<% =Resources.Lan.Plate %> <% =Resources.Lan.NoEmpty %>");
                return;
            }
            if(iSearchID[0] == "V")
            {
                $.each(jsonVehs,function(i,value){
                    if(value.id == iSearchID)
                    {
                        arrVehQuery.push({ "ID": value.id, "taxino": value.taxino});
                        return false;
                    }
                });
            }
            else
            {
                var arrGroupID = new Array();
                arrGroupID.push(iSearchID);
                var arrChildID = new Array();
                $.each(jsonVehGroup,function(i,value){
                    if(value.PID == iSearchID)
                    {
                        arrGroupID.push(value.id);
                        arrChildID.push(value.id);
                    }
                });
                while(arrChildID.length > 0)
                {
                    var arrChildItems = new Array();
                    $.each(arrChildID,function(i,value){
                        $.each(jsonVehGroup,function(j,value2){
                            if(value == value2.PID)
                            {
                                arrGroupID.push(value2.id);
                                arrChildItems.push(value2.id);
                            }
                        });
                    });
                    arrChildID.length =0;
                    arrChildID = arrChildItems;
                }
                $.each(arrGroupID,function(i,value){
                    $.each(jsonVehs,function(j,value2){
                        if(value == value2.GID)
                        {
                            arrVehQuery.push({ "ID": value2.id, "taxino": value2.taxino});
                        }
                    });
                });
            }
            if(arrVehQuery.length == 0)
            {
                OpenInfo("<% =Resources.Lan.Plate %> <% =Resources.Lan.NoEmpty %>");
                return;
            }
            if(sBegin.length == 0)
            {
                OpenInfo("<% =Resources.Lan.StartTime %> <% =Resources.Lan.NoEmpty %>");
                return;
            }
            if(sEnd.length == 0)
            {
                OpenInfo("<% =Resources.Lan.EndTime %> <% =Resources.Lan.NoEmpty %>");
                return;
            }
            if($('#chkWorkTime')[0].checked)
            {
                var sHour1 = $('#txtWorkBeginTime').timespinner('getHours');
                var sMinute1 = $('#txtWorkBeginTime').timespinner('getMinutes');
                var sSecond1 = $('#txtWorkBeginTime').timespinner('getSeconds');
                var sHour2 = $('#txtWorkEndTime').timespinner('getHours');
                var sMinute2 = $('#txtWorkEndTime').timespinner('getMinutes');
                var sSecond2 = $('#txtWorkEndTime').timespinner('getSeconds');
                if(sHour2 < sHour1)
                {
                    OpenInfo("【<% =Resources.Lan.WorkTime %>】<% =Resources.Lan.StartTimeNotGreaterEndTime %>");
                    return;
                }
                else if(sHour2 == sHour1)
                {
                    if(sMinute2 < sMinute1)
                    {
                        OpenInfo("【<% =Resources.Lan.WorkTime %>】<% =Resources.Lan.StartTimeNotGreaterEndTime %>");
                        return;
                    }
                    else if(sMinute2 == sMinute1)
                    {
                        if(sSecond2 < sSecond1)
                        {
                            OpenInfo("【<% =Resources.Lan.WorkTime %>】<% =Resources.Lan.StartTimeNotGreaterEndTime %>");
                            return;
                        }
                    }
                }
                sWorkTimeBegin = "1900-01-01 " + (Array(2>sHour1?(2-(''+sHour1).length+1):0).join(0)+sHour1) + ":" + (Array(2>sMinute1?(2-(''+sMinute1).length+1):0).join(0)+sMinute1)+ ":" + (Array(2>sSecond1?(2-(''+sSecond1).length+1):0).join(0)+sSecond1);
                sWorkTimeEnd = "1900-01-01 " + (Array(2>sHour2?(2-(''+sHour2).length+1):0).join(0)+sHour2) + ":" + (Array(2>sMinute2?(2-(''+sMinute2).length+1):0).join(0)+sMinute2)+ ":" + (Array(2>sSecond2?(2-(''+sSecond2).length+1):0).join(0)+sSecond2);
            }
            var Request = GetRequest();
//            var sOpenid = Request["openid"];
//		    if(sOpenid == undefined || sOpenid == null)
//		    {
//		        OpenInfo("微信授权错误！");
//                return;
//		    }
            var dtBegin = new Date(sBegin.replace(/-/g,"/"));
            var dtEnd = new Date(sEnd.replace(/-/g,"/"));
            var date3=dtEnd.getTime()-dtBegin.getTime();
            //计算出相差天数
            TotalDay= Math.floor(date3/(24*3600*1000));
            dtTime1 =dtBegin;
            dtTime2 = dtEnd;
//            if(true)
//            {            
//                var y = dtBegin.getFullYear();
//			    var m = dtBegin.getMonth()+1;
//			    var d = dtBegin.getDate() + 1;
//                var sTime1 = y + "/" + (m<10?('0'+m):m)+'/'+(d<10?('0'+d):d) + " 00:00:01";
//                dtTime1 = new Date(sTime1);
//            }
//            dtTime2 = dtEnd;
            var sUserType = "2";
//            if(bUserID)
//            {
//                sUserType = "1";
//            }
            if(isNaN(dtBegin))
            {
                OpenInfo("<% =Resources.Lan.StartTime %> <% =Resources.Lan.FillInError %>");
                return;
            }
            if(isNaN(dtEnd))
            {
                OpenInfo("<% =Resources.Lan.EndTime %> <% =Resources.Lan.FillInError %>");
                return;
            }
            if(dtBegin > dtEnd)
            {
                OpenInfo("<% =Resources.Lan.StartTimeNotGreaterEndTime %>");
                return;
            }
            bQuery = false;
            var sQueryTime1 = "";
            var sQueryTime2 = "";
            if(arrVehQuery.length > 1)
            {
                var y = dtBegin.getFullYear();
			    var m = dtBegin.getMonth()+1;
			    var d = dtBegin.getDate();
                var sTimeEnd = y + "-" + (m<10?('0'+m):m)+'-'+(d<10?('0'+d):d) + " 23:59:59";
                 sQueryTime1 = formatter1(dtTime1);
                 sQueryTime2 = formatter1(dtTime2);
                 bQuery = true;
                 OpenLoding(1);
    //            OpenInfo(formatter1(dtBegin) + "    " + sTimeEnd); 
    //            GetNextHistory();
            }
            else
            {
                //同一天查询
                bQuery = false;
                sQueryTime1 = formatter1(dtTime1);
                 sQueryTime2 = formatter1(dtTime2);
                 OpenLoding(1);
    //            OpenInfo(formatter1(dtBegin) + "    " + formatter1(dtEnd)); 
                $.ajax({
                    url: "../../Ashx/VehMileReport.ashx",
                    cache:false,
                    type:"get",
                    dataType:'json',
                    data:{VehID:arrVehQuery[iVehIndex].ID,BeginTime:sQueryTime1,EndTime:sQueryTime2,UseType:sUserType, DataType: sStatistical, iCmdID: arrVehQuery[iVehIndex].taxino, bWorkTime: $('#chkWorkTime')[0].checked, sWorkStart: sWorkTimeBegin, sWorkEnd: sWorkTimeEnd,username:sUserName,Pwd:sPwd,Filter:sFilter},
                    success:function(data){
                        if(data.result == "false")
                        {
//                            OpenInfo("查询失败：" + data.err);
                            $('#dlgLoding').dialog('close');
                        }
                        else
                        {
                            $('#dlgLoding').dialog('close');
                            if(data.data.length > 0)
                            {
                                var dOilData = parseFloat($.trim($('#txtOil').val()));
                                var dPrice = parseFloat($.trim($('#txtPrice').val()));
                                for(var i = 0; i < data.data.length;i++)
                                {
                                    if(data.data[i].TotalMile < 0)
                                    {
                                        data.data[i].TotalMile = 0;
                                        data.data[i].EndMile = data.StartMile;
                                    }
                                    data.data[i].TotalMile = data.data[i].TotalMile / 1000;
                                    data.data[i].StartMile = data.data[i].StartMile / 1000;
                                    data.data[i].EndMile = data.data[i].EndMile / 1000;
                                   if($("#chkMileCor")[0].checked)                                   {
                                        //里程修正
                                       var dMileScale = parseFloat($.trim($('#txtMileCorValue').val()));
                                       if ($.trim($('#txtMileCorType').combobox('getValue')) == "0")
                                       {
                                           data.data[i].TotalMile = data.data[i].TotalMile * (1 + dMileScale / 100);
                                       }
                                       else
                                       {
                                           data.data[i].TotalMile = data.data[i].TotalMile * (1 - dMileScale / 100);
                                       }
                                   }
                                   data.data[i].Oil = data.data[i].TotalMile * dOilData / 100;
                                   data.data[i].OilPrice = data.data[i].Oil * dPrice;
                                   data.data[i].Oil = data.data[i].Oil.toFixed(3);
                                   data.data[i].OilPrice = data.data[i].OilPrice.toFixed(3);
                                }
                                dataHistory.push(data.data);
                            }
                        }
                        var iCount = 0;
                        for(var i = 0;i<dataHistory.length;i++)
                        {
                            iCount = iCount + dataHistory[i].length;
                        }
                        OpenInfo("<% =Resources.Lan.QueryCompleteTotal %>" + iCount + "<% =Resources.Lan.Datas %>");
                        if(iCount > 0)
                        {         
                            ClearHistoryTable();
                            AddToHistoryTable();
                            return;
                        }
                        else
                        {
                            ClearHistoryTable();
                        }
                    },
                    error: function(e) { 
                        $('#dlgLoding').dialog('close');
                        OpenInfo(e.responseText); 
                    } 
                });
                return;
            }
            $.ajax({
                    url: "../../Ashx/VehMileReport.ashx",
                    cache:false,
                    type:"post",
                    dataType:'json',
                    data:{VehID:arrVehQuery[iVehIndex].ID,BeginTime:sQueryTime1,EndTime:sQueryTime2,UseType:sUserType, DataType: sStatistical, iCmdID: arrVehQuery[iVehIndex].taxino, bWorkTime: $('#chkWorkTime')[0].checked, sWorkStart: sWorkTimeBegin, sWorkEnd: sWorkTimeEnd,username:sUserName,Pwd:sPwd,Filter:sFilter},
                    success:function(data){
                        iVehIndex = iVehIndex + 1;
                        if(data.result == "true")
                        {
                            if(data.data.length > 0)
                            {
                                var dOilData = parseFloat($.trim($('#txtOil').val()));
                                var dPrice = parseFloat($.trim($('#txtPrice').val()));
                                for(var i = 0; i < data.data.length;i++)
                                {
                                    if(data.data[i].TotalMile < 0)
                                    {
                                        data.data[i].TotalMile = 0;
                                        data.data[i].EndMile = data.StartMile;
                                    }
                                    data.data[i].TotalMile = data.data[i].TotalMile / 1000;
                                    data.data[i].StartMile = data.data[i].StartMile / 1000;
                                    data.data[i].EndMile = data.data[i].EndMile / 1000;
                                   if($("#chkMileCor")[0].checked)                                   {
                                        //里程修正
                                       var dMileScale = parseFloat($.trim($('#txtMileCorValue').val()));
                                       if ($.trim($('#txtMileCorType').combobox('getValue')) == "0")
                                       {
                                           data.data[i].TotalMile = data.data[i].TotalMile * (1 + dMileScale / 100);
                                       }
                                       else
                                       {
                                           data.data[i].TotalMile = data.data[i].TotalMile * (1 - dMileScale / 100);
                                       }
                                   }
                                   data.data[i].Oil = data.data[i].TotalMile * dOilData / 100;
                                   data.data[i].OilPrice = data.data[i].Oil * dPrice;
                                   data.data[i].Oil = data.data[i].Oil.toFixed(3);
                                   data.data[i].OilPrice = data.data[i].OilPrice.toFixed(3);
                                }
                                dataHistory.push(data.data);
                            }
                        }
                        OpenLoding((iVehIndex * 100  / arrVehQuery.length).toFixed(0)); 
                        if(bQuery)
                        {
                            GetNextHistory();
                        }
                    },
                    error: function(e) { 
                        iVehIndex = iVehIndex + 1;
                        bQuery = false;                    
                        $('#dlgLoding').dialog('close');
                        OpenInfo(e.responseText); 
                    } 
                });
        }
        
        function GetNextHistory()
        {
            var sQueryBeginTime = "";
            var sQueryEndTime = "";
            var sStatistical= $('#txtStatistical').combobox('getValue');
            var arrFilter = $('#txtDateFilter').combobox('getValues');
            var sFilter = "";
            $.each(arrFilter,function(i,value){
                if(sFilter == "")
                {
                    sFilter = value;
                }
                else
                {
                    sFilter = sFilter + "," + value;
                }
            });
            var sUserName = GetCookie("username");
            var sPwd = GetCookie("pwd");
            var Request = GetRequest();
//            var sOpenid = Request["openid"];
//		    if(sOpenid == undefined || sOpenid == null)
//		    {
//		        OpenInfo("微信授权错误！");
//                return;
//		    }
            var sUserType = "2";
//            if(bUserID)
//            {
//                sUserType = "1";
//            }
            var date3=dtTime2.getTime()-dtTime1.getTime();
            //计算出相差天数
            var days=Math.floor(date3/(24*3600*1000));
            var procDay = parseInt(((TotalDay - days) / TotalDay * 100));
            if(procDay == 0)
            {
                procDay = 1;
            }
            if(iVehIndex < arrVehQuery.length - 1)
            {
                var y = dtTime1.getFullYear();
			    var m = dtTime1.getMonth()+1;
			    var d = dtTime1.getDate();
                var sTimeEnd = y + "-" + (m<10?('0'+m):m)+'-'+(d<10?('0'+d):d) + " 23:59:59";
                 sQueryBeginTime = formatter1(dtTime1);
                 sQueryEndTime =  formatter1(dtTime2);
                 bQuery = true;
                 OpenLoding((iVehIndex * 100  / arrVehQuery.length).toFixed(0)); 
            }
            else
            {
                bQuery = false;
                sQueryBeginTime = formatter1(dtTime1);
                sQueryEndTime = formatter1(dtTime2);
    //            OpenInfo(formatter1(dtTime1) + "    " + formatter1(dtTime2));
                $.ajax({
                    url: "../../Ashx/VehMileReport.ashx",
                    cache:false,
                    type:"get",
                    dataType:'json',
                    data:{VehID:arrVehQuery[iVehIndex].ID,BeginTime:sQueryBeginTime,EndTime:sQueryEndTime,UseType:sUserType, DataType: sStatistical, iCmdID: arrVehQuery[iVehIndex].taxino, bWorkTime: $('#chkWorkTime')[0].checked, sWorkStart: sWorkTimeBegin, sWorkEnd: sWorkTimeEnd,username:sUserName,Pwd:sPwd,Filter:sFilter},
                    success:function(data){
                        if(data.result == "false")
                        {
//                            OpenInfo("查询失败：" + data.err);
                            $('#dlgLoding').dialog('close');
                        }
                        else
                        {
                            $('#dlgLoding').dialog('close');
                            if(data.data.length > 0)
                            {
                                var dOilData = parseFloat($.trim($('#txtOil').val()));
                                var dPrice = parseFloat($.trim($('#txtPrice').val()));
                                for(var i = 0; i < data.data.length;i++)
                                {
                                    if(data.data[i].TotalMile < 0)
                                    {
                                        data.data[i].TotalMile = 0;
                                        data.data[i].EndMile = data.StartMile;
                                    }
                                    data.data[i].TotalMile = data.data[i].TotalMile / 1000;
                                    data.data[i].StartMile = data.data[i].StartMile / 1000;
                                    data.data[i].EndMile = data.data[i].EndMile / 1000;
                                   if($("#chkMileCor")[0].checked)                                   {
                                        //里程修正
                                       var dMileScale = parseFloat($.trim($('#txtMileCorValue').val()));
                                       if ($.trim($('#txtMileCorType').combobox('getValue')) == "0")
                                       {
                                           data.data[i].TotalMile = data.data[i].TotalMile * (1 + dMileScale / 100);
                                       }
                                       else
                                       {
                                           data.data[i].TotalMile = data.data[i].TotalMile * (1 - dMileScale / 100);
                                       }
                                   }
                                   data.data[i].Oil = data.data[i].TotalMile * dOilData / 100;
                                   data.data[i].OilPrice = data.data[i].Oil * dPrice;
                                   data.data[i].Oil = data.data[i].Oil.toFixed(3);
                                   data.data[i].OilPrice = data.data[i].OilPrice.toFixed(3);
                                }
                                dataHistory.push(data.data);
                            }
                        }
                        var iCount = 0;
                        for(var i = 0;i<dataHistory.length;i++)
                        {
                            iCount = iCount + dataHistory[i].length;
                        }
                        OpenInfo("<% =Resources.Lan.QueryCompleteTotal %>" + iCount + "<% =Resources.Lan.Datas %>");
                        if(iCount > 0)
                        {  
                            ClearHistoryTable();
                            AddToHistoryTable();
                            return;
                        }
                        else
                        {
                            ClearHistoryTable();
                        }
                        
                    },
                    error: function(e) { 
                        bQuery = false;
                        $('#dlgLoding').dialog('close');
                        OpenInfo(e.responseText); 
                    } 
                });
                return;
            }
//            dtTime1.setDate(dtTime1.getDate()+1);
            try{
    //        OpenInfo(sQueryBeginTime + "    " + sQueryEndTime);
            $.ajax({
                    url: "../../Ashx/VehMileReport.ashx",
                    cache:false,
                    type:"get",
                    dataType:'json',
                    data:{VehID:arrVehQuery[iVehIndex].ID,BeginTime:sQueryBeginTime,EndTime:sQueryEndTime,UseType:sUserType, DataType: sStatistical, iCmdID: arrVehQuery[iVehIndex].taxino, bWorkTime: $('#chkWorkTime')[0].checked, sWorkStart: sWorkTimeBegin, sWorkEnd: sWorkTimeEnd,username:sUserName,Pwd:sPwd,Filter:sFilter},
                    success:function(data){
                        iVehIndex = iVehIndex + 1;
                        $('#dlgLoding').dialog('close');
                        if(data.result == "true")
                        {
                            if(data.data.length > 0)
                            {
                                var dOilData = parseFloat($.trim($('#txtOil').val()));
                                var dPrice = parseFloat($.trim($('#txtPrice').val()));
                                for(var i = 0; i < data.data.length;i++)
                                {
                                    if(data.data[i].TotalMile < 0)
                                    {
                                        data.data[i].TotalMile = 0;
                                        data.data[i].EndMile = data.StartMile;
                                    }
                                    data.data[i].TotalMile = data.data[i].TotalMile / 1000;
                                    data.data[i].StartMile = data.data[i].StartMile / 1000;
                                    data.data[i].EndMile = data.data[i].EndMile / 1000;
                                   if($("#chkMileCor")[0].checked)                                   {
                                        //里程修正
                                       var dMileScale = parseFloat($.trim($('#txtMileCorValue').val()));
                                       if ($.trim($('#txtMileCorType').combobox('getValue')) == "0")
                                       {
                                           data.data[i].TotalMile = data.data[i].TotalMile * (1 + dMileScale / 100);
                                       }
                                       else
                                       {
                                           data.data[i].TotalMile = data.data[i].TotalMile * (1 - dMileScale / 100);
                                       }
                                   }
                                   data.data[i].Oil = data.data[i].TotalMile * dOilData / 100;
                                   data.data[i].OilPrice = data.data[i].Oil * dPrice;
                                   data.data[i].Oil = data.data[i].Oil.toFixed(3);
                                   data.data[i].OilPrice = data.data[i].OilPrice.toFixed(3);
                                }
                                dataHistory.push(data.data);
                            }
                        }
                        if(bQuery)
                        {
                            GetNextHistory();
                        }
                    },
                    error: function(e) { 
                        bQuery = false;
                        $('#dlgLoding').dialog('close');
                        OpenInfo(e.responseText); 
                    } 
                });
                }
                catch(e)
                {
                ShowInfo(e.message);
                }
        }
        
        function AddToHistoryTable()
        {
            var loadDatas = new Array();            for(var i = 0;i<dataHistory.length;i++)            {                for(var j = 0; j<dataHistory[i].length;j++)                {                    loadDatas.push(dataHistory[i][j]);                }            }
            var sStatistical= $('#txtStatistical').combobox('getValue');
            if(sStatistical == "0")
            {
                var sBegin = $.trim($('#txtBeginTime').datetimebox('getValue'));
                var sEnd = $.trim($('#txtEndTime').datetimebox('getValue'));
                var dtBegin = new Date(sBegin.replace(/-/g,"/"));
                var dtEnd = new Date(sEnd.replace(/-/g,"/"));
                dtEnd = new Date((dtEnd/1000+(86400*1))*1000);
                var sStart = dtBegin.getFullYear() * 10000 + dtBegin.getMonth() * 100 + dtBegin.getDate();
                var sEnd = dtEnd.getFullYear() * 10000 + dtEnd.getMonth() * 100 + dtEnd.getDate();
                var arrCph = new Array();
                for(var i = 0; i < loadDatas.length;i++)
                {
                    var bExists = false;
                    for(var j = 0; j < arrCph.length;j++)
                    {
                        if(arrCph[j].Cph == loadDatas[i].Cph)
                        {
                            bExists = true;
                            break;
                        }
                    }
                    if(!bExists)
                    {
                        arrCph.push({"Cph":loadDatas[i].Cph,"VehID":loadDatas[i].VehID});
                    }
                }
                while(sStart != sEnd)
                {
                    for(var j = 0; j < arrCph.length;j++)
                    {
                        var bExistsCph = false;
                        var bLastIndex = -1;
                        for(var i = 0; i < loadDatas.length;i++)
                        {
                            if(loadDatas[i].Cph == arrCph[j].Cph)
                            {
                                bExistsCph = true;
                                bLastIndex = i + 1;
                                var sTime = loadDatas[i].StartTime;
                                var dtTime = new Date(sTime.replace(/-/g,"/"));
                                var sDate = dtTime.getFullYear() * 10000 + dtTime.getMonth() * 100 + dtTime.getDate();
                                if(sDate == sStart)
                                {
                                    bLastIndex = -1;
                                    break;
                                }
                                if(sDate > sStart)
                                {
                                    bLastIndex = -1;
                                    // 拼接函数(索引位置, 要删除元素的数量, 元素)  
                                    loadDatas.splice(i, 0, {"Cph":arrCph[j].Cph,"StartTime":"","EndMile":"","EndTime":"","Oil":"","OilPrice":"","StartMile":"","TotalMile":"","VehID":arrCph[j].VehID});   
                                    break;                     
                                }
                            }
                        };
                        if(!bExistsCph || bLastIndex != -1)
                        {
                            var iAddIndex = loadDatas.length;
                            if(bLastIndex != -1)
                            {
                                iAddIndex = bLastIndex;
                            }
                           loadDatas.splice(iAddIndex, 0, {"Cph":arrCph[j].Cph,"StartTime":"","EndMile":"","EndTime":"","Oil":"","OilPrice":"","StartMile":"","TotalMile":"","VehID":arrCph[j].VehID});   
                        }
                    }
                    dtBegin = new Date((dtBegin/1000+(86400*1))*1000);
                    sStart = dtBegin.getFullYear() * 10000 + dtBegin.getMonth() * 100 + dtBegin.getDate();
                }
                
                var sCphTemp = "";
                var sTotalMile =  0;
                var iCphTemp = 0;
                var bAddTemp = true;
                for(var i  = 0; i < loadDatas.length; i++)
                {
                    if(i == 0)
                    {
                        sCphTemp = loadDatas[i].Cph;
                        iCphTemp = loadDatas[i].VehID;
                        if(loadDatas[i].TotalMile == "")
                        {
                            sTotalMile = 0;
                        }
                        else
                        {
                            sTotalMile = parseFloat(loadDatas[i].TotalMile);
                        }
                        bAddTemp = false;
                    }
                    else
                    {
                        if(sCphTemp != loadDatas[i].Cph)
                        {
                            loadDatas.splice(i, 0, {"Cph":sCphTemp,"StartTime":"<% =Resources.Lan.Total %>：","EndMile":"","EndTime":"","Oil":"","OilPrice":"","StartMile":"","TotalMile":sTotalMile,"VehID":iCphTemp});   
                            i = i + 1;
                            sCphTemp = loadDatas[i].Cph;
                            iCphTemp = loadDatas[i].VehID;
                            if(loadDatas[i].TotalMile == "")
                            {
                                sTotalMile = 0;
                            }
                            else
                            {
                                sTotalMile = parseFloat(loadDatas[i].TotalMile);
                            } 
                            bAddTemp = false; 
                        }
                        else
                        {
                            if(loadDatas[i].TotalMile == "")
                            {
                                
                            }
                            else
                            {
                                sTotalMile = sTotalMile + parseFloat(loadDatas[i].TotalMile);
                            }
                            bAddTemp = false; 
                        }
                    }
                }
                if(!bAddTemp)
                {
                   loadDatas.splice(loadDatas.length, 0, {"Cph":sCphTemp,"StartTime":"<% =Resources.Lan.Total %>：","EndMile":"","EndTime":"","Oil":"","OilPrice":"","StartMile":"","TotalMile":sTotalMile,"VehID":iCphTemp});   
                }
                $('#GridReport').datagrid('loadData',loadDatas); 
                            $('#GridReport').datagrid('sort', {
	                            sortName: 'Cph,StartTime',
	                            sortOrder: 'asc,asc'
                            });
                var merges = new Array();
                sCphTemp = "";
                var mIndex = 0;
                if(loadDatas.length > 0)
                {
                    sCphTemp = loadDatas[0].Cph;
                }
                for(var i = 0; i < loadDatas.length;i++)
                {
                    if(sCphTemp != loadDatas[i].Cph)
                    {
                        merges.push({"index":mIndex,"rowspan":(i - mIndex)});
                        sCphTemp = loadDatas[i].Cph;
                        mIndex = i;
                    }
                    else if(i == loadDatas.length - 1)
                    {
                        merges.push({"index":mIndex,"rowspan":(i - mIndex + 1)});
                    }
                }
                
			    for(var i=0; i<merges.length; i++){
				    $('#GridReport').datagrid('mergeCells',{
					    index: merges[i].index,
					    field: 'Cph',
					    rowspan: merges[i].rowspan
				    });
			    }
			}
			else
			{			    
                $('#GridReport').datagrid('loadData',loadDatas); 
                            $('#GridReport').datagrid('sort', {
	                            sortName: 'Cph,StartTime',
	                            sortOrder: 'asc,asc'
                            });
			}
        }
        
        var bQuery = false;
        
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
         
         function ChangeWorkEnable(owner)
         {
            if(owner.checked)
            {
                $("#txtWorkBeginTime").timespinner({ disabled: false });
                $("#txtWorkEndTime").timespinner({ disabled: false });
            }
            else
            {
                $("#txtWorkBeginTime").timespinner({ disabled: true });
                $("#txtWorkEndTime").timespinner({ disabled: true });
            }
         }
         
         function ChangeMileCor(owner)
         {
            if(owner.checked)
            {
                $("#txtMileCorType").combobox({ disabled: false });
                $("#txtMileCorValue").numberbox('enable');
            }
            else
            {
                $("#txtMileCorType").combobox({ disabled: true });
                $("#txtMileCorValue").numberbox('disable');
            }
         }
         
         function getDaysInOneMonth(year, month){  
          month = parseInt(month, 10);  
          var d= new Date(year, month, 0);  
          return d.getDate();  
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
       
       function CloseInfoCmd()
        {
            $('#openRoleDiv').window('close');
        }
        
        function OpenInfoCmd(url,thisWidth,thisHeight,thisTitle)        {
              window.parent.window.OpenInfoCmd(url,thisWidth,thisHeight,thisTitle);        }
    </script>
</head><%--oncontextmenu="return false" --%>
<body class="easyui-layout" id="bodyLayout" style="overflow-y: hidden; scroll:"no">
    <div id="DivAutoComplete" class="panel combo-p" style="z-index: 110003; position: absolute; display: none; height: 300px; ">
        <div style="float:right; "><img title="" src="../../EasyUI/themes/icons/cancel.png" onclick="VehClose();" /></div>
        <div style="float:left">
            <table id="tgVeh" class="easyui-treegrid" style=" float:left; height:200px; width:200px" 
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
		                <th data-options="field:'sim'" width="90"><% =Resources.Lan.Sim%></th>
		                <th data-options="field:'taxino'" width="100"><% =Resources.Lan.TaxiNo%></th>
		                <th data-options="field:'ipaddress'" width="94"><% =Resources.Lan.IpAddress%></th>
		            </tr>
		        </thead>
	        </table>
	    </div>
    </div>		
    <div region="north" split="true" border="true" style="overflow: hidden; font-family: Verdana, 微软雅黑,黑体; padding:2px; height:104px">
        <div>
                <table>
                    <tr>
                        <td style="text-align:right; width:120px;">
                            <% =Resources.Lan.Plate%>：
                        </td>
                        <td style="width:155px">
                            <input id="txtVeh" style="width:120px;" name = "txtVeh" type="text" value="" />
				            <img alt="" title="" src="../../EasyUI/themes/icons/search.png" onclick="ShowDivVehTree();" /> 
				        </td>
				        <td style="text-align:right; width:80px;">
                            <% =Resources.Lan.StartTime%>：
                        </td>
                        <td style="width:155px">
                            <input id="txtBeginTime"  editable="false" class="easyui-datetimebox" style="width:150px;" name="txtBeginTime" data-options="formatter:formatter1,parser:parser1,showSeconds:true" value="2016-04-02 00:00:01" />
                        </td>
                        <td style="text-align:right; width:100px;">
                            <% =Resources.Lan.EndTime%>：
                        </td>
                        <td style="width:155px">
                            <input id="txtEndTime" editable="false" class="easyui-datetimebox" style="width:150px;" name="txtEndTime" data-options="formatter:formatter1,parser:parser1,showSeconds:true" value="2016-04-02 23:59:59" />
                        </td>
                        <td style="width:150px" colspan="2">
                             <a href="#;" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="Query();"><% =Resources.Lan.Query%></a>
                             <a href="#;" class="easyui-linkbutton" data-options="iconCls:'icon-setting'" onclick="OpenInfoCmd('Htmls/Reports/FormHolidaysSetting.aspx',600,400,'<% =Resources.Lan.Holidays%>');"><% =Resources.Lan.Holidays%></a>   
                        </td>
                    </tr>
                    <tr>
                        <td  style="text-align:right; width:120px;">
                            <input type="checkbox" onclick="ChangeWorkEnable(this);" name="chkWorkTime" id="chkWorkTime" value="<% =Resources.Lan.WorkTime %>" /><% =Resources.Lan.WorkTime%>：
                        </td>
                        <td style="width:155px">
                            <input id="txtWorkBeginTime" disabled="disabled" class="easyui-timespinner" data-options="min:'00:00:00',max:'23:59:59',showSeconds:true" value="08:00:00" style="width:150px;" />
                        </td>
                        <td  style="text-align:right; width:80px;">
                            <% =Resources.Lan.EndTime%>：
                        </td>
                        <td style="width:155px">
                            <input id="txtWorkEndTime" disabled="disabled" class="easyui-timespinner" data-options="min:'00:00:00',max:'23:59:59',showSeconds:true" value="17:00:00" style="width:150px;" />
                        </td>
                        <td  style="text-align:right; width:100px;">
                            <% =Resources.Lan.StatisticalType%>：
                        </td>
                        <td style="width:155px">
                            <select class="easyui-combobox" name="txtStatistical" id="txtStatistical" style="width:150px">
		                        <option value="0"><% =Resources.Lan.ByDay%></option>
		                        <option value="1"><% =Resources.Lan.ByWeek%></option>
		                        <option value="2"><% =Resources.Lan.ByMonth%></option>
		                        <option value="3"><% =Resources.Lan.BySeason%></option>                            </select>
                        </td>                        
                        <td style="width:150px" colspan="2">
                             <a href="#;" class="easyui-linkbutton" data-options="iconCls:'icon-report'" onclick="return Export();"><% =Resources.Lan.Export%></a>   
                        </td>
                    </tr>
                    <tr>
                        <td  style="text-align:right; width:120px;">
                            <% =Resources.Lan.FuelConsumption%>：
                        </td>
                        <td style="width:155px">
                            <input class="easyui-numberbox" style="width:40px" id="txtOil" value="5" data-options="min:0,max:30" />                            <% =Resources.Lan.FuelUnitPer100%>
                        </td>
                        <td  style="text-align:right; width:80px;">
                            <% =Resources.Lan.Price%>：
                        </td>
                        <td style="width:155px">
                            <input class="easyui-numberbox" style="width:50px" precision="2" id="txtPrice" value="6" data-options="min:0.00,max:30.00" />
                            <% =Resources.Lan.YuanPerLiter%>
                        </td>
                        <td  colspan="4">
                            <input type="checkbox" onclick="ChangeMileCor(this)" name="chkMileCor" id="chkMileCor" value="<% =Resources.Lan.MileageCorrectionRatio %>" /><% =Resources.Lan.MileageCorrectionRatio%>：
                            
                            <select class="easyui-combobox" disabled="disabled" name="txtMileCorType" id="txtMileCorType" style="width:60px">
		                        <option value="0"><% =Resources.Lan.Add%></option>
		                        <option value="1"><% =Resources.Lan.Reduce%></option>                            </select>
                            
                            <input class="easyui-numberbox" disabled="disabled" style="width:40px" precision="2" id="txtMileCorValue" value="1" data-options="min:0.00,max:100.00" />%
                            &nbsp;&nbsp;
                            <% =Resources.Lan.Filter%>：
                            <select class="easyui-combobox" data-options="multiple:true,multiline:true" name="txtDateFilter" id="txtDateFilter" style="width:80px; height:24px;">
		                        <option value="3"><% =Resources.Lan.Unlimited %></option>
		                        <option value="0"><% =Resources.Lan.Saturday%></option>
		                        <option value="1"><% =Resources.Lan.Sunday%></option>
		                        <option value="2"><% =Resources.Lan.Holidays%></option>                            </select>
                        </td>
                    </tr>
                </table>
		         
		                      
		</div>
    </div>
    <%--中间--%>
    <div region="center" style="background: #eee; overflow-y:hidden">
            <table id="GridReport" class="easyui-datagrid" style="height:100%" data-options="idField:'id',singleSelect:true,collapsible:true">
		        <thead>
			        <tr>
			            <th data-options="field:'Cph',width:120,sortable:true,order:'desc',remoteSort:false,mergeCell: true"><% =Resources.Lan.Plate%></th>
                        <th data-options="field:'StartTime',width:130,sortable:true,order:'desc',remoteSort:false"><% =Resources.Lan.DialStartTime%></th>
                        <th data-options="field:'StartMile',width:120"><% =Resources.Lan.MileStart%></th>
                        <th data-options="field:'EndTime',width:130"><% =Resources.Lan.DialEndTime%></th>
                        <th data-options="field:'EndMile',width:120"><% =Resources.Lan.MileEnd%></th>
                        <!--<th data-options="field:'Longitude',width:80">经度</th>
                        <th data-options="field:'Latitude',width:80">纬度</th>-->
                        <th data-options="field:'TotalMile',width:120"><% =Resources.Lan.Mileage%></th>
                        <th data-options="field:'Oil',width:110"><% =Resources.Lan.FuelConsumption%></th>
                        <th data-options="field:'OilPrice',width:80"><% =Resources.Lan.Cost%></th>
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
			<a href="javascript:void(0)" class="easyui-linkbutton" style="width:100%;height:35px" onclick="$('#dlg1').dialog('close')"><% =Resources.Lan.Confirm%></a>
		</div>
	</div>
</body>
</html>
