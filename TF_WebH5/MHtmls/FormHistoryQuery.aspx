﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FormHistoryQuery.aspx.cs" Inherits="MHtmls_FormHistoryQuery" %>

<!DOCTYPE html>
<html>
<head >
    <%--<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />--%>
        body, html,#map {width: 100%;height: 100%;overflow: hidden;margin:0;}
        /*@font-face { 
        font-family: 'BaiduCar'; / * 字体名称,可自己定义* / 
            src: url('../EasyUI/Font/BaiduCar.eot') format('embedded-opentype');
            src: local('BaiduCar Regular'), local('BaiduCar Regular'), url('../EasyUI/Font/BaiduCar.ttf') format('truetype'), url('../EasyUI/Font/BaiduCar.svg#BaiduCar') format('svg');
        } */
        @font-face {
		    font-family: BaiduCar;
		    src: url(../EasyUI/Font/cherl.ttf);
		    src: url(../EasyUI/Font/cherl.eot)\9;
	    }
	    
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
	<link rel="stylesheet" type="text/css" href="../EasyUI/themes/metro/easyui.css" />
    <script type="text/javascript" src="../EasyUI/jquery.easyui.mobile.js"></script>
	<script type="text/javascript" src="../Js/Baidu/BaiduMapWrapper.js"></script> 
	<script type="text/javascript" src="../Js/Baidu/BaiduConvertor.js"></script>
	<script type="text/javascript" src="../Js/Baidu/BaiduDrawingManager.js"></script>
    <script type="text/javascript" src="../Js/Baidu/LineOverlay.js"></script>
    <script type="text/javascript" src="../Js/Baidu/BaiduLatLngCorrect.js"></script>
    <script language="javascript" type="text/javascript" src="../Js/Google/GoogleLatLngCorrect.js"></script>
    <script type="text/javascript" src="../Js/NanJingUnit.js"></script>
    <link rel="stylesheet" href="../Css/BaiduDrawingManager.css" />
    <script type="text/javascript">
              "ActionScript",
              "AppleScript",
              "Asp",
              "BASIC",
              "C",
              "C++",
              "Scala",
              "Scheme"
            ];
            for(var i = 0; i < availableTags.length; i++) { 
                if(i == 0)
                {
                    json += "\""+ availableTags[i] + "\""; 
                }
                else
                {
                    json += ",\""+ availableTags[i] + "\""; 
                }
            } 
            json += "]"; 
            {
                return;
            }
            if(jsonVehGroup.length == 0)
            {
                return;
            }
            var sVehidTemp = Request["VehID"];
                     if(item.id == sVehidTemp)
                     {
                        iSearchID = sVehidTemp.substring(1);
                        $('#txtVeh').val(item.name); 
                        return false; 
                     }
                });
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
        {
            iSearchID = vehID.substring(1);
            $('#txtVeh').val(cph);
        }
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
            if(row.id[0] == 'G')
            {
                return row.name;
            }      
             return "<input type='checkbox' onclick=showVehcheck('"+row.id+"') id='check_"+row.id+"' "+(row.checked?'checked':'')+"/>" + row.name;
        }
           var s = 'check_'+checkid;
            $("input[id^='check_']:checked").each(function(){
           if(checkid[0] == 'V')
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
            $('#tgVeh').treegrid('resize',{width:'170px',height:'300px'});
                var id = $(this).attr("id");              
                if(id.indexOf("check_V")>-1)
                {
                    $('#tgVeh').treegrid('select',id.substring(6));
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
//            var sOpenid = Request["openid"];
            TotalDay=Math.floor(date3/(24*3600*1000));
                nextData.setDate(nextData.getDate() + 1);      
			    var m = nextData.getMonth()+1;
			    var d = nextData.getDate();
			    var y = dtBegin.getFullYear();
			    var m = dtBegin.getMonth()+1;
			    var d = dtBegin.getDate();
			    var m = dtBegin.getMonth()+1;
			    var d = dtBegin.getDate();
			    var m = dtBegin.getMonth()+1;
			    var d = dtBegin.getDate();
                $.ajax({
                    url: "../Ashx/VehHistory.ashx",
                    cache:false,
                    type:"get",
                    dataType:'json',
                    data:{Operation:"GetHistory",VehID:iSearchID,BeginTime:sQueryTime1,EndTime:sQueryTime2,UseType:sUserType},
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
                        }
                        else
                        {
                            ClearHistoryTable();
                            clearLine();
                        }
                    },
                    error: function(e) { 
                        $('#dlgLoding').dialog('close');
                        OpenInfo(e.responseText); 
                    } 
                });
                    url: "../Ashx/VehHistory.ashx",
                    cache:false,
                    type:"post",
                    dataType:'json',
                    data:{Operation:"GetHistory",VehID:iSearchID,BeginTime:sQueryTime1,EndTime:sQueryTime2,UseType:sUserType},
                    success:function(data){
                        if(data.result == "true")
                        {
                            if(data.data.length > 0)
                            {
                                dataHistory.push(data.data);
                            }
                        }
                        OpenLoding(50); 
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
//            var sOpenid = Request["openid"];
            var sUserType = "2";
//            if(bUserID)
//            {
//                sUserType = "1";
//            }
            var days=Math.floor(date3/(24*3600*1000));
			    var y = dtTime1.getFullYear();
			    var m = dtTime1.getMonth()+1;
			    var d = dtTime1.getDate();
			    var m = dtTime1.getMonth()+1;
			    var d = dtTime1.getDate();
			    var m = dtTime1.getMonth()+1;
			    var d = dtTime1.getDate();
                    url: "../Ashx/VehHistory.ashx",
                    cache:false,
                    type:"get",
                    dataType:'json',
                    data:{Operation:"GetHistory",VehID:iSearchID,BeginTime:sQueryBeginTime,EndTime:sQueryEndTime,UseType:sUserType},
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
                        }
                        else
                        {
                            ClearHistoryTable();
                            clearLine();
                        }
                        
                    },
                    error: function(e) { 
                        bQuery = false;
                        $('#dlgLoding').dialog('close');
                        OpenInfo(e.responseText); 
                    } 
                });
                    url: "../Ashx/VehHistory.ashx",
                    cache:false,
                    type:"get",
                    dataType:'json',
                    data:{Operation:"GetHistory",VehID:iSearchID,BeginTime:sQueryBeginTime,EndTime:sQueryEndTime,UseType:sUserType},
                    success:function(data){
                        $('#dlgLoding').dialog('close');
                        if(data.result == "true")
                        {
                            if(data.data.length > 0)
                            {
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
            $("#dlgLoding").dialog('open').dialog('center');
			$('#p').progressbar('setValue', value);
        {   
            if(value != undefined)
            {      
                return value.toFixed(5)
             }   
             return value;
         }
        {   
            var content = '';   
            var abValue = value +'';   
            if(value != undefined)
            {      
                if(value.length>=22) 
                {         
//                    abValue = value.substring(0,19) + "...";         
                    content = '<a href="#;" onclick="$.messager.alert(\'<% =Resources.Lan.Tip %>\',\'' + value + '\',\'info\')"  title="' + value + '" class="easyui-tooltip">' + abValue + '</a>';      
                }
                else
                {         
                    content = '<a href="#;" onclick="$.messager.alert(\'<% =Resources.Lan.Tip %>\',\'' + value + '\',\'info\')"  title="' + abValue + '" class="easyui-tooltip">' + abValue + '</a>';      
                }   
             }   
             return content;
         }
        {   
            var content = '';   
            var abValue = value +'';    
            if(value != undefined)
            {      
                if(value.length == 0) 
                {            
                    content = '<a href="javascript:GetPlaceInfo(\'V' + row.id + '\',\'' + index + '\');"  title="<% =Resources.Lan.GetLocationInformation %>" ><% =Resources.Lan.GetLocationInformation %></a>';      
                }
                else
                {         
                    if(value.length>=22) 
                    {         
//                        abValue = value.substring(0,19) + "...";         
                        content = '<a href="#;" onclick="$.messager.alert(\'<% =Resources.Lan.Tip %>\',\'' + value + '\',\'info\')"  title="' + value + '" class="easyui-tooltip">' + abValue + '</a>';      
                    }
                    else
                    {         
                        content = '<a href="#;" onclick="$.messager.alert(\'<% =Resources.Lan.Tip %>\',\'' + value + '\',\'info\')"  title="' + abValue + '" class="easyui-tooltip">' + abValue + '</a>';      
                    }  
                }   
             }   
             return content;
         }   
         {
            try
            {
                var row = $('#tableHistory').datagrid('getSelected');
                if(row == undefined)
                {
                    return;
                }
                iIndex = $('#tableHistory').datagrid('getRowIndex', row);
                if(iIndex != -1)
                {
                    if("google" == '<% =Resources.Lan.MapType  %>')
                    {
                        var googleXY = CheckXYGpsToGoogle(row["Longitude"], row["Latitude"] );
                        var oLon = googleXY[0].lng;
                        var oLat = googleXY[0].lat;
                        $.ajax({
                            url: "http://maps.google.cn/maps/api/geocode/json",
                            cache:false,
                            type:"get",
                            dataType:'json',
                            async:false, 
                            data:{latlng:oLat + "," + oLon,language:"en-US",sensor:false},
                            success:function(data){
                                    if(data.status == "OK")
                                    {  
                                        row["address"] = data.results[0]["formatted_address"].replace("号","");
                                        $('#tableHistory').datagrid('updateRow',{
	                                    index: iIndex,
	                                    row: row});  
                                    }
                                    else
                                    {
	                                       //$("#divState").text(GetErr(data.err));
                                    }
                            },
                            error: function(e) { 
	                             //$("#divState").text(e.responseText);
                            } 
                        }) ;   
                    }
                    else
                    {
                        $.ajax({
                            url: "../Ashx/Place.ashx",
                            cache:false,
                            type:"post",
                            dataType:'json',
                            async:false, 
                            data:{type:'<% =Resources.Lan.MapType  %>',Lat:row["Latitude"],Lng:row["Longitude"]},
                            success:function(data){
                                    if(data.result == "true")
                                    {  
                                        row["address"] = data.data;
                                        $('#tableHistory').datagrid('updateRow',{
	                                    index: iIndex,
	                                    row: row});  
                                    }
                                    else
                                    {
	                                       //$("#divState").text(GetErr(data.err));
                                    }
                            },
                            error: function(e) { 
	                             //$("#divState").text(e.responseText);
                            } 
                        }) ;   
                    }
                }
            }
            catch(e)
            {
                //ShowInfo(row);
            }
         }
        function ShowInfo(info)
        {
            $.messager.alert('<% =Resources.Lan.Tip %>',info,'info');
        }
                {
                    var googleXY = CheckXYGpsToGoogle(row["Longitude"], row["Latitude"] );
                    var oLon = googleXY[0].lng;
                    var oLat = googleXY[0].lat;
                    $.ajax({
                        url: "http://maps.google.cn/maps/api/geocode/json",
                        cache:false,
                        type:"get",
                        dataType:'json',
                        async:false, 
                        data:{latlng:oLat + "," + oLon,language:"en-US",sensor:false},
                        success:function(data){
                                if(data.status == "OK")
                                {  
                                    row["address"] = data.results[0]["formatted_address"].replace("号","");
                                    $('#tableHistory').datagrid('updateRow',{
	                                index: iIndex,
	                                row: row});  
                                }
                                else
                                {
	                                   //$("#divState").text(GetErr(data.err));
                                }
                        },
                        error: function(e) { 
	                         //$("#divState").text(e.responseText);
                        } 
                    }) ;   
                }
                        url: "../Ashx/Place.ashx",
                        cache:false,
                        type:"post",
                        dataType:'json',
                        async:false, 
                        data:{type:'<% =Resources.Lan.MapType  %>',Lat:row["Latitude"],Lng:row["Longitude"]},
                        success:function(data){
                                if(data.result == "true")
                                {  
                                    row["address"] = data.data;
                                    $('#tableHistory').datagrid('updateRow',{
	                                index: iIndex,
	                                row: row});  
                                }
                                else
                                {
	                                   //$("#divState").text(GetErr(data.err));
                                }
                        },
                        error: function(e) { 
	                         //$("#divState").text(e.responseText);
                        } 
                    }) ;   
                    $.each(value,function(j,valuej){
                        valuej["address"] = "";
                        valuej["name"] = $.trim($('#txtVeh').val());
                        if(valuej.Locate == 1)
                        {
                            valuej["LocateStr"] = "<% =Resources.Lan.Location %>";
                        }
                        else if(valuej.Locate == 2)
                        {
                            valuej["LocateStr"] = "<% =Resources.Lan.BasestationLocation %>";
                        }
                        else
                        {
                            valuej["LocateStr"] = "<% =Resources.Lan.NotLocating %>";
                        }
                        valuej["Component"] = GetComponent(valuej["Component"]);
                        valuej["speedangle"] =  (Array(3).join(0) + valuej.Velocity).slice(-3) + "km/h " + AngleToString(valuej.Angle); 
                        arrHistoryDatagrid.push(valuej);
                    });
                }); 
         {
            var sReturn = "";
            try
            {
                if(sLan == "zh")
                {
                    sReturn = sComponent;
                    return sReturn;
                }
                else if(sComponent != undefined)
                {
                    var bAdd = "";
                    var arrComponent = sComponent.split(' ');
                    $.each(arrComponent,function(i,value)
                    {
                        if(value.length > 3)
                        {
                            if(value[0] == 'A' && value[1] == 'D')
                            {
                                sReturn = sReturn + bAdd + value;
                                bAdd = ",";
                                return true;
                            }
                            if(value[0] == '电' && value[1] == '量')
                            {
                                sReturn = sReturn + bAdd + value.replace("电量","<% =Resources.Lan.Battery %>");
                                bAdd = ",";
                                return true;
                            }
                            if(value[0] == '点' && value[1] == '火' && value[2] == '时' && value[3] == '定')
                            {
                                sReturn = sReturn + bAdd + value.replace("点火时定时间隔","<% =Resources.Lan.RightAccOnTimingInterval %>").replace("秒","<% =Resources.Lan.Second %>");
                                bAdd = ",";
                                return true;
                            }
                            if(value[0] == '熄' && value[1] == '火' && value[2] == '时' && value[3] == '定')
                            {
                                sReturn = sReturn + bAdd + value.replace("熄火时定时间隔","<% =Resources.Lan.RightAccOffTimingInterval %>").replace("秒","<% =Resources.Lan.Second %>");
                                bAdd = ",";
                                return true;
                            }
                            if(value[0] == '运' && value[1] == '动')
                            {
                                sReturn = sReturn + bAdd + value.replace("运动模式时长","<% =Resources.Lan.MovementPatternTime %>").replace("分","<% =Resources.Lan.Minute %>");
                                bAdd = ",";
                                return true;
                            }
                            if(value[0] == '静' && value[1] == '止')
                            {
                                sReturn = sReturn + bAdd + value.replace("静止模式时长","<% =Resources.Lan.StaticModelTime %>").replace("分","<% =Resources.Lan.Minute %>");
                                bAdd = ",";
                                return true;
                            }
                            if(value[0] == '已' && value[1] == '发' && value[2] == '条' && value[3] == '数')
                            {
                                sReturn = sReturn + bAdd + value.replace("已发条数","<% =Resources.Lan.SendNum %>");
                                bAdd = ",";
                                return true;
                            }
                            if(value[0] == '剩' && value[1] == '余' && value[2] == '条' && value[3] == '数')
                            {
                                sReturn = sReturn + bAdd + value.replace("剩余条数","<% =Resources.Lan.RemainCount %>");
                                bAdd = ",";
                                return true;
                            }
                        }
                        switch(value)
                        {
                            case "ACC开":
                            case "ACC开(启动)":
                                sReturn = sReturn + bAdd + "<% =Resources.Lan.AccOn %>";
                                bAdd = ",";
                                break;
                            case "ACC关":
                            case "ACC关(熄火) ":
                                sReturn = sReturn + bAdd + "<% =Resources.Lan.AccOff %>";
                                bAdd = ",";
                                break;
                            case "油路正常":
                                sReturn = sReturn + bAdd + "<% =Resources.Lan.PowerNormal %>";
                                bAdd = ",";
                                break;
                            case "油路断开":
                                sReturn = sReturn + bAdd + "<% =Resources.Lan.PowerOff %>";
                                bAdd = ",";
                                break;
                            case "G_Sensor异常":
                                sReturn = sReturn + bAdd + "<% =Resources.Lan.G_SensorAnomaly %>";
                                bAdd = ",";
                                break;
                            case "G_Sensor正常":
                                sReturn = sReturn + bAdd + "<% =Resources.Lan.G_SensorNormal %>";
                                bAdd = ",";
                                break;
                            case "ACAR蓝牙功能开启":
                                sReturn = sReturn + bAdd + "<% =Resources.Lan.ACARBluetoothOpen %>";
                                bAdd = ",";
                                break;
                            case "ACAR蓝牙功能关闭":
                                sReturn = sReturn + bAdd + "<% =Resources.Lan.ACARBluetoothClose %>";
                                bAdd = ",";
                                break;
                            case "刹车":
                                sReturn = sReturn + bAdd + "<% =Resources.Lan.Brakes %>";
                                bAdd = ",";
                                break;
                            case "未刹车":
                                sReturn = sReturn + bAdd + "<% =Resources.Lan.NoBrakes %>";
                                bAdd = ",";
                                break;
                            case "左转向关":
                                sReturn = sReturn + bAdd + "<% =Resources.Lan.SteerLeft %><% =Resources.Lan.DoorClose %>";
                                bAdd = ",";
                                break;
                            case "左转向开":
                                sReturn = sReturn + bAdd + "<% =Resources.Lan.SteerLeft %><% =Resources.Lan.DoorOpen %>";
                                bAdd = ",";
                                break;
                            case "右转向关":
                                sReturn = sReturn + bAdd + "<% =Resources.Lan.SteerRight %><% =Resources.Lan.DoorClose %>";
                                bAdd = ",";
                                break;
                            case "右转向开":
                                sReturn = sReturn + bAdd + "<% =Resources.Lan.SteerRight %><% =Resources.Lan.DoorOpen %>";
                                bAdd = ",";
                                break;
                            case "远光灯关":
                                sReturn = sReturn + bAdd + "<% =Resources.Lan.DistanceLight %><% =Resources.Lan.DoorClose %>";
                                bAdd = ",";
                                break;
                            case "远光灯开":
                                sReturn = sReturn + bAdd + "<% =Resources.Lan.DistanceLight %><% =Resources.Lan.DoorOpen %>";
                                bAdd = ",";
                                break;
                        }
                    });
                }
            }
            catch(e)
            {}
            return sReturn;
         }
        {
            arrHistoryDatagrid.length = 0;
            $('#tableHistory').datagrid('loadData', { total: 0, rows: [] });  
        }
        {
            try
            {
                switch (parseInt(iAngle / 90))
                {
                    case 0:
                        if (parseInt(iAngle % 90) <= 45)
                            if (parseInt(iAngle % 90) == 0)
                                return "<% =Resources.Lan.AngleNorth %>";
                            else
                                return "<% =Resources.Lan.AngleNorthByEast %>" + parseInt(iAngle % 90) + "°";
                        else
                            return "<% =Resources.Lan.AngleEastByNorth %>" + (90 - parseInt(iAngle % 90)) + "°";

                    case 1:
                        if (parseInt(iAngle % 90) <= 45)
                            if (parseInt(iAngle % 90) == 0)
                                return "<% =Resources.Lan.AngleEast %>";
                            else
                                return "<% =Resources.Lan.AngleEastBySouth %>" + parseInt(iAngle % 90) + "°";
                        else
                            return "<% =Resources.Lan.AngleSouthByEast %>" + (90 - parseInt(iAngle % 90)) + "°";


                    case 2:
                        if (parseInt(iAngle % 90) <= 45)
                            if (parseInt(iAngle % 90) == 0)
                                return "<% =Resources.Lan.AngleSouth %>";
                            else
                                return "<% =Resources.Lan.AngleSouthByWest %>" + parseInt(iAngle % 90) + "°";
                        else
                            return "<% =Resources.Lan.AngleWestBySouth %>" + (90 - parseInt(iAngle % 90)) + "°";


                    case 3:
                        if (parseInt(iAngle % 90) <= 45)
                            if (parseInt(iAngle % 90) == 0)
                                return "<% =Resources.Lan.AngleWest %>";
                            else
                                return "<% =Resources.Lan.AngleWestByNorth %>" + parseInt(iAngle % 90) + "°";
                        else
                            return "<% =Resources.Lan.AngleNorthByWest %>" + (90 - parseInt(iAngle % 90)) + "°";

                    default:
                        return "";
                }
            }
            catch (e)
            {
            
            }
        }
    var bLoad = false;
    var map; 
    var infoMouseover = false;
     var iHistoryType = 0;
    var overlayCars = [];//所有的车辆
    var overlayLable = [];//所有的车辆背景
    var infoWindowVeh;
    var carLable=null;
    var iconArray=new Array(8);
    var arrNanJingUnit;
    var bRefreshUnit = false;
    var arrUnitMarkers = new Array();
        bLoad = true;
        map.centerAndZoom(point, 9);                     // 初始化地图,设置中心点坐标和地图级别。
        map.enableScrollWheelZoom();                            //启用滚轮放大缩小
        map.addControl(new BMap.NavigationControl());  //启用导航控件
        map.addControl(new BMap.MapTypeControl({ mapTypes: [BMAP_NORMAL_MAP, BMAP_HYBRID_MAP] }));     //2D图，卫星图
            if(!bRefreshUnit)
            {
                bRefreshUnit = true;
                return;
            }
            if(bShowUnit)
            {
                RefreshUnit();
            }
       });
       
       // 定义一个控件类,即function
	    function ZoomControl(){
	      // 默认停靠位置和偏移量
	      this.defaultAnchor = BMAP_ANCHOR_TOP_LEFT;
	      this.defaultOffset = new BMap.Size(42, 40);
	    }

	    var arrMapUnit = new Array();     	
	    // 通过JavaScript的prototype属性继承于BMap.Control
	    ZoomControl.prototype = new BMap.Control();

	    // 自定义控件必须实现自己的initialize方法,并且将控件的DOM元素返回
	    // 在本方法中创建个div元素作为控件的容器,并将其添加到地图容器中
	    ZoomControl.prototype.initialize = function(map){
	      // 创建一个DOM元素
	      var div = document.createElement("div");
	      var div1 = document.createElement("div");
	      div.appendChild(div1);
	      var div2 = document.createElement("div");
	      div.appendChild(div2);
	      // 添加文字说明
	      var bigImg = document.createElement("img");     //创建一个img元素
          var selectUnit = document.createElement("select"); 
          var selectTract = document.createElement("select"); 
          var selectDetailUnit = document.createElement("select"); 
          var input = document.createElement("input");
          input.setAttribute("type", "button");
          input.setAttribute("value", "选择单位");
          input.onclick=function(e){
            OpenUnitFromThis();          
          };
//          div.appendChild(input);
          selectDetailUnit.style.width = "150" + "px";
//          selectDetailUnit.className  = "easyui-combobox";
	      bigImg.width="100";  //200个像素 不用加px    
          bigImg.src="../Img/company.png";   //给img元素的src属性赋值 
          bigImg.width = "48";
          bigImg.height = "48";
          bigImg.name = "left";
          bigImg.onclick= function(e){
               OpenUnitFromThis(); 
//            if(bigImg.name == "right")
//            {
//                bigImg.src="../EasyUI/themes/icons/left.png";
//                bigImg.name = "left";
//                selectUnit.style.visibility = "visible";
//                div.style.width = 200 + "px";
//                div.style.height = 57 + "px";
//            }
//            else
//            {
//                bigImg.src="../EasyUI/themes/icons/right.png";
//                bigImg.name = "right";
//                selectUnit.style.visibility = "hidden";
//                div.style.width = 60 + "px";
//                div.style.height = 57 + "px";
//            }
          }
          div1.appendChild(bigImg);      //为dom添加子元素im
	      div2.appendChild(document.createTextNode("选择<%=Resources.Lan.Unit %>"));
          
          selectUnit.id = "UnitSelect1";
          selectUnit.options.add(new Option("不限","0")); 
          selectUnit.options.add(new Option("安徽省","340000")); //这个兼容IE与firefox  
          selectUnit.options.add(new Option("鼓楼区","320106")); 
          selectUnit.options.add(new Option("玄武区","320102")); 
          selectUnit.options.add(new Option("白下区","320103")); 
          selectUnit.options.add(new Option("建邺区","320105")); 
          selectUnit.options.add(new Option("江宁区","320115")); 
          selectUnit.options.add(new Option("雨花台区","320114")); 
          selectUnit.options.add(new Option("江苏省","320000")); 
          selectUnit.options.add(new Option("南京市","320100")); 
          selectUnit.options.add(new Option("市辖区","320101")); 
          selectUnit.options.add(new Option("秦淮区","320104")); 
          selectUnit.options.add(new Option("浦口区","320111")); 
          selectUnit.options.add(new Option("栖霞区","320113")); 
          selectUnit.options.add(new Option("下关区","320107")); 
          selectUnit.options.add(new Option("六合区","320116")); 
          selectUnit.options.add(new Option("溧水县","320124")); 
          selectUnit.options.add(new Option("高淳县","320125")); 
          selectUnit.options.add(new Option("浙江省","330000")); 
//          div.appendChild(selectUnit);
          //机械类型          
          selectTract.id = "selectTract1";
          selectTract.options.add(new Option("不限","0")); 
          selectTract.options.add(new Option("轨道交通产业","13")); 
          selectTract.options.add(new Option("新材料","14")); 
          selectTract.options.add(new Option("电力自动化与智能电网","16")); 
          selectTract.options.add(new Option("塑料制品业","03300")); 
          selectTract.options.add(new Option("工程建设计量","4")); 
          selectTract.options.add(new Option("民生计量","1")); 
          selectTract.options.add(new Option("能源计量","2")); 
          selectTract.options.add(new Option("汽车设备计量","5")); 
          selectTract.options.add(new Option("环保计量","6")); 
          selectTract.options.add(new Option("医药计量","7")); 
          selectTract.options.add(new Option("食品安全计量","9")); 
          selectTract.options.add(new Option("石化计量","3")); 
          selectTract.options.add(new Option("其他","8")); 
          selectTract.options.add(new Option("钢铁","10")); 
          selectTract.options.add(new Option("电子信息","11")); 
          selectTract.options.add(new Option("新能源","12")); 
          selectTract.options.add(new Option("通信","15")); 
          selectTract.options.add(new Option("航空航天","17")); 
//          div.appendChild(selectTract);
          //详细单位
          selectDetailUnit.id = "selectDetailUnit1";
          selectDetailUnit.options.add(new Option("不限","0")); 
          var bs = map.getBounds();   //获取可视区域
	      var bssw = bs.getSouthWest();   //可视区域左下角
	      var bsne = bs.getNorthEast();   //可视区域右上角
//	        alert("当前地图可视范围是：" + bssw.lng + "," + bssw.lat + "到" + bsne.lng + "," + bsne.lat);
          arrUnit = arrUnit.sort(function() {Math.random() - 0.5});
          $.each(arrUnit,function(ii,value){
            selectDetailUnit.options.add(new Option(value.CompanyName,(ii + 1))); 
            if(arrMapUnit.length < 50)
            {
                if(value.Lat < bssw.lat || value.Lat > bsne.lat)
                {
                    
                }
                else if(value.Lng < bssw.lng || value.Lng > bsne.lng)
                {
                
                }
                else
                {
                    arrMapUnit.push(value);
                }
            }
            else
            {
                return false;
            }
          });
//          div.appendChild(selectDetailUnit);
          
//          div.appendChild("<select class=\"easyui-combobox\" name=\"state\" style=\"width:200px;\"><option value=\"AL\">Alabama</option></select>");
	      // 设置样式
	      div.style.cursor = "pointer";
//	      div.style.border = "1px solid gray";
	      div.style.backgroundColor = "white";
	      // 绑定事件,点击一次放大两级
//	      div.onclick = function(e){
//		    map.setZoom(map.getZoom() + 2);
//	      }
	      // 添加DOM元素到地图中
	      map.getContainer().appendChild(div);
	      // 将DOM元素返回
	      return div;
	    }
	    // 创建控件
	    var myZoomCtrl = new ZoomControl();
	    // 添加到地图当中
	    map.addControl(myZoomCtrl); 
        if(bShowUnit)
        {
    //            var baiduXY = CheckXYGpsToBaidu(value.Lng, value.Lat);
                var marker = new BMap.Marker(new BMap.Point(value.Lng, value.Lat));//baiduXY[0].lng, baiduXY[0].lat
                var label = new BMap.Label(value.CompanyName,{offset:new BMap.Size(20,-10)});
	            marker.setLabel(label);
                map.addOverlay(marker);
                arrUnitMarkers.push(marker);
            });
    var sUnitFind = "0";
    var rowFind = undefined;
    var bShowUnit = false;
    function SetFind(sRegionTemp, sUnitTemp, rowSelectTemp,bShow)
    {
        bUnitCenter = false;
        sRegionFind = sRegionTemp;
        sUnitFind = sUnitTemp ;
        rowFind = rowSelectTemp;
        bShowUnit = bShow;
        if(bShow)
        {
            RefreshUnit();
        }
        else
        {
            $.each(arrUnitMarkers,function(i,value){
                    map.removeOverlay(value);
                });
        }
    }
    var bUnitCenter  = false;
    function RefreshUnit()
    {
        try
        {
            if(rowFind != undefined)
            {
                $.each(arrUnitMarkers,function(i,value){
                    map.removeOverlay(value);
                });
                arrUnitMarkers.length = 0;
                var marker = new BMap.Marker(new BMap.Point(rowFind.Lng, rowFind.Lat));//baiduXY[0].lng, baiduXY[0].lat
                var label = new BMap.Label(rowFind.CompanyName + "<br />经度：" + rowFind.Lng.toFixed(6) + "，纬度：" + rowFind.Lat.toFixed(6),{offset:new BMap.Size(20,-10)});
	            marker.setLabel(label);
                map.addOverlay(marker);
                if(!bUnitCenter)
                {
                    var point = new BMap.Point(rowFind.Lng, rowFind.Lat);
                    map.centerAndZoom(point, map.getZoom());
                    bUnitCenter = true;
                }
                arrUnitMarkers.push(marker);
                return;
            }            
            if(!bUnitCenter)
            {
                if(sRegionFind != "0" || sUnitFind != "0")
                {
                    if(sRegionFind != "0")
                    {
                        var sRegionName = "";
                        if(sRegionFind == "320106")
                        {
                            map.centerAndZoom("南京 鼓楼区");
                            bUnitCenter = true;
                            return;
                        }
                        else if(sRegionFind == "320102")
                        {
                            map.centerAndZoom("南京 玄武区");
                            bUnitCenter = true;
                            return;
                        }
                        else if(sRegionFind == "320103")
                        {
                            map.centerAndZoom("南京 白下区");
                            bUnitCenter = true;
                            return;
                        }
                        else if(sRegionFind == "320105")
                        {
                            map.centerAndZoom("南京 建邺区");
                            bUnitCenter = true;
                            return;
                        }
                        else if(sRegionFind == "320115")
                        {
                            map.centerAndZoom("南京 江宁区");
                            bUnitCenter = true;
                            return;
                        }
                        else if(sRegionFind == "320114")
                        {
                            map.centerAndZoom("南京 雨花台区");
                            bUnitCenter = true;
                            return;
                        }
                        else if(sRegionFind == "320000")
                        {
                            map.centerAndZoom("江苏省");
                            bUnitCenter = true;
                            return;
                        }
                        else if(sRegionFind == "320100")
                        {
                            map.centerAndZoom("江苏省 南京");
                            bUnitCenter = true;
                            return;
                        }
                        else if(sRegionFind == "320104")
                        {
                            map.centerAndZoom("南京 秦淮区");
                            bUnitCenter = true;
                            return;
                        }
                        else if(sRegionFind == "320111")
                        {
                            map.centerAndZoom("南京 浦口区");
                            bUnitCenter = true;
                            return;
                        }
                        else if(sRegionFind == "320113")
                        {
                            map.centerAndZoom("南京 栖霞区");
                            bUnitCenter = true;
                            return;
                        }
                        else if(sRegionFind == "320107")
                        {
                            map.centerAndZoom("南京 下关区");
                            bUnitCenter = true;
                            return;
                        }
                        else if(sRegionFind == "320116")
                        {
                            map.centerAndZoom("南京 六合区");
                            bUnitCenter = true;
                            return;
                        }
                        else if(sRegionFind == "320124")
                        {
                            map.centerAndZoom("南京 溧水县");
                            bUnitCenter = true;
                            return;
                        }
                        else if(sRegionFind == "320125")
                        {
                            map.centerAndZoom("南京 高淳县");
                            bUnitCenter = true;
                            return;
                        }
                    }
                    var arrSortCenter = arrUnit.sort(function() {return Math.random() > 0.5 ? -1 : 1;});
                    $.each(arrSortCenter,function(ii,value){
                        if(value.RCode == sRegionFind)
                        {
                            if(sUnitFind != "0")
                            {
                                if(value.UCode == sUnitFind)
                                {
                                    var point = new BMap.Point(value.Lng,value.Lat);
                                    map.centerAndZoom(point, map.getZoom());
                                    bUnitCenter = true;
                                    return false;
                                }
                            }
                            else
                            {
                                var point = new BMap.Point(value.Lng,value.Lat);
                                map.centerAndZoom(point, map.getZoom());
                                bUnitCenter = true;
                                return false;
                            }
                        }
                        else if(sRegionFind == "0" && value.UCode == sUnitFind)
                        {
                            var point = new BMap.Point(value.Lng,value.Lat);
                            map.centerAndZoom(point, map.getZoom());
                            bUnitCenter = true;
                            return false;
                        }
                    });
                }
            }
            var bs = map.getBounds();   //获取可视区域
	      var bssw = bs.getSouthWest();   //可视区域左下角
	      var bsne = bs.getNorthEast();   //可视区域右上角
          var arrSort = arrUnit.sort(function() {return Math.random() > 0.5 ? -1 : 1;});
          var arrMapUnit = new Array();
          $.each(arrSort,function(ii,value){
            if(arrMapUnit.length <50)
            {
                if(value.Lat < bssw.lat || value.Lat > bsne.lat)
                {
                    
                }
                else if(value.Lng < bssw.lng || value.Lng > bsne.lng)
                {
                
                }
                else
                {
                    if(sRegionFind != "0")
                    {
                        if(value.RCode == sRegionFind)
                        {
                            if(sUnitFind != "0")
                            {
                                if(value.UCode == sUnitFind)
                                {
                                    arrMapUnit.push(value);
                                }
                            }
                            else
                            {
                                arrMapUnit.push(value);
                            }
                        }
                    }
                    else if(sUnitFind != "0")
                    {
                        if(value.UCode == sUnitFind)
                        {
                            arrMapUnit.push(value);
                        }
                    }
                    else
                    {
                        arrMapUnit.push(value);
                    }
                }
            }
            else
            {
                return false;
            }
          });
          $.each(arrUnitMarkers,function(i,value){
            map.removeOverlay(value);
          });
          arrUnitMarkers.length = 0;
          arrMapUnit = arrMapUnit.sort(function(a,b) {
            if(a.Lat == b.Lat)
            {
                return a.Lng - b.Lng;
            }
            else
            {
                return a.Lat - b.Lat;
            }
          });
          var dLat = 0;
          var dLng = 0;
          var iTop = -10;
            $.each(arrMapUnit,function(i,value){
    //            var baiduXY = CheckXYGpsToBaidu(value.Lng, value.Lat);
                var dDis = GetShortDistance(dLng,dLat,value.Lng,value.Lat);
                if(dDis < 20)
                {
                    iTop = iTop + 20;
                }
                else
                {
                    iTop = -10;
                }
                dLng = value.Lng;
                dLat = value.Lat;
                var marker = new BMap.Marker(new BMap.Point(value.Lng, value.Lat));//baiduXY[0].lng, baiduXY[0].lat
                var label = new BMap.Label(value.CompanyName,{offset:new BMap.Size(20,iTop)});
	            marker.setLabel(label);
                map.addOverlay(marker);
                arrUnitMarkers.push(marker);
            });
        }
        catch(e)
        {}
    }
   function setIconDirect()
   {
      for(var i=0;i<8;i++)
      {
          var ImageUrl = "../Img/Baidu/car"+i+".gif";
          var num=Number(i);
          iconArray[num] = ImageUrl;
      }
   }
            $.each(value,function(j,valuej){
                if(i == 1 && j == 1)
                {
                    var baiduXY = CheckXYGpsToBaidu(valuej.Longitude, valuej.Latitude);
                    var oLon = baiduXY[0].lng;
                    var oLat = baiduXY[0].lat;
                    points.push(new BMap.Point(oLon, oLat));
                }
                else if(i == dataHistory.length - 1 && j == value.length -1)
                {
                    var baiduXY = CheckXYGpsToBaidu(valuej.Longitude, valuej.Latitude);
                    var oLon = baiduXY[0].lng;
                    var oLat = baiduXY[0].lat;
                    points.push(new BMap.Point(oLon, oLat));
                }
                else
                {
                    if(valuej.Velocity > 0 && valuej.Locate == 1)
                    {
                        if(!bDrawLine)
                        {
                            map.centerAndZoom(new BMap.Point(valuej.Longitude, valuej.Latitude),13);
                            bDrawLine = true;
                        }
                        var baiduXY = CheckXYGpsToBaidu(valuej.Longitude, valuej.Latitude);
                        var oLon = baiduXY[0].lng;
                        var oLat = baiduXY[0].lat;
                        points.push(new BMap.Point(oLon, oLat));
                    }
                }
            });
        }); 
        polyLineNowAll = new BMap.Polyline(points, { strokeColor: "#050BFF", strokeWeight: 3, strokeOpacity: 0.5 });
        polyLineNowAll.disableMassClear();
        map.addOverlay(polyLineNowAll); //根据数组中的两点划线
//        arrPolyLine.push(polyLineNow);
            isFrist = true;
            car = null;
        }
      overlayCars.length = 0;
      if(carLable != null || carLable != undefined)
            carLable = null;
        }
    {
        return;
             pointsTrack.push(mapPointNow);
             if(pointsTrack.length > 1)
             {
                var line = new Array();
                line.push(pointsTrack[pointsTrack.length - 2]);
                line.push(mapPointNow);
                polyLineNowTrack = new BMap.Polyline(line, { strokeColor: "#050BFF", strokeWeight: 5, strokeOpacity: 0.5 });
                 map.addOverlay(polyLineNowTrack); //根据数组中的两点划线
                 trackVehLineClear.push(polyLineNowTrack);
             }                  
     }  
                {
                    var i = dataHistory.length - 1;
                    if(dataHistory[i][dataHistory[i].length - 1].Velocity > 0 && dataHistory[i][dataHistory[i].length - 1].Locate == 1)
                    {
                    
                    }
                    else
                    {
                        AddOrMoveObject(sCphTrack,dataHistory[i][dataHistory[i].length - 1].Time,dataHistory[i][dataHistory[i].length - 1].Longitude,dataHistory[i][dataHistory[i].length - 1].Latitude,dataHistory[i][dataHistory[i].length - 1].Velocity,dataHistory[i][dataHistory[i].length - 1].Angle,dataHistory[i][dataHistory[i].length - 1].Component,1,iHistoryType);
                    }
                }
                catch(e)
                {}
            var iTempCount = iCount;
            iCount = iCount + dataHistory[i].length;
            if(iTrackIndex > iCount - 1)
            {
                continue;
            }
            if(iTrackIndex == 0)
            {
                try
                {
                    AddOrMoveObject(sCphTrack,dataHistory[i][0].Time,dataHistory[i][0].Longitude,dataHistory[i][0].Latitude,dataHistory[i][0].Velocity,dataHistory[i][0].Angle,dataHistory[i][0].Component,1,iHistoryType);
               }
               catch(e)
               {}
               iTrackIndex = 1;
               return; 
            }
            while(iTrackIndex - iTempCount < dataHistory[i].length)
            {
                if(dataHistory[i][iTrackIndex - iTempCount].Velocity > 0 && dataHistory[i][iTrackIndex - iTempCount].Locate == 1)
                {
                    try
                    {
                        AddOrMoveObject(sCphTrack,dataHistory[i][iTrackIndex - iTempCount].Time,dataHistory[i][iTrackIndex - iTempCount].Longitude,dataHistory[i][iTrackIndex - iTempCount].Latitude,dataHistory[i][iTrackIndex - iTempCount].Velocity,dataHistory[i][iTrackIndex - iTempCount].Angle,dataHistory[i][iTrackIndex - iTempCount].Component,1,iHistoryType);
                    }
                    catch(e)
                    {
                        
                    }
                    iTrackIndex = iTrackIndex + 1;
                    return;
                }
                iTrackIndex= iTrackIndex + 1;
            };
        }
    function AddOrMoveObject(VehicleNum,GpsTime,Lon,Lat,NowSpeed,Direct,StatusDes,isSetCenter,HistoryType)
    {    
         var infoText = "<div id='infotable' name='infotable' onmouseover='InfoOver(1)' onmouseout='InfoOver(2)'><table style='font:9pt;'>"+
                          "<tr height='10px'><td width='15px'></td><td nowrap></td><td nowrap>" + "</td></tr>"+
                          "<tr><td width='15px'></td><td nowrap align='right'><font color='#244FAF'><% =Resources.Lan.Plate  %>：</font></td><td>"+ VehicleNum + "</td></tr>"+
                          "<tr><td width='15px'></td><td nowrap align='right'><font color='#244FAF'><% =Resources.Lan.DataTime  %>：</font></td><td>"+ GpsTime + "</td></tr>"+
                          "<tr><td width='15px'></td><td nowrap align='right'><font color='#244FAF'><% =Resources.Lan.Speed  %>：</font></td><td>"+ Number(NowSpeed) + "公里/小时</td></tr>"+
                          "<tr><td width='15px'></td><td nowrap align='right'><font color='#244FAF'><% =Resources.Lan.UnitStatus  %>：</font></td><td word-wrap:break-word;>"+ StatusDes + "</td></tr>"+
                          "<tr height='30px'><td width='15px'></td><td nowrap valign='top' align='right'><font color='#244FAF'><% =Resources.Lan.Address  %>：</font></td><td id='tdAdd' valign='top' style='word-wrap:break-word' >"+
                                      "<a onmouseover=\"document['imgDisplayAddr'].imgRolln=document['imgDisplayAddr'].src;document['imgDisplayAddr'].src=document['imgDisplayAddr'].lowsrc;\" onmouseout=\"document['imgDisplayAddr'].src=document['imgDisplayAddr'].imgRolln\" href=\"javascript:void(0)\" onclick='getAdd("+Lon+","+Lat+");' ><img border=\"0\" src=\"../Img/Baidu/showAddr.gif\" id=\"imgDisplayAddr\" name=\"imgDisplayAddr\" dynamicanimation=\"imgDisplayAddr\" lowsrc=\"../Img/Baidu/showAddr2.gif\" alt=\"\"  /></a>"+
                                           
                           "</td></tr>"+
                      "</table></div>"; 
         iHistoryType = HistoryType;
         var iColor = "49152";//lFeatureStopColor;
         var sColor = "000000";
//         if (parseInt(NowSpeed) > 0.1) //
//         {
//             strTemp = "2";
//             iColor = "12582912"; //lFeatureRunColor;
//             sColor = "0000c0";
//         }
//         else
//         {
//             strTemp = "1";
//             iColor = "49152";//lFeatureStopColor;
//             sColor = "000000";
//         }
        var baiduXY = CheckXYGpsToBaidu(Lon, Lat);
        var oLon = baiduXY[0].lng;
        var oLat = baiduXY[0].lat;
         if (isFrist) 
           {
//               if(infoWindowClick!=null && infoWindowClick != undefined && car != null)
//              {
//                car.removeEventListener("mouseover", infoWindowClick);
//              }
                AddObject(VehicleNum,oLon,oLat,NowSpeed,Direct,StatusDes,isSetCenter,infoText,sColor);        
                if(HistoryType != 1)
                {
                    isFrist = false; 
                }
                else
                {
                    isFrist = true;
                }        
           }
         else
          {
                MoveObject(oLon,oLat,VehicleNum,NowSpeed,Direct,StatusDes,isSetCenter,infoText,sColor); 
                if(HistoryType != 1)
                {
                    isFrist = false; 
                }
                else
                {
                    isFrist = true;
                }    
           }              
     }
  function AddObject(VehicleNum,Lon,Lat,NowSpeed,Direct,StatusDes,isSetCenter,info,Color)
  {     
      var  mouseText = '' ;
      var title = '';
      var dituDirect= Direct;
      var point =  new BMap.Point(Lon, Lat);
      if(isSetCenter=='1')
      {
          if(overlayCars.length == 0)
          {
                map.centerAndZoom(point,13);
          }
          else
          {
            var bounds = map.getBounds();
             if( !bounds.containsPoint( point ) )
             {
	            map.centerAndZoom(point,map.getZoom());
            }
          }
      }
      var iSize = 32;
      if(iHistoryType == 1)
      {
        iSize = 16;
      }      
      var myIconCar = new BMap.Icon("../Img/Baidu/baiducar.gif", new BMap.Size(iSize, iSize));
      car = new BMap.Marker(point, { icon: myIconCar });
      car.addEventListener("mouseover", infoWindowClick = function() { infoWindowVehID = VehicleNum; infoWindowVeh = new BMap.InfoWindow(info,{enableMessage:false}); infoWindowVeh.redraw(); infoWindowVeh.disableAutoPan(); this.openInfoWindow(infoWindowVeh); });
      car.setTitle(VehicleNum);    
      var sName = setIconFont(Direct, false);  
      var label = new BMap.Label(sName, { offset: new BMap.Size(0, 0) });
      carLable = new BMap.Label(sName, { position: point, offset: new BMap.Size(-16, -16) }); //VehicleNum            
      if(sName == "I")
      {
          sName = "1";
      }
      if(iHistoryType == 1)
      {
            label.setStyle({
                    color: "#" + Color,
                    borderColor: "transparent",
                    borderWidth: "0px 0px 0px 0px",
                    backgroundColor: "transparent",
                    fontSize: "28px",
                    height: "16px",
                    lineHeight: "16px",
                    width: "16px",
                    fontFamily: "BaiduCar"
                });           
      }
      else
      {
          label.setStyle({
                color: "#" + Color,
                borderColor: "transparent",
                borderWidth: "0px 0px 0px 0px",
                backgroundColor: "transparent",
                fontSize: "57px",
                height: "32px",
                lineHeight: "32px",
                width: "32px",
                fontFamily: "BaiduCar"
            });
            carLable.setStyle({
                color: "#" + Color,
                borderColor: "transparent",
                borderWidth: "0px 0px 0px 0px",
    //            backgroundImage: "url(51ditu/Car1.gif)",
                //backgroundColor: "transparent",
                background:"url(51ditu/CarBack" + sName + ".gif) no-repeat 0 0",
    //            background: "none transparent scroll repeat 0% 0%",
    //            FILTER: "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='51ditu/Car1.gif', sizingMethod='scale')",
                fontSize: "57px",
                height: "32px",
                lineHeight: "32px",
                width: "32px",
                fontFamily: "BaiduCar"
            });
        }
      car.setLabel(label);
      map.addOverlay(car);
      if(iHistoryType == 1)
      {
      
      }
      else
      {
        map.addOverlay(carLable);
//        overlayLable.push(carLable);
      }
      overlayCars.push(car);
      setMapTrack(point);
  }
  
  //车辆移动
    function MoveObject(lon,lat,VehicleNum,NowSpeed,Direct,StatusDes,isSetCenter,info,Color)
    {
         var mouseText ='';
         var title = '';
         var dituDirect= Direct;
         
//         var url = setIcon(dituDirect, true);
         var point = new BMap.Point(lon, lat);
         car.setPosition(point);
         carLable.setPosition(point);
         var sName = setIcon(Direct, false);
         car.getLabel().setContent(sName);
         car.getLabel().setStyle({
             color: "#" + Color,
             borderColor: "transparent",
             borderWidth: "0px 0px 0px 0px",
             backgroundColor: "transparent",
             fontSize: "57px",
             height: "32px",
             lineHeight: "32px",
             width: "32px",
             fontFamily: "BaiduCar"
         });
         carLable.setContent(sName);
         if(sName == "I")
          {
              sName = "1";
          }
            carLable.setStyle({
                color: "#" + Color,
                borderColor: "transparent",
                borderWidth: "0px 0px 0px 0px",
//                backgroundColor: "transparent",
                background:"url(51ditu/CarBack" + sName + ".gif) no-repeat 0 0",
                fontSize: "57px",
                height: "32px",
                lineHeight: "32px",
                width: "32px",
                fontFamily: "BaiduCar"
            });
          if (infoWindowVeh != undefined && infoWindowVeh.isOpen() && !infoMouseover) {// && infoWindowVehID == VehicleNum) {

                document.getElementById("infotable").outerHTML=info;
            }
            
         car.removeEventListener("mouseover", infoWindowClick);
         car.addEventListener("mouseover", infoWindowClick = function() { if(infoWindowVeh == undefined){ infoWindowVehID = VehicleNum; infoWindowVeh = new BMap.InfoWindow(info,{enableMessage:false});} else {infoWindowVeh.setContent(info); infoWindowVeh.redraw(); document.getElementById("infotable").outerHTML=info;}; this.openInfoWindow(infoWindowVeh); });

         
//         if(isTrack=='1')//显示轨迹
//         {
             setMapTrack(point);
//         }
         
         //得到边界，如果超出边界则重新设置
         if(isSetCenter=='1')
         {
            var bounds = map.getBounds();
             if(!bounds.containsPoint( point ) )//iCenter % 3 == 0) // 
             {
	            map.centerAndZoom(point,map.getZoom());
            }
//            iCenter = iCenter + 1;
//            if(iCenter > 12)
//            {
//                iCenter = 1;
//            }
        }  
    } 
        var marker = null;
        var vehCarUrl = setIcon(Direct, 1, false);
        var myIcon = new BMap.Icon(vehCarUrl, new BMap.Size(32, 32));//"../Image/baiducar.gif"
        var marker2 = new BMap.Marker(new BMap.Point(lon, lat), { icon: myIcon });
        return marker2; 
    }
        var iconURl = "../Img/Baidu/car";
        var direct = "1";
        if(bletter)
        {
            direct = "A";
        }
        if ((dituDirect >= 0 && dituDirect <= 22) || (dituDirect >= 338 && dituDirect <= 360)) {
            iconURl = iconURl + "0.gif";
            direct = "1";
            if(bletter)
            {
                direct = "A";
            }
        }
        else if (dituDirect >= 23 && dituDirect <= 67) {
            iconURl = iconURl + "1.gif";
            direct = "2";
            if(bletter)
            {
                direct = "B";
            }
        }
        else if (dituDirect >= 68 && dituDirect <= 112) {
            iconURl = iconURl + "2.gif";
            direct = "3";
            if(bletter)
            {
                direct = "C";
            }
        }
        else if (dituDirect >= 113 && dituDirect <= 157) {
            iconURl = iconURl + "3.gif";
            direct = "4";
            if(bletter)
            {
                direct = "D";
            }
        }
        else if (dituDirect >= 158 && dituDirect <= 202) {
            iconURl = iconURl + "4.gif";
            direct = "5";
            if(bletter)
            {
                direct = "E";
            }
        }
        else if (dituDirect >= 203 && dituDirect <= 247) {
            iconURl = iconURl + "5.gif";
            direct = "6";
            if(bletter)
            {
                direct = "F";
            }
        }
        else if (dituDirect >= 248 && dituDirect <= 292) {
            iconURl = iconURl + "6.gif";
            direct = "7";
            if(bletter)
            {
                direct = "G";
            }

        }
        else if (dituDirect >= 293 && dituDirect <= 337) {
            iconURl = iconURl + "7.gif";
            direct = "8";
            if(bletter)
            {
                direct = "H";
            }
        }
        else {
            iconURl = iconURl + "0.gif";
            direct = "1";
            if(bletter)
            {
                direct = "A";
            }
        }
        return direct;
    }
   {
      var iconURl='';
      var direct = "1";
      if(iLetter == 1)
      {
        direct = "A";
      }
      else if(iLetter == 2)
      {
        return "I";
      }
      if((dituDirect>=0&&dituDirect<=22)||(dituDirect>=338&&dituDirect<=360))
       {
          iconURl = iconArray[0];
          direct = "1";
          if(iLetter == 1)
          {
            direct = "A";
          }
       }
       else if(dituDirect>=23&&dituDirect<=67)
       {
         iconURl = iconArray[1];
          direct = "2";
          if(iLetter == 1)
          {
            direct = "B";
          }
       }
       else if(dituDirect>=68&&dituDirect<=112)
       {
          iconURl = iconArray[2];
          direct = "3";
          if(iLetter == 1)
          {
            direct = "C";
          }
       }
       else if(dituDirect>=113&&dituDirect<=157)
       {
          iconURl = iconArray[3];
          direct = "4";
          if(iLetter == 1)
          {
            direct = "D";
          }
       }
       else if(dituDirect>=158&&dituDirect<=202)
       {
          iconURl = iconArray[4];
          direct = "5";
          if(iLetter == 1)
          {
            direct = "E";
          }
       }
       else if(dituDirect>=203&&dituDirect<=247)
       {
         iconURl = iconArray[5];
          direct = "6";
          if(iLetter == 1)
          {
            direct = "F";
          }
       }
       else if(dituDirect>=248&&dituDirect<=292)
       {
          iconURl = iconArray[6];
          direct = "7";
          if(iLetter == 1)
          {
            direct = "G";
          }
          
       }
       else if(dituDirect>=293&&dituDirect<=337)
       {
          iconURl = iconArray[7];
          direct = "8";
          if(iLetter == 1)
          {
            direct = "H";
          }
       }
       else
       {
          iconURl = iconArray[0];
          direct = "1";
          if(iLetter == 1)
          {
            direct = "A";
          }
       }
//       return iconURl;
        return direct;
   }
   function getAdd(Lon,Lat)
    {
        var XX=0,YY=0;
        XX=parseFloat(Lon);
        YY=parseFloat(Lat);
        GetAddressFromBaidu(XX, YY);
    }
    
   function GetAddressFromBaidu(Lon, Lat) {
        var myHtml = null;
        var st = null;
        //由经纬度得地理位置

        var gc = new BMap.Geocoder();
        var pt = new BMap.Point(Lon, Lat);
        var mOption = {    
            poiRadius : 1000,           //半径为1000米内的POI,默认100米    
            numPois : 10                //列举出50个POI,默认10个
        }
            gc.getLocation(pt, function(rs) {
                    var myHtml = rs.address;
                    var iDistanceMin = 1100;
                    var sExpendAddress = "";
                    if(rs.surroundingPois.length > 0)
			        {
			            for (var i = 0;i<rs.surroundingPois.length;i++)
			            {
			                var iDistance = GetShortDistance(pt.lng,pt.lat,rs.surroundingPois[i].point.lng,rs.surroundingPois[i].point.lat);
//			                ShowInfo(iDistance + " " + rs.surroundingPois.length);
			                if(iDistance < iDistanceMin)
			                {
			                    sExpendAddress = rs.surroundingPois[i].title;
			                    iDistanceMin = iDistance;
			                }
			            }
			            myHtml += " " + sExpendAddress + "<% =Resources.Lan.Nearby %>";
//			            myHtml += "距离" + rs.surroundingPois[0].title + parseInt(sDistance) + "米";
//                        myHtml += " " + rs.surroundingPois[0].title + "附近";
			        }
                    document.getElementById('imgDisplayAddr').style.display = 'none';
                    var divAdd = document.getElementById('tdAdd');
                    divAdd.innerHTML = myHtml;
            },mOption);
    }  
        {
            var  DEF_PI = 3.14159265359; // PI
            var DEF_2PI= 6.28318530712; // 2*PI
            var DEF_PI180= 0.01745329252; // PI/180.0
            var DEF_R =6370693.5; // radius of earth
            var ew1, ns1, ew2, ns2;
            var dx, dy, dew;
            var distance;
            // 角度转换为弧度
            ew1 = lon1 * DEF_PI180;
            ns1 = lat1 * DEF_PI180;
            ew2 = lon2 * DEF_PI180;
            ns2 = lat2 * DEF_PI180;
            // 经度差
            dew = ew1 - ew2;
            // 若跨东经和西经180 度，进行调整
            if (dew > DEF_PI)
            dew = DEF_2PI - dew;
            else if (dew < -DEF_PI)
            dew = DEF_2PI + dew;
            dx = DEF_R * Math.cos(ns1) * dew; // 东西方向长度(在纬度圈上的投影长度)
            dy = DEF_R * (ns1 - ns2); // 南北方向长度(在经度圈上的投影长度)
            // 勾股定理求斜边长
            distance = Math.sqrt(dx * dx + dy * dy);
            return distance;
        }
        {
            if(OpenInfo == 1)
            {
                infoMouseover = true;
            }
            else
            {
                infoMouseover = false;
            }
        }
        {
            window.parent.window.OpenUnit("<% =Resources.Lan.BaiduMap  %><% =Resources.Lan.RightTrackPlayback  %>");
        }
        
        function GetUnit(tabTitle)
        {    
           window.parent.window.SetUnit('选择单位',arrUnit);
        }   
<body >
    <div class="easyui-navpanel" id="divMain" style="-webkit-overflow-scrolling: touch;">
        <div id="DivAutoComplete" class="panel combo-p" style="z-index: 110003; position: absolute; display: none; height: 300px; ">
            <div style="float:right; "><img alt="" title="" src="../EasyUI/themes/icons/cancel.png" onclick="VehClose();" /></div>
            <div style="float:left">
                <table id="tgVeh" class="easyui-treegrid" style=" float:left; height:200px; width:150px;" 
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
		                    <th data-options="field:'name'" formatter="formatVehcheckbox" width="150px"><% =Resources.Lan.TeamOrPlate%></th>
		                    <%--<th data-options="field:'sim'" width="90"><% =Resources.Lan.Sim %></th>
		                    <th data-options="field:'taxino'" width="100"><% =Resources.Lan.TaxiNo %></th>
		                    <th data-options="field:'ipaddress'" width="94"><% =Resources.Lan.IpAddress %></th>--%>
		                </tr>
		            </thead>
	            </table>
	        </div>
        </div>
        
        <div>
	    		   <tr>
	    		        <td width="80" style="text-align:right">
	    		            <% =Resources.Lan.Plate %>：
	    		        </td>
	    		        <td>
	    		            <input id="txtVeh" style="width:120px;" name = "txtVeh" type="text" value="" />
    	    	            <img alt="" title="" src="../EasyUI/themes/icons/search.png" onclick="ShowDivVehTree();" /> 
	    		        </td>
	    		    </tr>
	    		            <% =Resources.Lan.StartTime%>：
	    		        </td>
	    		            <% =Resources.Lan.EndTime %>：
	    		        </td>
		</div>
    </div>
    		
    <%--底部--%>
    <div class="easyui-navpanel" id="divHistory" style="-webkit-overflow-scrolling: touch;">
        <header>
            <div class="m-toolbar">
                <div class="m-left">
                    <a href="#;" onclick="$.mobile.go('#divData');" class="easyui-linkbutton m-back" plain="true" outline="true"><% =Resources.Lan.Back %></a>
                    <a href="#;" id="btnAllPlace" class="easyui-linkbutton" disabled="disabled" data-options="iconCls:'icon-LineRoad1'" onclick="GetAllPlaceInfo();"><% =Resources.Lan.DisplayAllTrackPosition %></a>
                </div>
            </div>
        </header>
        <table id="tableHistory" class="easyui-datagrid" style="height:100%" data-options="idField:'id',singleSelect:true,collapsible:true">
		    <thead>
		        <tr>
		            <th data-options="field:'id',width:50,hidden:true,halign:'center'" >ID</th>
		            <th data-options="field:'name',width:100,align:'left',halign:'center' "><% =Resources.Lan.Plate %></th>
		            <th data-options="field:'Time',width:130,align:'left',halign:'center'"><% =Resources.Lan.DataTime%></th>
		            <th data-options="field:'LocateStr',width:130,align:'left',halign:'center'"><% =Resources.Lan.PositionStatus %></th>
		            <th data-options="field:'Component',formatter: InfoFormater,width:200,align:'left',halign:'center'"><% =Resources.Lan.UnitStatus %></th>
		            <th data-options="field:'speedangle',width:140,align:'left',halign:'center'"><% =Resources.Lan.Speed %></th>
		            <th data-options="field:'address',formatter: PlaceFormaterInfo,width:200,align:'left',halign:'center'"><% =Resources.Lan.Address %></th>
		            <th data-options="field:'Latitude',formatter: LatLngFormater,width:80,align:'left',halign:'center',hidden:true"><% =Resources.Lan.Lat %></th>
		            <th data-options="field:'Longitude',formatter: LatLngFormater,width:80,align:'left',halign:'center',hidden:true"><% =Resources.Lan.Lng %></th>
		         </tr>
		    </thead>
	    </table>
    </div>
    <%--中间--%>
    <div class="easyui-navpanel" id="divData" style="overflow: hidden; -webkit-overflow-scrolling: touch;" >
        <header>
            <div class="m-toolbar">
                <div class="m-left">
                    <a href="#;" onclick="$.mobile.go('#divMain');" class="easyui-linkbutton m-back" plain="true" outline="true"><% =Resources.Lan.Back %></a>
                    <a href="#;" onclick="$.mobile.go('#divHistory');" class="easyui-linkbutton m-back" plain="true" outline="true"><% =Resources.Lan.HistoryData %></a>
                </div>
            </div>
        </header>
        <div style="width:100%;height:100%;">
            <div style="margin-left:35px; margin-top:53px; position: absolute;	vertical-align: middle;top:0;left:0;z-index: 1;">
            <div style="margin-left:100px; margin-top:53px; position: absolute;	vertical-align: middle;top:0;left:0;z-index: 1;">
                <%--<label>播放速度：</label>--%>
			    <input class="easyui-slider" value="90" style="width:120px" data-options="
			    showTip: false,
			    rule: [0,'|',5,'|',10],
			    tipFormatter: function(value){
				    return (value / 10);
			    },
			    onChange: function(value){
			        RunSpeed((value / 10));
			    }">
        </div>
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