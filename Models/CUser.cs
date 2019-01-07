using System;
using System.Collections.Generic;
using System.Text;
using Newtonsoft.Json;

namespace Models
{
    public class CUserGroup
    {
        public string id { get; set; }
        public string name { get; set; }
        public string PID { get; set; }
        public int HasChild { get; set; }
        public int Root { get; set; }
        //[JsonIgnore]
        //public string Tel1 { get; set; }
    }

    public class CUser
    {
        public string id { get; set; }
        public string name { get; set; }
        public string PID { get; set; }
        public int HasChild { get; set; }
    }

    public class CUserDetail
    {
        public string id { get; set; }
        public string name { get; set; }
        public string pwd { get; set; }
        public string company { get; set; }
        public string tel { get; set; }
        public int userType { get; set; }
        public int usergroup { get; set; }
        public string permission { get; set; }
        public string expirationTime { get; set; }
        public int role { get; set; }
        public string groups { get; set; }
    }
}
