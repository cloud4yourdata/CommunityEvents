using Microsoft.Analytics.Interfaces;
using Microsoft.Analytics.Types.Sql;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

namespace ADLAExt.Processors
{
    public class StackOverflowCategoryProducer : IProcessor
    {
        private static readonly IDictionary<string, IList<string>> categoryMapper =
            new Dictionary<string, IList<string>>
            {
                {"javascript", new List<string> {"javascript", "jquery"}},
                {"c++", new List<string> {"c++"}},
                {".net", new List<string> {"c#", ".net", "asp.net", "vb.net"}},
                {"java", new List<string> {"java"}},
                {"php", new List<string> {"php"}},
                {"sql", new List<string> {"sql", "mysql", "tsql"}},
                {"ruby-on-rails", new List<string> {"ruby-on-rails"}},
                {"azure", new List<string> {"azure"}},
                {"aws", new List<string> {"aws"}},
            };
        public override IRow Process(IRow input, IUpdatableRow output)
        {
            var tag = input.Get<string>("Tag");
            var category = input.Get<string>("Category");
            category = "other";
            foreach (var cat in categoryMapper)
            {
                var categoryName = cat.Key;
                var listOfPrefixes = cat.Value;
                var found = false;
                foreach (var pref in listOfPrefixes)
                {
                    if (tag.StartsWith(pref))
                    {
                        category = categoryName;
                        found = true;
                        break;
                    }
                }

                if (found)
                {
                    break;
                }
            }
            output.Set("Category", category);
            return output.AsReadOnly();
        }
    }
}