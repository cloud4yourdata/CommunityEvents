DECLARE @ProcTemplateType AS TABLE (
	Id INT NOT NULL
	,[Name] VARCHAR(50) NOT NULL
	,[Description] NVARCHAR(255)
	);
DECLARE @ProcTemplate AS TABLE (
	 TypeId INT NOT NULL
	,[Name] NVARCHAR(50) NOT NULL
	,[Description] NVARCHAR(50) NULL
	,Template NVARCHAR(MAX) NOT NULL
	);


INSERT INTO @ProcTemplateType (
	Id
	,[Name]
	,[Description]
	)
VALUES (
	1
	,'DROP STAGE TABLE'
	,'DROP STAGE TABLE'
	)
	,(
	2
	,'CREATE STAGE TABLE'
	,'CREATE STAGE TABLE'
	)
	,(
	3
	,'MERGE SCD TYPE 2'
	,'MERGE SCD TYPE 2'
	);

SET XACT_ABORT ON;

BEGIN TRAN;

MERGE [proc].ProcTemplateType AS trg
USING (
	SELECT Id
		,[Name]
		,[Description]
	FROM @ProcTemplateType
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

DECLARE @procTemplateDef NVARCHAR(MAX) = N'DROP TABLE IF EXISTS %%stage_table%%';

INSERT INTO @ProcTemplate (
	[TypeId]
	,[Name]
	,[Description]
	,Template
	)
VALUES (
	1
	,'DROP STAGE TABLE'
	,'DROP STAGE TABLE'
	,@procTemplateDef
	);

SET @procTemplateDef = N'CREATE TABLE %%stage_table%% USING %%data_format%%  LOCATION ''%%data_location%%''';

INSERT INTO @ProcTemplate (
	[TypeId]
	,[Name]
	,[Description]
	,Template
	)
VALUES (
	2
	,'CREATE STAGE TABLE'
	,'CREATE STAGE TABLE'
	,@procTemplateDef
	)

SET @procTemplateDef = 
	N'
MERGE INTO %%target_table%% AS trg USING (
  WITH CurrentLoad AS (
    SELECT
      %%column_list_stg_prefix%%,
      true AS dwh_IsCurrent,
      CURRENT_TIMESTAMP() AS dwh_ValidFrom,
      CAST(''9999-12-31'' AS TIMESTAMP) AS dwh_ValidTo,
      uuid() AS dwh_SurKey,
      SHA2(CONCAT_WS(''||'',  %%column_list_hash_stg_prefix%%), 256) AS dwh_RowHash,
      SHA2(CONCAT_WS(''||'', %%column_list_pks_stg_prefix%%), 256) AS dwh_MergeKey
    FROM
      %%stage_table%% AS stg
  )
  SELECT
    *
  FROM
    CurrentLoad
  UNION ALL
  SELECT
    %%column_list_stg_prefix%%,
    stg.dwh_IsCurrent,
    stg.dwh_ValidFrom,
    stg.dwh_Validto,
    stg.dwh_SurKey,
    stg.dwh_RowHash,
    NULL AS dwh_MergeKey
  FROM
    CurrentLoad AS stg
    JOIN %%target_table%% AS dest ON dest.dwh_MergeKey = stg.dwh_MergeKey
  WHERE
    dest.dwh_IsCurrent = 1
    AND stg.dwh_RowHash <> dest.dwh_RowHash
) AS src ON trg.dwh_mergeKey = src.dwh_mergeKey
WHEN MATCHED
AND trg.dwh_IsCurrent = true
AND trg.dwh_RowHash <> src.dwh_RowHash THEN
UPDATE
SET
  dwh_IsCurrent = false,
  dwh_ValidTo = src.dwh_ValidFrom
  WHEN NOT MATCHED THEN
INSERT
  (
    %%column_list%%,
    dwh_IsCurrent,
    dwh_ValidFrom,
    dwh_ValidTo,
    dwh_SurKey,
    dwh_RowHash,
    dwh_MergeKey
  )
VALUES
  (
    %%column_list%%,
    src.dwh_IsCurrent,
    src.dwh_ValidFrom,
    src.dwh_Validto,
    src.dwh_SurKey,
    src.dwh_RowHash,
    SHA2(CONCAT_WS(''||'', %%column_list_pks_prefix%%), 256)
  )
'
	;

INSERT INTO @ProcTemplate (
	[TypeId]
	,[Name]
	,[Description]
	,Template
	)
VALUES (
	3
	,'MERGE SCD TYPE 2'
	,'MERGE SCD TYPE 2'
	,@procTemplateDef
	);

MERGE [proc].ProcTemplate AS trg
USING (
	SELECT [TypeId]
		,[Name]
		,[Description]
		,Template
	FROM @ProcTemplate
	) AS src
	ON (trg.[Name] = src.[Name])
WHEN MATCHED
	THEN
		UPDATE
		SET [TypeId] = src.[TypeId]
			,[Description] = src.[Description]
			,[Template] = src.[Template]
WHEN NOT MATCHED
	THEN
		INSERT (
			[TypeId]
			,[Name]
			,[Description]
			,Template
			)
		VALUES (
			src.[TypeId]
			,src.[Name]
			,src.[Description]
			,src.Template
			);

COMMIT TRAN;
