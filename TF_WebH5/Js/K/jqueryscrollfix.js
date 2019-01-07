(function ($) {
    var last = null;
    jQuery.fn.scrollFix = function (height, dir,last) {
        height = height || 0;
        height = height == "top" ? 0 : height;
        return this.each(function () {
            if (height == "bottom") {
                height = document.documentElement.clientHeight - this.scrollHeight;
            } else if (height < 0) {
                height = document.documentElement.clientHeight - this.scrollHeight + height;
            }
            var that = $(this),
              oldHeight = false,
              p, r, l = that.offset().left;
            dir = dir == "bottom" ? dir : "top"; //榛樿婊氬姩鏂瑰悜鍚戜笅
            if (window.XMLHttpRequest) { //闈瀒e6鐢╢ixed


                function getHeight() { //>=0琛ㄧず涓婇潰鐨勬粴鍔ㄩ珮搴﹀ぇ浜庣瓑浜庣洰鏍囬珮搴�
                    return (document.documentElement.scrollTop || document.body.scrollTop) + height - that.offset().top;
                }
                $(window).scroll(function () {
                    if (oldHeight === false) {
                        if ((getHeight() >= 0 && dir == "top") || (getHeight() <= 0 && dir == "bottom")) {
                            oldHeight = that.offset().top - height;
                            that.css({
                                position: "fixed",
                                top: height,
                                //left: l
                               
                            });
                            $(last).css({"background-color":"#ccc"});
                        }
                    } else {
                        if (dir == "top" && (document.documentElement.scrollTop || document.body.scrollTop) < oldHeight) {
                            that.css({
                                position: "static"
                            });
                            $(last).css({ "background-color": "#4f9cee" });
                            oldHeight = false;
                        } else if (dir == "bottom" && (document.documentElement.scrollTop || document.body.scrollTop) > oldHeight) {
                            that.css({
                                position: "static"
                            });
                            $(last).css({ "background-color": "#4f9cee" });
                            oldHeight = false;
                        }

                    }
                });
            } else { //for ie6
                $(window).scroll(function () {
                    if (oldHeight === false) { //鎭㈠鍓嶅彧鎵ц涓€娆★紝鍑忓皯reflow
                        if ((getHeight() >= 0 && dir == "top") || (getHeight() <= 0 && dir == "bottom")) {
                            oldHeight = that.offset().top - height;
                            r = document.createElement("span");
                            p = that[0].parentNode;
                            p.replaceChild(r, that[0]);
                            document.body.appendChild(that[0]);
                            that[0].style.position = "absolute";
                        }
                    } else if ((dir == "top" && (document.documentElement.scrollTop || document.body.scrollTop) < oldHeight) || (dir == "bottom" && (document.documentElement.scrollTop || document.body.scrollTop) > oldHeight)) { //缁撴潫
                        that[0].style.position = "static";
                        p.replaceChild(that[0], r);
                        r = null;
                        oldHeight = false;
                    } else { //婊氬姩
                        that.css({
                            left: l,
                            top: height + document.documentElement.scrollTop
                        })
                    }
                });
            }
        });
    };
})(jQuery);
