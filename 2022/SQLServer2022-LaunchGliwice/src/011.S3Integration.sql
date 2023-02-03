USE DCSQLServer2022MeetupGliwice;

---OPEN MASTER KEY 
OPEN MASTER KEY DECRYPTION BY PASSWORD = 'P@$$w0rd1234!';

IF NOT EXISTS
(
	SELECT *
	FROM sys.database_scoped_credentials
	WHERE
		name = N'MyS3Credential'
)
BEGIN
CREATE DATABASE SCOPED CREDENTIAL [MyS3Credential]
WITH IDENTITY = 'S3 Access Key',
SECRET = '********';
END

SELECT *
	FROM sys.database_scoped_credentials;

--CREATE DATA SOURCE
IF NOT EXISTS
(
	SELECT 1
	FROM sys.external_data_sources s
	WHERE
		s.name = N'MyS3Bucket'
)
BEGIN
	CREATE EXTERNAL DATA SOURCE [MyS3Bucket] WITH
	(
		LOCATION = 's3://s3.eu-west-1.amazonaws.com/mszpot-analityka',
		CREDENTIAL = MyS3Credential
	);
END

SELECT *
	FROM sys.external_data_sources
----

SELECT r.filename(),r.filepath(), *
FROM OPENROWSET(
BULK 'sqlserver2022/DataSets/Users/*',
DATA_SOURCE = 'MyS3Bucket',
FORMAT = 'PARQUET'
) AS r;


CREATE EXTERNAL TABLE S3ExternalTable
	WITH (
    LOCATION = 'sqlserver2022/DataSets/S3ExternalTable/V=1',
    DATA_SOURCE = MyS3Bucket,
    FILE_FORMAT = ParquetFileFormat
	)
AS 
SELECT * FROM [dbo].[FactInternetSales];


SELECT r.filename(),r.filepath(), *
FROM OPENROWSET(
BULK 'sqlserver2022/DataSets/S3ExternalTable/V=*/*',
DATA_SOURCE = 'MyS3Bucket',
FORMAT = 'PARQUET'
) AS r;