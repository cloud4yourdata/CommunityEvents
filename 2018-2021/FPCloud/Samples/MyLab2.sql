use warehouse labsmall;
use database developersdemo;
use schema stage;

list @CitiCrimesBlobStorageStage;

copy into developersdemo.stage.StreetCrimes from @developersdemo.stage.CitiCrimesBlobStorageStage
file_format=developersdemo.stage.CSV;


create or replace external table StreetCrimesExt
 with location = @developersdemo.stage.CitiCrimesBlobStorageStage
 auto_refresh = false
 file_format = developersdemo.stage.CSV;

select value:c1 from StreetCrimesExt limit 10

truncate developersdemo.stage.StreetCrimes
select * from stage.StreetCrimes limit 10

merge into public.StreetCrimes as t
using 
(
 select CrimeID ,
 DateReported,
 MonthReported,
 YearReported,
 ShortReportedByPoliceForceName,
 ReportedByPoliceForceName,
 FallsWithinPoliceForceName,
 Longitude,
 Latitude,
 Location,
 DistrictCode,
 DistrictName,
 CrimeType,
 Outcome
  FROM stage.StreetCrimes
) as s
on s.CrimeID = t.CrimeID
 when matched then 
 update set
 t.DateReported = s.DateReported,
 t.MonthReported = s.MonthReported,
 t.YearReported = s.ShortReportedByPoliceForceName,
 t.ShortReportedByPoliceForceName = s.ShortReportedByPoliceForceName,
 t.ReportedByPoliceForceName = s.ReportedByPoliceForceName,
 t.FallsWithinPoliceForceName= s.FallsWithinPoliceForceName,
 t.Longitude = s.Longitude,
 t.Latitude = s.Latitude,
 t.Location = s.Location,
 t.DistrictCode = s.DistrictCode,
 t.DistrictName = s.DistrictName,
 t.CrimeType = s.CrimeType,
 t.Outcome = s.Outcome
 when not matched then
 insert (CrimeID ,
 DateReported,
 MonthReported,
 YearReported,
 ShortReportedByPoliceForceName,
 ReportedByPoliceForceName,
 FallsWithinPoliceForceName,
 Longitude,
 Latitude,
 Location,
 DistrictCode,
 DistrictName,
 CrimeType,
 Outcome)
 values
 (
 s.CrimeID ,
 s.DateReported,
 s.MonthReported,
 s.YearReported,
 s.ShortReportedByPoliceForceName,
 s.ReportedByPoliceForceName,
 s.FallsWithinPoliceForceName,
 s.Longitude,
 s.Latitude,
 s.Location,
 s.DistrictCode,
 s.DistrictName,
 s.CrimeType,
 s.Outcome
 )
 
 select  get_ddl('table','StreetCrimes')



