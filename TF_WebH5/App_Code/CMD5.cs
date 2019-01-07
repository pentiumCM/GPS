using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Collections;

/// <summary>
///CMD5 的摘要说明
/// </summary>
public class MD5Encrypt
{
    private static uint A;
    private static uint B;
    private static uint C;
    private static uint D;
    private const int S11 = 7;
    private const int S12 = 12;
    private const int S13 = 0x11;
    private const int S14 = 0x16;
    private const int S21 = 5;
    private const int S22 = 9;
    private const int S23 = 14;
    private const int S24 = 20;
    private const int S31 = 4;
    private const int S32 = 11;
    private const int S33 = 0x10;
    private const int S34 = 0x17;
    private const int S41 = 6;
    private const int S42 = 10;
    private const int S43 = 15;
    private const int S44 = 0x15;

    public static string ArrayToHexString(byte[] array, bool uppercase)
    {
        string str = "";
        string format = "x2";
        if (uppercase)
        {
            format = "X2";
        }
        foreach (byte num in array)
        {
            str = str + num.ToString(format);
        }
        return str;
    }

    private static uint F(uint x, uint y, uint z)
    {
        return ((x & y) | (~x & z));
    }

    private static void FF(ref uint a, uint b, uint c, uint d, uint mj, int s, uint ti)
    {
        a = ((a + F(b, c, d)) + mj) + ti;
        a = (a << (s & 0x1f)) | (a >> ((0x20 - s) & 0x1f));
        a += b;
    }

    private static uint G(uint x, uint y, uint z)
    {
        return ((x & z) | (y & ~z));
    }

    private static void GG(ref uint a, uint b, uint c, uint d, uint mj, int s, uint ti)
    {
        a = ((a + G(b, c, d)) + mj) + ti;
        a = (a << (s & 0x1f)) | (a >> ((0x20 - s) & 0x1f));
        a += b;
    }

    private static uint H(uint x, uint y, uint z)
    {
        return ((x ^ y) ^ z);
    }

    private static void HH(ref uint a, uint b, uint c, uint d, uint mj, int s, uint ti)
    {
        a = ((a + H(b, c, d)) + mj) + ti;
        a = (a << (s & 0x1f)) | (a >> ((0x20 - s) & 0x1f));
        a += b;
    }

    private static uint I(uint x, uint y, uint z)
    {
        return (y ^ (x | ~z));
    }

    private static void II(ref uint a, uint b, uint c, uint d, uint mj, int s, uint ti)
    {
        a = ((a + I(b, c, d)) + mj) + ti;
        a = (a << (s & 0x1f)) | (a >> ((0x20 - s) & 0x1f));
        a += b;
    }

    private static uint[] MD5_Append(byte[] input)
    {
        int num = 0;
        int num2 = 1;
        int num3 = 0;
        int length = input.Length;
        int num5 = length % 0x40;
        if (num5 < 0x38)
        {
            num = 0x37 - num5;
            num3 = (length - num5) + 0x40;
        }
        else if (num5 == 0x38)
        {
            num = 0;
            num2 = 0;
            num3 = length + 8;
        }
        else
        {
            num = (0x3f - num5) + 0x38;
            num3 = ((length + 0x40) - num5) + 0x40;
        }
        ArrayList list = new ArrayList(input);
        if (num2 == 1)
        {
            list.Add((byte)0x80);
        }
        for (int i = 0; i < num; i++)
        {
            list.Add((byte)0);
        }
        ulong num7 = (ulong)(length * 8);
        byte num8 = (byte)(num7 & 0xff);
        byte num9 = (byte)((num7 >> 8) & 0xff);
        byte num10 = (byte)((num7 >> 0x10) & 0xff);
        byte num11 = (byte)((num7 >> 0x18) & 0xff);
        byte num12 = (byte)((num7 >> 0x20) & 0xff);
        byte num13 = (byte)((num7 >> 40) & 0xff);
        byte num14 = (byte)((num7 >> 0x30) & 0xff);
        byte num15 = (byte)(num7 >> 0x38);
        list.Add(num8);
        list.Add(num9);
        list.Add(num10);
        list.Add(num11);
        list.Add(num12);
        list.Add(num13);
        list.Add(num14);
        list.Add(num15);
        byte[] buffer = (byte[])list.ToArray(typeof(byte));
        uint[] numArray = new uint[num3 / 4];
        long num16 = 0;
        long num17 = 0;
        while (num16 < num3)
        {
            numArray[(int)((IntPtr)num17)] = (uint)(((buffer[(int)((IntPtr)num16)] | (buffer[(int)((IntPtr)(num16 + 1))] << 8)) | (buffer[(int)((IntPtr)(num16 + 2))] << 0x10)) | (buffer[(int)((IntPtr)(num16 + 3))] << 0x18));
            num17++;
            num16 += 4;
        }
        return numArray;
    }

    private static void MD5_Init()
    {
        A = 0x67452301;
        B = 0xefcdab89;
        C = 0x98badcfe;
        D = 0x10325476;
    }

    private static uint[] MD5_Trasform(uint[] x)
    {
        for (int i = 0; i < x.Length; i += 0x10)
        {
            uint a = A;
            uint b = B;
            uint c = C;
            uint d = D;
            FF(ref a, b, c, d, x[i], 7, 0xd76aa478);
            FF(ref d, a, b, c, x[i + 1], 12, 0xe8c7b756);
            FF(ref c, d, a, b, x[i + 2], 0x11, 0x242070db);
            FF(ref b, c, d, a, x[i + 3], 0x16, 0xc1bdceee);
            FF(ref a, b, c, d, x[i + 4], 7, 0xf57c0faf);
            FF(ref d, a, b, c, x[i + 5], 12, 0x4787c62a);
            FF(ref c, d, a, b, x[i + 6], 0x11, 0xa8304613);
            FF(ref b, c, d, a, x[i + 7], 0x16, 0xfd469501);
            FF(ref a, b, c, d, x[i + 8], 7, 0x698098d8);
            FF(ref d, a, b, c, x[i + 9], 12, 0x8b44f7af);
            FF(ref c, d, a, b, x[i + 10], 0x11, 0xffff5bb1);
            FF(ref b, c, d, a, x[i + 11], 0x16, 0x895cd7be);
            FF(ref a, b, c, d, x[i + 12], 7, 0x6b901122);
            FF(ref d, a, b, c, x[i + 13], 12, 0xfd987193);
            FF(ref c, d, a, b, x[i + 14], 0x11, 0xa679438e);
            FF(ref b, c, d, a, x[i + 15], 0x16, 0x49b40821);
            GG(ref a, b, c, d, x[i + 1], 5, 0xf61e2562);
            GG(ref d, a, b, c, x[i + 6], 9, 0xc040b340);
            GG(ref c, d, a, b, x[i + 11], 14, 0x265e5a51);
            GG(ref b, c, d, a, x[i], 20, 0xe9b6c7aa);
            GG(ref a, b, c, d, x[i + 5], 5, 0xd62f105d);
            GG(ref d, a, b, c, x[i + 10], 9, 0x2441453);
            GG(ref c, d, a, b, x[i + 15], 14, 0xd8a1e681);
            GG(ref b, c, d, a, x[i + 4], 20, 0xe7d3fbc8);
            GG(ref a, b, c, d, x[i + 9], 5, 0x21e1cde6);
            GG(ref d, a, b, c, x[i + 14], 9, 0xc33707d6);
            GG(ref c, d, a, b, x[i + 3], 14, 0xf4d50d87);
            GG(ref b, c, d, a, x[i + 8], 20, 0x455a14ed);
            GG(ref a, b, c, d, x[i + 13], 5, 0xa9e3e905);
            GG(ref d, a, b, c, x[i + 2], 9, 0xfcefa3f8);
            GG(ref c, d, a, b, x[i + 7], 14, 0x676f02d9);
            GG(ref b, c, d, a, x[i + 12], 20, 0x8d2a4c8a);
            HH(ref a, b, c, d, x[i + 5], 4, 0xfffa3942);
            HH(ref d, a, b, c, x[i + 8], 11, 0x8771f681);
            HH(ref c, d, a, b, x[i + 11], 0x10, 0x6d9d6122);
            HH(ref b, c, d, a, x[i + 14], 0x17, 0xfde5380c);
            HH(ref a, b, c, d, x[i + 1], 4, 0xa4beea44);
            HH(ref d, a, b, c, x[i + 4], 11, 0x4bdecfa9);
            HH(ref c, d, a, b, x[i + 7], 0x10, 0xf6bb4b60);
            HH(ref b, c, d, a, x[i + 10], 0x17, 0xbebfbc70);
            HH(ref a, b, c, d, x[i + 13], 4, 0x289b7ec6);
            HH(ref d, a, b, c, x[i], 11, 0xeaa127fa);
            HH(ref c, d, a, b, x[i + 3], 0x10, 0xd4ef3085);
            HH(ref b, c, d, a, x[i + 6], 0x17, 0x4881d05);
            HH(ref a, b, c, d, x[i + 9], 4, 0xd9d4d039);
            HH(ref d, a, b, c, x[i + 12], 11, 0xe6db99e5);
            HH(ref c, d, a, b, x[i + 15], 0x10, 0x1fa27cf8);
            HH(ref b, c, d, a, x[i + 2], 0x17, 0xc4ac5665);
            II(ref a, b, c, d, x[i], 6, 0xf4292244);
            II(ref d, a, b, c, x[i + 7], 10, 0x432aff97);
            II(ref c, d, a, b, x[i + 14], 15, 0xab9423a7);
            II(ref b, c, d, a, x[i + 5], 0x15, 0xfc93a039);
            II(ref a, b, c, d, x[i + 12], 6, 0x655b59c3);
            II(ref d, a, b, c, x[i + 3], 10, 0x8f0ccc92);
            II(ref c, d, a, b, x[i + 10], 15, 0xffeff47d);
            II(ref b, c, d, a, x[i + 1], 0x15, 0x85845dd1);
            II(ref a, b, c, d, x[i + 8], 6, 0x6fa87e4f);
            II(ref d, a, b, c, x[i + 15], 10, 0xfe2ce6e0);
            II(ref c, d, a, b, x[i + 6], 15, 0xa3014314);
            II(ref b, c, d, a, x[i + 13], 0x15, 0x4e0811a1);
            II(ref a, b, c, d, x[i + 4], 6, 0xf7537e82);
            II(ref d, a, b, c, x[i + 11], 10, 0xbd3af235);
            II(ref c, d, a, b, x[i + 2], 15, 0x2ad7d2bb);
            II(ref b, c, d, a, x[i + 9], 0x15, 0xeb86d391);
            A += a;
            B += b;
            C += c;
            D += d;
        }
        return new uint[] { A, B, C, D };
    }

    public static byte[] MD5Array(byte[] input)
    {
        MD5_Init();
        uint[] numArray2 = MD5_Trasform(MD5_Append(input));
        byte[] buffer = new byte[numArray2.Length * 4];
        int index = 0;
        for (int i = 0; index < numArray2.Length; i += 4)
        {
            buffer[i] = (byte)(numArray2[index] & 0xff);
            buffer[i + 1] = (byte)((numArray2[index] >> 8) & 0xff);
            buffer[i + 2] = (byte)((numArray2[index] >> 0x10) & 0xff);
            buffer[i + 3] = (byte)((numArray2[index] >> 0x18) & 0xff);
            index++;
        }
        return buffer;
    }

    public static string MDString(string message)
    {
        char[] chArray = message.ToCharArray();
        byte[] input = new byte[chArray.Length];
        for (int i = 0; i < chArray.Length; i++)
        {
            input[i] = (byte)chArray[i];
        }
        return ArrayToHexString(MD5Array(input), false);
    }
}
