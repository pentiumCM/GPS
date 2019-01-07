<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FormYJRoad.aspx.cs" Inherits="MHtmls_Cmd_YJ_FormYJRoad" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title><% =Resources.Lan.GpsNavigation %></title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="../../../Css/index.css" rel="stylesheet" type="text/css" />
	<link rel="stylesheet" type="text/css" href="../../../EasyUI/themes/metro/easyui.css" />    <link rel="stylesheet" type="text/css" href="../../../EasyUI/themes/mobile.css" />
    <link rel="stylesheet" type="text/css" href="../../../EasyUI/themes/color.css" />
    <link rel="stylesheet" type="text/css" href="../../../EasyUI/themes/icon.css" />  
    <script type="text/javascript" src="../../../EasyUI/jquery.min.js"></script>  
    <script type="text/javascript" src="../../../EasyUI/jquery.easyui.min.js"></script> 
    <script type="text/javascript" src="../../../EasyUI/jquery.easyui.mobile.js"></script>
    <script type="text/javascript" src="../../../Js/GenerageGuid.js"></script> 
    <script type="text/javascript" src="../../../Js/JsCookies.js"></script>  
    <script type="text/javascript" src="../../../Js/GridTreeMulSelect.js"></script> 
    <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=l4zKPgF3ihF8lciY2QGmpsvW"></script><!--C9f93589d92e645b1a9a4cf2fb53caa4-->
	<script type="text/javascript" src="../../../Js/Baidu/BaiduLatLngCorrect.js?v=1"></script>
    <script type="text/javascript">
        $(document).ready(function() { 
            try            {                LoadMap();            }            catch(e)            {}
            window.parent.window.GetCmdVeh();            
        });
        
        var map;
        function LoadMap()        {//            $("#map").height(document.body.clientHeight);            map = new BMap.Map("map",{minZoom:3,maxZoom:19,enableMapClick:false});            // 创建Map实例
            var point = new BMap.Point(114.052161, 22.648986);    // 创建点坐标
            map.centerAndZoom(point, 5);                     // 初始化地图,设置中心点坐标和地图级别。
            map.enableScrollWheelZoom();                            //启用滚轮放大缩小
            map.addControl(new BMap.NavigationControl());  //启用导航控件
            map.addControl(new BMap.MapTypeControl({ mapTypes: [BMAP_NORMAL_MAP, BMAP_HYBRID_MAP] }));     //2D图，卫星图        }
        
        
        function send()
        {
            try
            {
                var sLng1 = $.trim($('#txtLng1').val());
                var sLat1 = $.trim($('#txtLat1').val());
                if((sLng1.length == 0 && sLat1.length == 0) || (sLng1 == "0" && sLat1 == "0"))
                {
                    sLng1 = "0";
                     sLat1 = "0";
                }
                else
                {                    
//                    var baiduXY = CheckXYBaiduToGps(sLng1, sLat1);
//                    sLng1 = baiduXY[0].lng;
//                    sLat1 = baiduXY[0].lat;
                       var baiduXY = new Array();
                       baiduXY.push({"lng":sLng1,"lat":sLat1});
                       baiduXY = BDToGCJ(baiduXY);
                       sLng1 = baiduXY[0].lng;
                        sLat1 = baiduXY[0].lat;
                }
                var sPlace1 = $.trim($('#txtPlace1').val());
//                if(sPlace1.length == 0)
//                {
//                    ShowInfo("<% =Resources.Lan.OriginAddress %> <% =Resources.Lan.FillInError %>");
//                    return;
//                }
            
                var sLng = $.trim($('#txtLng').val());
                if(sLng.length == 0)
                {
                    sLng = "0";
                }
                if(sLng.length == 0)
                {
                    ShowInfo("<% =Resources.Lan.Lng %> <% =Resources.Lan.FillInError %>");
                    return;
                }
                var sLat = $.trim($('#txtLat').val());
                if(sLat.length == 0)
                {
                    sLat = "0";
                }
                if(sLat.length == 0)
                {
                    ShowInfo("<% =Resources.Lan.Lat %> <% =Resources.Lan.FillInError %>");
                    return;
                }
                var sPlace = $.trim($('#txtPlace').val());
                if(sPlace.length == 0)
                {
                    ShowInfo("<% =Resources.Lan.Destination %> <% =Resources.Lan.FillInError %>");
                    return;
                }
                
//                var baiduXY2 = CheckXYBaiduToGps(sLng, sLat);
//                sLng = baiduXY2[0].lng;
//                sLat = baiduXY2[0].lat;
                var baiduXY2 = new Array();
                baiduXY2.push({"lng":sLng,"lat":sLat});
                baiduXY2 = BDToGCJ(baiduXY2);
                sLng = baiduXY2[0].lng;
                sLat = baiduXY2[0].lat;
                window.parent.window.SendCmdYJRoad("YJRoad", sLng1, sLat1, sPlace1, sLng, sLat, sPlace, 4, "<% =Resources.Lan.GpsNavigation %>", "<% =Resources.Lan.GpsNavigation %>")
                closeForm();
//                $.ajax({
//                    url: "../../../Ashx/YjCmd.ashx",
//                    cache:false,
//                    type:"post",
//                    dataType:'json',
//                    async:false,//同步 
//                    data:{lat:sLat,lng:sLng,des:sPlace,type:'road',cph:sSendVeh,cid:sCid},
//                    success:function(data){
//                            if(data.error == 0)
//                            {
//                                  ShowInfo("<% =Resources.Lan.Successful %>");
//                            }
//                            else
//                            {
//	                               ShowInfo(data.errormsg);
//                            }
//                    },
//                    error: function(e) { 
//	                     ShowInfo(e.message);
//                    } 
//                }) ;
                closeForm();
            }
            catch(e)
            {
                ShowInfo(e.message);
            }
        }
        
        var sSendVeh = "";
        var sCid = "";
        function SetCmdVeh(rows)
        {
            $.each(rows,function(i,value)
            {
                 sSendVeh = value.name;
                 sCid = value.cid;
                 $('#ulList').datalist('appendRow',{text:value.name,value:value.name});
                 return false;
            });
            $('#ulList').datalist('deleteRow',0);
        }
        
        function closeForm()
        {
            window.parent.window.CloseInfoCmd();
        }
        
        function GetFromLngLat(iDoType)
        {
            var sTypeName = "";
            if(iDoType == 1)
            {
                sTypeName = "1";
            }
            $('#txtPlace' + sTypeName).textbox('setValue','');
            var sLng = $.trim($('#txtLng' + sTypeName).val());
            if(sLng.length == 0)
            {
                ShowInfo("<% =Resources.Lan.Lng %> <% =Resources.Lan.FillInError %>");
                return;
            }
            var sLat = $.trim($('#txtLat' + sTypeName).val());
            if(sLat.length == 0)
            {
                ShowInfo("<% =Resources.Lan.Lat %> <% =Resources.Lan.FillInError %>");
                return;
            }
            if(marker != undefined)
            {
                map.removeOverlay(marker);
                marker = undefined;
            }
            var point = new BMap.Point(parseFloat(sLng), parseFloat(sLat));
            marker = new BMap.Marker(point);  // 创建标注
	        map.addOverlay(marker);               // 将标注添加到地图中
	        if (map.getZoom() < 16) {
                map.centerAndZoom(point, 16);  //初始化时，即可设置中心点和地图缩放级别。
            }
            else {
                map.setCenter(point);
            }
            $.ajax({
                url: "../../../Ashx/FindRoad.ashx",
                cache:false,
                type:"post",
                dataType:'json',
                async:true, //异步
                data:{type:'FromXY',Lat:sLat,Lng:sLng,coordtype:'bd09ll'},
                success:function(data){
                        if(data.result == "true")
                        {  
                            $('#txtPlace' + sTypeName).textbox('setValue',data.data);
                        }
                        else
                        {
                        
                        }
                },
                error: function(e) { 
                
                } 
            }) ;   
        }
        
        function GetFromDes(iDoType)
        {
            var sTypeName = "";
            if(iDoType == 1)
            {
                sTypeName = "1";
            }
            $('#txtLng' + sTypeName).textbox('setValue','');
            $('#txtLat' + sTypeName).textbox('setValue','');
            var sPlace = $.trim($('#txtPlace' + sTypeName).val());
            if(sPlace.length == 0)
            {
                if(iDoType == 1)
                {
                    ShowInfo("<% =Resources.Lan.OriginAddress %> <% =Resources.Lan.FillInError %>");
                }
                else
                {
                    ShowInfo("<% =Resources.Lan.Destination %> <% =Resources.Lan.FillInError %>");
                }
                return;
            }
            $.ajax({
                url: "../../../Ashx/FindRoad.ashx",
                cache:false,
                type:"post",
                dataType:'json',
                async:true, //异步
                data:{type:'FromDes',Lat:0,Lng:0,des:sPlace},
                success:function(data){
                        if(data.status == 0)
                        {  
                        try
                        {
//                            ShowInfo(data.result.location.lng + "_" + data.result.location.lat);
//                            var baiduXY = CheckXYBaiduToGps(data.result.location.lng, data.result.location.lat);
//                            var oLon = baiduXY[0].lng;
//                            var oLat = baiduXY[0].lat;
                            
                            $('#txtLng' + sTypeName).textbox('setValue',data.result.location.lng.toFixed(6));
                            $('#txtLat' + sTypeName).textbox('setValue',data.result.location.lat.toFixed(6));
                            if(marker != undefined)
                            {
                                map.removeOverlay(marker);
                                marker = undefined;
                            }
                            var point = new BMap.Point(data.result.location.lng, data.result.location.lat);
                            marker = new BMap.Marker(point);  // 创建标注
	                        map.addOverlay(marker);               // 将标注添加到地图中
	                        if (map.getZoom() < 16) {
                                map.centerAndZoom(point, 16);  //初始化时，即可设置中心点和地图缩放级别。
                            }
                            else {
                                map.setCenter(point);
                            }
                            }catch(e)
                            {
                            ShowInfo(e.message);
                            }
                        }
                        else
                        {
                        
                        }
                },
                error: function(e) { 
                    
                } 
            }) ;  
        }
        
        var lineRoadclick = undefined;
        function MapTranslation()
        {
            map.setDefaultCursor("url('../../../Img/Baidu/baiduhand.cur')");
            if (lineRoadclick != undefined) {
                map.removeEventListener("click", lineRoadclick);
                lineRoadclick = undefined;
            }
            if(marker != undefined)
            {
                map.removeOverlay(marker);
                marker = undefined;
            }
        }
        
        var marker = undefined;
        function SetLngLat(iDoType)
        {
            var sTypeName = "";
            if(iDoType == 1)
            {
                sTypeName = "1";
            }
            map.addEventListener("click", lineRoadclick = function(e) {
                if(marker != undefined)
                {
                    map.removeOverlay(marker);
                    marker = undefined;
                }
                marker = new BMap.Marker(e.point);  // 创建标注
	            map.addOverlay(marker);               // 将标注添加到地图中
	            $('#txtLng' + sTypeName).textbox('setValue',e.point.lng.toFixed(6));
                $('#txtLat' + sTypeName).textbox('setValue',e.point.lat.toFixed(6));
            });
        }
        
        function ShowInfo(info)
        {
            $.messager.alert('<% =Resources.Lan.Tip %>',info,'info');
        }
    </script>
</head>
<body>
    <div class="easyui-navpanel" style="-webkit-overflow-scrolling: touch;">
        <div style="float:left; display:none;" id="divList">
            <ul class="easyui-datalist" id="ulList" title="<% =Resources.Lan.VehList %>" lines="true" style="width:140px; ">
		        <li value=""></li>
            </ul>
        </div>
        <div style="float:left">
        <div class="easyui-panel" title="<% =Resources.Lan.GpsNavigation %>" style="width:450px; height:518px">
		    <div>
	            <form id="ff" method="post">
	    	         <table cellpadding="5" width="100%">
	    		    <tr>
	    		        <td>
	    		            <fieldset>
	    		                <legend><% =Resources.Lan.OriginAddress %>(<font color="red"><% =Resources.Lan.YJRoadStartTip %></font>) </legend>
	    		                <table>
	    		                    <tr>
	    			                    <td style="text-align:right"><% =Resources.Lan.Lng %>：</td>
	    			                    <td >
	    			                        <input style="width:80px" class="easyui-textbox" type="text" id="txtLng1" value="" name="txtLng1" />
	    			                        <% =Resources.Lan.Lat %>：<input style="width:80px" class="easyui-textbox" type="text" id="txtLat1" value="" name="txtLat1" />
	    			                        <a href="javascript:void(0)" class="easyui-linkbutton" onclick="GetFromLngLat(1)"><% =Resources.Lan.Query %></a>
	    			                        <a href="javascript:void(0)" class="easyui-linkbutton" onclick="SetLngLat(1)"><% =Resources.Lan.MapGet %></a>
	    			                    </td>
	    		                    </tr>
	    		                    <tr>
	    			                    <td style="text-align:right"><% =Resources.Lan.OriginAddress %>：</td>
	    			                    <td>
	    			                    <input style="width:200px" class="easyui-textbox" type="text" id="txtPlace1" value="" name="txtPlace1" />
	    			                    <a href="javascript:void(0)" class="easyui-linkbutton" onclick="GetFromDes(1)"><% =Resources.Lan.Query %></a>
	    			                        <a href="javascript:void(0)" class="easyui-linkbutton" onclick="MapTranslation(1)"><% =Resources.Lan.Translation %></a>
	    			                    </td>	    			    
	    		                    </tr>
	    		                </table>
	    		            </fieldset>
	    		        </td>
	    		    </tr>
	    		    <tr>
	    		        <td>
	    		            <fieldset>
	    		                <legend><% =Resources.Lan.Destination %> </legend>
	    		                <table>
	    		                    <tr>
	    			                    <td style="text-align:right"><% =Resources.Lan.Lng %>：</td>
	    			                    <td >
	    			                        <input style="width:80px" class="easyui-textbox" type="text" id="txtLng" value="" name="txtLng" />
	    			                        <% =Resources.Lan.Lat %>：<input style="width:80px" class="easyui-textbox" type="text" id="txtLat" value="" name="txtLat" />
	    			                        <a href="javascript:void(0)" class="easyui-linkbutton" onclick="GetFromLngLat(2)"><% =Resources.Lan.Query %></a>
	    			                        <a href="javascript:void(0)" class="easyui-linkbutton" onclick="SetLngLat(2)"><% =Resources.Lan.MapGet %></a>
	    			                    </td>
	    		                    </tr>
	    		                    <tr>
	    			                    <td style="text-align:right"><% =Resources.Lan.Destination %>：</td>
	    			                    <td>
	    			                    <input style="width:200px" class="easyui-textbox" type="text" id="txtPlace" value="" name="txtPlace" />
	    			                    <a href="javascript:void(0)" class="easyui-linkbutton" onclick="GetFromDes(2)"><% =Resources.Lan.Query %></a>
	    			                        <a href="javascript:void(0)" class="easyui-linkbutton" onclick="MapTranslation(2)"><% =Resources.Lan.Translation %></a>
	    			                    </td>   			    
	    		                    </tr>
	    		                </table>
	    		            </fieldset>
	    		        </td>	    			    
	    		    </tr>
	    		    <tr>
	    			    <td>
	    			        <div id="map" onclick="this.focus();" style="width:430px; height:220px;overflow: hidden;margin:0;" ></div>
	    			    </td>
	    		    </tr>
	    	        </table>
	                </form>
	            </div>
	            <div style="text-align:center;padding:5px">
	    	        <a href="javascript:void(0)" class="easyui-linkbutton" onclick="send()"><% =Resources.Lan.Send %></a>
	    	        &nbsp;&nbsp;<a href="javascript:void(0)" class="easyui-linkbutton" onclick="closeForm()"><% =Resources.Lan.Close %></a>
	            </div>
	        </div>
        </div>
    </div>
</body>
</html>
