DECLARE @Config TABLE (
	[Key] VARCHAR(255) NOT NULL
	,[Value] VARCHAR(1024) NOT NULL
	);

INSERT INTO @Config (
	[Key]
	,[Value]
	)
VALUES (
	'%%dwh_spark_path%%'
	,'analytics_zone/DWHS/DWH2021/'
	)
	,(
	'%%serve_data_source%%'
	,'DataLake'
	)
	,(
	'%%serve_schema_name%%'
	,'dbo'
	);

MERGE [serve].Config AS trg
USING (
	SELECT [Key]
		,[Value]
	FROM @Config
	) AS src
	ON (trg.[Key] = src.[Key])
WHEN MATCHED
	THEN
		UPDATE
		SET [Value] = src.[Value]
WHEN NOT MATCHED
	THEN
		INSERT (
			[Key]
			,[Value]
			)
		VALUES (
			src.[Key]
			,src.[Value]
			);
