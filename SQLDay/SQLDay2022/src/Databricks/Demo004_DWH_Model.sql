-- Databricks notebook source
SHOW DATABASES

-- COMMAND ----------

USE dsadventureworks2019

-- COMMAND ----------

SHOW TABLES

-- COMMAND ----------

SELECT * FROM person_person LIMIT 100

-- COMMAND ----------

DESCRIBE FORMATTED person_person

-- COMMAND ----------

DROP DATABASE IF EXISTS DWHDLTDemo20220511 CASCADE

-- COMMAND ----------

CREATE DATABASE IF NOT EXISTS DWHDLTDemo2 LOCATION 'dbfs:/mnt/datalake/analytics_zone/DWHS/DWHDLTDemo20220511';

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Create Delta Live Tables - JOBS

-- COMMAND ----------

-- MAGIC %fs
-- MAGIC ls dbfs:/mnt/datalake/analytics_zone/DWHS/DWHDLTDemo20220511

-- COMMAND ----------

USE DWHDLTDemo20220511

-- COMMAND ----------

SHOW TABLES

-- COMMAND ----------

DESCRIBE FORMATTED factsalesorderdetail

-- COMMAND ----------

SELECT * FROM factsalesorderdetail

-- COMMAND ----------

DESCRIBE HISTORY factsalesorderdetail

-- COMMAND ----------

-- MAGIC %fs
-- MAGIC ls dbfs:/mnt/datalake/analytics_zone/DWHS/DWHDLTDemo20220511/tables/FactSalesOrderDetail

-- COMMAND ----------

SELECT * FROM delta.`dbfs:/mnt/datalake/analytics_zone/DWHS/DWHDLTDemo20220511/system/events`

-- COMMAND ----------

WITH event_log_raw AS
 (SELECT * FROM delta.`dbfs:/mnt/datalake/analytics_zone/DWHS/DWHDLTDemo20220511/system/events`)

SELECT
  timestamp,
  Double(details :cluster_utilization.num_executors) as current_num_executors,
  Double(details :cluster_utilization.avg_num_task_slots) as avg_num_task_slots,
  Double(
    details :cluster_utilization.avg_task_slot_utilization
  ) as avg_task_slot_utilization,
  Double(
    details :cluster_utilization.avg_num_queued_tasks
  ) as queue_size,
  Double(details :flow_progress.metrics.backlog_bytes) as backlog
FROM
  event_log_raw
WHERE
  event_type IN ('cluster_utilization', 'flow_progress')