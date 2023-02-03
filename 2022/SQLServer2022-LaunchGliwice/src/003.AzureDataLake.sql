USE DCSQLServer2022MeetupGliwice;

---OPEN MASTER KEY 
OPEN MASTER KEY DECRYPTION BY PASSWORD = 'P@$$w0rd1234!';

---CREATE CREDENTIALS --ONLY SAS (SHOW HOW TO GENERATE SAS)
IF NOT EXISTS
(
	SELECT *
	FROM sys.database_scoped_credentials
	WHERE
		name = N'MyDataLakeCredential'
)
BEGIN
	CREATE DATABASE SCOPED CREDENTIAL [MyDataLakeCredential]
	WITH IDENTITY = 'SHARED ACCESS SIGNATURE',
	SECRET = 'si=***************';
END;

SELECT *
	FROM sys.database_scoped_credentials
	WHERE
		name = N'MyDataLakeCredential';



/*CREATE DATA SOURCE
Azure Storage Account(V2)	    abs	    abs://<storage_account_name>.blob.core.windows.net/<container_name>
Azure Data Lake Storage Gen2	adls	adls://<storage_account_name>.dfs.core.windows.net/<container_name>
*/
IF NOT EXISTS
(
	SELECT 1
	FROM sys.external_data_sources s
	WHERE
		s.name = N'MyLakehouseDataLake'
)
BEGIN
	CREATE EXTERNAL DATA SOURCE MyLakehouseDataLake WITH
	(
		LOCATION = 'adls://datalake@datalake2demos.dfs.core.windows.net',
		CREDENTIAL = MyDataLakeCredential
	);
END
--CHECK DATA SOURCES
SELECT *
	FROM sys.external_data_sources s
	WHERE
		s.name = N'MyLakehouseDataLake'


