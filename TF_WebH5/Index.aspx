<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Index.aspx.cs" Inherits="Index" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title><% =Resources.Lan.Title %></title>
    <meta name="renderer" content="webkit" /> 
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="Css/index.css" rel="stylesheet" type="text/css" />
	<link rel="stylesheet" type="text/css" href="EasyUI/themes/default/easyui.css" />
    <link rel="stylesheet" type="text/css" href="EasyUI/themes/color.css" />
    <link rel="stylesheet" type="text/css" href="EasyUI/themes/icon.css" />  
    <script type="text/javascript" src="EasyUI/jquery.min.js"></script>  
    <script type="text/javascript" src="EasyUI/jquery.easyui.min.js"></script> 
    <script type="text/javascript" src="Js/GenerageGuid.js"></script> 
    <script type="text/javascript" src="Js/JsCookies.js"></script>  
    <script type="text/javascript" src="Js/GridTreeMulSelect.js"></script> 
    <script type="text/javascript" src="Js/JCode.js"></script> 
    <script type="text/javascript" src="Js/JsBase64.js"></script> 
    <script language="javascript" type="text/javascript" src="Js/Google/GoogleLatLngCorrect.js"></script>
    <script type="text/javascript" language="javascript">    
        function InitVehAndGroup(tabTitle)
        {
            var sContent = $('#tabs').tabs('getTab',tabTitle).panel('options').content;
	        var iFrame = $(sContent).find("iframe");
	        window.frames[iFrame[0].name].InitVehAndGroup(jsonVehGroup, jsonVehs);
        } 
        
        function InitOil()
        {
            var rows = $("#tgVeh").treegrid('getSelections');
            if(rows == undefined)
            {
                return;
            }
            var sContent = $('#openRoleDiv');
	        var iFrame = $(sContent).find("iframe");
	        $.each(jsonOil,function(i,value){
	            if(value.VehID == rows[0].id)
	            {
	                window.frames[iFrame[0].name].InitOil(value);
	                return false;
	            }
	        });
        }
        
        function UpdateOil(id,sStealOil,sChkPresent,sOil)
        {
            var rows = $("#tgVeh").treegrid('getSelections');
            if(rows == undefined)
            {
                return;
            }
            var bExists = false;
	        $.each(rows,function(k,valuek){
	            $.each(jsonOil,function(i,value){
	                if(value.VehID == valuek.id)
	                {
	                    bExists = true;
	                    value.StealOil = sStealOil;
	                    if(sChkPresent)
	                    {
	                        var arrTemp = sOil.split(',');
	                         value.lstDetail = new Array();
	                        value.lstDetail.push({"Scale":sOil[0],"OilValue":sOil[1]});
	                    }
	                    else
	                    {
	                        var arrAll = sOil.split(';');
	                        value.lstDetail = new Array();
	                        $.each(arrAll,function(j,valuej){
	                            var arrTemp = valuej.split(',');
	                            value.lstDetail.push({"Scale":arrTemp[0],"OilValue":arrTemp[1]});
	                        });
	                    }
	                    return false;
	                }
	            });
	            if(!bExists)
	            {
	                var lstDetail = new Array();
	                if(sChkPresent)
	                {
	                    var arrTemp = sOil.split(',');
	                    lstDetail = new Array();
	                    lstDetail.push({"Scale":sOil[0],"OilValue":sOil[1]});
	                }
	                else
	                {
	                    var arrAll = sOil.split(';');
	                    $.each(arrAll,function(j,valuej){
	                        var arrTemp = valuej.split(',');
	                        lstDetail.push({"Scale":arrTemp[0],"OilValue":arrTemp[1]});
	                    });
	                }
	                var row = {"id":0,"VehID":valuek.VehID,"Cph":valuek.name,"StealOil":sStealOil,"lstDetail":lstDetail};
	                jsonOil.push(row);
	            }
	        });
        }
        
        function FullScreenZoom()
        {
            if(fullscreenEnable())
            {
                exitFullScreen();
                setTimeout("ExpandEast()",1000);
            }
            else
            {
                fullScreen(null);
                setTimeout("CollapseEast()",1000);
            }
        }
        
        function ExpandEast()
        {
            $('#bodyLayout').layout('expand','east');
        }
        
        function CollapseEast()
        {
            $('#bodyLayout').layout('collapse','east');
            $('#CenterLayout').layout('collapse','south');
        }
        
        function fullScreen(element) {
//            var el = document.documentElement,
            var el = element instanceof HTMLElement ? element : document.documentElement,
                rfs = el.requestFullScreen || el.webkitRequestFullScreen || el.mozRequestFullScreen || el.msRequestFullScreen,
                wscript;
         
            if(typeof rfs != "undefined" && rfs) {
                rfs.call(el);
                return;
            }
         
            if(typeof window.ActiveXObject != "undefined") {
                wscript = new ActiveXObject("WScript.Shell");
                if(wscript) {
                    wscript.SendKeys("{F11}");
                }
            }
        }
        
        function fullscreenEnable(){
           return document.fullscreenElement    ||
                   document.msFullscreenElement  ||
                   document.mozFullScreenElement ||
                   document.webkitFullscreenElement || false;
        }
         
        function exitFullScreen() {
            var el = document,
                cfs = el.cancelFullScreen || el.webkitCancelFullScreen || el.mozCancelFullScreen || el.exitFullScreen,
                wscript;
         
            if (typeof cfs != "undefined" && cfs) {
              cfs.call(el);
              return;
            }
         
            if (typeof window.ActiveXObject != "undefined") {
                wscript = new ActiveXObject("WScript.Shell");
                if (wscript != null) {
                    wscript.SendKeys("{F11}");
                }
          }
        }
        
        function SetVehLoginMap()
        {
            var sLoginTypeComplete = GetCookie("logintype");
            if(sLoginTypeComplete == "2" && jsonVehs.length > 0)
            {
                $('#check_'+jsonVehs[0].id)[0].checked = true;
                showVehcheck(jsonVehs[0].id);
                GotoPlace(jsonVehs[0]["lng"],jsonVehs[0]["lat"]);
            }
        }
        
        function SetTreeVeh(tabTitle)
        {
            var rows = $("#tgVeh").treegrid('getSelections');
            if(rows == undefined || rows.length == 0)
            {
                if(jsonVehs != undefined && jsonVehs.length == 1)
                {
                    var sContent = $('#tabs').tabs('getTab',tabTitle).panel('options').content;
	                var iFrame = $(sContent).find("iframe");
	                window.frames[iFrame[0].name].SetTreeVeh(jsonVehs[0].id, jsonVehs[0].name);
                }
                return;
            }
            $.each(rows,function(i,value)
            {
                if(value.id[0] == 'V')
                {
                    var sContent = $('#tabs').tabs('getTab',tabTitle).panel('options').content;
	                var iFrame = $(sContent).find("iframe");
	                window.frames[iFrame[0].name].SetTreeVeh(rows[0].id, rows[0].name);
	                return false;
	            }
            });
        }
        
        var bAutoCollapse = false;
        function CollapseGrid()
        {
            var p = $('#CenterLayout').layout('panel','south')[0].clientWidth;
            if (p > 0)  
            {
                bAutoCollapse = true;
            }
            else  
            {
                
            }
            $('#CenterLayout').layout('collapse','south');
        }
        
        function ExpandGrid()
        {
            $('#CenterLayout').layout('expand','south');
        }
        
        function SetSelectVehToMap(title)
        {
            try
            {
                $('#tgVeh').parent().find("input:checked").each(function(){
                    if(this.id.indexOf("check_V") > -1)
                    {
                        var iVeh = this.id.substring(6);
                        $.each(jsonVehs,function(i,value){
                            if(value.id == iVeh)
                            {
                                AddOrMoveObjectTitle(value,title);
                                return false;
                            }
                        });
                    }
                });
            }
            catch(e)
            {}
        }
        
        function InitVehAndGroupCmd(tabTitle)
        {
            var sContent = $('#openRoleDiv');
	        var iFrame = $(sContent).find("iframe");
	        window.frames[iFrame[0].name].InitVehAndGroup(jsonVehGroup, jsonVehs, PolygonVehs);
        }
    
        var noSupportMessage = "<% =Resources.Lan.BrowserNotSupport %>";
        var ws;
        var arrErr = new Array();
        arrErr.push({ "key": "4001","value":"<% =Resources.Lan.EnterAccountAndPassword %>"});
        arrErr.push({ "key": "4002","value":"<% =Resources.Lan.NotEnterIllegalCharacters %>"});
        arrErr.push({ "key": "4004","value":"<% =Resources.Lan.AccountNotExist %>"});
        arrErr.push({ "key": "4005","value":"<% =Resources.Lan.AccountOverdue %>"});
        arrErr.push({ "key": "4006","value":"<% =Resources.Lan.UnknownError %>"});
        arrErr.push({ "key": "4007","value":"<% =Resources.Lan.PleaseLogin %>"});
        
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
        
        var arrVehDetail =new Array();
        arrVehDetail.push({ "key": "id","value":"ID"});
        arrVehDetail.push({ "key": "Cph","value":"<% =Resources.Lan.Plate %>"});
        arrVehDetail.push({ "key": "ownno","value":"<% =Resources.Lan.IpAddress %>"});
        arrVehDetail.push({ "key": "IpAddress","value":"<% =Resources.Lan.IpTrueAddress %>"});
        arrVehDetail.push({ "key": "Deviceid","value":"<% =Resources.Lan.Sim %>"});
        arrVehDetail.push({ "key": "TaxiNo","value":"<% =Resources.Lan.TaxiNo %>"});
        arrVehDetail.push({ "key": "ProductCode","value":"<% =Resources.Lan.ProductCode %>"});
        arrVehDetail.push({ "key": "Decph","value":"<% =Resources.Lan.Decph %>"});
        arrVehDetail.push({ "key": "OwnerName","value":"<% =Resources.Lan.OwnerName %>"});
        arrVehDetail.push({ "key": "Contact1","value":"<% =Resources.Lan.Contract1 %>"});
        arrVehDetail.push({ "key": "AlarmLinkTel","value":"<% =Resources.Lan.Tel1 %>"});
        arrVehDetail.push({ "key": "Contact2","value":"<% =Resources.Lan.Contact2 %>"});
        arrVehDetail.push({ "key": "LinkTel2","value":"<% =Resources.Lan.Tel2 %>"});
        arrVehDetail.push({ "key": "Contact3","value":"<% =Resources.Lan.Contact3 %>"});
        arrVehDetail.push({ "key": "ContactPhone3","value":"<% =Resources.Lan.Tel3 %>"});
        arrVehDetail.push({ "key": "YyZh","value":"<% =Resources.Lan.YyZh %>"});
        arrVehDetail.push({ "key": "ByZd","value":"<% =Resources.Lan.Sex %>"});
        arrVehDetail.push({ "key": "FrameNo","value":"<% =Resources.Lan.FrameNo %>"});
        arrVehDetail.push({ "key": "EngineNo","value":"<% =Resources.Lan.EngineNo %>"});
        arrVehDetail.push({ "key": "VehicleType","value":"<% =Resources.Lan.VehicleType %>"});
        arrVehDetail.push({ "key": "Color","value":"<% =Resources.Lan.CarColor %>"});
        arrVehDetail.push({ "key": "PurchaseDate","value":"<% =Resources.Lan.PurchaseDate %>"});
        arrVehDetail.push({ "key": "ServerEndTime","value":"<% =Resources.Lan.ServerEndTime %>"});
        arrVehDetail.push({ "key": "EnrolDate","value":"<% =Resources.Lan.EnrolDate %>"});
        arrVehDetail.push({ "key": "ServerMoney","value":"<% =Resources.Lan.ServerMoney %>"});
        arrVehDetail.push({ "key": "Seller","value":"<% =Resources.Lan.Seller %>"});
        arrVehDetail.push({ "key": "LogOutCause","value":"<% =Resources.Lan.LogOutCause %>"});
        arrVehDetail.push({ "key": "InstallPerson","value":"<% =Resources.Lan.InstallPerson %>"});
        arrVehDetail.push({ "key": "InstallAddress","value":"<% =Resources.Lan.InstallAddress %>"});
        arrVehDetail.push({ "key": "RecordPerson","value":"<% =Resources.Lan.RecordPerson %>"});
        arrVehDetail.push({ "key": "BusinessPerson","value":"<% =Resources.Lan.BusinessPerson %>"});
        arrVehDetail.push({ "key": "PowerType","value":"<% =Resources.Lan.PowerType %>"});
        arrVehDetail.push({ "key": "Marks","value":"<% =Resources.Lan.Marks %>"});
        
        function GetArrVehDetail(key)
        {
            for(var i = 0; i < arrVehDetail.length; i++)
            {
                if(arrVehDetail[i].key == key)
                {
                    return arrVehDetail[i].value;
                }
            }
            return key;
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
    //			        width:$('#mainPanle').width()-10,
    //			        height:$('#mainPanle').height()-26
		            });
	            }else{
		            $('#tabs').tabs('select',subtitle);
		            try
		            {
		                SetTreeVeh(subtitle);
		            }
		            catch(e)
		            {}
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

       function ShowInfo(info)
       {
           $.messager.alert('<% =Resources.Lan.Tip %>',info,'info');
       }
        function clockon() {
            var now = new Date();
            var year = now.getFullYear(); //getFullYear getYear
            var month = now.getMonth();
            var date = now.getDate();
            var day = now.getDay();
            var hour = now.getHours();
            var minu = now.getMinutes();
            var sec = now.getSeconds();
            var week;
            month = month + 1;
            if (month < 10) month = "0" + month;
            if (date < 10) date = "0" + date;
            if (hour < 10) hour = "0" + hour;
            if (minu < 10) minu = "0" + minu;
            if (sec < 10) sec = "0" + sec;
            var arr_week = new Array("星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六");
            week = arr_week[day];
            var time = "";
            time = year + "年" + month + "月" + date + "日" + " " + hour + ":" + minu + ":" + sec + " " + week;

            $("#bgclock").html(time);

            var timer = setTimeout("clockon()", 200);
        }
        
        var sMenuFence = new Array("divFence1418");
        var sMenuAll = new Array("5006","1308","1312","1307","1302","1303","1324");
        function DisableMenuBig()
        {
            try
            {
                $('#menu5006').hide();
                for(var i = 0; i < sMenuFence.length; i++)
                {
                    $('#divFence14').menu('disableItem', $('#' + sMenuFence[i]));
                    $('#' + sMenuFence[i]).hide();
                };
                for(var i = 0; i < sMenuAll.length; i++)
                {
                    if(sMenuAll[i] == "5006")
                    {
//                        $('#menu5006').hide();
                    }
                    else
                    {
                        $('#reportAll').menu('disableItem', $('#menu' + sMenuAll[i]));
                        $('#menu' + sMenuAll[i]).hide();
                    }
                };
                var sPermission = '<% =sPermission %>';
                if(sPermission == undefined || sPermission == null)
                {
                    sPermission = "";
                }
                var sUserID = GetCookie("userid");
                if(sUserID == "1")
                {                    
                    $('#divFence14').show();
                    for(var i = 0; i < sMenuFence.length; i++)
                    {
                        $('#divFence14').menu('enableItem', $('#' + sMenuFence[i]));
                        $('#' + sMenuFence[i]).show();
                    }
                    $('#' + sMenuFence[i]).show();
                    $('#menu5006').show();
                    for(var i = 0; i < sMenuAll.length; i++)
                    {
                        if(sMenuAll[i] == "5006")
                        {
                            
                        }
                        else
                        {
                            $('#reportAll').menu('enableItem', $('#menu' + sMenuAll[i]));
                            $('#menu' + sMenuAll[i]).show();
                        }
                    }
                }
                else
                {
                    var arrPermission = sPermission.split(',');
                    var bExistsMenu = false;
                    for(var i = 0; i < sMenuFence.length; i++)
                    {
                        var bExists = false;
                        for(var j = 0; j < arrPermission.length; j++)
                        {
                            var sTemp = "divFence" + arrPermission[j];
                            if(sMenuFence[i] == sTemp)
                            {
                                bExists = true;
                                bExistsMenu = true;
                                break;
                            }
                        }
                        if(bExists)
                        {
                            $('#divFence14').show();
                            $('#divFence14').menu('enableItem', $('#' + sMenuFence[i]));
                            $('#' + sMenuFence[i]).show();
                        }
                    }
                    if(bExistsMenu)
                    {
                        $('#divFence14').show();
                    }
                    else
                    {
                        $('#divFence14').hide();
                    }
                    bExistsMenu = false;
                    for(var i = 0; i < sMenuAll.length; i++)
                    {
                        for(var j = 0; j < arrPermission.length; j++)
                        {
                            var sTemp = arrPermission[j];
                            if(sMenuAll[i] == sTemp)
                            {
                                if(sMenuAll[i] == "5006")
                                {
                                    $('#menu' + sMenuAll[i]).show();
                                    break;
                                }
                                else
                                {
                                    bExistsMenu = true;
                                    $('#reportAll').menu('enableItem', $('#menu' + sMenuAll[i]));
                                    $('#menu' + sMenuAll[i]).show();
                                    break;
                                }
                            }
                        }
                    }
                    if(bExistsMenu)
                    {
                        $('#reportAll').show();
                    }
                    else
                    {
                        $('#reportAll').hide();
                    }
                }
            }
            catch (e)
            {
            
            }
        }
        
        var sGbKey = new Array("G2","G20","G1601","G201","G202","G204","G1602","G5006","G5005","G2002","G2003");  //  
        var sEnterpriceKey = new Array("E2","E4","E5001","E201","E202","E204","E5004","E5006","E5005","E2002","E2003");//"E5002",拍照   
        var sYJKey = new Array("Y20","Y1602","Y53","Y5006","Y65","Y204","Y5006","Y2006");
        var sk1Key = new Array("K2","K201","K5004","K406","K53","K5006");
        function DisableRightKey()
        {
            try
            {
                for(var i = 0; i < sGbKey.length; i++)
                {
                    $('#vehMenuGb').menu('disableItem', $('#' + sGbKey[i]));
                    $('#' + sGbKey[i]).hide();
                }
                for(var i = 0; i < sEnterpriceKey.length; i++)
                {
                    $('#vehMenuEnterprice').menu('disableItem', $('#' + sEnterpriceKey[i]));
                    $('#' + sEnterpriceKey[i]).hide();
                }
                for(var i = 0; i < sk1Key.length; i++)
                {
                    $('#vehMenuK1').menu('disableItem', $('#' + sk1Key[i]));
                    $('#' + sk1Key[i]).hide();
                }
                for(var i = 0; i < sYJKey.length; i++)
                {
                    $('#vehMenuYJ').menu('disableItem', $('#' + sYJKey[i]));
                    $('#' + sYJKey[i]).hide();
                }
                var sPermission = '<% =sPermission %>';
                if(sPermission == undefined || sPermission == null)
                {
                    sPermission = "";
                }
                var sUserID = GetCookie("userid");
                if(sUserID == "1")
                {
                    for(var i = 0; i < sGbKey.length; i++)
                    {
                        $('#vehMenuGb').menu('enableItem', $('#' + sGbKey[i]));
                        $('#' + sGbKey[i]).show();
                    }
                    for(var i = 0; i < sEnterpriceKey.length; i++)
                    {
                        $('#vehMenuEnterprice').menu('enableItem', $('#' + sEnterpriceKey[i]));
                        $('#' + sEnterpriceKey[i]).show();
                    }
                    for(var i = 0; i < sk1Key.length; i++)
                    {
                        $('#vehMenuK1').menu('enableItem', $('#' + sk1Key[i]));
                        $('#' + sk1Key[i]).show();
                    }
                    for(var i = 0; i < sYJKey.length; i++)
                    {
                        $('#vehMenuYJ').menu('enableItem', $('#' + sYJKey[i]));
                        $('#' + sYJKey[i]).show();
                    }
                }
                else
                {
                    var arrPermission = sPermission.split(',');
                    var bAllShow = false;
                    for(var i = 0; i < sGbKey.length; i++)
                    {
                        var bExists = false;
                        for(var j = 0; j < arrPermission.length; j++)
                        {
                            var sTemp = "G" + arrPermission[j];
                            if(sGbKey[i] == sTemp)
                            {
                                bExists = true;
                                break;
                            }
                        }
                        if(bExists)
                        {
                            bAllShow = true;
                            $('#vehMenuGb').menu('enableItem', $('#' + sGbKey[i]));
                            $('#' + sGbKey[i]).show();
                        }
                    }
                    if(!bAllShow)
                    {
                        $('#vehMenuGb').hide();
                    }
                    bAllShow = false;
                    for(var i = 0; i < sYJKey.length; i++)
                    {
                        var bExists = false;
                        for(var j = 0; j < arrPermission.length; j++)
                        {
                            var sTemp = "Y" + arrPermission[j];
                            if(sYJKey[i] == sTemp)
                            {
                                bExists = true;
                                bAllShow = true;
                                break;
                            }
                        }
                        if(bExists)
                        {
                            $('#vehMenuYJ').menu('enableItem', $('#' + sYJKey[i]));
                            $('#' + sYJKey[i]).show();
                        }
                    }                    
                    if(!bAllShow)
                    {
                        $('#vehMenuYJ').hide();
                    }
                    bAllShow = false;
                    for(var i = 0; i < sEnterpriceKey.length; i++)
                    {
                        var bExists = false;
                        for(var j = 0; j < arrPermission.length; j++)
                        {
                            var sTemp = "E" + arrPermission[j];
                            if(sEnterpriceKey[i] == sTemp)
                            {
                                bExists = true;
                                bAllShow = true;
                                break;
                            }
                        }
                        if(bExists)
                        {
                            $('#vehMenuEnterprice').menu('enableItem', $('#' + sEnterpriceKey[i]));
                            $('#' + sEnterpriceKey[i]).show();
                        }                        
                    }                    
                    if(!bAllShow)
                    {
                        $('#vehMenuEnterprice').hide();
                    }
                    bAllShow = false;
                    for(var i = 0; i < sk1Key.length; i++)
                    {
                        var bExists = false;
                        for(var j = 0; j < arrPermission.length; j++)
                        {
                            var sTemp = "K" + arrPermission[j];
                            if(sk1Key[i] == sTemp)
                            {
                                bExists = true;
                                bAllShow = true;
                                break;
                            }
                        }
                        if(bExists)
                        {
                            $('#vehMenuK1').menu('enableItem', $('#' + sk1Key[i]));
                            $('#' + sk1Key[i]).show();
                        }                        
                    }
                    if(!bAllShow)
                    {
                        $('#vehMenuK1').hide();
                    }
                }
            }
            catch(e)
            {

            }
        }
        
        var jsonVehGroup;
        var jsonVehs;
        var jsonOil;
        
        $(document).ready(function() { 
            $('#CenterLayout').layout('collapse','south');
            DisableRightKey();
            DisableMenuBig();
            tabClose();
	        tabCloseEven();
//	        document.addEventListener("fullscreenchange", function(e) {
//              alert(e);
//            });
//            document.addEventListener("mozfullscreenchange", function(e) {
//              alert(e);
//            });
//            document.addEventListener("webkitfullscreenchange", function(e) {
//              alert(e);
//            });
//            document.addEventListener("msfullscreenchange", function(e) {
//              alert(e);
//            });
	        var sLan = "<% =Resources.Lan.Language  %>";
            if(sLan == "zh")
            {
	            addTab('<% =Resources.Lan.BaiduMap  %>','Htmls/FormBaiduMap.aspx');
	        }
	        else
	        {
	            addTab('<% =Resources.Lan.GoogleMap  %>','Htmls/FormGoogleMap.aspx');	            
	        }
	        window.setInterval(ThreadOnline,60000 * 10); //
//	        $("#tableRealTime").treegrid("hideColumn","id");
//	        $("#tableRealTime").treegrid("hideColumn","ipaddress");
	        var sTempVehGroup = '<% =sVehGroup %>';
	        if(sTempVehGroup.length > 0)
	        {
	            jsonVehGroup = $.parseJSON(sTempVehGroup);
	        }
	        var sOil = '<% =sOil %>';
	        if(sOil.length > 0)
	        {
	            jsonOil = $.parseJSON(sOil);
	        }
//            $('#tgVeh').treegrid({
//                onExpand:function(node,param){            
//                    ShowInfo("a");
//                }
//            });
	        //AddVehGroup();
            if(jsonVehGroup == undefined)
            {
                return;
            }
            if(jsonVehGroup.length == 0)
            {
                return;
            }
            var sLoginType = GetCookie("logintype");
            if(sLoginType == "2")
            {
                if(jsonVehGroup.length > 0)
                {
                    jsonVehGroup[0].name = '<% =Resources.Lan.MyCar %>';
                }
                $('#menuVehInfor').hide();
                $('#aback').hide();
            }
            //获取车辆数据
	        $("#divState").text("<% =Resources.Lan.LoadingVehicleData %>");
//	        $('#tgVeh').treegrid('onExpand',treeonBeforeLoad);
	        GetVeh();
        });
        
        function ThreadOnline()
        {
            $.each(jsonVehs,function(i,value)
            {
                var bonline = value["online"];
                if(bonline)
                {
                    var gpsDate = new Date(value.time.replace(/-/g,"/")); 
                    var timeNow =new Date();
                    var date3=timeNow.getTime()-gpsDate.getTime();  //时间差的毫秒数
                    if((date3 / 1000 / 60) < 10)
                    {
                        
                    } 
                    else
                    {
                        bonline = false;
                    }
                    if(!bonline)
                    {
                        SetOnline(value,false);
                        if(value["visibleinreal"])
                        {
                            AddOrMoveObject(value);
                        }
                        if(value["Expend"])
                        {
                            $("#lbState" + value.id).text("(离线)");
                            $("#lbCphState" + value.id).text("离线");
                            value["lbState"] = "(离线)";
                            value["cphstate"] = "离线";
                            $("#check_" + value.id).parent().css("color","black");
                        }
                        value["online"] = false;
                    }
                }
            });
        }
        
        function treeonBeforeLoad(row)
        {
            var IsCheck = $(('#check_'+row.id))[0].checked;
            if($("#tgVeh").treegrid("getChildren",row.id).length == 0)
            {
                    var attchJson = new Array();
                    $.each(jsonVehs,function(i,value){
                        if(value.GID == row.id)
                        {
                            value["visibleinreal"] = IsCheck;
                            var carIcon = "icon-offine";
                            if(value["online"])
                            {
                                carIcon = "icon-online";
                            }
                            value["Expend"] = true;
                            var sState = "离线";
                            if(value["cphstate"] == undefined)
                            {
                            
                            }
                            else
                            {
                                sState = value["cphstate"];
                            }
                            var rowVeh = { id: value.id, team: value.team, online: value.online, name: value.name, sim: value.sim, taxino: value.taxino, ipaddress: value.ipaddress, iconCls: carIcon, cid: value.customid, _parentId: value.GID, cphstate:sState,contact3:value.contact3, ownername:value.ownername, seller:value.seller };
                            attchJson.push(rowVeh);
                        }
                    });
                    if(attchJson.length > 0)
                    {
                        attchJson = attchJson.sort(function(a,b){
                            var iText1 = 1;
                            switch(a.cphstate)
                            {
                                case "行驶":
                                    iText1 = 1;
                                    break;
                                case "停车":
                                    iText1 = 2;
                                    break;
                                case "熄火":
                                    iText1 = 3;
                                    break;
                                case "离线":
                                    iText1 = 4;
                                    break;
                            }
                            var iText2 = 1;
                            switch(b.cphstate)
                            {
                                case "行驶":
                                    iText2 = 1;
                                    break;
                                case "停车":
                                    iText2 = 2;
                                    break;
                                case "熄火":
                                    iText2 = 3;
                                    break;
                                case "离线":
                                    iText2 = 4;
                                    break;
                            }
                            return iText1-iText2;
                        });
                        $('#tgVeh').treegrid('append',{
	                        parent: row.id,  // the node has a 'id' value that defined through 'idField' property
	                        data: attchJson
                        });                        
                        $.each(jsonVehs,function(i,value){
                            if(value.GID == row.id)
                            {
                                value["Expend"] = true;
                                if(value["online"])
                                {
                                    if(value["Acc"] == 1)
                                    {
                                        if(value["velocity"] > 1)
                                        {
                                            $("#lbState" + value.id).text("(行驶)");
                                            $("#lbCphState" + value.id).text("行驶");
                                            value["lbState"] = "(行驶)";
                                            value["cphstate"] = "行驶";
                                            $("#check_" + value.id).parent().css("color","green");
                                        }
                                        else
                                        {
                                             $("#lbState" + value.id).text("(停车)");
                                             $("#lbCphState" + value.id).text("停车");
                                             value["lbState"] = "(停车)";
                                             value["cphstate"] = "停车";
                                             $("#check_" + value.id).parent().css("color","#FD6504");
                                        }
                                    }
                                    else
                                    {
                                        $("#lbState" + value.id).text("(熄火)");
                                        $("#lbCphState" + value.id).text("熄火");
                                        value["lbState"] = "(熄火)";
                                        value["cphstate"] = "熄火";
                                        $("#check_" + value.id).parent().css("color","red");
                                    }
                                }
                                else
                                {
                                     $("#lbState" + value.id).text("(离线)");
                                     $("#lbCphState" + value.id).text("离线");
                                     value["lbState"] = "(离线)";
                                     value["cphstate"] = "离线";
                                     $("#check_" + value.id).parent().css("color","black");
                                }
                            }
                        });
                    }
                    if(IsCheck)
                    {
                        $.each(attchJson,function(i,value)
                        {
                                $(('#check_'+value.id))[0].checked = true;
                                showVehcheck(value.id);
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
                            value["visibleinreal"] = IsCheck;
                            var carIcon = "icon-offine";
                            if(value["online"])
                            {
                                carIcon = "icon-online";
                            }
                            var sState = "离线";
                            if(value["cphstate"] == undefined)
                            {
                            
                            }
                            else
                            {
                                sState = value["cphstate"];
                            }
                            var rowVeh = { id: value.id, name: value.name, online: value.online,team: value.team, sim: value.sim, taxino: value.taxino, ipaddress: value.ipaddress, cid: value.customid,iconCls: carIcon, _parentId: value.GID, cphstate:sState, contact3:value.contact3, ownername:value.ownername, seller:value.seller };
                            attchJson.push(rowVeh);
                        }
                    });
                    if(attchJson.length > 0)
                    {
                        attchJson = attchJson.sort(function(a,b){
                            var iText1 = 1;
                            switch(a.cphstate)
                            {
                                case "行驶":
                                    iText1 = 1;
                                    break;
                                case "停车":
                                    iText1 = 2;
                                    break;
                                case "熄火":
                                    iText1 = 3;
                                    break;
                                case "离线":
                                    iText1 = 4;
                                    break;
                            }
                            var iText2 = 1;
                            switch(b.cphstate)
                            {
                                case "行驶":
                                    iText2 = 1;
                                    break;
                                case "停车":
                                    iText2 = 2;
                                    break;
                                case "熄火":
                                    iText2 = 3;
                                    break;
                                case "离线":
                                    iText2 = 4;
                                    break;
                            }
                            return iText1-iText2;
                        });
                        $('#tgVeh').treegrid('append',{
	                        parent: row.id,  // the node has a 'id' value that defined through 'idField' property
	                        data: attchJson
                        });                        
                        $.each(jsonVehs,function(i,value){
                            if(value.GID == row.id)
                            {
                                value["Expend"] = true;
                                if(value["online"])
                                {
                                    if(value["Acc"] == 1)
                                    {
                                        if(value["velocity"] > 1)
                                        {
                                            $("#lbState" + value.id).text("(行驶)");
                                            $("#lbCphState" + value.id).text("行驶");
                                            value["lbState"] = "(行驶)";
                                            value["cphstate"] = "行驶";
                                            $("#check_" + value.id).parent().css("color","green");
                                        }
                                        else
                                        {
                                             $("#lbState" + value.id).text("(停车)");
                                             $("#lbCphState" + value.id).text("停车");
                                             value["lbState"] = "(停车)";
                                             value["cphstate"] = "停车";
                                             $("#check_" + value.id).parent().css("color","#FD6504");
                                        }
                                    }
                                    else
                                    {
                                        $("#lbState" + value.id).text("(熄火)");
                                        $("#lbCphState" + value.id).text("熄火");
                                        value["lbState"] = "(熄火)";
                                        value["cphstate"] = "熄火";
                                        $("#check_" + value.id).parent().css("color","red");
                                    }
                                }
                                else
                                {
                                     $("#lbState" + value.id).text("(离线)");
                                     $("#lbCphState" + value.id).text("离线");
                                     value["lbState"] = "(离线)";
                                     value["cphstate"] = "离线";
                                     $("#check_" + value.id).parent().css("color","black");
                                }
                            }
                        });
                    }
                    if(IsCheck)
                    {
                        $.each(attchJson,function(i,value)
                        {
                                $(('#check_'+value.id))[0].checked = true;
                                showVehcheck(value.id);
                        });
                    }
                }
            }
//            row.sort="cphstate"; 
        }
        
        function treeonClickRow(index){   
            //-------------for TEST 结合SHIFT,CTRL,ALT键实现单选或多选----------------      
            if(index != selectIndexs.firstSelectRowIndex && !inputFlags.isShiftDown ){    
                selectIndexs.firstSelectRowIndex = index; //ShowInfo('firstSelectRowIndex, sfhit = ' + index);  
            }             
            if(inputFlags.isShiftDown ) {  
//                $('#tgVeh').datagrid('clearSelections');                  
//                selectIndexs.lastSelectRowIndex = index;  
//                var tempIndex = 0;  
//                if(selectIndexs.firstSelectRowIndex > selectIndexs.lastSelectRowIndex ){  
//                    tempIndex = selectIndexs.firstSelectRowIndex;  
//                    selectIndexs.firstSelectRowIndex = selectIndexs.lastSelectRowIndex;  
//                    selectIndexs.lastSelectRowIndex = tempIndex;  
//                }  
//                for(var i = selectIndexs.firstSelectRowIndex ; i <= selectIndexs.lastSelectRowIndex ; i++){  
//                    $('#tgVeh').datagrid('selectRow', i.id);     
//                }     
            }             
            //-------------for TEST 结合SHIFT,CTRL,ALT键实现单选或多选----------------  
        }  
        
        function treeonDblClickRow(row){   
            var vID = row.id;
            if(vID[0] == 'G')
            {
                return;
            }
            $.each(jsonVehs, function(j, value2){
                 if(value2.id == vID)
                 {
                    GotoPlace(value2["lng"],value2["lat"]);
                     return false;//true=continue,false=break
                 }
            });
        }
        
        function onVehMenu(e,row){
			e.preventDefault();
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
            if(row.id[0] == 'G')
            {
                return;
            }
//            这样设置的菜单项虽然显示不可用，但点击后还是会执行事件，需要在事件处理中加入判断：
//            if ( !$('#vehMenuGb').menu("getItem", $('#GbControl')).disabled ) {
//              toBanchRefuse();//执行
//            }
//            $('#vehMenuGb').menu('disableItem', $('#GbCallName'));
//            $('#vehMenuGb').menu("enableItem", $('#GbCallName'));
//            
//			$("#GbControl").attr("disabled", "disabled");
            if(row.taxino.indexOf("GB") > -1)
            {
			    $('#vehMenuGb').menu('show',{
				    left: e.pageX,
				    top: e.pageY
			    });
			}
			else if(row.taxino.indexOf("YJ云镜") > -1)
            {
			    $('#vehMenuYJ').menu('show',{
				    left: e.pageX,
				    top: e.pageY
			    });
			}
			else if(row.taxino.indexOf("DB44") > -1)
            {
			    $('#vehMenuGb').menu('show',{
				    left: e.pageX,
				    top: e.pageY
			    });
			}
			else if(row.taxino.indexOf("GPRS_M6") > -1 || row.taxino.indexOf("GPRS_A6") > -1)
            {
			    $('#vehMenuEnterprice').menu('show',{
				    left: e.pageX,
				    top: e.pageY
			    });
			}
			else if(row.taxino.indexOf("GPRS_K1") > -1)
            {
			    $('#vehMenuK1').menu('show',{
				    left: e.pageX,
				    top: e.pageY
			    });
			}
		}
		
		function UpdateTree(data)
		{
		    if(data == undefined )
		    {
		        return;
		    }
            $.each(data,function(i,value){
                $.each(jsonVehs,function(j,valuej){
                    if(value.name == valuej.name)
                    {
                        value["cphstate"] = valuej["cphstate"];
                        if(value["cphstate"] == undefined)
                        {
                            value["cphstate"] = "离线";
                        }
                        return false;
                    }
                });
                UpdateTree(value.children);
            });
		}
		
		var iSort = -1;
		function CphFormat(a,b)
		{   
		    var queryParams = $('#tgVeh').treegrid('options').queryParams;
            queryParams.sortName = "cphstate";
            if(queryParams.sortOrder == undefined)
            {
                queryParams.sortOrder = "asc";
            }
            if(!bHasSort)
            {
                bHasSort = true;
                var treeData = $('#tgVeh').treegrid('getData');
                UpdateTree(treeData);
            }
            if(a == undefined || b == undefined)
            {
                return iSort;
            }
            var iFindCount = 0;
            $.each(jsonVehs,function(i,value){
                if(value.name == a)
                {
                    iFindCount = iFindCount + 1;
                    a = value["cphstate"];
                    if(a == undefined)
                    {
                        a = "离线";
                    }
                }
                else if(value.name == b)
                {
                    iFindCount = iFindCount + 1;
                    b = value["cphstate"];
                    if(b == undefined)
                    {
                        b = "离线";
                    }
                }
                if(iFindCount == 2)
                {
                    return false;
                }
            });
//            alert("a" + a);
//            alert("b" + b);
//		    var iLeft1 = a.indexOf("(");
//		    var iRight1 = a.indexOf(")");
//		    var iLeft2 = b.indexOf("(");
//		    var iRight2 = b.indexOf(")");
//		    if(iLeft1 == -1 || iLeft2 == -1)
//		    {
//		        return iSort;
//		    }
//		    var sText1 = a.substring(iLeft1,iRight1);
//		    var sText2 = b.substring(iLeft2,iRight2);
            var iText1 = 1;
            switch(a)
            {
                case "行驶":
                    iText1 = 1;
                    break;
                case "停车":
                    iText1 = 2;
                    break;
                case "熄火":
                    iText1 = 3;
                    break;
                case "离线":
                    iText1 = 4;
                    break;
            }
            var iText2 = 1;
            switch(b)
            {
                case "行驶":
                    iText2 = 1;
                    break;
                case "停车":
                    iText2 = 2;
                    break;
                case "熄火":
                    iText2 = 3;
                    break;
                case "离线":
                    iText2 = 4;
                    break;
            }
            if(iText1 < iText2)
            {
                return iSort;
            }
            else if(iText1 == iText2)
            {
                return iSort;
            }
            else
            {
                return 0 - iSort;
            }
		}
		
		var bHasSort = false;
		function CphSortColumn(sort, order)
		{
		    bHasSort = false;
//		    var queryParams = $('#tgVeh').treegrid('options').queryParams;
//            queryParams.sortName = "cphstate";// sort;
////            alert(sort);
//            queryParams.sortOrder = "desc";// order;
            iSort = 0 - iSort;
//            $('#tgVeh').treegrid('reload');
//		    alert(sort);
//		    alert(order);

            $.each(jsonVehs,function(i,value){
                if(value["Expend"])
                {
//                    row["cphstate"] = value["cphstate"];
                    if(value["velocity"] != undefined)
                    {
                        if(value["online"])
                        {
                            if(value["Acc"] == 1)
                            {
                                if(value["velocity"] > 1)
                                {
                                     $("#lbState" + value.id).text("(行驶)");
                                     $("#lbCphState"  + value.id).text("行驶");
                                     $("#check_" + value.id).parent().css("color","green");
                                }
                                else
                                {
                                    if(value["Expend"])
                                    {
                                        $("#lbState" + value.id).text("(停车)");
                                        $("#lbCphState" + value.id).text("停车");
                                        $("#check_" + value.id).parent().css("color","#FD6504");
                                    }
                                }
                            }
                            else
                            {
                                $("#lbStateV" + value.id).text("(熄火)");
                                $("#lbCphStateV" + value.id).text("熄火");
                                $("#check_" + value.id).parent().css("color","red");
                            }
                        }
                        else
                        {
                             $("#lbState" + value.id).text("(离线)");
                             $("#lbCphState" + value.id).text("离线");
                             $("#check_" + value.id).parent().css("color","black");
                        }
                        if(value["online"])
                        {
                            SetOnline(value,true);
                        }
                    }
                }
            });
		}
        
        function onVehGridMenu(e, rowIndex, rowData)
        {
            $('#divVehGrid').menu('show',{
				    left: e.pageX,
				    top: e.pageY
			    });
        }
        
        function onVehDblClickRow(rowIndex, rowData)
        {
            GotoPlace(rowData["lng"] , rowData["lat"]);
        }
        
        function ClearVehGrid()
        {
            $('#tableRealTime').datagrid('loadData', { total: 0, rows: [] });  
        }
        
        function onAlarmGridMenu(e, rowIndex, rowData)
        {
            $('#divAlarmGrid').menu('show',{
				    left: e.pageX,
				    top: e.pageY
			    });
        }
        
        function ClearAlarmGrid()
        {
            $.each(jsonVehs,function(i,value){
                if(value["alarmcount"] == undefined)
                {
                    value["alarmcount"] = 0;
                }
                else
                {
                    value["alarmcount"] = 0;
                }
                value["alarmtype"] = "";
            });
            $('#tableAlarm').datagrid('loadData', { total: 0, rows: [] });  
        }
        
        function onInteractiveGridMenu(e, rowIndex, rowData)
        {
            $('#divInteractiveGrid').menu('show',{
				    left: e.pageX,
				    top: e.pageY
			    });
        }
        
        
        function ClearInteractiveGrid()
        {
            $('#tableInteractive').datagrid('loadData', { total: 0, rows: [] });  
        }
        
        function VehonSelect(title,index)
        {
            if(index == 1)
            {
                var row = $('#tgVeh').datagrid('getSelected');  
                if(row == undefined )
                {
                    $("#tableVehDetail").datagrid('loadData',[{'name':'<% =Resources.Lan.Tip %>','value':'<% =Resources.Lan.NoVeh %>'}]);
//                    $("#tableVehDetail").empty();
                }
                else
                {
                    if(row.id[0] == 'G')
                    {
                        $("#tableVehDetail").datagrid('loadData',[{'name':'<% =Resources.Lan.Tip %>','value':'<% =Resources.Lan.NoVeh %>'}]);
                    }
                    else
                    {
                        var iDoType = 2;
                        var sLoginType = GetCookie("logintype");
                        if(sLoginType == "2")
                        {
                            iDoType = 4;
                        }
                        $("#tableVehDetail").datagrid('loadData',[{}]);
                        var sUserName = GetCookie("username");
                        var sPwd = GetCookie("pwd");
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
                                          $.each(data.data,function(i,value)
                                          {
                                            value.name = GetArrVehDetail(value.name);
                                          });
                                          $("#tableVehDetail").datagrid('loadData',data.data);
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
//                        var arrData = new Array();
//                        var rowTemp = {'name':'1','value':'1'};
//                        arrData.push(rowTemp);
//                        $("#tableVehDetail").datagrid('loadData',arrData);

                    }
                }
            }
        }
        
        function AddOrMoveObject(row)
        {
            var strTemp = "1";
            try
            {
                if(!$('#tabs').tabs('exists','<% =Resources.Lan.BaiduMap %>')){
    		        
	            }else{
    //	         $('#tt').tabs('update', { 
    //            tab: tab, 
    //            options: { 
    //                title: 'New Title'
    //            } 
    //        });
    //window.frames["mainFrame"].testa("a");
                    var iColor = "49152";//lFeatureStopColor;
                    var sColor = "000000";
                    if(row["online"])
                    {
                        if(row["Acc"] == 0)
                        {
                            sColor = "ff0000";//熄火停车
                        }
                        if(row["Acc"] != undefined && row["Acc"] == 1)
                        {
                            if(row["velocity"] != undefined && row["velocity"] > 1)
                            {
                                sColor = "008000";//行驶绿色
                            }
                            else
                            {
                                sColor = "FD6504"; //停车,黄色
                            }
                        }
                        else
                        {
                            sColor = "ff0000";//熄火停车
                        }
                    }
                    else
                    {
                        sColor = "000000";//离线黑色
                    }
//                    if (row["alarmtype"] != null && row["alarmtype"].length > 0)  //报警
//                    {
//                        strTemp = "3";
//                        iColor = "255"; //lFeatureAlarmColor;
//                        sColor = "ff0000";
//                    }
//                    else if (row["online"] != undefined && row["online"])// && parseInt(row["velocity"]) > 0.1) //
//                    {
//                        strTemp = "2";
//                        iColor = "12582912"; //lFeatureRunColor;
//                        sColor = "0000c0";
//                    }
//                    else
//                    {
//                        strTemp = "1";
//                        iColor = "49152";//lFeatureStopColor;
//                        sColor = "000000";
//                    }
	                var sContent = $('#tabs').tabs('getTab',"<% =Resources.Lan.BaiduMap %>").panel('options').content;
	                var iFrame = $(sContent).find("iframe");
	                window.frames[iFrame[0].name].AddOrMoveObject(row.id, row.name, row["lng"], row["lat"], row["lng"], row["lat"], row["velocity"], row["angle"], 12, row["unitstatus"], 0, 22, 1, '0', 1, row["time"], strTemp,sColor,0,'',1);
    //	                                                                                                                                                                                                                                                                          isNeedRevice, Addr, isSetCenter, IsUpdate, sTime, ImgState, ImgState, iColor, iLetter, addressCompany, iShowState) {
    //	            iFrame[0].contentWindow.testa('sssss');
    //	            $('.tabs-inner span').each(function(i,n){
    //			        var t = $(n).text();
    //			        if(t!="<% =Resources.Lan.BaiduMap %>")				        
    //		        var fff = 1;
    //		        });	
    //		        var iiii = 1;
	            }
	        }
	        catch(e)
	        {
	        alert(e.message);
	        }
	        try
            {
                if(!$('#tabs').tabs('exists','<% =Resources.Lan.GoogleMap %>')){
    		        
	            }else{
                    var iColor = "49152";//lFeatureStopColor;
                    var sColor = "000000";
                    if(row["online"])
                    {
                        if(row["Acc"] == 0)
                        {
                            sColor = "ff0000";//熄火停车
                        }
                        if(row["Acc"] != undefined && row["Acc"] == 1)
                        {
                            if(row["velocity"] != undefined && row["velocity"] > 1)
                            {
                                sColor = "008000";//行驶绿色
                            }
                            else
                            {
                                sColor = "FD6504"; //停车,黄色
                            }
                        }
                        else
                        {
                            sColor = "ff0000";//熄火停车
                        }
                    }
                    else
                    {
                        sColor = "000000";//离线黑色
                    }
	                var sContent = $('#tabs').tabs('getTab',"<% =Resources.Lan.GoogleMap %>").panel('options').content;
	                var iFrame = $(sContent).find("iframe");
	                window.frames[iFrame[0].name].AddOrMoveObject(row.id, row.name, row["lng"], row["lat"], row["lng"], row["lat"], row["velocity"], row["angle"], 12, row["unitstatus"], 0, 22, 1, '0', 1, row["time"], strTemp,sColor,0,'',1);
	            }
	        }
	        catch(e)
	        {}
        }
        
        function AddOrMoveObjectTitle(row,title)
        {
            try
            {
                if(!$('#tabs').tabs('exists',title)){
    		        
	            }else{
    //	         $('#tt').tabs('update', { 
    //            tab: tab, 
    //            options: { 
    //                title: 'New Title'
    //            } 
    //        });
    //window.frames["mainFrame"].testa("a");
                    var iColor = "49152";//lFeatureStopColor;
                    var sColor = "000000";
                    if (row["alarmtype"] != null && row["alarmtype"].length > 0)  //报警
                    {
                        strTemp = "3";
                        iColor = "255"; //lFeatureAlarmColor;
                        sColor = "ff0000";
                    }
                    else if (row["online"] != undefined && row["online"])// && parseInt(row["velocity"]) > 0.1) //
                    {
                        strTemp = "2";
                        iColor = "12582912"; //lFeatureRunColor;
                        sColor = "0000c0";
                    }
                    else
                    {
                        strTemp = "1";
                        iColor = "49152";//lFeatureStopColor;
                        sColor = "000000";
                    }
	                var sContent = $('#tabs').tabs('getTab',title).panel('options').content;
	                var iFrame = $(sContent).find("iframe");
	                window.frames[iFrame[0].name].AddOrMoveObject(row.id, row.name, row["lng"], row["lat"], row["lng"], row["lat"], row["velocity"], row["angle"], 12, row["unitstatus"], 0, 22, 1, '0', 1, row["time"], strTemp,sColor,0,'',1);
   
	            }
	        }
	        catch(e)
	        {}
        }
        
        function deleteCar(id)
        {
            if(!$('#tabs').tabs('exists','<% =Resources.Lan.BaiduMap %>')){
		        
	        }else{
	            var sContent = $('#tabs').tabs('getTab',"<% =Resources.Lan.BaiduMap %>").panel('options').content;
	            var iFrame = $(sContent).find("iframe");
	            window.frames[iFrame[0].name].deleteCar(id);
	        }
            if(!$('#tabs').tabs('exists','<% =Resources.Lan.GoogleMap %>')){
		        
	        }else{
	            var sContent = $('#tabs').tabs('getTab',"<% =Resources.Lan.GoogleMap %>").panel('options').content;
	            var iFrame = $(sContent).find("iframe");
	            window.frames[iFrame[0].name].deleteCar(id);
	        }
        }
        
        function JsExit()
        {
            $("#btnClearSessionCS")[0].click();
        }
        //---------------------treegrid
        function AddVehGroup()
        {
            if(jsonVehGroup == undefined)
            {
                return undefined;
            }
            if(jsonVehGroup.length == 0)
            {
                return undefined;
            }
//           var attchJson = {"total":0,"rows":[]};
           var aaJson = new Array();
            for (var i = 0; i < jsonVehGroup.length; i++) {
                if(jsonVehGroup[i].Root == 1)
                {
                    var sState = "";
                    if(jsonVehGroup[i].HasChild == 1)
                    {
                        sState = "closed";
                    }
                    var row = { id: jsonVehGroup[i].id, name: jsonVehGroup[i].name, state: sState, cid: '', iconCls: "icon-team" };
//                    attchJson.rows.push(row);//$.parseJSON(row)
                    aaJson.push(row);
//            ShowInfo(row);
//            ShowInfo(JSON.stringify(row));
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
//                    attchJson.rows.push(row);//$.parseJSON(row)
                }
            }
//            for(var i = 0; i<aaJson.length ; i++)
//            {
//                attchJson.rows.push(aaJson[i]);
//            }
//            ShowInfo(JSON.stringify(attchJson));
//            $('#tgVeh').treegrid('loadData',attchJson);
            return aaJson;
            var dsVehGroup = jsonVehGroup;
            for(var i=0; i<dsVehGroup.length; i++)  
            {
                var node = $("#tgVeh").treegrid("find",dsVehGroup[i].PID);  
                if(node == undefined)
                {
                    AddParrentVehGroup(dsVehGroup,dsVehGroup[i].PID);
                }
                node = $("#tgVeh").treegrid("find",dsVehGroup[i].id);  
                if(node == undefined)
                {
                    $('#tgVeh').treegrid('append',{
	                    parent: dsVehGroup[i].PID,  // the node has a 'id' value that defined through 'idField' property
	                    data: [{
		                    id: dsVehGroup[i].id,
		                    name: dsVehGroup[i].name,
		                    date: '222',
		                    iconCls: 'icon-team'
	                    }]
                    });
                }               
            } 
            $('#tgVeh').treegrid('collapseAll',0);
            
//            $('#tgVeh').treegrid('append',{
//	            parent: "G1794",  // the node has a 'id' value that defined through 'idField' property
//	            data: [{
//		            id: 'G1000',
//		            name: '1794',
//		            date: '222'
//	            }]
//            });
//            $('#tgVeh').treegrid('append',{
//	            parent: 'G1',  // the node has a 'id' value that defined through 'idField' property
//	            data: [{
//		            id: 'G2',
//		            name: 'name73',
//		            date: '222'
//	            }]
//            });
        }
        
        function GetVeh()
        {
            var sUserName = GetCookie("username");
            var sPwd = GetCookie("pwd");
            var sLoginType = GetCookie("logintype");
            var sUserID = GetCookie("userid");
            var iDoType = 1;
            if(sLoginType == "2")
            {
                iDoType = 3;
            }
            $.ajax({
                url: "Ashx/Vehicle.ashx",
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
                                                //return false;//true=continue,false=break
                                            }
                                       });
                                    }
                                    attchJson.rows.push(value);
                               });
//                               $.each(dsVeh, function(i, value){
//                                    var row = { id: value.id, name: value.name, iconCls: "icon-offine", _parentId: value.GID };
//                                    attchJson.rows.push(row);
//                               });
                               $('#tgVeh').treegrid('loadData',attchJson);
                               if(iDoType == 3)
                               {
                                    $('#tgVeh').treegrid('expandAll',0);
                               }
                               else
                               {
                                    $('#tgVeh').treegrid('collapseAll',0);
                               }
                               $("#divState").text("<% =Resources.Lan.LoadVehComplete %>");
                               connectSocketServer();
                               return;
                               for (var i = 0; i < jsonVehGroup.length; i++) {
                                   if(jsonVehGroup[i].Root == 1)
                                   {
                                       var sState = "";
                                       if(jsonVehGroup[i].HasChild == 1)
                                       {
                                           sState = "closed";
                                       }
                                       var row = { id: jsonVehGroup[i].id, name: jsonVehGroup[i].name, state: sState, iconCls: "icon-team", _parentId: jsonVehGroup[i].PID };
                                       attchJson.push(row);
                                   }
                               }
                               $('#tgVeh').treegrid('loadData',attchJson);
                               return;
//                               for (var i = 0; i < 10000; i++) {
//                                    var row = ({ id: 'id' + i, name: '一' });
//                                    obj.rows.push(row);
//                                }
                               $('#tgVeh').treegrid('loadData',jsonVehs);
                               
                               
//                               $('#tgVeh').treegrid('loadData',dsVeh);
                               for(var i=0; i<dsVeh.length; i++)  
                                {
//                                    var node = $("#tgVeh").treegrid("find",dsVeh[i].GID);  
//                                    if(node == undefined)
//                                    {
//                                        continue;
//                                    }
//                                    node = $("#tgVeh").treegrid("find",dsVeh[i].id);  
//                                    if(node == undefined)
//                                    {
//                                        $('#tgVeh').treegrid('append',{
//	                                        parent: dsVeh[i].GID,  // the node has a 'id' value that defined through 'idField' property
//	                                        data: [{
//		                                        id: dsVeh[i].id,
//		                                        name: dsVeh[i].name,
//		                                        date: '222',
//		                                        iconCls: 'icon-offine'
//	                                        }]
//                                        });
//                                    }    
                                }
                                $('#tgVeh').treegrid('collapseAll',0);
	                           $("#divState").text("<% =Resources.Lan.Successful %>");
                        }
                        else
                        {
	                           $("#divState").text(GetErr(data.err));
//                            OpenInfo(GetErr(data.err));
//		                    $(".datagrid-mask").remove();  
//                            $(".datagrid-mask-msg").remove(); 
                        }
                },
                error: function(e) { 
	                 $("#divState").text(e.responseText);
//		            $(".datagrid-mask").remove();  
//                    $(".datagrid-mask-msg").remove(); 
//                    OpenInfo(e.responseText); 
                } 
            })
        }
        
        function AddParrentVehGroup(dsVehGroup,pID)
        {
                for(var i=0; i<dsVehGroup.length; i++) 
                {
                    if(dsVehGroup[i].id == pID)
                    {
                        var node = $("#tgVeh").treegrid("find",dsVehGroup[i].PID);  
                        if(node == undefined)
                        {
                            AddParrentVehGroup(dsVehGroup,dsVehGroup[i].PID);
                        }
                        var node = $("#tgVeh").treegrid("find",dsVehGroup[i].id);  
                        if(node == undefined)
                        {
                            $('#tgVeh').treegrid('append',{
	                            parent: dsVehGroup[i].PID,  // the node has a 'id' value that defined through 'idField' property
	                            data: [{
		                            id: dsVehGroup[i].id,
		                            name: dsVehGroup[i].name,
		                            cid: '',
		                            date: '222',
		                            iconCls: 'icon-team'
	                            }]
                            });
                            return;
                        }       
                    }             
                }
        }
        
        function formatVehcheckbox(val,row){      
            var sAddLabel = "";
            var sState = "离线";
            if(row.id[0] == 'V')
            {
                sState = row["cphstate"];
                if(sState == undefined)
                {
                    sState = "离线";
                }
//                $.each(jsonVehs,function(i,value){
//                    if(value.id == row.id)
//                    {
//                        row["cphstate"] = value["cphstate"];
//                        status = row["cphstate"];
//                        return false;
//                    }
//                });
                sAddLabel = "&nbsp;<label id='lbState" + row.id + "'>(" + sState + ")<label>";
            }
             return "<input type='checkbox' onclick=showVehcheck('"+row.id+"') id='check_"+row.id+"' "+(row.checked?'checked':'')+"/>" + row.name + sAddLabel;
        }
        
        function formatCphState(val,row){
            var sAddLabel = "";
            var sState = "离线";
            if(row["cphstate"] == undefined)
            {
            
            }
            else
            {
                sState = row["cphstate"];
            }
            if(row.id[0] == 'V')
            {
                sAddLabel = "<label id='lbCphState" + row.id + "'>" + sState + "<label>";
            }
             return sAddLabel;
        }
        
        function showVehcheck(checkid){
          var s = '#check_'+checkid;
          //ShowInfo( $(s).attr("id"));
          // ShowInfo($(s)[0].checked);
          /*选子节点*/
           var nodes = $("#tgVeh").treegrid("getChildren",checkid);
           if(checkid[0] == 'V')
           {
                if($(s)[0].checked)
                {
                    var iIndex = $('#tableRealTime').datagrid('getRowIndex',checkid);
                    if(iIndex == -1)
                    {
                            var insertRow = undefined;
                            $.each(jsonVehs,function(j,item)
                            {
                                if(checkid == item.id)
                                {
                                    item["visibleinreal"] = true;
                                    insertRow = item;
                                    return false;
                                }
                            });
//                            ShowInfo(insertRow);
                        $('#tableRealTime').datagrid('insertRow',{
	                                index: 0,	// index start with 0
	                                row: insertRow//$("#tgVeh").treegrid("find",checkid)
                                });
                                
                         AddOrMoveObject(insertRow);
                         try
                        {
                            if(!$('#tabs').tabs('exists','<% =Resources.Lan.BaiduMap %>')){
                		        
	                        }else{
	                            var sContent = $('#tabs').tabs('getTab',"<% =Resources.Lan.BaiduMap %>").panel('options').content;
	                            var iFrame = $(sContent).find("iframe");
//	                            if(insertRow["lng"] != 0 &&  insertRow["lat"] != 0)
//	                            {
//	                                window.frames[iFrame[0].name].setMapCenter( insertRow["lng"], insertRow["lat"], insertRow["lng"], insertRow["lat"], 12);
//                                }
	                        }
	                    }
	                    catch(e)
	                    {}
                     }
                }
                else
                { 
                    $.each(jsonVehs,function(j,item)
                    {
                        if(checkid == item.id)
                        {
                            item["visibleinreal"] = false;
                            return false;
                        }
                    });
                    var iIndex = $('#tableRealTime').datagrid('getRowIndex',checkid);
                    if(iIndex != -1)
                    {
                        $('#tableRealTime').datagrid('deleteRow',iIndex);
                        deleteCar(checkid);
                    }
                }
           }
           else
           {
                try
                {
                    if(!$('#tabs').tabs('exists','<% =Resources.Lan.BaiduMap %>')){
        		        
	                }else{
	                    var sContent = $('#tabs').tabs('getTab',"<% =Resources.Lan.BaiduMap %>").panel('options').content;
	                    var iFrame = $(sContent).find("iframe");
	                    window.frames[iFrame[0].name].SetNanJingZoom();
      
	                }
	            }
	            catch(e)
	            {}
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
                        var iIndex = $('#tableRealTime').datagrid('getRowIndex',nodes[i].id);
                        if(iIndex == -1)
                        {
                            var insertRow = undefined;
                            $.each(jsonVehs,function(j,item)
                            {
                                if(nodes[i].id == item.id)
                                {
                                    item["visibleinreal"] = true;
                                    insertRow = item;
                                }
                            });
                            $('#tableRealTime').datagrid('insertRow',{
	                                    index: 0,	// index start with 0
	                                    row: insertRow//$("#tgVeh").treegrid("find",nodes[i].id)
                                    });
                            AddOrMoveObject(insertRow);
                         }
                     }    
              }
              else
              {
                    $.each(jsonVehs,function(j,item)
                    {
                        if(nodes[i].id == item.id)
                        {
                            item["visibleinreal"] = false;
                            return false;
                        }
                    });
                    var iIndex = $('#tableRealTime').datagrid('getRowIndex',nodes[i].id);
                    if(iIndex != -1)
                    {
                        $('#tableRealTime').datagrid('deleteRow',iIndex);
                        deleteCar(nodes[i].id);
                    }
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
        
        function remarkFormater(value, row, index) 
        {   
            var content = '';   
            var abValue = value +'';   
            if(value != undefined)
            {      
                if(value.length>=22) 
                {         
//                    abValue = value.substring(0,19) + "...";         
                    content = '<a href="#;"  onclick="$.messager.alert(\'<% =Resources.Lan.Tip %>\',\'' + value + '\',\'info\')"  title="' + value + '" class="easyui-tooltip">' + abValue + '</a>';      
                }
                else
                {         
                    content = '<a href="#;" onclick="$.messager.alert(\'<% =Resources.Lan.Tip %>\',\'' + value + '\',\'info\')"  title="' + abValue + '" class="easyui-tooltip">' + abValue + '</a>';      
                }   
             }   
             return content;
         }
         
         function PlaceFormaterAlarm(value, row, index) 
        {   
            var content = '';   
            var abValue = value +'';  
            if(value != undefined)
            {      
                if(value.length == 0) 
                {            
                    content = '<a href="javascript:GetPlaceAlarm(\'V' + row.id + '\',\'' + index + '\');"  title="<% =Resources.Lan.GetLocationInformation %>" ><% =Resources.Lan.GetLocationInformation %></a>';      
                }
                else
                {         
                    if(value.length>=22) 
                    {         
//                        abValue = value.substring(0,19) + "...";         
                        content = '<a href="#;" onclick="$.messager.alert(\'<% =Resources.Lan.Tip %>\',\'' + value + '\',\'info\')" title="' + value + '" class="easyui-tooltip">' + abValue + '</a>';      
                    }
                    else
                    {         
                        content = '<a href="#;" onclick="$.messager.alert(\'<% =Resources.Lan.Tip %>\',\'' + value + '\',\'info\')" title="' + abValue + '" class="easyui-tooltip">' + abValue + '</a>';      
                    }  
                }   
             }   
             return content;
         }
         
         function GetPlaceAlarm(vID, iIndex)
         {
            try
            {
                var row = $('#tableAlarm').datagrid('getSelected');
                if(row == undefined)
                {
                    return;
                }
                iIndex = $('#tableAlarm').datagrid('getRowIndex', row);
                if(iIndex != -1)
                {
                    if("google" == '<% =Resources.Lan.MapType  %>')
                    {
                        var googleXY = CheckXYGpsToGoogle(row["lng"], row["lat"] );
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
                                        $('#tableAlarm').datagrid('updateRow',{
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
                            url: "Ashx/Place.ashx",
                            cache:false,
                            type:"post",
                            dataType:'json',
                            async:false, 
                            data:{type:'<% =Resources.Lan.MapType  %>',Lat:row["lat"],Lng:row["lng"]},
                            success:function(data){
                                    if(data.result == "true")
                                    {  
                                        row["address"] = data.data;
                                        $('#tableAlarm').datagrid('updateRow',{
	                                    index: iIndex,
	                                    row: row});  
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
            catch(e)
            {
                ShowInfo(row);
            }
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
                    if(value.length>=22) 
                    {         
//                        abValue = value.substring(0,19) + "...";         
                        content = '<a href="#;"  onclick="$.messager.alert(\'<% =Resources.Lan.Tip %>\',\'' + value + '\',\'info\')" title="' + value + '" class="easyui-tooltip">' + abValue + '</a>';      
                    }
                    else
                    {         
                        content = '<a href="#;"  onclick="$.messager.alert(\'<% =Resources.Lan.Tip %>\',\'' + value + '\',\'info\')" title="' + abValue + '" class="easyui-tooltip">' + abValue + '</a>';      
                    }  
                }   
             }   
             return content;
         }         
        
         function GotoPlaceFormater(value, row, index) 
        {   
            var content = '';   
            var abValue = value +'';   
            if(value != undefined)
            {      
                content = '<a href="javascript:GotoPlace(' + row["lng"] + ',' + row["lat"] + ');"  title="' + abValue + '" >' + abValue + '</a>';       
             }   
             return content;
         }
         
         function GotoPlace(lng,lat)
         {
            try
            {
                if(lng == undefined)
                {
                    return;
                }
                if(lat == undefined)
                {
                    return;
                }
                if(!$('#tabs').tabs('exists','<% =Resources.Lan.BaiduMap %>')){
    		        
	            }else{
	                var sContent = $('#tabs').tabs('getTab',"<% =Resources.Lan.BaiduMap %>").panel('options').content;
	                var iFrame = $(sContent).find("iframe");
	                window.frames[iFrame[0].name].setMapCenter(lng,lat,lng,lat,15);
	            }
                if(!$('#tabs').tabs('exists','<% =Resources.Lan.GoogleMap %>')){
    		        
	            }else{
	                var sContent = $('#tabs').tabs('getTab',"<% =Resources.Lan.GoogleMap %>").panel('options').content;
	                var iFrame = $(sContent).find("iframe");
	                window.frames[iFrame[0].name].setMapCenter(lng,lat,lng,lat,15);
   
	            }
                if(!$('#tabs').tabs('exists','<% =Resources.Lan.FenceRegionManage %>')){
    		        
	            }else{
	                var sContent = $('#tabs').tabs('getTab',"<% =Resources.Lan.FenceRegionManage %>").panel('options').content;
	                var iFrame = $(sContent).find("iframe");
	                window.frames[iFrame[0].name].setMapCenter(lng,lat,lng,lat,15);
   
	            }
	        }
	        catch(e)
	        {}
         }
         
         function GetPlaceInfo(vID, iIndex)
         {
            try
            {
                var row = $('#tableRealTime').datagrid('getSelected');
                if(row == undefined)
                {
                    return;
                }
                iIndex = $('#tableRealTime').datagrid('getRowIndex', row);
                if(iIndex != -1)
                {
                    if("google" == '<% =Resources.Lan.MapType  %>')
                    {
                        var googleXY = CheckXYGpsToGoogle(row["lng"], row["lat"] );
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
                                        $('#tableRealTime').datagrid('updateRow',{
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
                            url: "Ashx/Place.ashx",
                            cache:false,
                            type:"post",
                            dataType:'json',
                            async:false, 
                            data:{type:'<% =Resources.Lan.MapType  %>',Lat:row["lat"],Lng:row["lng"]},
                            success:function(data){
                                    if(data.result == "true")
                                    {  
                                        row["address"] = data.data;
                                        $('#tableRealTime').datagrid('updateRow',{
	                                    index: iIndex,
	                                    row: row});  
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
            catch(e)
            {
                //ShowInfo(row);
            }
         }
         
         function ttt(ee)
         {
//            ShowInfo(ee);
         }
         
         function LatLngFormater(value, row, index) 
        {   
            if(value != undefined)
            {      
                return value.toFixed(5);
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
//                    abValue = value.substring(0,19) + "...";         
                    content = '<a href="#;"  onclick="$.messager.alert(\'<% =Resources.Lan.Tip %>\',\'' + value + '\',\'info\')" title="' + value + '" class="easyui-tooltip">' + abValue + '</a>';      
                }
                else
                {         
                    content = '<a href="#;"  onclick="$.messager.alert(\'<% =Resources.Lan.Tip %>\',\'' + value + '\',\'info\')" title="' + abValue + '" class="easyui-tooltip">' + abValue + '</a>';      
                }   
             }   
             return content;
         }
        
        //socket------------------------------
        //交互
        function VisibleInReal(vID,value) //实时监控
        {
            try
            {
                var iIndex = $('#tableRealTime').datagrid('getRowIndex',vID);
                if(iIndex != -1)
                {
                    $('#tableRealTime').datagrid('updateRow',{
	                    index: iIndex,
	                    row: value});
	                AddOrMoveObject(value);
    //                $('#tableRealTime').datagrid('deleteRow',iIndex);
                }
                else
                {
                    $('#tableRealTime').datagrid('insertRow',{
	                    index: 0,	// index start with 0
	                    row: value//$("#tgVeh").treegrid("find",checkid)
                    });
                    AddOrMoveObject(value);
                }
            }
            catch(e)
            {}
        }
        
        function VisibleInAlarm(vID, value, sAlarm) //报警数据
        {
            try
            {
                var iIndex = $('#tableAlarm').datagrid('getRowIndex',vID);
                if(iIndex != -1)
                {
                    var arrAlarm = value.alarmtype.split(' ');
                    var arrNewAlarm = sAlarm.split(' ');
                    var bExits = false;
                    $.each(arrNewAlarm,function(i,value2){
                        if($.trim(value2) == "")
                        {
                            
                        }                        
                        else 
                        {
                            $.each(arrAlarm,function(j,value3){
                                if(value2 == $.trim(value3))
                                {
                                    bExits = true;
                                    return false;
                                }
                            });
                            if(!bExits)
                            {
                                value.alarmtype = value.alarmtype + value2 + " ";
                            }
                            bExits = false;
                        }
                    });
                    $('#tableAlarm').datagrid('updateRow',{
	                    index: iIndex,
	                    row: value});
                }
                else
                {
                    $('#tableAlarm').datagrid('insertRow',{
	                    index: 0,	
	                    row: value
                    });
                }
            }
            catch(e)
            {}
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
        
        function SetOnline(value,online)
        {
            try
            {
                var checkBox = $('#check_'+value.id);
                if(checkBox == undefined || checkBox.length == 0)
                {
                    return;
                }
                if(online)
                {
                     var thisClass = $(checkBox[0].parentNode.parentNode).find("span.icon-offine");
                     if(thisClass != undefined)
                     {
                         thisClass.removeClass("icon-offine").addClass("icon-online");
                     }; 
                }
                else
                {
                    var thisClass = $(checkBox[0].parentNode.parentNode).find("span.icon-online");
                     if(thisClass != undefined)
                     {
                         thisClass.removeClass("icon-online").addClass("icon-offine");
                     }; 
                }
            }
            catch(e)
            {}
        }
        //------------------
        function Analize(sReturn)
        {
            try
            {
                if(sReturn == undefined || sReturn.length == 0)
                {
                    return;
                } 
                var data = eval(sReturn)[0];
                switch(data.key)
                {
                    case "2_1":
                        if(data.data[0].result)
                        {
                            $("#divState").text("<% =Resources.Lan.SuccessfulLoginCenter %>");
                            if(!bGetLastposition)
                            {
                                var sGetLocation = "[{'key':'1_2','ver':1,'rows':0,'cols':0,data:[{}]}]";
                                ws.send(sGetLocation);
                                $("#divState").text("<% =Resources.Lan.LodingLastpostion %>");
                            }
                        }
                        else
                        {
                            $("#divState").text("<% =Resources.Lan.PleaseLogin %>");
                        }
                        break;
                    case "2_2"://位置数据
                    case "2_4"://点名返回
                        $.each(data.data,function(k,item)
                        {
                            var dataDetail = item;// data.data[0];
                            var vID = "V" + dataDetail.id;
                            if(dataDetail.id == -1)
                            {
                                bGetLastposition = true;
                                $("#divState").text("<% =Resources.Lan.LodingLastpostionComplete %>");
                                var sLoginTypeComplete = GetCookie("logintype");
                                if(sLoginTypeComplete == "2" && jsonVehs.length > 0)
                                {
                                    $('#check_'+jsonVehs[0].id)[0].checked = true;
                                    showVehcheck(jsonVehs[0].id);
                                    GotoPlace(jsonVehs[0]["lng"],jsonVehs[0]["lat"]);
                                }
                                return false;
                            }
                            $.each(jsonVehs,function(i,value)
                            {
                                if(value.id == vID)
                                {
                                    if(data.key == "2_4")
                                    {
                                        var arrInteractive = new Array();
                                        var sGuid =  Guid.NewGuid();
                                        var dateReceive = new Date(); 
                                        var sReceiveTime = formatDate(dateReceive);
                                        var arrInteractive = { id: sGuid.ToString("N"),name:value.name,time:sReceiveTime, interactive:"<% =Resources.Lan.RightCallName %>",content: "<% =Resources.Lan.Return %>"};
                                        $('#tableInteractive').datagrid('insertRow',{
	                                        index: 0,	
	                                        row: arrInteractive
                                        });
                                    }
                                    value["time"] = dataDetail.time;
                                    var gpsDate = new Date(dataDetail.time.replace(/-/g,"/")); 
                                    var timeNow =new Date();
                                    var date3=timeNow.getTime()-gpsDate.getTime();  //时间差的毫秒数
                                    var bonline = value["online"];
                                    if(bGetLastposition || (date3 / 1000 / 60) < 10)
                                    {
                                        value["online"] = true;
                                    } 
                                    else
                                    {
                                        value["online"] = false;
                                    }
                                    value["Veh"] = dataDetail.iVeh;
                                    value["Angle"] = dataDetail.iAngle;
                                    value["lat"] = dataDetail.lat;
                                    value["lng"] = dataDetail.lng;
                                    value["address"] = "";
                                    value["velocity"] = dataDetail.iVel;
                                    value["angle"] = dataDetail.iAngle;
                                    if(value["mileage"] == 4294967294)
                                    {
                                        value["mileage"] = "异常";
                                    }
                                    else if(value["mileage"] == 4294967295)
                                    {
                                        value["mileage"] = "无效";
                                    }
                                    value["speedangle"] =  (Array(3).join(0) + dataDetail.iVel).slice(-3) + "km/h " + AngleToString(dataDetail.iAngle); 
                                    if(value.Velocity ==  65534)
                                    {
                                        value["speedangle"] = "异常";
                                    }
                                    else if(value.Velocity ==  65535)
                                    {
                                        value["speedangle"] = "无效";
                                    }                                    
                                    if(dataDetail.location == 1)
                                    {
                                        if(dataDetail.Unit[0] == "1")
                                        {
                                            value["positionstatus"] = "<% =Resources.Lan.Location %> " + GetEnterpriseLocationInfo(dataDetail.Unit);
                                        }
                                        else
                                        {
                                            value["positionstatus"] = "<% =Resources.Lan.Location %> ";
                                        }
                                    }
                                    else if(dataDetail.location == 2)
                                    {
                                        if(dataDetail.Unit[0] == "1")
                                        {
                                            value["positionstatus"] = "<% =Resources.Lan.BasestationLocation %> " + GetEnterpriseLocationInfo(dataDetail.Unit);
                                        }
                                        else
                                        {
                                            value["positionstatus"] = "<% =Resources.Lan.BasestationLocation %> ";
                                        }
                                    }
                                    else
                                    {
                                        if(dataDetail.Unit[0] == "1")
                                        {
                                            value["positionstatus"] = "<% =Resources.Lan.NotLocating %> " + GetEnterpriseLocationInfo(dataDetail.Unit); 
                                        }
                                        else
                                        {
                                            value["positionstatus"] = "<% =Resources.Lan.NotLocating %> ";
                                        }
                                    }
                                    var sExAlarm = "";
                                    var objAcc = { Acc: 0 };
                                    if(dataDetail.Unit[0] == "1")
                                    {
                                        value["unitstatus"] = GetEnterprisePositionStatus(dataDetail.Unit,objAcc);
                                    }
                                    else if(dataDetail.Unit[0] == "5")
                                    {
                                        var rowUnit = GetK1Ex(dataDetail.Ex,objAcc);
                                        value["unitstatus"] = rowUnit.status;
                                        sExAlarm = rowUnit.alarm;
                                    }
                                    else if(dataDetail.Unit[0] == "2")
                                    {
                                        value["unitstatus"] = GetGbBDPositionStatus(dataDetail.Unit,objAcc);
                                    }
                                    else if(dataDetail.Unit[0] == "3")
                                    {
                                        value["unitstatus"] = GetGbPositionStatus(dataDetail.Unit,objAcc);
                                    }
                                    else
                                    {
                                        value["unitstatus"] = dataDetail.Unit; 
                                    }
                                    value["mileage"] = dataDetail.mile; 
                                    value["fuelscale"] = dataDetail.oilScale; 
                                    value["fuel"] = GetOil(vID,dataDetail.oilScale);
                                    if(value["Acc"] != objAcc.Acc)
                                    {
                                        value["Acc"] = objAcc.Acc;
                                        if(objAcc.Acc == 0)
                                        {
                                            value["cphstate"] = "熄火";
                                            if(value["Expend"])
                                            {
                                                $("#lbStateV" + dataDetail.id).text("(熄火)");
                                                $("#lbCphStateV" + dataDetail.id).text("熄火");
                                                $("#check_" + vID).parent().css("color","red");
                                            }
                                        }
                                    }
                                    if(value["online"])
                                    {
                                        if(objAcc.Acc == 1)
                                        {
                                            if(dataDetail.iVel > 1)
                                            {
                                                value["cphstate"] = "行驶";
                                                if(value["lbState"] != "(行驶)")
                                                {
                                                    if(value["Expend"])
                                                    {
                                                        $("#lbStateV" + dataDetail.id).text("(行驶)");
                                                        $("#lbCphStateV"  + dataDetail.id).text("行驶");
                                                        value["lbState"] = "(行驶)";
                                                        value["cphstate"] = "行驶";
                                                        $("#check_" + vID).parent().css("color","green");
                                                    }
                                                }
                                            }
                                            else
                                            {
                                                value["cphstate"] = "停车";
                                                if(value["lbState"] != "(停车)")
                                                {
                                                    if(value["Expend"])
                                                    {
                                                        $("#lbStateV" + dataDetail.id).text("(停车)");
                                                        $("#lbCphStateV" + dataDetail.id).text("停车");
                                                        value["lbState"] = "(停车)";
                                                        value["cphstate"] = "停车";
                                                        $("#check_" + vID).parent().css("color","#FD6504");
                                                    }
                                                }
                                            }
                                        }
                                        else
                                        {
                                            value["lbState"] = "(熄火)";
                                            value["cphstate"] = "熄火";
                                            value["cphstate"] = "熄火";
                                            $("#check_" + vID).parent().css("color","red");
                                        }
                                    }
                                    else
                                    {
                                        value["cphstate"] = "离线";
                                        if(value["Expend"])
                                        {
                                            if(value["lbState"] != "(离线)")
                                            {
                                                $("#lbStateV" + dataDetail.id).text("(离线)");
                                                $("#lbCphStateV" + dataDetail.id).text("离线");
                                                value["lbState"] = "(离线)";
                                                value["cphstate"] = "离线";
                                                $("#check_" + vID).parent().css("color","black");
                                            }
                                        }
                                    }
                                    if(!bonline && value["online"])
                                    {
                                        SetOnline(value,true);
                                    }
                                    if(value["visibleinreal"]) //如果定位了
                                    {
                                        VisibleInReal(vID,value);
                                        AddOrMoveObject(value);
                                    }
                                    var sAlarm = "";
                                    if(dataDetail.Unit[0] == "1") //企标
                                    {
                                        sAlarm = GetEnterprisePositionAlarm(dataDetail.Unit);
                                    }
                                    else if(dataDetail.Unit[0] == "2") //部标北斗
                                    {
                                        sAlarm = GetGbBDPositionAlarm(dataDetail.Unit);
                                    }    
                                    else if(dataDetail.Unit[0] == "3")// 旧部标
                                    {
                                        sAlarm = GetGbPositionAlarm(dataDetail.Unit);
                                    }  
                                    else if(dataDetail.Unit[0] == "5") //K1低功耗
                                    {
                                        sAlarm = GetK1PositionAlarm(dataDetail.Unit);
                                    }                                  
                                    var arrExAlarm = sExAlarm.split(' ');
                                    $.each(arrExAlarm,function(iEx,valueEx)
                                    {
                                        if(valueEx != "")
                                        {
                                            if(sAlarm.indexOf(valueEx) == -1)
                                            {
                                                sAlarm = sAlarm + valueEx + " ";
                                            }
                                        }
                                    });
                                    if(sAlarm.length > 0)
                                    {
                                        if(value["alarmcount"] == undefined)
                                        {
                                            value["alarmcount"] = 1;
                                        }
                                        else
                                        {
                                            value["alarmcount"] = parseInt(value["alarmcount"]) + 1;
                                        }
                                        if(value["alarmtype"] == undefined)
                                        {
                                            value["alarmtype"] = sAlarm;
                                        }
                                        else
                                        {
//                                            value["alarmtype"] = sAlarm;
                                        }
                                        VisibleInAlarm(vID,value, sAlarm);
                                    }
                                    return false;
                                }
                            });
                        });
                        break;
                    case "2_5":
                    case "2_6":
                        var bExist25=false;
                        $.each(jsonVehs,function(i,value)
                        {
                            if(value.id == "V" + data.data[0].id)
                            {
                                bExist25 = true;
                                var sAlarmType = "<% =Resources.Lan.EnterFenceAreaAlarm %> ";
                                if(data.data[0].type == 2)
                                {
                                    sAlarmType = "<% =Resources.Lan.LeaveFenceAreaAlarm %> ";
                                }
                                if(data.key == "2_5")
                                {
                                    sAlarmType = "(<% =Resources.Lan.FencePolygon %>)" + sAlarmType;
                                }
                                else if(data.key == "2_6")
                                {
                                    sAlarmType = "(<% =Resources.Lan.AdministrativeAreasFence %>)" + sAlarmType;
                                }
                                if(value["alarmcount"] == undefined || value["alarmcount"] == "")
                                {
                                    value["alarmcount"] = 1;
                                }
                                else
                                {
                                    value["alarmcount"] = parseInt(value["alarmcount"]) + 1;
                                }
                                if(value["alarmtype"] == undefined || value["alarmtype"] == "")
                                {
                                    value["alarmtype"] = sAlarmType;
                                }
                                var myDateFE = new Date();
                                value["time"] = formatterTime(myDateFE);
                                //value.alarmtype = sAlarmType;
                                VisibleInAlarm(value.id,value, sAlarmType);
                            }
                        });
                        break;
                    case "2_3":
//                        bGetLastposition = true;
//                        $("#divState").text("<% =Resources.Lan.LodingLastpostionComplete %>");
                        break;
                    case "2_7"://云镜返回
                        var dateSend2_7 = new Date(); 
                        var sTime2_7 = formatDate(dateSend2_7);
                        var sGuid2_7 =  Guid.NewGuid();
                        var arrInteractive2_7 = new Array();
                        var sResult2_7 = "<% =Resources.Lan.Return %>:<% =Resources.Lan.Fault %>";
                        var UserID2_7 = data.data[0].UserID;
                        var Source2_7 = data.data[0].Source;
                        var Guid2_7 = data.data[0].Guid;
                        var ControlType2_7 = data.data[0].ControlType;
                        var Cmd2_7 = data.data[0].Cmd;
                        var Result2_7 = data.data[0].iResult;
                        var Cph2_7 = data.data[0].Cph;
                        var arrInteractive2_7;
                        if(Result2_7 == 0)
                        {
                            sResult2_7 = "<% =Resources.Lan.Return %>:<% =Resources.Lan.Successful %>";
                        }
                        else if(Result2_7 == 2)
                        {
                            sResult2_7 = "<% =Resources.Lan.Return %>:<% =Resources.Lan.Nonsupport %>";
                        }
                        
                        switch(Cmd2_7)
                        {
                            case 0://拍照
                                arrInteractive2_7 = { id: sGuid2_7.ToString("N"),name:data.data[0].Cph,time:sTime2_7, interactive:"<% =Resources.Lan.RightPhotograph %>",content: sResult2_7};
                                $('#tableInteractive').datagrid('insertRow',{
	                                index: 0,	
	                                row: arrInteractive2_7
                                });
                                var bExistGuid = false;
                                for(var j = 0; j < arrPhotoGuid.length; j++)
                                {
                                    if(arrPhotoGuid[j] == Guid2_7)
                                    {
                                        bExistGuid = true;
                                        arrPhotoGuid.splice(j,1);
                                        break;
                                    }
                                }
                                if(Result2_7 == 0 && Cmd2_7 == 0 && bExistGuid)
                                {
                                    for(var i = 0; i < jsonVehs.length ;i++)
                                    {
                                        if(jsonVehs[i].name == data.data[0].Cph)
                                        {
                                            if(!$('#tabs').tabs('exists','YJ<% =Resources.Lan.RightPhotograph %>【' + jsonVehs[i].name + "】")){
                    		        
	                                        }else{
	                                            var sContent = $('#tabs').tabs('getTab',"YJ<% =Resources.Lan.RightPhotograph %>【" + jsonVehs[i].name + "】").panel('options').content;
	                                            var iFrame = $(sContent).find("iframe");
	                                            window.frames[iFrame[0].name].GetSrc(Guid2_7);
	                                        }
                                            addTab('YJ<% =Resources.Lan.RightPhotograph %>【' + jsonVehs[i].name + "】",'Htmls/Cmd/YJ/FormYJPhoto.aspx?cid=' + jsonVehs[i].customid + '&vehid=' + jsonVehs[i].id.substring(1) + '&guid=' + Guid2_7);
                                            return false;
                                        }
                                    }
                                }
                                break;
                            case 1://录像
                                arrInteractive2_7 = { id: sGuid2_7.ToString("N"),name:data.data[0].Cph,time:sTime2_7, interactive:"<% =Resources.Lan.RealtimeVideoMonitoring %>",content: sResult2_7};
                                $('#tableInteractive').datagrid('insertRow',{
	                                index: 0,	
	                                row: arrInteractive2_7
                                });
                                if(Result2_7 == 0 && Cmd2_7 == 1)
                                {
                                    for(var i = 0; i < jsonVehs.length ;i++)
                                    {
                                        if(jsonVehs[i].name == data.data[0].Cph)
                                        {
                                            var bExistsVideo = false;
                                            for(var j = 0; j < arrVideoCmd.length; j++)
                                            {
                                                if(arrVideoCmd[j].customid == jsonVehs[i].customid)
                                                {
                                                    bExistsVideo = true;
                                                    break;
                                                }
                                            }
                                            if(!bExistsVideo)
                                            {
                                                return false;
                                            }
                                            if(!$('#tabs').tabs('exists','<% =Resources.Lan.RealtimeVideoMonitoring %>【' + jsonVehs[i].name + "】")){
                                                
	                                        }else{
	                                            var sContent = $('#tabs').tabs('getTab',"<% =Resources.Lan.RealtimeVideoMonitoring %>【" + jsonVehs[i].name + "】").panel('options').content;
	                                            var iFrame = $(sContent).find("iframe");
	                                            window.frames[iFrame[0].name].GetSrc(Guid2_7);
	                                        }
                                            addTab('<% =Resources.Lan.RealtimeVideoMonitoring %>【' + jsonVehs[i].name + "】",'Htmls/Cmd/YJ/FormYJVideo.aspx?cid=' + jsonVehs[i].customid + '&vehid=' + jsonVehs[i].id.substring(1) + '&guid=' + Guid2_7);
                                            return false;
                                        }
                                    }
                                }
                                break;
                            case 2://导航
                                arrInteractive2_7 = { id: sGuid2_7.ToString("N"),name:data.data[0].Cph,time:sTime2_7, interactive:"<% =Resources.Lan.GpsNavigation %>",content: sResult2_7};
                                $('#tableInteractive').datagrid('insertRow',{
	                                index: 0,	
	                                row: arrInteractive2_7
                                });
                                break;
                            case 5://关机
                                arrInteractive2_7 = { id: sGuid2_7.ToString("N"),name:data.data[0].Cph,time:sTime2_7, interactive:"<% =Resources.Lan.Shutdown %>",content: sResult2_7};
                                $('#tableInteractive').datagrid('insertRow',{
	                                index: 0,	
	                                row: arrInteractive2_7
                                });
                                break;
                        }
                        break;
                    case "2_8"://车辆资料96同步
                        break;
                    case "4_1":
                        var dateSend85 = new Date(); 
                        var sTime85 = formatDate(dateSend85);
                        var sGuid85 =  Guid.NewGuid();
                        var arrInteractive85 = new Array();
                        var sResult85 = "<% =Resources.Lan.Return %>:<% =Resources.Lan.MessageIsWrong %>";
                        switch(data.data[0].key1)
                        {
                            case 52:
                                arrInteractive85 = { id: sGuid85.ToString("N"),name:data.data[0].cph,time:sTime85, interactive:"<% =Resources.Lan.RightAccOnTimingInterval %>",content: "<% =Resources.Lan.Return %>"};
                                $('#tableInteractive').datagrid('insertRow',{
	                                index: 0,	
	                                row: arrInteractive85
                                });
                                break;
                           case 56:
                                arrInteractive85 = { id: sGuid85.ToString("N"),name:data.data[0].cph,time:sTime85, interactive:"<% =Resources.Lan.OilOpen %>",content: "<% =Resources.Lan.Return %>"};
                                $('#tableInteractive').datagrid('insertRow',{
	                                index: 0,	
	                                row: arrInteractive85
                                });
                                break;
                           case 57:
                                arrInteractive85 = { id: sGuid85.ToString("N"),name:data.data[0].cph,time:sTime85, interactive:"<% =Resources.Lan.OilCutOff %>",content: "<% =Resources.Lan.Return %>"};
                                $('#tableInteractive').datagrid('insertRow',{
	                                index: 0,	
	                                row: arrInteractive85
                                });
                                break;
                            case 63:
                                arrInteractive85 = { id: sGuid85.ToString("N"),name:data.data[0].cph,time:sTime85, interactive:"<% =Resources.Lan.OverSpeedSetting %>",content: "<% =Resources.Lan.Return %>"};
                                    $('#tableInteractive').datagrid('insertRow',{
	                                    index: 0,	
	                                    row: arrInteractive85
                                });
                                break;
                            case 112:
                                arrInteractive85 = { id: sGuid85.ToString("N"),name:data.data[0].cph,time:sTime85, interactive:"<% =Resources.Lan.RightAccOffTimingInterval %>",content: "<% =Resources.Lan.Return %>"};
                                $('#tableInteractive').datagrid('insertRow',{
	                                index: 0,	
	                                row: arrInteractive85
                                });
                                break;
                            case 33027://0x8103
                                switch(data.data[0].key2)
                                {
                                    case 0:
                                        sResult85 = "<% =Resources.Lan.Return %>:<% =Resources.Lan.Successful %>";
                                        break;
                                    case 1:
                                        sResult85 = "<% =Resources.Lan.Return %>:<% =Resources.Lan.Fault %>";
                                        break;
                                    case 2:
                                        sResult85 = "<% =Resources.Lan.Return %>:<% =Resources.Lan.MessageIsWrong %>";
                                        break;
                                    case 3:
                                        sResult85 = "<% =Resources.Lan.Return %>:<% =Resources.Lan.Nonsupport %>";
                                        break;
                                }
                                arrInteractive85 = { id: sGuid85.ToString("N"),name:data.data[0].cph,time:sTime85, interactive:"<% =Resources.Lan.TerminalParameterSettings %>",content: sResult85};
                                $('#tableInteractive').datagrid('insertRow',{
	                                index: 0,	
	                                row: arrInteractive85
                                });
                                break;
                            case 33029://0x8105
                                switch(data.data[0].key2)
                                {
                                    case 0:
                                        sResult85 = "<% =Resources.Lan.Return %>:<% =Resources.Lan.Successful %>";
                                        break;
                                    case 1:
                                        sResult85 = "<% =Resources.Lan.Return %>:<% =Resources.Lan.Fault %>";
                                        break;
                                    case 2:
                                        sResult85 = "<% =Resources.Lan.Return %>:<% =Resources.Lan.MessageIsWrong %>";
                                        break;
                                    case 3:
                                        sResult85 = "<% =Resources.Lan.Return %>:<% =Resources.Lan.Nonsupport %>";
                                        break;
                                }
                                arrInteractive85 = { id: sGuid85.ToString("N"),name:data.data[0].cph,time:sTime85, interactive:"<% =Resources.Lan.RightTerminalControl %>",content: sResult85};
                                $('#tableInteractive').datagrid('insertRow',{
	                                index: 0,	
	                                row: arrInteractive85
                                });
                                break;
                        }
                        break;
                    case "4_2":
                        if(!$('#tabs').tabs('exists','<% =Resources.Lan.RightPhotograph %>【' + data.data[0].cph + "】")){
                		        
	                        }else{
	                            var sContent = $('#tabs').tabs('getTab',"<% =Resources.Lan.RightPhotograph %>【" + data.data[0].cph + "】").panel('options').content;
	                            var iFrame = $(sContent).find("iframe");
	                            window.frames[iFrame[0].name].SetSrc(data.data[0].src);
	                        }
                    break;
                    default:                                
                        $("#divState").text("<% =Resources.Lan.Unknown %>" + "<% =Resources.Lan.Interactive %>：" + data.key);
                        break;
                }
             }
             catch(e)
             {}
        }
        
        function GetOil(vehId,dOilSalce)
        {
            if(dOilSalce == 0 || jsonOil == undefined)
            {
                return 0;
            }
            else
            {
                for(var i =0; i < jsonOil.length; i++)
                {
                    if(jsonOil[i].VehID == vehId)
                    {
                        if(jsonOil[i].lstDetail.length == 0)
                        {
                            return 0;
                        }
                        else if(jsonOil[i].lstDetail.length == 1)
                        {
                            return (jsonOil[i].lstDetail[0].OilValue * dOilSalce / 100);
                        }
                        else
                        {
                            //提前找出电阻电压最大值，以及和它对应的油量刻度
                            //此目的是为了过滤终端超大阻值的异常
                            var iMaxSign = 0;
                            var iMaxPercent = 0;
                            for (var iOilData = 0; iOilData < jsonOil[i].lstDetail.length; iOilData++)
                            {
                                if (jsonOil[i].lstDetail[iOilData].Scale > iMaxPercent)
                                {
                                    iMaxSign = iOilData;
                                    iMaxPercent = jsonOil[i].lstDetail[iOilData].OilValue;
                                }
                            }

                            if (iMaxPercent <= dOilSalce)
                            {
                                return jsonOil[i].lstDetail[iMaxSign].OilValue;
                            }
                            else
                            {
                                for (var iOilData = 0; iOilData < jsonOil[i].lstDetail.length; iOilData++)
                                {
                                    if (jsonOil[i].lstDetail[iOilData].Scale > dOilSalce)
                                    {
                                        if (iOilData == 0)
                                        {
                                            return (jsonOil[i].lstDetail[iOilData].OilValue - (jsonOil[i].lstDetail[iOilData].Scale - dOilSalce) * (jsonOil[i].lstDetail[iOilData + 1].OilValue - jsonOil[i].lstDetail[iOilData].OilValue) / (jsonOil[i].lstDetail[iOilData + 1].Scale - jsonOil[i].lstDetail[iOilData].Scale)).toFixed(2);
                                        }
                                        else
                                        {
                                            return (jsonOil[i].lstDetail[iOilData].OilValue - (jsonOil[i].lstDetail[iOilData].Scale - dOilSalce) * (jsonOil[i].lstDetail[iOilData].OilValue - jsonOil[i].lstDetail[iOilData - 1].OilValue) / (jsonOil[i].lstDetail[iOilData].Scale - jsonOil[i].lstDetail[iOilData - 1].Scale)).toFixed(2);
                                        }
                                    }
                                }
                                return (jsonOil[i].lstDetail[jsonOil[i].lstDetail.lenght - 1].OilValue + (dOilSalce - jsonOil[i].lstDetail[jsonOil[i].lstDetail.length - 1].Scale) * (Math.Abs(jsonOil[i].lstDetail[jsonOil[i].lstDetail.length - 1].OilValue - jsonOil[i].lstDetail[jsonOil[i].lstDetail.length - 2].OilValue) / (jsonOil[i].lstDetail[jsonOil[i].lstDetail.length - 1].Scale - jsonOil[i].lstDetail[jsonOil[i].lstDetail.length - 2].Scale))).toFixed(2);
                            }
                        }
                        break;
                    }
                }
                return 0;
            }
        }
        
        function formatterTime(date){
			var y = date.getFullYear();
			var m = date.getMonth()+1;
			var d = date.getDate();
			var h = date.getHours();
			var f = date.getMinutes();
			var s = date.getSeconds();
			return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d)+' '+ (h<10?('0'+h):h)+':'+(f<10?('0'+f):f)+':'+(s<10?('0'+s):s);
		}
        
        var bGetLastposition = false;
        function connectSocketServer() {
                var support = "MozWebSocket" in window ? 'MozWebSocket' : ("WebSocket" in window ? 'WebSocket' : null);
//$("#divState").text("<% =Resources.Lan.LoadVehComplete %>");
                if (support == null) {
                    $("#divState").text(noSupportMessage);
                    return;
                }

                $("#divState").text("<% =Resources.Lan.ConnectingServer %>");
                // create a new websocket and connect
                ws = new window[support]('<% =ConfigurationManager.AppSettings["WebPort"] %>');
//                ws = new window[support]('ws://192.168.1.159:2012/');
                // when data is comming from the server, this metod is called
                ws.onmessage = function (evt) {
                    try
                    {
                        var sReturn = "";
                        if(typeof(evt.data)=="string"){ 
                            sReturn = evt.data;
                            Analize(sReturn);
                        }else{ 
                            var reader = new FileReader(); 
                            reader.onload = function(evt){ 
                                if(evt.target.readyState == FileReader.DONE){ 
                                    var dataBlob = new Uint8Array(evt.target.result); 
                                    for(var k = 0; k < dataBlob.length; k++)
                                    {
                                        sReturn = sReturn + String.fromCharCode(dataBlob[k]);
                                    }
                                    Analize(sReturn);
                                } 
                            } 
                            reader.readAsArrayBuffer(evt.data); 
                        }
                        
                    }
                    catch(e)
                    {
                        ShowInfo(e.message);
                    }
                };

                // when the connection is established, this method is called
                ws.onopen = function () {
                    $("#divState").text("<% =Resources.Lan.SuccessfulConnectionCenter %>");
                    var sUserName = GetCookie("username");
                    var sPwd = GetCookie("pwd");
                    var sLoginType = GetCookie("logintype");
                    if(sUserName == undefined || sPwd == undefined)
                    {
                        $("#divState").text("<% =Resources.Lan.PleaseLogin %>");
                        return;
                    }
                    var sLogin = "[{'key':'1_1','ver':1,'rows':1,'cols':2,data:[{'name':'" + sUserName + "','pwd':'" + sPwd + "','type':" + sLoginType + "}]}]";
                    ws.send(sLogin);
//                    var a = new Uint8Array([8, 6, 7, 5, 3, 0, 9,10,16,255]);  
////                    $("#divState").text(Decodeuint8arr(a));
//                    a = Encodeuint8arr("你好");
//                    
////                    ws.binaryType = 'arraybuffer';
//                    ws.send(a.buffer);  
                };

                // when the connection is closed, this method is called
                ws.onclose = function () {
                    $("#divState").text('<% =Resources.Lan.ConnectionClosed %>');
                    setTimeout("connectSocketServer()", 2000 )
                }
            }
            function Decodeuint8arr(uint8array){
                return new TextDecoder("utf-8").decode(uint8array);
            }
            
            function Encodeuint8arr(myString){
                return new TextEncoder("utf-8").encode(myString);
            }
        //企标----------------------------------------------------------------------------------------------------------
        function GetEnterprisePositionStatus(pPacketData,objAcc)
        {
            try
            {
                var iIsantiTurn = -1;
                var sTelePhone = "";
                if(pPacketData.length == 0)
                {
                    return "";
                }
                var sTempStatus = "";
                var bByte = parseInt(pPacketData.substring(1,3),16).toString(2);
                bByte = (Array(8).join(0) + bByte).slice(-8);
                if (bByte[0] == "1")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.AccOff %> ";
                    objAcc.Acc = 0;
                }
                else
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.AccOn %> ";
                    objAcc.Acc = 1;
                }
                if (bByte[1] == "1")
                {
                    //sTempStatus=sTempStatus+"自定义1路高传感器状态为低(正常) ";	
//                    iSenSorData[0] = 1;
                }
                else
                {
//                    iSenSorData[0] = 0;
                    //sTempStatus = sTempStatus + "1路高传感触发 ";
                }
                if (bByte[2] == "1")
                {
                    //TempStatus=sTempStatus+"自定义2路高传感器状态为低(正常) ";	
//                    iSenSorData[1] = 1;
                    //停转
                    sTempStatus = sTempStatus + "<% =Resources.Lan.Stalling %> ";
                    iIsantiTurn = 0;
                }
                else
                {
//                    iSenSorData[1] = 0;
                    //sTempStatus = sTempStatus + "2路高传感触发 ";
                }
                if (bByte[3] == "1")
                {
                    //sTempStatus=sTempStatus+"自定义1路低传感器状态为高(正常) ";	
//                    iSenSorData[2] = 1;
                }
                else
                {
//                    iSenSorData[2] = 0;
                    //sTempStatus = sTempStatus + "1路低传感触发 ";
                }
                if (bByte[4] == "1")
                {
                    //TempStatus=sTempStatus+"自定义2路低传感器状态为高(正常) ";
//                    iSenSorData[3] = 1;
                }
                else
                {
//                    iSenSorData[3] = 0;
                    // sTempStatus = sTempStatus + "2路低传感触发 ";
                }

                if (bByte[6] == "1")
                {
                    //sTempStatus = sTempStatus + "没有登签 ";
                }
                else
                {
                    //int iSignin=0;
                    //string sSignno = "";
                    //sTempStatus = sTempStatus + "已登签 ";
                    //if (pPacketData.Length > 41)
                    //{
                    //    //解析登签状态

                    //    if ((pPacketData[31] & (byte)0x2) == 0)
                    //    {
                    //        //已登签

                    //        //iSignin=1;
                    //        if (pPacketData[2] == 0x80)
                    //        {
                    //            sSignno = (ReturnHsignNo(pPacketData[27]) * 256 + pPacketData[40]).ToString();
                    //            sTempStatus = sTempStatus + "登签号：" + sSignno + " ";
                    //        }
                    //    }
                    //    else
                    //    {
                    //        //没有登签
                    //        //iSignin=0;
                    //    }
                    //}
                }
                //if ((pPacketData[31] & (byte)0x1) == 0x1)
                //{
                    // sTempStatus = sTempStatus + "油路控制模式 ";
                    if (bByte[5] == "1")
                    {
                        sTempStatus = sTempStatus + "<% =Resources.Lan.OilNormal %> ";
                    }
                    else
                    {
                        sTempStatus = sTempStatus + "<% =Resources.Lan.OilDisconnect %> ";
                    }
                //}
                //else
                //{
                //    //sTempStatus = sTempStatus + "超速提示控制模式 ";
                //    if ((pPacketData[31] & (byte)0x4) == 0x4)
                //    {
                //        // sLocalString = sLocalString + "没有超速提示 ";
                //    }
                //    else
                //    {
                //        // sLocalString = sLocalString + "超速提示模式 ";
                //    }
                //}
                bByte = parseInt(pPacketData.substring(3,5),16).toString(2);
                bByte = (Array(8).join(0) + bByte).slice(-8);
                //32
                if (bByte[6] == "1")
                {
                    //sTempStatus=sTempStatus+"GPRS没有上线 ";		
                }
                else
                {
                    //sTempStatus=sTempStatus+"GPRS已上线 ";		
                }
                if (bByte[7] == "1")
                {
                    //sTempStatus=sTempStatus+"终端拨号未成功 ";

                }
                else
                {
                    //sTempStatus=sTempStatus+"终端拨号成功 ";

                }
                //33
                bByte = parseInt(pPacketData.substring(5,7),16).toString(2);
                bByte = (Array(8).join(0) + bByte).slice(-8);
                if (bByte[0] == "1")
                {
                    //sTempStatus=sTempStatus+"GPRS未注册 ";

                }
                else
                {
                    //sTempStatus=sTempStatus+"GPRS注册 ";

                }
                if (bByte[1] == "1")
                {
                    //sTempStatus=sTempStatus+"中心应下发21应答指令 ";

                }
                else
                {
                    //sTempStatus=sTempStatus+"中心不需下发21应答指令 ";

                }
                if (bByte[2] == "1")
                {
                    //sTempStatus = sTempStatus + "TCP通讯方式 ";

                }
                else
                {
                    //sTempStatus = sTempStatus + "UDP通讯方式 ";

                }
                //36
                bByte = parseInt(pPacketData.substring(7,9),16).toString(2);
                bByte = (Array(8).join(0) + bByte).slice(-8);
                if (iIsantiTurn == 0)
                {
                    //停转
                }
                else
                {
                    //转

                    if (bByte[2] == "1" & bByte[1] == "1")
                    {
                        //正转
                        sTempStatus = sTempStatus + "<% =Resources.Lan.Foreward %> ";
                        iIsantiTurn = 1;
                    }
                    else if (bByte[2] == "0" & bByte[1] == "1")
                    {
                        //反转
                        iIsantiTurn = 2;
                        sTempStatus = sTempStatus + "<% =Resources.Lan.Reversal %> ";
                    }
                }
                if (bByte[5] == "1")
                {
                    sTelePhone = sTelePhone + "<% =Resources.Lan.ProhibitCallsOut %> ";

                }
                else
                {
                    sTelePhone = sTelePhone + "<% =Resources.Lan.AllowCallsOut %> ";

                }
                if (bByte[6] == "1")
                {
                    sTelePhone = sTelePhone + "<% =Resources.Lan.ProhibitCallsIn %> ";

                }
                else
                {
                    sTelePhone = sTelePhone + "<% =Resources.Lan.AllowCallsIn %> ";

                }
                if (bByte[7] == "1")
                {
                    sTelePhone = sTelePhone + "<% =Resources.Lan.ProhibitCalls %> ";

                }
                else
                {
                    sTelePhone = sTelePhone + "<% =Resources.Lan.AllowCalls %> ";

                }
                //sTempStatus=sTempStatus+"ACC开时定时发送时间间隔" +(pPacketData[35]*256+pPacketData[36]).ToString() +"秒 ";
                //sTempStatus=sTempStatus+"停车超时时间"+pPacketData[37].ToString()+"分 ";
                //sTempStatus=sTempStatus+"超速设置门阀"+pPacketData[38].ToString()+"公里/小时 ";
                //sTempStatus=sTempStatus+"电子围栏设置个数"+pPacketData[39].ToString()+"个 ";
                //sTempStatus=sTempStatus+"定时发送图片的时间"+pPacketData[41].ToString()+"分 ";
                return sTempStatus;
            }
            catch (e)
            {
                return "";
            }
        }
        
        function GetEnterpriseLocationInfo(pPacketData)
        {
            try
            {
                var sLocalString = "";
                var bByte = parseInt(pPacketData.substring(9,11),16).toString(2);
                bByte = (Array(8).join(0) + bByte).slice(-8);
                if (bByte[1] == "1")
                {
                    if (bByte[2] == "1")
                    {
                        //GPS天线正常
                        sLocalString = sLocalString + "<% =Resources.Lan.AntennaNormal %> ";
                    }
                    else
                    {
                        //GPS天线短路
                        sLocalString = sLocalString + "<% =Resources.Lan.AntennaShortCircuit %> ";
                    }
                }
                else
                {
                    if (bByte[2] == "1")
                    {
                        sLocalString = sLocalString + "<% =Resources.Lan.AntennaOpen %> ";

                    }
                    else
                    {
                        sLocalString = sLocalString + "<% =Resources.Lan.AntennaFault %> ";
                    }
                }
                if (bByte[3] == "1")
                {

                    if (bByte[4] == "1")
                    {
                        //电源正常
                        sLocalString = sLocalString + "<% =Resources.Lan.PowerNormal %> ";
                    }
                    else
                    {
                        //主电源掉电
                        sLocalString = sLocalString + "<% =Resources.Lan.PowerOff %> ";

                    }
                }
                else
                {

                    if (bByte[4] == "1")
                    {
                        //主电源过高或过低
                        sLocalString = sLocalString + "<% =Resources.Lan.PowerVoltageLow %> ";
                    }
                    else
                    {

                    }

                }
                return sLocalString;
            }
            catch(e)
            {
                return "";
            }
        }
        
        function GetEnterprisePositionAlarm(pPacketData)
        {
            try
            {
                var sTempStatus = "";
                //34
                var bByte = parseInt(pPacketData.substring(3,5),16).toString(2);
                bByte = (Array(8).join(0) + bByte).slice(-8);
                if (bByte[0] == "1")
                {
                    sTempStatus = sTempStatus + "";
                }
                else
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.AlarmRob %> ";
                }


                //疲劳驾驶报警 XDLN 版本 表示疲劳驾驶报警D4=0报警 D4=1正常 其它版本保留没用
                if (bByte[3] == "1")
                {
                    sTempStatus = sTempStatus + "";
                }
                else
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.AlarmDriverOvertime %> ";
                }

                if (bByte[1] == "1")
                {
                    sTempStatus = sTempStatus + "";
                }
                else
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.AlarmOverSpeed %> ";
                }
                if (bByte[2] == "1")
                {
                    sTempStatus = sTempStatus + "";
                }
                else
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.AlarmParkingSuperlong %> ";
                }
//                if (bByte[4] == "1")
//                {
//                    sTempStatus = sTempStatus + "";
//                }
//                else
//                {
//                    sTempStatus = sTempStatus + "压车报警 ";
//                }

                if (bByte[5] == "1")
                {
                    sTempStatus = sTempStatus + "";
                }
                else
                {
//                    sTempStatus = sTempStatus + "密码错误报警 ";
                }
                //pPacketData[27]
                return sTempStatus;
            }
            catch (e)
            {
                return "";
            }
        }
        //部标-------------------------------------------
        function GetGbBDPositionStatus(pPacketData,objAcc)
        {
            try
            {
                var sTempStatus = "";
                var iIndex = 15;
                var bByte = parseInt(pPacketData.substring(iIndex,iIndex + 2),16).toString(2);
                bByte = (Array(8).join(0) + bByte).slice(-8);
                if (bByte[7] == "0")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.AccOff %> ";
                    objAcc.Acc = 0;
                }
                else
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.AccOn %> ";
                    objAcc.Acc = 1;
                }
                iIndex = iIndex - 2;
                bByte = parseInt(pPacketData.substring(iIndex,iIndex + 2),16).toString(2);
                bByte = (Array(8).join(0) + bByte).slice(-8);
                if (bByte[5] == "0")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.OilNormal %> ";
                }
                else
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.OilDisconnect %> ";
                }
                if (bByte[4] == "0")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.CircuitNormal %> ";
                }
                else
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.CircuitDisconnection %> ";
                }
                if (bByte[2] == "0")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.DoorFront %>" + "<% =Resources.Lan.DoorClose %> ";
                }
                else
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.DoorFront %>" + "<% =Resources.Lan.DoorOpen %> ";
                }
                if (bByte[1] == "0")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.DoorMiddle %>" + "<% =Resources.Lan.DoorClose %> ";
                }
                else
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.DoorMiddle %>" + "<% =Resources.Lan.DoorOpen %> ";
                }
                if (bByte[0] == "0")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.DoorBack %>" + "<% =Resources.Lan.DoorClose %> ";
                }
                else
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.DoorBack %>" + "<% =Resources.Lan.DoorOpen %> ";
                }
                iIndex = iIndex - 2;
                bByte = parseInt(pPacketData.substring(iIndex,iIndex + 2),16).toString(2);
                bByte = (Array(8).join(0) + bByte).slice(-8);
                if (bByte[7] == "0")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.DoorDriver %>" + "<% =Resources.Lan.DoorClose %> ";
                }
                else
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.DoorDriver %>" + "<% =Resources.Lan.DoorOpen %> ";
                }
                if (bByte[6] == "0")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.Door5 %>" + "<% =Resources.Lan.DoorClose %> ";
                }
                else
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.Door5 %>" + "<% =Resources.Lan.DoorOpen %> ";
                }
                
//                if ((status & 0x100) == 0x100)
//                {
//                    if ((status & 0x200) == 0x200)
//                    {
//                        sb.Append("满载 ");
//                    }
//                }
//                else
//                {
//                    if ((status & 0x200) == 0x200)
//                    {
//                        sb.Append("半载 ");
//                    }
//                    else
//                    {
//                        sb.Append("空车 ");
//                    }
//                }                   
//                sb.Append(((status & 0x800) == 0 ? ("电路正常 ") : "电路断开 "));

//                sb.Append(((status & 0x2000) == 0 ? ("门1关 ") : "门1开 "));
//                sb.Append(((status & 0x4000) == 0 ? ("门2关 ") : "门2开 "));
//                sb.Append(((status & 0x8000) == 0 ? ("门3关 ") : "门3开 "));
//                sb.Append(((status & 0x10000) == 0 ? ("门4关（驾驶席门） ") : "门4开（驾驶席门） "));
//                sb.Append(((status & 0x20000) == 0 ? ("门5关  ") : "门5开 "));
//                sb.Append(((status & 0x40000) == 0 ? ("不使用GPS卫星定位 ") : "使用GPS卫星定位 "));
//                sb.Append(((status & 0x80000) == 0 ? ("不使用北斗卫星定位 ") : "使用北斗卫星定位 "));
//                sb.Append(((status & 0x100000) == 0 ? ("不使用GLONASS卫星定位 ") : "使用GLONASS卫星定位 "));
//                sb.Append(((status & 0x200000) == 0 ? ("不使用Galileo卫星定位 ") : "使用Galileo卫星定位 "));

//                //sb.Append(((status & 0x8000) == 0 ? ("发动机关 ") : "发动机开 "));


//                //sb.Append(((status & 0x20000) == 0 ? ("未刹车 ") : "刹车 "));
//                //sb.Append(((status & 0x40000) == 0 ? ("左转向关 ") : "左转向开 "));
//                //sb.Append(((status & 0x80000) == 0 ? ("右转向关 ") : "右转向开 "));
//                bGPS = (status & 0x40000) == 0 ? false : true;
//                bDB = (status & 0x80000) == 0 ? false : true;
//                //sb.Append(((status & 0x100000) == 0 ? ("远光关 ") : "远光开 "));
                return sTempStatus;
            }
            catch(e)
            {
                return "";
            }
        }
        
        function GetGbPositionStatus(pPacketData,objAcc)
        {
            try
            {
                var sTempStatus = "";
                var iIndex = 15;
                var bByte = parseInt(pPacketData.substring(iIndex,iIndex + 2),16).toString(2);
                bByte = (Array(8).join(0) + bByte).slice(-8);
                if (bByte[7] == "0")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.AccOff %> ";
                    objAcc.Acc = 0;
                }
                else
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.AccOn %> ";
                    objAcc.Acc = 1;
                }
                iIndex = iIndex - 2;
                bByte = parseInt(pPacketData.substring(iIndex,iIndex + 2),16).toString(2);
                bByte = (Array(8).join(0) + bByte).slice(-8);
                if (bByte[5] == "0")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.OilNormal %> ";
                }
                else
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.OilDisconnect %> ";
                }
                if (bByte[4] == "0")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.CircuitNormal %> ";
                }
                else
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.CircuitDisconnection %> ";
                }
                if (bByte[2] == "0")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.DoorFront %>" + "<% =Resources.Lan.DoorClose %> ";
                }
                else
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.DoorFront %>" + "<% =Resources.Lan.DoorOpen %> ";
                }
                if (bByte[1] == "0")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.DoorBack %>" + "<% =Resources.Lan.DoorClose %> ";
                }
                else
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.DoorBack %>" + "<% =Resources.Lan.DoorOpen %> ";
                }
                if (bByte[0] == "0")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.EngineClose %> ";
                }
                else
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.EngineOpen %> ";
                }
                iIndex = iIndex - 2;
                bByte = parseInt(pPacketData.substring(iIndex,iIndex + 2),16).toString(2);
                bByte = (Array(8).join(0) + bByte).slice(-8);
                if (bByte[7] == "0")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.AirConditionerClose %> " ;
                }
                else
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.AirConditionerOpen %> ";
                }
                if (bByte[6] == "0")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.NoBrakes %> ";
                }
                else
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.Brakes %> ";
                }
                if (bByte[5] == "0")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.SteerLeft %>" + "<% =Resources.Lan.DoorClose %> ";
                }
                else
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.SteerLeft %>" + "<% =Resources.Lan.DoorOpen %> ";
                }
                if (bByte[4] == "0")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.SteerRight %>" + "<% =Resources.Lan.DoorClose %> ";
                }
                else
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.SteerRight %>" + "<% =Resources.Lan.DoorOpen %> ";
                }
                if (bByte[3] == "0")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.DistanceLight %>" + "<% =Resources.Lan.DoorClose %> ";
                }
                else
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.DistanceLight %>" + "<% =Resources.Lan.DoorOpen %> ";
                }
                return sTempStatus;
            }
            catch(e)
            {
                return "";
            }
        }
        
        function GetGbBDPositionAlarm(pPacketData)
        {
            try
            {
                var sTempStatus = "";
                var iIndex = 7;
                var bByte = parseInt(pPacketData.substring(iIndex,iIndex + 2),16).toString(2);
                bByte = (Array(8).join(0) + bByte).slice(-8);
                if (bByte[7] == "1")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.AlarmRob %> ";
                }
                if (bByte[6] == "1")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.AlarmOverSpeed %> ";
                }
                if (bByte[5] == "1")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.AlarmFatigueDriving %> ";
                }
                if (bByte[3] == "1")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.AlarmGNSSModuleFault %> ";
                }
                if (bByte[2] == "1")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.AntennaOpen %> ";
                }
                if (bByte[1] == "1")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.AntennaShortCircuit %> ";
                }
                if (bByte[0] == "1")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.PowerVoltageLow %> ";
                }
                iIndex = iIndex - 2;
                bByte = parseInt(pPacketData.substring(iIndex,iIndex + 2),16).toString(2);
                bByte = (Array(8).join(0) + bByte).slice(-8);
                if (bByte[7] == "1")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.PowerOff %> ";
                }
                if (bByte[4] == "1")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.AlarmCameraFault %> ";
                }
                if (bByte[3] == "1")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.AlarmICCardFault %> ";
                } 
                iIndex = iIndex - 2;
                bByte = parseInt(pPacketData.substring(iIndex,iIndex + 2),16).toString(2);
                bByte = (Array(8).join(0) + bByte).slice(-8);
                if (bByte[4] == "1")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.AlarmTimeoutParking %> ";
                }
                if (bByte[3] == "1")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.AlarmTimeoutParking %> ";
                }
                if (bByte[2] == "1")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.AlarmInAndOutOfTheArea %> ";
                }
                if (bByte[1] == "1")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.AlarmInAndOutOfTheLine %> ";
                }
                if (bByte[0] == "1")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.AlarmOutOfTheLine %> ";
                }
                iIndex = iIndex - 2;
                bByte = parseInt(pPacketData.substring(iIndex,iIndex + 2),16).toString(2);
                bByte = (Array(8).join(0) + bByte).slice(-8);
                if (bByte[2] == "1")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.AlarmCrashForewarning %> ";
                }
                if (bByte[1] == "1")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.AlarmRolloverForewarning %> ";
                }
                return sTempStatus;
            }
            catch (e)
            {
                return "";
            }
        }
        
        function GetGbPositionAlarm(pPacketData)
        {
            try
            {
                var sTempStatus = "";
                var iIndex = 7;
                var bByte = parseInt(pPacketData.substring(iIndex,iIndex + 2),16).toString(2);
                bByte = (Array(8).join(0) + bByte).slice(-8);
                if (bByte[7] == "1")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.AlarmRob %> ";
                }
                if (bByte[6] == "1")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.AlarmOverSpeed %> ";
                }
                if (bByte[5] == "1")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.AlarmFatigueDriving %> ";
                }
                if (bByte[3] == "1")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.AlarmGNSSModuleFault %> ";
                }
                if (bByte[2] == "1")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.AntennaOpen %> ";
                }
                if (bByte[1] == "1")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.AntennaShortCircuit %> ";
                }
                if (bByte[0] == "1")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.PowerVoltageLow %> ";
                }
                iIndex = iIndex - 2;
                bByte = parseInt(pPacketData.substring(iIndex,iIndex + 2),16).toString(2);
                bByte = (Array(8).join(0) + bByte).slice(-8);
                if (bByte[7] == "1")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.PowerOff %> ";
                }
                if (bByte[4] == "1")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.AlarmCameraFault %> ";
                }
                iIndex = iIndex - 2;
                bByte = parseInt(pPacketData.substring(iIndex,iIndex + 2),16).toString(2);
                bByte = (Array(8).join(0) + bByte).slice(-8);
                if (bByte[4] == "1")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.AlarmTimeoutParking %> ";
                }
                if (bByte[3] == "1")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.AlarmTimeoutParking %> ";
                }
                if (bByte[2] == "1")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.AlarmInAndOutOfTheArea %> ";
                }
                if (bByte[1] == "1")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.AlarmInAndOutOfTheLine %> ";
                }
                if (bByte[0] == "1")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.AlarmOutOfTheLine %> ";
                }
                iIndex = iIndex - 2;
                bByte = parseInt(pPacketData.substring(iIndex,iIndex + 2),16).toString(2);
                bByte = (Array(8).join(0) + bByte).slice(-8);
                if (bByte[2] == "1")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.AlarmCrashForewarning %> ";
                }
                if (bByte[1] == "1")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.AlarmRolloverForewarning %> ";
                }
                return sTempStatus;
            }
            catch (e)
            {
                return "";
            }
        }
        
        function GetK1PositionAlarm(pPacketData)
        {
            try
            {
                var sTempStatus = "";
                var iIndex = 1;
                var bByte = parseInt(pPacketData.substring(iIndex,iIndex + 2),16).toString(2);
                bByte = (Array(8).join(0) + bByte).slice(-8);
               
                if (bByte[4] == "1")
                {
                    sTempStatus = sTempStatus + "<% =Resources.Lan.TerminalDismantle %> ";
                }
                
                return sTempStatus;
            }
            catch (e)
            {
                return "";
            }
        }
        
        function GetK1Ex(pPacketData,objAcc)
        {
            var row = {"status":"","alarm":""};
            try
            {                
                var sTempStatus = "";
                if(pPacketData == undefined)
                {
                    return row;
                }
                if(pPacketData.length == 0)
                {
                    return row;
                }
                var iIndex = 0;
                var iDataCount = -1;//终端条数
                var iMaxCount = 1800;//最大上传条数
//                var bByte = parseInt(pPacketData.substring(iIndex,iIndex + 2),16).toString(2);
//                bByte = (Array(8).join(0) + bByte).slice(-8);
                while(iIndex < pPacketData.length - 8)
                {
                    var sTextLen = pPacketData.substring(iIndex,iIndex + 4);
                    var sCmd = pPacketData.substring(iIndex + 4,iIndex + 8);
                    var iLen = parseInt(sTextLen.substring(0,2),16) * 256;
                    iLen = iLen + parseInt(sTextLen.substring(2,4),16);
                    
                    if(iLen == 0)
                    {
                        iIndex = iIndex + 1;
                        continue;
                    }
                    else if(iIndex + (iLen * 2) + 4 <= pPacketData.length)
                    {
                        var sData = pPacketData.substring(iIndex + 8,iIndex + iLen * 2 + 4);
                        iIndex = iIndex + 4 + iLen * 2;
                        if(iLen == 5 && sCmd == "0004") //K1低功耗AD
                        {
                            sTempStatus = sTempStatus + "<% =Resources.Lan.Voltage %>：" + sData[0] + "." + sData.substr(1,5) + "V ";
                        }
                        else if(iLen == 6 && sCmd == "00A5") //K1低功耗版本
                        {                            
                            if(sData == "00000001")//A5C
                            {
                                iMaxCount = 1500;
                            }
                            else if(sData == "00000002")//A5D
                            {
                                iMaxCount = 1000;
                            }
                            else if(sData == "00000006")//ACAR,A5C-3
                            {
                                iMaxCount = 1500;
                            }
                        }
                        else if(iLen == 4 && sCmd == "0008") //K1低功耗电池电压
                        {
                            iDataCount = parseInt(sData.substring(0,2),16) * 256;
                            iDataCount = iDataCount + parseInt(sData.substring(2,4),16);
                        }
                        else if(iLen == 3 && sCmd == "00A8")
                        {
                            sTempStatus = sTempStatus + "<% =Resources.Lan.Power %>：" + parseInt(sData.substring(0,2),16) + "% ";
                        }
                        else if(iLen == 6 && sCmd == "0089")
                        {
                            var bByte = parseInt(sData.substring(6,8),16).toString(2);
                            bByte = (Array(8).join(0) + bByte).slice(-8); 
                            if(bByte[6] == '0')
                            {
                                row.alarm = row.alarm + "<% =Resources.Lan.TerminalDismantle %> " ;
                            }
                        }
                        else if(sCmd == "00AA")
                        {
                            if(sData[0] == "0" && sData[1] == "0")
                            {
                                sTempStatus = sTempStatus + "<% =Resources.Lan.AccOff %> " ;
                                objAcc.Acc = 0;
                            }
                            else
                            {
                                sTempStatus = sTempStatus + "<% =Resources.Lan.AccOn %> " ;
                                objAcc.Acc = 1;
                            }
                            if(sData[2] == "0" && sData[3] == "0")
                            {
                                sTempStatus = sTempStatus + "<% =Resources.Lan.G_SensorAnomaly %> " ;
                            }
                            else
                            {
                                sTempStatus = sTempStatus + "<% =Resources.Lan.G_SensorNormal %> " ;
                            }
                            //ACC开回传时间
                            var iACConAA = parseInt(sData.substring(4,6),16) * 256;
                            iACConAA = iACConAA + parseInt(sData.substring(6,8),16);
                            sTempStatus = sTempStatus + "<% =Resources.Lan.RightAccOnTimingInterval %>：" + iACConAA + "<% =Resources.Lan.Second %> " ;
                            var iACCoffAA = parseInt(sData.substring(8,10),16) * 256;
                            iACCoffAA = iACCoffAA + parseInt(sData.substring(10,12),16);
                            sTempStatus = sTempStatus + "<% =Resources.Lan.RightAccOffTimingInterval %>：" + iACCoffAA + "<% =Resources.Lan.Second %> " ;
                            var iMoveTimeAA = parseInt(sData.substring(12,14),16) * 256 * 256 * 256;
                            iMoveTimeAA = iMoveTimeAA + parseInt(sData.substring(14,16),16) * 256 * 256;
                            iMoveTimeAA = iMoveTimeAA + parseInt(sData.substring(16,18),16) * 256;
                            iMoveTimeAA = iMoveTimeAA + parseInt(sData.substring(18,20),16);
                            sTempStatus = sTempStatus + "<% =Resources.Lan.MovementPatternTime %>：" + iMoveTimeAA + "<% =Resources.Lan.Minute %> " ;
                            var iStaticTimeAA = parseInt(sData.substring(20,22),16) * 256 * 256 * 256;
                            iStaticTimeAA = iStaticTimeAA + parseInt(sData.substring(22,24),16) * 256 * 256;
                            iStaticTimeAA = iStaticTimeAA + parseInt(sData.substring(24,26),16) * 256;
                            iStaticTimeAA = iStaticTimeAA + parseInt(sData.substring(26,28),16);
                            sTempStatus = sTempStatus + "<% =Resources.Lan.StaticModelTime %>：" + iStaticTimeAA + "<% =Resources.Lan.Minute %> " ;
                            
                        }
                        else if(iLen == 7 && sCmd == "00B3")
                        {
                            if(sData[0] == "0" && sData[1] == "0")
                            {
                                sTempStatus = sTempStatus + "<% =Resources.Lan.ACARBluetoothOpen %> ";
                            }
                            else
                            {
                                sTempStatus = sTempStatus + "<% =Resources.Lan.ACARBluetoothClose %> ";
                            }
                            var bByte = parseInt(sData.substring(4,6),16).toString(2);
                            bByte = (Array(8).join(0) + bByte).slice(-8); 
                            if(bByte[6] == "0")
                            {
                                row.alarm = row.alarm + "BCAR<% =Resources.Lan.TerminalDismantle %> " ;
                            }
                            bByte = parseInt(sData.substring(8,10),16).toString(2);
                            bByte = (Array(8).join(0) + bByte).slice(-8); 
                            if(bByte[7] == "0")
                            {
                                row.alarm = row.alarm + "<% =Resources.Lan.ACARBluetoothFailure %> " ;
                            }
                            if(bByte[6] == "0")
                            {
                                row.alarm = row.alarm + "<% =Resources.Lan.BCARTest %> " ;
                            }
                        }
                        else if(sCmd == "00A3")
                        {                           
                            sTempStatus = sTempStatus + "<% =Resources.Lan.DebugInfo %>：" + HerGb2312ToStr(sData) + " ";
                        }
                    }
                    else
                    {
                        iIndex = iIndex + 1;
                    }
                }
                if(iDataCount > -1 && iMaxCount > 0)
                {
                    row.status = row.status + "<% =Resources.Lan.RemainCount %>：" + iDataCount + "，" +parseInt(iDataCount * 100 / iMaxCount) + "% " + sTempStatus;
                }
                else
                {
                    row.status =  row.status + sTempStatus;
                }
                return row;
            }
            catch (e)
            {
                return row;
            }
        }        
        
        //右键菜单命令----------------------------------------------------------------------------
        var PolygonVehs = new Array();
        function BindPolygonVehP(node)
        {
            PolygonVehs.length = 0;
            PolygonVehs = node;
            if(node.id[0] == 'X')
            {
            OpenInfoCmd("Htmls/Cmd/FormBindAreaVeh.aspx", 550, 455, "<% =Resources.Lan.FenceBindVehicle %>");
            }
            else
            {
                OpenInfoCmd("Htmls/Cmd/FormBindPolygonVeh.aspx", 550, 455, "<% =Resources.Lan.FenceBindVehicle %>");
            }
        }
        
        function GetCmdVeh()
        {
            var rows = $("#tgVeh").treegrid('getSelections');
            if(rows == undefined)
            {
                return;
            }
            var sContent = $('#openRoleDiv');
	        var iFrame = $(sContent).find("iframe");
	        window.frames[iFrame[0].name].SetCmdVeh(rows);
        }
        
        function PolygonSync()
        {
            var sSendContent = "[{'key':'3_1','ver':1,'rows':0,'cols':3,data:[{'terType':'','name':'PolygonSync','ip':''}]}]";
            ws.send(sSendContent);
        }
        
        function AreaSync()
        {
            var sSendContent = "[{'key':'3_1','ver':1,'rows':0,'cols':3,data:[{'terType':'','name':'AreaSync','ip':''}]}]";
            ws.send(sSendContent);
        }
        
        function CallName(owner, terType)
        {
            var sMenumName = "#vehMenuGb";
            if(terType == 1)
            {
                sMenumName = "#vehMenuEnterprice";
            }
            if ( !$(sMenumName).menu("getItem", $(owner)).disabled ) {
                var rows = $("#tgVeh").treegrid('getSelections');
                if(rows == undefined)
                {
                    return;
                }
                var dateSend = new Date(); 
                var sTime = formatDate(dateSend);// dateSend.getFullYear() + "-" + dateSend.getMonth() + "-" + dateSend.getDate() + " " + dateSend.getHours() + ":" + dateSend.getMinutes() + ":" + dateSend.getSeconds();
                for(var i = 0; i < rows.length; i++)
                {
                    var sCallName = "[{'key':'3_1','ver':1,'rows':0,'cols':3,data:[{'terType':" + terType + ",'name':'Calling','ip':'" + rows[i].ipaddress + "'}]}]";
                    ws.send(sCallName);
                    var arrInteractive = new Array();
                    var sGuid =  Guid.NewGuid();
                    var arrInteractive = { id: sGuid.ToString("N"),name:rows[i].name,time:sTime, interactive:"<% =Resources.Lan.RightCallName %>",content: "<% =Resources.Lan.RightCallName %>&nbsp;&nbsp;<% =Resources.Lan.SuccessfullySentToTheCenter %>"};
                    $('#tableInteractive').datagrid('insertRow',{
	                    index: 0,	
	                    row: arrInteractive
                    });
                }
            }
        }
        
        function HistoryTrack(mapType)
        {
            var rows = $("#tgVeh").treegrid('getSelections');
            if(rows == undefined)
            {
                return;
            }
            if(rows.length > 0)
            {
                if(mapType == 1)
                {
                    addTab('<% =Resources.Lan.BaiduMap  %><% =Resources.Lan.RightTrackPlayback  %>','Htmls/FormHistoryQuery.aspx?VehID=' + rows[0].id);
                }
                else if(mapType == 2)
                {
                    addTab('<% =Resources.Lan.GoogleMap  %><% =Resources.Lan.RightTrackPlayback  %>','Htmls/FormHistoryGoogleQuery.aspx?VehID=' + rows[0].id);
                }
            }
        }
        
        function TaskVideo(owner)
        {
            var sMenumName = "#vehMenuYJ";
            if ( !$(sMenumName).menu("getItem", $(owner)).disabled ) {   
                var rows = $("#tgVeh").treegrid('getSelections');
                if(rows == undefined)
                {
                    return;
                }
                if(rows.length > 0)
                {
                     OpenInfoCmd("Htmls/Cmd/YJ/FormYJVideoCmd.aspx", 490, 355, "<% =Resources.Lan.RealtimeVideoMonitoring %>");
//                    for(var i =0; i < rows.length; i++)
//                    {
//                        if(!$('#tabs').tabs('exists','<% =Resources.Lan.RealtimeVideoMonitoring %>【' + rows[i].name + "】")){
//                    	    
//	                    }else{
//	                        var sContent = $('#tabs').tabs('getTab',"<% =Resources.Lan.RealtimeVideoMonitoring %>【" + rows[i].name + "】").panel('options').content;
//	                        var iFrame = $(sContent).find("iframe");
//	                        window.frames[iFrame[0].name].TaskVideo();
//	                    }
//                        addTab('<% =Resources.Lan.RealtimeVideoMonitoring %>【' + rows[i].name + "】",'Htmls/Cmd/YJ/FormYJVideo.aspx?cid=' + rows[i].cid + '&vehid=' + rows[i].id.substring(1));
//                    }
                }
           }
        }
        
        function TaskPic(owner, terType)
        {
            var sMenumName = "#vehMenuGb";
            if(terType == 4)
            {
                sMenumName = "#vehMenuYJ";
            }
            if ( !$(sMenumName).menu("getItem", $(owner)).disabled ) {                
                var rows = $("#tgVeh").treegrid('getSelections');
                if(rows == undefined)
                {
                    return;
                }
                if(rows.length > 0)
                {
                    for(var i =0; i < rows.length; i++)
                    {
                        if(terType == 2)
                        {
                            addTab('<% =Resources.Lan.RightPhotograph %>【' + rows[i].name + "】",'Htmls/Cmd/GB/FormGBPhotoList.aspx?taxino=' + rows[i].taxino + '&vehid=' + rows[i].id.substring(1));
                        }
                        else if(terType == 4)
                        {
                            OpenInfoCmd("Htmls/Cmd/YJ/FormYJPhotoCmd.aspx", 490, 355, "<% =Resources.Lan.RightPhotograph %>");
                            break;
//                            if(!$('#tabs').tabs('exists','YJ<% =Resources.Lan.RightPhotograph %>【' + rows[i].name + "】")){
//                		        
//	                        }else{
//	                            var sContent = $('#tabs').tabs('getTab',"YJ<% =Resources.Lan.RightPhotograph %>【" + rows[i].name + "】").panel('options').content;
//	                            var iFrame = $(sContent).find("iframe");
//	                            window.frames[iFrame[0].name].TaskPhoto();
//	                        }
//                            addTab('YJ<% =Resources.Lan.RightPhotograph %>【' + rows[i].name + "】",'Htmls/Cmd/YJ/FormYJPhoto.aspx?cid=' + rows[i].cid + '&vehid=' + rows[i].id.substring(1));
                        }
                    }
                    if(terType == 2)
                    {
                        OpenInfoCmd("Htmls/Cmd/GB/FormGBPhoto.aspx", 450, 355, "<% =Resources.Lan.RightPhotograph %>");
                    }
                }
            }
        }
        
        function formatDate(d) {  
          var D=['00','01','02','03','04','05','06','07','08','09']  
          with (d || new Date) return [  
            [getFullYear(), D[getMonth()+1]||getMonth()+1, D[getDate()]||getDate()].join('-'),  
            [D[getHours()]||getHours(), D[getMinutes()]||getMinutes(), D[getSeconds()]||getSeconds()].join(':')  
          ].join(' ');  
        } 
        
        function AccOnSetting(owner, terType)
        {
            var sMenumName = "#vehMenuGb";
            if(terType == 1)
            {
                sMenumName = "#vehMenuEnterprice";
            }
            else if(terType == 5)
            {
                sMenumName = "#vehMenuK1";
            }
            if ( !$(sMenumName).menu("getItem", $(owner)).disabled ) {
                var rows = $("#tgVeh").treegrid('getSelections');
                if(rows == undefined)
                {
                    return;
                }
                if(terType == 5)
                {
                    OpenInfoCmd("Htmls/Cmd/K1/FormTimeComesBack.aspx", 450, 355, "<% =Resources.Lan.TimingTimeComesBack %>");
                    return;
                }
//                var sForm = '<iframe name="accFrame" scrolling="auto" frameborder="0"  src="Htmls/Cmd/Enterprise/FormAccOn.aspx" style="width:100%;height:100%;"></iframe>';
                OpenInfoCmd("Htmls/Cmd/Enterprise/FormAccOn.aspx", 450, 355, "<% =Resources.Lan.RightAccOnTimingInterval %>");
            }
        }
        
        function OilSetting(owner)
        {
            OpenInfoCmd("Htmls/Cmd/FormOilSetting.aspx", 450, 405, "<% =Resources.Lan.OilTestingParametersSetting %>");
        }
        
        function SchedulingCmdSetting(owner, terType)
        {
            var sMenumName = "#vehMenuGb";
            if(terType == 1)
            {
                sMenumName = "#vehMenuEnterprice";
            }
            else if(terType == 5)
            {
                sMenumName = "#vehMenuK1";
            }
            if ( !$(sMenumName).menu("getItem", $(owner)).disabled ) {
                var rows = $("#tgVeh").treegrid('getSelections');
                if(rows == undefined)
                {
                    return;
                }
                if(terType == 5)
                {
                    OpenInfoCmd("Htmls/Cmd/K1/FormSchedulingCmdSetting.aspx", 450, 355, "<% =Resources.Lan.SendSchedulingInformation %>");
                    return;
                }
//                var sForm = '<iframe name="accFrame" scrolling="auto" frameborder="0"  src="Htmls/Cmd/Enterprise/FormAccOn.aspx" style="width:100%;height:100%;"></iframe>';
                OpenInfoCmd("Htmls/Cmd/Enterprise/FormSchedulingCmdSetting.aspx", 450, 355, "<% =Resources.Lan.SendSchedulingInformation %>");
            }
        }
        
        function RestartSetting(owner, terType)
        {
            var sMenumName = "#vehMenuGb";
            if(terType == 1)
            {
                sMenumName = "#vehMenuEnterprice";
            }
            else if(terType == 5)
            {
                sMenumName = "#vehMenuK1";
            }
            if ( !$(sMenumName).menu("getItem", $(owner)).disabled ) {
                var rows = $("#tgVeh").treegrid('getSelections');
                if(rows == undefined)
                {
                    return;
                }
                SendCmdText("Restart","", terType, "<% =Resources.Lan.Restart %>", "<% =Resources.Lan.Restart %>")
            }
        }
        
        function AccOffSetting(owner, terType)
        {
            var sMenumName = "#vehMenuGb";
            if(terType == 1)
            {
                sMenumName = "#vehMenuEnterprice";
            }
            if ( !$(sMenumName).menu("getItem", $(owner)).disabled ) {
                var rows = $("#tgVeh").treegrid('getSelections');
                if(rows == undefined)
                {
                    return;
                }
//                var sForm = '<iframe name="accFrame" scrolling="auto" frameborder="0"  src="Htmls/Cmd/Enterprise/FormAccOn.aspx" style="width:100%;height:100%;"></iframe>';
                if(terType == 1)
                {
                    OpenInfoCmd("Htmls/Cmd/Enterprise/FormAccOff.aspx", 450, 355, "<% =Resources.Lan.RightAccOffTimingInterval %>");
                }
                else if(terType == 2)
                {
                  OpenInfoCmd("Htmls/Cmd/GB/FormGBAccOff.aspx", 450, 355, "<% =Resources.Lan.RightAccOffTimingInterval %>");
                }
            }
        }
        
        function OilOpenOrClose(owner, terType, iOpenOrClose)
        {
            var sMenumName = "#vehMenuGb";
            if(terType == 1)
            {
                sMenumName = "#vehMenuEnterprice";
            }
            if ( !$(sMenumName).menu("getItem", $(owner)).disabled ) {
                var rows = $("#tgVeh").treegrid('getSelections');
                if(rows == undefined)
                {
                    return;
                }
                var sCmd = "<% =Resources.Lan.OilCutOff %>";
                if(iOpenOrClose == "1")
                {
                    sCmd = "<% =Resources.Lan.OilOpen %>";
                }
                
//                var sForm = '<iframe name="accFrame" scrolling="auto" frameborder="0"  src="../Htmls/Cmd/Enterprise/FormAccOn.aspx" style="width:100%;height:100%;"></iframe>';
                SendCmdText("OilOpenOrClose",iOpenOrClose, terType, sCmd, sCmd)
            }
        }
        
        function OverSpeedSetting(owner, terType)
        {
            var sMenumName = "#vehMenuGb";
            if(terType == 1)
            {
                sMenumName = "#vehMenuEnterprice";
            }
            else if(terType == 4)
            {
                sMenumName = "#vehMenuYJ";
            }
            if ( !$(sMenumName).menu("getItem", $(owner)).disabled ) {
                var rows = $("#tgVeh").treegrid('getSelections');
                if(rows == undefined)
                {
                    return;
                }
//                var sForm = '<iframe name="accFrame" scrolling="auto" frameborder="0"  src="Htmls/Cmd/Enterprise/FormAccOn.aspx" style="width:100%;height:100%;"></iframe>';
                if(terType == 1)
                {
                    OpenInfoCmd("Htmls/Cmd/Enterprise/FormOverSpeedSet.aspx", 450, 355, "<% =Resources.Lan.OverSpeedSetting %>");
                }
                else if(terType == 2 || terType == 4)
                {
                  OpenInfoCmd("Htmls/Cmd/GB/FormGBOverSpeedSet.aspx", 450, 355, "<% =Resources.Lan.OverSpeedSetting %>");
                }
            }
        }
        
        function ShutdownSetting(owner, terType)
        {
            var dateSend = new Date(); 
            var sTime = formatDate(dateSend);
            var sMenumName = "#vehMenuYJ";
            if ( !$(sMenumName).menu("getItem", $(owner)).disabled ) {
                var rows = $("#tgVeh").treegrid('getSelections');
                if(rows == undefined)
                {
                    return;
                }
                for(var i = 0; i < rows.length; i++)
                {
                    var sGuid =  Guid.NewGuid();
                    var sSend = "[{'key':'3_1','ver':1,'rows':0,'cols':3,data:[{'terType':" + terType + ",'name':'YJShutdown','ip':'" + rows[i].ipaddress + "','Source':1}]}]";
                    ws.send(sSend);
                    var arrInteractive = new Array();
                    var arrInteractive = { id: sGuid.ToString("N"),name:rows[i].name,time:sTime, interactive:"<% =Resources.Lan.Shutdown %>",content: "<% =Resources.Lan.Shutdown %>" + "&nbsp;&nbsp;<% =Resources.Lan.SuccessfullySentToTheCenter %>"};
                    $('#tableInteractive').datagrid('insertRow',{
	                    index: 0,	
	                    row: arrInteractive
                    });
                }
           }
        }
        
        function NavigationVehRoad(owner)
        {
            var sMenumName = "#vehMenuYJ";
            if ( !$(sMenumName).menu("getItem", $(owner)).disabled ) {
                var rows = $("#tgVeh").treegrid('getSelections');
                if(rows == undefined)
                {
                    return;
                }
//                for(var i = 0; i < rows.length; i++)
//                {
//                    if(rows[i].id[0] == 'V')
//                    {
//                        SendNavigationRoad(rows[i].name, 22.333,114.232,"天天");
//                    }
//                }
                OpenInfoCmd("Htmls/Cmd/YJ/FormYJRoad.aspx", 620, 575, "<% =Resources.Lan.GpsNavigation %>");
            }
        }
        
        function SendNavigationRoad(sCph,dlat,dlng,sDestination)
        {
            try
            {
                $.ajax({
                    url: "Ashx/YjCmd.ashx",
                    cache:false,
                    type:"post",
                    dataType:'json',
                    async:false,//同步 
                    data:{lat:dlat,lng:dlng,des:sDestination,type:'road',cph:sCph},
                    success:function(data){
                            if(data.error == 0)
                            {
                                  ShowInfo("<% =Resources.Lan.Successful %>");
                            }
                            else
                            {
	                               ShowInfo(data.errormsg);
                            }
                    },
                    error: function(e) { 
	                     $("#divState").text(e.responseText);
                    } 
                }) ;    
            }
            catch(e)
            {
                
            }
        }
        
        function SendCmdText(sCmdType, sText, terType, sInteractive, sContent)
        {
            var dateSend = new Date(); 
            var sTime = formatDate(dateSend);
            var rows = $("#tgVeh").treegrid('getSelections');
            if(rows == undefined)
            {
                return;
            }
            for(var i = 0; i < rows.length; i++)
            {
                var sCallName = "[{'key':'3_1','ver':1,'rows':0,'cols':3,data:[{'terType':" + terType + ",'name':'" + sCmdType + "','ip':'" + rows[i].ipaddress + "','text':'" + sText + "'}]}]";
                ws.send(sCallName);
                var arrInteractive = new Array();
                var sGuid =  Guid.NewGuid();
                var arrInteractive = { id: sGuid.ToString("N"),name:rows[i].name,time:sTime, interactive:sInteractive,content: sContent + "&nbsp;&nbsp;<% =Resources.Lan.SuccessfullySentToTheCenter %>"};
                $('#tableInteractive').datagrid('insertRow',{
	                index: 0,	
	                row: arrInteractive
                });
            }
        }
        
        function SendCmdGbPhoto(sCmdType, iChannel, iResolution, iCmd, iSecond, sUpload, terType, sInteractive, sContent)
        {
            var dateSend = new Date(); 
            var sTime = formatDate(dateSend);
            var rows = $("#tgVeh").treegrid('getSelections');
            if(rows == undefined)
            {
                return;
            }
            for(var i = 0; i < rows.length; i++)
            {
                var sSend = "[{'key':'3_1','ver':1,'rows':0,'cols':3,data:[{'terType':" + terType + ",'name':'" + sCmdType + "','ip':'" + rows[i].ipaddress + "','Channel':" + iChannel + ",'Resolution':" + iResolution + ",'Cmd':" + iCmd + ",'Second':" + iSecond + ",'Upload':" + sUpload + "}]}]";
                ws.send(sSend);
                var arrInteractive = new Array();
                var sGuid =  Guid.NewGuid();
                var arrInteractive = { id: sGuid.ToString("N"),name:rows[i].name,time:sTime, interactive:sInteractive,content: sContent + "&nbsp;&nbsp;<% =Resources.Lan.SuccessfullySentToTheCenter %>"};
                $('#tableInteractive').datagrid('insertRow',{
	                index: 0,	
	                row: arrInteractive
                });
            }
        }
        
        var arrPhotoGuid = new Array();
        function SendCmdYJPhoto(sCmdType, iChannel, iResolution, iPhotoCount, iShootingInterval, iImageQuality, terType, sInteractive, sContent)
        {
            var dateSend = new Date(); 
            var sTime = formatDate(dateSend);
            var rows = $("#tgVeh").treegrid('getSelections');
            if(rows == undefined)
            {
                return;
            }
            for(var i = 0; i < rows.length; i++)
            {
                var sGuid =  Guid.NewGuid();
                var sSend = "[{'key':'3_1','ver':1,'rows':0,'cols':3,data:[{'terType':" + terType + ",'name':'" + sCmdType + "','ip':'" + rows[i].ipaddress + "','Channel':" + iChannel + ",'Resolution':" + iResolution + ",'PhotoCount':" + iPhotoCount + ",'ShootingInterval':" + iShootingInterval + ",'ImageQuality':" + iImageQuality + ",'Source':1,'Guid':'" + sGuid.ToString("N") + "'}]}]";
                ws.send(sSend);
                arrPhotoGuid.push(sGuid.ToString("N"));
                var arrInteractive = new Array();
                var arrInteractive = { id: sGuid.ToString("N"),name:rows[i].name,time:sTime, interactive:sInteractive,content: sContent + "&nbsp;&nbsp;<% =Resources.Lan.SuccessfullySentToTheCenter %>"};
                $('#tableInteractive').datagrid('insertRow',{
	                index: 0,	
	                row: arrInteractive
                });
            }
        }
        
        function SendCmdYJRoad(sCmdType, sLng1, sLat1, sPlace1, sLng2, sLat2, sPlace2, terType, sInteractive, sContent)
        {
            var dateSend = new Date(); 
            var sTime = formatDate(dateSend);
            var rows = $("#tgVeh").treegrid('getSelections');
            if(rows == undefined)
            {
                return;
            }
            for(var i = 0; i < rows.length; i++)
            {
                var sSend = "[{'key':'3_1','ver':1,'rows':0,'cols':3,data:[{'terType':" + terType + ",'name':'" + sCmdType + "','ip':'" + rows[i].ipaddress + "','Lng1':" + sLng1 + ",'Lat1':" + sLat1 + ",'Add1':'" + sPlace1 + "','Lng2':" + sLng2 + ",'Lat2':" + sLat2 + ",'Add2':'" + sPlace2 + "','Source':1}]}]";
                ws.send(sSend);
                var arrInteractive = new Array();
                var sGuid =  Guid.NewGuid();
                var arrInteractive = { id: sGuid.ToString("N"),name:rows[i].name,time:sTime, interactive:sInteractive,content: sContent + "&nbsp;&nbsp;<% =Resources.Lan.SuccessfullySentToTheCenter %>"};
                $('#tableInteractive').datagrid('insertRow',{
	                index: 0,	
	                row: arrInteractive
                });
            }
        }
        
        function TVideoUnSelect(scidTemp)
        {
            for(var j = 0; j < arrVideoCmd.length; j++)
            {
                if(arrVideoCmd[j].customid == scidTemp)
                {
                    arrVideoCmd.splice(j,1);
                }
            }
        }
        
        function TVideoTimeout(scidTemp)
        {
            for(var j = 0; j < arrVideoCmd.length; j++)
            {
                if(arrVideoCmd[j].customid == scidTemp)
                {
                    var row = arrVideoCmd[j].row ;
                    var sCmdType = arrVideoCmd[j].CmdType;
                    var iChannel = arrVideoCmd[j].Channel;
                    var iResolution = arrVideoCmd[j].Resolution;
                    var iUpload = arrVideoCmd[j].Upload;
                    var iShootingInterval = arrVideoCmd[j].ShootingInterval;
                    var iImageQuality = arrVideoCmd[j].ImageQuality;
                    var terType = arrVideoCmd[j].terType;
                    sInteractive = arrVideoCmd[j].Interactive;
                    sContent = arrVideoCmd[j].Content;
                    var dateSend = new Date(); 
                    var sTime = formatDate(dateSend);
                    var sSend = "[{'key':'3_1','ver':1,'rows':0,'cols':3,data:[{'terType':" + terType + ",'name':'" + sCmdType + "','ip':'" + row.ipaddress + "','Channel':" + iChannel + ",'Resolution':" + iResolution + ",'Upload':" + iUpload + ",'ShootingInterval':" + iShootingInterval + ",'ImageQuality':" + iImageQuality + ",'Source':1}]}]";
                    ws.send(sSend);
                    var arrInteractive = new Array();
                    var sGuid =  Guid.NewGuid();
                    var arrInteractive = { id: sGuid.ToString("N"),name:row.name,time:sTime, interactive:sInteractive,content: sContent + "&nbsp;&nbsp;<% =Resources.Lan.SuccessfullySentToTheCenter %>"};
                    $('#tableInteractive').datagrid('insertRow',{
	                    index: 0,	
	                    row: arrInteractive
                    });
                    break;
                }
            }
        }
        
        var arrVideoCmd = new Array();
        function SendCmdYJVideo(sCmdType, iChannel, iResolution, iUpload, iShootingInterval, iImageQuality, terType, sInteractive, sContent)
        {
            var dateSend = new Date(); 
            var sTime = formatDate(dateSend);
            var rows = $("#tgVeh").treegrid('getSelections');
            if(rows == undefined)
            {
                return;
            }
            for(var i = 0; i < rows.length; i++)
            {
                var bExists = false;
                for(var j = 0; j < arrVideoCmd.length; j++)
                {
                    if(arrVideoCmd[j].customid == rows[i].cid)
                    {
                        bExists = true;
                        arrVideoCmd[j].row = rows[i];
                        arrVideoCmd[j].CmdType = sCmdType;
                        arrVideoCmd[j].Channel = iChannel;
                        arrVideoCmd[j].Resolution = iResolution;
                        arrVideoCmd[j].Upload = iUpload;
                        arrVideoCmd[j].ShootingInterval = iShootingInterval;
                        arrVideoCmd[j].ImageQuality = iImageQuality;
                        arrVideoCmd[j].terType = terType;
                        arrVideoCmd[j].Interactive = sInteractive;
                        arrVideoCmd[j].Content = sContent;
                        break;
                    }
                }
                if(!bExists)
                {
                    arrVideoCmd.push({"customid":rows[i].cid,"row":rows[i],"CmdType":sCmdType,"Channel":iChannel,"Resolution":iResolution,"Upload":iUpload,"ShootingInterval":iShootingInterval,"ImageQuality":iImageQuality,"terType":terType,"Interactive":sInteractive,"Content":sContent});
                }
                var sSend = "[{'key':'3_1','ver':1,'rows':0,'cols':3,data:[{'terType':" + terType + ",'name':'" + sCmdType + "','ip':'" + rows[i].ipaddress + "','Channel':" + iChannel + ",'Resolution':" + iResolution + ",'Upload':" + iUpload + ",'ShootingInterval':" + iShootingInterval + ",'ImageQuality':" + iImageQuality + ",'Source':1}]}]";
                ws.send(sSend);
                var arrInteractive = new Array();
                var sGuid =  Guid.NewGuid();
                var arrInteractive = { id: sGuid.ToString("N"),name:rows[i].name,time:sTime, interactive:sInteractive,content: sContent + "&nbsp;&nbsp;<% =Resources.Lan.SuccessfullySentToTheCenter %>"};
                $('#tableInteractive').datagrid('insertRow',{
	                index: 0,	
	                row: arrInteractive
                });
            }
        }
        
        function CloseInfoCmd()
        {
            $('#openRoleDiv').window('close');
        }
        
        function OpenInfoCmd(url,thisWidth,thisHeight,thisTitle)
        {
//            $("#prodcutDetailSrc").attr("src","Htmls/Cmd/Enterprise/FormAccOn.aspx"); //设置IFRAME的SRC
//            $("#dlgCmd").dialog({
//                bgiframe: true,
//                resizable: true, //是否可以重置大小
//                height: 283, //高度
//                width: 626, //宽度
//                draggable: false, //是否可以拖动。
//                title: "公司产品编辑",
//                modal: true,
//                open: function (e) {  //打开的时候触发的事件    
//                    document.body.style.overflow = "hidden"; //隐藏滚动条
//                },
//                close: function () { //关闭Dialog时候触发的事件
//                    document.body.style.overflow = "visible";  //显示滚动条
//                    Test();
//                }
//            });
//                $('#openRoleDiv').dialog('open');
                
                $('#openRoleDiv').window({
                    width:thisWidth,
                    height:thisHeight,
                    title:thisTitle,
                    modal:true
                });
                $('#openRoleDiv').window('open').window('center');
              $('#openXXXIframe')[0].src= url;//'Htmls/Cmd/Enterprise/FormAccOn.aspx';
//            $("#dlgCmdInfo").height(400);
//            $("#dlgCmdInfo").width(450);
//            $("#dlgCmdInfo").html(info);
//            $('#dlgCmd2').dialog({
//                title: '<% =Resources.Lan.RightAccOnTimingInterval %>',
//                width: 450,
//                height: 400,
//                closed: false,
//                cache: false,
////                href: 'Htmls/Cmd/Enterprise/FormAccOn.aspx',
//                modal: true
//            }).dialog('center');
//            var rows = $("#tgVeh").treegrid('getSelections');
//            SetCmdVeh(rows);
//            $("#dlgCmd").height(300);
//            $("#dlgCmd").width(400);
//            $("#dlgCmd").dialog('open').dialog('center');
//            $("#dlgCmd").dialog('open').dialog('center');
        }
        
        function OpenInfoPhoto(info)
        {
            $("#dlgInfoPhoto").html("<p>" + info + "</p>");
            $("#dlgPhoto").dialog('open').dialog('center');
        }
        //----------------------------------------------------------------------------------------------------------
        function TabonSelect(title,index)
        {
            try
            {
                if(title == "<% =Resources.Lan.GoogleMap %>")
                {
                    if(bAutoCollapse)
                    {
                        bAutoCollapse = false;
                        ExpandGrid();
                    }
    //                setTimeout(SetSelectVehToMap,2000);
                        var sContent = $('#tabs').tabs('getTab',"<% =Resources.Lan.GoogleMap %>").panel('options').content;
	                    var iFrame = $(sContent).find("iframe");
	                    window.frames[iFrame[0].name].UpdateZoom();
                }
                else if(title == "<% =Resources.Lan.GoogleMap %><% =Resources.Lan.RightTrackPlayback  %>")
                {
                    if(false) //bAutoCollapse)
                    {
                        bAutoCollapse = false;
                        ExpandGrid();
                    }
                    else
                    {
                        CollapseGrid();
                    }
                }
                else if(title == "<% =Resources.Lan.BaiduMap %><% =Resources.Lan.RightTrackPlayback  %>")
                {
                    if(false) //bAutoCollapse)
                    {
                        bAutoCollapse = false;
                        ExpandGrid();
                    }
                    else
                    {
                        CollapseGrid();
                    }
                }
                else
                {
                    if(bAutoCollapse)
                    {
                        bAutoCollapse = false;
                        ExpandGrid();
                    }
                }
            }
            catch(e)
            {}
        }
        
        function GotoBackEnd()
        {
            var sName = GetCookie("username");
            var sPwd = GetCookie("pwd");
            sName = utf16to8(base64encode(sName));
            sPwd = utf16to8(base64encode(sPwd));
            window.open("mng/Login.aspx?k=0&rUser=" + sName + "&rPwd=" + sPwd);        
        }
        
        function GetUnit(title)
        {
            try
            {
                if(!$('#tabs').tabs('exists',title)){
    		        
	            }else{
	                var sContent = $('#tabs').tabs('getTab',title).panel('options').content;
	                var iFrame = $(sContent).find("iframe");
	                window.frames[iFrame[0].name].GetUnit(title);
   
	            }
	        }
	        catch(e)
	        {}
        }
        
        function SetUnit(title,arrUnit)
        {
            var sContent = $('#openRoleDiv');
	        var iFrame = $(sContent).find("iframe");
	        window.frames[iFrame[0].name].InitUnit(arrUnit);
        }
        
        function SetFindUnit(sTitle, sRegion, sUnit, rowSelect,bShow)
        {
            try
            {
                if(!$('#tabs').tabs('exists',sTitle)){
    		        
	            }else{                    
	                var sContent = $('#tabs').tabs('getTab',sTitle).panel('options').content;
	                var iFrame = $(sContent).find("iframe");
	                window.frames[iFrame[0].name].SetFind(sRegion, sUnit, rowSelect,bShow);
                }
	        }
	        catch(e)
	        {}
        }
        
        function OpenUnit(title)
        {
             OpenInfoCmd("Htmls/FormNanJingUnit.aspx?t=" + title, 620, 440, "选择单位");
        }
        
        function clickTest()
        {
            $('#tabNavigation').find('.datagrid-header-row').find('.datagrid-sort').click();
        }
    </script>
</head>
<body oncontextmenu="return false" id="bodyLayout" class="easyui-layout" style="overflow-y: hidden; scroll:no" onkeydown="javascript:keyPress(event);" onkeyup="javascript:keyRelease(event);">
    <noscript>
    <div style=" position:absolute; z-index:100000; height:2046px;top:0px;left:0px; width:100%; background:white; text-align:center;">
        <img src="Img/noscript.gif" alt='<% =Resources.Lan.ScriptSupport %>' />
    </div>
    </noscript>
    <%--顶层--%>
    <div region="north" split="true" border="false" style="overflow: hidden; height: 30px;
        background: url(Img/layout-browser-hd-bg.gif) #7f99be repeat-x center 50%;
        line-height: 20px;color: #fff; font-family: Verdana, 微软雅黑,黑体">
        <span style="float:right; padding-right:20px;" class="head">
        <a id="aback" href="javascript:GotoBackEnd();"><% =Resources.Lan.BackEnd %></a>
        <% =Resources.Lan.User %> <% = sUserName%><%--<span style="color:#E0ECFF; font-weight:bold "> /</span>--%> <%--<a href="#;" id="editpass">修改密码</a> <span style="color:#E0ECFF; font-weight:bold "> / </span>--%><a href="javascript:JsExit();" id="loginOut"><%--<% =Resources.Lan.Exit  %>--%></a></span>
        <span style="padding-left:10px; font-size: 16px; "><img src="Img/blocks.gif" width="20" height="20" align="absmiddle" /> <% =Resources.Lan.Title %></span>
	    <form id="formcs" runat="server">
	        <div style="display:none">
                <asp:Button ID="btnClearSessionCS" Height="0" Width="0" runat="server" Text="" OnClick="btnClearSessionCS_Click" />
            </div>
        </form>
    </div>
    <%--底部--%>
    <div region="south" split="true" style="height: 30px; background: #D2E0F2; ">
        <div id="divState" style="float:left; color: red;line-height: 23px;font-weight: bold;"></div><%--color: #15428B;--%>
        <div class="footer" style="position:absolute; left:0; width:100%">©2016</div>
    </div>
    <%--导航菜单--%>
     <div region="east" split="true" title="<% =Resources.Lan.TerminalToolbar  %>" style="width:255px;" id="east">
        <div id="tabNavigation" class="easyui-tabs" data-options="onSelect:VehonSelect" tabPosition="bottom" fit="true" border="false" >
		      <%--<input type="button" id="btn" value="222" onclick="clickTest();" />--%>
		      <div title="<% =Resources.Lan.VehList %>" style="overflow:auto; height:100%"><%--style="overflow:hidden;"--%>
			            <table id="tgVeh" class="easyui-treegrid" style="height:100%"
			                data-options="
				                <%--url: 'treegrid_data1.json',--%>
				                method: 'get',
				                lines: false,
				                rownumbers: false,
				                idField: 'id',
				                treeField: 'name',
				                remoteSort:false,
				                singleSelect: true,
				                onBeforeExpand :treeonBeforeLoad,
				                onClickRow:treeonClickRow,
				                onDblClickRow:treeonDblClickRow,
				                onContextMenu: onVehMenu,
				                onSortColumn:CphSortColumn
			                ">
		                <thead>
			                <tr>
				                <th data-options="field:'name',sortable:true,sorter:CphFormat" formatter="formatVehcheckbox" width="220px"><% =Resources.Lan.TeamOrPlate%></th>
				                <th data-options="field:'sim',hidden:true" width="90"><% =Resources.Lan.Sim %></th>
				                <th data-options="field:'taxino',hidden:true" width="100"><% =Resources.Lan.TaxiNo %></th>
				                <th data-options="field:'ipaddress',hidden:true" width="94"><% =Resources.Lan.IpAddress %></th>
				                <th data-options="field:'cphstate',hidden:true,sortable:true,sorter:CphFormat" formatter="formatCphState" width="70">状态</th>
				                <th data-options="field:'ownername'" width="90"><% =Resources.Lan.OwnerName %></th>
				                <th data-options="field:'contact3'" width="90"><% =Resources.Lan.Contact3 %></th>
				                <th data-options="field:'seller'" width="90"><% =Resources.Lan.VehWorkUnit %></th>
			                </tr>
		                </thead>
	                </table>
		            </div>
		      
		      <div id="divVehDetail" title="<% =Resources.Lan.VehDetail %>" style=" height:100%; overflow:hidden; "><%--showHeader:false,--%>
		            <div style="overflow:hidden; width:260px; height:100%">
		                <div style="overflow-x: hidden;overflow-y: scroll; height:100%; width:275px">
		                <table id="tableVehDetail" class="easyui-datagrid" style="width:100%; height:auto;  " data-options="showHeader:false,striped:true,nowrap:false,singleSelect:true,collapsible:true">
		                        <thead>
			                        <tr>
				                        <th data-options="field:'name',width:115,align:'left'" >name</th>
				                        <th data-options="field:'value',align:'left',width:130" >value</th>
				                        </tr>
		                        </thead>
	                        </table>
	                    </div>
	                </div>
		      </div>
		 </div>    
     </div>
     <%--内容--%>
     <div id="mainPanle" region="center" style="background: #eee; overflow-y:hidden">
        <div class="easyui-layout" id="CenterLayout" style="width:100%;height:100%;">
           <%-- <div region="north" border="false" style="overflow: hidden; height: 30px;
            line-height: 20px;color: #fff; font-family: Verdana, 微软雅黑,黑体">
                <span class="admin-bread">
                    <a href="#;" class="easyui-menubutton" data-options="menu:'#mainBase',iconCls:'icon-home'"><% =Resources.Lan.BasicFunction%></a>
		            <a href="#;" class="easyui-menubutton" data-options="menu:'#mainmm2',iconCls:'icon-help'">Help</a>
    		        
                </span>
            </div>--%>
		    <%--内容底部--%>
            <div region="south" split="true" title="<% =Resources.Lan.Information %>" id="dataSouth" style="height: 200px; background: #D2E0F2; ">
                <div id="divDataInformation" tabPosition="bottom" class="easyui-tabs"  fit="true" border="false" >
                    <div title="<% =Resources.Lan.RealtimeInformation %>">
		                <table id="tableRealTime" class="easyui-datagrid" style="height:100%" data-options="idField:'id',singleSelect:true,collapsible:true,remoteSort:false,multiSort:true,onRowContextMenu: onVehGridMenu,onHeaderContextMenu: onVehGridMenu, onDblClickRow: onVehDblClickRow">
		                <thead data-options="frozen:true">
			                <tr>
				                <th data-options="field:'id',width:50,hidden:true,halign:'center',frozen:true" >ID</th>
				                <th data-options="field:'name',formatter: GotoPlaceFormater,width:100,align:'left',halign:'center',sortable:true,order:'asc',frozen:true "><% =Resources.Lan.Plate %></th>
				                <th data-options="field:'sim',width:85,align:'left',halign:'center',frozen:true"><% =Resources.Lan.Sim %></th><%--,align:'right'--%>
				                <th data-options="field:'team',width:80,align:'left',halign:'center',sortable:true,order:'asc',frozen:true"><% =Resources.Lan.Team %></th>
				                <th data-options="field:'taxino',width:80,align:'left',halign:'center'"><% =Resources.Lan.TaxiNo %></th>
				                <th data-options="field:'ipaddress',width:60,align:'left',halign:'center',hidden:true"><% =Resources.Lan.IpAddress %></th>
				                </tr>
		                </thead>
		                <thead>
			                <tr>				                
				                <th data-options="field:'time',width:130,align:'left',halign:'center'"><% =Resources.Lan.DataTime %></th>
				                <th data-options="field:'speedangle',width:140,align:'left',halign:'center'"><% =Resources.Lan.SpeedAngle %></th>
				                <th data-options="field:'positionstatus',formatter: InfoFormater,width:150,align:'left',halign:'center'"><% =Resources.Lan.PositionStatus %></th>
				                <th data-options="field:'unitstatus',formatter: InfoFormater,width:200,align:'left',halign:'center'"><% =Resources.Lan.UnitStatus %></th>
				                <th data-options="field:'mileage',width:80,align:'left',halign:'center'"><% =Resources.Lan.Mileage %></th>
				                <th data-options="field:'fuelscale',width:70,align:'left',halign:'center'"><% =Resources.Lan.FuelScale %></th>
				                <th data-options="field:'fuel',width:70,align:'left',halign:'center'"><% =Resources.Lan.Fuel %></th>
				                <%--<th data-options="field:'alarmcount',width:80,align:'left',halign:'center'"><% =Resources.Lan.AlarmCount%></th>--%>
				                <th data-options="field:'address',formatter: PlaceFormaterInfo,width:200,align:'left',halign:'center'"><% =Resources.Lan.Address %></th>
			                    <th data-options="field:'nono',width:10,align:'left',halign:'center'"></th>
			                </tr>
		                </thead>
	                </table>
		            </div>
		            <div title="<% =Resources.Lan.AlarmInformation %>">
		                <table id="tableAlarm" class="easyui-datagrid" style="height:100%" data-options="idField:'id',singleSelect:true,collapsible:true,onRowContextMenu: onAlarmGridMenu,onHeaderContextMenu: onAlarmGridMenu, onDblClickRow: onVehDblClickRow">
		                    <thead>
			                    <tr>
				                    <th data-options="field:'id',width:50,hidden:true,halign:'center'" >ID</th>
				                    <th data-options="field:'name',width:100,align:'left',halign:'center' "><% =Resources.Lan.Plate %></th>
				                    <th data-options="field:'team',width:80,align:'left',halign:'center'"><% =Resources.Lan.Team %></th>
				                    <th data-options="field:'time',width:130,align:'left',halign:'center'"><% =Resources.Lan.AlarmTime %></th>
				                    <th data-options="field:'alarmcount',width:80,align:'left',halign:'center'"><% =Resources.Lan.AlarmCount %></th>
				                    <th data-options="field:'alarmtype',formatter: InfoFormater,width:200,align:'left',halign:'center'"><% =Resources.Lan.AlarmType %></th>
				                    <th data-options="field:'speedangle',width:140,align:'left',halign:'center'"><% =Resources.Lan.Speed %></th>
				                    <th data-options="field:'address',formatter: PlaceFormaterAlarm,width:200,align:'left',halign:'center'"><% =Resources.Lan.AlarmAddress %></th>
				                    <th data-options="field:'lat',formatter: LatLngFormater,width:80,align:'left',halign:'center'"><% =Resources.Lan.Lat %></th>
				                    <th data-options="field:'lng',formatter: LatLngFormater,width:80,align:'left',halign:'center'"><% =Resources.Lan.Lng %></th>
				                    <th data-options="field:'nono',width:10,align:'left',halign:'center'"></th>
				                 </tr>
		                    </thead>
	                    </table>
		            </div>
		            <div title="<% =Resources.Lan.InteractiveContent %>">
		                <table id="tableInteractive" class="easyui-datagrid" style="height:100%" data-options="idField:'id',singleSelect:true,collapsible:true,onRowContextMenu: onInteractiveGridMenu,onHeaderContextMenu: onInteractiveGridMenu">
		                    <thead>
			                    <tr>
				                    <th data-options="field:'id',width:50,hidden:true,halign:'center'" >ID</th>
				                    <th data-options="field:'name',width:100,align:'left',halign:'center' "><% =Resources.Lan.Plate %></th>
				                    <th data-options="field:'time',width:125,align:'left',halign:'center'"><% =Resources.Lan.ReceiveSendTime %></th>
				                    <th data-options="field:'interactive',width:120,align:'left',halign:'center'"><% =Resources.Lan.Interactive %></th>
				                    <th data-options="field:'content',width:500,align:'left',halign:'left'"><% =Resources.Lan.Content %></th>
				                 </tr>
		                    </thead>
	                    </table>
		            </div>
                </div>
            </div>
            <%-- 内容中间--%>
            <div id="divDataCenter" region="center" style="background: #eee; overflow-y:hidden">
                <div id="tabs" class="easyui-tabs"  data-options="tools:'#tab-tools',onSelect:TabonSelect" fit="true" border="false" >
		          <%--  <div title="<% =Resources.Lan.BaiduMap  %>" style="overflow:hidden;" id="home">
			            <iframe name="mainFrame" scrolling="auto" frameborder="0"  src="Htmls/FormBaiduMap.aspx" style="width:100%;height:100%;"></iframe>';
            	        
		            </div>--%>
		        </div>
		    </div>
		</div>
     </div>
    <div id="tab-tools">
		<a href="#;" class="easyui-menubutton" data-options="menu:'#mainBase',iconCls:'icon-home'"><% =Resources.Lan.BasicFunction%></a>
		            <a href="#;" class="easyui-menubutton" data-options="menu:'#mainmm2',iconCls:'icon-help'"><% =Resources.Lan.Help %></a>
    		        
	</div>
	
	<div id="tab-tools2">
		<a href="#;" class="easyui-menubutton" data-options="iconCls:'icon-help'">Help</a>
    		        
	</div>
    
    <div id="mm" class="easyui-menu" style="width:150px;">
		<div id="mm-tabclose"><% =Resources.Lan.Close %></div>
		<div id="mm-tabcloseall"><% =Resources.Lan.CloseAll %></div>
		<div id="mm-tabcloseother"><% =Resources.Lan.ClosedAllButThis %></div>
		<div class="menu-sep"></div>
		<div id="mm-tabcloseright"><% =Resources.Lan.ClosedRightSide %></div>
		<div id="mm-tabcloseleft"><% =Resources.Lan.ClosedLeftSide %></div>
		<div class="menu-sep"></div>
		<div id="mm-exit"><% =Resources.Lan.Exit %></div>
	</div>	
	
	<div id="mainBase" style="width:150px;">
		<div data-options="iconCls:'icon-map'">
			<span><% =Resources.Lan.Maps %></span>
			<div>
				<div onclick="addTab('<% =Resources.Lan.BaiduMap  %>','Htmls/FormBaiduMap.aspx')" data-options="iconCls:'icon-baidu'"><% =Resources.Lan.BaiduMap %></div>
				<div onclick="addTab('<% =Resources.Lan.GoogleMap  %>','Htmls/FormGoogleMap.aspx')" data-options="iconCls:'icon-googlemap'"><% =Resources.Lan.GoogleMap %></div>
				<%--<div class="menu-sep"></div>
				<div>New Toolbar...</div>--%>
			</div>
		</div>
		<div data-options="iconCls:'icon-map'" id="menu5006">
			<span><% =Resources.Lan.RightTrackPlayback %></span>
			<div>
				<div onclick="addTab('<% =Resources.Lan.BaiduMap  %><% =Resources.Lan.RightTrackPlayback %>','Htmls/FormHistoryQuery.aspx')" data-options="iconCls:'icon-baidu'"><% =Resources.Lan.BaiduMap %></div>
				<div onclick="addTab('<% =Resources.Lan.GoogleMap  %><% =Resources.Lan.RightTrackPlayback %>','Htmls/FormHistoryGoogleQuery.aspx')" data-options="iconCls:'icon-googlemap'"><% =Resources.Lan.GoogleMap %></div>
			</div>
		</div>
		<div data-options="iconCls:'icon-report'" id="reportAll">
			<span><% =Resources.Lan.ReportFunction %></span>
			<div>
				<div id="menu1308" onclick="addTab('<% =Resources.Lan.ImageReport  %>','Htmls/Reports/FormImageReportQuery.aspx')" data-options="iconCls:'icon-photo'"><% =Resources.Lan.ImageReport %></div>
				<div id="menu1312" onclick="addTab('<% =Resources.Lan.MileageReport  %>','Htmls/Reports/FormMileReportQuery.aspx')" data-options="iconCls:'icon-mile'"><% =Resources.Lan.MileageReport %></div>
				<div onclick="addTab('<% =Resources.Lan.VehFenceScheduleTimeReport  %>','Htmls/Reports/FormNotInPolygonQuery.aspx')" data-options="iconCls:'icon-polygon'"><% =Resources.Lan.VehFenceScheduleTimeReport %></div>
				<div id="menu1307" onclick="addTab('<% =Resources.Lan.ReportSpeedSift  %>','Htmls/Reports/FormSpeedSiftReportQuery.aspx')" data-options="iconCls:'icon-speed'"><% =Resources.Lan.ReportSpeedSift %></div>
				<div id="menu1302" onclick="addTab('<% =Resources.Lan.ReportAcc %>','Htmls/Reports/FormAccReportQuery.aspx')" data-options="iconCls:'icon-acc'"><% =Resources.Lan.ReportAcc %></div>
				<div id="menu1303" onclick="addTab('<% =Resources.Lan.ReportAlarm %>','Htmls/Reports/FormAlarmReportQuery.aspx')" data-options="iconCls:'icon-alarm'"><% =Resources.Lan.ReportAlarm %></div>
				<div id="menuVehInfor" onclick="addTab('<% =Resources.Lan.VehicleInformation %>','Htmls/Reports/FormVehicleInfoReportQuery.aspx')" data-options="iconCls:'icon-online'"><% =Resources.Lan.VehicleInformation %></div>
		        <div id="menu1324" data-options="iconCls:'icon-electric'">
			        <span><% =Resources.Lan.ElectrombileReport %></span>
			        <div>
				        <div id="menuEleReport" onclick="addTab('<% =Resources.Lan.VehicleData  %>','Htmls/Reports/Energy/FormVehicleDataReportQuery.aspx')" data-options="iconCls:'icon-electriccar'"><% =Resources.Lan.VehicleData %></div>
			            <div id="menuEngineReport" onclick="addTab('发动机信息','Htmls/Reports/Energy/FormEngineReportQuery.aspx')" data-options="iconCls:'icon-engine'">发动机信息</div>
			            <div id="menuMaxMinReport" onclick="addTab('极值数据','Htmls/Reports/Energy/FormMaxMinReportQuery.aspx')" data-options="iconCls:'icon-maxmin'">极值数据</div>
			         </div>
		        </div>
			</div>
		</div>
		<div id="divFence14" data-options="iconCls:'icon-polygon'">
			<span><% =Resources.Lan.LocationManager %></span>
			<div>
				<div id="divFence1418" onclick="addTab('<% =Resources.Lan.FenceRegionManage  %>','Htmls/FormFenceRegion.aspx')" data-options="iconCls:'icon-polygon'"><% =Resources.Lan.FenceRegionManage %></div>
			</div>
		</div>
	</div>
	<div id="mainmm2" style="width:100px;">
		<div><% =Resources.Lan.Welcome %>&nbsp;&nbsp;<% =Resources.Lan.Visit%></div>
	</div>
	<div id="vehMenuGb" class="easyui-menu unselectable" >
		<div id="G20" data-options="iconCls:'icon-control'"><span><% =Resources.Lan.RightTerminalControl%></span>
		    <div>
		        <div id="G1601" onclick="CallName(this,2);" data-options="iconCls:'icon-language'"><% =Resources.Lan.RightCallName%></div>
		        <div id="G1602" onclick="TaskPic(this,2)" data-options="iconCls:'icon-photo'"><% =Resources.Lan.RightPhotograph%></div>
		    </div>
		</div>
		<div id="G2" data-options="iconCls:'icon-setting'"><span><% =Resources.Lan.RightTerminalSettings%></span>
		    <div>
		        <div id="G201" onclick="AccOnSetting(this,2);" data-options="iconCls:'icon-time'"><% =Resources.Lan.RightAccOnTimingInterval %></div>
		        <div id="G202" onclick="AccOffSetting(this,2);" data-options="iconCls:'icon-time'"><% =Resources.Lan.RightAccOffTimingInterval %></div>
		        <div id="G204" onclick="OverSpeedSetting(this,2);" data-options="iconCls:'icon-speed'"><% =Resources.Lan.OverSpeedSetting %></div>
		        <div id="G2002" onclick="OilOpenOrClose(this,2,'0');" data-options="iconCls:'icon-text'"><% =Resources.Lan.OilCutOff %></div>
		        <div id="G2003" onclick="OilOpenOrClose(this,2,'1');" data-options="iconCls:'icon-text'"><% =Resources.Lan.OilOpen %></div>
		    </div>
		</div>
		<div id="G53" data-options="iconCls:'icon-online'"><span><% =Resources.Lan.RightVehicleInformationCommand %></span>
		    <div>
		        <div id="G5006"  data-options="iconCls:'icon-LineRoad1'"><span><% =Resources.Lan.RightTrackPlayback %></span> 
		            <div>
		                <div onclick="HistoryTrack(1);" data-options="iconCls:'icon-LineRoad1'"><% =Resources.Lan.BaiduMap %></div>
		                <div onclick="HistoryTrack(2);" data-options="iconCls:'icon-LineRoad1'"><% =Resources.Lan.GoogleMap %></div>
		            </div>
		        </div>
		        <div id="G5005" onclick="OilSetting(this);" data-options="iconCls:'icon-oil'"><% =Resources.Lan.OilTestingParametersSetting %></div>
		    </div>
		</div>
	</div>
	<div id="vehMenuYJ" class="easyui-menu" >
		<div id="Y20" data-options="iconCls:'icon-control'"><span><% =Resources.Lan.RightTerminalControl %></span>
		    <div >
		        <div onclick="NavigationVehRoad(this);" data-options="iconCls:'icon-LineRoad1'"><% =Resources.Lan.GpsNavigation %></div>
		        <div id="Y1602" onclick="TaskPic(this,4)" data-options="iconCls:'icon-photo'"><% =Resources.Lan.RightPhotograph %></div>
		        <div id="Y65" onclick="TaskVideo(this);" data-options="iconCls:'icon-video'"><% =Resources.Lan.RealtimeVideoMonitoring %></div>
		        <div id="Y204" onclick="OverSpeedSetting(this,4);" data-options="iconCls:'icon-speed'"><% =Resources.Lan.OverSpeedSetting %></div>
		        <div id="Y2006" onclick="ShutdownSetting(this,4);" data-options="iconCls:'icon-acc'"><% =Resources.Lan.Shutdown %></div>
		    </div>
		</div>
		<div id="Y53" data-options="iconCls:'icon-online'"><span><% =Resources.Lan.RightVehicleInformationCommand %></span>
		    <div>
		        <div id="Y5006"  data-options="iconCls:'icon-LineRoad1'"><span><% =Resources.Lan.RightTrackPlayback %></span> 
		            <div>
		                <div onclick="HistoryTrack(1);" data-options="iconCls:'icon-LineRoad1'"><% =Resources.Lan.BaiduMap %></div>
		                <div onclick="HistoryTrack(2);" data-options="iconCls:'icon-LineRoad1'"><% =Resources.Lan.GoogleMap %></div>
		            </div>
		        </div>
		    </div>
		</div>
	</div>
	<div id="vehMenuEnterprice" class="easyui-menu" >
		<div id="E4" data-options="iconCls:'icon-control'"><% =Resources.Lan.RigthTerminalControlInstruction %>
		    <div>
		        <div id="E5001" onclick="CallName(this,1);" data-options="iconCls:'icon-language'"><% =Resources.Lan.RightCallName%></div>
		        <%--<div id="E5002" data-options="iconCls:'icon-photo'"><% =Resources.Lan.RightPhotograph%></div>--%>
		    </div>
		</div>
		<div id="E2" data-options="iconCls:'icon-setting'"><% =Resources.Lan.RightTerminalSettings%>
		    <div>
		        <div id="E201" onclick="AccOnSetting(this,1);" data-options="iconCls:'icon-time'"><% =Resources.Lan.RightAccOnTimingInterval%></div>
		        <div id="E202" onclick="AccOffSetting(this,1);" data-options="iconCls:'icon-time'"><% =Resources.Lan.RightAccOffTimingInterval%></div>
		        <div id="E204" onclick="OverSpeedSetting(this,1);" data-options="iconCls:'icon-speed'"><% =Resources.Lan.OverSpeedSetting %></div>
		        <div id="E5004" onclick="SchedulingCmdSetting(this,1);" data-options="iconCls:'icon-text'"><% =Resources.Lan.SendSchedulingInformation %></div>
		        <div id="E2002" onclick="OilOpenOrClose(this,1,'0');" data-options="iconCls:'icon-text'"><% =Resources.Lan.OilCutOff %></div>
		        <div id="E2003" onclick="OilOpenOrClose(this,1,'1');" data-options="iconCls:'icon-text'"><% =Resources.Lan.OilOpen %></div>
		        
		    </div>
		</div>
		<div id="E53" data-options="iconCls:'icon-online'"><span><% =Resources.Lan.RightVehicleInformationCommand %></span>
		    <div>
		        <div id="E5006"  data-options="iconCls:'icon-LineRoad1'"><span><% =Resources.Lan.RightTrackPlayback %></span> 
		            <div>
		                <div onclick="HistoryTrack(1);" data-options="iconCls:'icon-LineRoad1'"><% =Resources.Lan.BaiduMap %></div>
		                <div onclick="HistoryTrack(2);" data-options="iconCls:'icon-LineRoad1'"><% =Resources.Lan.GoogleMap %></div>
		            </div>
		        </div>
		        <div id="E5005" onclick="OilSetting(this);" data-options="iconCls:'icon-oil'"><% =Resources.Lan.OilTestingParametersSetting %></div>
		    </div>
		</div>
	</div>
	<div id="vehMenuK1" class="easyui-menu" >
		<div id="K2" data-options="iconCls:'icon-setting'"><% =Resources.Lan.RightTerminalSettings%>
		    <div>
		        <div id="K201" onclick="AccOnSetting(this,5);" data-options="iconCls:'icon-time'"><% =Resources.Lan.TimingTimeComesBack %></div>
		        <div id="K5004" onclick="SchedulingCmdSetting(this,5);" data-options="iconCls:'icon-text'"><% =Resources.Lan.SendSchedulingInformation %></div>
		        <div id="K406" onclick="RestartSetting(this,5);" data-options="iconCls:'icon-restart'"><% =Resources.Lan.Restart %></div>
		    </div>
		</div>
		<div id="K53" data-options="iconCls:'icon-online'"><span><% =Resources.Lan.RightVehicleInformationCommand %></span>
		    <div>
		        <div id="K5006"  data-options="iconCls:'icon-LineRoad1'"><span><% =Resources.Lan.RightTrackPlayback %></span> 
		            <div>
		                <div onclick="HistoryTrack(1);" data-options="iconCls:'icon-LineRoad1'"><% =Resources.Lan.BaiduMap %></div>
		                <div onclick="HistoryTrack(2);" data-options="iconCls:'icon-LineRoad1'"><% =Resources.Lan.GoogleMap %></div>
		            </div>
		        </div>
		    </div>
		</div>
	</div>
	<div id="divVehGrid" class="easyui-menu"  style="width:120px;">
		<div data-options="iconCls:'icon-clear'" onclick="ClearVehGrid();"><% =Resources.Lan.Clear %></div>
    </div>
	<div id="divAlarmGrid" class="easyui-menu"  style="width:120px;">
		<div data-options="iconCls:'icon-clear'" onclick="ClearAlarmGrid();"><% =Resources.Lan.Clear %></div>
    </div>
	<div id="divInteractiveGrid" class="easyui-menu"  style="width:120px;">
		<div data-options="iconCls:'icon-clear'" onclick="ClearInteractiveGrid();"><% =Resources.Lan.Clear %></div>
    </div>
    <div id="dlgCmd2" class="easyui-dialog" style="padding:0px;" data-options="inline:true,modal:true,closed:true,title:'<% =Resources.Lan.Prompt %>'">
		<div id="dlgCmdInfo">This is a message dialog.</div>
		<div class="dialog-button">
			<a href="javascript:void(0)" class="easyui-linkbutton" style="width:100%;height:35px" onclick="$('#dlgCmd').dialog('close')"><% =Resources.Lan.Confirm %></a>
		</div>
	</div>
    <div style="display:none;overflow:hidden;padding:3px; " id="dlgCmd">
        <iframe frameborder="no" border="0" marginwidth="0" marginheight="0" id="prodcutDetailSrc"  scrolling="no"  width="100%" height="100%"></iframe>
    </div>
    <div id="openRoleDiv" class="easyui-window" style="padding:0px; overflow:hidden" closed="true" modal="true" title="标题" >
        <iframe scrolling="no" id='openXXXIframe' name="openXXXIframe" frameborder="0"  src="" style="width:100%;height:100%; padding:0px"></iframe>
    </div>    
    <div id="dlgPhoto" class="easyui-dialog" style="padding:20px 6px;width:850px; height:550px;" data-options="inline:true,modal:true,closed:true,title:'<% =Resources.Lan.Prompt %>'">
		<div id="dlgInfoPhoto">This is a message dialog.</div>
		
	</div>
</body>
</html>
