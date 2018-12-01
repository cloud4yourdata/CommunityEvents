using Microsoft.Analytics.Interfaces;
using Microsoft.Analytics.Types.Sql;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

namespace ADLAExt.Reducers
{
    public class BreakRangeReducer : IReducer
    {
        const string BeginColName = "begin";
        const string EndColName = "end";
        const string ValueColName = "value";
        private readonly int _maxDuration;
        public BreakRangeReducer(int maxDuration)
        {
            _maxDuration = maxDuration;
        }
        public override IEnumerable<IRow> Reduce(IRowset input, IUpdatableRow output)
        {
            // Init aggregation values
            var firstRowProcessed = false;
            var begin = DateTime.MinValue;
            var end = DateTime.MinValue;
            var finalvalue = 0.0;
            // requires that the reducer is PRESORTED on begin and READONLY on the reduce key.
            foreach (var row in input.Rows)
            {
                if (!firstRowProcessed)
                {
                    firstRowProcessed = true;
                    begin = row.Get<DateTime>(BeginColName);
                    end = row.Get<DateTime>(EndColName);
                    finalvalue = row.Get<double>(ValueColName);
                }
                else
                {
                    var b = row.Get<DateTime>(BeginColName);
                    var e = row.Get<DateTime>(EndColName);
                    var tmpvalue = row.Get<double>(ValueColName);
                    if ((b - end).TotalSeconds <= _maxDuration)
                    {
                        finalvalue += tmpvalue;
                    }
                    else
                    {
                        output.Set<double>(ValueColName, finalvalue);
                        output.Set<DateTime>(BeginColName, begin);
                        output.Set<DateTime>(EndColName, end);

                        yield return output.AsReadOnly();
                        finalvalue = tmpvalue;
                        begin = b;
                    }
                    end = e;

                }
            }
            output.Set<DateTime>(BeginColName, begin);
            output.Set<DateTime>(EndColName, end);
            output.Set<double>(ValueColName, finalvalue);
            yield return output.AsReadOnly();
        }
    }
}