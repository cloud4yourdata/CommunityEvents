
--https://docs.microsoft.com/en-us/azure/sql-data-warehouse/load-data-from-azure-blob-storage-using-polybase
--USE devlabDW
SELECT t.name AS table_name, s.name as schema_name,
p.distribution_policy_desc
FROM sys.tables t JOIN sys.schemas s
ON t.schema_Id = s.schema_id
JOIN sys.pdw_table_distribution_properties p
ON t.object_id = p.object_id
/*
CREATE TABLE dbo.Trip_Hash
WITH
(
DISTRIBUTION = HASH ( MedallionId ),
CLUSTERED COLUMNSTORE INDEX
)
AS SELECT * FROM dbo.Trip
OPTION (LABEL='CTAS - Trip_Hash'); */

/*
CREATE TABLE dbo.Date_Replicated
WITH
(
CLUSTERED INDEX (DateId),
DISTRIBUTION = REPLICATED
)
AS SELECT * FROM dbo.Date
OPTION (LABEL='CTAS - Date_Replicated'); */



DBCC PDW_SHOWSPACEUSED('dbo.Trip')
DBCC PDW_SHOWSPACEUSED('dbo.Trip_Hash')

DBCC PDW_SHOWSPACEUSED('dbo.Date')
DBCC PDW_SHOWSPACEUSED('dbo.Date_Replicated')