using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SweetMachine.Simulator.Model
{
    public class SweetsMachine
    {
        public string SerialNumber { get; set; }
        public int CurrentTemp { get; set; }
        public bool Enabled { get; set; }
        public IList<Product> Products { get; private set;}
        public SweetsMachine()
        {
            Products = new List<Product>();
            Enabled = true;
        }
    }
}
