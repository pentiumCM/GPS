using System;
using System.Collections.Generic;
using System.Text;

namespace Models
{
    public class COverSpeed
    {
        //Longitude, Latitude, Angle, Velocity, Component, Locate,[Time]
        public int id { get; set; }
        public double Longitude { get; set; }
        public double Latitude { get; set; }
        public int Velocity { get; set; }
        public string StartTime { get; set; }
        public string EndTime { get; set; }
        public DateTime DtStartTime { get; set; }
        public DateTime DtEndTime { get; set; }
        public int MaxVelocity { get; set; }
        public double TimeSecond { get; set; }
    }
}
