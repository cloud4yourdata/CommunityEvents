USE DCSQLServer2022MeetupGliwice;
--PARQUET
SELECT COUNT(*)
FROM OPENROWSET(
BULK 'analytics_zone/DWHS/DWHDemo/dimcustomer/DlhIsCurrent=*/*/',
DATA_SOURCE = 'MyLakehouseDataLake',
FORMAT = 'PARQUET'
) AS r;

--DELTA
SELECT count(*)
FROM OPENROWSET( BULK 'analytics_zone/DWHS/DWHDemo/dimcustomer',
DATA_SOURCE = 'MyLakehouseDataLake',
FORMAT = 'DELTA'
) AS r;

--DATASET
SELECT TOP 100 *
	FROM OPENROWSET( BULK 'analytics_zone/DWHS/DWHDemo/dimcustomer',
DATA_SOURCE = 'MyLakehouseDataLake',
FORMAT = 'DELTA'
) AS r

--DESCRIBE DATASET
EXEC sp_describe_first_result_set N'SELECT TOP 1 * FROM OPENROWSET(
BULK ''analytics_zone/DWHS/DWHDemo/dimcustomer'',
DATA_SOURCE = ''MyLakehouseDataLake'',
FORMAT = ''DELTA''
) AS r'


IF EXISTS(SELECT 1 FROM sys.views where [name] = 'vwDimCustomerExt')
BEGIN
	DROP VIEW [dbo].[vwDimCustomerExt];
END
---CREATE VIEW
CREATE OR ALTER VIEW [dbo].[vwDimCustomerExt]
AS
SELECT *
FROM OPENROWSET(BULK 'analytics_zone/DWHS/DWHDemo/dimcustomer', DATA_SOURCE = 'MyLakehouseDataLake', FORMAT = 'DELTA')
 WITH (
		[CustomerKey] BIGINT
		,[CustomerID] INT
		,[AccountNumber] VARCHAR(510)
		,[FirstName] VARCHAR(510)
		,[IsDeleted] BIT
		,[LastName] VARCHAR(510)
		,[ModifiedDate] DATETIME2(7)
		,[PersonId] INT
		,[Title] VARCHAR(510)
		,[DlhDmlAction] INT
		,[DlhEtlProcLogId] BIGINT
		,[DlhInsertEtlProcLogId] BIGINT
		,[DlhIsCurrent] BIT
		,[DlhIsDeleted] BIT
		,[DlhLoadDate] DATETIME2(7)
		,[DlhRowHash] VARCHAR(510)
		,[DlhUpdateDate] DATETIME2(7)
		,[DlhUpdateEtlProcLogId] BIGINT
		,[DlhValidFrom] DATETIME2(7)
		,[DlhValidTo] DATETIME2(7)
		,[DlhVersion] INT
		) r
GO

SELECT TOP 100 * FROM [dbo].[vwDimCustomerExt]

