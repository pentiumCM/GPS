var pi = 3.14159265358979324;
var a = 6378245.0;
var ee = 0.00669342162296594323;
var x_pi = 3.14159265358979324 * 3000.0 / 180.0;
        
function CheckXYGpsToBaidu(X, Y)
{
    var baiduXY = new Array();
    baiduXY.push({"lat":Y,"lng":X});
    try
    {
        GPSToGCJ(baiduXY);
        GCJToBD(baiduXY);
    }
    catch(e)
    {
        
    }
    return baiduXY;
}

function GPSToGCJ(baiduXY)
{
    var d ;
    d = transform(baiduXY);
    baiduXY[0].lng = d[0].lng;
    baiduXY[0].lat = d[0].lat;
}

function transform(baiduXY)
{
    var wgLon = baiduXY[0].lng;
    var wgLat = baiduXY[0].lat;
    var d = new Array();
    d.push({"lat":baiduXY[0].lat,"lng":baiduXY[0].lng});
    var mgLat;
    var mgLon;
    if (outOfChina(wgLat, wgLon))
    {
        mgLat = wgLat;
        mgLon = wgLon;
        return d;
    }
    var dLat = transformLat(wgLon - 105.0, wgLat - 35.0);
    var dLon = transformLon(wgLon - 105.0, wgLat - 35.0);
    var radLat = wgLat / 180.0 * pi;
    var magic = Math.sin(radLat);
    magic = 1 - ee * magic * magic;
    var sqrtMagic = Math.sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi);
    dLon = (dLon * 180.0) / (a / sqrtMagic * Math.cos(radLat) * pi);
    mgLat = wgLat + dLat;
    mgLon = wgLon + dLon;
    d[0].lng = mgLon;
    d[0].lat = mgLat;
    return d;
}

function transformLat(x, y)
{
    var ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2
            * Math.sqrt(Math.abs(x));
    ret += (20.0 * Math.sin(6.0 * x * pi) + 20.0 * Math.sin(2.0 * x * pi)) * 2.0 / 3.0;
    ret += (20.0 * Math.sin(y * pi) + 40.0 * Math.sin(y / 3.0 * pi)) * 2.0 / 3.0;
    ret += (160.0 * Math.sin(y / 12.0 * pi) + 320 * Math.sin(y * pi / 30.0)) * 2.0 / 3.0;
    return ret;
}

function transformLon(x, y)
{
    var ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * Math.sqrt(Math.abs(x));
    ret += (20.0 * Math.sin(6.0 * x * pi) + 20.0 * Math.sin(2.0 * x * pi)) * 2.0 / 3.0;
    ret += (20.0 * Math.sin(x * pi) + 40.0 * Math.sin(x / 3.0 * pi)) * 2.0 / 3.0;
    ret += (150.0 * Math.sin(x / 12.0 * pi) + 300.0 * Math.sin(x / 30.0 * pi)) * 2.0 / 3.0;
    return ret;
}

function outOfChina(lat, lon)
{
    if (lon < 72.004 || lon > 137.8347)
        return true;
    if (lat < 0.8293 || lat > 55.8271)
        return true;
    return false;
}

function GCJToBD(baiduXY)
{
    var d;
    d = TransformGCJToBD(baiduXY[0].lng, baiduXY[0].lat);
    baiduXY[0].lat = d[0].lat;
    baiduXY[0].lng = d[0].lng;
}

function TransformGCJToBD(gg_lon, gg_lat)
{
    var d = new Array();
    var x = gg_lon, y = gg_lat;
    var z = Math.sqrt(x * x + y * y) + 0.00002 * Math.sin(y * x_pi);
    var theta = Math.atan2(y, x) + 0.000003 * Math.cos(x * x_pi);
    var bd_lon = z * Math.cos(theta) + 0.0065;
    var bd_lat = z * Math.sin(theta) + 0.006;
    d.push({"lat":bd_lat,"lng":bd_lon});
    return d;
}

//baidu to gps
function CheckXYBaiduToGps(X,Y)
{
    var baiduXY = new Array();
    baiduXY.push({"lat":Y,"lng":X});
    try
    {
        BDToGCJ(baiduXY);
        GCJToGPS(baiduXY);
    }
    catch(e)
    {
        
    }
    return baiduXY;          
}

function BDToGCJ(baiduXY)
{
    var d ;
    d = TransformBDToGCJ(baiduXY);
    baiduXY[0].lng = d[0].lng;
    baiduXY[0].lat = d[0].lat;
    return baiduXY;
}

function TransformBDToGCJ(baiduXY)
{
    var d = new Array();
    var bd_lon = baiduXY[0].lng;
    var bd_lat = baiduXY[0].lat;
    var x = bd_lon - 0.0065, y = bd_lat - 0.006;
    var z = Math.sqrt(x * x + y * y) - 0.00002 * Math.sin(y * x_pi);
    var theta = Math.atan2(y, x) - 0.000003 * Math.cos(x * x_pi);
    var gg_lon = z * Math.cos(theta);
    var gg_lat = z * Math.sin(theta);
    d.push({"lat":gg_lat,"lng":gg_lon});
    return d;
}

function GCJToGPS(baiduXY)
{
    var wgLon = baiduXY[0].lng;
    var wgLat = baiduXY[0].lat;
    if (outOfChina(wgLat, wgLon))
    {
        return;
    }
    var gps = transform(baiduXY);
    var lontitude = wgLon * 2 - gps[0].lng;
    var latitude = wgLat * 2 - gps[0].lat;
    baiduXY[0].lng = lontitude;
    baiduXY[0].lat = latitude;
    return baiduXY;
}

