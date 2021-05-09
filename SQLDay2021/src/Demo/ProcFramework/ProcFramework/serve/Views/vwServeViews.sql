CREATE VIEW [serve].[vwServeViews]
AS
SELECT d.[Name] AS ProcDatabaseName
	,s.TableId
	,s.ViewStatement
	,s.ManifestPath
	,c.[Value] AS ServeDataSource
FROM [proc].DatabaseConfig AS d
JOIN [proc].TableConfig AS t ON t.DatabaseConfigId = d.Id
CROSS APPLY [serve].[tvf_GetServeViews](t.id) AS s
CROSS JOIN [serve].Config AS c
WHERE c.[Key] = '%%serve_data_source%%'
