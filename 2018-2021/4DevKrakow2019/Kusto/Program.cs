using System;
using System.Data;
using System.Data.SqlClient;

namespace Kusto
{
    class Program
    {
        static void Main(string[] args)
        {

            KustoTest();
            Console.ReadKey();
        }

        private static void KustoTest()
        {
            var csb = new SqlConnectionStringBuilder
            {
                InitialCatalog = "Samples",
                Authentication = SqlAuthenticationMethod.ActiveDirectoryIntegrated,
                DataSource = "help.kusto.windows.net",
                
            };
            using (var connection = new SqlConnection(csb.ToString()))
            {
                connection.Open();
                System.Console.WriteLine("KQL EXAMPLE");
                using (var command = new SqlCommand("sp_execute_kql", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    var query = new SqlParameter("@kql_query", SqlDbType.NVarChar);
                    command.Parameters.Add(query);
                    var parameter = new SqlParameter("myLimit", SqlDbType.Int);
                    command.Parameters.Add(parameter);
                    query.Value = "StormEvents | take myLimit";
                    parameter.Value = 3;
                    using (var reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            for (int i = 0; i < reader.FieldCount; i++)
                            {
                                System.Console.Write("{0}|", reader[i]);
                            }
                            System.Console.WriteLine();
                        }
                    }
                }
                System.Console.WriteLine("SQL EXAMPLE");
                using (var command = new SqlCommand("SELECT TOP 3 * FROM StormEvents", connection))
                {
                    using (var reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            for (int i =0 ; i < reader.FieldCount; i++)
                            {
                                System.Console.Write("{0}|",reader[i]);
                            }
                            System.Console.WriteLine();
                        }
                    }
                }

            }
        }
    }
}
