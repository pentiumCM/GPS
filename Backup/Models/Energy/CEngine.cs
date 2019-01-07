using System;
using System.Collections.Generic;
using System.Text;

namespace Models
{
    //发动机数据
    public class CEngine
    {
        public int id { get; set; }
        public string Time { get; set; }
        public string State { get; set; }
        public int RPM { get; set; }
        public int OilConsumptionRate { get; set; }
    }
}
