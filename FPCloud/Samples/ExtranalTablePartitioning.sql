use mylabs
list @STREETCRIMES

select * from streetcrimes

use role sysadmin

CREATE OR REPLACE FILE FORMAT CSV
	SKIP_HEADER = 1
	FIELD_OPTIONALLY_ENCLOSED_BY = '\"'
;

CREATE OR REPLACE STREAM StreetCrimesSteam ON TABLE PUBLIC.STREETCRIMES
DROP TASK loadStreetCrimesDesc
CREATE OR REPLACE TASK loadStreetCrimesDesc
  WAREHOUSE = LABSMALL
  SCHEDULE = '1 MINUTE'
  WHEN
  SYSTEM$STREAM_HAS_DATA('StreetCrimesSteam')
AS
INSERT INTO PUBLIC.STREETCRIMESDESC
SELECT * FROM PUBLIC.STREETCRIMES

alter task loadStreetCrimesDesc suspend; 
alter task loadStreetCrimesDesc resume; 


select *
  from table(information_schema.task_history())
  order by scheduled_time;
  
  
 copy into StreetCrimes from @STREETCRIMES
file_format=CSV;

select count(*) from StreetCrimes
truncate table StreetCrimesDesc
select count(*) from StreetCrimesDesc

show tasks

show streams history


truncate  table PUBLIC.STREETCRIMESDESC

select CURRENT_TIMESTAMP

use role accountadmin;

grant execute task on account to role sysadmin WITH GRANT OPTION;
use role sysadmin


use role accountadmin;
select *
  from table(information_schema.task_history())
  order by scheduled_time;
  
  DESCRIBE TASK loadStreetCrimesDesc
  
  SHOW GRANTS TO ROLE sysadmin
  
SELECT METADATA$Action  FROM StreetCrimesSteam WHERE METADATA$ACTION = 'INSERT';

SHOW stages
https://bdpbstorage.blob.core.windows.net/snowflake/db/streetcrimesparitioned/


list @STREETCRIMESPARITIONEDSTAGE
--db/streetcrimesparitioned/YYYYMMDD=2015-02-01/part-00004-tid-2634496396507209609-614ae86a-05f0-4845-b174-4674258650c1-170-1.c000.csv
select metadata$filename,to_date(substr(metadata$filename, 36, 10), 'YYYY-MM-DD') from @STREETCRIMESPARITIONEDSTAGE/
-- date_part date as to_date(substr(metadata$filename, 35, 10), 'YYYY-MM-DD'),
select LENGTH('db/streetcrimesparitioned/YYYYMMDD=')

create or replace external table StreetCrimesExt
(
 date_part date as to_date(substr(metadata$filename, 36, 10), 'YYYY-MM-DD'))
  partition by (date_part)
 location = @STREETCRIMESPARITIONEDSTAGE
 REFRESH_ON_CREATE = true
 AUTO_REFRESH = false
 file_format = 
 (
   TYPE = csv
   SKIP_HEADER = 1
   FIELD_OPTIONALLY_ENCLOSED_BY = '\"'
 )
 pattern='.*part.*[.]csv';
 
 alter external table StreetCrimesExt refresh;
 select count(*) from StreetCrimesExt
 select to_date(VALUE:c2)
 from StreetCrimesExt where date_part=to_date('2017-07-01','YYYY-MM-DD');
 
 desc external table StreetCrimesExt