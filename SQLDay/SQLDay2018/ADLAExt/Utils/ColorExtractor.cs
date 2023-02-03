using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace ADLAExt.Utils
{
    internal static class ColorExtractor
    {
        public static IDictionary<int, string> GetMostUsedColor(Bitmap theBitMap, int topColorCount)
        {
            var dctColorIncidence = GetPixelColors(theBitMap);
            var dctSortedByValueHighToLow = dctColorIncidence.OrderByDescending(x => x.Value)
                .ToDictionary(x => x.Key, x => x.Value);
            int i = 0;
            return dctSortedByValueHighToLow.Take(topColorCount).ToDictionary(kvp => i++, kvp => kvp.Key);
        }

        private static IDictionary<string, int> GetPixelColors(Bitmap theBitMap)
        {
            var dctColorIncidence = new Dictionary<string, int>();
            for (var row = 0; row < theBitMap.Size.Width; row++)
            {
                for (var col = 0; col < theBitMap.Size.Height; col++)
                {
                    var pixelColor = theBitMap.GetPixel(row, col).ToArgb();
                    string colorName;
                    var c = FindColour(Color.FromArgb(pixelColor), out colorName);
                    if (dctColorIncidence.Keys.Contains(colorName))
                    {
                        dctColorIncidence[colorName]++;
                    }
                    else
                    {
                        dctColorIncidence.Add(colorName, 1);
                    }
                }
            }
            return dctColorIncidence;
        }

        private static MatchType FindColour(Color colour, out string name)
        {
            var result = MatchType.NoMatch;
            var leastDifference = 0;
            name = colour.Name;

            foreach (
                var systemColour in
                    typeof(Color).GetProperties(BindingFlags.Static | BindingFlags.Public |
                                                 BindingFlags.FlattenHierarchy))
            {
                var systemColourValue = (Color)systemColour.GetValue(null, null);

                if (systemColourValue == colour)
                {
                    name = systemColour.Name;
                    result = MatchType.ExactMatch;
                    break;
                }

                int
                    a = colour.A - systemColourValue.A,
                    r = colour.R - systemColourValue.R,
                    g = colour.G - systemColourValue.G,
                    b = colour.B - systemColourValue.B,
                    difference = a * a + r * r + g * g + b * b;

                if (result == MatchType.NoMatch || difference < leastDifference)
                {
                    result = MatchType.ClosestMatch;
                    name = systemColour.Name;
                    leastDifference = difference;
                }
            }

            return result;
        }

        private enum MatchType
        {
            NoMatch,
            ExactMatch,
            ClosestMatch
        }
    }
}
