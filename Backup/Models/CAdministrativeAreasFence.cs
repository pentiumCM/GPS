using System;
using System.Collections.Generic;
using System.Text;

namespace Models
{
    public class CAdministrativeAreasFence
    {
        public string id{ get; set; }
        public string text{ get; set; }
        public int PolygonType{ get; set; }
        public string Province { get; set; }
        public string City { get; set; }
        public string Area { get; set; }
        public List<CPolygonVeh> lstVeh = new List<CPolygonVeh>();
    }

    //public class CPolygonVeh
    //{
    //    public int VehID{ get; set; }
    //    public int InOrOut { get; set; }
    //    public bool IsTime { get; set; }
    //    public string StartTime { get; set; }
    //    public string EndTime { get; set; }
    //}

    //public class CPoint
    //{
    //    public double lng { get; set; }
    //    public double lat { get; set; }
    //}
}
