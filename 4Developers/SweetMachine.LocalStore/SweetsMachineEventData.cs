using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SweetMachine.LocalStore
{
    public class SweetsMachineEventData
    {
        public string SerialNumber { get; set; }
        public int EventType { get; set; }
        public int EventValue1 { get; set; }
        public int EventValue2 { get; set; }
        public int EventValue3 { get; set; }
        public DateTime EventTime { get; set; }
        public DateTime EventProcessedUtcTime { get; set; }
        public int PartitionId { get; set; }
        public DateTime EventEnqueuedUtcTime { get; set; }
    }
}
