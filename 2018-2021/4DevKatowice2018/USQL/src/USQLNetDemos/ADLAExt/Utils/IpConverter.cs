using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace ADLAExt.Utils
{
    public static class IpConverter
    {
        public static string ToIp4Format(string ip)
        {
            return IPAddress.Parse(ip).MapToIPv4().ToString();
        }
    }
}
