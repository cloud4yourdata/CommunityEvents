DECLARE @log TABLE (
	[TableId] INT NOT NULL
	,[LoadDate] DATETIME2(7) NOT NULL
	,[DataContainer] VARCHAR(1024) NOT NULL
	,[DataPath] VARCHAR(1024) NOT NULL
	,[DataFormat] VARCHAR(255) NOT NULL
	,[DataFormatOptions] VARCHAR(255) NOT NULL
	,[EltProc] INT NOT NULL
	);
DECLARE @TableName1 VARCHAR(255) = 'User';
DECLARE @TableName2 VARCHAR(255) = 'dimUser';
DECLARE @DatabaseName VARCHAR(255) = 'DWH2021';
DECLARE @DatabaseId INT;
DECLARE @TableId INT;

SELECT @DatabaseId = Id
FROM [proc].DatabaseConfig
WHERE [Name] = @DatabaseName;

SELECT @TableId = Id
FROM [proc].[TableConfig]
WHERE DatabaseConfigId = @DatabaseId
	AND [Name] = @TableName1;

INSERT INTO @log (
	TableId
	,LoadDate
	,DataContainer
	,DataPath
	,DataFormat
	,DataFormatOptions
    ,EltProc
	)
VALUES (
	@TableId
	,SYSDATETIME()
	,''
	,'/mnt/datalake/rawdata/UserDB/users/yyyyMMdd=20201120/'
	,'PARQUET'
	,''
	,1
	)
	,(
	@TableId
	,SYSDATETIME()
	,''
	,'/mnt/datalake/rawdata/UserDB/users/yyyyMMdd=20201121/'
	,'PARQUET'
	,''
	,2
	);

SELECT @TableId = Id
FROM [proc].[TableConfig]
WHERE DatabaseConfigId = @DatabaseId
	AND [Name] = @TableName2;

INSERT INTO @log (
	TableId
	,LoadDate
	,DataContainer
	,DataPath
	,DataFormat
	,DataFormatOptions
	,EltProc
	)
VALUES (
	@TableId
	,SYSDATETIME()
	,''
	,'/mnt/datalake/rawdata/UserDB/users/yyyyMMdd=20201120/'
	,'PARQUET'
	,''
	,1
	)
	,(
	@TableId
	,SYSDATETIME()
	,''
	,'/mnt/datalake/rawdata/UserDB/users/yyyyMMdd=20201121/'
	,'PARQUET'
	,''
	,2
	);

TRUNCATE TABLE [load].DataLoadLog;

SET XACT_ABORT ON;

BEGIN TRAN;

INSERT INTO [load].DataLoadLog (
	TableId
	,LoadDate
	,DataContainer
	,DataPath
	,DataFormat
	,DataFormatOptions
	,EltProc
	)
SELECT TableId
	,LoadDate
	,DataContainer
	,DataPath
	,DataFormat
	,DataFormatOptions
	,EltProc
FROM @log

COMMIT TRAN;
