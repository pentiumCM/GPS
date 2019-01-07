using System;
using System.Collections.Generic;
using System.Text;

namespace Models
{
    public class CPolygon
    {
        public string id{ get; set; }
        public string text{ get; set; }
        public int PolygonType{ get; set; }
        public List<CPolygonVeh> lstVeh = new List<CPolygonVeh>();
    }

    public class CPolygonVeh
    {
        public int VehID{ get; set; }
        public int InOrOut { get; set; }
        public bool IsTime { get; set; }
        public string StartTime { get; set; }
        public string EndTime { get; set; }
        public string Sms { get; set; }
        public int WeekEnd { get; set; }
        public int Holidays { get; set; }
    }

    public class CPoint
    {
        public double lng { get; set; }
        public double lat { get; set; }
    }
}
