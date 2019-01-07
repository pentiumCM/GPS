using System;
using System.Collections.Generic;
using System.Text;

namespace Models
{
    public class CHolidays
    {
        public string year { get; set; }
        public string days { get; set; }
        public string workdays { get; set; }
        public string text { get; set; }
    }

    public class CHolidaysJson
    {
        public string Year { get; set; }
        public string Days { get; set; }
        public string workdays { get; set; }
        public string Do { get; set; }
    }
}
