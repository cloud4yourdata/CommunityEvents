using SweetMachine.LocalStore;
using SweetMachine.Simulator;
using SweetMachine.Simulator.Model;
using SweetsMachine.EventHub.Sender;
using SweetsMachine.EventHub.Sender.Model;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace SweetsMachineSimulatorApp
{
    public partial class Main : Form
    {
        private SweetsMachinesSimulator _simulator;
        private CancellationTokenSource _ts;
        private SweetsMachineDataSender _eventHubSender;
        private LocalFileStore _localFileStore;
        private string baseDir = @"d:\Repos\Cloud4YourData\Demos\4Developers\Data\";
        public Main()
        {
            InitializeComponent();
            _simulator = new SweetsMachinesSimulator(10);
            _simulator.MachineEvents += _simulator_MachineEvents;
            var eventHubConnectionString = ConfigurationManager.AppSettings["EventHubConnectionString"];
            _eventHubSender = new SweetsMachineDataSender(eventHubConnectionString);
            _localFileStore = new LocalFileStore(baseDir);

        }

        private void _simulator_MachineEvents(object sender, SweetsMachineSimulatorEventArg e)
        {
            switch (e.EventType)
            {
                case SweetsMachineEventTypes.BuyProduct:
                     AddLog(e.ToString());
                    break;
                case SweetsMachineEventTypes.TempSensor:
                    AddLogTemp(e.ToString());
                    break;
            }
            if (rbSendToCloud.Checked)
            {
                _eventHubSender.SendDataAsync(ConvertToEventHub(e));
            }
            _localFileStore.Save(ConvertToLocalStoreData(e));

        }

        private void button1_Click(object sender, EventArgs e)
        {
            _ts = new CancellationTokenSource();
            _simulator.RunSweetsMachines(_ts.Token);
        }

        private void btnStop_Click(object sender, EventArgs e)
        {
            _ts.Cancel();
            
        }

        private void AddLog(string logInfo)
        {
            if (InvokeRequired)
            {
                BeginInvoke(new Action(() =>
                {
                    rtbLog.AppendText(logInfo);
                    rtbLog.AppendText(Environment.NewLine);
                }));
            }
            else
            {
                rtbLog.AppendText(logInfo);
                rtbLog.AppendText(Environment.NewLine);
            }
        }

        private void AddLogTemp(string logInfo)
        {
            if (InvokeRequired)
            {
                BeginInvoke(new Action(() =>
                {
                    if (rtbTemp.Lines.Count() > 200)
                    {
                        rtbTemp.Clear();
                    }
                    rtbTemp.AppendText(logInfo);
                    rtbTemp.AppendText(Environment.NewLine);
                    
                }));
            }
            else
            {
                if (rtbTemp.Lines.Count() > 200)
                {
                    rtbTemp.Clear();
                }
                rtbTemp.AppendText(logInfo);
                rtbTemp.AppendText(Environment.NewLine);
            }
        }

        private static SweetsMachineData ConvertToEventHub(SweetsMachineSimulatorEventArg e)
        {
            return new SweetsMachineData
            {
                EventTime = e.EventTime,
                EventType = (int)e.EventType,
                EventValue1 = e.Value1,
                EventValue2 = e.Value2,
                EventValue3 = e.Value3,
                SerialNumber = e.MachineSerialNumber
            };
        }

        private static SweetsMachineEventData ConvertToLocalStoreData(SweetsMachineSimulatorEventArg e)
        {
            return new SweetsMachineEventData
            {
                EventTime = e.EventTime,
                EventType = (int)e.EventType,
                EventValue1 = e.Value1,
                EventValue2 = e.Value2,
                EventValue3 = e.Value3,
                SerialNumber = e.MachineSerialNumber
            };
        }


        private void btnLoad_Click(object sender, EventArgs e)
        {
            _simulator.LoadProducts();
        }
    }
}
