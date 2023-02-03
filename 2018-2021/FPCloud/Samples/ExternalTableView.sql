use MYLABS;
/*CrimeID ,
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
 Outcome*/
 CREATE OR REPLACE VIEW vwStreetCrimesExt
 AS
 select VALUE:c1::string AS CrimeID, to_date(VALUE:c2) AS DateReported,
 VALUE:c6::double AS Longitude,
 VALUE:c7::double AS Latitude,
 VALUE:c8::string AS CrimeType,
 date_part
 from StreetCrimesExt 
 
 use warehouse LABSMALL
 select count(*) from vwStreetCrimesExt
 where date_part>=to_date('2017-07-01','YYYY-MM-DD')
 AND date_part<=to_date('2017-10-01','YYYY-MM-DD')
 LIMIT 100;
 
  select * from StreetCrimesExt 
 where date_part=to_date('2017-07-01','YYYY-MM-DD')
 LIMIT 10;
 
 select count(*) from vwStreetCrimesExt