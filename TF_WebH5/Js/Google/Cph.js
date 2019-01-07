function Rectangle(opt_point, opt_weight, opt_color, Veh_Name,img) {
	this.point_ = opt_point;
	this.weight_ = opt_weight || 0;
	this.color_ = opt_color || "#888888";
	this.vehname_ = Veh_Name || "名字未知";
	this.img = img;

}
//Rectangle.prototype = new GOverlay();

// Creates the DIV representing this rectangle.
Rectangle.prototype.initialize = function(map) {
	// Create the DIV representing our rectangle
	//alert('inite');
	var div = document.createElement("div");
	div.style.border = this.weight_ + "px solid " + this.color_;
	div.style.position = "absolute";
	div.style.textAlign = "left";
	//	var img = document.createElement("img");
	//	img.src = "image/car.ico";
	//	img.height = "20";
	//	img.width = "20";

	div.appendChild(this.img);
	var div_text = document.createElement("div");
	//div_text.innerHTML="京A5001";
	div_text.innerHTML = this.vehname_;
	//div_text.style.fontSize = "11px";
	//div_text.style.fontweight = "bold";
	//div_text.style.color = "red";
	div_text.className = "CphStyle";
	div.appendChild(div_text);
	// Our rectangle is flat against the map, so we add our selves to the
	// MAP_PANE pane, which is at the same z-index as the map itself (i.e.,
	// below the marker shadows)
	map.getPane(G_MAP_FLOAT_PANE).appendChild(div);
	this.map_ = map;
	this.div_ = div;

	function newEventPassthru(obj, event) {
		return function() {
			GEvent.trigger(obj, event);
		};
	}
	var eventPassthrus = ['click', 'dblclick', 'mousedown', 'mouseup', 'mouseover', 'mouseout'];
	for (var i = 0; i < eventPassthrus.length; i++) {
		var name = eventPassthrus[i];
		GEvent.addDomListener(this.div_, name, newEventPassthru(this, name));
	}
}

// Remove the main DIV from the map pane
Rectangle.prototype.remove = function() {
	this.div_.parentNode.removeChild(this.div_);
}

// Copy our data to a new Rectangle
Rectangle.prototype.copy = function() {
	return new Rectangle(this.point_, this.weight_, this.color_,
                       this.backgroundColor_, this.opacity_);
}

// Redraw the rectangle based on the current projection and zoom level
Rectangle.prototype.redraw = function(force) {
	// We only need to redraw if the coordinate system has changed
	if (!force) return;

	// Calculate the DIV coordinates of two opposite corners of our bounds to
	// get the size and position of our rectangle
	//  var c1 = this.map_.fromLatLngToDivPixel(this.bounds_.getSouthWest());
	//  var c2 = this.map_.fromLatLngToDivPixel(this.bounds_.getNorthEast());

	var ps = this.map_.fromLatLngToDivPixel(this.point_);
	// Now position our DIV based on the DIV coordinates of our bounds
	this.div_.style.width = "60px";
	this.div_.style.height = "10px";
	this.div_.style.left = ps.x + "px";
	this.div_.style.top = ps.y + "px";
}

Rectangle.prototype.openInfoWindowHtml = function(str) {
	this.map_.openInfoWindowHtml(this.point_, str);
}
Rectangle.prototype.setLatLng = function(point) {
	this.point_ = point;
	this.redraw(true);
}
Rectangle.prototype.setImgUrl = function(url) {
	this.img.src = url;
}