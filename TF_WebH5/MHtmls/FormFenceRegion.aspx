<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FormFenceRegion.aspx.cs" Inherits="MHtmls_FormFenceRegion" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <%--<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />--%>
    <title><% =Resources.Lan.FenceRegionManage %></title>
    <style type="text/css">
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
    </style>  
    <link rel="stylesheet" type="text/css" href="../EasyUI/themes/default/easyui.css" />  
    <link rel="stylesheet" type="text/css" href="../EasyUI/themes/color.css"/> 
    <link rel="stylesheet" type="text/css" href="../EasyUI/themes/icon.css"/> 
    <script type="text/javascript" src="../EasyUI/jquery.min.js"></script>  
    <script type="text/javascript" src="../EasyUI/jquery.easyui.min.js"></script>     <script type="text/javascript" src="../Js/JsCookies.js"></script>  
    <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=l4zKPgF3ihF8lciY2QGmpsvW"></script><!--C9f93589d92e645b1a9a4cf2fb53caa4-->
	<script type="text/javascript" src="../Js/Baidu/BaiduMapWrapper.js"></script> 
	<script type="text/javascript" src="../Js/Baidu/BaiduConvertor.js"></script>
	<script type="text/javascript" src="../Js/Baidu/BaiduDrawingManager.js"></script>
    <script type="text/javascript" src="../Js/Baidu/LineOverlay.js"></script>
    <script type="text/javascript" src="../Js/Baidu/BaiduLatLngCorrect.js"></script>
    <script language="javascript" type="text/javascript" src="../Js/Google/GoogleLatLngCorrect.js"></script>
    <link rel="stylesheet" href="../Css/BaiduDrawingManager.css" />
    <script type="text/javascript">
        $(document).ready(function() { 
            InitTree();
            GetPolygon();
        })
        
        function InitTree()
        {   
            var attchJson = new Array();  
            var rowVeh = { id: 'G1', text: '<% =Resources.Lan.FenceAllElectronic %>', iconCls: "icon-map" };
            attchJson.push(rowVeh);    
            $('#tt').tree('loadData',attchJson);        
            rowVeh = { id: 'G2', text: '<% =Resources.Lan.FencePolygon %>', iconCls: "icon-polygon" };
            var node = $('#tt').tree('find', 'G1');
            $('#tt').tree('append', {
	        parent: node.target,
	            data: rowVeh
            });
        }
        
        var arrPolygon =new Array();
        function GetPolygon()
        {
            try
            {
                arrPolygon.length = 0;
                var sUserName = GetCookie("username");
                var sPwd = GetCookie("pwd");
                $.ajax({
                    url: "../Ashx/FenceRegion.ashx",
                    cache:false,
                    type:"post",
                    dataType:'json',
                    async:true, 
                    data:{username:sUserName,Pwd:sPwd,doType:'GetPolygons',loginDefaultType:1},
                    success:function(data){
                            if(data.result == "true")
                            {
                                arrPolygon = data.data;
                                var node = $('#tt').tree('find', 'G2');
                                $('#tt').tree('append', {
	                                parent: node.target,
	                                data: data.data
                                });
                            }
                            else
                            {
//	                               $("#divState").text(GetErr(data.err));
                            }
                    },
                    error: function(e) { 
                        ShowInfo(e.responseText);
//	                     $("#divState").text(e.responseText);
                    } 
                }) ;   
            }
            catch(e)
            {}
        }
        
        function ShowInfo(info)
        {
            $.messager.alert('<% =Resources.Lan.Tip %>',info,'info');
        }
        
        function BindPolygonVeh()
        {
            var node = $('#tt').tree('getSelected');
            if(node != undefined)
            {
                window.parent.window.BindPolygonVehP(node);
            }
        }
        
        function ShowPolygon()
        {   
            var node = $('#tt').tree('getSelected');
            if(node != undefined)
            {
                try
                {
                    var sUserName = GetCookie("username");
                    var sPwd = GetCookie("pwd");
                    $.ajax({
                        url: "../Ashx/FenceRegion.ashx",
                        cache:false,
                        type:"post",
                        dataType:'json',
                        async:true, 
                        data:{username:sUserName,Pwd:sPwd,doType:'GetPolygonPoint',loginDefaultType:1,cid:node.id.substring(1)},
                        success:function(data){
                                if(data.result == "true")
                                {
                                    var sLngLat = "";
                                    $.each(data.data,function(i,value){
                                        var baiduXY = CheckXYGpsToBaidu(value.lng, value.lat);
                                        var x = baiduXY[0].lng;
                                        var y = baiduXY[0].lat;
                                        if(i == 0)
                                        {
                                            sLngLat = y + "," + x;
                                        }
                                        else
                                        {
                                            sLngLat = sLngLat + ";" + y + "," + x;
                                        }
                                    });
                                    if(sLngLat.length > 0)
                                    {
                                        ShowPolyline(node.id, sLngLat);
                                    }
                                }
                                else
                                {
                                
                                }
                        },
                        error: function(e) { 
                            ShowInfo(e.responseText);
                        } 
                    }) ;   
                }
                catch(e)
                {}
            }
        }
        
        function HidePolygon()
        {
            var node = $('#tt').tree('getSelected');
            if(node != undefined)
            {
                HidePolylinePosition(node.id);
            }
            
        }
        
        function AddPolygonForm(pointsDraw)
        {
            var node = $('#tt').tree('getSelected');
            if(node != undefined)
            {                $.messager.defaults.ok = "<% =Resources.Lan.Confirm %>";  
                $.messager.defaults.cancel = "<% =Resources.Lan.Cancel %>";
                //$.messager.defaults = { ok: "<% =Resources.Lan.Confirm %>", cancel: "<% =Resources.Lan.Cancel %>" }; 
                $.messager.confirm('<% =Resources.Lan.Prompt %>', '<% =Resources.Lan.Name %>：<input id="txtName" name = "txtName" type="text" value="" />', function(r){
				    if (r){
					    try
                        {
                            var sName = $("#txtName").val();
                            var sUserName = GetCookie("username");
                            var sPwd = GetCookie("pwd");
                            var sUserID = GetCookie("userid");
                            $.ajax({
                                url: "../Ashx/FenceRegion.ashx",
                                cache:false,
                                type:"post",
                                dataType:'json',
                                async:true, 
                                data:{username:sUserName,Pwd:sPwd,doType:'SavePolygon',loginDefaultType:1,name:sName,points:pointsDraw,userid: sUserID},
                                success:function(data){
                                        if(data.result == "true")
                                        {
                                            arrPolygon.push(data.data);
                                            var node2 = $('#tt').tree('find', 'G2');
                                            $('#tt').tree('append', {
	                                            parent: node2.target,
	                                            data: data.data
                                            });
                                            $.messager.alert('<% =Resources.Lan.Prompt %>','<% =Resources.Lan.Successful %>');
                                        }
                                        else
                                        {
                                            $.messager.alert('<% =Resources.Lan.Prompt %>','<% =Resources.Lan.Fault %>');
                                        }
                                },
                                error: function(e) { 
                                    ShowInfo(e.responseText);
                                } 
                            }) ;   
                        }
                        catch(e)
                        {}
				    }
			    });
            }
        }
        
        function DelPolygon()
        {
            var node = $('#tt').tree('getSelected');
            if(node != undefined)
            {                $.messager.defaults.ok = "<% =Resources.Lan.Confirm %>";  
                $.messager.defaults.cancel = "<% =Resources.Lan.Cancel %>";
                //$.messager.defaults = { ok: "<% =Resources.Lan.Confirm %>", cancel: "<% =Resources.Lan.Cancel %>" }; 
                $.messager.confirm('<% =Resources.Lan.Prompt %>', '<% =Resources.Lan.FenceDel %>?', function(r){
				    if (r){
					    try
                        {
                            var sUserName = GetCookie("username");
                            var sPwd = GetCookie("pwd");
                            $.ajax({
                                url: "../Ashx/FenceRegion.ashx",
                                cache:false,
                                type:"post",
                                dataType:'json',
                                async:true, 
                                data:{username:sUserName,Pwd:sPwd,doType:'DelPolygon',loginDefaultType:1,cid:node.id.substring(1)},
                                success:function(data){
                                        if(data.result == "true")
                                        {
                                            HidePolygon();
                                            $('#tt').tree('remove',node.target);
                                            $.messager.show({
				                                title:'<% =Resources.Lan.Prompt %>',
				                                msg:'<% =Resources.Lan.Successful %>',
				                                showType:'fade',
				                                style:{
					                                right:'',
					                                bottom:''
				                                }
			                                });
                                        }
                                        else
                                        {
                                        
                                        }
                                },
                                error: function(e) { 
                                    ShowInfo(e.responseText);
                                } 
                            }) ;   
                        }
                        catch(e)
                        {}
				    }
			    });
            }
        }
        
        var oldnodename = "";
        function MidifyName()
        {
            var node = $('#tt').tree('getSelected');
            if(node != undefined)
            {
                oldnodename = node.text;  
                $('#tt').tree('beginEdit',node.target);  
                var nodeid=node.id;  
                setCursorPos(nodeid);
            }
        }
        
        function MidyfyAjax(node)
        {
            try
            {
                var sUserName = GetCookie("username");
                var sPwd = GetCookie("pwd");
                $.ajax({
                    url: "../Ashx/FenceRegion.ashx",
                    cache:false,
                    type:"post",
                    dataType:'json',
                    async:true, 
                    data:{username:sUserName,Pwd:sPwd,doType:'SavePolygonName',loginDefaultType:1,name:node.text,cid:node.id.substring(1)},
                    success:function(data){
                            if(data.result == "true")
                            {
                                $.each(arrPolygon,function(i,value){
                                    if(value.id == node.id)
                                    {
                                        value.text = node.text;
                                        return false;
                                    }
                                });
                                $('#tt').tree('update',node);
                            }
                            else
                            {
                                $.each(arrPolygon,function(i,value){
                                    if(value.id == node.id)
                                    {
                                        node.text = oldnodename;
                                        return false;
                                    }
                                });
                                $('#tt').tree('update',node);
                            }
                    },
                    error: function(e) { 
                        $.each(arrPolygon,function(i,value){
                            if(value.id == node.id)
                            {
                                node.text = oldnodename;
                                return false;
                            }
                        });
                        $('#tt').tree('update',node);
                        ShowInfo(e.responseText);
                    } 
                }) ;   
            }
            catch(e)
            {}
            
        }
        
        function setCursorPos(nodeid){  
//            var parnote=$("div[node-id='"+nodeid+"']");  
//            var titlespannote=$(parnote).children(".tree-title");  
//            var titleinput= $(titlespannote).children("input");       
//            var e1=titleinput[0];  
//            e1.select();  
        }
    </script>
</head>
<body oncontextmenu="return false" onload="load()"  onunload="unload()"  class="easyui-layout" id="bodyLayout" style="overflow-y: hidden; scroll:"no">
    <div region="west" split="true" border="true" style="overflow: hidden; font-family: Verdana, 微软雅黑,黑体; padding:2px; width:240px">
        <ul id="tt" class="easyui-tree" data-options="
				<%--url: 'tree_data1.json',--%>
				method: 'get',
				animate: true,
				onContextMenu: function(e,node){
					e.preventDefault();
					$(this).tree('select',node.target);
					if(node.id == 'G1')
					{
					    return;
					}
					else if(node.id == 'G2')
					{
					    $('#divPolygon').menu('show',{
						    left: e.pageX,
						    top: e.pageY
					    });
					}
					else					
					{
					    $('#divPolygonDetail').menu('show',{
						    left: e.pageX,
						    top: e.pageY
					    });
					}
				},
		     onAfterEdit:function(node){
		        MidyfyAjax(node);
		        //$('#tt').tree('update',node);
		        //ShowInfo('onlEdit---');  
		     },onCancelEdit:function(node){  
                 //ShowInfo('onCancelEdit---');  
             }  
			"></ul>
    </div>
    <div region="center" split="true" border="true" style="overflow: hidden; font-family: Verdana, 微软雅黑,黑体; padding:2px; width:240px">
        <div id="map" onclick="this.focus();"></div>
        <div id="r-result" style="height:150px; overflow:scroll; "></div>
    </div>
    <div id="divPolygon" class="easyui-menu">
        <div data-options="iconCls:'icon-add'" onclick="startDragPolygonShape();"><% =Resources.Lan.FenceAddPolygon %></div>
    </div>
    <div id="divPolygonDetail" class="easyui-menu">
        <div onclick="BindPolygonVeh()" ><% =Resources.Lan.FenceBindVehicle %></div>
        <div onclick="ShowPolygon()" ><% =Resources.Lan.FenceDisplay %></div>
        <div onclick="HidePolygon();"><% =Resources.Lan.FenceHide %></div>
        <div onclick="MidifyName();"><% =Resources.Lan.FenceMidifyName %></div>
        <div onclick="DelPolygon();"><% =Resources.Lan.FenceDel %></div>
    </div>
</body>	
</html>
<script type="text/javascript">
    var bLoad = false;
    var map;
    // 创建汽车图标
    var pointsBAK = null;
    var car = null;
    var iconArray = new Array(8);
    setIconDirect();

    var iconURL = '51ditu/';
    var statusType = '';
    var vehicleType = '';
    var rect = null;
    var marker = null;
    var car = null;
    var strObjectCode = '';
    var strLon = null;
    var strLat = null;
    var tooltype = 0;
    var ctrlMapType = null;
    var arrPoly = new Array();
    var lastpoint = null;
    var polyLine1 = null;
    var polystartpoint = null;
    var arrTracker = new Array();
    var Locatemarker = null;
    //list
    var MarkList = new Array();
    var NodeOverlays = new Array();
    var labelOverlays = new Array();
    var TrackList=new Array();
    //map choice
    var CurrentMapType = null;
    var infoWindowVeh;
    var infoWindowVehID = 0; //信息框的ID
    var overlays = []; //围栏，多边形等等
    var drawingManager;//地图位置定义
    var mPositionPoint;//位置点

    function unload() {
        bLoad = false;
    }

    function load() {
        map = new BMap.Map("map",{minZoom:3,maxZoom:19,enableMapClick:false});            // 创建Map实例
        bLoad = true;
        var point = new BMap.Point(102.362240, 36.910400);    // 创建点坐标
        map.centerAndZoom(point, 5);                     // 初始化地图,设置中心点坐标和地图级别。
        map.enableScrollWheelZoom();                            //启用滚轮放大缩小
        map.addControl(new BMap.NavigationControl());  //启用导航控件
        map.addControl(new BMap.MapTypeControl({ mapTypes: [BMAP_NORMAL_MAP, BMAP_HYBRID_MAP] }));     //2D图，卫星图
//        AddOrMoveObject(9398, 'wu_2D', 114.0391, 22.6501666666667, 114.0391, 22.6501666666667, 0, 248, 12, 'ACC关(熄火) 油路断开 停转;定位 GPS天线正常 电源正常 ', 1, 22, 1, '0', 0, '2013-05-15 16:27:03', '1','ffffc0');

//        AddOrMoveObject(9398, 'wu_2D', 114.0391, 22.6501666666667, 114.0491, 22.6501666666667, 0, 248, 12, 'ACC开(熄火) 油路断开 停转;定位 GPS天线正常 电源正常 ', 1, 22, 1, '0', 1, '2013-05-15 16:27:03', '1','ffffc0');
        //实例化鼠标绘制工具
        drawingManager = new BMapLib.DrawingManager(map, {
            isOpen: true, //是否开启绘制模式
            enableDrawingTool: false, //是否显示工具栏
            drawingToolOptions: {
                anchor: BMAP_ANCHOR_TOP_RIGHT, //位置
                offset: new BMap.Size(5, 5), //偏离值
                scale: 0.8 //工具栏缩放比例
            },
            circleOptions: styleOptions, //圆的样式
            polylineOptions: styleOptions, //线的样式
            polygonOptions: styleOptions, //多边形的样式
            rectangleOptions: styleOptions //矩形的样式
        });
        //添加鼠标绘制工具监听事件，用于获取绘制结果
        drawingManager.addEventListener('overlaycomplete', overlaycomplete);
//        drawingManager.setDrawingMode(BMAP_DRAWING_RECTANGLE);
        drawingManager.close();
//        DrawLineRoad();
//        ShowNode("113.04514,31.52872;113.04514,29.22368;114.04068,22.65075;114.03717,22.65071;114.03946,22.65039;114.03873,22.65038;114.04149,22.65211;114.03775,22.65208;116.4896,39.92309;116.45315,39.89499;117.22255,24.89896;117.19297,24.87439;110.43599,30.69181;110.43599,28.72944;109.09877,23.14687;107.89705,22.32788;107.46545,30.86726;105.55334,30.86706");
        //        drawingManager.open();
            
        
//        AddOrMoveObject(11051, 'YH41080149', 106.895183333333, 33.1436166666667, 106.905781, 33.147684, 0, 1, 12, 'ACC开(启动) 油路正常;定位 GPS天线正常 电源正常 ', 1, 22, 1, '0', 0, '2013-11-26 16:03:17', '1', '00c000');
    }

    //地图增加车辆     

    function AddOrMoveObject(ObjectCode, VehicleNum, oLon, oLat, Lon, Lat, NowSpeed, Direct, Zoom, StatusDes, isTrack, isNeedRevice, Addr, isSetCenter, IsUpdate, sTime, ImgState, iColor, iLetter, addressCompany, iShowState) {
        strLon = Lon;
        strLat = Lat;
        var baiduXY = CheckXYGpsToBaidu(Lon, Lat);
        oLon = baiduXY[0].lng;
        oLat = baiduXY[0].lat;
        if (!bLoad) {
            return;
        }
        var sShowState = "";
        if(iShowState == 0)
        {
            sShowState = " style=\"display:none\"";
        }
        var infoText = "<table>" + //style='font:9pt;'
        // "<tr height='10px'><td width='15px'></td><td nowrap></td><td>" + "</td></tr>"+
                          "<tr><td width='15px'></td><td nowrap align='right'><font color='#244FAF'>ID：</font></td><td nowrap>" + ObjectCode + "</td></tr>" +
                          "<tr><td width='15px'></td><td nowrap align='right'><font color='#244FAF'><% =Resources.Lan.Plate  %>：</font></td><td nowrap>" + VehicleNum + "</td></tr>" +
                          "<tr><td width='15px'></td><td nowrap align='right'><font color='#244FAF'><% =Resources.Lan.Speed  %>：</font></td><td nowrap>" + Number(NowSpeed) + "公里/小时</td></tr>" +
                           "<tr><td width='15px'></td><td nowrap align='right'><font color='#244FAF'><% =Resources.Lan.DataTime  %>：</font></td><td nowrap>" + sTime + "</td></tr>" +
                          "<tr" + sShowState + "><td width='15px'></td><td nowrap align='right'><font color='#244FAF'><% =Resources.Lan.UnitStatus  %>：</font></td><td nowrap>" + StatusDes + "</td></tr>" +
                          "<tr height='0px' style=\"display:none\"><td width='15px'></td><td nowrap align='right'><font color='#244FAF'>地址：</font></td><td nowrap><label id=\"lblCompany\">" + addressCompany + "</label></td></tr>" +
                          "<tr  height='50px'  ><td width='15px'></td><td nowrap valign='top' align='right'><font color='#244FAF'><% =Resources.Lan.Address  %>：</font></td><td id='tdAdd' valign='top' >" +
                          "<a onmouseover=\"document['imgDisplayAddr'].imgRolln=document['imgDisplayAddr'].src;document['imgDisplayAddr'].src=document['imgDisplayAddr'].lowsrc;\" onmouseout=\"document['imgDisplayAddr'].src=document['imgDisplayAddr'].imgRolln\" href=\"#\"    onclick='getAdd(" + Lon + "," + Lat + ");' >"
                          + "<img border=\"0\" src=\"../Img/Baidu/showAddr.gif\" id=\"imgDisplayAddr\" name=\"imgDisplayAddr\" dynamicanimation=\"imgDisplayAddr\" lowsrc=\"../Img/Baidu/showAddr2.gif\" alt=\"\"/></a>" +
                           "</td></tr>" +
                      "</table>";
//        infoText = "地址：北京市东城区王府井大街88号乐天银泰百货八层地址：北京市东城区王府井大街88号乐天银泰百货八层";              
        //可以转化gps坐标
        var mapWforGPS = undefined;  //new BMapLib.MapWrapper(map, BMapLib.COORD_TYPE_GPS);
        //添加gps坐标mkr
//        var gpsMkr = new BMap.Marker(new BMap.Point(oLon, oLat));      
//        
//                
//            gpsMkr.addEventListener("click", function(){
//                var strXY = this.getPosition().lng.toFixed(3) + ", " + this.getPosition().lat.toFixed(3);
//                var infoWin = new BMap.InfoWindow("GPS" + strXY);
//                this.openInfoWindow(infoWin);
//            });
//        
//        mapWforGPS.addOverlay(gpsMkr);
//        return;
        IsUpdate = 0;
        for (var i = 0; i < MarkList.length; i++) {
            if (MarkList[i].ID == ObjectCode) {
                IsUpdate = 1;
                break;
            }
        }
        if (IsUpdate == 0) {
            AddObject(mapWforGPS,ObjectCode, VehicleNum, oLon, oLat, NowSpeed, Direct, Zoom, StatusDes, isTrack, Addr, isSetCenter, infoText, ImgState, iColor, iLetter);
        }
        else {
            MoveObject(mapWforGPS,oLon, oLat, ObjectCode, VehicleNum, NowSpeed, Direct, Zoom, StatusDes, isTrack, isNeedRevice, Addr, isSetCenter, infoText, ImgState, iColor, iLetter);
        }
        //strObjectCode = ObjectCode; 
    }

    function AddObject(mapWforGPS,ObjectCode, VehicleNum, oLon, oLat, NowSpeed, Direct, Zoom, StatusDes, isTrack, Addr, isSetCenter, info, ImgState, Color, iLetter) {
        //
        var addmark;
        var markexist = 0;
        var mouseText = '';
        var title = '';
        if (CurrentMapType == "混合地图") {
            car = NewMarker(VehicleNum, oLon, oLat, Direct, ImgState); //产生车辆标注对象
        }
        else {
            car = NewMarker(VehicleNum, oLon, oLat, Direct, ImgState); //产生车辆标注对象
        }
        //      car.trackMarkers = true;
        addmark = createMarker(car, info, ObjectCode);
        var infoWindowClick = undefined;
        infoWindowClick = function() { infoWindowVehID = ObjectCode; infoWindowVeh = new BMap.InfoWindow(info, { enableMessage: false }); infoWindowVeh.redraw(); this.openInfoWindow(infoWindowVeh); };
        addmark.addEventListener("click", infoWindowClick);
        var vehCarNum = "I";
        var vehFontSize = "43px"
        if(iLetter < 2)
        {
            vehCarNum = setIcon(Direct, ImgState, iLetter == 1);
            vehFontSize = "57px";
        }
        var label = new BMap.Label(vehCarNum, { position: new BMap.Point(oLon, oLat), offset: new BMap.Size(-16, -16) }); //VehicleNum
        var labelNum = new BMap.Label(VehicleNum, { offset: new BMap.Size((VehicleNum.length * -4 ) + 22, 33) }); //VehicleNum
        labelNum.setStyle({
            color: "red",
            borderColor: "transparent",
            borderWidth: "0px 0px 0px 0px",
            fontSize: "12px",
            height: "20px",
            lineHeight: "20px",
            fontFamily: "微软雅黑"
        });
        if(vehCarNum == "I")
        {
            vehCarNum = "1";
        }
        label.setStyle({
            color: "#" + Color,
            borderColor: "transparent",
            borderWidth: "0px 0px 0px 0px",
//            backgroundImage: "url(51ditu/Car1.gif)",
            //backgroundColor: "transparent",
            background:"url(../Img/Baidu/CarBack" + vehCarNum + ".gif) no-repeat 0 0",
//            background: "none transparent scroll repeat 0% 0%",
//            FILTER: "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='51ditu/Car1.gif', sizingMethod='scale')",
            fontSize: vehFontSize,
            height: "32px",
            lineHeight: "32px",
            width: "32px",
            fontFamily: "BaiduCar"
        });
        addmark.setLabel(labelNum);
        addmark.setZIndex(MarkList.length + 1);
        label.setZIndex(MarkList.length + 1);
        for (var i = 0; i < MarkList.length; i++) {

            if (MarkList[i].ID == ObjectCode) {
                markexist = 1;
                break;
            }
        }

        if (markexist == 0) {

            MarkList.push({ "ID": ObjectCode, "Mark": addmark, "Label": label, "oX": oLon, "oY": oLat, "X": oLon, "Y": oLat, "Click": infoWindowClick });
            //            mapWforGPS.addOverlay(addmark);
            map.addOverlay(addmark);
            map.addOverlay(label);
        }
        for (var i = 0; i < TrackList.length; i++) 
        {      
            if (TrackList[i].ID ==ObjectCode) //显示轨迹
            {
                setMapTrack(point,i);
                TrackList[i].LastPoint = new BMap.Point(oLon, oLat);
                break;
            }
        } 
    }

    function deleteCar(ObjectCode) {
        for (var i = 0; i < MarkList.length; i++) {
            if (MarkList[i].ID == ObjectCode) {
                map.removeOverlay(MarkList[i].Mark); 
                map.removeOverlay(MarkList[i].Label); 
                MarkList.splice(i, 1);
                break;
            }
        }
    }

    var winVeh = "";
    //车辆移动
    function MoveObject(mapWforGPS,oLon, oLat, ObjectCode, VehicleNum, NowSpeed, Direct, Zoom, StatusDes, isTrack, isNeedRevice, Addr, isSetCenter, info, ImgState, Color, iLetter) {
        var SelectMark = null;
        var SelectLabel = null;
        var infoWindowClick = null;
        var iMarkListIndex = 0;
        for (var i = 0; i < MarkList.length; i++) {
            if (MarkList[i].ID == ObjectCode) {
                SelectMark = MarkList[i].Mark;
                SelectLabel = MarkList[i].Label;
                infoWindowClick = MarkList[i].Click;
                iMarkListIndex = i;
                break;
            }
        }

        if (SelectMark == null) return;
        var point = new BMap.Point(oLon, oLat);
//        var translateCallback = function(point) {
            var mouseText = '';
            var title = '';
            var dituDirect = Direct;
            var url = setIcon(dituDirect, ImgState);
            //         SelectMark.trackMarkers = true;
//            SelectMark.setIcon(new BMap.Icon("51ditu/baiducar.gif", new BMap.Size(32, 32)));//setIcon(Direct, ImgState), new BMap.Size(32, 32)));
            SelectMark.setPosition(point);
            SelectLabel.setPosition(point);
            var vehCarNum = "I";
            if(iLetter < 2)
            {
                vehCarNum = setIcon(Direct, ImgState, iLetter == 1);
            }
            var vehFontSize = "43px"
            if(iLetter < 2)
            {
                vehCarNum = setIcon(Direct, ImgState, iLetter == 1);
                vehFontSize = "57px";
            }
//            var vehCarNum = setIcon(Direct, ImgState, iLetter == 1);
            SelectLabel.setContent(vehCarNum);
            SelectMark.getLabel().setContent(VehicleNum);
            
            if(vehCarNum == "I")
            {
                vehCarNum = "1";
            }
            SelectLabel.setStyle({
                color: "#" + Color,
                borderColor: "transparent",
                borderWidth: "0px 0px 0px 0px",
//                backgroundColor: "transparent",
                background:"url(../Img/Baidu/CarBack/CarBack" + vehCarNum + ".gif) no-repeat 0 0",
                fontSize: vehFontSize,
                height: "32px",
                lineHeight: "32px",
                width: "32px",
                fontFamily: "BaiduCar"
            });
            if (infoWindowVeh != undefined && infoWindowVeh.isOpen() && infoWindowVehID == ObjectCode) {
                infoWindowVeh.setContent(info);
                infoWindowVeh.redraw();
            }
            if(infoWindowClick != null && infoWindowClick != undefined)
            {
                SelectMark.removeEventListener("click", infoWindowClick);
            }
            infoWindowClick = function() { infoWindowVehID = ObjectCode; infoWindowVeh = new BMap.InfoWindow(info, { enableMessage: false }); infoWindowVeh.redraw(); this.openInfoWindow(infoWindowVeh); };
            SelectMark.addEventListener("click", infoWindowClick);
            MarkList[iMarkListIndex].Click = infoWindowClick;

            if (isTrack == '1')//显示轨迹
            {
                //            setMapTrack(point);
            }
            for (var i = 0; i < TrackList.length; i++) 
            {      
                if (TrackList[i].ID ==ObjectCode) //显示轨迹
                {
                    setMapTrack(point,i);
                    TrackList[i].LastPoint = point;
                    break;
                }
            }     
//        }
//        BMap.Convertor.translate(point, 0, translateCallback);     //真实经纬度转成百度坐标       
       
        //得到边界，如果超出边界则重新设置
        //         if(isSetCenter=='1')
        //         {
        //            var bounds = map.getBounds();
        //             //if( !bounds.contains( point ) )
        //             //{
        //	            map.setCenter(point,map.getZoom());
        //            //}
        //        }
//        var bounds = map.getBounds();
//        if (!bounds.contains(point)) {
//            map.setCenter(point, map.getZoom());
//        }
    }
    
    //多宫格显示
    function AddOrMoveGridVeh(ObjectCode, VehicleNum, oLon, oLat, Lon, Lat, NowSpeed, Direct, Zoom, StatusDes, isTrack, isNeedRevice, Addr, isSetCenter, IsUpdate, sTime, ImgState, iColor, iLetter, addressCompany) {
        strLon = Lon;
        strLat = Lat;
        oLon = Lon;
        oLat = Lat;
        if (!bLoad) {
            return;
        }
        var infoText = "<table style='font:9pt;'>" +
        // "<tr height='10px'><td width='15px'></td><td nowrap></td><td>" + "</td></tr>"+
                          "<tr><td width='15px'></td><td nowrap><font color='#244FAF'>编号：</font></td><td nowrap>" + ObjectCode + "</td></tr>" +
                          "<tr><td width='15px'></td><td nowrap><font color='#244FAF'>车牌：</font></td><td nowrap>" + VehicleNum + "</td></tr>" +
                          "<tr><td width='15px'></td><td nowrap><font color='#244FAF'>速度：</font></td><td nowrap>" + Number(NowSpeed) + "公里/小时</td></tr>" +
                           "<tr><td width='15px'></td><td nowrap><font color='#244FAF'>时间：</font></td><td nowrap>" + sTime + "</td></tr>" +
                          "<tr><td width='15px'></td><td nowrap><font color='#244FAF'>状态：</font></td><td nowrap>" + StatusDes + "</td></tr>" +
                          "<tr height='0px' style=\"display:none\"><td width='15px'></td><td nowrap><font color='#244FAF'>地址：</font></td><td nowrap><label id=\"lblCompany\">" + addressCompany + "</label></td></tr>" +
                          "<tr  height='30px'  ><td width='15px'></td><td nowrap valign='top'><font color='#244FAF'>位置：</font></td><td id='tdAdd' valign='top' >" +
                          "<a onmouseover=\"document['imgDisplayAddr'].imgRolln=document['imgDisplayAddr'].src;document['imgDisplayAddr'].src=document['imgDisplayAddr'].lowsrc;\" onmouseout=\"document['imgDisplayAddr'].src=document['imgDisplayAddr'].imgRolln\" href=\"#\"    onclick='getAdd(" + Lon + "," + Lat + ");' >"
                          + "<img border=\"0\" src=\"../Img/Baidu/CarBack/showAddr.gif\" id=\"imgDisplayAddr\" name=\"imgDisplayAddr\" dynamicanimation=\"imgDisplayAddr\" lowsrc=\"51ditu/showAddr2.gif\" alt=\"显示地址\"/></a>" +
                           "</td></tr>" +
                      "</table>";
//        infoText = "地址：北京市东城区王府井大街88号乐天银泰百货八层地址：北京市东城区王府井大街88号乐天银泰百货八层";              
        //可以转化gps坐标
        var mapWforGPS = undefined;  //new BMapLib.MapWrapper(map, BMapLib.COORD_TYPE_GPS);
        IsUpdate = 0;
        for (var i = MarkList.length - 1; i >= 0 ; i--) {
            if (MarkList[i].ID != ObjectCode) {
                map.removeOverlay(MarkList[i].Mark); 
                map.removeOverlay(MarkList[i].Label); 
                MarkList.splice(i, 1);
            }
        }
        for (var i = 0; i < MarkList.length; i++) {
            if (MarkList[i].ID == ObjectCode) {
                IsUpdate = 1;
                break;
            } 
        }
        if (IsUpdate == 0) {
            AddObject(mapWforGPS,ObjectCode, VehicleNum, oLon, oLat, NowSpeed, Direct, Zoom, StatusDes, isTrack, Addr, isSetCenter, infoText, ImgState, iColor, iLetter);
        }
        else {
            MoveObject(mapWforGPS,oLon, oLat, ObjectCode, VehicleNum, NowSpeed, Direct, Zoom, StatusDes, isTrack, isNeedRevice, Addr, isSetCenter, infoText, ImgState, iColor, iLetter);
            
        }
        for (var i = 0; i < MarkList.length; i++) {
            if (MarkList[i].ID == ObjectCode) {
                MarkList[i].Mark.getLabel().setContent("");
                break;
            }
        }
        var bounds = map.getBounds();
        var point = new BMap.Point(oLon, oLat);
       if (map.getZoom() > 13) {
           map.centerAndZoom(point, map.getZoom());
       }
       else {
           map.centerAndZoom(point, 13);
       }
       map.panBy(0,-60, {noAnimation:true});   
    }

    function createMarker(NewCar, Info, ObjectCode) {
//        NewCar.addEventListener("click", function() { infoWindowVehID = ObjectCode; infoWindowVeh = new BMap.InfoWindow(Info, { enableMessage: false }); infoWindowVeh.redraw(); this.openInfoWindow(infoWindowVeh); });
        return NewCar;
    }

    function NewMarker(VehicleNum, lon, lat, Direct, ImgState) {
        var marker = null;
        //        var myIcon = new BMap.Icon(setIcon(Direct, ImgState), new BMap.Size(32, 32));
        var myIcon = new BMap.Icon("../Img/Baidu/baiducar.gif", new BMap.Size(32, 32));
        var marker2 = new BMap.Marker(new BMap.Point(lon, lat), { icon: myIcon });
//        var marker2 = new BMap.Label("217", { offset: new BMap.Size(25, 25) });
//        marker2.setStyle({
//            color: 'red',
//            borderColor: "red",
//            fontSize: "12px",
//            height: "20px",
//            lineHeight: "20px",
//            fontFamily: "GisDisplay"
//        });
        return marker2; 
    }

    function setIconDirect() {
        for (var i = 0; i < 8; i++) {
            var ImageUrl = "51ditu/car" + i + ".gif";
            var num = Number(i);
            iconArray[num] = ImageUrl;
        }
    }

    function setIcon(dituDirect, ImgState) {
        var iconURl = "51ditu/car";
        if (ImgState == 1) {
            iconURl = iconURl + "Stop";
        }
        else if (ImgState == 2) {
            iconURl = iconURl + "Nexact";
        }
        else {
            iconURl = iconURl + "Alarm";
        }
        var direct = "1";
        if ((dituDirect >= 0 && dituDirect <= 22) || (dituDirect >= 338 && dituDirect <= 360)) {
            iconURl = iconURl + "0.gif";
            direct = "1";
        }
        else if (dituDirect >= 23 && dituDirect <= 67) {
            iconURl = iconURl + "1.gif";
            direct = "2";
        }
        else if (dituDirect >= 68 && dituDirect <= 112) {
            iconURl = iconURl + "2.gif";
            direct = "3";
        }
        else if (dituDirect >= 113 && dituDirect <= 157) {
            iconURl = iconURl + "3.gif";
            direct = "4";
        }
        else if (dituDirect >= 158 && dituDirect <= 202) {
            iconURl = iconURl + "4.gif";
            direct = "5";
        }
        else if (dituDirect >= 203 && dituDirect <= 247) {
            iconURl = iconURl + "5.gif";
            direct = "6";
        }
        else if (dituDirect >= 248 && dituDirect <= 292) {
            iconURl = iconURl + "6.gif";
            direct = "7";

        }
        else if (dituDirect >= 293 && dituDirect <= 337) {
            iconURl = iconURl + "7.gif";
            direct = "8";
        }
        else {
            iconURl = iconURl + "0.gif";
            direct = "1";
        }
//        return iconURl;
        return direct;
    }
    
    function setIcon(dituDirect, ImgState, bletter) {
        var iconURl = "51ditu/car";
        if (ImgState == 1) {
            iconURl = iconURl + "Stop";
        }
        else if (ImgState == 2) {
            iconURl = iconURl + "Nexact";
        }
        else {
            iconURl = iconURl + "Alarm";
        }
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
//        return iconURl;
        return direct;
    }

    function setMapCenter(oLon, oLat, lon, lat, zoom) {
//        var baiduXY = CheckXYGpsToBaidu(Lon, Lat);
//        oLon = baiduXY[0].lng;
//        oLat = baiduXY[0].lat;
        var point = new BMap.Point(oLon, oLat);
        var translateCallback = function(point) {
            if (map.getZoom() > 15) {
                map.centerAndZoom(point, map.getZoom());
            }
            else {
                map.centerAndZoom(point, zoom);
            }
        }
        BMap.Convertor.translate(point, 0, translateCallback);     //真实经纬度转成百度坐标
    }
    
    function setMapCenterAndMark(oLon, oLat, zoom) {
        var point = new BMap.Point(oLon, oLat);
        var translateCallback = function(point) {
            if (map.getZoom() > 15) {
                map.centerAndZoom(point, map.getZoom());
            }
            else {
                map.centerAndZoom(point, zoom);
            }
            var marker = new BMap.Marker(point);
	        map.addOverlay(marker);
        }
        BMap.Convertor.translate(point, 0, translateCallback);     //真实经纬度转成百度坐标
    }
    
    //轨迹线
    function  setMapTrack(mapPointNow,arrIndex)
    {
         //点放入数组
         if(TrackList[arrIndex] !=null)
         {
             var points = new Array();
             if(TrackList[arrIndex].LastPoint == null)
             {
                return;
             }
             points.push(TrackList[arrIndex].LastPoint);
             points.push(mapPointNow);
                    
             //定义线的形式
             var polyLineNow= new BMap.Polyline(points, {strokeColor:"#f33f00", strokeWeight:5});
             map.addOverlay(polyLineNow);
             
             var myIcon = new BMap.Icon(SetBaiduMidArrows(TrackList[arrIndex].LastPoint, mapPointNow), new BMap.Size(24, 24));
             var markerDirection = new BMap.Marker(mapPointNow, { icon: myIcon, title: 1, enableDragging: false });  // 创建标注
             map.addOverlay(markerDirection);              // 将标注添加到地图中
                    
             if(TrackList[arrIndex].Marks == null)
             {
                var overlayList = new Array();
                overlayList.push(polyLineNow);
                TrackList[arrIndex].Marks = overlayList;
                var markerDirectionList = new Array();
                markerDirectionList.push(markerDirection);
                TrackList[arrIndex].Direction = markerDirectionList;
             }
             else
             {
                TrackList[arrIndex].Marks.push(polyLineNow);
                TrackList[arrIndex].Direction.push(markerDirection);
                while(TrackList[arrIndex].Marks.length > 100)
                {
                    map.removeOverlay(TrackList[arrIndex].Marks[0]);
                    TrackList[arrIndex].Marks.splice(0, 1);
                    map.removeOverlay(TrackList[arrIndex].Direction[0]);
                    TrackList[arrIndex].Direction.splice(0, 1);
                }
             }
         }                  
     }  

    //跟踪
    function AddTracking(VehId) {
        for (var i = 0; i < TrackList.length; i++) 
        {      
            if (TrackList[i].ID ==VehId) 
            {            
                return;
            }
        }      
        TrackList.push({"ID":VehId,"Marks":null,"Direction":null,"LastPoint":null});
    }

    function ClearTracking(VehId) {
        for (var i = 0; i < TrackList.length; i++) 
        {          
           if (TrackList[i].ID ==VehId) 
           {
                var overlayList=TrackList[i].Marks;
                if(overlayList==null)
                {
                    return;
                }
                for (var j = 0; j < overlayList.length; j++) 
                { 
                    map.removeOverlay(overlayList[j]);  
                }
                var markDirection= TrackList[i].Direction;
                if(markDirection == null)
                {
                    return;
                }
                for (var j = 0; j < markDirection.length; j++) 
                { 
                    map.removeOverlay(markDirection[j]);  
                }
                 TrackList.splice(i, 1);
           }
        }
    }
    
//    UpdatePositionPoint("{\"Positions\":[{\"x\":\"106.5493\",\"y\":\"30.2871\",\"name\":\"重庆\"}]}");
    mPositionPoint  = eval("({\"Positions\":[]})");
    function UpdatePositionPoint(sJson)
    {
//debugger;
//        var ssss = eval("(" + sJson + ")");
        mPositionPoint = sJson;
//        ShowInfo(mPositionPoint.Positions.length);
//        for(var i = 0; i < sJson.Positions.length;i++)
//        {
//            var str = "name:"+sJson.Positions[i].name;
//            ShowInfo(str);
//        }
    }

    //获取地址
    function getAdd(Lon, Lat) {
        var XX = 0, YY = 0;
        XX = parseFloat(Lon);
        YY = parseFloat(Lat);
        try
        {
            if("google" == '<% =Resources.Lan.MapType  %>')
            {
                var googleXY = CheckXYGpsToGoogle(XX, YY );
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
                                document.getElementById('imgDisplayAddr').style.display = 'none';
                                var divAdd = document.getElementById('tdAdd');
                                divAdd.innerHTML = data.results[0]["formatted_address"].replace("号","");
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
                    data:{type:'<% =Resources.Lan.MapType  %>',Lat:YY,Lng:XX},
                    success:function(data){
                            if(data.result == "true")
                            {  
                                document.getElementById('imgDisplayAddr').style.display = 'none';
                                var divAdd = document.getElementById('tdAdd');
                                divAdd.innerHTML = data.data;
                            }
                            else
                            {
        	                       
                            }
                    },
                    error: function(e) { 
        	             
                    } 
                }) ;  
            }
        }
        catch(e)
        {
            ShowInfo(e);
        }
//        GetAddressFromBaidu(XX, YY)
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
//        var translateCallback = function(point) {
            gc.getLocation(pt, function(rs) {
//                var addComp = rs.addressComponents;
//                var myHtml = addComp.province + addComp.city + "" + addComp.district + "" + addComp.street + "" + addComp.streetNumber;
//                document.getElementById('imgDisplayAddr').style.display = 'none';
//                var divAdd = document.getElementById('tdAdd');
//                divAdd.innerHTML = myHtml;
                    var myHtml = rs.address;
                    var addCompany = "";//document.getElementById("lblCompany").innerText;
                    var iDistanceMin = 1100;
                    var sExpendAddress = "";
                    if(addCompany.length > 0)
                    {
                        myHtml += " " + addCompany ;
                    }
                    else
                    {
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
			        }
                    document.getElementById('imgDisplayAddr').style.display = 'none';
                    var divAdd = document.getElementById('tdAdd');
                    divAdd.innerHTML = myHtml;
            },mOption);
//        }
//        BMap.Convertor.translate(pt, 0, translateCallback);     //真实经纬度转成百度坐标
    }

    //以下是画图方面的函数
    //回调获得覆盖物信息
    var overlaycomplete = function(e) {
        drawingManager.close();
        overlays.push(e.overlay);
        var result = "";
        result = "<p>";
        result += e.drawingMode + ":";
        if (e.drawingMode == BMAP_DRAWING_MARKER) {
            result += ' 坐标：' + e.overlay.getPosition().lng + ',' + e.overlay.getPosition().lat;
        }
        if (e.drawingMode == BMAP_DRAWING_CIRCLE) {
            result += ' 半径：' + e.overlay.getRadius();
            result += ' 中心点：' + e.overlay.getCenter().lng + "," + e.overlay.getCenter().lat;
            layDragPolygonShapeGB= e.overlay;
            window.external.InCircleForm(e.overlay.getRadius(),e.overlay.getCenter().lng ,e.overlay.getCenter().lat);
        }
        if (e.drawingMode == BMAP_DRAWING_POLYLINE || e.drawingMode == BMAP_DRAWING_POLYGON || e.drawingMode == BMAP_DRAWING_RECTANGLE) {
            if (e.drawingMode == BMAP_DRAWING_RECTANGLE) {
                var pointsDraw = "";
                for (var i = 0; i < e.overlay.getPath().length; i++) {
                    if (pointsDraw == "") {
                        pointsDraw = e.overlay.getPath()[i].lng;
                        pointsDraw = pointsDraw + "," + e.overlay.getPath()[i].lat;
                    }
                    else {
                        pointsDraw = pointsDraw + ";" + e.overlay.getPath()[i].lng;
                        pointsDraw = pointsDraw + "," + e.overlay.getPath()[i].lat;
                    }
                }
                if (bRectVehicle) {
                    //                    bRectVehicle = false;
                    drawingManager.open();
                    window.external.InRectVehicle(pointsDraw);
                }
                else if (bDragRectangle || bDragRectangleGB) {
                    bDragRectangle = false;
                    if(!bDragRectangleGB)
                    {
                        PanTool();
                    }
                    else
                    {
                        layDragPolygonShapeGB= e.overlay;
                    }
                    window.external.ShowRectangleForm(pointsDraw);
                }
                else {
                    window.external.AddNodeData(pointsDraw);
                }
            }
            else if(e.drawingMode == BMAP_DRAWING_POLYLINE)
            {
                if(bDragPolygonShape || bDragPolygonShapeGB)
                {
                    var pointsDraw = "";
                    for (var i = 0; i < e.overlay.getPath().length; i++) {
                        var baiduXY = CheckXYGpsToBaidu(e.overlay.getPath()[i].lng, e.overlay.getPath()[i].lat);
                        var x = baiduXY[0].lng;
                        var y = baiduXY[0].lat;
                        if (pointsDraw == "") {
                            pointsDraw = x;
                            pointsDraw = pointsDraw + "," + y;
                        }
                        else {
                            pointsDraw = pointsDraw + ";" + x;
                            pointsDraw = pointsDraw + "," + y;
                        }
                    }
                    if(bDragPolygonShapeGB)
                    {
                        layDragPolygonShapeGB = e.overlay;
                    }
                    AddPolygonForm(pointsDraw);
//                    window.external.AddPolygonForm(pointsDraw);
                }
            }
            //            result += ' 所画的点个数：' + e.overlay.getPath().length;
        }
        if(!bDragPolygonShapeGB && !bDragRectangleGB && e.drawingMode != BMAP_DRAWING_CIRCLE)
        {
            map.removeOverlay(e.overlay);
        }
    };
    
    var layDragPolygonShapeGB = undefined;
    function removeDragPolygonShapeGB()
    {
        bDragRectangleGB  = false;
        bDragPolygonShapeGB = false;
        if(layDragPolygonShapeGB != undefined)
        {
            map.removeOverlay(layDragPolygonShapeGB);
            layDragPolygonShapeGB = undefined;
        }
    }

    function ShowNode(points, names, ids) {
        try {
            var arrPoints = points.split(";");
            var arrName = names.split(";"); 
            var arrIDs = ids.split(";");
            var i = 0;
            for (var j = 0; j < arrPoints.length / 2; j++) {
                ShowNodeEach(arrPoints[i].split(",")[0], arrPoints[i].split(",")[1], arrPoints[i + 1].split(",")[0], arrPoints[i + 1].split(",")[1], arrName[j], arrIDs[j]);
                i = i + 2;
            }
        }
        catch (e) { 
        
        }
    }

    function HideNode() {
        try {
            clearDrawNodeAll();
        }
        catch (e) { 
        
        }
    }

    var bDelNode = false;
    function DelNode() {
        bDelNode = true;
    }

    function ShowNodeEach(pStartX, pStartY, pEndX, pEndY, labelName, id) {
        var polygon = new BMap.Polygon([
          new BMap.Point(pStartX, pStartY),
          new BMap.Point(pEndX, pStartY),
          new BMap.Point(pEndX, pEndY),
          new BMap.Point(pStartX, pEndY)
        ], { strokeColor: "blue", strokeWeight: 6, strokeOpacity: 0.6, fillOpacity: 0.2 });
        polygon.addEventListener("click", function showInfo() {
            if (bDelNode) {
                bDelNode = false;
                if (confirm('是否确实需要删除[' + labelName + ']节点？')) {
                    window.external.DelNodeByID(id);
                }
            }
            //            ShowInfo(cp.lng + "," + cp.lat);
        });
        map.addOverlay(polygon);
        overlays.push(polygon);
        var labelMark = addTextMarker(new BMap.Point(pEndX, pEndY), labelName); //围栏定义里的大经大纬其实是小的，以前的代码弄反了。
        NodeOverlays.push({ "Name": labelMark, "ID": id, "MarkNode": polygon, "MarkLabel": labelMark });
    }

    function ClearNodeByID(id) {
        for (var i = 0; i < NodeOverlays.length; i++) {
            if (NodeOverlays[i].ID == id) {
                map.removeOverlay(NodeOverlays[i].MarkNode);
                map.removeOverlay(NodeOverlays[i].MarkLabel);
                NodeOverlays.splice(i, 1);
                break;
            }
        }
    }

    function addTextMarker(_point, labelName) {
        var label = new BMap.Label(labelName , { position: _point, offset: new BMap.Size(0, 5) });
        map.addOverlay(label);
        label.setStyle({
            color: "red",
            borderColor: "blue",
            fontSize: "12px",
            height: "20px",
            lineHeight: "20px",
            fontFamily: "微软雅黑"
        });
        return label;
    }

    function UpdateNode(id, labelName) {
        for (var i = 0; i < NodeOverlays.length; i++) {
            if (NodeOverlays[i].ID == id) {
                NodeOverlays[i].MarkLabel.setContent(labelName);
            }
        }
    }

    function clearDrawNodeAll() {
        for (var i = 0; i < NodeOverlays.length; i++) {
            map.removeOverlay(NodeOverlays[i].MarkNode);
            map.removeOverlay(NodeOverlays[i].MarkLabel);
        }
        overlays.length = 0
    }

    var styleOptions = {
        strokeColor: "blue",    //边线颜色。
        fillColor: "blue",      //填充颜色。当参数为空时，圆形将没有填充效果。
        strokeWeight: 3,       //边线的宽度，以像素为单位。
        strokeOpacity: 0.8,    //边线透明度，取值范围0 - 1。
        fillOpacity: 0.3,      //填充的透明度，取值范围0 - 1。
        strokeStyle: 'solid' //边线的样式，solid或dashed。
    }   


//    function $(id) {
//        return document.getElementById(id);
//    }

    function clearAll() {
        for (var i = 0; i < overlays.length; i++) {
            map.removeOverlay(overlays[i]);
        }
        overlays.length = 0
    }
    
    //以下是围栏定义
    function NodeDefine() {
        try {
            if (!bLoad || typeof (drawingManager) == undefined) {
                return;
            }
            PanTool();
            drawingManager.setDrawingMode(BMAP_DRAWING_RECTANGLE);
            drawingManager.open();
//            clearDrawAll();
        }
        catch (e) {
//            ShowInfo(e.message);
        }
    }

    var bPlaceDefine = false;
    var labelClickEvent;
    function PlaceDefine() {
        try {
            if (!bPlaceDefine) {
                map.addEventListener("click", labelClickEvent = function AddLabel(e) {
                    if (bPlaceDefine) {
                        window.external.AddPlaceDefine(e.point.lng, e.point.lat);
                    };
                })
            }
            PanTool();
            bPlaceDefine = true;
            map.setDefaultCursor("text"); //"crosshair"            
        }
        catch (e) { 
            
        }
    }

    function AddPlaceDefine(id, x, y, title, thisColor) {
        try {
            var marker = new BMap.Marker(new BMap.Point(x, y));  // 创建标注
            map.addOverlay(marker);              // 将标注添加到地图中
            var label = new BMap.Label(title, { offset: new BMap.Size(20, 0) });
            label.setStyle({
                color: thisColor,
                borderColor: "red",
                fontSize: "12px",
                height: "20px",
                lineHeight: "20px",
                fontFamily: "微软雅黑"
            });
            marker.setLabel(label);
            marker.addEventListener("click", function RemoveLabel(e) {
                if (bDelPoint) {
                    window.external.DelPointFromJS(id, title);
                }
            })
            labelOverlays.push({ "Name": title, "ID": id, "MarkNode": marker, "LabelMark": label });
        }
        catch (e) {
//            ShowInfo(e.message);
        }
    }

    function PointUpdate(id, title, thisColor) {
        try {
            for (var i = 0; i < labelOverlays.length; i++) {
                if (labelOverlays[i].ID == id) {
                    labelOverlays[i].LabelMark.setContent(title);
                    label.setStyle({
                        color: thisColor,
                        borderColor: "red",
                        fontSize: "12px",
                        height: "20px",
                        lineHeight: "20px",
                        fontFamily: "微软雅黑"
                    });
                    
                }
            }
        }
        catch (e) { 
        
        }
    }

    function clearAllPoints() {
        for (var i = 0; i < labelOverlays.length; i++) {
            map.removeOverlay(labelOverlays[i].MarkNode);
        }
        labelOverlays.length = 0
    }

    function DelPlaceDefine(id) {
        try {
            for (var i = 0; i < labelOverlays.length; i++) {
                if (labelOverlays[i].ID == id) {
                    map.removeOverlay(labelOverlays[i].MarkNode);
                    labelOverlays.splice(i, 1);
                    break;
                }
            }
        }
        catch (e) {
            ShowInfo(e.message);
        }
    }

    var bDragRectangle = false;
    function DragRectangle() {
        if (bDragRectangle) {
            return;
        }
        try {
            if (!bLoad || typeof (drawingManager) == undefined) {
                return;
            }
            PanTool();
            bDragRectangle = true;
            drawingManager.setDrawingMode(BMAP_DRAWING_RECTANGLE);
            drawingManager.open();
        }
        catch (e) {
           
        }  
    }
    
    function DragCircleGB(){
        
        try {
            if (!bLoad || typeof (drawingManager) == undefined) {
                return;
            }
            PanTool();
            drawingManager.setDrawingMode(BMAP_DRAWING_CIRCLE);
            drawingManager.open();
        }
        catch (e) {
           
        } 
    }
    
    var bDragRectangleGB = false;
    function DragRectangleGB() {
        if (bDragRectangleGB) {
            return;
        }
        try {
            if (!bLoad || typeof (drawingManager) == undefined) {
                return;
            }
            PanTool();
            bDragRectangleGB = true;
            drawingManager.setDrawingMode(BMAP_DRAWING_RECTANGLE);
            drawingManager.open();
        }
        catch (e) {
           
        }  
    }

    var bDelPoint = false;
    function DelPoint() {
        try {
            PanTool();
            bDelPoint = true;
        }
        catch (e) { 
        
        }
    }

    var arrLineRoads = new Array();
    var lineRoaddblclick;
    var lineRoadclick;
    var lineRoadMousemove;
    var labelLineRoads;
    
    function DrawLineRoad() {
        try {
            PanTool();
            
            map.setDefaultCursor("crosshair"); //"crosshair"
            map.disableDoubleClickZoom();
            ShowLineRoad(2, '');
//            map.enableDoubleClickZoom();
            arrLineRoads.splice(0, arrLineRoads.length);
            arrLineRoads.length = 0;
            map.addEventListener("mousemove", lineRoadMousemove = function(e) {
                if (labelLineRoads == undefined) {
                    var opts = {
                        position: e.point,    // 指定文本标注所在的地理位置
                        offset: new BMap.Size(20, 20)    //设置文本偏移量

                    }
                    labelLineRoads = new BMap.Label("右键结束编辑！", opts);  // 创建文本标注对象
                    labelLineRoads.setStyle({
                        color: "red",
                        fontSize: "12px",
                        height: "20px",
                        lineHeight: "20px",
                        fontFamily: "微软雅黑"
                    });
                    map.addOverlay(labelLineRoads);
                }
                else {
                    labelLineRoads.setPosition(e.point);
                    labelLineRoads.show();
                }
            });
            map.addEventListener("rightclick", lineRoaddblclick = function(e) {
                map.enableDoubleClickZoom();
                map.removeEventListener("rightclick", lineRoaddblclick);
                map.removeEventListener("click", lineRoadclick);
                map.removeEventListener("mousemove", lineRoadMousemove);
                lineRoadclick = undefined;
                lineRoaddblclick = undefined;
                for (var i = 0; i < arrLineRoads.length; i++) {
                    map.removeOverlay(arrLineRoads[i]);
                }
                if (arrLineRoads.length < 3) {
                    arrLineRoads = new Array();
                    PanTool();
                    return;
                }
                var sPoint = "";
                sPoint = arrLineRoads[0].getPosition().lng + "," + arrLineRoads[0].getPosition().lat;
                for (var i = 1; i < arrLineRoads.length / 2; i++) {
                    sPoint = sPoint + ";" + arrLineRoads[i * 2].getPosition().lng + "," + arrLineRoads[i * 2].getPosition().lat;
                }
                var iCheckTemp = 1;
                if (arrLineRoads.length >= 2) {
                    window.external.ShowDrawRoadForm("'" + sPoint + "'", iCheckTemp);
                }
                arrLineRoads = new Array();
                PanTool();
            });
            map.addEventListener("click", lineRoadclick = function(e) {
                if (arrLineRoads.length == 0) {
                    var marker1 = new BMap.Marker(e.point, { title: arrLineRoads.length, enableDragging: true });  // 创建标注//e.point.lng, e.point.lat
                    map.addOverlay(marker1);              // 将标注添加到地图中
                    arrLineRoads.push(marker1);
                    marker1.addEventListener('dragend', function(e) {
                        arrLineRoads[0] = marker1;
                        if (arrLineRoads.length > 2) {
                            var myIcon = new BMap.Icon(SetBaiduMidArrows(e.point, arrLineRoads[2].getPosition()), new BMap.Size(24, 24));
                            arrLineRoads[2].setIcon(myIcon);
                            var arrLinePoints = new Array;
                            arrLinePoints.push(e.point, arrLineRoads[2].getPosition());
                            arrLineRoads[1].setPath(arrLinePoints);
                        }
                        //                        ShowInfo(e.point.lng + ', ' + e.point.lat);
                    })
                }
                else {
                    if (arrLineRoads.length / 2 > 99) {
                        ShowInfo("线路点不能超过100个！");
                        return;
                    }
                    var polyline = new BMap.Polyline([
                      arrLineRoads[arrLineRoads.length - 1].getPosition(),
                      e.point
                    ], { strokeColor: "blue", strokeWeight: 3, strokeOpacity: 0.5 });
                    map.addOverlay(polyline);
                    var myIcon = new BMap.Icon(SetBaiduMidArrows(arrLineRoads[arrLineRoads.length - 1].getPosition(), e.point), new BMap.Size(24, 24));
                    var marker2 = new BMap.Marker(e.point, { icon: myIcon, title: arrLineRoads.length, enableDragging: true });  // 创建标注
                    map.addOverlay(marker2);              // 将标注添加到地图中
                    arrLineRoads.push(polyline);
                    arrLineRoads.push(marker2);

                    marker2.addEventListener('dragend', function(e) {
                        var thisID = Number(marker2.getTitle()) + Number(1);
                        arrLineRoads[thisID] = marker2;
                        if (arrLineRoads.length > 2) {
                            var myIcon = new BMap.Icon(SetBaiduMidArrows(arrLineRoads[thisID - 2].getPosition(), e.point), new BMap.Size(24, 24));
                            arrLineRoads[thisID].setIcon(myIcon);
                            var arrLinePoints = new Array;
                            arrLinePoints.push(arrLineRoads[thisID - 2].getPosition(), e.point);
                            arrLineRoads[thisID - 1].setPath(arrLinePoints);
                            if (arrLineRoads.length - thisID >= 3) {
                                myIcon = new BMap.Icon(SetBaiduMidArrows(e.point, arrLineRoads[thisID + 2].getPosition()), new BMap.Size(24, 24));
                                arrLineRoads[thisID + 2].setIcon(myIcon);
                                arrLinePoints = new Array;
                                arrLinePoints.push(e.point, arrLineRoads[thisID + 2].getPosition());
                                arrLineRoads[thisID + 1].setPath(arrLinePoints);
                            }
                        }
                        //                        ShowInfo(e.point.lng + ', ' + e.point.lat);
                    })
                }
            });
        }
        catch (e) { 
        
        }
    }

    function ShowLineRoad(doType, pointsCheck, points)//1显示，2隐藏
    {
        try {
            for (var i = 0; i < arrLineRoads.length; i++) {
                map.removeOverlay(arrLineRoads[i]);
            }
            if (doType == 2) {
                return;
            }
            PanTool();
            arrLineRoads.length = 0;
            //开始显示图标
            var pontsLatLng = pointsCheck.split(";");
            var PreLatLng;
            for (var ii = 0; ii < pontsLatLng.length; ii++) {
                var latlng = new BMap.Point(pontsLatLng[ii].split(",")[1], pontsLatLng[ii].split(",")[0]);
                if (ii == 0) {
                    if (map.getZoom() < 15) {
                        map.centerAndZoom(latlng, 15);  //初始化时，即可设置中心点和地图缩放级别。
                    }
                    else {
                        map.setCenter(latlng);
                    }
//                    map.setZoom(15);  //将视图切换到指定的缩放等级，中心点坐标不变    
                    var marker1 = new BMap.Marker(latlng, { title: arrLineRoads.length, enableDragging: true });  // 创建标注//e.point.lng, e.point.lat
                    map.addOverlay(marker1);              // 将标注添加到地图中
                    arrLineRoads.push(marker1);
                    marker1.addEventListener('dragend', function(e) {
                        arrLineRoads[0] = marker1;
                        if (arrLineRoads.length > 2) {
                            var myIcon = new BMap.Icon(SetBaiduMidArrows(e.point, arrLineRoads[2].getPosition()), new BMap.Size(24, 24));
                            arrLineRoads[2].setIcon(myIcon);
                            var arrLinePoints = new Array;
                            arrLinePoints.push(e.point, arrLineRoads[2].getPosition());
                            arrLineRoads[1].setPath(arrLinePoints);
                        }
                        window.external.UpdateDrawRoadForm("'" + e.point.lat + "," + e.point.lng + "'", 1, 0); 
                    })
                }
                else {
                    var polyline = new BMap.Polyline([
                      arrLineRoads[(ii -1) * 2].getPosition(),
                      latlng
                    ], { strokeColor: "blue", strokeWeight: 3, strokeOpacity: 0.5 });
                    map.addOverlay(polyline);
                    var myIcon = new BMap.Icon(SetBaiduMidArrows(arrLineRoads[(ii - 1) * 2].getPosition(), latlng), new BMap.Size(24, 24));
                    var marker2 = new BMap.Marker(latlng, { icon: myIcon, title: arrLineRoads.length, enableDragging: true });  // 创建标注
                    map.addOverlay(marker2);              // 将标注添加到地图中
                    arrLineRoads.push(polyline);
                    arrLineRoads.push(marker2);

                    marker2.addEventListener('dragend', function(e) {
                        var thisID = Number(this.getTitle()) + Number(1);
//                        arrLineRoads[thisID] = marker2;
                        if (arrLineRoads.length > 2) {
                            var myIcon = new BMap.Icon(SetBaiduMidArrows(arrLineRoads[thisID - 2].getPosition(), e.point), new BMap.Size(24, 24));
                            arrLineRoads[thisID].setIcon(myIcon);
                            var arrLinePoints = new Array;
                            arrLinePoints.push(arrLineRoads[thisID - 2].getPosition(), e.point);
                            arrLineRoads[thisID - 1].setPath(arrLinePoints);
                            if (arrLineRoads.length - thisID >= 3) {
                                myIcon = new BMap.Icon(SetBaiduMidArrows(e.point, arrLineRoads[thisID + 2].getPosition()), new BMap.Size(24, 24));
                                arrLineRoads[thisID + 2].setIcon(myIcon);
                                arrLinePoints = new Array;
                                arrLinePoints.push(e.point, arrLineRoads[thisID + 2].getPosition());
                                arrLineRoads[thisID + 1].setPath(arrLinePoints);
                            }
                        }
                        window.external.UpdateDrawRoadForm("'" + e.point.lat + "," + e.point.lng + "'", 1, (thisID / 2));    
                        //                        ShowInfo(e.point.lng + ', ' + e.point.lat);
                    })
                }
            }
        }
        catch (e) {
        }
    }
    
    function DrawLineRoadClick()
    {
        try
        {
            
        }
        catch(e)
        {
            
        }
    }

    //以下是围栏定义
    var bRectVehicle = false;
    function RectVehicle() {
        try {
            if (!bLoad || typeof (drawingManager) == undefined) {
                return;
            }
            PanTool();
            bRectVehicle = true;
            drawingManager.setDrawingMode(BMAP_DRAWING_RECTANGLE);
            drawingManager.open();
            //            clearDrawAll();
        }
        catch (e) {
            //            ShowInfo(e.message);
        }
    }

    function PanTool() {
        try {
            if (bLoad) {
                bDelNode = false;
                bDelPoint = false;
                bDragRectangle = false;
                bDragRectangleGB = false;
                bRectVehicle = false;
                bDragPolygonShapeGB =false;
                bDragPolygonShape = false;
                if (bPlaceDefine) {
                    bPlaceDefine = false;
                    map.removeEventListener("click", labelClickEvent);
                }
                //            map.setDefaultCursor("pointer");指尖方式
                map.setDefaultCursor("url('51ditu/baiduhand.cur')"); //http://api.map.baidu.com/images/openhand.cur
                if (drawingManager != undefined) {
                    drawingManager.close();
                }
                map.enableDoubleClickZoom();
                if (lineRoaddblclick != undefined) {
                    map.removeEventListener("rightclick", lineRoaddblclick);
                    lineRoaddblclick = undefined;
                }
                if (lineRoadclick != undefined) {
                    map.removeEventListener("click", lineRoadclick);
                    lineRoadclick = undefined;
                }
                if (lineRoadMousemove != undefined)
                {
                    map.removeEventListener("mousemove", lineRoadMousemove);
                    lineRoadMousemove = undefined;
                }
                if (labelLineRoads != undefined) {
                    labelLineRoads.hide();
                }
            }
        }
        catch (e) { 
            
        }
    }
    
    //行政区域
    function AddMarkFromPolitical(area,city)
    {
        var thisGeocoder = new BMap.Geocoder();
        thisGeocoder.getPoint(area,AddMark,city);
        getBoundary(area);
    }
    
    //行政区域
    function AddMarkFromPoliticalOnly(area,city)
    {
        var thisGeocoder = new BMap.Geocoder();
        map.clearOverlays();        //清除地图覆盖物    
        thisGeocoder.getPoint(area,AddMark,city);
        var bdary = new BMap.Boundary();
        bdary.get(area, function(rs){       //获取行政区域  
            var count = rs.boundaries.length; //行政区域的点有多少个
            if(count >0)
            {
                for(var i = 0; i < count; i++){
                    var ply = new BMap.Polygon(rs.boundaries[i], {strokeWeight: 2, strokeColor: "#ff0000"}); //建立多边形覆盖物
                    map.addOverlay(ply);  //添加覆盖物
                    if(i == 0)
                    {
                        map.setViewport(ply.getPath());    //调整视野  
                    }
                }
                return;
            }    
        }); 
    }
    
    function HidePolylinePosition(cid)
    {
        for(var i = 0; i < arrPolylinePosition.length; i++)
        {
            if(cid == arrPolylinePosition[i].id)
            {
                map.removeOverlay(arrPolylinePosition[i].lay); 
                arrPolylinePosition.splice(i, 1);
                return;
            }
        }
    }
    
    function HidePoliticalAllLays(cid)
    {
        map.clearOverlays();
    }
    
    function AddMark(point)
    {
        if(point == undefined || point == null)
        {
            ShowInfo("添加图标失败，找不到该地址！");
            return;
        }
//        map.clearOverlays();
        var marker1 = new BMap.Marker(point);  // 创建标注
        map.addOverlay(marker1);              // 将标注添加到地图中
        var iZoom = map.getZoom();
        if(iZoom < 11)
        {
            iZoom = 11;
        }
        map.centerAndZoom(point,iZoom);
    }
    
    function getBoundary(area){       
        var bdary = new BMap.Boundary();
        var sValues = "";
        bdary.get(area, function(rs){       //获取行政区域  
            var count = rs.boundaries.length; //行政区域的点有多少个
            if(count >0)
            {
                for(var i = 0; i < count; i++){
                    if(i == 0)
                    {
                        sValues = rs.boundaries[i];
                    }
                    else
                    {
                       sValues = sValues + "-" + rs.boundaries[i]; 
                    }
                    var ply = new BMap.Polygon(rs.boundaries[i], {strokeWeight: 2, strokeColor: "#ff0000"}); //建立多边形覆盖物
                    map.addOverlay(ply);  //添加覆盖物
                    if(i == 0)
                    {
                        map.setViewport(ply.getPath());    //调整视野  
                    }
                }
                window.external.AddBoundary(sValues);
                return;
            }
            else
            {
                window.external.AddBoundary(sValues);
            }      
        }); 
    }
    
    var bDragPolygonShape = false;
    function startDragPolygonShape()
    {
        try {
            if (!bLoad || typeof (drawingManager) == undefined) {
                return;
            }
            PanTool();
            drawingManager.setDrawingMode(BMAP_DRAWING_POLYLINE);
            drawingManager.open();
            bDragPolygonShape= true;
        }
        catch (e) {
            
        }
    }
      
    var bDragPolygonShapeGB = false;
    function startDragPolygonShapeGB()
    {
        try {
            if (!bLoad || typeof (drawingManager) == undefined) {
                return;
            }
            PanTool();
            drawingManager.setDrawingMode(BMAP_DRAWING_POLYLINE);
            drawingManager.open();
            bDragPolygonShapeGB= true;
        }
        catch (e) {
            
        }
    }
    
    var arrPolylinePosition = new Array();
    function ShowPolyline(cid,sPoint)
    {
    try
    {
        var arrPolylinePoints = new Array();
        var arrLatLng = sPoint.split(';');
        for(var i = 0;i<arrLatLng.length;i++)
        {
            var sLatLng = new BMap.Point(parseFloat(arrLatLng[i].split(',')[1]), parseFloat(arrLatLng[i].split(',')[0]));
            arrPolylinePoints.push(sLatLng);
        }
        var sLatLng2 = new BMap.Point(parseFloat(arrLatLng[0].split(',')[1]), parseFloat(arrLatLng[0].split(',')[0]));
        arrPolylinePoints.push(sLatLng2);
//        arrPolylinePoints.push(new BMap.Point(114.399, 23.910));
//		arrPolylinePoints.push(new BMap.Point(116.405, 26.920));  
        for(var i = 0; i < arrPolylinePosition.length; i++)
        {
            if(arrPolylinePosition[i].id == cid)
            {
                map.setViewport(arrPolylinePoints);    //调整视野 
                return;
            }
        }
        var polyline = new BMap.Polyline(arrPolylinePoints, {strokeColor:"blue", strokeWeight:2, strokeOpacity:0.5});   //创建折线
	    map.addOverlay(polyline);   //增加折线
	    arrPolylinePosition.push({"id":cid, lay: polyline});
	    map.setViewport(arrPolylinePoints);    //调整视野  
	    }
	    catch(e)
	    {
//	        ShowInfo(e.message);
	    }
    }
    
    function GetShortDistance(lon1, lat1, lon2, lat2)
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
   
   var objDrivingRoute = undefined;
   function clearDrivingRoute()
   {
        if(objDrivingRoute != undefined)
        {
            objDrivingRoute.clearResults();
        }
        objDrivingRoute = undefined;
        var oMap=document.getElementById('map');//获得元素
        oMap.focus();
        var o=document.getElementById('r-result');//获得元素
        o.style.position='';
   }
   
   function JsDrivingRoute(sStart, sEnd, iType)  
   {
        clearDrivingRoute();
        var o=document.getElementById('r-result');//获得元素
        o.style.position='absolute';
        var oMap=document.getElementById('map');//获得元素
        o.style.top =oMap.offsetHeight - 150;
        o.focus();
        if(iType == 1)
        {
            objDrivingRoute = new BMap.DrivingRoute(map,{
		        renderOptions: {
			        map: map,
			        panel: "r-result",
			        enableDragging : true //起终点可进行拖拽
		        }
	        });
	        objDrivingRoute.search(sStart,sEnd);
        }
        else
        {
            var sLngLat = sStart.split(',');
            var point1 = new BMap.Point(sLngLat[0], sLngLat[1]);
            objDrivingRoute = new BMap.DrivingRoute(map, {
		        renderOptions: {
			        map: map,
			        panel: "r-result",
			        enableDragging : true //起终点可进行拖拽
		        } 
	        });
	        objDrivingRoute.search(point1,sEnd);
        }
   }   
</script>