CREATE DATABASE [SQLDay2022Demo]
COLLATE Latin1_General_100_BIN2_UTF8;

USE [SQLDay2022Demo]




CREATE MASTER KEY ENCRYPTION BY PASSWORD ='*******';
CREATE DATABASE SCOPED CREDENTIAL DataLakeManagedIdentityCredential
WITH IDENTITY='Managed Identity';

CREATE EXTERNAL DATA SOURCE [DataLake] 
WITH 
 (LOCATION = N'abfss://datalake@datalake2demos.dfs.core.windows.net',
  CREDENTIAL = [DataLakeManagedIdentityCredential])

CREATE EXTERNAL FILE FORMAT PARQUET_FORMAT
WITH
(  
    FORMAT_TYPE = PARQUET,
    DATA_COMPRESSION = 'org.apache.hadoop.io.compress.SnappyCodec'
);

CREATE SCHEMA stage AUTHORIZATION dbo;