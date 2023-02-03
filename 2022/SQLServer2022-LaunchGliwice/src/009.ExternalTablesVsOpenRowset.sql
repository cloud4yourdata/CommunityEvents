
USE DCSQLServer2022MeetupGliwice;

CREATE EXTERNAL TABLE [dbo].[ExportedFactInternetSalesLake]
(
	[ProductKey] [int] NOT NULL,
	[OrderDateKey] [int] NOT NULL,
	[DueDateKey] [int] NOT NULL,
	[ShipDateKey] [int] NOT NULL,
	[CustomerKey] [int] NOT NULL,
	[PromotionKey] [int] NOT NULL,
	[CurrencyKey] [int] NOT NULL,
	[SalesTerritoryKey] [int] NOT NULL,
	[SalesOrderNumber] [nvarchar](20) NOT NULL,
	[SalesOrderLineNumber] [tinyint] NOT NULL,
	[RevisionNumber] [tinyint] NOT NULL,
	[OrderQuantity] [smallint] NOT NULL,
	[UnitPrice] [money] NOT NULL,
	[ExtendedAmount] [money] NOT NULL,
	[UnitPriceDiscountPct] [float] NOT NULL,
	[DiscountAmount] [float] NOT NULL,
	[ProductStandardCost] [money] NOT NULL,
	[TotalProductCost] [money] NOT NULL,
	[SalesAmount] [money] NOT NULL,
	[TaxAmt] [money] NOT NULL,
	[Freight] [money] NOT NULL,
	[CarrierTrackingNumber] [nvarchar](25) NULL,
	[CustomerPONumber] [nvarchar](25) NULL,
	[OrderDate] [datetime2](3) NULL,
	[DueDate] [datetime2](3) NULL,
	[ShipDate] [datetime2](3) NULL
)
WITH (DATA_SOURCE = [MyLakehouseDataLakeExport],
LOCATION = N'rawdata/exported/FactInternetSales/Version=1670779454',
FILE_FORMAT = [ParquetFileFormat],REJECT_TYPE = VALUE,REJECT_VALUE = 0);


---STATISTICS
SELECT s.name AS statistics_name
      ,c.name AS column_name
      ,sc.stats_column_id
FROM sys.stats AS s
INNER JOIN sys.stats_columns AS sc
    ON s.object_id = sc.object_id AND s.stats_id = sc.stats_id
INNER JOIN sys.columns AS c
    ON sc.object_id = c.object_id AND c.column_id = sc.column_id
WHERE s.object_id = OBJECT_ID('dbo.ExportedFactInternetSalesLake');

---
CREATE STATISTICS ExportedFactInternetSalesLakeProductKey ON dbo.ExportedFactInternetSalesLake (ProductKey) WITH FULLSCAN;
CREATE STATISTICS ExportedFactInternetSalesLakeOrderDateKey ON dbo.ExportedFactInternetSalesLake (OrderDateKey) WITH FULLSCAN;
---
SELECT s.name AS statistics_name
      ,c.name AS column_name
      ,s.*
FROM sys.stats AS s
INNER JOIN sys.stats_columns AS sc
    ON s.object_id = sc.object_id AND s.stats_id = sc.stats_id
INNER JOIN sys.columns AS c
    ON sc.object_id = c.object_id AND c.column_id = sc.column_id
WHERE s.object_id = OBJECT_ID('dbo.ExportedFactInternetSalesLake');

--PARTITION PRUNING/ELIMINATION
SELECT TOP 100 *
FROM OPENROWSET(BULK 'rawdata/exported/FactInternetSales/Version=*/', DATA_SOURCE = 'MyLakehouseDataLakeExport', FORMAT = 'PARQUET') 
r
WHERE r.filepath(1)=1670875085

----
--ENABLE TRACE FLAG
DBCC TRACEON (6408, -1); 

--BY DEFAULT EXTERNALPUSHDOWN IS ENABLED -SHOW ESTIMATED PLAN
SELECT TOP 100 * FROM dbo.FactInternetSales WHERE OrderDateKey BETWEEN 20101231 AND 20110131
OPTION (FORCE EXTERNALPUSHDOWN)

--DISABLE EXTERNALPUSHDOWN - RUN PROFILER 
-- FILTER : Database AdventureWorksDW2019 User:AdventureWorksDW2019
SELECT TOP 100 * FROM dbo.FactInternetSales WHERE OrderDateKey BETWEEN 20101231 AND 20110131
OPTION (DISABLE EXTERNALPUSHDOWN)