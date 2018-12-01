using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataGen
{
    class Program
    {
        static void Main(string[] args)
        {
            var path = @"d:\Repos\Cloud4YourData\SQLDay2018\Misc\DeviceData\";
            var gen = new DeviceSimulator(1, path);
            var endDate = DateTime.Parse("2018-05-11 00:00:00");
            var startDate = endDate.AddDays(-1);
            gen.Generate(startDate, endDate);
            Console.ReadKey();
        }
    }
}
