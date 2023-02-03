use warehouse labsmall;
use database developersdemo;
use schema stage;

list @CitiCrimesBlobStorageStage;

truncate StreetCrimes;

select count(*) from StreetCrimes;

copy into StreetCrimes from @CitiCrimesBlobStorageStage
file_format=developersdemo.stage.CSV;

select * from StreetCrimes limit 10

drop table StreetCrimes;

select * from StreetCrimes limit 10

undrop table StreetCrimes

select * from StreetCrimes limit 10


----ODBC
use database developersdemo;
use schema stage;
SELECT count(*) FROM StreetCrimes
select * from StreetCrimes limit 10

SELECT * FROM STREETCRIMES WHERE CrimeId='86576cf5c8c2a06d198b09fc14c6f1b38c5c7878db0805309e232b26be1cf0e7'

SELECT * FROM STREETCRIMES WHERE CrimeId='727fd9b547aa0facc0576d6f341f8729c83a0fd6d6e72b40a3b783611c32b4b0'