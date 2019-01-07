using System;
using System.Collections.Generic;
using System.Text;

namespace Models
{
    //发动机数据
    public class CMaxMin
    {
        public int id { get; set; }
        public string Time { get; set; }
        public int MaxVolChildSystemNum { get; set; }
        public int MaxVolCellNum { get; set; }
        public int MaxCellVol { get; set; }
        public int MinVolChildSystemNum { get; set; }
        public int MinVolCellNum { get; set; }
        public int MinCellVol { get; set; }
        public int MaxTempChildSystemNum { get; set; }
        public int MaxTempProbedNum { get; set; }
        public int MaxTemp { get; set; }
        public int MinTempChildSystemNum { get; set; }
        public int MinTempProbedNum { get; set; }
        public int MinTemp { get; set; }
    }
}
