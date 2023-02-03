 #r "Newtonsoft.Json"
using System;
using System.Net;
using Newtonsoft.Json;

public static void Run(string myEventHubMessage, TraceWriter log)
{
    var alerts = myEventHubMessage.Split(new string[] { System.Environment.NewLine }, StringSplitOptions.RemoveEmptyEntries);
            foreach(var alert in alerts)
            {
                var wAlert = JsonConvert.DeserializeObject<AltertEventData>(alert);
    log.Info($"WATER ALERT FOR OBJECT:{wAlert.id} MAX WATER LEVEL:{wAlert.maxwaterlevel} CURRENT LEVEL:{wAlert.waterlevel}");
            }
    
}

public class AltertEventData
{
    public string id { get; set; }
    public string waterlevel { get; set; }
    public string maxwaterlevel { get; set; }
}