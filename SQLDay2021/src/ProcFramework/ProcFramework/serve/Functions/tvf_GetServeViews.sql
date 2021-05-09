CREATE FUNCTION [serve].[tvf_GetServeViews] (
	@tableId INT
	) 
RETURNS @statements TABLE (
	TableId INT
	,ViewStatement NVARCHAR(MAX)
	,ManifestPath NVARCHAR(MAX)
	)
AS
BEGIN
	DECLARE @viewDef NVARCHAR(MAX);
	DECLARE @manifestPath NVARCHAR(MAX);

	SELECT @viewDef = Template
	FROM [serve].[ServeTemplate]
	WHERE TypeId = 1;

	SELECT @manifestPath = Template
	FROM [serve].[ServeTemplate]
	WHERE TypeId = 2;

	SELECT @viewDef= REPLACE(@viewDef, p.KeyName, p.KeyValue)
		,@manifestPath = REPLACE(@manifestPath, p.KeyName, p.KeyValue)
	FROM [serve].vwServeTemplateValue AS p
	WHERE TableId = @tableId;

	SET @viewDef = REPLACE(REPLACE(@viewDef, CHAR(13) + CHAR(10), ''),CHAR(9),' ')

	INSERT @statements
	SELECT @tableId
		,@viewDef
		,@manifestPath

	RETURN
END
