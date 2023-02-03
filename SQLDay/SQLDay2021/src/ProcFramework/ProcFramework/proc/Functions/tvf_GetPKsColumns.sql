CREATE FUNCTION [proc].[tvf_GetPKsColumns] (
	@prefix VARCHAR(50)
	,@keyName VARCHAR(50)
	)
RETURNS TABLE
AS
RETURN (
		SELECT TableId
			,@keyName AS KeyName
			,STRING_AGG(CAST(@prefix + ColumnName AS VARCHAR(MAX)), ',') WITHIN
		GROUP (
				ORDER BY Id
				) AS ColumnList
		FROM [proc].ColumnConfig
		WHERE IsPrimaryKey = 1
		GROUP BY TableId
		)
