CREATE DATABASE IF NOT EXISTS FPCLOUD;
USE FPCLOUD;
CREATE SCHEMA IF NOT EXISTS STAGE;
USE SCHEMA STAGE;


CREATE OR REPLACE STAGE  "FPCLOUD"."STAGE"."STREETCRIMESPARITIONEDSTAGE" 
  URL = 'azure://bdpbstorage.blob.core.windows.net/snowflake/db/streetcrimesparitioned/' 
     CREDENTIALS = 
     (AZURE_SAS_TOKEN = '{SAS}');
     
LIST @STREETCRIMESPARITIONEDSTAGE

---TRIPS AWS
CREATE STAGE IF NOT EXISTS "FPCLOUD"."STAGE"."CITIBIKETRIPSSTAGEAWS" URL = 's3://snowflake-workshop-lab/citibike-trips';
LIST @CITIBIKETRIPSSTAGEAWS