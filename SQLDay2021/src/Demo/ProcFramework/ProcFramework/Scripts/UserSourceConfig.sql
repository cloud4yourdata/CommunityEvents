DECLARE @DataSource TABLE (
	[DataSourceTypeId] INT NOT NULL
	,[Name] VARCHAR(255) NOT NULL
	,[Description] NVARCHAR(255) NOT NULL
	);
DECLARE @DataSet TABLE (
	[DataSourceId] INT NOT NULL
	,[DataSetTypeId] INT NOT NULL
	,[Name] NVARCHAR(255) NOT NULL
	,[Descrition] NVARCHAR(255) NOT NULL
	);
DECLARE @DataSetProperty TABLE (
	[DataSetId] INT NOT NULL
	,[Name] VARCHAR(255)
	,[DataType] VARCHAR(255) NOT NULL
	,[DataTypePrecision] INT
	,[IsPrimayKey] BIT NOT NULL
	,[IsNullable] BIT NOT NULL
	);
DECLARE @DataSourceName VARCHAR(255) = 'Users';
DECLARE @DataSourceId INT;
DECLARE @DataSetName VARCHAR(255) = 'Users';
DECLARE @DataSetId INT;

INSERT INTO @DataSource (
	[DataSourceTypeId]
	,[Name]
	,[Description]
	)
VALUES (
	1
	,@DataSourceName
	,'Azure SQL Users DB'
	);

SET XACT_ABORT ON;

BEGIN TRAN;

MERGE [dbo].[DataSource] AS trg
USING (
	SELECT [DataSourceTypeId]
		,[Name]
		,[Description]
	FROM @DataSource
	) AS src
	ON (trg.[Name] = src.[Name])
WHEN MATCHED
	THEN
		UPDATE
		SET [DataSourceTypeId] = src.[DataSourceTypeId]
			,[Description] = src.[Description]
WHEN NOT MATCHED
	THEN
		INSERT (
			[DataSourceTypeId]
			,[Name]
			,[Description]
			)
		VALUES (
			src.[DataSourceTypeId]
			,src.[Name]
			,src.[Description]
			);

SELECT @DataSourceId = Id
FROM [dbo].DataSource
WHERE [Name] = @DataSourceName;

INSERT INTO @DataSet (
	DataSourceId
	,DataSetTypeId
	,[Name]
	,[Descrition]
	)
VALUES (
	@DataSourceId
	,1
	,@DataSetName
	,'Users Table'
	);

MERGE [dbo].[DataSet] AS trg
USING (
	SELECT DataSourceId
		,DataSetTypeId
		,[Name]
		,[Descrition]
	FROM @DataSet
	) AS src
	ON (
			trg.[Name] = src.[Name]
			AND trg.DataSetTypeId = src.DataSetTypeId
			)
WHEN MATCHED
	THEN
		UPDATE
		SET [DataSetTypeId] = src.[DataSetTypeId]
			,[Descrition] = src.[Descrition]
WHEN NOT MATCHED
	THEN
		INSERT (
			DataSourceId
			,DataSetTypeId
			,[Name]
			,[Descrition]
			)
		VALUES (
			src.DataSourceId
			,src.DataSetTypeId
			,src.[Name]
			,src.[Descrition]
			);

SELECT @DataSetId = Id
FROM [dbo].DataSet
WHERE [Name] = @DataSetName
	AND DataSourceId = @DataSourceId;

INSERT INTO @DataSetProperty (
	[DataSetId]
	,[Name]
	,[DataType]
	,[DataTypePrecision]
	,[IsPrimayKey]
	,[IsNullable]
	)
VALUES (
	@DataSetId
	,'UserId'
	,'INT'
	,NULL
	,1
	,0
	)
	,(
	@DataSetId
	,'UserName'
	,'VARCHAR'
	,100
	,0
	,0
	)
	,(
	@DataSetId
	,'UserRole'
	,'VARCHAR'
	,50
	,0
	,0
	);

MERGE [dbo].[DataSetProperty] AS trg
USING (
	SELECT [DataSetId]
		,[Name]
		,[DataType]
		,[DataTypePrecision]
		,[IsPrimayKey]
		,[IsNullable]
	FROM @DataSetProperty
	) AS src
	ON (
			trg.[Name] = src.[Name]
			AND trg.[DataSetId] = src.[DataSetId]
			)
WHEN MATCHED
	THEN
		UPDATE
		SET [DataType] = src.[DataType]
			,[DataTypePrecision] = src.[DataTypePrecision]
			,[IsPrimayKey] = src.[IsPrimayKey]
			,[IsNullable] = src.IsNullable
WHEN NOT MATCHED
	THEN
		INSERT (
			[DataSetId]
			,[Name]
			,[DataType]
			,[DataTypePrecision]
			,[IsPrimayKey]
			,[IsNullable]
			)
		VALUES (
			src.[DataSetId]
			,src.[Name]
			,src.[DataType]
			,src.[DataTypePrecision]
			,src.[IsPrimayKey]
			,src.[IsNullable]
			);

COMMIT TRAN;
