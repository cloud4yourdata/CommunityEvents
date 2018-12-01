using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace DataGen
{
    class DeviceSimulator
    {
        private int _devCount;
        private string _filePath;
        private string _dirPath;
        public DeviceSimulator(int devCount,string dirPath)
        {
            _dirPath = dirPath;
            _devCount = devCount;
           
        }
        public void Generate(DateTime startDate, DateTime endDate)
        {
            var fileName = $"{startDate.ToString("yyyyMMdd")}_{Guid.NewGuid()}.csv";
            _filePath = Path.Combine(_dirPath, fileName);
            WriteHeader();
            var tm = (endDate - startDate).TotalSeconds;
            var lastValue = new Dictionary<int, int>();
            for (int i = 0; i < _devCount; i++)
            {
                lastValue[i] = 1;
            }
            for (var j = 0; j <= tm; j++)
            {
                for (int i = 0; i < _devCount; i++)
                {
                    lastValue[i] = GenerateNewValue(lastValue[i]);
                    var newDateTime = startDate.AddSeconds(j);
                    var time = newDateTime
                         .ToString("u");
                    var csvData = $"{i},{time},{lastValue[i]}{System.Environment.NewLine}";
                    File.AppendAllText(_filePath, csvData);
                    Console.WriteLine(csvData);
                }

            }
        }

        private int GenerateNewValue(int lastValue)
        {
            var rn = new Random(Guid.NewGuid().GetHashCode());
            var v = rn.Next(5);
            if (v == 0)
            {
                return --lastValue ;
            }
            return lastValue+2;
        }
        private void WriteHeader()
        {
            var header = "Id,MesDate,MesValue";
            header += System.Environment.NewLine;
            File.AppendAllText(_filePath, header);
        }

    }
}
