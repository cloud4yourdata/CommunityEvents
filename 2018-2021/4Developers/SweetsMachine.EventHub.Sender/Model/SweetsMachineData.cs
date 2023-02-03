using System;
using System.Collections.Generic;
using System.Text;

namespace SweetsMachine.EventHub.Sender.Model
{
    public class SweetsMachineData
    {
        public string SerialNumber { get; set; }
        public int EventType { get; set; }
        public int EventValue1 { get; set; }
        public int EventValue2 { get; set; }
        public int EventValue3 { get; set; }
        public DateTime EventTime { get; set; }
    }
}
