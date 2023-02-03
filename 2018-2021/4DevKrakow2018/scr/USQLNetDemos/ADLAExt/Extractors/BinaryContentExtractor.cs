using Microsoft.Analytics.Interfaces;
using Microsoft.Analytics.Types.Sql;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

namespace ADLAExt.Extractors
{
    [SqlUserDefinedExtractor(AtomicFileProcessing = true)]
    public class BinaryContentExtractor : IExtractor
    {
        public override IEnumerable<IRow> Extract(IUnstructuredReader input, IUpdatableRow output)
        {
            using (var ms = new MemoryStream())
            {
                input.BaseStream.CopyTo(ms);
                var content = ms.ToArray();
                output.Set(0, content);
                yield return output.AsReadOnly();
            }
        }
    }

}