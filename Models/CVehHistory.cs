using System;
using System.Collections.Generic;
using System.Text;

namespace Models
{
    public class CVehHistory
    {
        //Longitude, Latitude, Angle, Velocity, Component, Locate,[Time]
        public double Longitude { get; set; }

        public double Latitude { get; set; }

        public int Angle { get; set; }
        public int Velocity { get; set; }
        public string Component { get; set; }
        public int Locate { get; set; }
        public string Time { get; set; }
    }
}
