using CsvHelper;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SweetMachine.LocalStore
{
    public class LocalFileStore
    {
        private string _filePath;
        private bool _isHeader = false;
        public LocalFileStore(string filePath)
        {
            var fileName = $"{DateTime.UtcNow.ToString("yyyyMMdd")}_{Guid.NewGuid()}.csv";
            _filePath = Path.Combine(filePath,fileName);
              
        }

        public void Save(SweetsMachineEventData dataEvent)
        {
            if(!_isHeader)
            {
                WriteHeader();
                _isHeader = true;
            }
            dataEvent.PartitionId = 0;
            dataEvent.EventEnqueuedUtcTime = dataEvent.EventTime;
            dataEvent.EventProcessedUtcTime = dataEvent.EventTime;
            var time = dataEvent.EventTime.ToUniversalTime()
                         .ToString("yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'fff'Z'");
            var csvData = $"{dataEvent.SerialNumber},{dataEvent.EventType},{dataEvent.EventValue1}," +
                 $"{dataEvent.EventValue2},{dataEvent.EventValue3}," +
                 $"{time},{time}," +
                 $"{dataEvent.PartitionId}," +
                 $"{time}{System.Environment.NewLine}";
            File.AppendAllText(_filePath, csvData);
        }

        private void WriteHeader()
        {
            var header = "SerialNumber,EventType,EventValue1,EventValue2,EventValue3,EventTime," +
                "EventProcessedUtcTime,PartitionId,EventEnqueuedUtcTime";
            header+=System.Environment.NewLine;
            File.AppendAllText(_filePath, header);
        }

    }
}
