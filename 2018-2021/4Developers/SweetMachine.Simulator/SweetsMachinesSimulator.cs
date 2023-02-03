using SweetMachine.Simulator.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace SweetMachine.Simulator
{
    public delegate void SweetsMachinesSimulatorEventHandler(object sender, SweetsMachineSimulatorEventArg e);
    public class SweetsMachinesSimulator
    {

        private readonly int MaxProdCount = 5;
        private readonly int ProdQuantity = 50;
        private IList<SweetsMachine> _machines;
        public event SweetsMachinesSimulatorEventHandler MachineEvents;
        public SweetsMachinesSimulator(int machinesCount)
        {
            _machines = new List<SweetsMachine>();
            for (int i = 0; i < machinesCount; i++)
            {
                var machine = new SweetsMachine
                {
                    CurrentTemp = 8,
                    SerialNumber = $"SerialNr{i}"
                };
                for (int p = 0; p < MaxProdCount; p++)
                {
                    machine.Products.Add(new Product
                    {
                        ProdId = p,
                        CurrentState = ProdQuantity
                    });
                }
                _machines.Add(machine);
            }
        }
        public void LoadProducts()
        {
            foreach (var machine in _machines)
            {
                foreach(var p in machine.Products)
                {
                    p.CurrentState = ProdQuantity;
                }
            }
        }
        public void RunSweetsMachines(CancellationToken ct)
        {
            Task.Factory.StartNew(() =>
            {
                int maxIter = 3;
                int currentIter = 0;
                int stopIter = 0;
                while (true)
                {
                    foreach (var machine in _machines)
                    {
                        if (machine.Enabled)
                        {
                            machine.CurrentTemp = ComputeTemp(machine.CurrentTemp);
                            RaiseTempEvent(machine);
                            if (currentIter == maxIter)
                            {
                                currentIter = 0;
                                var rn = new Random(Guid.NewGuid().GetHashCode());
                                var buyMachines = _machines.Where(m => m.Enabled).
                                    OrderBy(m => Guid.NewGuid()).
                                    Take(rn.Next(1, _machines.Count));
                                BuyProduct(buyMachines);
                            }
                        }
                    }
                    currentIter++;
                    stopIter++;
                    Thread.Sleep(1000);
                    if (ct.IsCancellationRequested)
                    {
                        break;
                    }
                }
            }, ct);
        }
        private void BuyProduct(IEnumerable<SweetsMachine> machines)
        {
            foreach (var machine in machines)
            {
                var rn = new Random(Guid.NewGuid().GetHashCode());
                var buyProdId = rn.Next(0, machine.Products.Count);
                var product = machine.Products.FirstOrDefault(p => p.ProdId == buyProdId);
                if (product.CurrentState > 0)
                {
                   
                    product.CurrentState --;
                    RaiseBuyProductEvent(machine, product);
                }
            }
        }

        private void RaiseTempEvent(SweetsMachine machine)
        {
            MachineEvents?.Invoke(this, new SweetsMachineSimulatorEventArg
            {
                MachineSerialNumber = machine.SerialNumber,
                EventType = SweetsMachineEventTypes.TempSensor,
                Value1 = machine.CurrentTemp,
                EventTime = DateTime.UtcNow
            });
        }

        private void RaiseStopMachineEvent(SweetsMachine machine)
        {
            MachineEvents?.Invoke(this, new SweetsMachineSimulatorEventArg
            {
                MachineSerialNumber = machine.SerialNumber,
                EventType = SweetsMachineEventTypes.StopMachine,
                EventTime = DateTime.UtcNow
            });
        }

        private void RaiseBuyProductEvent(SweetsMachine machine, Product product)
        {
            var paymentType = 0; //Cash
            var rnPaymentType = new Random(Guid.NewGuid().GetHashCode());
            if (rnPaymentType.Next(5) == 0)
            {
                //Card
                paymentType = 1;
            }

            MachineEvents?.Invoke(this, new SweetsMachineSimulatorEventArg
            {
                MachineSerialNumber = machine.SerialNumber,
                EventType = SweetsMachineEventTypes.BuyProduct,
                Value1 = product.ProdId,
                Value2 = product.CurrentState,
                Value3 = paymentType,
                EventTime = DateTime.UtcNow
            });
        }

        private int ComputeTemp(int temp)
        {
            var changeRn = new Random(Guid.NewGuid().GetHashCode());
            if (changeRn.Next(10) == 0)
            {
                var rn = new Random(Guid.NewGuid().GetHashCode());
                return temp + rn.Next(-1, 2);
            }
            else
            {
                return temp;
            }
        }


    }
}
