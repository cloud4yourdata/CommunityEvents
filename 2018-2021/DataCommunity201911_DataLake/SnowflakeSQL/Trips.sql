--time traveling zerocopy clonning
USE FPCLOUD;
USE WAREHOUSE MYLAB_DW;
USE ROLE SYSADMIN;
USE SCHEMA STAGE;

--craete file format
CREATE OR REPLACE FILE FORMAT CSV 
TYPE = 'CSV' 
COMPRESSION = 'AUTO' 
FIELD_DELIMITER = ',' 
RECORD_DELIMITER = '\n' 
SKIP_HEADER = 0 
FIELD_OPTIONALLY_ENCLOSED_BY = '\042' 
TRIM_SPACE = FALSE 
ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE 
ESCAPE = 'NONE' 
ESCAPE_UNENCLOSED_FIELD = '\134' 
DATE_FORMAT = 'AUTO' 
TIMESTAMP_FORMAT = 'AUTO' 
NULL_IF = ('');


CREATE OR REPLACE TABLE Trips
(tripduration integer,
  starttime timestamp,
  stoptime timestamp,
  start_station_id integer,
  start_station_name string,
  start_station_latitude float,
  start_station_longitude float,
  end_station_id integer,
  end_station_name string,
  end_station_latitude float,
  end_station_longitude float,
  bikeid integer,
  membership_type string,
  usertype string,
  birth_year integer,
  gender integer);
  
  
TRUNCATE TABLE Trips;
----------------------------------------------
SELECT * FROM Trips LIMIT 100;
---------------------------------------------
COPY INTO Trips FROM @CitibikeTripsStageAWS FILE_FORMAT=CSV;
---
SELECT * FROM Trips LIMIT 100;
