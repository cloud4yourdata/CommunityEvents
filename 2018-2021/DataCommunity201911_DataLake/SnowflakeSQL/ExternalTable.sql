USE FPCLOUD;
USE WAREHOUSE MYLAB_DW;
USE ROLE SYSADMIN;
USE SCHEMA STAGE;

SHOW STAGES


LIST @STREETCRIMESPARITIONEDSTAGE;

---Create external table
--azure://bdpbstorage.blob.core.windows.net/snowflake/db/streetcrimesparitioned/YYYYMMDD=2015-02-01/
CREATE OR REPLACE EXTERNAL TABLE StreetCrimesExt
(
 date_part DATE AS to_date(substr(metadata$filename, 36, 10), 'YYYY-MM-DD')) PARTITION BY (date_part)
 
 LOCATION = @STREETCRIMESPARITIONEDSTAGE
 REFRESH_ON_CREATE = true
 AUTO_REFRESH = false
 FILE_FORMAT = 
 (
   TYPE = CSV
   SKIP_HEADER = 1
   FIELD_OPTIONALLY_ENCLOSED_BY = '\"'
 )
 PATTERN='.*part.*[.]csv';
 
 ALTER EXTERNAL TABLE StreetCrimesExt REFRESH;
 
 SELECT COUNT(*) FROM StreetCrimesExt;
 ---SHOW SAMPLE DATA
SELECT * FROM StreetCrimesExt WHERE date_part=to_date('2017-07-01','YYYY-MM-DD') LIMIT 100;
---
CREATE OR REPLACE VIEW vwStreetCrimesExt
 AS
 SELECT
 VALUE:c1::string AS CrimeID,
 to_date(VALUE:c2) AS DateReported,
 VALUE:c6::double AS Longitude,
 VALUE:c7::double AS Latitude,
 VALUE:c8::string AS CrimeType,
 date_part
 FROM StreetCrimesExt;
 
 
 ---SHOW DATA and SHOW PLAN
 SELECT * FROM vwStreetCrimesExt WHERE date_part=to_date('2017-07-01','YYYY-MM-DD') LIMIT 10;
 
 --SHOW PLAN (WITH PARTITION AND WITHOUT PARTITION)
 SELECT * FROM vwStreetCrimesExt WHERE DateReported=to_date('2017-07-01','YYYY-MM-DD')
 --AND date_part=to_date('2017-07-01','YYYY-MM-DD')
 LIMIT 12;
 

 
 
 
 