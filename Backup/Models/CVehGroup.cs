using System;
using System.Collections.Generic;
using System.Text;
using Newtonsoft.Json;

namespace Models
{
    public class CVehGroup
    {
        public string id { get; set; }
        public string name { get; set; }
        public string PID { get; set; }
        public int HasChild { get; set; }
        public int Root { get; set; }
        [JsonIgnore]
        public string Tel1 { get; set; }
    }


    public class CVehGroupDetail
    {
        public int VehGroupID { get; set; }
        public string VehGroupName { get; set; }
        public string Contact { get; set; }
        public string sTel1 { get; set; }
        public string sTel2 { get; set; }
        public string Address { get; set; }
        public int PID { get; set; }
    }
}
