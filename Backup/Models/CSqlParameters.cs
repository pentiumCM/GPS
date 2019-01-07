using System;
using System.Collections.Generic;
using System.Text;
using System.Data;

namespace Models
{
    public class CSqlParameters
    {
        private string _Name;
        public string sName
        {
            get { return _Name; }
            set { _Name = "@" + value; }
        }

        public SqlDbType sqlDbType { get; set; }
        public ParameterDirection pDirection { get; set; }
        public object sValue { get; set; }
        public int iLen { get; set; }
        //参数1  
        //sqlParme = sqlCmd.Parameters.Add("@purchaseID", SqlDbType.NVarChar);
        //sqlParme.Direction = ParameterDirection.Input;
        //sqlParme.Value = shichang.Value.Trim();
        ////参数2(在多了就以此类推)  
        //sqlParme = sqlCom.Parameters.Add("@machineCategory", SqlDbType.NVarChar);
        //sqlParme.Direction = ParameterDirection.Input;
        //sqlParme.Value = ddlCode.Text.Trim();  
    }
}
