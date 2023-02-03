USE DCSQLServer2022MeetupGliwice;
--CREATE FORMAT
IF NOT EXISTS
(
    SELECT 1
    FROM sys.external_file_formats e
    WHERE  
        e.name = N'DeltaFileFormat'
)
BEGIN
    CREATE EXTERNAL FILE FORMAT DeltaFileFormat WITH
    (
        FORMAT_TYPE = DELTA
    );
END;

--CREATE FORMAT
IF NOT EXISTS
(
    SELECT 1
    FROM sys.external_file_formats e
    WHERE  
        e.name = N'ParquetFileFormat'
)
BEGIN
    CREATE EXTERNAL FILE FORMAT ParquetFileFormat WITH
    (
        FORMAT_TYPE = PARQUET
    );
END;

SELECT * FROM sys.external_file_formats

--CREATE EXTRANAL TABLE
IF (OBJECT_ID('dbo.DimCustomerExt') IS NULL)
BEGIN
CREATE EXTERNAL TABLE [dbo].[DimCustomerExt] 
(
         [CustomerKey] BIGINT
		,[CustomerID] INT
		,[AccountNumber] VARCHAR(510)
		,[FirstName] VARCHAR(510)
		,[IsDeleted] BIT
		,[LastName] VARCHAR(510)
		,[ModifiedDate] DATETIME2(7)
		,[PersonId] INT
		,[Title] VARCHAR(510)
		,[DlhIsCurrent] BIT
		,[DlhIsDeleted] BIT
		,[DlhValidFrom] DATETIME2(7)
		,[DlhValidTo] DATETIME2(7) 
)
 WITH (
        LOCATION='analytics_zone/DWHS/DWHDemo/dimcustomer',
        DATA_SOURCE = MyLakehouseDataLake,
        FILE_FORMAT = DeltaFileFormat
    )
END

SELECT TOP 100 * FROM [dbo].[DimCustomerExt];

