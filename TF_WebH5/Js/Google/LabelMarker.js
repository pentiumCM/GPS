//function FocusMarker(map, options) {
//    // Now initialize all properties.   
//    this.latlng = options.latlng; //设置图标的位置
//    this.image_ = options.image;  //设置图标的图片
//    this.labelText = options.labelText || '';
//    this.labelClass = options.labelClass || 'shadow'; //设置文字的样式
//    this.clickFun = options.clickFun; //注册点击事件
//    this.para = options.para;
//    //    this.labelOffset = options.labelOffset || new google.maps.Size(8, -33);
//    this.map_ = map;
//    this.div_ = null;
//    this.check_=1;
//    // Explicitly call setMap() on this overlay   
//    this.setMap(map);
//}

function FocusMarker(thismap, options, innerHtml) {

    if(innerHtml)
    {
        this.text_ = innerHtml;
        this.latlng_ = options;
        this.div_ = null;
        this.check_=2;
        this.setMap(thismap);
    }
    else{
        this.latlng = options.latlng; //设置图标的位置
        this.image_ = options.image;  //设置图标的图片
        this.labelText = options.labelText || '';
        this.labelClass = options.labelClass || 'shadow'; //设置文字的样式
        this.clickFun = options.clickFun; //注册点击事件
        this.para = options.para;
        this.check_=1;
    }
    this.map_ = thismap;
    this.div_ = null;  
    this.setMap(thismap);
}

FocusMarker.prototype = new google.maps.OverlayView();
//初始化图标
FocusMarker.prototype.onAdd = function() {
    // Note: an overlay's receipt of onAdd() indicates that  
    // the map's panes are now available for attaching   
    // the overlay to the map via the DOM.    
    // Create the DIV and set some basic attributes.  
    
    if(this.check_==1)
    {
        var div = document.createElement('DIV'); //创建存放图片和文字的div
        div.style.border = "none";
        div.style.borderWidth = "0px";
        div.style.position = "absolute";
        div.style.cursor = "hand";
        var divcli = this.clickFun;
        var paras = this.para;
        div.onclick = function() {
            if (divcli) {
                if (paras.length >= 3) {
                    divcli(paras[0], paras[1], paras[2]);
                }
                else
                {
                    divcli();
                }
            }        
            
        }; //注册click事件，没有定义就为空函数
        // Create an IMG element and attach it to the DIV.   
        if(this.image_)
        { 
//            var divFont = document.createElement("div"); //创建图片元素
//            var img = document.createElement("img"); //创建图片元素
//            img.src = this.image_;
//            img.style.width = "100%";
//            img.style.height = "100%";
//            divFont.appendChild(img);
            if(true) //增加车辆文字图标
            {
                var carFont = document.createElement('div'); //创建文字标签
                carFont.className = this.labelClass;
                carFont.innerHTML = paras[3];
    //            carFont.style.position = 'absolute';
                carFont.style.width = paras[4];
//                carFont.style.fontWeight = "bold";
                carFont.style.textAlign = 'left';
                carFont.style.color = paras[5];
//                carFont.style.float = "left";
//                carFont.style.padding = "2px";
                carFont.style.fontSize = paras[4];
                carFont.style.fontFamily = "BaiduCar";
                carFont.onclick = function() {
                    if (divcli) {
                        if (paras.length >= 3) {
                            divcli(paras[0], paras[1], paras[2]);
                        }
                        else
                        {
                            divcli();
                        }
                    }        
            
                 }; //注册click事件，没有定义就为空函数
                div.appendChild(carFont);
            }
//            div.appendChild(divFont);
        }
        //初始化文字标签
        var label = document.createElement('div'); //创建文字标签
        label.className = this.labelClass;
        label.innerHTML = this.labelText;
        label.style.position = 'absolute';
        label.style.width = '200px';
        label.style.fontWeight = "bold";
        label.style.textAlign = 'left';
        label.style.color = "red";
        label.style.padding = "2px";
        label.style.fontSize = "14px";
        label.style.marginTop = "-15px";
        //	label.style.fontFamily = "Courier New";

        div.appendChild(label);
        this.div_ = div;
        // We add an overlay to a map via one of the map's panes.  
        // We'll add this overlay to the overlayImage pane.  
        var panes = this.getPanes();
        panes.overlayLayer.appendChild(div);
    }
    else
    {
         var div = document.createElement("DIV");
        div.style.border = 'none';
        div.style.position = 'absolute';
        div.innerHTML = this.text_.innerHtml;
        this.div_ = div;
        var panes = this.getPanes();
        panes.overlayLayer.appendChild(div);
    }
}

function UpdateLabelMarkerInfoWindow(labelmarker, labelinfo) {
    var div = labelmarker.div_;
    div.onclick = function() {
        if (divcli) {
            if (paras.length == 3) {
                divcli(labelmarker.para[0], labelmarker.para[1], labelinfo);
            }
        }
    }; 
}

//绘制图标，主要用于控制图标的位置
FocusMarker.prototype.draw = function() {

 if(this.check_==1)
    {
        // Size and position the overlay. We use a southwest and northeast   
        // position of the overlay to peg it to the correct position and size.  
        // We need to retrieve the projection from this overlay to do this.  
        var overlayProjection = this.getProjection();
        // Retrieve the southwest and northeast coordinates of this overlay  
        // in latlngs and convert them to pixels coordinates.  
        // We'll use these coordinates to resize the DIV.  
        var position = overlayProjection.fromLatLngToDivPixel(this.latlng);   //将地理坐标转换成屏幕坐标
        //  var ne = overlayProjection.fromLatLngToDivPixel(this.bounds_.getNorthEast());    
        // Resize the image's DIV to fit the indicated dimensions.   
        var div = this.div_;
        div.style.left = position.x - 5 + 'px';
        div.style.top = position.y - 5 + 'px';
        //控制图标的大小
        div.style.width = '30px';
        div.style.height = '30px';
    }
    else
    {
        var pixPosition = this.getProjection().fromLatLngToDivPixel(this.latlng_);
        // 设置层的大小 和 位置
        var div = this.div_;
        var size = new google.maps.Size(-26, -42); // 修正坐标的值;
        div.style.left = (pixPosition.x + size.width) + 'px';
        div.style.top = (pixPosition.y + size.height) + 'px';
    }
}

 function RemarkRedraw(marker, point, labelHTML,icon) {
         try {
             var overlayProjection = marker.getProjection();
             var position = overlayProjection.fromLatLngToDivPixel(point);   //将地理坐标转换成屏幕坐标
             marker.div_.style.left = (position.x - 12) + "px";
             marker.div_.style.top = (position.y - 12) + "px";
             marker.div_.children[1].innerHTML = labelHTML;
             marker.div_.children[0].src = icon;
         }
         catch (e) {
             
         }
     }

FocusMarker.prototype.onRemove = function() {
    this.div_.parentNode.removeChild(this.div_);
    this.div_ = null;
}

//Note that the visibility property must be a string enclosed in quotes
FocusMarker.prototype.hide = function() {
    if (this.div_) {
        this.div_.style.visibility = "hidden";
    }
}
FocusMarker.prototype.show = function() {
    if (this.div_) {
        this.div_.style.visibility = "visible";
    }
}
//显示或隐藏图标
FocusMarker.prototype.toggle = function() {
    if (this.div_) {
        if (this.div_.style.visibility == "hidden") {
            this.show();
        } else {
            this.hide();
        }
    }
}  





//function FocusMarker(thismap, latlng, innerHtml) {
//    this.map_ = thismap;
//    this.text_ = innerHtml;
//    this.latlng_ = latlng;
//    this.div_ = null;
//    this.setMap(thismap);
//}

//FocusMarker.prototype = new google.maps.OverlayView();

//FocusMarker.prototype.onAdd = function() {
//    var div = document.createElement("DIV");
//    div.style.border = 'none';
//    div.style.position = 'absolute';
//    div.innerHTML = this.text_;
//    this.div_ = div;
//    var panes = this.getPanes();
//    panes.overlayLayer.appendChild(div);
//}

//// 当第一次在地图上显示时 调用
//FocusMarker.prototype.draw = function() {
//    var overlayProjection = this.getProjection();
//    var latLng = overlayProjection.fromLatLngToDivPixel(this.latLng_);
//    // 设置层的大小 和 位置
//    var div = this.div_;
//    var size = new google.maps.Size(-26, -42); // 修正坐标的值;
//    div.style.left = (latLng.x + size.width) + 'px';
//    div.style.top = (latLng.y + size.height) + 'px';
//};
//// 当设置 悬浮层的 setMap(null) 会自动调用
//FocusMarker.prototype.onRemove = function() {
//    this.div_.parentNode.removeChild(this.div_);
//    this.div_ = null;
//};


//google.maps.FocusMarker = function(latlng, opt){
//        this.latlng = latlng;
//        this.innerHtml = opt.innerHtml || '';
//        this.className = opt.className || '';
//        this.css = opt.css || {};
//        this.id = opt.id || '';
//    }
//    google.maps.FocusMarker.prototype = new google.maps.OverlayView();
//    google.maps.FocusMarker.prototype.initialize = function(map) {
//        // 创建用于表示该矩形区域的 DIV 元素
//        var div = document.createElement("div");
//        div.id = this.id || '';
//        div.style.width = this.css.width || 'auto';
//        div.className = this.className;
//        div.style.border = this.css.border || "none";
//        div.style.color = this.css.color || "red";
//        div.style.backgroundColor = this.css.backgroundColor || "";
//        div.style.position = this.css.position || "absolute";
//        div.style.textAlign = this.css.textAlign || "left";
//        div.style.padding = this.css.padding || "0px 0px 0px 0px";
//        div.style.fontSize = this.css.fontSize || "12px";
//        div.style.height = this.css.height || "60px";
//        div.style.width = this.css.width || "142px";
//        div.style.cursor = this.css.cursor || "pointer";
//        var c = map.fromLatLngToDivPixel(this.latlng);
//        div.style.left = (c.x - 8) + "px";
//        div.style.top = (c.y - 15) + "px";
//        div.innerHTML = this.innerHtml;
//        // 我们希望将覆盖物紧贴于地图之上，因此我们把它放置在 Z 序最小的 G_MAP_MAP_PANE 层，  
//        // 事实上，这也是地图本身的 Z 顺序，即在标注的影子之下  
//        map.getPane(G_MAP_MAP_PANE).appendChild(div);
//        this.map = map;
//        this.container = div;
//    }
//     google.maps.FocusMarker.prototype.remove = function() 
//     {  
//         this.container.parentNode.removeChild(this.container);
//     }
//     google.maps.FocusMarker.prototype.onclick = function() {
//         
//     }
//     google.maps.FocusMarker.prototype.redraw = function(force) {
//         try {
//             // 只有当坐标系改变时，我们才需要重绘
//             if (!force) return;

//             // 根据当前显示区域的经纬度坐标，计算 DIV 元素的左上角和右下角的像素坐标
//             var c = this.latlng;
//             c = this.map.fromLatLngToDivPixel(this.latlng);
//             // 根据计算得到的坐标放置我们的 DIV 元素
//             this.container.style.left = (c.x - 8) + "px";
//             this.container.style.top = (c.y - 15) + "px";
//             // this.div_.style.width = "auto";
//         }
//         catch (e) {
//             
//         }
//     }

//     function RemarkRedraw(marker, point) {
//         try {
//             //             var c = point;
//            var c = this.map.fromLatLngToDivPixel(point);
//             marker.container.style.left = (c.x - 8) + "px";
//             marker.container.style.top = (c.y - 15) + "px";
//         }
//         catch (e) {
//             
//         }
//     }