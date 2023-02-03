# Synapse Spark meta store integration

## PARQUET 

Azure Synapse Spark

```sql
DROP DATABASE IF EXISTS SQLDay2021 CASCADE;
CREATE DATABASE IF NOT EXISTS SQLDay2021;
CREATE TABLE SQLDay2021.DataTable (Val INTEGER) USING PARQUET;
INSERT INTO SQLDay2021.DataTable VALUES(1),(2);
SELECT * FROM SQLDay2021.DataTable;
```

Azure Synapse Serverless (SQLDay2021/Demo000_Spark)

```sql
SELECT * FROM SQLDay2021.DataTable
```

## DELTA 

Create table

```python
data = spark.range(0, 5)
data.write.format("delta").save("/tmp/delta-table")
df.write.format("delta").saveAsTable("DeltaTable")
```

Merge/Update

```python
from delta.tables import *
from pyspark.sql.functions import *

deltaTable = DeltaTable.forPath(spark, "/tmp/delta-table")

# Update every even value by adding 100 to it
deltaTable.update(
  condition = expr("id % 2 == 0"),
  set = { "id": expr("id + 100") })

# Delete every even value
deltaTable.delete(condition = expr("id % 2 == 0"))

# Upsert (merge) new data
newData = spark.range(0, 20)

deltaTable.alias("oldData") \
  .merge(
    newData.alias("newData"),
    "oldData.id = newData.id") \
  .whenMatchedUpdate(set = { "id": col("newData.id") }) \
  .whenNotMatchedInsert(values = { "id": col("newData.id") }) \
  .execute()

deltaTable.toDF().show()
```

https://docs.delta.io/0.8.0/quick-start.html