CREATE FUNCTION [proc].[tvf_GetAllColumns] (
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
		GROUP BY TableId
		)
