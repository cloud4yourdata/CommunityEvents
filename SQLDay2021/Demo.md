#DEMO

##SQL -User Data Source

```mssql
IF OBJECT_ID('dbo.Users') IS NOT NULL
DROP TABLE dbo.Users;

CREATE TABLE dbo.Users 
(
 UserId INT NOT NULL,
 UserName VARCHAR(100) NOT NULL,
 UserRole VARCHAR(50) NOT NULL,
 CONSTRAINT PK_Users PRIMARY KEY CLUSTERED(UserId ASC) 
)
```



```mssql
INSERT INTO dbo.Users(UserId,UserName,UserRole)
VALUES (0,'Jorge','Junior Developer'),
(71,'Bob','Junior Developer'),
(11626092,'Alice','Senior Developer'),
(3764996,'Diana','Team Leader');
```



```mssql
CREATE TABLE dbo.Users2 
(
 UserId INT NOT NULL,
 UserName VARCHAR(100) NOT NULL,
 UserRole VARCHAR(50) NOT NULL,
 ModDate DATETIME2(7) NOT NULL,
 CONSTRAINT PK_Users2 PRIMARY KEY CLUSTERED(UserId ASC) 
)

INSERT INTO dbo.Users2(UserId,UserName,UserRole,ModDate)
VALUES (0,'Jorge','Senior Developer',SYSDATETIME()),
(71,'Bob','Junior Developer',SYSDATETIME()),
(11626092,'Alice','Senior Developer',SYSDATETIME()),
(3764996,'Diana','Team Leader',SYSDATETIME())  
```

### Loader Configuration

```mssql
DECLARE @configId INT;
DECLARE @sourceId INT = 1;
DECLARE @datePartitionTypeId INT = 1;
DECLARE @confName VARCHAR(50);
DECLARE @destFileName VARCHAR(100);
DECLARE @sqlQuery AS VARCHAR(MAX);
DECLARE @sqlMaxIdQuery VARCHAR(MAX);
SET @sqlMaxIdQuery = N'SELECT MAX(Id) AS Id FROM dbo.Users';

SET @confName = 'Users';
SET @destFileName = 'Users.snappy.parquet'
SET @datePartitionTypeId = 2;
SET @sqlQuery = N'SELECT UserId, UserName, UserRole FROM dbo.Users WHERE UserId > @StartId AND UserId <= @EndId';

SET @sqlMaxIdQuery = N'SELECT MAX(Id) AS Id FROM dbo.Users';

	INSERT INTO dbo.SqlConfigurations (
		[Name]
		,PartitionTypeId
		,SourceId
		,SqlIngestQuery
		,SqlMaxIdQuery
		)
	VALUES (
		@confName
		,@datePartitionTypeId
		,@sourceId
		,@sqlQuery
		,@sqlMaxIdQuery
		);
```

```mssql
UPDATE dbo.users2 SET UserRole = 'Senior Developer',ModDate=SYSDATETIME() WHERE UserId=71
```

```mssql
TRUNCATE TABLE [dbo].[DataLoadsHistory];

SELECT TOP (1000) [Id]
      ,[DataSourceId]
      ,[SinkTypeId]
      ,[PartitionTypeId]
      ,[Name]
      ,[Description]
      ,[SqlIngestQuery]
      ,[SqlMaxIdQuery]
      ,[SourceServer]
      ,[SourceDatabaseName]
      ,[SinkDir]
      ,[SinkFileNamePrefix]
      ,[SinkFileNameExt]
      ,[IsActive]
  FROM [dbo].[SqlLoaderConfig]

  SELECT TOP (1000) [Id]
      ,[TimeStamp]
      ,[SqlLoaderConfigId]
      ,[PartitionTypeId]
      ,[PartitionStartTime]
      ,[PartitionEndTime]
      ,[PartitionStartKeyId]
      ,[PartitionEndKeyId]
  FROM [dbo].[DataLoadsHistory]
```

```mssql
 EXEC [dbo].[usp_GetDataLoaderConfigDateRange] 1,1
```

