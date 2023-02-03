# SQL Day 2022 - Azure Data Lakehouse

## Why Lakehouse Approach  



Delta Lake is an open-source storage layer that brings improved reliability to the **lakehouse** .

A **lakehouse** is a new DM paradigm that enables users to do everything from **BI, SQL analytics, data science, and ML** on a single platform.  

The data **warehouse** approach isn’t future-proof because it’s missing support for predictions, real-time (streaming) data, flexible scalability, and managing raw data in any format .



### Enables a single combined cloud data platform: 

With a lakehouse, all data is kept within its lake format; it’s a common storage medium across the whole architecture  

### Unifies data warehousing and machine learning (ML)  

One platform for data warehousing and ML supports all types and frequency of data  

### Increases data team efficiency  

Lakehouses are enabled by a new system design that implements similar data structures and data management features to those in a data warehouse, directly on the kind of low-cost storage used for data lakes.
Merging them into a single system means that ML teams can move faster because they’re able to use data without needing
to access multiple systems  

### Reduces cost  

With the lakehouse approach, you have one system for data warehousing and ML. Multiple systems for different analytics use cases are eliminated. You can store data in cheap object storage such as Amazon S3, Azure Blob Storage, and so on.

### Simplifies data governance    

A lakehouse can eliminate the operational overhead of managing data governance on multiple tools.  

### Simplifies ETL jobs  

With the data warehousing technique, the data has to be loaded into the data warehouse to query or to perform analysis. But by using the lakehouse approach, the ETL process is eliminated by connecting the query engine directly to your data lake  

### Removes data redundancy  

The lakehouse approach removes data redundancy by using a single tool to process your raw data. Data redundancy happens when you have data on multiple tools and platforms such as cleaned data on data warehouse for processing, some meta-data on
business intelligence (BI) tools, and temporary data on ETL tools.  

### Enables direct data access  

Data teams can use a query engine to query the data directly from raw data, giving them the power to build their transformation logics and cleaning techniques after understanding basic statistical insights and quality of the raw data.

### Connects directly to BI tools    

Lakehouses enables tools, such as Apache Drill and supports the direct connection to popular BI tools like Tableau, PowerBI, and so on.  

### Handles security

Data related security challenges are easier to handle with a simplified data flow and single source of truth approach. 



## Spark Versions

https://docs.microsoft.com/en-us/azure/databricks/release-notes/runtime/releases

https://databricks.com/blog/2021/03/02/introducing-apache-spark-3-1.html

https://databricks.com/blog/2021/10/19/introducing-apache-spark-3-2.html

## SQL Endpoints

https://docs.microsoft.com/en-us/azure/databricks/sql/user/security/access-control/sql-endpoint-acl

## Data Lake and Slowly changing dimensions

### Delta

### Slowly changing dimensions - Merge

```sql
MERGE INTO target_table_identifier [AS target_alias]
USING source_table_identifier [<time_travel_version>] [AS source_alias]
ON <merge_condition>
[ WHEN MATCHED [ AND <condition> ] THEN <matched_action> ]
[ WHEN MATCHED [ AND <condition> ] THEN <matched_action> ]
[ WHEN NOT MATCHED [ AND <condition> ]  THEN <not_matched_action> ]
```

 (https://docs.databricks.com/delta/delta-update.html#merge-examples)

#### Surrogate Keys

"A surrogate key (or synthetic key, entity identifier, system-generated key, database sequence number, factless key, technical key, or arbitrary unique identifier[citation needed]) in a database is a unique identifier for either an entity in the modeled world or an object in the database. The surrogate key is not derived from application data, unlike a natural (or business) key which is derived from application data.[1]" https://en.wikipedia.org/wiki/Surrogate_key

[Ralph Kimbal](https://www.kimballgroup.com/1998/05/surrogate-keys/): "Actually, a surrogate key in a data warehouse is more than just a substitute for a natural key. In a data warehouse, a surrogate key is a necessary generalization of the natural production key and is one of the basic elements of data warehouse design. Let’s be very clear: Every join between dimension tables and fact tables in a data warehouse environment should be based on surrogate keys, not natural keys. It is up to the data extract logic to systematically look up and replace every incoming natural key with a data warehouse surrogate key each time either a dimension record or a fact record is brought into the data warehouse environment."

"A surrogate key is frequently a sequential number (e.g. a Sybase or SQL Server "identity column", a PostgreSQL or Informix serial, an Oracle or SQL Server SEQUENCE or a column defined with AUTO_INCREMENT in MySQL). Some databases provide UUID/GUID as a possible data type for surrogate keys (e.g. PostgreSQL UUID or SQL Server UNIQUEIDENTIFIER)."

1. Strategies

- monotonically_increasing_id
- row_number() Rank OVER
- ZipWithIndex()
- ZipWithUniqueIndex()
- **Row Hash with hash()**
- Row Hash with md5()

### Serving Layer

#### Spark SQL

##### Security

**Table access control**

Requirements
Access control requires the Premium plan (or, for customers who subscribed to Databricks before March 3, 2020, the Operational Security package).

https://docs.databricks.com/security/access-control/table-acls/object-privileges.html

**Row Level Security**

***current_user()***: return the current user name.
*i**s_member()***: determine if the current user is a member of a specific Databricks group.

```sql
SELECT
  current_user as user,
-- Check to see if the current user is a member of the "Managers" group.
  is_member("Managers") as admin
```



Column-level and Data masking- Views

```sql
CREATE VIEW sales_redacted AS
SELECT
  user_id,
  region,
  CASE
    WHEN is_member('auditors') THEN email
    ELSE regexp_extract(email, '^.*@(.*)$', 1)
  END
  FROM sales_raw
```