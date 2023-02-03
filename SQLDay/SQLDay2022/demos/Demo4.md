

# SQL 2022 Demo 4

## Demo003_Ansi -Databricks

```sql
SET spark.sql.ansi.enabled = false;
SET spark.sql.storeAssignmentPolicy = LEGACY;
```

GET SETTINGS -REGISTER TEMP VIEW

```python
%python
df = spark.sql("SET -v")
df.createOrReplaceTempView("SparkSettings")
```

GET/DESCRIBE SETTING

```sql
SELECT * FROM SparkSettings WHERE key='spark.sql.storeAssignmentPolicy'
```

CAST 

```sql
SELECT 1/0, CAST(DATE'2022-05-11' AS INT),CAST('SQl Day 2022' AS INT)
```

CREATE SAMPLE TABLES

```sql
USE SQLDay2022;
DROP TABLE IF EXISTS AnsiDemo;
DROP TABLE IF EXISTS AnsiDemo2;
```

```sql
CREATE OR REPLACE TABLE AnsiDemo 
(
 IntVal BIGINT,
 BigIntVal BIGINT
)
USING DELTA
```

```sql
INSERT INTO AnsiDemo
VALUES(21474836479999, 2147483647999)
--MAX INT 2147483647
```

```sql
INSERT INTO AnsiDemo
VALUES(214748364711111, 214748364711111)
```

```sql
SELECT * FROM AnsiDemo
```

```sql
CREATE OR REPLACE TABLE AnsiDemo2
(
 IntVal INT,
 BigIntVal BIGINT
)
USING DELTA
```

```sql
INSERT INTO AnsiDemo2( IntVal,BigIntVal)
SELECT * FROM AnsiDemo
```

```sql
INSERT INTO AnsiDemo2
SELECT * FROM AnsiDemo
```

CHECK DATA IN AnsiDemo2

```sql
SELECT * FROM AnsiDemo2
```

SET ANSI COMPLIANCE SETTINGS

```sql
INSERT INTO AnsiDemo2
SELECT * FROM AnsiDemo
```

TRY TO LOAD DATA

```sql
INSERT INTO AnsiDemo2
SELECT * FROM AnsiDemo
```

CHECK SAMPLE QUERY

```sql
SELECT 1/0, CAST(DATE'2022-05-11' AS INT),CAST('SQl Day 2022' AS INT)
```

