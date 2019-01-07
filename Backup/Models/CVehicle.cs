using System;
using System.Collections.Generic;
using System.Text;
using Newtonsoft.Json;

namespace Models
{
    public class CVehicle
    {
        public string id { get; set; }
        public string name { get; set; }
        public string GID { get; set; }
        public string ipaddress { get; set; }
        public string ownno { get; set; }
        public string taxino { get; set; }
        public string customid { get; set; }
        //[JsonIgnore]
        public string sim { get; set; }
        public string ownername { get; set; }
        public string contact3 { get; set; }
        public string seller { get; set; }
    }

    public class CKeyValue
    {
        public string name { get; set; }
        public string value { get; set; }
        public CKeyValue()
        {

        }
        public CKeyValue(string n1, string v1)
        {
            name = n1;
            value = v1;
        }
    }

    public class CVehUsage
    {
        public string Date { get; set; }
        public int Value { get; set; }
    }

    public class CVehProvince
    {
        //public string Date { get; set; }
        public int VehID { get; set; }
        public string Province { get; set; }
        public string City { get; set; }
    }

    public class CVehicleDetail
    {
        public string PlateNO { get; set; }
        public string IpAddress { get; set; }
        public string ownno { get; set; }
        public string Sim { get; set; }
        public string TaxiNo { get; set; }
        //基本资料
        public string CustomNum { get; set; }
        public string VendorCode { get; set; }
        public string ServerPwd { get; set; }
        public string PlateColor { get; set; }
        public string CarColor { get; set; }
        public string CarType { get; set; }
        public string EngineNumber { get; set; }
        public string FrameNumber { get; set; }
        public string InstallDate { get; set; }
        public string PowerType { get; set; }
        //其它资料
        public string OwnerName { get; set; }
        public string Sex { get; set; }
        public string Tel { get; set; }
        public string Email { get; set; }
        public string Contact1 { get; set; }
        public string Tel1 { get; set; }
        public string Contact2 { get; set; }
        public string Tel2 { get; set; }
        public string IdentityCard { get; set; }
        public string PostalCode { get; set; }
        public string WorkUnit { get; set; }
        public string DriverName { get; set; }
        public string Address { get; set; }
        //中心资料
        public string InstallPerson { get; set; }
        public string TonOrSeats { get; set; }
        public string OperationRoute { get; set; }
        public string TransportLicenseID { get; set; }
        public string Money { get; set; }
        public string PurchaseDate { get; set; }
        public string ServerEndTime { get; set; }
        public string EnrolDate { get; set; }
        public string AnnualInspectionRepairTime { get; set; }
        public string Level2MaintenanceTime { get; set; }
        //备注
        public string Marks { get; set; }
    }
}
