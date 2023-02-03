using Microsoft.Analytics.Interfaces;
using Microsoft.Analytics.Types.Sql;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Management;
using System.Text;

namespace ADLAExt.Utils
{
    public static class VertextInfo
    {
        public static string GetInfo()
        {
            var info = "";
            var procQuery = "SELECT Name,NumberOfCores FROM Win32_Processor";
            var pObjectSearchersearcher = new ManagementObjectSearcher(procQuery);
            foreach (ManagementObject WniPART in pObjectSearchersearcher.Get())
            {
                info =
                    $"Processor:{WniPART.Properties["Name"].Value};NumberOfCores:{WniPART.Properties["NumberOfCores"].Value};";
            }

            var Query = "SELECT Capacity FROM Win32_PhysicalMemory";
            var searcher = new ManagementObjectSearcher(Query);
            var totalMemorySizeInGb = (from ManagementObject wniPart in searcher.Get()
                                       select Convert.ToUInt64(wniPart.Properties["Capacity"].Value)
                into sizeinByte
                                       select sizeinByte / 1024 / 1024 / 1024).Aggregate<ulong, ulong>(0, (current, sizeinGb) => current + sizeinGb);
            info += $"RAM Size in GB: {totalMemorySizeInGb}";
            return info;
        }

        public static string GetFullInfo()
        {
            var sb = new StringBuilder();
            var myManagementClass = new
                ManagementClass("Win32_OperatingSystem");
            var myManagementCollection =
                myManagementClass.GetInstances();
            var myProperties =
                myManagementClass.Properties;
            var myPropertyResults =
                new Dictionary<string, object>();

            foreach (var obj in myManagementCollection)
            {
                foreach (var myProperty in myProperties)
                {
                    myPropertyResults.Add(myProperty.Name,
                        obj.Properties[myProperty.Name].Value);
                }
            }

            foreach (var myPropertyResult in myPropertyResults)
            {
                var item = $"{myPropertyResult.Key}:{myPropertyResult.Value}";
                sb.AppendLine(item);
            }
            return sb.ToString();
        }

        public static string GetVMInfo()
        {
            var sb = new StringBuilder();
            var myManagementClass = new
                ManagementClass("Win32_PerfRawData_Counters_HyperVDynamicMemoryIntegrationService");
            var myManagementCollection =
                myManagementClass.GetInstances();
            var myProperties =
                myManagementClass.Properties;
            var myPropertyResults =
                new Dictionary<string, object>();

            foreach (var obj in myManagementCollection)
            {
                foreach (var myProperty in myProperties)
                {
                    myPropertyResults.Add(myProperty.Name,
                        obj.Properties[myProperty.Name].Value);
                }
            }

            foreach (var myPropertyResult in myPropertyResults)
            {
                var item = $"{myPropertyResult.Key}:{myPropertyResult.Value}";
                sb.AppendLine(item);
            }
            return sb.ToString();
        }

        public static string GetDrivesInfo()
        {
            var sb = new StringBuilder();
            var driveQuery = new ManagementObjectSearcher("select * from Win32_DiskDrive");
            foreach (ManagementObject d in driveQuery.Get())
            {
                var partitionQueryText = string.Format("associators of {{{0}}} where AssocClass = Win32_DiskDriveToDiskPartition", d.Path.RelativePath);
                var partitionQuery = new ManagementObjectSearcher(partitionQueryText);
                foreach (ManagementObject p in partitionQuery.Get())
                {

                    var logicalDriveQueryText = string.Format("associators of {{{0}}} where AssocClass = Win32_LogicalDiskToPartition", p.Path.RelativePath);
                    var logicalDriveQuery = new ManagementObjectSearcher(logicalDriveQueryText);
                    foreach (ManagementObject ld in logicalDriveQuery.Get())
                    {
                        sb.AppendLine(ld["Name"].ToString());
                    }
                }

            }

            return sb.ToString();
        }

        public static string GetInstalledApps()
        {
            var sb = new StringBuilder();
            ManagementObjectSearcher mos = new ManagementObjectSearcher("SELECT * FROM Win32_Product");
            foreach (ManagementObject mo in mos.Get())
            {
                sb.AppendLine(mo["Name"].ToString());
            }
            return sb.ToString();
        }

        public static string ListDirectories(string path)
        {
            var sb = new StringBuilder();
            foreach (var d in Directory.GetDirectories(path))
            {
                sb.AppendLine(d);
            }
            return sb.ToString();
        }

        public static string ListCurrentDir()
        {
            var sb = new StringBuilder();
            foreach (var df in Directory.GetFileSystemEntries(Directory.GetCurrentDirectory(), "*", SearchOption.AllDirectories))
            {
                sb.AppendLine(df);
            }
            return sb.ToString();
        }

        public static string ListDrivesFiles(string drive)
        {
            var sb = new StringBuilder();
            foreach (var df in Directory.GetFileSystemEntries(drive, " * ", SearchOption.AllDirectories))
            {
                sb.AppendLine(df);
            }
            return sb.ToString();
        }
    }

}