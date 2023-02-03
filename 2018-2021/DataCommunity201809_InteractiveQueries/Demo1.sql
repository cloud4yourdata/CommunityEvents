--Create Database
CREATE DATABASE IF NOT EXISTS DCDbHive
 LOCATION 'adl://adlsdemos.azuredatalakestore.net/dbs/DCDbHive'
 ---Show databeses
 SHOW DATABASES;
 -----------------------------------------------------------------------
 USE DCDbHive;
 --------
 DROP TABLE IF EXISTS DevicesDataExternal;
 DROP TABLE IF EXISTS devicedataparbydate;
 DROP TABLE IF EXISTS devicesdata;
 DROP TABLE IF EXISTS devicesdatapar;
 
 
 ---Create External table-----------------------------------------------
CREATE EXTERNAL TABLE IF NOT EXISTS DevicesDataExternal (
   DEVICEID INT,
   READINGDATETIME TIMESTAMP,
   VALUE DOUBLE
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES ("timestamp.formats"="yyyy-MM-dd HH:mm:ss")
STORED AS TEXTFILE
LOCATION 'adl://adlsdemos.azuredatalakestore.net/sampledata/sample/'
TBLPROPERTIES ("skip.header.line.count"="1");
--Show tables
SHOW TABLES;
---
SELECT COUNT(*) FROM DevicesDataExternal
--Sample Query
SELECT * FROM DevicesDataExternal WHERE DEVICEID =10 ORDER BY READINGDATETIME DESC LIMIT 100
--
SELECT DEVICEID, AVG(VALUE) AVGVAL
FROM DevicesDataExternal
WHERE 
READINGDATETIME >= '2018-08-01'
AND READINGDATETIME <= '2018-08-31'
GROUP BY DEVICEID
----------------------------------------------
----------------------------------------------
DROP TABLE IF EXISTS  DevicesData
---Create managed table
CREATE TABLE IF NOT EXISTS  DevicesData
(
   DEVICEID INT,
   READINGDATETIME TIMESTAMP,
   VALUE DOUBLE
)
STORED AS ORC
----------------------------
----------------------------
--Load data into DevicesData
INSERT INTO DevicesData
SELECT DEVICEID,READINGDATETIME,VALUE FROM DevicesDataExternal
--------------------------------
SELECT DEVICEID, AVG(VALUE) AVGVAL
FROM DevicesData
WHERE 
READINGDATETIME >= '2018-08-01'
AND READINGDATETIME <= '2018-08-31'
GROUP BY DEVICEID
-----------------------------
DROP TABLE IF EXISTS DevicesDataPar

--Create Partitioned Table
CREATE TABLE IF NOT EXISTS DevicesDataPar
(
    READINGDATETIME TIMESTAMP,
    VALUE DOUBLE
)
PARTITIONED BY ( 
  DEVICEID INT)
STORED AS ORC
TBLPROPERTIES ("ocr.compress"="SNAPPY")
---------------------------------------

--Load data into partitioned table dynamic partitioninig
INSERT INTO DevicesDataPar PARTITION(DEVICEID)
SELECT READINGDATETIME,VALUE,DEVICEID FROM DevicesData
---------------------------------------------------
---------------------------------------------------
SHOW PARTITIONS DevicesDataPar
---------------------------------------------------
SELECT DEVICEID, AVG(VALUE) AVGVAL
FROM DevicesDataPar
WHERE 
READINGDATETIME >= '2018-08-01'
AND READINGDATETIME <= '2018-08-31'
GROUP BY DEVICEID
---
SELECT COUNT(*) FROM DevicesDataPar

-------------------------------------
DROP TABLE IF EXISTS DeviceDataParByDate;

CREATE TABLE IF NOT EXISTS DeviceDataParByDate
(
  DEVICEID INT,
  READINGDATETIME TIMESTAMP,
  VALUE DOUBLE
)
PARTITIONED BY (YYYYMM STRING)
CLUSTERED BY (DEVICEID) INTO 10 BUCKETS
STORED AS ORC
TBLPROPERTIES ("ocr.compress"="SNAPPY")

---------
INSERT INTO DeviceDataParByDate PARTITION(YYYYMM)
SELECT DEVICEID,READINGDATETIME,VALUE, DATE_FORMAT(READINGDATETIME,'yyyyMM') YYYYMM FROM DevicesData 

----------
SELECT YYYYMM,DEVICEID,AVG(VALUE) FROM DeviceDataParByDate GROUP BY YYYYMM,DEVICEID
----
SELECT YYYYMM,AVG(VALUE) FROM DeviceDataParByDate WHERE DEVICEID=10 GROUP BY YYYYMM  
ORDER BY YYYYMM