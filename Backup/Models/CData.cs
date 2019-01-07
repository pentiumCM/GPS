using System;
using System.Collections.Generic;
using System.Text;

namespace Models
{
    public class CData
    {
        public string result { get; set; }
        public string data { get; set; }
    }

    public class CData2
    {
        public bool result { get; set; }
        public string data { get; set; }
    }

    public class CErr
    {
        public bool result { get; set; }
        public string err { get; set; }
    }
}
