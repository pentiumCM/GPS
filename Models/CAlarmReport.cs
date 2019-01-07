using System;
using System.Collections.Generic;
using System.Text;

namespace Models
{
    public class CAlarmReport
    {
        public int id { get; set; }
        public double Longitude { get; set; }
        public double Latitude { get; set; }
        public int speed { get; set; }
        public int angle { get; set; }
        public string time { get; set; }
        public string alarmtype { get; set; }
    }
}
