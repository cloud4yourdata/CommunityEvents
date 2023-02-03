SELECT  * FROM vwFactSalesOrderDetail 
-----------
DROP EXTERNAL TABLE FactSalesOrderDetail;
CREATE EXTERNAL TABLE FactSalesOrderDetail
WITH (
    LOCATION = '/analytics_zone/DWHS/DWHDLTDemo/tables/ExtFactSalesOrderDetail/Version=1',
    DATA_SOURCE = DataLake,  
    FILE_FORMAT = PARQUET_FORMAT
)  
AS
SELECT * FROM vwFactSalesOrderDetail ;

--REFRESH
DROP EXTERNAL TABLE FactSalesOrderDetail;
CREATE EXTERNAL TABLE FactSalesOrderDetail
WITH (
    LOCATION = '/analytics_zone/DWHS/DWHDLTDemo/tables/ExtFactSalesOrderDetail/Version=2',
    DATA_SOURCE = DataLake,  
    FILE_FORMAT = PARQUET_FORMAT
)  
AS
SELECT * FROM vwFactSalesOrderDetail;


--------SHOW RESULTS

SELECT * FROM FactSalesOrderDetail

--QPI Recommendation
SELECT * FROM qpi.recommendations
--QPI QUERY HISTORY
SELECT TOP 10 * FROM qpi.query_history WHERE query_text LIKE '%FactSalesOrderDetail%' 
ORDER BY start_time DESC

--COMPARE QUERIES
SELECT * FROM qpi.cmp_queries('{EF727ABD-3CDD-439F-B853-23C22E5AD5CD}',
'{4D63F5A6-C864-443F-A284-38642DAE6F4D}')
