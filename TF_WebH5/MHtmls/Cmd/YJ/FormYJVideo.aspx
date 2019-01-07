<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FormYJVideo.aspx.cs" Inherits="MHtmls_Cmd_YJ_FormYJVideo" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title><% =Resources.Lan.RealtimeVideoMonitoring %></title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="../../../Css/index.css" rel="stylesheet" type="text/css" />
	<link rel="stylesheet" type="text/css" href="../../../EasyUI/themes/metro/easyui.css" />    <link rel="stylesheet" type="text/css" href="../../../EasyUI/themes/mobile.css" />
    <link rel="stylesheet" type="text/css" href="../../../EasyUI/themes/color.css" />
    <link rel="stylesheet" type="text/css" href="../../../EasyUI/themes/icon.css" />  
    <script type="text/javascript" src="../../../EasyUI/jquery.min.js"></script>  
    <script type="text/javascript" src="../../../EasyUI/jquery.easyui.min.js"></script> 
    <script type="text/javascript" src="../../../EasyUI/jquery.easyui.mobile.js"></script>
    <script type="text/javascript" src="../../../Js/GenerageGuid.js"></script> 
    <script type="text/javascript" src="../../../Js/JsCookies.js"></script>      <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=l4zKPgF3ihF8lciY2QGmpsvW"></script><!--C9f93589d92e645b1a9a4cf2fb53caa4-->
	<script type="text/javascript" src="../../../Js/Baidu/BaiduMapWrapper.js"></script> 
	<script type="text/javascript" src="../../../Js/Baidu/BaiduConvertor.js"></script>
	<script type="text/javascript" src="../../../Js/Baidu/BaiduDrawingManager.js"></script>
    <script type="text/javascript" src="../../../Js/Baidu/LineOverlay.js"></script>
    <script type="text/javascript" src="../../../Js/Baidu/BaiduLatLngCorrect.js"></script> 

    <script type="text/javascript">
        var iTry = 0;
        var IsClose = false;
        $(document).ready(function() { 
//            GetLastTime();
//            TaskVideo();
                var Request = GetRequest();
                $.messager.show({
				    title:'<% =Resources.Lan.Tip %>',
				    msg:'单击右上角图标停止播放视频！',
				    showType:'slide',
				    style:{
					    right:'',
					    top:document.body.scrollTop+document.documentElement.scrollTop,
					    bottom:''
				    }
			    });
                IsClose = false;
                var sGuid = Request["guid"];
                GetSrc(sGuid);
        });
        
        function TaskVideo()
        {
            try
            {
                iTry = 0;
                var Request = GetRequest();
                var sCid = Request["cid"];
                if(sCid.length == 0)
                {
                    ShowInfo("IMIE&nbsp;<% =Resources.Lan.FillInError %>");
                    return;
                }
                $.ajax({
                    url: "../../../Ashx/YjCmd.ashx",
                    cache:false,
                    type:"post",
                    dataType:'json',
                    async:true,//异步 
                    data:{lat:0,lng:0,des:'0',type:'video',cph:'0',cid:sCid},
                    success:function(data){
                            if(data.error == 0)
                            {
                                  //获取图片
                                  setTimeout("GetSrc()",2000);
                            }
                            else
                            {
                                setTimeout("TaskVideo()",2000);
//	                               ShowInfo(data.errormsg);
                            }
                    },
                    error: function(e) { 
                        setTimeout("TaskVideo()",2000);
//	                     ShowInfo(e.message);
                    } 
                }) ;
//                closeForm();
            }
            catch(e)
            {
                setTimeout("TaskVideo()",2000);
//                ShowInfo(e.message);
            }
        }
        
        function Zoom(img)
        {
            window.parent.window.OpenInfoPhoto('<img alt="" src = "' + img.src + '" width="800px" height="480px" />');
        }
        
        function TVideoTimeout()
        {
             var Request = GetRequest();
             var sCid = Request["cid"];
             if(sCid == undefined || sCid.length == 0)
             {
                 ShowInfo("IMIE&nbsp;<% =Resources.Lan.FillInError %>");
                 return;
             }
             window.parent.window.TVideoTimeout(sCid);
        }
        
        function GetSrc(guid)
        {
            try
            {
                if(IsClose)
                {
                    return;
                }
                setTimeout("TVideoTimeout()",10);
                var Request = GetRequest();
                var sCid = Request["cid"];
                if(sCid == undefined || sCid.length == 0)
                {
                    ShowInfo("IMIE&nbsp;<% =Resources.Lan.FillInError %>");
                    return;
                }
                sCid = sCid.substring(4);
                if(guid == undefined || guid.length == 0)
                {
                    ShowInfo("Guid&nbsp;<% =Resources.Lan.FillInError %>");
                    return;
                }
                $.ajax({
                    url: "http://36.250.69.195:8002/api/GetRemoteInfo",
                    cache:false,
                    type:"post",
                    dataType:'json',
                    async:true,//异步 
                    data:{"APPKEY":"0a944ca1f7a849de8288a1636b2c89eb","CONTROL_GUID":guid,"TERMINAL_ID":sCid},
                    success:function(data){
                            if(data.Status == 1)
                            {
                                  //获取图片
                                  iTry = iTry + 1;
	                               var sTime = data.Entity.TIME;
	                               sLastTime = sTime;
	                               var sUrl = data.Entity.URL;
	                               var dLONGITUDE = data.Entity.LONGITUDE / 1000000;
	                               var dLATITUDE = data.Entity.LATITUDE / 1000000;
	                               var baiduXY = CheckXYGpsToBaidu(dLONGITUDE, dLATITUDE);
                                   dLONGITUDE = baiduXY[0].lng;
                                   dLATITUDE = baiduXY[0].lat;
//	                               var dLatLng = TransformGCJToBD(dLONGITUDE,dLATITUDE);
//	                               dLONGITUDE = dLatLng[0].lng;
//	                               dLATITUDE = dLatLng[0].lat;
	                               var sGuid =  Guid.NewGuid().ToString("N");
	                               var sMap = '<div style="float:left;margin-top:3px; "><div style="width:400px; height:400px;" id="map' + sGuid + '" onclick="this.focus();"></div></div></div>';
	                               $("#panelPic").prepend('<div style="float:left;width:815px;margin:0;padding:0;"><div style="float:left;width:400px;height:400px; "><video width="399px" style="padding:3px;object-fit:fill;" height="399px" autoplay="autoplay" ><source src="' + sUrl + '" type="video/mp4" /><% =Resources.Lan.BrowserVideoNotSupport %></video></div>' + sMap);
	                               SetMap(dLATITUDE,dLONGITUDE,"map" + sGuid);
//	                               $("#panelPic").prepend('<video width="400" style="padding:3px" height="400" autoplay="autoplay" ><source src="' + sUrl + '" type="video/mp4" /><% =Resources.Lan.BrowserVideoNotSupport %></video>');
//                                   TaskVideo();
                            }
                            else
                            {
	                               ShowInfo("<% =Resources.Lan.Fault %>");
                            }
                    },
                    error: function(e) { 
                    
                    } 
                }) ;
//                closeForm();
            }
            catch(e)
            {
                ShowInfo(e.message);
            }
        }        
       
        function SetMap(dLat,dLng,sName)
        {
            var map = new BMap.Map(sName,{minZoom:3,maxZoom:19,enableMapClick:false});            // 创建Map实例
            var point = new BMap.Point(dLng,dLat);    // 创建点坐标
            map.centerAndZoom(point, 12);                     // 初始化地图,设置中心点坐标和地图级别。
            map.enableScrollWheelZoom();                            //启用滚轮放大缩小
//        map.addControl(new BMap.NavigationControl());  //启用导航控件
//        map.addControl(new BMap.MapTypeControl({ mapTypes: [BMAP_NORMAL_MAP, BMAP_HYBRID_MAP] }));     //2D图，卫星图
            var marker = new BMap.Marker(point);// 创建标注
	        map.addOverlay(marker);             // 将标注添加到地图中
        }
        
        var sLastTime = "";
        function GetLastTime()
        {
            try
            {
                var Request = GetRequest();
                var sCid = Request["cid"];
                if(sCid.length == 0)
                {
                    ShowInfo("IMIE&nbsp;<% =Resources.Lan.FillInError %>");
                    return;
                }
                $.ajax({
                    url: "http://36.250.69.195:8002/api/Files?fileType=3&imei=" + sCid,
                    cache:false,
                    type:"get",
                    dataType:'json',
                    async:false,//同步 
                    data:{fileType:1,imei:sCid},
                    success:function(data){
                            if(data.Status == 1)
                            {
                                  //获取图片
	                              sLastTime = data.Entity.createDate;
                            }
                            else
                            {
                            
                            }
                    },
                    error: function(e) { 
	                     ShowInfo(e.message);
                    } 
                }) ;
//                closeForm();
            }
            catch(e)
            {
                ShowInfo(e.message);
            }
        }
        
        function ShowInfo(info)
        {
            $.messager.alert('<% =Resources.Lan.Tip %>',info,'info');
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
        
        function closeForm()
        {
            window.parent.window.CloseInfoCmd();
        }
        
        function OpenInfoPhoto(info)        {            $("#dlgInfoPhoto").html("<p>" + info + "</p>");            $("#dlgPhoto").dialog('open').dialog('center');        }
        
        function UnLoad()
        {
            try
            {
                IsClose = true;
                var Request = GetRequest();
                var sCid = Request["cid"];
                window.parent.window.TVideoUnSelect(sCid);
                ShowInfo("<% =Resources.Lan.StopVideoSuccessful %>");
            }
            catch (e)
            {
//                ShowInfo(e.message);
            }
        }
    </script>
</head>
<body onunload="UnLoad()">
    <div class="easyui-navpanel" style="-webkit-overflow-scrolling: touch;">
        <div id="panelPic" class="easyui-panel" data-options="fit:true,iconCls:'icon-photo'" title="<% =Resources.Lan.RealtimeVideoMonitoring %>" style="width:100%; height:100%">
	        <%--<img alt="" ondblclick="Zoom(this)" src = "../../../Img/page1_0.png" width="200px" height="200px" style="padding:3px" />--%>
    	    
	    </div>
        <div id="tt">
		    <%--<a href="javascript:void(0)" class="icon-add" onclick="javascript:TaskVideo()"></a>--%>
		    <a href="javascript:void(0)" class="icon-no" onclick="javascript:UnLoad()"></a>
	    </div>  
    </div>    <div id="dlgPhoto" class="easyui-dialog" style="padding:20px 6px;width:250px; height:250px;" data-options="inline:true,modal:true,closed:true,title:'<% =Resources.Lan.Prompt %>'">
		<div id="dlgInfoPhoto">This is a message dialog.</div>
		
	</div>
</body>
</html>