<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FormGoogleMap.aspx.cs" Inherits="Htmls_FormGoogleMap" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    <title><% =Resources.Lan.GoogleMap %></title>
    <style type="text/css">
        body, html,#map {width: 100%;height: 100%;overflow: hidden;margin:0;}
        @font-face {
		    font-family: BaiduCar;
		    /*src: url(../EasyUI/Font/cherl.ttf);
		    src: url(../EasyUI/Font/cherl.eot)\9;*/
		    src:url('../EasyUI/Font/cherl.eot');  
            src:local('BaiduCar Regular'),  
                url('../EasyUI/Font/cherl.eot?#iefix') format('embedded-opentype'),  
                url('../EasyUI/Font/cherl.woff') format('woff'),  
                url('../EasyUI/Font/cherl.ttf') format('truetype'),  
                url('../EasyUI/Font/cherl.svg#webfontOTINA1xY') format('svg');  
                font-weight:normal;  
                font-style:normal; 
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
    <link href="../Css/index.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" type="text/css" href="../EasyUI/themes/default/easyui.css" />  
    <link rel="stylesheet" type="text/css" href="../EasyUI/themes/color.css"/> 
    <link rel="stylesheet" type="text/css" href="../EasyUI/themes/icon.css"/> 
    <script type="text/javascript" src="../EasyUI/jquery.min.js"></script>  
    <script type="text/javascript" src="../EasyUI/jquery.easyui.min.js"></script> 
    <!-- <script	src="http://ditu.google.cn/?file=api&amp;v=3.x&amp;hl=zh-CN&amp;key=ABQIAAAAtiQHi6P1KYBHDBwqFMk8-RRxLBl31PV58VnGj4prUHlOIdNepBR9h0tX3BZXnOpF3TgHT8brJv06dw&hl"type="text/javascript"></script>-->
    <script	src="http://ditu.google.cn/maps/api/js?v=3.x&key=AIzaSyDywdVGQZV8oTZ3IIifOsNgRuJGlOPKbzQ&sensor=false&language=<% =Resources.Lan.ThisLan %>" type="text/javascript"></script>
     <script src="../Js/Google/maplabel.js?v=2"></script>
     <script language="javascript" type="text/javascript" src="../Js/Google/GoogleLatLngCorrect.js"></script>
     <%--<script language="javascript" type="text/javascript" src="../Js/Google/Revise_LatLon.js"></script>
    <script language="javascript" type="text/javascript" src="../Js/Google/Cph.js"></script>
    <script language="javascript" type="text/javascript" src="../Js/Google/publicjs.js"></script>
    <script language="javascript" type="text/javascript" src = "../Js/Google/LabelMarker.js"></script>
    <script language="javascript" type="text/javascript" src = "../Js/Google/LineOverlay.js"></script>--%>
    <style type="text/css">
        v\:* {      behavior:url(#default#VML);    }
        .CphStyle
        {   position:absolute;
            font-size:11px;
            color:white;
            filter: glow(Color=red,Strength=4);  
        }
    </style>
</head>

<script language="javascript" type="text/javascript">   var sLan = "<% =Resources.Lan.Language  %>";//   if(sLan == "zh")//   {//       try//       {//            document.write("<script src='http://ditu.google.cn/maps/api/js?v=3.x&key=AIzaSyDywdVGQZV8oTZ3IIifOsNgRuJGlOPKbzQ&sensor=false&language=zh-CN'><\/script>");//       }//       catch(e)//       {}//       document.write("<script src='../Js/Google/maplabel.js?v=2'><\/script>");//   }//   else//   {//        try//        {//            document.write("<script src='http://ditu.google.cn/maps/api/js?v=3.x&key=AIzaSyDywdVGQZV8oTZ3IIifOsNgRuJGlOPKbzQ&sensor=false&language=en-US'><\/script>");////            document.write("<script src='https://maps.googleapis.com/maps/api/js?key=AIzaSyDywdVGQZV8oTZ3IIifOsNgRuJGlOPKbzQ'><\/script>");//        }//       catch(e)//       {}//        document.write("<script src='../Js/Google/maplabel.js?v=2'><\/script>");//   }           function SetTreeVeh(vehID,cph)   {//       iSearchID = vehID.substring(1);
//       $('#txtVeh').val(cph);   }
   
   function CarInfo(objectcode) {
　　this.lastpoint = null;
　　this.objectcode = objectcode;
　　this.arrline = new Array();　
　　};
　　
    var map;
    var geocoder = null;
  // 创建汽车图标
    var pointsBAK=null;
    var car=null;
    var iconArray=new Array(32);
    setIconDirect();
    
    var iconURL = '51ditu/';
    var statusType = '';
    var vehicleType = '';
    var rect=null;
    var marker=null;
    var car=null;
    var strObjectCode='';
    var strLon=null;
    var strLat=null;
    var tooltype=0;
    var ctrlMapType=null;
    var downX=0;
    var downY=0;
    var moveX=0;
    var moveY=0;
    var ifPress=false;
    var newrect=null;
    var arrPoly=new Array();
    var lastpoint=null;
    var polyLine1=null;
    var polystartpoint=null;
    var arrTracker=new Array();
    var Locatemarker=null;
    //list
    var MarkList=new Array();
    var TrackList=new Array();
    //map choice
    var CurrentMapType=null;
    //

   //画线路
   var gdirDrawLine;
   var marker2DrawLine;
   var hasMarkerDrawLine = false;
   var polylineDrawLine =new Array();
   var pointsDrawLine = new Array();
   var markerDrawLineLst = new Array();
    var overlays = []; //围栏，多边形等等
  <!-- Hide

      function killErrors() {
      return true;
    }

    window.onerror = killErrors;
   // -->
   

    
    
    function DealBtnEvent()
    {
      if (tooltype==0)
      {
      }
      else
      if (tooltype==1)//放大
      {
        map.zoomIn();
      }
      else
      if (tooltype==2)
      {
        map.zoomOut();
      }
      else
      if (tooltype==3)
      {
        
      }
    }
    
    function SetToolType(maptooltype)
    {
      if (!map.draggingEnabled()) 
      {
        GEvent.clearListeners(map.getDragObject(), "mousedown");
        GEvent.clearListeners(map, "mousemove");
        GEvent.clearListeners(map.getDragObject(), "mouseup");
        map.enableDragging();
      }
      tooltype=maptooltype;
      
      if (tooltype==3)
      {
        map.disableDragging();
        GEvent.addListener(map.getDragObject(), "mousedown", onmousedown);
        GEvent.addListener(map, "mousemove", mousemove);
        GEvent.addListener(map.getDragObject(), "mouseup", onmouseup);
      }
    }
    
   function onmousedown()
   {
     downX = window.event.x;
     downY = window.event.y - 29;
     ifPress=true;
     if (newrect != null)
     {
       map.removeOverlay(newrect); 
     }
     if (rect != null)
     {
       map.removeOverlay(rect); 
     }
   } 
   
   function mousemove()
   {
     if (ifPress==true)
     {
       if ((moveX != 0) && (moveY != 0))
       {
         if (newrect != null)
         {
           map.removeOverlay(newrect); 
          }
       }
       moveX=window.event.x;
       moveY=window.event.y - 29;
      
      var points = new Array();
      var pos=new google.maps.Point(Math.min(downX, moveX),Math.min(downY, moveY));
      var pos1=new google.maps.Point(Math.max(downX, moveX),Math.min(downY, moveY));
      var pos2=new google.maps.Point(Math.max(downX, moveX),Math.max(downY, moveY));
      var pos3=new google.maps.Point(Math.min(downX, moveX),Math.max(downY, moveY));
      var point1=map.fromContainerPixelToLatLng(pos);
      var point2=map.fromContainerPixelToLatLng(pos1);
      var point3=map.fromContainerPixelToLatLng(pos2);
      var point4=map.fromContainerPixelToLatLng(pos3);
      var point5=map.fromContainerPixelToLatLng(pos);
      points.push(point1);
      points.push(point2);
      points.push(point3);
      points.push(point4);
      points.push(point5);
      newrect = new google.maps.Polyline( points,"#f33f00", 5);
		map.addOverlay(newrect);
       
     }
   } 
   
   function onmouseup()
   {
     if (ifPress==true)
     {
       ifPress=false;
       downX=0;
       downY=0;
       moveX=0;
       moveY=0;
       document.getElementById('RectMinLon').value=newrect.getBounds().getSouthWest().lng();
       document.getElementById('RectMinLat').value=newrect.getBounds().getSouthWest().lat();
       document.getElementById('RectMaxLon').value=newrect.getBounds().getNorthEast().lng();
       document.getElementById('RectMaxLat').value=newrect.getBounds().getNorthEast().lat();
     }
   } 
   
//   function Rectangle(bounds, opt_weight, opt_color, opt_name, opt_click) {
//            this.bounds_ = bounds;
//            this.weight_ = opt_weight || 2;
//            this.color_ = opt_color || "#0000FF";
//            this.name_ = opt_name || "";
//            this.onclick_ = opt_click || undefined;
//        }
//        Rectangle.prototype = new GOverlay();

//        Rectangle.prototype = new google.maps.OverlayView();

//        // 创建表示此矩形的 DIV.
//        Rectangle.prototype.initialize = function(map) {
//            // 创建表示我们的矩形的 DIV
//            var div = document.createElement("div");
//            div.style.border = this.weight_ + "px solid " + this.color_;
//            div.style.position = "absolute";
//            div.style.color = "blue";
//            div.style.whiteSpace = "nowrap";
//            div.style.wordwrap = "break-word"; 
//            div.style.textAlign = "center";
////            div.style.backgroundColor = "#FFFFFF";
////            div.style.filter = "alpha(opacity=30,finishopacity=100)";
//            div.innerHTML = "<b>" + this.name_ + "</b>";
//            if(this.onclick_ != undefined)
//            {
//                var divClick_ = this.onclick_;
//                div.onclick=function divOnclick()
//                {
//                    divClick_();
//                }
//            }
//            // 我们的矩形相对于地图是平面，所以将其添加到MAP_PANE 面板，
//            // 与地图本身的绘制顺序相同（即在标记阴影下方）
//            map.getPane(G_MAP_MAP_PANE).appendChild(div);

//            this.map_ = map;
//            this.div_ = div;
//        }

//        // 从地图面板删除 DIV
//        Rectangle.prototype.remove = function() {
//            this.div_.parentNode.removeChild(this.div_);
//        }

//        // 将我们的数据复制到新的矩形
//        Rectangle.prototype.copy = function() {
//            return new google.maps.Rectangle(this.bounds_, this.weight_, this.color_,
//                           this.backgroundColor_, this.opacity_);
//        }

//        // 基于当前投影和缩放级别重新绘制矩形
//        Rectangle.prototype.redraw = function(force) {
//            // We only need to redraw if the coordinate system has changed
//            if (!force) return;

//            // 计算边界两个对角的 DIV 坐标，获取矩形的尺寸和位置
//            var c1 = this.map_.fromLatLngToDivPixel(this.bounds_.getSouthWest());
//            var c2 = this.map_.fromLatLngToDivPixel(this.bounds_.getNorthEast());

//            // 现在基于边界的 DIV 坐标放置 DIV
//            this.div_.style.width = Math.abs(c2.x - c1.x) + "px";
//            this.div_.style.height = Math.abs(c2.y - c1.y) + "px";
//            this.div_.style.left = (Math.min(c2.x, c1.x) - this.weight_) + "px";
//            this.div_.style.top = (Math.min(c2.y, c1.y) - this.weight_) + "px";
//        }
   
     var beginlatlng = "";//记录起始点坐标
     var endlatlng = "";//记录结束点坐标
//     var rectBounds = "";
     var SfClick = "";
     var SfMove = "";
     var ClickCount = 0;//点击次数
     var rectBounds = new google.maps.Rectangle();       
     var rectOptions = {
        strokeColor: "#FF0000",
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: "#FF0000",
        fillOpacity: 0.35,     
        clickable:false       
    };
    var bMapLoad = false;
        
    function SetSelectVeh()
    {
        if(!bMapLoad)
        {
            return;
        }
       window.parent.window.SetSelectVehToMap("<% =Resources.Lan.GoogleMap %>");
       window.parent.window.SetVehLoginMap();
    }
    
    function UpdateZoom()
    {    
        if(bMapLoad)
        {
            var iZoom = map.getZoom();
            if(iZoom <= 4)
            {
                map.setZoom(iZoom + 1);
                map.setZoom(iZoom);
            }
            else
            {
                map.setZoom(iZoom - 1);
                map.setZoom(iZoom);
            }
        }
    }
    
    function load() 
    {    
//      if (GBrowserIsCompatible()) 
//      {
       var mapOptions =
        {
            zoom: 9,
            center: new google.maps.LatLng(32.067428,118.790243),
            overviewMapControl: true,
            scaleControl:true   
            
            };
       
       var sIcon = "../Img/Baidu/baiducar.gif";
       map = new google.maps.Map(document.getElementById("map"),mapOptions);
       var mapLabel = new MapLabel({
          text: ' ',
          position: new google.maps.LatLng(30.910400, 108.362240),
          map: map,
          fontSize: 32,
          align: 'center',
          fontFamily:'BaiduCar'
        });
        bMapLoad = true;
//      var marker = new google.maps.Marker({icon: sIcon});
//        marker.bindTo('map', mapLabel);
//        marker.bindTo('position', mapLabel);
//        marker.setDraggable(true);
//        marker.addListener('click', toggleBounce);
//        mapLabel.set('fontFamily', 'BaiduCar');
//        marker.setMap(null);
        setTimeout(SetSelectVeh,3000);
       gdirDrawLine = new google.maps.DirectionsRenderer();
       gdirDrawLine.setMap(map); 
       
//       NodeDefine();
//       DrawLineRoad();         
//      
      
//        map = new GMap2(document.getElementById("map"), { googleBarOptions: { showOnLoad: true} });
//        gdirDrawLine = new GDirections(map);
        
            //设置地图的缩放工具
//            map.setUIToDefault();
            //缩略图
//            map.addControl(new GOverviewMapControl);
        
        
//        map.addControl(new GScaleControl());//添加比例尺
        //ctrlMapType=new GMapTypeControl();
        //map.addControl(ctrlMapType);//地图类型转换
        //添加地图移动缩放控件
       /*  map.addControl(new GOverviewMapControl()); //鹰眼图
        */
//       
//        map.enableScrollWheelZoom();//滑动缩放 

//       var center = new google.maps.LatLng(30.910400, 108.362240);
//       map.setCenter(center, 5);
       
            CurrentMapType = "地图";
            
             // 添加自定义的控件
//            geocoder = new GClientGeocoder();
            geocoder = new google.maps.Geocoder();
//            GEvent.addDomListener(map, 'maptypechanged', function()   
//            {   
//                ChangeMap(map.getCurrentMapType().getName(false));   
//            });
//            DrawLineRoad();
//       ShowLineRoad(1, '22.647639,114.046269;22.647879,114.045649;22.648189,114.045139;22.648289,114.045239;22.648389,114.045339','22.647639,114.046269;22.647879,114.045649;22.648189,114.045139;22.648289,114.045239;22.648389,114.045339');    
       //map.setMapType(G_HYBRID_MAP);
       //document.getElementById('MapInit').value='T';
       // 添加地图的事件处理
       //GEvent.addListener(map, "click", function() {DealBtnEvent()});
//       ShowNode('116.045449,24.648479;115.043104,23.645918','wu_2d','127');

//       UpdateNode(127,"test");
//         AddOrMoveObject(9398,'wu_2D',114.0406,22.6503,114.045589,22.647449,0,301,12,'ACC关(熄火) 油路正常 停转;定位 GPS天线正常 电源正常 ',1,22,1,'0',0,'2013-11-19 13:27:35','','Offline');
//         AddOrMoveObject(9398,'wu_2D',114.2406,22.8503,114.045589,22.647449,0,301,12,'ACC开(开火) 油路正常 停转;定位 GPS天线正常 电源正常 ',1,22,1,'0',1,'2013-11-19 13:27:35','','Offline');
//           ShowLineRoad(1,'33.72433966,101.86523438;29.19053283,104.10644531;29.99300228,110.25878906;32.62087018,110.87402344;35.13787912,109.55566406','33.72621366,101.86365138;29.19328183,104.10396131;29.99555728,110.25387006;32.62320218,110.86878744;35.13875712,109.55062706');
//      }
    }
    
    var DrawRoadSingleRightClick;
    var DrawRoadDbClick;
    var DrawRoadClick;
    function DrawLineRoad()
    {
        ShowLineRoad(2,'');
        hasMarkerDrawLine = false;
        pointsDrawLine = new Array();
        markerDrawLineLst = new Array();
        polylineDrawLine=new Array();
        if(DrawRoadClick!=undefined)
        {
            google.maps.event.removeListener(DrawRoadClick);
        }
        if(DrawRoadSingleRightClick!=undefined)
        {
            google.maps.event.removeListener(DrawRoadSingleRightClick);
        }
        if(DrawRoadDbClick!=undefined)
        {
            google.maps.event.removeListener(DrawRoadDbClick);
        }
//        DrawRoadSingleRightClick = google.maps.event.addListener(map,"singlerightclick", function(pixel, tile){
        DrawRoadSingleRightClick = google.maps.event.addListener(map,"rightclick", function(event){
            hasMarkerDrawLine = true;
//            for (var i=0; i<=gdirDrawLine.getNumRoutes(); i++)
//            {
//                var originalMarker = gdirDrawLine.getMarker(i);
//                try
//                {
//                    map.removeOverlay(originalMarker);
//                }
//                catch(e)
//                {}
//            }
            for (var i=0;i<markerDrawLineLst.length;i++)
            {
//                map.removeOverlay(markerDrawLineLst[i]);
                markerDrawLineLst[i].setMap(map);
            }
            for(var i=0;i<polylineDrawLine.length;i++)
            {
//                map.removeOverlay(polylineDrawLine[i]);
                polylineDrawLine[i].setMap(map);
            }
            google.maps.event.removeListener(DrawRoadClick);
            google.maps.event.removeListener(DrawRoadSingleRightClick);
            google.maps.event.removeListener(DrawRoadDbClick);
            var sPoint="";
            for(var i=0;i<pointsDrawLine.length ;i++)
            {
                if(i==0)
                {
                    sPoint = pointsDrawLine[i].ob + "," + pointsDrawLine[i].nb;
                }
                else
                {
                    sPoint = sPoint + ";" + pointsDrawLine[i].ob + "," + pointsDrawLine[i].nb;
                }
            }
            var iCheckTemp = 1;
//            if(map.getCurrentMapType().getName(false) == "混合地图")
            if(CurrentMapType == "混合地图")
            {
                iCheckTemp=1;
            }
            else
            {
                iCheckTemp = 1;
            }
            if(pointsDrawLine.length >=2)
            {
                window.external.ShowDrawRoadForm("'" + sPoint + "'",iCheckTemp);
                for (var i=0;i<markerDrawLineLst.length;i++)
                {
                    markerDrawLineLst[i].setMap(null);
                }
                for(var i=0;i<polylineDrawLine.length;i++)
                {
                    polylineDrawLine[i].setMap(null);
                }
                    
                        
              }
            pointsDrawLine = new Array();
            markerDrawLineLst = new Array();
            var pointsTemp=[];
//            gdirDrawLine.loadFromWaypoints(pointsTemp,{"preserveViewport":true});
        });
        
//        DrawRoadDbClick = google.maps.event.addListener(map,"dblclick", function(pixel, tile){
            DrawRoadDbClick = google.maps.event.addListener(map,"dblclick", function(event){
            hasMarkerDrawLine = true;
//            for (var i=0; i<=gdirDrawLine.getNumRoutes(); i++)
//            {
//                var originalMarker = gdirDrawLine.getMarker(i);
//                try
//                {
//                    map.removeOverlay(originalMarker);
//                }
//                catch(e)
//                {}
//            }
            for (var i=0;i<markerDrawLineLst.length;i++)
            {
//            map.removeOverlay(markerDrawLineLst[i]);
                markerDrawLineLst[i].setMap(map);
            }
            for(var i=0;i<polylineDrawLine.length;i++)
            {
//                map.removeOverlay(polylineDrawLine[i]);
                polylineDrawLine[i].setMap(map);
            }
            google.maps.event.removeListener(DrawRoadClick);
            google.maps.event.removeListener(DrawRoadSingleRightClick);
            google.maps.event.removeListener(DrawRoadDbClick);
            var sPoint="";
            for(var i=0;i<pointsDrawLine.length ;i++)
            {
                if(i==0)
                {
                    sPoint = pointsDrawLine[i].ob + "," + pointsDrawLine[i].nb;
                }
                else
                {
                    sPoint = sPoint + ";" + pointsDrawLine[i].ob + "," + pointsDrawLine[i].nb;
                }
            }
            var iCheckTemp = 1;
//            if(map.getCurrentMapType().getName(false) == "混合地图")
            if(CurrentMapType == "混合地图")
            {
                iCheckTemp=1;
            }
            else
            {
                iCheckTemp = 1;
            }
            if(pointsDrawLine.length >=2)
            {
                window.external.ShowDrawRoadForm("'" + sPoint + "'",iCheckTemp);
                for (var i=0;i<markerDrawLineLst.length;i++)
                {
                    markerDrawLineLst[i].setMap(null);
                }
                for(var i=0;i<polylineDrawLine.length;i++)
                {
                    polylineDrawLine[i].setMap(null);
                }    
            }
            pointsDrawLine = new Array();
            markerDrawLineLst = new Array();
            var pointsTemp=[];
//            gdirDrawLine.loadFromWaypoints(pointsTemp,{"preserveViewport":true});
        });
        
//        DrawRoadClick = google.maps.event.addListener(map,"click",function(overlay,latlng,overlaylatlng){
        DrawRoadClick = google.maps.event.addListener(map,"click",function(event){
            if(event.latLng == null || hasMarkerDrawLine == true){
                return;
            }
            if(pointsDrawLine.length == 0)
            {
//                var greenIcon = new GIcon(G_DEFAULT_ICON);
//    //            greenIcon.image = "../googlemap/green-dot.png";
//                greenIcon.iconSize = new GSize(32,32);
//                greenIcon.iconAnchor = new google.maps.Point(16,32);
//                greenIcon.shadowSize=new GSize(1,1);
    //            marker2DrawLine = new GMarker(latlng,{draggable: true,icon:greenIcon});
//                marker2DrawLine = new GMarker(latlng,{draggable: true,icon:greenIcon, title:markerDrawLineLst.length});
//                var image={
////                    url: 'images/beachflag.png',
//                    size: new google.maps.Size(32,32),
//                    origin: new google.maps.Point(1,1),
//                    anchor: new google.maps.Point(16,32)
//                };

                marker2DrawLine = new google.maps.Marker({map:map,draggable: true,title:markerDrawLineLst.length.toString(),position:event.latLng});
 
 
//                map.addOverlay(marker2DrawLine);
                markerDrawLineLst.push(marker2DrawLine);
                
                google.maps.event.addListener(marker2DrawLine, "dragend", function() {  
                          for(var i=0;i<markerDrawLineLst.length;i++)
                          {
                                if(markerDrawLineLst[i].getTitle() ==marker2DrawLine.getTitle())
                                {
                                    markerDrawLineLst[i] = marker2DrawLine;
                                    pointsDrawLine.splice(i,1,markerDrawLineLst[i].getPosition());
                                    if((1 + i * 2) >= polylineDrawLine.length)
                                    {
                                        break;
                                    }
                                     var points = new Array();
                                     points.push(markerDrawLineLst[i].getPosition());
                                     points.push(polylineDrawLine[1 + i * 2].getPosition());
                                     //定义线的形式
//                                     var polyLineNow= new google.maps.Polyline(points, "#FE0202", 2);
//                                     map.addOverlay(polyLineNow); //根据数组中的两点划线
//                                     map.removeOverlay(polylineDrawLine[i * 2]);
                                     var polyLineNow= new google.maps.Polyline({map:map,path:points,strokeColor:"#FE0202",strokeWeight:2});
                                     polylineDrawLine[i * 2].setMap(null);

                    
                                     polylineDrawLine.splice(i*2,1,polyLineNow);
                                     
                                     polylineDrawLine[1 + i * 2] = SetMidArrows(points,polylineDrawLine[1 + i * 2]);
                                }
                          }
                    });   
            }
//            GEvent.addListener(marker2DrawLine,"dragend",function(){
//                pointsDrawLine.push(marker2DrawLine.getLatLng());
//                gdirDrawLine.loadFromWaypoints(pointsDrawLine,{"preserveViewport":true});
//            })
//            GEvent.addListener(gdirDrawLine, "addoverlay", function(){
//                for (var i=0; i<=gdirDrawLine.getNumRoutes(); i++){
//                    var originalMarker = gdirDrawLine.getMarker(i);
//                    map.removeOverlay(originalMarker);
//                }
//                polylineDrawLine = gdirDrawLine.getPolyline();
//                polylineDrawLine.setStrokeStyle({color:"red",weight:2,opacity:1});

//            });
            hasMarkerDrawLine = false;
            if((polylineDrawLine.length / 2) >=99)//最多只能添加100个点
            {
                ShowInfo("线路点不能超过100个！");
                return;
            }
            pointsDrawLine.push(event.latLng);
            pointsTemp=[];
            for(var p = 0; p < pointsDrawLine.length; p++)
            {
                pointsTemp[p] = pointsDrawLine[p];
            }
            if(pointsTemp.length >=2)
            {
//                JudgeDrawArrow(map,pointsTemp[pointsTemp.length -2].x,pointsTemp[pointsTemp.length -2].y,pointsTemp[pointsTemp.length -1].x,pointsTemp[pointsTemp.length -1].y);
                // 画线
	            var points = new Array();
	            points.push(pointsDrawLine[pointsDrawLine.length - 2]);
	            points.push(event.latLng);
	            //定义线的形式
//	            var polyLineNow = new google.maps.Polyline(points, "#FE0202", 2);//	            
//	            map.addOverlay(polyLineNow); //根据数组中的两点划线
	            var polyLineNow = new google.maps.Polyline({map:map,path:points,strokeColor:"#FE0202",strokeWeight:2});
	            polylineDrawLine.push(polyLineNow);
                var arrowMark = midArrows(pointsTemp, polylineDrawLine.length);
                if(arrowMark != undefined)
                {
                    polylineDrawLine.push(arrowMark);
                    google.maps.event.addListener(arrowMark, "dragend", function(event) {  
                          for(var i=0;i<polylineDrawLine.length - 1;i++)
                          {
                                if(polylineDrawLine[1 + i].getTitle() ==this.getTitle())
                                {
//                                    pointsDrawLine.splice(i + 1,1,polylineDrawLine[i + 1].getLatLng());
                                         pointsDrawLine.splice(i + 1,1,polylineDrawLine[i + 1].getPosition());
                                     var points = new Array();
                                     if(i == 0)
                                     {
                                        points.push(markerDrawLineLst[0].getPosition());
                                     }
                                     else
                                     {
                                        points.push(polylineDrawLine[i - 1].getPosition());
                                     }
                                     points.push(polylineDrawLine[1 + i].getPosition());
                                     //定义线的形式
//                                     var polyLineNow= new google.maps.Polyline(points, "#FE0202", 2);
//                                     map.addOverlay(polyLineNow); //根据数组中的两点划线
//                                     map.removeOverlay(polylineDrawLine[i]);
                                     var polyLineNow = new google.maps.Polyline({map:map,path:points,strokeColor:"#FE0202",strokeWeight:2});
                                     polylineDrawLine[i].setMap(null);
                                     
                                     polylineDrawLine.splice(i,1,polyLineNow);
                                     polylineDrawLine[1 + i] = SetMidArrows(points,polylineDrawLine[1 + i]);
                                     if((3+i) < polylineDrawLine.length)
                                     {
                                        points = new Array();
                                        points.push(polylineDrawLine[1 + i].getPosition());
                                        points.push(polylineDrawLine[3 + i].getPosition());
                                        //定义线的形式
//                                         var polyLineNow= new google.maps.Polyline(points, "#FE0202", 2);
//                                         map.addOverlay(polyLineNow); //根据数组中的两点划线
//                                         map.removeOverlay(polylineDrawLine[i + 2]);
                                         
                                         var polyLineNow = new google.maps.Polyline({map:map,path:points,strokeColor:"#FE0202",strokeWeight:2});
                                         polylineDrawLine[i + 2].setMap(null);
                                         
                                         polylineDrawLine.splice(i + 2,1,polyLineNow);
                                         polylineDrawLine[3 + i] = SetMidArrows(points,polylineDrawLine[3 + i]);
                                     }
                                }
                                i++;
                          }
                    });   
                }
            }
//            gdirDrawLine.loadFromWaypoints(pointsTemp,{"preserveViewport":true});
        })
    }
    
    var lineRoadPoly = new Array();
    var s_PointsLineCheck = "";
    var s_PointsLineNoCheck = "";
    function ShowLineRoad(doType,pointsCheck,points)//1显示，2隐藏
    {
//        ShowInfo(doType + "|" + pointsCheck + "|" + points);
        hasMarkerDrawLine = true;
        try{
             pointsDrawLine = new Array();
//         for (var i=0; i<=gdirDrawLine.getNumRoutes(); i++)
//         {
//             var originalMarker = gdirDrawLine.getMarker(i);
//             if(originalMarker != undefined)
//             {
//                 try 
//                 {
//                map.removeOverlay(originalMarker);
//                }
//                catch(e)
//                {}
//             }
//         }
             for (var i=0;i<markerDrawLineLst.length;i++)
             {
//                map.removeOverlay(markerDrawLineLst[i]);
                markerDrawLineLst[i].setMap(null);
             } 
             for(var i=0;i<polylineDrawLine.length;i++)
             {
//                 map.removeOverlay(polylineDrawLine[i]);
                  polylineDrawLine[i].setMap(null);
             }
             pointsDrawLine = new Array();
             markerDrawLineLst = new Array();
             polylineDrawLine = new Array();
             var pointsTemp=[];
    //         gdirDrawLine.loadFromWaypoints(pointsTemp,{"preserveViewport":true});      
             for(var i=0;i<lineRoadPoly.length;i++)
             {
//                map.removeOverlay(lineRoadPoly[i]);
                lineRoadPoly[i].setMap(null);
             }   
             lineRoadPoly = new Array();
         }
         catch(e)
         {
         
         }
         if(doType==2)
         {
            s_PointsLineCheck = "";
            s_PointsLineNoCheck = "";         
            return;
         }
         s_PointsLineCheck = pointsCheck;
         s_PointsLineNoCheck = points;
         
         //开始显示图标
         var pontsLatLng = pointsCheck.split(";");
//         if(map.getCurrentMapType().getName(false) == "混合地图")
//         {
//            pontsLatLng = pointsCheck.split(";");
//         }
//         else
//         {
//             pontsLatLng = pointsCheck.split(";");
//         }
//         ShowInfo(pointsCheck);
         var PreLatLng;
         for(var ii =0;ii<pontsLatLng.length; ii ++)
         {
            var latlng = new google.maps.LatLng(pontsLatLng[ii].split(",")[0],pontsLatLng[ii].split(",")[1]);
            pointsDrawLine.push(latlng);
            if(ii == 0)
            {
                var iZoom = map.getZoom();
                if(iZoom < 16)
                {
                    iZoom = 16;
                }
                map.setCenter(latlng);
                map.setZoom(iZoom);
//                map.setCenter(latlng,iZoom);
//                var greenIcon = new GIcon(G_DEFAULT_ICON);
//        //            greenIcon.image = "../googlemap/green-dot.png";
//                    greenIcon.iconSize = new GSize(32,32);
//                    greenIcon.iconAnchor = new google.maps.Point(16,32);
//                    greenIcon.shadowSize=new GSize(1,1);
//        //            marker2DrawLine = new GMarker(latlng,{draggable: true,icon:greenIcon});
//                    marker2DrawLine = new GMarker(latlng,{draggable: true,icon:greenIcon,title:markerDrawLineLst.length});
//                    map.addOverlay(marker2DrawLine);

                    
//                    
//                    var image={
////                    url: 'images/beachflag.png',
//                    size: new google.maps.Size(32,32),
//                    origin: new google.maps.Point(1,1),
//                    anchor: new google.maps.Point(16,32)
//                };

                marker2DrawLine = new google.maps.Marker({map:map,draggable: true,title:markerDrawLineLst.length.toString(),position:latlng});
                markerDrawLineLst.push(marker2DrawLine);    
                    
                   google.maps.event.addListener(marker2DrawLine, "dragend", function() {  
                          for(var i=0;i<markerDrawLineLst.length;i++)
                          {
                                if(markerDrawLineLst[i].getTitle() ==marker2DrawLine.getTitle())
                                {
                                    pointsDrawLine.splice(i,1,marker2DrawLine.getPosition());
                                    markerDrawLineLst[i] = marker2DrawLine;
//                                    if(map.getCurrentMapType().getName(false) == "混合地图")
                                    if(CurrentMapType == "混合地图")
                                    {
                                        iCheckTemp=1;
                                    }
                                    else
                                    {
                                        iCheckTemp = 1;
                                    }
                                    if(pointsDrawLine.length >=2)
                                    {
                                        window.external.UpdateDrawRoadForm("'" + marker2DrawLine.getPosition().nb + "," + marker2DrawLine.getPosition().ob + "'",iCheckTemp,0);    
                                    }
                                    if((1 + i * 2) >= lineRoadPoly.length)
                                    {
                                        break;
                                    }
                                     var points = new Array();
                                     points.push(markerDrawLineLst[i].getPosition());
                                     points.push(lineRoadPoly[1 + i * 2].getPosition());
                                     //定义线的形式
//                                     var polyLineNow= new google.maps.Polyline(points, "#FE0202", 2);
//                                     map.addOverlay(polyLineNow); //根据数组中的两点划线
//                                     map.removeOverlay(lineRoadPoly[i * 2]);
//                                     
                                     var polyLineNow = new google.maps.Polyline({map:map,path:points,strokeColor:"#FE0202",strokeWeight:2});
                                     lineRoadPoly[i * 2].setMap(map);
                                     
                                     
                                     
                                     lineRoadPoly.splice(i*2,1,polyLineNow);
                                     
                                     lineRoadPoly[1 + i * 2] = SetMidArrows(points,lineRoadPoly[1 + i * 2]);
//                                     lineRoadPoly.push(polyLineNow);
//                                     map.removeOverlay(lineRoadPoly[1 + i * 2]);
//                                     
//                                     var arrowMark = midArrows(points,1 + i*2);
//                                    if(arrowMark != undefined)
//                                    {
////                                        lineRoadPoly.push(arrowMark);
//                                            lineRoadPoly.splice(1 + i*2,1,arrowMark);
//                                    }
                                }
                          }
                    });   
        //            GEvent.addListener(marker2DrawLine,"dragend",function(){
        //                pointsDrawLine.push(marker2DrawLine.getLatLng());
        //                gdirDrawLine.loadFromWaypoints(pointsDrawLine,{"preserveViewport":true});
        //            })
            }
            if(ii >0)
            {
                var points = new Array();
                 points.push(PreLatLng);
                 points.push(latlng);
                 //定义线的形式
//                 var polyLineNow= new google.maps.Polyline(points, "#FE0202", 2);
//                 map.addOverlay(polyLineNow); //根据数组中的两点划线
                 
                  var polyLineNow = new google.maps.Polyline({map:map,path:points,strokeColor:"#FE0202",strokeWeight:2});
                 
                 lineRoadPoly.push(polyLineNow);
                 
                 var arrowMark = midArrows(points,lineRoadPoly.length);
                if(arrowMark != undefined)
                {
                    lineRoadPoly.push(arrowMark);
                    google.maps.event.addListener(arrowMark, "dragend", function() {  
                          for(var i=0;i<lineRoadPoly.length - 1;i++)
                          {
                                if(lineRoadPoly[1 + i].getTitle() ==this.getTitle())
                                {
                                    pointsDrawLine.splice(i + 1,1,lineRoadPoly[i + 1].getPosition());
//                                    if(map.getCurrentMapType().getName(false) == "混合地图")
                                    if(CurrentMapType == "混合地图")
                                    {
                                        iCheckTemp=1;
                                    }
                                    else
                                    {
                                        iCheckTemp = 1;
                                    }
                                    if(pointsDrawLine.length >=2)
                                    {
                                        window.external.UpdateDrawRoadForm("'" + lineRoadPoly[i + 1].getPosition().nb + "," + lineRoadPoly[i + 1].getPosition().ob + "'",iCheckTemp,(i / 2) + 1);    
                                    }
                                     var points = new Array();
                                     if(i == 0)
                                     {
                                        points.push(markerDrawLineLst[0].getPosition());
                                     }
                                     else
                                     {
                                        points.push(lineRoadPoly[i - 1].getPosition());
                                     }
                                     points.push(lineRoadPoly[1 + i].getPosition());
                                     //定义线的形式
//                                     var polyLineNow= new google.maps.Polyline(points, "#FE0202", 2);
//                                     map.addOverlay(polyLineNow); //根据数组中的两点划线
//                                     map.removeOverlay(lineRoadPoly[i]);

                                        var polyLineNow = new google.maps.Polyline({map:map,path:points,strokeColor:"#FE0202",strokeWeight:2});
                                        lineRoadPoly[i].setMap(null);
                                     
                                     lineRoadPoly.splice(i,1,polyLineNow);
                                     lineRoadPoly[1 + i] = SetMidArrows(points,lineRoadPoly[1 + i]);
                                     if((3+i) < lineRoadPoly.length)
                                     {
                                        points = new Array();
                                        points.push(lineRoadPoly[1 + i].getPosition());
                                        points.push(lineRoadPoly[3 + i].getPosition());
                                        //定义线的形式
//                                         var polyLineNow= new google.maps.Polyline(points, "#FE0202", 2);
//                                         map.addOverlay(polyLineNow); //根据数组中的两点划线
//                                         map.removeOverlay(lineRoadPoly[i + 2]);
                                         
                                        var polyLineNow = new google.maps.Polyline({map:map,path:points,strokeColor:"#FE0202",strokeWeight:2});
                                        lineRoadPoly[i + 2].setMap(null);
                                        
                                         lineRoadPoly.splice(i + 2,1,polyLineNow);
                                         lineRoadPoly[3 + i] = SetMidArrows(points,lineRoadPoly[3 + i]);
                                     }
                                }
                                i++;
                          }
                    });   
                }
             }
             PreLatLng = latlng;
             
//                GEvent.addListener(gdirDrawLine, "addoverlay", function(){
//                    for (var i=0; i<=gdirDrawLine.getNumRoutes(); i++){
//                        var originalMarker = gdirDrawLine.getMarker(i);
//                        if(originalMarker != undefined)
//                         {
//                             try 
//                             {
//                                map.removeOverlay(originalMarker);
//                             }
//                            catch(e)
//                            {}
//                         }
//                        
//                    }
//                try
//                {
//                    polylineDrawLine = gdirDrawLine.getPolyline();
//                    polylineDrawLine.setStrokeStyle({color:"red",weight:2,opacity:1});
//                }
//                catch(e)
//                {
//                    pointsDrawLine.push(latlng);
//                    var pointsTemp=[];
//                    for(var p = 0; p < pointsDrawLine.length; p++)
//                    {
//                        pointsTemp[p] = pointsDrawLine[p];
//                    }
//                    gdirDrawLine.loadFromWaypoints(pointsTemp,{"preserveViewport":true});
//                    }
//                });
//                pointsDrawLine.push(latlng);
//                var pointsTemp=[];
//                for(var p = 0; p < pointsDrawLine.length; p++)
//                {
//                    pointsTemp[p] = pointsDrawLine[p];
//                }
//                gdirDrawLine.loadFromWaypoints(pointsTemp,{"preserveViewport":true});
            }
    }
        
    function DragRectangle()
    {
    
         if(ClickCount == 0 )
        {
            ClickCount++;
            SfClick = google.maps.event.addListener(map, "click", function(e) {            

                var begin = e.latLng;
               if (ClickCount == 1) {
                   SfMove = google.maps.event.addListener(map, "mousemove", function(e) {
                       ClickCount++;
                       beginlatlng = begin;
                       endlatlng = e.latLng;                           
                        rectOptions.bounds = new google.maps.LatLngBounds(beginlatlng, endlatlng);
                        rectOptions.map = map;
                        rectBounds.setOptions(rectOptions);

                   })
               }
               else {
                   google.maps.event.removeListener(SfClick);
                   google.maps.event.removeListener(SfMove);
                   window.external.ShowRectangleForm('','',beginlatlng.nb,endlatlng.nb,beginlatlng.ob,endlatlng.ob);                   
                       if (rectBounds != null) {
                            rectBounds.setMap(null);
                       }
                   ClickCount = 0;

               }
           })
         }
    
//        if(ClickCount == 0 )
//        {
//            ClickCount++;
//            SfClick = GEvent.addListener(map, "click", function(overlay, begin) {
//               //                    if (map.draggingEnabled()) {
//               //                        map.disableDragging(); //禁止地图拖动
//               //                    }
////               ClickCount++;
//               if (ClickCount == 1) {
//                   SfMove = GEvent.addListener(map, "mousemove", function(end) {
//                       ClickCount++;
//                       beginlatlng = begin;
//                       if (rectBounds != null) {
//                           map.removeOverlay(rectBounds);
//                       }
//                       endlatlng = end;                           
//                       rectBounds = new google.maps.Rectangle(new google.maps.LatLngBounds(beginlatlng, endlatlng));
//                       map.addOverlay(rectBounds);
//                   })
//               }
//               else {
//                   GEvent.removeListener(SfClick);
//                   GEvent.removeListener(SfMove);
//                   window.external.ShowRectangleForm('','',beginlatlng.x,endlatlng.x,beginlatlng.y,endlatlng.y);                   
//                       if (rectBounds != null) {
//                           map.removeOverlay(rectBounds);
//                       }
//                   ClickCount = 0;
////                   ShowInfo('起始坐标点' + beginlatlng + '\n结束坐标点' + endlatlng);
//               }
//           })
//         }
    }
    
     function ChangeMap(maptype) {
            if(s_PointsLineCheck !="" && s_PointsLineNoCheck !="")
            {
//                ShowLineRoad(1,s_PointsLineCheck,s_PointsLineNoCheck)
            }
//        if (maptype != CurrentMapType) {
//            if ((maptype == "混合地图" && (CurrentMapType == "地图" || CurrentMapType == "地形")) || (CurrentMapType == "混合地图" && (maptype == "地图" || maptype == "地形"))) {
//                CurrentMapType = maptype;
//                //ShowInfo(CurrentMapType);
//                var point;
//                for (var i = 0; i < MarkList.length; i++) 
//                    if(CurrentMapType == "混合地图")
//                    {
//                        point = new google.maps.LatLng(MarkList[i].oY,MarkList[i].oX);
//                  {
//                   }
//                    else
//                    {
//                        point = new google.maps.LatLng(MarkList[i].Y,MarkList[i].X);
//                    }
//                     MarkList[i].Mark.setLatLng(point);  
//                 }
//            }
//            
//        }
    }
    
    function AddLargeMapControl()
    {
       var LargeMapControl=new GLargeMapControl();
        map.addControl(LargeMapControl);
    }
    
    function RemoveMapTypeControl()
    {
      map.removeControl(ctrlMapType);
    }
    
    function ViewDefaultMap()
    {
      if (map.getCurrentMapType() != G_NORMAL_MAP)
      {
        map.removeMapType(map.getCurrentMapType());
        map.setMapType( G_NORMAL_MAP);
      }
    }
    
    function ViewGoogleMap()  //混合地图
    {
      if (map.getCurrentMapType() != G_HYBRID_MAP)
      {
        map.removeMapType(map.getCurrentMapType());
        map.setMapType( G_HYBRID_MAP);
      }
    }
    
    function ViewOtherMap()//卫星图
    {
      if (map.getCurrentMapType() != G_SATELLITE_MAP)
      {
        map.removeMapType(map.getCurrentMapType());
        map.setMapType(G_SATELLITE_MAP);
      }
    }
    
    //设置车辆方向
     //设置车辆方向
   function setIconDirect()
   {
      for(var i=0;i<8;i++)
      {
          var ImageUrl = "51ditu/carGray"+i+".gif";
          var num=Number(i);
          iconArray[num] = ImageUrl;
      }
      for(var i=0;i<8;i++)
      {
          var ImageUrl = "51ditu/carBlue"+i+".gif";
          var num=Number(i) + Number(8);
          iconArray[num] = ImageUrl;
      }
      for(var i=0;i<8;i++)
      {
          var ImageUrl = "51ditu/carGreed"+i+".gif";
          var num=Number(i) + Number(16);
          iconArray[num] = ImageUrl;
      }
      for(var i=0;i<8;i++)
      {
          var ImageUrl = "51ditu/carRed"+i+".gif";
          var num=Number(i) + Number(24);
          iconArray[num] = ImageUrl;
      }
   }
    
    //地图增加车辆地址 
   function getAdd(Lon,Lat)
    {
        var XX=0,YY=0;
        XX=parseFloat(Lon);
        YY=parseFloat(Lat);
        GetAddressFromGoogle(XX,YY)
    }
    
   function GetAddressFromGoogle(Lon,Lat) 
   {
        var p = new google.maps.LatLng(Lat,Lon);

        var myHtml = null;
        var st = null;
        //由经纬度得地理位置

        
        geocoder.geocode({'latLng':p}, function(results, status) {
            if (status != google.maps.GeocoderStatus.OK) {
                myHtml = "";
            }
            else {
                if(results.length > 0)
                {
//                    address = results[1].formatted_address);
//                    myHtml = address.address;
                    document.getElementById('imgDisplayAddr').style.display='none';
                    var divAdd = document.getElementById('tdAdd');
                    divAdd.innerHTML=results[0].formatted_address;   
                }
            }
            
        });
    }
    
    
    function setIcon(dituDirect,sIcon)
   {
      var iconURl='';
      var iIconIndex = 0;
      if(sIcon == "Online")
      {
        iIconIndex = 8;
      }
      if(sIcon == "Velocity")
      {
        iIconIndex = 16;
      }
      if(sIcon == "Alert")
      {
        iIconIndex = 24;
      }
      if((dituDirect>=0&&dituDirect<=22)||(dituDirect>=338&&dituDirect<=360))
       {
          iconURl = iconArray[0 + iIconIndex];
       }
       else if(dituDirect>=23&&dituDirect<=67)
       {
         iconURl = iconArray[1 + iIconIndex];
       }
       else if(dituDirect>=68&&dituDirect<=112)
       {
          iconURl = iconArray[2 + iIconIndex];
       }
       else if(dituDirect>=113&&dituDirect<=157)
       {
          iconURl = iconArray[3 + iIconIndex];
       }
       else if(dituDirect>=158&&dituDirect<=202)
       {
          iconURl = iconArray[4 + iIconIndex];
       }
       else if(dituDirect>=203&&dituDirect<=247)
       {
         iconURl = iconArray[5 + iIconIndex];
       }
       else if(dituDirect>=248&&dituDirect<=292)
       {
          iconURl = iconArray[6 + iIconIndex];
          
       }
       else if(dituDirect>=293&&dituDirect<=337)
       {
          iconURl = iconArray[7 + iIconIndex];
       }
       else
       {
          iconURl = iconArray[0 + iIconIndex];
       }
       return iconURl;
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
     
      //地图增加车辆     
    function AddOrMoveObject(ObjectCode,VehicleNum,oLon,oLat,Lon,Lat,NowSpeed,Direct,Zoom,StatusDes,isTrack,isNeedRevice,Addr,isSetCenter,IsUpdate,sTime,ImgState, iColor,iLetter,addressCompany,iShowState)
    {        
         strLon=Lon;
         strLat=Lat;
         if(Lon == undefined || Lat == undefined )
         {
            return;
         }
         var googleXY = CheckXYGpsToGoogle(Lon, Lat);
        oLon = googleXY[0].lng;
        oLat = googleXY[0].lat;
         var sShowState = "";
         if(iShowState == 0)
         {
             sShowState = " style=\"display:none\"";
         } 
         var infoText = "<table>" + //style='font:9pt;'
        // "<tr height='10px'><td width='15px'></td><td nowrap></td><td>" + "</td></tr>"+
                          "<tr><td width='15px'></td><td nowrap align='right' width='80px'><font color='#244FAF'>ID：</font></td><td nowrap width='180px'>" + ObjectCode + "</td></tr>" +
                          "<tr><td width='15px'></td><td nowrap align='right' width='80px'><font color='#244FAF'><% =Resources.Lan.Plate  %>：</font></td><td nowrap>" + VehicleNum + "</td></tr>" +
                          "<tr><td width='15px'></td><td nowrap align='right' width='80px'><font color='#244FAF'><% =Resources.Lan.Speed  %>：</font></td><td nowrap>" + Number(NowSpeed) + "<% =Resources.Lan.KmHour %></td></tr>" +
                           "<tr><td width='15px'></td><td nowrap align='right' width='80px'><font color='#244FAF'><% =Resources.Lan.DataTime  %>：</font></td><td nowrap>" + sTime + "</td></tr>" +
                          "<tr" + sShowState + "><td width='15px'></td><td nowrap align='right' width='80px'><font color='#244FAF'><% =Resources.Lan.UnitStatus  %>：</font></td><td nowrap>" + StatusDes + "</td></tr>" +
                          "<tr height='0px' style=\"display:none\"><td width='15px'></td><td nowrap align='right'><font color='#244FAF'>地址：</font></td><td nowrap><label id=\"lblCompany\">" + addressCompany + "</label></td></tr>" +
                          "<tr  height='50px'  ><td width='15px'></td><td nowrap valign='top' align='right'><font color='#244FAF'><% =Resources.Lan.Address  %>：</font></td><td id='tdAdd' valign='top' style='width:180px;word-break:break-all'>" +
                          "<a onmouseover=\"document['imgDisplayAddr'].imgRolln=document['imgDisplayAddr'].src;document['imgDisplayAddr'].src=document['imgDisplayAddr'].lowsrc;\" onmouseout=\"document['imgDisplayAddr'].src=document['imgDisplayAddr'].imgRolln\" href=\"#\"    onclick='getAdd(" + oLon + "," + oLat + ");' >"
                          + "<img border=\"0\" src=\"../Img/Baidu/showAddr.png\" id=\"imgDisplayAddr\" name=\"imgDisplayAddr\" dynamicanimation=\"imgDisplayAddr\" lowsrc=\"../Img/Baidu/showAddr.png\" alt=\"\"/></a>" +
                           "</td></tr>" +
                      "</table>";
        IsUpdate = 0;
        for (var i = 0; i < MarkList.length; i++) {
            if (MarkList[i].ID == ObjectCode) {
                IsUpdate = 1;
                break;
            }
        }
         if (IsUpdate == 0) 
           AddObject(ObjectCode,VehicleNum,oLon,oLat,Lon,Lat,NowSpeed,Direct,Zoom,StatusDes,isTrack,Addr,isSetCenter,infoText,ImgState,iColor,iLetter);
         else
           MoveObject(oLon,oLat,Lon,Lat,ObjectCode,VehicleNum,NowSpeed,Direct,Zoom,StatusDes,isTrack,isNeedRevice,Addr,isSetCenter,infoText,ImgState,iColor, iLetter); 
              
         //strObjectCode = ObjectCode; 
    }
     
   function toggleBounce(ee)
     {
        alert('a');
     }  
  function AddObject(ObjectCode,VehicleNum,oLon,oLat,Lon,Lat,NowSpeed,Direct,Zoom,StatusDes,isTrack,Addr,isSetCenter,info,ImgState,Color,iLetter)
  {
      //
      var addmark;
      var markexist=0;
      
      var  mouseText = '' ;
      var title = '';
      var point ;
      var vehCarNum = "I";
      var vehFontSize = "43"
      if(iLetter < 2)
      {
          vehCarNum = setIcon(Direct, ImgState, iLetter == 1);
          vehFontSize = "57";
      }
      var sIcon = "../Img/Baidu/baiducar.gif";
//      var sIcon = "../Img/Baidu/car0.gif";
      point =  new google.maps.LatLng(oLat,oLon);
      
//      var marker2 = new google.maps.Marker({
//          position: point,
//          title: "Hello World!"
//      });

//      marker2.setMap(map); 
      
//      var flightPlanCoordinates = [
//    new google.maps.LatLng(oLat,oLon),
//    new google.maps.LatLng(oLat + 0.1,oLon + 0.1)
//  ];
//  var flightPath = new google.maps.Polyline({
//    path: flightPlanCoordinates,
//    strokeColor: "#FF0000",
//    strokeOpacity: 1.0,
//    strokeWeight: 2
//  });
// 
//  flightPath.setMap(map);
      
//      if(CurrentMapType == "混合地图")
//        {
//            point =  new google.maps.LatLng(oLat,oLon);
//            car =NewMarker(VehicleNum,oLon,oLat,Direct,info,sIcon,vehCarNum,vehFontSize,Color) ;//产生车辆标注对象
//        }
//      else
//        {
//            point =  new google.maps.LatLng(Lat,Lon);
//            car =NewMarker(VehicleNum,Lon,Lat,Direct,info,sIcon,vehCarNum,vehFontSize,Color) ;//产生车辆标注对象
//        }
//      if(isSetCenter=='1')
//      {
//        map.setCenter(point,map.getZoom());
//      }
      var mapLabel = new MapLabel({
          text: vehCarNum,
          position: new google.maps.LatLng(oLat,oLon),
          map: map,
          fontSize: vehFontSize,
          align: 'center',
          fontFamily:'BaiduCar',
          onlyText:false,
          fontColor:'#' + Color
        });
      var mapLabelText = new MapLabel({
          text: VehicleNum,
          position: new google.maps.LatLng(oLat,oLon),
          map: map,
          fontSize: 14,
          align: 'center',
          fontFamily:'sans-serif',
          onlyText:true,
          fontColor:'#FF0000',
        });
      car = new google.maps.Marker({icon: sIcon});
        car.bindTo('map', mapLabel);
        car.bindTo('position', mapLabel);
        car.setDraggable(false);
//        car.addListener('click', toggleBounce);
        mapLabel.set('fontFamily', 'BaiduCar');
       
      map.setCenter(point);
      map.setZoom(map.getZoom());
      car.trackMarkers = true;
      addmark=createMarker(car,info, ObjectCode);
      
      for (var i = 0; i < MarkList.length; i++) 
      {
      
        if (MarkList[i].ID ==ObjectCode) 
        {
            markexist=1;
            break;
        }
      }
      
      if(markexist==0)
      {
        MarkList.push({"ID":ObjectCode,"Mark":addmark,"oX":oLon,"oY":oLat,"X":Lon,"Y":Lat,"LabelIco": mapLabel, "LabelText":mapLabelText});
//        map.addOverlay(addmark);
      }
      /*GEvent.addListener(car, "mouseout", function() {
          car.closeInfoWindow();
         });*/
      
      //if(isTrack=='1')//显示轨迹
      //{
      //    setMapTrack(point);
      //}      
        for (var i = 0; i < TrackList.length; i++) 
        {      
            if (TrackList[i].ID ==ObjectCode) //显示轨迹
            {
                setMapTrack(point,i);
                TrackList[i].LastPoint = point;
            }
        } 
  }
  
      function NewMarker(VehicleNum,Lon,Lat,Direct,info,sIcon,carFont,carFontSize,Color) 
      {
        var marker = null;
        var point = new google.maps.LatLng(Lat,Lon);
        
        var textInfo = info.replace(/\'/g,"").replace(/\"/g,"");
        var arrPara = new  Array();
        arrPara.push(Lat);
        arrPara.push(Lon);
        arrPara.push(textInfo);//setIcon(Direct,sIcon)
        arrPara.push(carFont);
        arrPara.push(carFontSize);
        arrPara.push(Color);
        marker = new FocusMarker(map,{latlng:point,image:"../Img/Baidu/car0.gif",clickFun:cli,para:arrPara,labelText: VehicleNum});//(Lat ,Lon,textInfo)
        

        return marker;
     }
     
     function UpdateMarkerInfo(marker,VehicleNum,Lon,Lat,Direct,info,sIcon)
     {
        var point = new google.maps.LatLng(Lat,Lon);
        // 创建我们的“缩微”图标
//        var icon = new GIcon();
//        icon.image = setIcon(Direct,sIcon);
//        icon.iconSize = new GSize(32, 32);
//        icon.iconAnchor = new google.maps.Point(6, 20);
//        icon.infoWindowAnchor = new google.maps.Point(1, 1);
        var textInfo = info.replace(/\'/g,"").replace(/\"/g,"");
        marker.para[0] = Lat;
        marker.para[1] = Lon;
        marker.para[2] = textInfo;
//        marker.container.innerHTML =  '<img onclick="cli(' + Lat + ',' + Lon + ',\'' + textInfo + '\')" src = "' + setIcon(Direct,sIcon) + '" alt="" /><div onclick="cli(' + Lat + ',' + Lon + ',\''+ textInfo +'\')" class="blmz left bold" style = "padding-left:33;margin-top:-16;font-weight:bold;" width = "140px"> ' + VehicleNum + '</div>';
     }
     
     //var textInfo ="";
     var infowindow = new google.maps.InfoWindow();
     var infowindowID = -1;
     function cli(lat,lon,info)
     {
        var point = new google.maps.LatLng(lat,lon);
//        var infowindow = new google.maps.InfoWindow({content:info});        
        infowindow.setPosition(point);
        infowindow.setContent(info);
        infowindow.open(map);
//        map.openInfoWindowHtml(point,info);
     }
  
  //车辆移动
    function MoveObject(oLon,oLat,lon,lat,ObjectCode,VehicleNum,NowSpeed,Direct,Zoom,StatusDes,isTrack,isNeedRevice,Addr,isSetCenter,info, ImgState, Color, iLetter)
    {
         var SelectMark=null;
         var iSelectMarkIndex=0;
         var LabelIco = null;
         var LabelText = null;
         for (var i = 0; i < MarkList.length; i++) 
         {
           if (MarkList[i].ID ==ObjectCode) 
           {
                 SelectMark=MarkList[i].Mark;  
                 LabelIco=MarkList[i].LabelIco; 
                 LabelText=MarkList[i].LabelText; 
                 iSelectMarkIndex=i;
                 break;
           }
         }
         
         if(SelectMark==null) return;   
//        map.removeOverlay(SelectMark);
        
         var mouseText ='';
         var title = '';
         var dituDirect= Direct;
         
//         var url = setIcon(dituDirect,sIcon);
         
         var point = new google.maps.LatLng(oLat,oLon);
//         if(CurrentMapType == "混合地图")
//         {
//            point=new google.maps.LatLng(oLat,oLon);
//            car = NewMarker(VehicleNum,oLon,oLat,Direct,info) ;
//         }
//         else
//         {
//            point=new google.maps.LatLng(lat,lon);
//            car = NewMarker(VehicleNum,lon,lat,Direct,info) ;
//         }
    LabelIco.set('position', point);
    LabelText.set('position', point);
    createMarker(SelectMark,info,ObjectCode);
    var vehCarNum = "I";
    if(iLetter < 2)
    {
        vehCarNum = setIcon(Direct, ImgState, iLetter == 1);
    }
    var vehFontSize = "43"
    if(iLetter < 2)
    {
        vehCarNum = setIcon(Direct, ImgState, iLetter == 1);
        vehFontSize = "57";
    }
    LabelIco.set('text', vehCarNum);
    LabelIco.set('fontColor',Color);
    LabelText.set('text', VehicleNum);
//    UpdateMarkerInfo(SelectMark,VehicleNum,lon,lat,Direct,info,sIcon) ;
     MarkList[iSelectMarkIndex].Mark=SelectMark;
     MarkList[iSelectMarkIndex].LabelIco=LabelIco;
     MarkList[iSelectMarkIndex].LabelText=LabelText;
         //GEvent.clearListeners(SelectMark, "mouseover");
         //GEvent.clearListeners(car, "mouseout");
//         GEvent.addListener(SelectMark, "click", function() {
//         SelectMark.openInfoWindowHtml(info);
//         });//明天增加离开时隐藏提示窗口
         /*GEvent.addListener(car, "mouseout", function() {
          car.closeInfoWindow();
         });*/
                    
         
//         if(isTrack=='1')//显示轨迹
//         {
//             setMapTrack(point);
//         }
         
         //得到边界，如果超出边界则重新设置
         if(isSetCenter=='1')
         {
            var bounds = map.getBounds();
             //if( !bounds.contains( point ) )
             //{
	            map.setCenter(point);
                map.setZoom(map.getZoom());
            //}
        }  
        
        for (var i = 0; i < TrackList.length; i++) 
        {      
            if (TrackList[i].ID ==ObjectCode) //显示轨迹
            {
                setMapTrack(point,i);
                TrackList[i].LastPoint = point;
            }
        }      
    } 
    
    function AddTracking(ObjectCode)
    {
         for (var i = 0; i < TrackList.length; i++) 
        {      
            if (TrackList[i].ID ==ObjectCode) 
            {            
                return;
            }
        }      
        TrackList.push({"ID":ObjectCode,"Marks":null,"LastPoint":null});
    }
    
    function ClearTracking(ObjectCode)
    {
        for (var i = 0; i < TrackList.length; i++) 
        {          
           if (TrackList[i].ID ==ObjectCode) 
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
                 TrackList.splice(i, 1);
           }
        }
    }
    
    function setMapCenter(oLon,oLat,lon,lat,zoom)
    {
        var googleXY = CheckXYGpsToGoogle(lon, lat);
        oLon = googleXY[0].lng;
        oLat = googleXY[0].lat;
        var point=   new google.maps.LatLng(oLat,oLon);
//        if(CurrentMapType == "混合地图")
//        {
//            point=   new google.maps.LatLng(oLat,oLon);
//        }
//        else
//        {
//            point=  new google.maps.LatLng(lat,lon);
//        }
        
        if(zoom==0)
        {
            map.setCenter(point);
            map.setZoom(map.getZoom());
        }
        else
        {
            map.setCenter(point);
            map.setZoom(zoom);
//            map.setCenter(point,zoom);
        }
    }
    
//    function setMarkerCenter(ObjectCode)
//    {
//        var SelectMark=null;
//         
//         for (var i = 0; i < MarkList.length; i++) 
//         {
//           if (MarkList[i].ID ==ObjectCode) 
//           {
//                 SelectMark=MarkList[i].Mark;  
//                 break;
//           }
//         }
//         
//         if(SelectMark==null) return;
//    }
    
    function  setMapTrack(mapPointNow)
    {
         //点放入数组
         if(pointsBAK !=null)
         {
             var points = new Array();
             points.push(pointsBAK);
             points.push(mapPointNow);
             //定义线的形式
             var polyLineNow= new google.maps.Polyline({path:points, strokeColor:"#f33f00", strokeWeight:2});
             polyLineNow.setMap(map);
//             map.addOverlay(polyLineNow); //根据数组中的两点划线
         }
          pointsBAK=mapPointNow;//保留第二个点作为下一段线的起始点
                  
     }  
     
     function  setMapTrack(mapPointNow,arrIndex)
    {
         //点放入数组
         if(TrackList[arrIndex] !=null)
         {
             var points = new Array();
             points.push(TrackList[arrIndex].LastPoint);
             points.push(mapPointNow);
             //定义线的形式
             var polyLineNow= new google.maps.Polyline({path:points, strokeColor:"#f33f00", strokeWeight:5});
//             map.addOverlay(polyLineNow); //根据数组中的两点划线
             polyLineNow.setMap(polyLineNow);
             if(TrackList[arrIndex].Marks == null)
             {
                var overlayList = new Array();
                overlayList.push(polyLineNow);
                TrackList[arrIndex].Marks = overlayList;
             }
             else
             {
                TrackList[arrIndex].Marks.push(polyLineNow);
             }
         }                  
     }  
  
    function createMarker(NewCar, Info,vehid) {
      NewCar.value = Info;
      if(infowindow != null && vehid == infowindowID)
      {
        infowindow.setContent(Info);
      }
      google.maps.event.clearInstanceListeners(NewCar);
      var vehListen = google.maps.event.addListener(NewCar,"click", function() {
//            var infowindow = new google.maps.InfoWindow({content:info});      
            infowindow.setContent(Info);
            infowindow.open(map,NewCar);
            infowindowID = vehid;
      });
      return NewCar;
	  }
	       
     function deleteCar(ObjectCode)
     { 
        for (var i = 0; i < MarkList.length; i++) 
        {
          
           if (MarkList[i].ID ==ObjectCode) 
           {
                 MarkList[i].Mark.setMap(null);  
                 MarkList[i].LabelText.setMap(null);
                 MarkList.splice(i, 1);
           }
        }
         
     }
    
    function  ClearObject()
    {
         map.clearOverlays();//清除地图标注
    }
    
   function AddCarMaker(Lon,Lat)
   {
     if (marker !== null)
     {
       marker.setMap(null);
     }
     var mapPoint=new google.maps.LatLng(Lat,Lon);
     marker=new google.maps.Marker(mapPoint);//使用该图标创建标记LTMarker
     marker.setMap(marker);//将标记添加到地图
     map.setCenter(mapPoint);
     map.setZoom(map.getZoom());
   }
   
   //画矩形
   function DrawRect()
   {
      SetToolType(3); 
   }
   
   function DrawPolygon(LonList,LatList)
   {
     var ArrayLon = new Array();
     var ArrayLat = new Array();
     var points = new Array();
      ArrayLon = LonList.split("|");
      ArrayLat = LatList.split("|");
      for (var i=0;i<ArrayLon.length; i++)
      {
        points.push(new google.maps.LatLng(ArrayLat[i], ArrayLon[i]));
      }
      var polyLine = new google.maps.Polyline( {path:points, strokeColor:"#f33f00", strokeWeight:5});
		//将折线添加到地图
		polyLine.setMap(map);
//		map.setCenter(polyLine.getBounds().getCenter(),map.getZoom());
		
   }
   
   function ViewBoundInfo()
   {
     document.getElementById('MinLon').value=map.getBounds().getSouthWest().lng();
     document.getElementById('MinLat').value=map.getBounds().getSouthWest().lat();
     document.getElementById('MaxLon').value=map.getBounds().getNorthEast().lng();
     document.getElementById('MaxLat').value=map.getBounds().getNorthEast().lat();
     
   }
   
   function ClickRowSetCenter(Lon,Lat,Addr)
   {
        var center = new google.maps.LatLng(Lat, Lon);
         map.setCenter(center);
         map.setZoom(map.getZoom());
    }
    
    
    function GetCenterPoint()
    {
      document.getElementById('CenterLon').value=Number(map.getCenter().lng()).mul(1000000);
      document.getElementById('CenterLat').value=Number(map.getCenter().lat()).mul(1000000);
    } 
    
    function GetViewSize()
    {
      var pos=new GSize();
      pos=map.getSize();
      document.getElementById('MaxX').value=pos.width;
      document.getElementById('MaxY').value=pos.height;
    }
    
    function ViewAllMap()
    {
      var center = new google.maps.LatLng(30.910400, 108.362240);
      map.setCenter(center);
      map.setZoom(5);
    }
    
    function GetDistanc(MinX,MinY,MaxX,MaxY)
    {
      var pos1=new google.maps.Point(MinX,MinY); 
      var pos2=new google.maps.Point(MaxX,MaxY);
      var point1=new google.maps.LatLng();
      var point2=new google.maps.LatLng();
      point1=map.fromContainerPixelToLatLng(pos1);
      point2=map.fromContainerPixelToLatLng(pos2);
      
     var distance=point1.distanceFrom(point2);
     document.getElementById('Distinct').value=distance;//单位为米
    }
    
    function ZoomIn(X,Y)
    {
      if (map.getZoom() == 18)
      {
        return;
      }
      var pos=new google.maps.Point(X,Y);
      var point=new google.maps.LatLng();
      point=map.fromContainerPixelToLatLng(pos);
      map.setCenter(point);
      map.setZoom(map.getZoom() + 1);
    }

    function ZoomByIndex(AIndex)
    {
      var point=map.getCenter();
      map.setCenter(point);
      map.setZoom(AIndex);
    }

    function GetZoom()
    {
      document.getElementById('Zoom').value=map.getZoom();
    }
    
    function ZoomOut(X,Y)
    {
      if (map.getZoom() == 5)
        return; 
      var pos=new google.maps.Point(X,Y);
      var point=new google.maps.LatLng();
      point=map.fromContainerPixelToLatLng(pos);
      map.setCenter(point);
      map.setZoom(map.getZoom - 1);
    }
    
    function GetLonAndLat(X,Y)
    {
      var point=new google.maps.LatLng();
      var pos=new google.maps.Point(X,Y);
      point=map.fromContainerPixelToLatLng(pos);
      document.getElementById('Lon').value=point.lng();
      document.getElementById('Lat').value=point.lat();
    }
    
    function AutoDrawRect(MinX,MinY,MaxX,MaxY)
    {
        var points=new Array();
        points[0]=new google.maps.LatLng(MinY,MinX);
        points[1]=new google.maps.LatLng(MinY,MaxX);
        points[2]=new google.maps.LatLng(MaxY,MaxX);
        points[3]=new google.maps.LatLng(MaxY,MinX);
        points[4]=new google.maps.LatLng(MinY,MinX);
        rect = new GPolygon(points,"#f33f00", 5, 1, "#ff0000", 0.2);
		  map.addOverlay(rect);
		  map.setCenter(rect.getBounds().getCenter());
            map.setZoom(map.getZoom());
//		  map.setCenter(rect.getBounds().getCenter(),map.getZoom());
		 
    }
    
    function DeleteRect()
    {
      map.clearOverlays();
    }
    
    function ViewBounds(minlon,minlat,maxlon,maxlat)
    {
       var pos1=new google.maps.LatLng(minlat,minlon);
       var pos2=new google.maps.LatLng(maxlat,maxlon);
       var bounds=new google.maps.LatLngBounds(pos1,pos2);
        map.setCenter(bounds.getCenter());
      map.setZoom(map.getZoom());
//		  map.setCenter(bounds.getCenter(),map.getZoom());
    }
    
    function GetNTU()
    {
      document.getElementById('NTULon').value=Math.round(Number(map.getBounds().getNorthEast().lng()-map.getBounds().getSouthWest().lng()).mul(1000000));
      document.getElementById('NTULat').value=Math.round(Number(map.getBounds().getNorthEast().lat()-map.getBounds().getSouthWest().lat()).mul(1000000));
    }
    
    function GetXAndY(Lon,Lat)
    {
      var point=new google.maps.Point(map.fromLatLngToContainerPixel(new google.maps.LatLng(Lat,Lon)));
      document.getElementById('PosX').value=point.x.x;
      document.getElementById('PosY').value=point.x.y;
    }
    
    function GetNewLonAndLat(Lon, Lat)
    {
      document.getElementById('NewLon').value=Lon;
      document.getElementById('NewLat').value=Lat;
    }
    
    function MapMove(X,Y)
    {
      //var Size = new GSize(-X,-Y);
      //map.panBy(Size);
      var pos=new GSize();
      pos=map.getSize();
      var point=map.getCenter();
      var NTULon=Math.round(Number(map.getBounds().getNorthEast().lng()-map.getBounds().getSouthWest().lng()).mul(1000000));
      var NTULat=Math.round(Number(map.getBounds().getNorthEast().lat()-map.getBounds().getSouthWest().lat()).mul(1000000));
      var NewPoint=new google.maps.LatLng(point.lat()-Y*(NTULat / pos.height).div(1000000),point.lng()+X*(NTULon / pos.width).div(1000000));
      map.setCenter(NewPoint);
      map.setZoom(map.getZoom());
//      map.setCenter(NewPoint,map.getZoom());
    }
    

    function getPosition(Lon,Lat)
    {
        var locationTextNew = GetAddrFrom51Ditu_ByClient(Lon,Lat);
        document.getElementById('Position').value=locationTextNew;
    }

    function ClearAutoDrawPloy()
    {
      if (arrPoly.length > 0)
       {
          while(arrPoly.length>0)
          {
            map.removeOverlay(arrPoly.pop())
          } 
        }
        lastpoint=null;
	     polyLine1=null;
	     polystartpoint=null;
    }
    
    function MoveDrawPloy(x,y)
    {
      var pos=new google.maps.Point(x,y);
      var lp=map.fromContainerPixelToLatLng(pos);
	   if (lastpoint != null)
	   {  
	      if (polyLine1 != null)
	      {
	        map.removeOverlay(polyLine1);
	      }
	      var arrPolyPoint = new Array();
         arrPolyPoint.push(lastpoint);
         arrPolyPoint.push(lp);
         var polyLineNow= new google.maps.Polyline( {path:arrPolyPoint, strokeColor:"#f33f00", strokeWeight:5});
		   map.addOverlay(polyLineNow);
         polyLine1=polyLineNow;
	   }
    }
    
    function StartDrawPloy(x,y)
    {
       var pos=new google.maps.Point(x,y);
	    var lp=map.fromContainerPixelToLatLng(pos);
		   
	    if (lastpoint!=null)
	    {
	      if (polyLine1 != null)
	      {
	        arrPoly.push(polyLine1);
	      }
	    }
	    else
	    {
	      polystartpoint=lp;
	    }
	    lastpoint=lp;
	    polyLine1=null;
    }
    
    function EndDrawPloy()
    {
      if (lastpoint != null)
	   {
         var arrPolyPoint = new Array();
         arrPolyPoint.push(lastpoint);
         arrPolyPoint.push(polystartpoint);
          //定义线的形式
         var polyLineNow= new google.maps.Polyline(arrPolyPoint, "#f33f00", 5);
	      map.addOverlay(polyLineNow);
         arrPoly.push(polyLineNow);
	   }
	   lastpoint=null;
	   polyLine1=null;
	   polystartpoint=null;
    }
    
    function TrackerObject(ObjectCode,Lon,Lat,isSetCenter)
    {     
         var bIfExists=false;
      
         for(var i=0;i<arrTracker.length;i++)
         {
           if (arrTracker[i].objectcode == ObjectCode)
           {
             bIfExists=true;
             if ((arrTracker[i].lastpoint.lng() - Lon<0.000001) && (arrTracker[i].lastpoint.lat()<0.000001))
             {
               return;
             }
             break;
           }
         }   
         
        if (!bIfExists) 
        {
          var carobj=new CarInfo(ObjectCode);
          AddTrackerObject(Lon,Lat,isSetCenter,carobj);
          arrTracker.push(carobj);
        }
        else
          MoveTrackerObject(Lon,Lat,isSetCenter,arrTracker[i]); 
    }
     
     
  function AddTrackerObject(Lon,Lat,isSetCenter,carobj)
  {
      var point =  new google.maps.LatLng(Lat,Lon);
      carobj.lastpoint=point;
  }
  
  //车辆移动
    function MoveTrackerObject(lon,lat,isSetCenter,carobj)
    {
         var point =  new google.maps.LatLng(lat,lon);        
         if(carobj.lastpoint !=null)
         {
           var pointarr = new Array();
             pointarr.push(carobj.lastpoint);
             pointarr.push(point);
             //定义线的形式
             var polyLineNow= new google.maps.Polyline(pointarr, "#f33f00", 5);
             map.addOverlay(polyLineNow); //根据数组中的两点划线
             carobj.lastpoint=point;
             if (carobj.arrline.length > 1000)
             {
               map.removeOverlay(carobj.arrline[0]);
               carobj.arrline.shift();
             }
             carobj.arrline.push(polyLineNow);
          }
         
    } 
    
   function MapLocate(Lon,Lat)
   {
     if (Locatemarker !== null)
     {
       map.removeOverlay(Locatemarker);
       Locatemarker=null;
     }
     var mapPoint=new google.maps.LatLng(Lat,Lon);
     Locatemarker=new GMarker(mapPoint);//使用该图标创建标记LTMarker
     map.addOverlay(Locatemarker);//将标记添加到地图
   }
   
    var bDelNode = false;
    function DelNode() {
        bDelNode = true;
    }   
    
   //画围栏
   function ShowNode(points, names, ids) 
   {
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
   
   
   function ShowNodeEach(pEndX, pEndY,pStartX, pStartY,  labelName, id) {
        var rectBounds = new google.maps.LatLngBounds(
            new google.maps.LatLng(pStartY, pStartX),
            new google.maps.LatLng(pEndY, pEndX)); 
            
        var Options = {
        strokeColor: "#FF0000",
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: "#FF0000",
        fillOpacity: 0.35,
        clickable:true     
    };

        var clickTemp_ = function () {
            if (bDelNode) {
                if (confirm('是否确实需要删除[' + labelName + ']节点？')) {
                    window.external.DelNodeByID(id);
                }
            }
        };
        Options.bounds=rectBounds;
        Options.map=map;
        
        var rectangleOverlay = new google.maps.Rectangle();               
        rectangleOverlay.setOptions(Options);
//        rectangleOverlay.click=clickTemp_;
        google.maps.event.addListener(rectangleOverlay,"click",clickTemp_);
        
                
//        var lableMarker=new FocusMarker(map,new google.maps.LatLng(pStartY, pStartX),
//        {innerHtml:'<div class="blmz left bold" style = "padding-left:33;margin-top:-16;font-weight:bold;" width = "140px"> ' + labelName + '</div>'}
//        );
        var lableMarker = new FocusMarker(map,{latlng:new google.maps.LatLng(pStartY, pStartX),labelText:labelName})
        
                
//         
//        map.addOverlay(rectangleOverlay);
        overlays.push({ "Name": labelName, "ID": id, "MarkNode": rectangleOverlay ,"LableMark":lableMarker});
    }
     
    function HideNode()
    {
        try
        {
            for(var i=0;i<overlays.length ;i++)
            {
//                map.removeOverlay(overlays[i].MarkNode);
                overlays[i].MarkNode.setMap(null);
                overlays[i].LableMark.setMap(null);
            }
            overlays.length = 0;
        }
        catch(e)
        {
                
        }
    }
    
    function ClearNodeByID(id) {
    try
    {
        for (var i = 0; i < overlays.length; i++) {
            if (overlays[i].ID == id) {
//                map.removeOverlay(overlays[i].MarkNode);
                overlays[i].MarkNode.setMap(null);
                overlays[i].LableMark.setMap(null);
                overlays.splice(i, 1);
                break;
            }
        }
        }
        catch(e)
        {
        
        }
    }
    
    function NodeDefine()
    {
    
    
    if(ClickCount == 0 )
        {
        
        
            SfClick = google.maps.event.addListener(map, "click", function(e) {
              
                var begin = e.latLng;
                  ClickCount++;               
               if (ClickCount == 1) {
                   SfMove = google.maps.event.addListener(map, "mousemove", function(e) {  
                        beginlatlng = begin;
                        endlatlng = e.latLng;                      
                        rectOptions.bounds = new google.maps.LatLngBounds(beginlatlng, endlatlng);
                        rectOptions.map = map;                      
                        rectBounds.setOptions(rectOptions);
                   })
               }
               else {
                   google.maps.event.removeListener(SfClick);
                   google.maps.event.removeListener(SfMove);
                   window.external.AddNodeData(beginlatlng.ob,endlatlng.ob,beginlatlng.nb,endlatlng.nb);                   
                       if (rectBounds != null) {
                          rectBounds.setMap(null);
                       }
                   ClickCount = 0;

               }
           })
         }
    
    
//        if(ClickCount == 0 )
//        {
//            ClickCount++;
//            SfClick = GEvent.addListener(map, "click", function(overlay, begin) {
//               if (ClickCount == 1) {
//                   SfMove = GEvent.addListener(map, "mousemove", function(end) {
//                       ClickCount++;
//                       beginlatlng = begin;
//                       if (rectBounds != null) {
//                           map.removeOverlay(rectBounds);
//                       }
//                       endlatlng = end;                           
//                       rectBounds = new google.maps.Rectangle(new google.maps.LatLngBounds(beginlatlng, endlatlng));
//                       map.addOverlay(rectBounds);
//                   })
//               }
//               else {
//                   GEvent.removeListener(SfClick);
//                   GEvent.removeListener(SfMove);
//                   window.external.AddNodeData(beginlatlng.x,endlatlng.x,beginlatlng.y,endlatlng.y);                   
//                       if (rectBounds != null) {
//                           map.removeOverlay(rectBounds);
//                       }
//                   ClickCount = 0;
//               }
//           })
//         }
    }
    
    function UpdateNode(id, labelName) {
    try
    {
        for (var i = 0; i < overlays.length; i++) {
            if (overlays[i].ID == id) {
                overlays[i].MarkNode.div_.innerHTML = "<b>" + labelName + "</b>";
            }
        }
        }
        catch(e)
        {
        
        }
    }
    
   function ShowInfo(info)
   {
       $.messager.alert('<% =Resources.Lan.Tip %>',info,'info');
   }
</script>
<!-- onunload="GUnload()"-->
<body onload="load()"  style="padding:0px; margin:0px; height:100%; width:100%; overflow:hidden;"  oncontextmenu="return false">
<div>
<input type="hidden" name="__VIEWSTATE" id="__VIEWSTATE" value="/wEPDwUKMTYzMTY3OTc4MWRkn2gftafXsoMoNUznu5qzhgoZJJ4=" />
</div>
<div>
</div>

     <div id="MapControlPnl" style="padding: 0px; margin: 0px; width: 100%; background-repeat:repeat-x; background-image:url(51ditu/back.gif); display:none" >
       <a onmouseover="document['fpAnimswapImgFP3'].imgRolln=document['fpAnimswapImgFP3'].src;document['fpAnimswapImgFP3'].src=document['fpAnimswapImgFP3'].lowsrc;" onmouseout="document['fpAnimswapImgFP3'].src=document['fpAnimswapImgFP3'].imgRolln" href="javascript:void(0)"><img border="0" src="51ditu/m0_a.gif" id="fpAnimswapImgFP3" name="fpAnimswapImgFP3" dynamicanimation="fpAnimswapImgFP3" lowsrc="51ditu/m0_b.gif" width="66" height="26" onclick="javascript:SetToolType(0);"></a>
       <a onmouseover="document['fpAnimswapImgFP2'].imgRolln=document['fpAnimswapImgFP2'].src;document['fpAnimswapImgFP2'].src=document['fpAnimswapImgFP2'].lowsrc;" onmouseout="document['fpAnimswapImgFP2'].src=document['fpAnimswapImgFP2'].imgRolln" href="javascript:void(0)"><img border="0" src="51ditu/m1_a.gif" id="fpAnimswapImgFP2" name="fpAnimswapImgFP2" dynamicanimation="fpAnimswapImgFP2" lowsrc="51ditu/m1_b.gif" width="87" height="26" onclick="javascript:SetToolType(1);"/></a>
       <a onmouseover="document['fpAnimswapImgFP4'].imgRolln=document['fpAnimswapImgFP4'].src;document['fpAnimswapImgFP4'].src=document['fpAnimswapImgFP4'].lowsrc;" onmouseout="document['fpAnimswapImgFP4'].src=document['fpAnimswapImgFP4'].imgRolln" href="javascript:void(0)"><img border="0" src="51ditu/m2_a.gif" id="fpAnimswapImgFP4" name="fpAnimswapImgFP4" dynamicanimation="fpAnimswapImgFP4" lowsrc="51ditu/m2_b.gif" width="87" height="26" onclick="javascript:SetToolType(2);"/></a>
    
     </div>
    <div id="map" style="padding: 0px; margin: 0px; width: 100%; height: 100%; position:absolute; " onclick="this.focus();"></div>
    <input name="MinLon" type="hidden" id="MinLon" />
    <input name="MaxLon" type="hidden" id="MaxLon" />
    <input name="MinLat" type="hidden" id="MinLat" />
    <input name="MaxLat" type="hidden" id="MaxLat" />
    <input name="PosX" type="hidden" id="PosX" />
    <input name="PosY" type="hidden" id="PosY" />
    <input name="MaxX" type="hidden" id="MaxX" />
    <input name="MaxY" type="hidden" id="MaxY" />
    <input name="MapInit" type="hidden" id="MapInit" />
    <input name="Distinct" type="hidden" id="Distinct" />
    <input name="Lon" type="hidden" id="Lon" />
    <input name="Lat" type="hidden" id="Lat" />
    <input name="RectMinLon" type="hidden" id="RectMinLon" />
    <input name="RectMinLat" type="hidden" id="RectMinLat" />
    <input name="RectMaxLon" type="hidden" id="RectMaxLon" />
    <input name="RectMaxLat" type="hidden" id="RectMaxLat" />
    <input name="NTU" type="hidden" id="NTU" />
    <input name="CenterLon" type="hidden" id="CenterLon" />
    <input name="CenterLat" type="hidden" id="CenterLat" />
    <input name="NewLon" type="hidden" id="NewLon" />
    <input name="NewLat" type="hidden" id="NewLat" />
    <input name="Position" type="hidden" id="Position" />
    <input name="NTULon" type="hidden" id="NTULon" />
    <input name="NTULat" type="hidden" id="NTULat" />
    <input name="Zoom" type="hidden" id="Zoom" />
 
    
<div>
	<input type="hidden" name="__EVENTVALIDATION" id="__EVENTVALIDATION" value="/wEWGgK8kajzCgKcndmcCwLKkunCCwKOnfGcCwK8ksHCCwKbnZaCDgKbnYKnBQLll8aYDgLll7K9BQLrl9/9DgL96q+TAQK4ov6VDwKqhszBCQKg4ojrBQKW4vDqBQKGyIH4DAL8x6n4DALjyOOwDgLB1sC5AwLX1rjcBwKgu7j9AwKuu5D9AwLSlNfsDwKKwvbXCgKYwt7YCgLli9ihCjNcMG3FwYpUJa4+KAnzIsnVIvT1" />
</div>
</body>
</html>
