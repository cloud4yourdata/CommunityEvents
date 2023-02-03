using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Azure.EventHubs;
using System.Linq;
using Newtonsoft.Json;
using SweetsMachine.EventHub.Sender.Model;

namespace SweetsMachine.EventHub.Sender
{
    public class SweetsMachineDataSender : ISweetsMachineDataSender
    {
        private EventHubClient _eventHubClient;

        public SweetsMachineDataSender(string eventHubConnectionString)
        {
            _eventHubClient = EventHubClient.CreateFromConnectionString(eventHubConnectionString);
        }

        public async Task SendDataAsync(SweetsMachineData sweetsMachineEvent)
        {
            EventData eventData = CreateEventData(sweetsMachineEvent);
            await _eventHubClient.SendAsync(eventData);
        }

        public async Task SendDataAsync(IEnumerable<SweetsMachineData> sweetsMachineEvents)
        {
            var eventDatas = sweetsMachineEvents.Select(sweetsMachineEvent => CreateEventData(sweetsMachineEvent));

            var eventDataBatch = _eventHubClient.CreateBatch();

            foreach (var eventData in eventDatas)
            {
                if (!eventDataBatch.TryAdd(eventData))
                {
                    await _eventHubClient.SendAsync(eventDataBatch);
                    eventDataBatch = _eventHubClient.CreateBatch();
                    eventDataBatch.TryAdd(eventData);
                }
            }

            if (eventDataBatch.Count > 0)
            {
               await _eventHubClient.SendAsync(eventDataBatch);
            }
        }

        private static EventData CreateEventData(SweetsMachineData data)
        {
            var dataAsJson = JsonConvert.SerializeObject(data);
            var eventData = new EventData(Encoding.UTF8.GetBytes(dataAsJson));
            return eventData;
        }
    }
}
