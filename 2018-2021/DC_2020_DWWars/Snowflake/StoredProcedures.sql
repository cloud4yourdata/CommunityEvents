USE FPCLOUD;
USE WAREHOUSE MYLAB_DW;
USE ROLE SYSADMIN;
USE SCHEMA STAGE;

DROP STAGE IF EXISTS AzureBSSnowflake

CREATE STAGE IF NOT EXISTS AzureBSSnowflake
  URL = 'azure://bdpbstorage.blob.core.windows.net/snowflake' 
     CREDENTIALS = 
     (AZURE_SAS_TOKEN = '{SAS}');

LIST @AzureBSSnowflake

CREATE OR REPLACE TABLE  VehiclesTripsADF
(
  vehicle_id integer,
  entry_id integer,
  event_date timestamp,
  latitude float,
  longitude float,
  speed integer,
  direction string,
  trip_id integer
);


CREATE OR REPLACE FILE FORMAT VehiclCSV
TYPE = 'CSV' 
 COMPRESSION = 'AUTO' 
 FIELD_DELIMITER = ',' 
 RECORD_DELIMITER = '\n' 
 SKIP_HEADER = 0 
 TRIM_SPACE = FALSE 
 ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE 
 ESCAPE = 'NONE' 
 DATE_FORMAT = 'AUTO' 
 TIMESTAMP_FORMAT = 'AUTO';
 

SELECT DISTINCT metadata$filename FROM '@AzureBSSnowflake/ADF'


CREATE OR REPLACE PROCEDURE TRUNCATE_STAGETABLES()
    RETURNS VARCHAR
    LANGUAGE JAVASCRIPT
    AS
    $$
    var sql_command = "TRUNCATE TABLE FPCLOUD.STAGE.VehiclesTripsADF";
    var stmt = snowflake.createStatement( {sqlText: sql_command} );
    var resultSet = stmt.execute();
    return 'Done';
    $$
    ;

CREATE OR REPLACE PROCEDURE LOADINTOSTAGETABLES()
    RETURNS VARCHAR
    LANGUAGE JAVASCRIPT
    AS
    $$
    var sql_command = "COPY INTO FPCLOUD.STAGE.VehiclesTripsADF FROM '@AzureBSSnowflake/ADF' FILE_FORMAT=VehiclCSV;";
    var stmt = snowflake.createStatement( {sqlText: sql_command} );
    var resultSet = stmt.execute();
    return 'Done';
    $$
    ;
    
CALL LOADINTOSTAGETABLES()
SELECT COUNT(*) FROM VehiclesTripsADF

TRUNCATE TABLE VehiclesTripsADF