using Microsoft.Analytics.Interfaces;
using Microsoft.Analytics.Types.Sql;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;

namespace ADLAExt.Extractors
{
    [SqlUserDefinedExtractor(AtomicFileProcessing = true)]
    public class Log4NetExtractor : IExtractor
    {
        public override IEnumerable<IRow> Extract(IUnstructuredReader input, IUpdatableRow output)
        {
            var firstLine = true;
            var newEntry = false;
            using (TextReader reader = new StreamReader(input.BaseStream))
            {
                var logEntry = new StringBuilder();
                while (reader.Peek() >= 0)
                {
                    var line = reader.ReadLine();
                    if (firstLine)
                    {
                        logEntry.Append(line);
                    }
                    else
                    {
                        if (IsNewLine(line))
                        {
                            newEntry = true;
                        }
                        else
                        {
                            logEntry.Append(line);
                        }
                    }
                    if (newEntry)
                    {
                        var e = logEntry.ToString();
                        var l4n = ParseLogEntry(e);
                        output.Set(0, l4n.Level);
                        output.Set(1, l4n.Date);
                        output.Set(2, l4n.ThreadId);
                        output.Set(3, l4n.Message);
                        yield return output.AsReadOnly();
                        logEntry.Clear();
                        newEntry = false;
                        logEntry.Append(line);
                    }
                    firstLine = false;
                }
            }
        }

        private static Log4NetEntry ParseLogEntry(string entry)
        {
            var p = entry.Split(new[] { "] - " }, StringSplitOptions.RemoveEmptyEntries);
            var info = p[0].Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
            var message = p[1];
            var level = info[0];
            DateTime date = new DateTime();
            DateTime? logDate = null;
            if (DateTime.TryParseExact(info[1] + " " + info[2], "yyyy-MM-dd HH:mm:ss,fff",
                CultureInfo.InvariantCulture, DateTimeStyles.None, out date))
            {
                logDate = date;
            }
            int? logThreadId = null;
            int threadId;
            if (int.TryParse(info[3].Replace("[", string.Empty), out threadId))
            {
                logThreadId = threadId;
            }
            return new Log4NetEntry { Level = level, Date = logDate, ThreadId = logThreadId, Message = message };
        }

        private static bool IsNewLine(string line)
        {
            var l = line.TrimStart();
            return l.StartsWith("ERROR") || l.StartsWith("DEBUG") ||
                   l.StartsWith("INFO") || l.StartsWith("WARN");
        }

        private class Log4NetEntry
        {
            public DateTime? Date;
            public string Level;
            public string Message;
            public int? ThreadId;
        }
    }
}