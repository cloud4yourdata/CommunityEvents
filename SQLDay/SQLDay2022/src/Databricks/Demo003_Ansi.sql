-- Databricks notebook source
SET spark.sql.ansi.enabled = false;
SET spark.sql.storeAssignmentPolicy = LEGACY;

-- COMMAND ----------

SELECT 1/0, CAST(DATE'2022-05-11' AS INT),CAST('SQl Day 2022' AS INT)

-- COMMAND ----------

USE SQLDay2022;

-- COMMAND ----------

DROP TABLE IF EXISTS AnsiDemo;

-- COMMAND ----------

DROP TABLE IF EXISTS AnsiDemo2;

-- COMMAND ----------

CREATE OR REPLACE TABLE AnsiDemo 
(
 IntVal BIGINT,
 BigIntVal BIGINT
)
USING DELTA

-- COMMAND ----------

INSERT INTO AnsiDemo
VALUES(21474836479999, 2147483647999)

-- COMMAND ----------

INSERT INTO AnsiDemo
VALUES(214748364711111, 214748364711111)

-- COMMAND ----------

SELECT * FROM AnsiDemo

-- COMMAND ----------

CREATE OR REPLACE TABLE AnsiDemo2
(
 IntVal INT,
 BigIntVal BIGINT
)
USING DELTA

-- COMMAND ----------

INSERT INTO AnsiDemo2( IntVal,BigIntVal)
SELECT * FROM AnsiDemo

-- COMMAND ----------

INSERT INTO AnsiDemo2
SELECT * FROM AnsiDemo

-- COMMAND ----------

SELECT * FROM AnsiDemo2

-- COMMAND ----------

SET spark.sql.ansi.enabled = true;
SET spark.sql.storeAssignmentPolicy = ANSI

-- COMMAND ----------

INSERT INTO AnsiDemo2
SELECT * FROM AnsiDemo

-- COMMAND ----------

SELECT 1/0, CAST(DATE'2022-05-11' AS INT),CAST('SQl Day 2022' AS INT)