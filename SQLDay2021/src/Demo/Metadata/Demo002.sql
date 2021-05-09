SELECT ds.[Name],p.[Name] AS ColumnName,
p.DataType,
p.DataTypePrecision,
p.IsPrimayKey,
p.IsNullable
FROM dbo.DataSet AS ds
JOIN dbo.DataSetProperty AS p ON p.DataSetId=ds.Id;


WITH pks
AS (SELECT col.[name] AS ColumnName,
           tab.[name] AS TableName,
           s.[name] AS TableSchema
    FROM sys.tables tab
        INNER JOIN sys.indexes pk
            ON tab.object_id = pk.object_id
               AND pk.is_primary_key = 1
        INNER JOIN sys.index_columns ic
            ON ic.object_id = pk.object_id
               AND ic.index_id = pk.index_id
        INNER JOIN sys.columns col
            ON pk.object_id = col.object_id
               AND col.column_id = ic.column_id
        INNER JOIN sys.schemas s
            ON tab.schema_id = s.schema_id
   )
SELECT t.TABLE_NAME AS TableName,
       c.COLUMN_NAME AS ColumnName,
       c.ORDINAL_POSITION AS OrdinalPosition,
       TRY_CAST(IIF(c.IS_NULLABLE = 'YES', 1, 0)AS BIT) AS IsNullable,
       c.DATA_TYPE AS DataType,
       CHARACTER_MAXIMUM_LENGTH AS CharacterMaximumLength,
       NUMERIC_PRECISION AS NumericPrecision,
       NUMERIC_SCALE AS NumericScale,
       TRY_CAST(CASE
                    WHEN pks.ColumnName IS NOT NULL THEN
                        1
                    ELSE
                        0
                END AS BIT) AS IsPrimaryKey
FROM INFORMATION_SCHEMA.TABLES AS t
    INNER JOIN INFORMATION_SCHEMA.COLUMNS AS c
        ON t.TABLE_NAME = c.TABLE_NAME
           AND t.TABLE_SCHEMA = c.TABLE_SCHEMA
    LEFT JOIN pks
        ON t.TABLE_NAME = pks.TableName
           AND c.COLUMN_NAME = pks.ColumnName
           AND t.TABLE_SCHEMA = pks.TableSchema


---------------------------

SELECT 
ProcDatabaseName
,TableId
	,ViewStatement
	,ManifestPath
	,ServeDataSource
FROM [serve].[vwServeViews]
