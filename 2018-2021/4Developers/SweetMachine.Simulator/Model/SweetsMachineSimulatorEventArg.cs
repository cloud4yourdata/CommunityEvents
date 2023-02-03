using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SweetMachine.Simulator.Model
{
    public class SweetsMachineSimulatorEventArg: EventArgs
    {
        public string MachineSerialNumber { get; set; }
        public SweetsMachineEventTypes EventType { get; set; }
        public int Value1 { get; set; }
        public int Value2 { get; set; }
        public int Value3 { get; set; }
        public int Value4 { get; set; }
        public DateTime EventTime { get; set; }

        public override string ToString()
        {
            string desc = string.Empty;
            switch(EventType)
            {
                case SweetsMachineEventTypes.BuyProduct:
                    desc = $"EventType:BuyProduct # MachineSerialNumber:{MachineSerialNumber} " +
                        $"# ProductId:{Value1} # CurrentState:{Value2}";
                    break;
                case SweetsMachineEventTypes.TempSensor:
                    desc = $"EventType:TempSensor # MachineSerialNumber:{MachineSerialNumber} " +
                        $"# Temperature:{Value1}";
                    break;
                case SweetsMachineEventTypes.StopMachine:
                    desc = $"EventType:StopMachine # MachineSerialNumber:{MachineSerialNumber} ";
                    break;

            }
            return desc;
        }
    }
}
