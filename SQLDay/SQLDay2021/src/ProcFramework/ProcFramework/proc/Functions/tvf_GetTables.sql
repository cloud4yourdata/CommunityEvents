CREATE FUNCTION [proc].[tvf_GetTables] ()
RETURNS TABLE
AS
RETURN (
		SELECT tc.Id AS TableId
			,'%%target_table%%' AS KeyName
			,dc.[Name] + '.' + tc.[Name] AS TableName
		FROM [proc].DatabaseConfig AS dc
		JOIN [proc].[TableConfig] AS tc ON tc.DatabaseConfigId = dc.Id
		
		UNION ALL
		
		SELECT tc.Id AS TableId
			,'%%stage_table%%' AS KeyName
			,dc.[StageDatabaseName] + '.' + tc.[Name] AS TableName
		FROM [proc].DatabaseConfig AS dc
		JOIN [proc].[TableConfig] AS tc ON tc.DatabaseConfigId = dc.Id
		)
