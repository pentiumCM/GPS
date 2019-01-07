using System;
using System.Collections.Generic;
using System.Text;

namespace Models
{
    //整车数据
    public class CVehicleData
    {
        public int id { get; set; }
        public string Time { get; set; }
        public string VehState { get; set; }
        public string RunModel { get; set; }
        public string ChargeState { get; set; }
        public int Speed { get; set; }
        public Int64 Mile { get; set; }//不同
        public int Voltage { get; set; }
        public int Current { get; set; }
        public int SOC { get; set; }
        public string DCDC { get; set; }
        public int Drive { get; set; }
        public int Braking { get; set; }
        public string Gear { get; set; }
        public int Resistor { get; set; }
        public int AcceleratorPedalStrokeMile { get; set; }
        public int AcceleratorPedalStrokeState { get; set; }
    }
}
