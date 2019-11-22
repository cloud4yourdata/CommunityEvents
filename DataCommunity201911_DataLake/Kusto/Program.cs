using Microsoft.IdentityModel.Clients.ActiveDirectory;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace Kusto
{
    class Program
    {
        static async Task Main(string[] args)
        {

            await KustoTest();
            Console.ReadKey();
        }

        private static async Task KustoTest()
        {
            var csb = new SqlConnectionStringBuilder
            {
                InitialCatalog = "demos",
                DataSource = "adxdemos.northeurope.kusto.windows.net"


            };
            using (var connection = new SqlConnection(csb.ToString()))
            {
                connection.AccessToken = await ObtainToken();
                connection.Open();
                System.Console.WriteLine("KQL EXAMPLE");
                using (var command = new SqlCommand("sp_execute_kql", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    var query = new SqlParameter("@kql_query", SqlDbType.NVarChar);
                    command.Parameters.Add(query);
                    var parameter = new SqlParameter("myLimit", SqlDbType.Int);
                    command.Parameters.Add(parameter);
                    query.Value = "EnergyData | take myLimit";
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
                using (var command = new SqlCommand("SELECT TOP 3 * FROM EnergyData", connection))
                {
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

            }
        }

        private static async Task<string> ObtainToken()
        {
            var authContext = new AuthenticationContext(
              "https://login.microsoftonline.com/925460c6-df85-4de8-ab11-38b0891a7dff");
            var applicationCredentials = new ClientCredential(
              "*************************************",
              "*************************************");
            var result = await authContext.AcquireTokenAsync(
              "https://adxdemos.northeurope.kusto.windows.net",
              applicationCredentials);
            return result.AccessToken;
        }
    }
}
