<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FormNotInPolygonQuery.aspx.cs" Inherits="Htmls_Reports_FormNotInPolygonQuery" %>

<!DOCTYPE html>
<html>
<head >
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <%--<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />--%>
    <title><% =Resources.Lan.VehFenceScheduleTimeReport %></title>
    <style type="text/css">
        body, html,#map {width: 100%;height: 100%;overflow: hidden;margin:0;}
        
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
    <script type="text/javascript" src="../../EasyUI/jquery.easyui.min.js"></script>     <script type="text/javascript" src="../../Js/JsCookies.js"></script>  
    <script type="text/javascript" src="../../Js/AutoComplete.js"></script> 
    <script language="javascript" type="text/javascript" src="../../Js/Google/GoogleLatLngCorrect.js"></script>
    <script type="text/javascript">
//        dynamicLoading.js("../EasyUI/easyui-lang-zh_CN.js");
        var sLan = "<% =Resources.Lan.Language  %>";
        if(sLan == "zh")
        {
            document.write("<script src='../EasyUI/easyui-lang-zh_CN.js'><\/script>");
        }
        
        $(document).ready(function() { 
            $('#DivAutoComplete').hide();
            var myDate = new Date();
            $('#txtBeginTime').datetimebox('setValue', formatterSearch(myDate,"00:00:01"));
            $('#txtEndTime').datetimebox('setValue', formatterSearch(myDate,"23:59:59"));
            window.parent.window.InitVehAndGroup("<% =Resources.Lan.VehFenceScheduleTimeReport %>");
            var availableTags = [
              "ActionScript",
              "AppleScript",
              "Asp",
              "BASIC",
              "C",
              "C++",
              "Scala",
              "Scheme"
            ];
            var json="["; 
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
//		        window.parent.window.SetTreeVeh("<% =Resources.Lan.VehFenceScheduleTimeReport  %>");
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
                function SetTreeVeh(vehID,cph)        {//            iSearchID = vehID;
//            $('#txtVeh').val(cph);        }        
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
            if(row.id[0] == 'G')
            {
                return row.name;
            }      
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
                if(id.indexOf("check_V")>-1)
                {
                    $('#tgVeh').treegrid('select',id.substring(6));
                    var row = $('#tgVeh').treegrid('getSelected');
                    iSearchID = id.substring(7);
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
        function Query()
        {
            $("#btnAllPlace").linkbutton({disabled:true});
            ClearHistoryTable();
            dataHistory.length = 0;
            var sBegin = $.trim($('#txtBeginTime').datetimebox('getValue'));
            var sEnd = $.trim($('#txtEndTime').datetimebox('getValue'));
            var sVeh = "0";// $.trim($('#txtVeh').val());
            iSearchID = "0";
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
            var sUserName = GetCookie("username");
            var sPwd = GetCookie("pwd");
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
            TotalDay=Math.floor(date3/(24*3600*1000));
            dtTime1 = new Date();
            if(true)
            {            
                var nextData = new Date(dtBegin);
                nextData.setDate(nextData.getDate() + 1);                      var y = nextData.getFullYear();
			    var m = nextData.getMonth()+1;
			    var d = nextData.getDate();                var sTime1 = y + "/" + (m<10?('0'+m):m)+'/'+(d<10?('0'+d):d) + " 00:00:01";                dtTime1 = new Date(sTime1);
            }
            dtTime2 = dtEnd;
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
            if(dtBegin.getFullYear() != dtEnd.getFullYear()) //年不相同
            {
			    var y = dtBegin.getFullYear();
			    var m = dtBegin.getMonth()+1;
			    var d = dtBegin.getDate();
                 var sTimeEnd = y + "-" + (m<10?('0'+m):m)+'-'+(d<10?('0'+d):d) + " 23:59:59";
                 sQueryTime1 = formatter1(dtBegin);
                 sQueryTime2 = sTimeEnd;
                 bQuery = true;
                 OpenLoding(1);
    //              OpenInfo(formatter1(dtBegin) + "    " + sTimeEnd);
    //              GetNextHistory();
    //            var dtQ = dtBegin;
    //            dtQ.setDate(dtQ.getDate()+1);
            }
            else if(dtBegin.getMonth() != dtEnd.getMonth())//月不相同
            {   
                var y = dtBegin.getFullYear();
			    var m = dtBegin.getMonth()+1;
			    var d = dtBegin.getDate();
                var sTimeEnd = y + "-" + (m<10?('0'+m):m)+'-'+(d<10?('0'+d):d) + " 23:59:59";
                 sQueryTime1 = formatter1(dtBegin);
                 sQueryTime2 = sTimeEnd;
                 bQuery = true;
                 OpenLoding(1);
    //            OpenInfo(formatter1(dtBegin) + "    " + sTimeEnd);
    //              GetNextHistory();
            }
            else if(dtBegin.getDate() != dtEnd.getDate())
            {
                var y = dtBegin.getFullYear();
			    var m = dtBegin.getMonth()+1;
			    var d = dtBegin.getDate();
                var sTimeEnd = y + "-" + (m<10?('0'+m):m)+'-'+(d<10?('0'+d):d) + " 23:59:59";
                 sQueryTime1 = formatter1(dtBegin);
                 sQueryTime2 = sTimeEnd;
                 bQuery = true;
                 OpenLoding(1);
    //            OpenInfo(formatter1(dtBegin) + "    " + sTimeEnd); 
    //            GetNextHistory();
            }
            else
            {
                bQuery = false;
                sQueryTime1 = formatter1(dtBegin);
                sQueryTime2 = formatter1(dtEnd);
                 OpenLoding(1);
    //            OpenInfo(formatter1(dtBegin) + "    " + formatter1(dtEnd)); 
                $.ajax({
                    url: "../../Ashx/VehNotInPolygon.ashx",
                    cache:false,
                    type:"get",
                    dataType:'json',
                    data:{username:sUserName,Pwd:sPwd,BeginTime:sQueryTime1,EndTime:sQueryTime2,UseType:sUserType},
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
                            $("#btnAllPlace").linkbutton({disabled:false});
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
                    url: "../../Ashx/VehNotInPolygon.ashx",
                    cache:false,
                    type:"post",
                    dataType:'json',
                    data:{username:sUserName,Pwd:sPwd,BeginTime:sQueryTime1,EndTime:sQueryTime2,UseType:sUserType},
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
        }
        
        function GetNextHistory()
        {
            var sQueryBeginTime = "";
            var sQueryEndTime = "";
            var Request = GetRequest();
            var sUserName = GetCookie("username");
            var sPwd = GetCookie("pwd");
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
            if(dtTime1.getFullYear() != dtTime2.getFullYear()) //年不相同
            {
			    var y = dtTime1.getFullYear();
			    var m = dtTime1.getMonth()+1;
			    var d = dtTime1.getDate();
                 var sTimeEnd = y + "-" + (m<10?('0'+m):m)+'-'+(d<10?('0'+d):d) + " 23:59:59";
                 sQueryBeginTime = formatter1(dtTime1);
                 sQueryEndTime =  sTimeEnd;
                 bQuery = true;
                 OpenLoding(procDay);
    //            var dtQ = dtTime1;
    //            dtQ.setDate(dtQ.getDate()+1);
            }
            else if(dtTime1.getMonth() != dtTime2.getMonth())//月不相同
            {   
                var y = dtTime1.getFullYear();
			    var m = dtTime1.getMonth()+1;
			    var d = dtTime1.getDate();
                var sTimeEnd = y + "-" + (m<10?('0'+m):m)+'-'+(d<10?('0'+d):d) + " 23:59:59";
                 sQueryBeginTime = formatter1(dtTime1);
                 sQueryEndTime =  sTimeEnd;
                 bQuery = true;
                 OpenLoding(procDay);
            }
            else if(dtTime1.getDate() != dtTime2.getDate())
            {
                var y = dtTime1.getFullYear();
			    var m = dtTime1.getMonth()+1;
			    var d = dtTime1.getDate();
                var sTimeEnd = y + "-" + (m<10?('0'+m):m)+'-'+(d<10?('0'+d):d) + " 23:59:59";
                 sQueryBeginTime = formatter1(dtTime1);
                 sQueryEndTime =  sTimeEnd;
                 bQuery = true;
                 OpenLoding(procDay);
            }
            else
            {
                bQuery = false;
                sQueryBeginTime = formatter1(dtTime1);
                sQueryEndTime = formatter1(dtTime2);
    //            OpenInfo(formatter1(dtTime1) + "    " + formatter1(dtTime2));
                $.ajax({
                    url: "../../Ashx/VehNotInPolygon.ashx",
                    cache:false,
                    type:"get",
                    dataType:'json',
                    data:{username:sUserName,Pwd:sPwd,BeginTime:sQueryBeginTime,EndTime:sQueryEndTime,UseType:sUserType},
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
                            $("#btnAllPlace").linkbutton({disabled:false});
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
            dtTime1.setDate(dtTime1.getDate()+1);
    //        OpenInfo(sQueryBeginTime + "    " + sQueryEndTime);
            $.ajax({
                    url: "../../Ashx/VehNotInPolygon.ashx",
                    cache:false,
                    type:"get",
                    dataType:'json',
                    data:{username:sUserName,Pwd:sPwd,BeginTime:sQueryBeginTime,EndTime:sQueryEndTime,UseType:sUserType},
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
        
        //以下是数据表格
        function LatLngFormater(value, row, index) 
        {   
            if(value != undefined)
            {      
                return value.toFixed(5)
             }   
             return value;
         }
         
         function InfoFormater(value, row, index) 
        {   
            var content = '';   
            var abValue = value +'';   
            if(value != undefined)
            {      
                if(value.length>=22) 
                {         
                    abValue = value.substring(0,19) + "...";         
                    content = '<a href="#;"  title="' + value + '" class="easyui-tooltip">' + abValue + '</a>';      
                }
                else
                {         
                    content = '<a href="#;"  title="' + abValue + '" class="easyui-tooltip">' + abValue + '</a>';      
                }   
             }   
             return content;
         }
         
         function PlaceFormaterInfo(value, row, index) 
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
                    if(value.length>=38) 
                    {         
//                        abValue = value.substring(0,35) + "...";         
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
         
         function TypeFormaterInfo(value, row, index)
         {
            if(value == 2)
            {
                return "<% =Resources.Lan.LeaveFenceAreaAlarm %>";
            }
            else if(value == 4)
            {
                return "<% =Resources.Lan.VehicleLeaveFenceScheduleTimeAlarm %>";
            }
            return "<% =Resources.Lan.VehicleLeaveFenceScheduleTimeAlarm %>";
         }
         
         function GetPlaceInfo(vID, iIndex)
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
                            url: "../../Ashx/Place.ashx",
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
                //alert(row);
            }
         }
         
         function GetAllPlaceInfo()
         {
            $.each(arrHistoryDatagrid,function(iIndex,row){
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
                        url: "../../Ashx/Place.ashx",
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
            });
         }
         
         var arrHistoryDatagrid = new Array();
         function AddToHistoryTable()
         {
            try
            {
                arrHistoryDatagrid.length = 0;
                $.each(dataHistory,function(i,value){
                    $.each(value,function(j,valuej){
                        $.each(jsonVehs,function(k,valuek){
                            if(valuek.id == "V" + valuej.id)
                            {
                                valuej["name"] = valuek.name;
                                return false;
                            }
                        });
                        valuej["address"] = "";
                        if(valuej.Acc == 1)
                        {
                            valuej["AccState"] = "<% =Resources.Lan.AccOn %>";
                        }
                        else
                        {
                            valuej["AccState"] = "<% =Resources.Lan.AccOff %>";
                        }
//                        valuej["speedangle"] =  (Array(3).join(0) + valuej.Velocity).slice(-3) + "km/h " + AngleToString(valuej.Angle); 
                        arrHistoryDatagrid.push(valuej);
                    });
                }); 
                $('#tableHistory').datagrid('loadData',arrHistoryDatagrid);
//                $('#tableHistory').datagrid('sort', {
//	                sortName: 'id',
//	                sortOrder: 'ascc'
//                });
            }
            catch(e)
            {}
         }
         
         function ClearHistoryTable()
        {
            arrHistoryDatagrid.length = 0;
            $('#tableHistory').datagrid('loadData', { total: 0, rows: [] });  
        }
        
        function AngleToString(iAngle)
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
        
    </script>
</head><%--oncontextmenu="return false" --%>
<body class="easyui-layout" id="bodyLayout" style="overflow-y: hidden; scroll:"no">
    <div id="DivAutoComplete" class="panel combo-p" style="z-index: 110003; position: absolute; display: none; height: 300px; ">
        <div style="float:right; "><img title="" src="../EasyUI/themes/icons/cancel.png" onclick="VehClose();" /></div>
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
		                <th data-options="field:'sim'" width="90"><% =Resources.Lan.Sim %></th>
		                <th data-options="field:'taxino'" width="100"><% =Resources.Lan.TaxiNo %></th>
		                <th data-options="field:'ipaddress'" width="94"><% =Resources.Lan.IpAddress %></th>
		            </tr>
		        </thead>
	        </table>
	    </div>
    </div>		
    <div region="north" split="true" border="true" style="overflow: hidden; font-family: Verdana, 微软雅黑,黑体; padding:2px; height:40px">
        <div>
				<label style="display:none">&nbsp;&nbsp;&nbsp;&nbsp;<% =Resources.Lan.Plate %>：</label>
				<%--<input id="txtVeh" name = "txtVeh" type="text" value="" class="easyui-textbox" data-options="
				    prompt:'请输入车牌号',
				    icons:[{
				        iconCls:'icon-online',
				        handler: function(e){
					        InitTree();
				        }
			        }]
				"  />--%>
				<input style="display:none" id="txtVeh" name = "txtVeh" type="text" value="" />
				<img style="display:none" title="" src="../../EasyUI/themes/icons/search.png" onclick="ShowDivVehTree();" /> 
				<label><% =Resources.Lan.StartTime %>：</label><input id="txtBeginTime"  editable="false" class="easyui-datetimebox" style="width:150px;" name="txtBeginTime" data-options="formatter:formatter1,parser:parser1,showSeconds:true" value="2016-04-02 00:00:01" />
				<label><% =Resources.Lan.EndTime %>：</label><input id="txtEndTime"  editable="false" class="easyui-datetimebox" style="width:150px;" name="txtEndTime" data-options="formatter:formatter1,parser:parser1,showSeconds:true" value="2016-04-02 23:59:59" />
				<a href="#;" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="Query();"><% =Resources.Lan.Query %></a>
		        <a href="#;" id="btnAllPlace" class="easyui-linkbutton" disabled="disabled" data-options="iconCls:'icon-LineRoad1'" onclick="GetAllPlaceInfo();"><% =Resources.Lan.DisplayAllTrackPosition %></a>               
		</div>
    </div>
    <%--底部--%>
    <div region="center" split="true" title="<% =Resources.Lan.Information %>" id="dataSouth" style="background: #eee; overflow-y:hidden">
        <table id="tableHistory" class="easyui-datagrid" style="height:100%" data-options="idField:'id',singleSelect:true,collapsible:true">
		    <thead>
		        <tr>
		            <th data-options="field:'id',width:50,hidden:true,halign:'center'" >ID</th>
		            <th data-options="field:'name',width:100,align:'left',halign:'center' "><% =Resources.Lan.Plate %></th>
		            <th data-options="field:'Time',width:130,align:'left',halign:'center'"><% =Resources.Lan.DataTime%></th>
		            <th data-options="field:'AccState',width:130,align:'left',halign:'center'"><% =Resources.Lan.UnitStatus %></th>
		            <th data-options="field:'PolygonType',formatter: TypeFormaterInfo,width:130,align:'left',halign:'center'"><% =Resources.Lan.AlarmType %></th>
		            <%--<th data-options="field:'speedangle',width:140,align:'left',halign:'center'"><% =Resources.Lan.Speed %></th>--%>
		            <th data-options="field:'address',formatter: PlaceFormaterInfo,width:400,align:'left',halign:'center'"><% =Resources.Lan.Address %></th>
		            <th data-options="field:'Latitude',formatter: LatLngFormater,width:80,align:'left',halign:'center',hidden:true"><% =Resources.Lan.Lat %></th>
		            <th data-options="field:'Longitude',formatter: LatLngFormater,width:80,align:'left',halign:'center',hidden:true"><% =Resources.Lan.Lng %></th>
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