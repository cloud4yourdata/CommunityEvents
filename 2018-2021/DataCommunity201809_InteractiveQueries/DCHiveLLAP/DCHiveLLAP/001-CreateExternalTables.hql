USE DCDbHive;
 
CREATE EXTERNAL TABLE DevicesDataExternal (
   DEVICEID INT,
   READINGDATETIME TIMESTAMP,
   VALUE DOUBLE
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES ("timestamp.formats"="yyyy-MM-dd HH:mm:ss")
STORED AS TEXTFILE
LOCATION 'adl://adlsdemos.azuredatalakestore.net/sampledata/sample/'
TBLPROPERTIES ("skip.header.line.count"="1");
