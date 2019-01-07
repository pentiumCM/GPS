using System;
using System.Collections.Generic;
using System.Text;

namespace Models
{
    public class CNotInPolygn
    {
        //[VehID],[Time],[Lng],[Lat],[Acc],[PolygonID]
        public int id { get; set; }

        public string Time { get; set; }

        public double Longitude { get; set; }
        public double Latitude { get; set; }
        public int Acc { get; set; }
        public int PolygonID { get; set; }
        public int PolygonType { get; set; }
    }
}
