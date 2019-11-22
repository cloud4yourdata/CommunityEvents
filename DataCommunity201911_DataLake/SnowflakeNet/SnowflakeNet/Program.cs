using Snowflake.Data.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SnowflakeNet
{
    class Program
    {
        static void Main(string[] args)
        {
            using (IDbConnection conn = new SnowflakeDbConnection())
            {
                conn.ConnectionString =
                    "account=cp29156;host=cp29156.west-europe.azure.snowflakecomputing.com;user=**;password=****;db=FPCLOUD;schema=STAGE;WAREHOUSE=MYLAB_DW";
                conn.Open();

                IDbCommand cmd = conn.CreateCommand();
                cmd.CommandText = @"SELECT * FROM vwStreetCrimesExt WHERE DateReported=to_date('2017-07-01','YYYY-MM-DD')
                                    AND date_part = to_date('2017-07-01', 'YYYY-MM-DD')
                                    LIMIT 12; ";
                IDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    Console.WriteLine(reader.GetString(0));
                }

                conn.Close();
            }
            Console.ReadKey();
        }
    }
}
