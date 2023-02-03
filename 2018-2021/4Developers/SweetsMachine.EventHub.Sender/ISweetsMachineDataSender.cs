using SweetsMachine.EventHub.Sender.Model;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace SweetsMachine.EventHub.Sender
{
    interface ISweetsMachineDataSender
    {
        Task SendDataAsync(SweetsMachineData sweetsMachineEvent);
        Task SendDataAsync(IEnumerable<SweetsMachineData> sweetsMachineEvents);
    }
}
