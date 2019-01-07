using System;
using System.Collections.Generic;
using System.Text;

namespace Models
{
    public class COil
    {
        public int id { get; set; }
        public string VehID { get; set; }

        public string Cph { get; set; }

        public int StealOil { get; set; }
        public List<COilDetail> lstDetail = new List<COilDetail>();
    }

    public class COilDetail
    {
        public double Scale { get; set; }

        public double OilValue { get; set; }
    }
}
