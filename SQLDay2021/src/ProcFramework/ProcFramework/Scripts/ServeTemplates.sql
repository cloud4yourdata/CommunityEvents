DECLARE @ServeTemplateType AS TABLE (
	Id INT NOT NULL
	,[Name] VARCHAR(50) NOT NULL
	,[Description] NVARCHAR(255)
	);
DECLARE @ServeTemplate AS TABLE (
	 TypeId INT NOT NULL
	,[Name] NVARCHAR(50) NOT NULL
	,[Description] NVARCHAR(50) NULL
	,Template NVARCHAR(MAX) NOT NULL
	);


INSERT INTO @ServeTemplateType (
	Id
	,[Name]
	,[Description]
	)
VALUES (
	1
	,'VIEW DELTA MANIFEST SYNAPSE SERVERLESS'
	,'VIEW DELTA MANIFEST SYNAPSE SERVERLESS'
	),
	(
	2
	,'VIEW DELTA MANIFEST PATH'
	,'VIEW DELTA MANIFEST PATH'
	)
	;

SET XACT_ABORT ON;

BEGIN TRAN;

MERGE [serve].ServeTemplateType AS trg
USING (
	SELECT Id
		,[Name]
		,[Description]
	FROM @ServeTemplateType
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

DECLARE @viewTemplateDef NVARCHAR(MAX) = N'CREATE OR ALTER VIEW %%view_name%% AS
									SELECT CAST(r.filepath(1) AS BIT)  AS dwh_IsCurrent, * FROM 
										OPENROWSET( 
											BULK ''%%data_path%%/%%table_name_lower%%/dwh_IsCurrent=*/*.snappy.parquet'',
											DATA_SOURCE = ''%%serve_data_source%%'',
											FORMAT=''PARQUET''
										)
									 WITH 
									  (
									    %%_serve_column_list_with_types%%,
									  	[dwh_ValidFrom] datetime2(7),
										[dwh_ValidTo] datetime2(7)
									  ) 
										AS r
									 WHERE r.filename() IN 
										(%%manifest_file_list%% )';

INSERT INTO @ServeTemplate (
	[TypeId]
	,[Name]
	,[Description]
	,Template
	)
VALUES (
	1
	,'VIEW DELTA MANIFEST SYNAPSE SERVERLESS'
	,'VIEW DELTA MANIFEST SYNAPSE SERVERLESS'
	,@procTemplateDef
	);

DECLARE @manifestTemplateDef NVARCHAR(MAX) = N'%%serve_data_path%%/%%table_name_lower%%/_symlink_format_manifest/*/manifest';

INSERT INTO @ServeTemplate (
	[TypeId]
	,[Name]
	,[Description]
	,Template
	)
VALUES (
	2
	,'VIEW DELTA MANIFEST PATH (PART LEVEL 1)'
	,'VIEW DELTA MANIFEST PATH (PART LEVEL 2)'
	,@procTemplateDef
	);

MERGE [serve].ServeTemplate AS trg
USING (
	SELECT [TypeId]
		,[Name]
		,[Description]
		,Template
	FROM @ServeTemplate
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
