CREATE FUNCTION [proc].tvf_GetProcStatements (
	@tableId INT
	,@loadId INT
	)
RETURNS @statements TABLE (
	TableId INT
	,DropStageStatement NVARCHAR(MAX)
	,CreateStageStatement NVARCHAR(MAX)
	,MergeStatement NVARCHAR(MAX)
	)
AS
BEGIN
	DECLARE @dropStageStatement NVARCHAR(MAX);
	DECLARE @createStageStatement NVARCHAR(MAX);
	DECLARE @mergeStatement NVARCHAR(MAX);

	SELECT @dropStageStatement = Template
	FROM [proc].[ProcTemplate]
	WHERE TypeId = 1;

	SELECT @createStageStatement = Template
	FROM [proc].[ProcTemplate]
	WHERE TypeId = 2;

	SELECT @mergeStatement = Template
	FROM [proc].[ProcTemplate]
	WHERE TypeId = 3;

	SELECT @dropStageStatement = REPLACE(@dropStageStatement, p.KeyName, p.KeyValue)
		,@createStageStatement = REPLACE(@createStageStatement, p.KeyName, p.KeyValue)
		,@mergeStatement = REPLACE(@mergeStatement, p.KeyName, p.KeyValue)
	FROM [proc].vwProcTemplateParamValue AS p
	WHERE TableId = @tableId;

	SELECT @createStageStatement = REPLACE(@createStageStatement, p.KeyName, p.KeyValue)
	FROM [proc].[tvf_GetDataToProcess](@loadId) AS p

	INSERT @statements
	SELECT @tableId
		,@dropStageStatement
		,@createStageStatement
		,@mergeStatement

	RETURN
END
