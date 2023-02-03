# How to generate the sample data

1. Create Azure Databricks cluster (Cluster Mode High Concurrency)

   ![AzureDBHCCluster](img\AzureDBHCCluster.png)

2. Run Azure Databricks cluster

3. Setup Azure Data Lake Storage

4.  Create **dbs** and **sampledata** directories

5. Create new application (with public key)

6. Add permission for application to Azure Data Lake Storage

7. Mount ADLS storage
```python
configs = {"dfs.adls.oauth2.access.token.provider.type": "ClientCredential",
           "dfs.adls.oauth2.client.id": "<applicationId>",
           "dfs.adls.oauth2.credential": "<secret key",
           "dfs.adls.oauth2.refresh.url": "https://login.microsoftonline.com/<your-directory-id>/oauth2/token"}
dbutils.fs.mount(
  source = "adl://<adls>.azuredatalakestore.net/dbs",
  mount_point = "/mnt/dbs",
  extra_configs = configs)
dbutils.fs.mount(
  source = "adl://<adls>.azuredatalakestore.net/sampledata",
  mount_point = "/mnt/data",
  extra_configs = configs)
           
```


8. Run pyspark script

   ```python
   import datetime
   now = datetime.datetime.now()
   from datetime import datetime
   from pyspark.sql.functions import to_date,dayofyear
   from datetime import timedelta
   from pyspark.sql.functions import lit
   beginDate = datetime.strptime('2017/01/01 00:00', '%Y/%m/%d %H:%M')
   devices = 100
   samples = 288*(365+256)
   import numpy as np
   def f(x):
       return np.random.randint(1000)
   seedRdd = sc.parallelize([(x) for x in range(devices)] , devices)
   df = seedRdd.flatMap(lambda i: [[i, (beginDate + timedelta(0, 300 * x)), f(x)] for x in range(samples)]) \
     .toDF(['DEVICEID', 'READINGDATETIME', 'VALUE'])
   path="/mnt/data/sample"
   df.write.format('com.databricks.spark.csv').mode("overwrite").save(path, header = 'true',timestampFormat ='yyyy-MM-dd HH:mm:ss')
   ```



# Hive Demo (HDInsight Interactive Query Cluster)

#### Show the sample data on ADLA

#### Show the ODBC Configuration

#### Create database 

```sql
CREATE DATABASE IF NOT EXISTS DCDbHive
 LOCATION 'adl://adlsdemos.azuredatalakestore.net/dbs/DCDbHive'
```

#### Show databases

```sql
SHOW DATABASES
```

#### Create external tables

```sql
USE DCDbHive;
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
```

#### Show tables

```sql
SHOW TABLES
```

#### Sample Query -Count

```sql
SELECT COUNT(*) FROM DevicesDataExternal
```

#### Sample Query - DevicesData

```sql
SELECT * FROM DevicesDataExternal WHERE DEVICEID =10 ORDER BY READINGDATETIME DESC LIMIT 100
```

#### Sample Query - Aggregations

```sql
SELECT DEVICEID, AVG(VALUE) AVGVAL
FROM DevicesDataExternal
WHERE 
READINGDATETIME >= '2018-08-01'
AND READINGDATETIME <= '2018-08-31'
GROUP BY DEVICEID
```

#### Create Managed Table (ORC)

```sql
DROP TABLE IF EXISTS  DevicesData;
--Create managed table
CREATE TABLE IF NOT EXISTS  DevicesData
(
   DEVICEID INT,
   READINGDATETIME TIMESTAMP,
   VALUE DOUBLE
)
STORED AS ORC
```

#### Create managed table

```sql
INSERT INTO DevicesData
SELECT DEVICEID,READINGDATETIME,VALUE FROM DevicesDataExternal
```
#### Show created table (ADLS)

#### Sample Query - Aggregations

```sql
SELECT DEVICEID, AVG(VALUE) AVGVAL
FROM DevicesData
WHERE 
READINGDATETIME >= '2018-08-01'
AND READINGDATETIME <= '2018-08-31'
GROUP BY DEVICEID
```
#### Create Partitioned Table (ORC and Snappy)
```sql
DROP TABLE IF EXISTS DevicesDataPar;
CREATE TABLE IF NOT EXISTS DevicesDataPar
(
    READINGDATETIME TIMESTAMP,
    VALUE DOUBLE
)
PARTITIONED BY ( 
  DEVICEID INT)
STORED AS ORC
TBLPROPERTIES ("ocr.compress"="SNAPPY")
```

#### Load data into partitioned table
```sql
INSERT INTO DevicesDataPar PARTITION(DEVICEID)
SELECT READINGDATETIME,VALUE,DEVICEID FROM DevicesData
```
### Show partitions
```sql
SHOW PARTITIONS DevicesDataPar
```
### Sample Query - Aggregations
```sql
SELECT DEVICEID, AVG(VALUE) AVGVAL
FROM DevicesDataPar
WHERE 
READINGDATETIME >= '2018-08-01'
AND READINGDATETIME <= '2018-08-31'
GROUP BY DEVICEID
```
#### Create Partitioned Table (ORC and Snappy) with bucketing 
```sql
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
```
#### Load data 
```sql
INSERT INTO DeviceDataParByDate PARTITION(YYYYMM)
SELECT DEVICEID,READINGDATETIME,VALUE, DATE_FORMAT(READINGDATETIME,'yyyyMM') YYYYMM FROM DevicesData
```
#### Sample Query
```sql
SELECT YYYYMM,AVG(VALUE) FROM DeviceDataParByDate WHERE DEVICEID=10 GROUP BY YYYYMM  
ORDER BY YYYYMM
```

# SPARK Demo

#### Show databases

```sql
SHOW DATABASES
```

#### Create new database

```sql
CREATE DATABASE IF NOT EXISTS DCDbSpark
COMMENT 'Data Community Demo'
LOCATION '/mnt/dbs/DCDbSpark'
```

#### Show information about created database

```sql
DESCRIBE DATABASE DCDbSpark;
```

#### Change database

```sql
USE DCDbSpark
```

#### Create external table 

```sql
DROP TABLE IF EXISTS DevicesDataExternal;
CREATE TABLE IF NOT EXISTS DevicesDataExternal (
  DEVICEID INT,
  READINGDATETIME TIMESTAMP,
  VALUE DOUBLE)
 USING com.databricks.spark.csv
OPTIONS (header 'true')
LOCATION '/mnt/data/sample/'
```

#### Run sample query

```sql
SELECT * FROM DevicesDataExternal WHERE DEVICEID =10 ORDER BY READINGDATETIME DESC LIMIT 100
```

#### Create managed table (format PARQUET, compression SNAPPY)

```sql
DROP TABLE IF  EXISTS DevicesData;
CREATE TABLE IF NOT EXISTS DevicesData 
(
  DEVICEID INT,
  READINGDATETIME TIMESTAMP,
  VALUE DOUBLE
)
USING PARQUET
OPTIONS ('compression'='SNAPPY')
PARTITIONED BY (DEVICEID)
```

#### Load data into managed table (dynamic partition)

```sql
INSERT INTO DevicesData PARTITION (DEVICEID)
SELECT READINGDATETIME,VALUE,DEVICEID FROM DevicesDataExternal
```

#### Show partitions

```sql
SHOW PARTITIONS DevicesData
```

#### Show execution plan for  sample query (check partition count)

```sql
EXPLAIN SELECT * FROM DevicesData WHERE DEVICEID IN (5,7)
```

#### Run sample query

```sql
SELECT DEVICEID,DATE_FORMAT(READINGDATETIME,'yyyyMM'), AVG(VALUE) AVGVALUE, MIN(VALUE) MINVALUE, MAX(VALUE),STDDEV(VALUE) 
FROM DevicesData 
GROUP BY DEVICEID,DATE_FORMAT(READINGDATETIME,'yyyyMM')  
ORDER BY DEVICEID,DATE_FORMAT(READINGDATETIME,'yyyyMM')
```

#### Create Hive table (use HQL Language)

```sql
DROP TABLE IF EXISTS DevicesDataParHive;
CREATE TABLE IF NOT EXISTS DevicesDataParHive
(
    READINGDATETIME TIMESTAMP,
    VALUE DOUBLE
)
PARTITIONED BY (deviceid INT)
LOCATION '/mnt/dbs/DCDbHive/devicesdatapar/'
STORED AS ORC
TBLPROPERTIES ("ocr.compress"="SNAPPY")
```

#### Run sample query 

```sql
SELECT DEVICEID,DATE_FORMAT(READINGDATETIME,'yyyyMM'), AVG(VALUE) AVGVALUE, MIN(VALUE) MINVALUE, MAX(VALUE),STDDEV(VALUE) 
FROM DevicesDataParHive 
GROUP BY DEVICEID,DATE_FORMAT(READINGDATETIME,'yyyyMM')  
ORDER BY DEVICEID,DATE_FORMAT(READINGDATETIME,'yyyyMM')
```

