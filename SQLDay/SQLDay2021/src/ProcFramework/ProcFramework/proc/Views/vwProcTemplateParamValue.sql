CREATE VIEW [proc].vwProcTemplateParamValue
AS
SELECT t.TableId
	,KeyName
	,TableName AS KeyValue
FROM [proc].tvf_GetTables() AS t

UNION ALL

SELECT TableId
	,KeyName
	,ColumnList AS KeyValue
FROM [proc].[tvf_GetAllColumns]('stg.', '%%column_list_stg_prefix%%')

UNION ALL

SELECT TableId
	,KeyName
	,ColumnList AS KeyValue
FROM [proc].[tvf_GetHashColumns]('stg.', '%%column_list_hash_stg_prefix%%')

UNION ALL

SELECT TableId
	,KeyName
	,ColumnList AS KeyValue
FROM [proc].[tvf_GetPKsColumns]('stg.', '%%column_list_pks_stg_prefix%%')

UNION ALL

SELECT TableId
	,KeyName
	,ColumnList AS KeyValue
FROM [proc].[tvf_GetPKsColumns]('', '%%column_list_pks_prefix%%')

UNION ALL

SELECT TableId
	,KeyName
	,ColumnList AS KeyValue
FROM [proc].[tvf_GetAllColumns]('', '%%column_list%%')
