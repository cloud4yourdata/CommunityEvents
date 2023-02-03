DECLARE @DataSetType AS TABLE (
	Id INT NOT NULL
	,[Name] VARCHAR(50) NOT NULL
	,[Description] NVARCHAR(255)
	);


INSERT INTO @DataSetType (
	Id
	,[Name]
	,[Description]
	)
VALUES (
	1
	,'TABLE'
	,'DATABASE TABLE'
	);

DECLARE @DataSourceType AS TABLE (
	Id INT NOT NULL
	,[Name] VARCHAR(50) NOT NULL
	,[Description] NVARCHAR(255)
	);


INSERT INTO @DataSourceType (
	Id
	,[Name]
	,[Description]
	)
VALUES (
	1
	,'MSSQL'
	,'MSSQL SERVER'
	);


SET XACT_ABORT ON;

BEGIN TRAN;

MERGE [dbo].DataSetType AS trg
USING (
	SELECT Id
		,[Name]
		,[Description]
	FROM @DataSourceType
	) AS src
	ON (trg.Id = src.Id)
WHEN MATCHED
	THEN
		UPDATE
		SET [Name] = src.[Name]
			,[Description] = src.[Description]
WHEN NOT MATCHED
	THEN
		INSERT (
			Id
			,[Name]
			,[Description]
			)
		VALUES (
			src.Id
			,src.[Name]
			,src.[Description]
			);

MERGE [dbo].DataSourceType AS trg
USING (
	SELECT Id
		,[Name]
		,[Description]
	FROM @DataSetType
	) AS src
	ON (trg.Id = src.Id)
WHEN MATCHED
	THEN
		UPDATE
		SET [Name] = src.[Name]
			,[Description] = src.[Description]
WHEN NOT MATCHED
	THEN
		INSERT (
			Id
			,[Name]
			,[Description]
			)
		VALUES (
			src.Id
			,src.[Name]
			,src.[Description]
			);

COMMIT TRAN;
