CREATE VIEW [serve].[vwServeTemplateValue]
AS
SELECT TableId
	,KeyName
	,KeyValue
FROM [proc].vwProcTemplateParamValue

UNION ALL

SELECT Id AS TableId
	,'%%view_name%%' AS KeyName
	,'vw' + [Name] AS KeyValue
FROM [proc].TableConfig AS t

UNION ALL

SELECT t.Id AS TableId
	,'%%data_path%%' AS KeyName
	,c.[Value] + d.[Name] AS KeyValue
FROM [proc].TableConfig AS t
JOIN [proc].[DatabaseConfig] AS d ON d.Id = t.DatabaseConfigId
CROSS JOIN [serve].Config AS c
WHERE c.[Key] = '%%dwh_spark_path%%'

UNION ALL

SELECT Id AS TableId
	,'%%table_name_lower%%' AS KeyName
	,LOWER([Name]) AS KeyValue
FROM [proc].TableConfig AS t

UNION ALL

SELECT t.Id AS TableId
	,'%%serve_data_source%%' AS KeyName
	,c.[Value] AS KeyValue
FROM [proc].TableConfig AS t
CROSS JOIN [serve].Config AS c
WHERE c.[Key] = '%%serve_data_source%%'

UNION ALL

SELECT t.Id AS TableId
	,'%%view_name%%' AS KeyName
	,c.[Value] + '.vw' + [Name] AS KeyValue
FROM [proc].TableConfig AS t
CROSS JOIN [serve].Config AS c
WHERE c.[Key] = '%%serve_schema_name%%'

UNION ALL

SELECT c.TableId AS TableId
	,'%%serve_column_list_with_types%%' AS KeyName
	,STRING_AGG(CAST(c.ColumnName + ' ' + p.DataType + CASE 
				WHEN p.DataTypePrecision IS NOT NULL
					THEN '(' + CAST(p.DataTypePrecision AS VARCHAR) + ')'
				ELSE ''
				END AS VARCHAR(MAX)), ',') WITHIN
GROUP (
		ORDER BY c.Id
		) AS KeyValue
FROM [proc].ColumnConfig AS c
JOIN [dbo].DataSetProperty AS p ON p.Id = c.DataSetPropertyId
GROUP BY c.TableId
