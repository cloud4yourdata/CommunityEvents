DECLARE @DatabaseConfig AS TABLE (
	[DataSourceId] INT NOT NULL
	,[Name] VARCHAR(255) NOT NULL
	,[Description] NVARCHAR(255) NOT NULL
	,[Location] VARCHAR(1024) NOT NULL
	,[StageDatabaseName] VARCHAR(255) NOT NULL
	);
DECLARE @TableConfig AS TABLE (
	[DatabaseConfigId] INT NOT NULL
	,[DataSetId] INT
	,[Name] VARCHAR(255)
	,[Description] NVARCHAR(255)
	);
DECLARE @ColumnConfig AS TABLE (
	[TableId] INT NOT NULL
	,[DataSetPropertyId] INT
	,[ColumnName] VARCHAR(255) NOT NULL
	,[DataType] VARCHAR(100) NOT NULL
	,[IsPrimaryKey] BIT
	,[IsHashPart] BIT
	)
DECLARE @DatabaseName VARCHAR(255) = 'DWH2021';
DECLARE @DatabaseId INT;
DECLARE @DataSourceId INT;

SELECT @DataSourceId = Id
FROM dbo.DataSet
WHERE [Name] = 'Users';

INSERT INTO @DatabaseConfig (
	[DataSourceId]
	,[Name]
	,[Description]
	,[Location]
	,[StageDatabaseName]
	)
VALUES (
	@DataSourceId
	,'DWH2021'
	,'DWH2021 DEMO'
	,'/mnt/datalake/analytics_zone/DWHS/DWH2021/'
	,'Stage'
	);

SET XACT_ABORT ON;

BEGIN TRAN;

MERGE [proc].DatabaseConfig AS trg
USING (
	SELECT [DataSourceId]
		,[Name]
		,[Description]
		,[Location]
		,[StageDatabaseName]
	FROM @DatabaseConfig
	) AS src
	ON (trg.[Name] = src.[Name])
WHEN MATCHED
	THEN
		UPDATE
		SET [DataSourceId] = src.[DataSourceId]
			,[Description] = src.[Description]
			,[Location] = src.[Location]
			,[StageDatabaseName] = src.[StageDatabaseName]
WHEN NOT MATCHED
	THEN
		INSERT (
			[DataSourceId]
			,[Name]
			,[Description]
			,[Location]
			,[StageDatabaseName]
			)
		VALUES (
			src.[DataSourceId]
			,src.[Name]
			,src.[Description]
			,src.[Location]
			,src.[StageDatabaseName]
			);

SELECT @DatabaseId = Id
FROM [proc].DatabaseConfig
WHERE [Name] = @DatabaseName;

DECLARE @TableName VARCHAR(255) = 'User';
DECLARE @TableName2 VARCHAR(255) = 'dimUser';
DECLARE @DataSetId INT;

SELECT @DataSetId = Id
FROM dbo.DataSet
WHERE [Name] = 'Users'
	AND DataSourceId = @DataSourceId;

INSERT INTO @TableConfig (
	DatabaseConfigId
	,DataSetId
	,[Name]
	,[Description]
	)
VALUES (
	@DatabaseId
	,@DataSetId
	,@TableName
	,@TableName
	)
	,(
	@DatabaseId
	,@DataSetId
	,@TableName2
	,@TableName2
	);

MERGE [proc].TableConfig AS trg
USING (
	SELECT DatabaseConfigId
		,DataSetId
		,[Name]
		,[Description]
	FROM @TableConfig
	) AS src
	ON (
			trg.[Name] = src.[Name]
			AND trg.DatabaseConfigId = src.DatabaseConfigId
			)
WHEN MATCHED
	THEN
		UPDATE
		SET DataSetId = src.DataSetId
			,[Description] = src.[Description]
WHEN NOT MATCHED
	THEN
		INSERT (
			DatabaseConfigId
			,DataSetId
			,[Name]
			,[Description]
			)
		VALUES (
			src.DatabaseConfigId
			,src.DataSetId
			,src.[Name]
			,src.[Description]
			);

DECLARE @Table1Id INT;
DECLARE @Table2Id INT;

SELECT @Table1Id = Id
FROM [proc].TableConfig
WHERE DatabaseConfigId = @DatabaseId
	AND [Name] = @TableName;

SELECT @Table2Id = Id
FROM [proc].TableConfig
WHERE DatabaseConfigId = @DatabaseId
	AND [Name] = @TableName2;

INSERT INTO @ColumnConfig (
	[TableId]
	,[ColumnName]
	,[DataType]
	,[IsPrimaryKey]
	,[IsHashPart]
	)
VALUES (
	@Table1Id
	,'UserId'
	,'INT'
	,1
	,0
	)
	,(
	@Table1Id
	,'UserName'
	,'STRING'
	,0
	,1
	)
	,(
	@Table1Id
	,'UserRole'
	,'STRING'
	,0
	,1
	);

INSERT INTO @ColumnConfig (
	[TableId]
	,[ColumnName]
	,[DataType]
	,[IsPrimaryKey]
	,[IsHashPart]
	)
VALUES (
	@Table2Id
	,'UserId'
	,'INT'
	,1
	,0
	)
	,(
	@Table2Id
	,'UserName'
	,'STRING'
	,0
	,1
	)
	,(
	@Table2Id
	,'UserRole'
	,'STRING'
	,0
	,1
	);

UPDATE c
SET c.DataSetPropertyId = p.Id
FROM @ColumnConfig AS c
JOIN [proc].TableConfig AS t ON t.Id = c.TableId
JOIN dbo.DataSetProperty AS p ON p.DataSetId = t.DataSetId
	AND p.[Name] = c.ColumnName;

MERGE [proc].ColumnConfig AS trg
USING (
	SELECT [TableId]
		,[DataSetPropertyId]
		,[ColumnName]
		,[DataType]
		,[IsPrimaryKey]
		,[IsHashPart]
	FROM @ColumnConfig
	) AS src
	ON (
			trg.[ColumnName] = src.[ColumnName]
			AND trg.TableId = src.TableId
			)
WHEN MATCHED
	THEN
		UPDATE
		SET DataSetPropertyId = src.DataSetPropertyId
			,[DataType] = src.[DataType]
			,[IsPrimaryKey] = src.[IsPrimaryKey]
			,[IsHashPart] = src.[IsHashPart]
WHEN NOT MATCHED
	THEN
		INSERT (
			[TableId]
			,DataSetPropertyId
			,[ColumnName]
			,[DataType]
			,[IsPrimaryKey]
			,[IsHashPart]
			)
		VALUES (
			src.[TableId]
			,src.DataSetPropertyId
			,src.[ColumnName]
			,src.[DataType]
			,src.[IsPrimaryKey]
			,src.[IsHashPart]
			);

COMMIT TRAN
