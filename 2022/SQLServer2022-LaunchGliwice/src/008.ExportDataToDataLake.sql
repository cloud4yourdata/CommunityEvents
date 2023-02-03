USE DCSQLServer2022MeetupGliwice;


--NEW CREDENTIAL USISNG POLICY
IF NOT EXISTS
(
	SELECT *
	FROM sys.database_scoped_credentials
	WHERE
		name = N'MyDataLakeCredentialExport'
)
BEGIN
	CREATE DATABASE SCOPED CREDENTIAL [MyDataLakeCredentialExport]
	WITH IDENTITY = 'SHARED ACCESS SIGNATURE',
	SECRET = 'si=********';
END;

--NEW EXTERNAL DATA SOURCE abs 
IF NOT EXISTS
(
	SELECT 1
	FROM sys.external_data_sources s
	WHERE
		s.name = N'MyLakehouseDataLakeExport'
)
BEGIN
	CREATE EXTERNAL DATA SOURCE MyLakehouseDataLakeExport WITH
	(
		LOCATION = 'abs://datalake2demos.blob.core.windows.net/datalake',
		CREDENTIAL = MyDataLakeCredentialExport
	);
END
--Msg 15883, Level 16, State 1, Line 1
--Access check for 'CREATE/WRITE' operation against 'adls://datalake2demos.dfs.core.windows.net/datalake/rawdata/exported/FactInternetSales/Version=1670692581/' failed with HRESULT = '0x80070057'.

--EPOCH TIME
DECLARE @version BIGINT;
SELECT @version=CAST(DATEDIFF(s,'1970-01-01 00:00:00',SYSDATETIME())AS BIGINT);
SELECT @version;

--CREATE TABLE SET GENERATED @version
CREATE EXTERNAL TABLE ExportedFactInternetSales
WITH (
    LOCATION = 'rawdata/exported/FactInternetSales/Version=1671129643/',
    DATA_SOURCE = MyLakehouseDataLakeExport,
    FILE_FORMAT = ParquetFileFormat
)  
AS 
SELECT * FROM [dbo].[FactInternetSales];

--CHECK DATA
SELECT r.filepath(1) AS [Version],*
FROM OPENROWSET(BULK 'rawdata/exported/FactInternetSales/Version=*/', DATA_SOURCE = 'MyLakehouseDataLakeExport', FORMAT = 'PARQUET') 
r
GO
--RUN ONCE AGAIN CREATE
CREATE EXTERNAL TABLE ExportedFactInternetSales
WITH (
    LOCATION = 'rawdata/exported/FactInternetSales/Version=1670692581/',
    DATA_SOURCE = MyLakehouseDataLakeExport,
    FILE_FORMAT = ParquetFileFormat
)  
AS 
SELECT * FROM [dbo].[FactInternetSales];

--DROP EXTERNAL TABLE 
DROP EXTERNAL TABLE ExportedFactInternetSales;
CREATE EXTERNAL TABLE ExportedFactInternetSales
WITH (
    LOCATION = 'rawdata/exported/FactInternetSales/Version=1670692581/',
    DATA_SOURCE = MyLakehouseDataLakeExport,
    FILE_FORMAT = ParquetFileFormat
)  
AS 
SELECT * FROM [dbo].[FactInternetSales];

--CREATE SP

IF OBJECT_ID('usp_DataExporter', 'P') IS NOT NULL
BEGIN
 DROP PROCEDURE dbo.usp_DataExporter
END
GO
---
CREATE PROCEDURE dbo.usp_DataExporter
    @table_name NVARCHAR(255),
    @data_location NVARCHAR(255),
    @data_query NVARCHAR(MAX)
AS
BEGIN
    DECLARE @version BIGINT;
	DECLARE @drop_existing NVARCHAR(MAX)='IF (OBJECT_ID(''@table_name'') IS NOT NULL)
	 BEGIN
	  DROP EXTERNAL TABLE @table_name;
	 END;'
	DECLARE @create_query NVARCHAR(MAX) = 'CREATE EXTERNAL TABLE @table_name 
	WITH (
    LOCATION = ''@data_location/Version=@version'',
    DATA_SOURCE = MyLakehouseDataLakeExport,
    FILE_FORMAT = ParquetFileFormat
)  
AS @data_query';

SET @drop_existing  = REPLACE(@drop_existing ,'@table_name',@table_name)
SELECT @version=CAST(DATEDIFF(s,'1970-01-01 00:00:00',SYSDATETIME())AS BIGINT);
SET @create_query= REPLACE(
					 REPLACE(
						REPLACE(
							REPLACE(@create_query,
							'@table_name',@table_name),
							'@version',@version),
							'@data_location',@data_location),
							'@data_query',@data_query);

EXEC sp_executesql @drop_existing;
EXEC sp_executesql @create_query;

PRINT 'Table has been created...';

END;
---------------------------
EXEC dbo.usp_DataExporter
    @table_name = N'dbo.ExportedFactInternetSales',
    @data_location = N'rawdata/exported/FactInternetSales',
    @data_query = N'SELECT * FROM [dbo].[FactInternetSales]'

--CHECK DATA
SELECT DISTINCT r.filepath(1) AS [Version]
FROM OPENROWSET(BULK 'rawdata/exported/FactInternetSales/Version=*/', 
DATA_SOURCE = 'MyLakehouseDataLakeExport', FORMAT = 'PARQUET') 
r


