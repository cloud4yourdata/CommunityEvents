USE DCSQLServer2022MeetupGliwice;
/* DATA STUDIO
  CredentialName: FP-LSC0191-AdventureWorksDW2019-DemoPolybaseUser
  CredentialIdentity/User: DemoPolybaseUser
  Password: ***********
  DatasourceName: FP-LSC0191-AdventureWorksDW2019
  Location/Server: sqlserver://FP-LSC0191
  DBName:AdventureWorksDW2019
  Tables: DimProduct
          FactInternetSales
*/

SELECT * FROM sys.external_data_sources

SELECT *
	FROM sys.database_scoped_credentials

SELECT * FROM sys.external_tables 
WHERE [location] LIKE '%AdventureWorks%'

SELECT COUNT(*) FROM dbo.DimProduct;
SELECT COUNT(*) FROM dbo.FactInternetSales;