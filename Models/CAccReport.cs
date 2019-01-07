using System;
using System.Collections.Generic;
using System.Text;

namespace Models
{
    public class CAccReport
    {
        //Longitude, Latitude, Angle, Velocity, Component, Locate,[Time]
        public int id { get; set; }
        //public double Longitude { get; set; }
        //public double Latitude { get; set; }
        //public int Velocity { get; set; }
        public string StartTime { get; set; }
        public string EndTime { get; set; }
        public double TimeContinue { get; set; }
    }
}
