use warehouse labsmall;
use database developersdemo;
use schema stage;

list @CitiCrimesBlobStorageStage;

truncate StreetCrimes;

select count(*) from StreetCrimes;--513002

copy into developersdemo.stage.StreetCrimes from @developersdemo.stage.CitiCrimesBlobStorageStage
file_format=developersdemo.stage.CSV;

select get_ddl('file_format','developersdemo.stage.CSV')

select * from StreetCrimes limit 10

drop table StreetCrimes;

select * from StreetCrimes limit 10

undrop table StreetCrimes

select * from StreetCrimes limit 10
