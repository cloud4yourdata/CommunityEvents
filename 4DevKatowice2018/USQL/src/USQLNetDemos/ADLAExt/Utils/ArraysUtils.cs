using Microsoft.Analytics.Interfaces;
using Microsoft.Analytics.Types.Sql;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

namespace ADLAExt.Utils
{
    public static class ArraysUtils
    {
        public static IList<string> MergeByPosition(string array1, string array2, string separator)
        {
            var result = new List<string>();
            var valArray1 = array1.Split(new string[] { separator }, StringSplitOptions.RemoveEmptyEntries);
            var valArray2 = array2.Split(new string[] { separator }, StringSplitOptions.RemoveEmptyEntries);
            for (int i = 0; i < valArray1.Length; i++)
            {
                var val1 = valArray1[i];
                var val2 = string.Empty;
                if (i < valArray2.Length)
                {
                    val2 = valArray2[i];
                }
                result.Add(val1 + separator + val2);
            }
            return result;
        }
    }
}