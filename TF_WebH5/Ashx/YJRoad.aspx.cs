using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;

public partial class Ashx_YJRoad : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            string sIp = Request["IpAddress"];
            sIp = sIp.PadLeft(12, '0');
            string sLng1 = Request["Lng1"];
            double dLng1 = double.Parse(sLng1);
            string sLat1 = Request["Lat1"];
            double dLat1 = double.Parse(sLat1);
            string sPlace1 = System.Web.HttpUtility.UrlDecode(Request["Place1"], System.Text.Encoding.GetEncoding("GB2312"));
            string sLng2 = Request["Lng2"];
            double dLng2 = double.Parse(sLng2);
            string sLat2 = Request["Lat2"];
            double dLat2 = double.Parse(sLat2);
            string sPlace2 = System.Web.HttpUtility.UrlDecode(Request["Place2"], System.Text.Encoding.GetEncoding("GB2312"));
            //百度坐标转高德坐标
            if (dLat1 != 0 && dLng1 != 0)
            {
                bd09_To_Gcj02(ref dLat1, ref dLng1);
            }
            bd09_To_Gcj02(ref dLat2, ref dLng2);
            string sUserID = "0".PadLeft(32, '0');
            string sGuid = System.Guid.NewGuid().ToString("N");
            byte[] byteCmd = new byte[72];
            byte[] byteUser = System.Text.Encoding.ASCII.GetBytes(sUserID);
            System.Buffer.BlockCopy(byteUser, 0, byteCmd, 0, 32);
            byteCmd[32] = 0x01;
            byte[] byteGuid = System.Text.Encoding.ASCII.GetBytes(sGuid);
            System.Buffer.BlockCopy(byteGuid, 0, byteCmd, 33, 32);
            int iTimestamp = ConvertDateTimeInt(DateTime.Now);
            byteCmd[65] = (byte)(iTimestamp >> 24);
            byteCmd[66] = (byte)((iTimestamp >> 16) & 0xFF);
            byteCmd[67] = (byte)((iTimestamp >> 8) & 0xFF);
            byteCmd[68] = (byte)(iTimestamp & 0xFF);
            byteCmd[69] = 0x00;
            byteCmd[70] = 0x01;
            byteCmd[71] = 0x02;
            //--------content
            byte[] byteAdd1 = System.Text.Encoding.Default.GetBytes(sPlace1);
            byte[] byteAdd2 = System.Text.Encoding.Default.GetBytes(sPlace2);
            byte[] byteContent = new byte[18 + byteAdd1.Length + byteAdd2.Length];
            int iLng1 = (int)dLng1;
            byteContent[0] = (byte)(iLng1 >> 24);
            byteContent[1] = (byte)((iLng1 >> 16) & 0xFF);
            byteContent[2] = (byte)((iLng1 >> 8) & 0xFF);
            byteContent[3] = (byte)(iLng1 & 0xFF);
            int iLat1 = (int)dLat1;
            byteContent[4] = (byte)(iLat1 >> 24);
            byteContent[5] = (byte)((iLat1 >> 16) & 0xFF);
            byteContent[6] = (byte)((iLat1 >> 8) & 0xFF);
            byteContent[7] = (byte)(iLat1 & 0xFF);

            byteContent[8] = (byte)byteAdd1.Length;
            System.Buffer.BlockCopy(byteAdd1, 0, byteContent, 9, byteAdd1.Length);

            int iLng2 = (int)dLng2;
            byteContent[9 + byteAdd1.Length] = (byte)(iLng2 >> 24);
            byteContent[10 + byteAdd1.Length] = (byte)((iLng2 >> 16) & 0xFF);
            byteContent[11 + byteAdd1.Length] = (byte)((iLng2 >> 8) & 0xFF);
            byteContent[12 + byteAdd1.Length] = (byte)(iLng2 & 0xFF);
            int iLat2 = (int)dLat2;
            byteContent[13 + byteAdd1.Length] = (byte)(iLat2 >> 24);
            byteContent[14 + byteAdd1.Length] = (byte)((iLat2 >> 16) & 0xFF);
            byteContent[15 + byteAdd1.Length] = (byte)((iLat2 >> 8) & 0xFF);
            byteContent[16 + byteAdd1.Length] = (byte)(iLat2 & 0xFF);
            byteContent[17 + byteAdd1.Length] = (byte)byteAdd2.Length;

            System.Buffer.BlockCopy(byteAdd2, 0, byteContent, 18 + byteAdd1.Length, byteAdd2.Length);
            byte[] temp = new byte[byteCmd.Length + byteContent.Length];
            System.Buffer.BlockCopy(byteCmd, 0, temp, 0, byteCmd.Length);
            System.Buffer.BlockCopy(byteContent, 0, temp, byteCmd.Length, byteContent.Length);
            byte[] cmd;
            if (MakeGBCommand(0, sIp, 0x9000, temp, out cmd))
            {
                byte[] data = Make_A5_Command(sIp, cmd);
                //设定服务器IP地址  
                System.Net.IPAddress ip = System.Net.IPAddress.Parse(System.Configuration.ConfigurationManager.AppSettings["CenterIP"]);
                System.Net.Sockets.Socket clientSocket = new System.Net.Sockets.Socket(System.Net.Sockets.AddressFamily.InterNetwork, System.Net.Sockets.SocketType.Stream, System.Net.Sockets.ProtocolType.Tcp);
                clientSocket.Connect(new System.Net.IPEndPoint(ip, int.Parse(System.Configuration.ConfigurationManager.AppSettings["CenterPort"]))); //配置服务器IP与端口  
                clientSocket.Send(data);
                System.Threading.Thread.Sleep(3000);
                clientSocket.Shutdown(System.Net.Sockets.SocketShutdown.Both);
                clientSocket.Close(); 
                Response.Write("{\"result\":true}"); 
                return;
            }
            else
            {
                Response.Write("{\"result\":false,\"err\":\"\"}");
                return;
            }
        }
        catch(Exception ex)
        {
            Response.Write("{\"result\":false,\"err\":\"" + ex.Message + "\"}");
            return;
        }
    }

    public double pi = 3.1415926535897932384626;
    public double x_pi = 3.14159265358979324 * 3000.0 / 180.0;
    public double a = 6378245.0;
    public double ee = 0.00669342162296594323;
    public double[] bd09_To_Gcj02(ref double lat, ref double lon)
    {
        double x = lon - 0.0065, y = lat - 0.006;
        double z = Math.Sqrt(x * x + y * y) - 0.00002 * Math.Sin(y * x_pi);
        double theta = Math.Atan2(y, x) - 0.000003 * Math.Cos(x * x_pi);
        double tempLon = z * Math.Cos(theta);
        double tempLat = z * Math.Sin(theta);
        double[] gps = { tempLat, tempLon };
        lat = tempLat;
        lon = tempLon;
        return gps;
    }

    public bool MakeGBCommand(int nSN, string strMobile, ushort CmdID, byte[] Content, out byte[] buff)
    {
        buff = null;
        try
        {
            System.Collections.Generic.List<byte> lstByte = new System.Collections.Generic.List<byte>();
            byte[] temp;
            //主信令
            temp = BitConverter.GetBytes(CmdID);
            lstByte.Add(temp[1]);
            lstByte.Add(temp[0]);

            ushort nLen = 0;
            //后面包长
            if ((Content == null) || (Content.Length < 1))
            {
                nLen = 0;
            }
            else
            {
                nLen = (ushort)Content.Length;
            }
            temp = BitConverter.GetBytes(nLen);
            lstByte.Add(temp[1]);
            lstByte.Add(temp[0]);

            //手机号码
            strMobile = strMobile.PadLeft(12, '0');

            int nPos = 0;
            for (int i = 0; i < 6; i++)
            {
                lstByte.Add(Convert.ToByte(strMobile.Substring(nPos, 2), 16));
                nPos += 2;
            }

            //流水号
            lstByte.Add((byte)((nSN >> 8) & 0x000000ff));
            lstByte.Add((byte)(nSN & 0x000000ff));

            //附加内容
            if (Content != null)
            {
                for (int i = 0; i < Content.Length; i++)
                {
                    lstByte.Add(Content[i]);
                }
            }

            //校验
            temp = lstByte.ToArray();
            byte bXorValue = GetXorValue(temp, 0, temp.Length - 1);
            lstByte.Add(bXorValue);

            buff = lstByte.ToArray();

            //转义
            lstByte.Clear();
            lstByte.Add(0x7E);
            for (int j = 0; j < buff.Length; j++)
            {
                switch (buff[j])
                {
                    case 0x7E:
                        lstByte.Add(0x7D);
                        lstByte.Add(0x02);
                        break;
                    case 0x7D:
                        lstByte.Add(0x7D);
                        lstByte.Add(0x01);
                        break;
                    default:
                        lstByte.Add(buff[j]);
                        break;
                }
            }

            lstByte.Add(0x7E);
            buff = lstByte.ToArray();

            return true;
        }
        catch (Exception ex)
        {
            return false;
        }
    }

    public byte[] Make_A5_Command(string strIPAddress, byte[] data)
    {
        const int PacketSize = 14;
        strIPAddress = strIPAddress.PadLeft(12, '0');
        byte[] tempIP = new byte[6];
        for (int i = 0; i < 6; i++)
        {
            tempIP[i] = Convert.ToByte(strIPAddress.Substring((i * 2), 2), 16);
        }

        byte[] cmd = null;

        if ((data == null) || (data.Length <= 0))
        {
            cmd = new byte[PacketSize];
            cmd[0] = 0x2D;
            cmd[1] = 0x2D;

            cmd[2] = 0xAA;

            cmd[3] = 0x00;
            //cmd[4] = 0x06;
            cmd[4] = 0x07 + 2;

            cmd[5] = tempIP[0];
            cmd[6] = tempIP[1];
            cmd[7] = tempIP[2];
            cmd[8] = tempIP[3];
            cmd[9] = tempIP[4];
            cmd[10] = tempIP[5];

            cmd[11] = 0x5;

            cmd[12] = GetXorValue(cmd, 0, cmd.Length - 2);
            cmd[13] = 0x0D;
        }
        else
        {
            int nSize = PacketSize + data.Length;
            cmd = new byte[nSize];

            //cmd[0] = 0x13;
            //cmd[1] = 0x56;
            cmd[0] = 0x2D;
            cmd[1] = 0x2D;

            cmd[2] = 0xAA;

            int nLen = data.Length + 7 + 2;
            cmd[3] = (byte)((nLen >> 8) & 0xFF);
            cmd[4] = (byte)(nLen & 0xFF);

            cmd[5] = tempIP[0];
            cmd[6] = tempIP[1];
            cmd[7] = tempIP[2];
            cmd[8] = tempIP[3];
            cmd[9] = tempIP[4];
            cmd[10] = tempIP[5];

            cmd[11] = 0x05;

            System.Buffer.BlockCopy(data, 0, cmd, 12, data.Length);
            cmd[cmd.Length - 2] = GetXorValue(cmd, 0, cmd.Length - 2);
            cmd[cmd.Length - 1] = 0x0D;
        }

        return cmd;
    }
    
    private byte GetXorValue(byte[] data, int StartIndex, int EndPosition)
    {
        byte temp = data[StartIndex];
        for (int i = (StartIndex + 1); i <= EndPosition; i++)
        {
            temp ^= data[i];
        }
        return temp;
    }

    public int ConvertDateTimeInt(System.DateTime time)
    {
        System.DateTime startTime = TimeZone.CurrentTimeZone.ToLocalTime(new System.DateTime(1970, 1, 1));
        return (int)(time - startTime).TotalSeconds;
    }
}
