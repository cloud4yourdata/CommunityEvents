using Microsoft.Analytics.Interfaces;
using System;

namespace ADLAExt.Processors
{
    public class NameReverseProcessor : IProcessor
    {
        public override IRow Process(IRow input, IUpdatableRow output)
        {
            var s = input.Get<string>("name");
            output.Set<string>("reversed", Reverse(s));
            return output.AsReadOnly();
        }

        private static string Reverse(string s)
        {
            char[] charArray = s.ToCharArray();
            Array.Reverse(charArray);
            return new string(charArray);
        }
    }
}