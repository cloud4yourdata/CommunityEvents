using System;
using System.Collections.Generic;
using System.Device.Location;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ADLAExt.Utils
{
    public static class Gps
    {
        public static double ComputeDistance(double sLat, double sLong, double dLat, double dLong)
        {
            var locA = new GeoCoordinate(sLat, sLong);
            var locB = new GeoCoordinate(dLat, dLong);
            return locA.GetDistanceTo(locB); // metres
        }

        public static double ComputeDistance(string sLat, string sLong, string dLat, string dLong)
        {
            try
            {
                var locA = new GeoCoordinate(TypeConverter.ParseToDouble(sLat), TypeConverter.ParseToDouble(sLong));
                var locB = new GeoCoordinate(TypeConverter.ParseToDouble(dLat), TypeConverter.ParseToDouble(dLong));
                return locA.GetDistanceTo(locB); // metres
            }
            catch (Exception)
            {
                return -1;
            }

        }
    }

}
