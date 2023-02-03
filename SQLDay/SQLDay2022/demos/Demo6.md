

# SQL 2022 Demo 6

## Demo005_Maintenance -Databricks

DWHDLTDemo3 DB built based on DLT Demo

```sql
 USE DWHDLTDemo3
```

```sql
DESCRIBE HISTORY factsalesorderdetail
```

```sql
DESCRIBE FORMATTED factsalesorderdetail
```

#### Change Type ProductID INT ->ProductID BIGINT

```sql
SHOW CREATE TABLE DWHDLTDemo3.FactSalesOrderDetail
```

Replace table

```sql
CREATE OR REPLACE TABLE DWHDLTDemo3.FactSalesOrderDetail
USING DELTA
AS 
SELECT
 `SalesOrderDetailID`,
  `SalesOrderID`,
  CAST(`ProductID` AS BIGINT) AS `ProductID`,
  `CustomerID`,
  `SalesPersonID`,
  `ShipMethodID`,
  `TerritoryID`,
  `SpecialOfferID`,
  `SalesOrderStatus`,
  `SalesOnlineOrderFlag`,
  `SalesOrderAccountNumber`,
  `BillToAddressID`,
  `ShipToAddressID`,
  `SalesOrderDetailModifiedDateKey`,
  `SalesOrderDateKey`,
  `SalesOrderDueDateKey`,
  `SalesOrderShipDateKey`,
  `SalesOrderModifiedDateKey` ,
  `OrderQty`,
  `UnitPrice` ,
  `UnitPriceDiscount`,
  `LineTotal` ,
  `SalesOrderSubTotal`,
  `SalesOrderTaxAmount` ,
  `SalesOrderFreightAmount`,
  `SalesOrderTotalDueAmount` ,
  `IsDeleted`
FROM
DWHDLTDemo3.FactSalesOrderDetail
```

Describe history

```sql
DESCRIBE HISTORY DWHDLTDemo3.FactSalesOrderDetail
```

Update sample row

```sql
UPDATE DWHDLTDemo3.FactSalesOrderDetail SET ProductID = 12
```

Show files

```bash
%fs
ls dbfs:/mnt/datalake/analytics_zone/DWHS/DWHDLTDemo3/tables/FactSalesOrderDetail
```

```sql
SELECT DISTINCT input_file_name() FROM DWHDLTDemo3.FactSalesOrderDetail
```

Show hisotry

```sql
SELECT DISTINCT input_file_name() FROM DWHDLTDemo3.FactSalesOrderDetail
```

Compare changed rows

```sql
SELECT * FROM DWHDLTDemo3.FactSalesOrderDetail WHERE SalesOrderDetailID=10
UNION ALL
SELECT * FROM DWHDLTDemo3.FactSalesOrderDetail VERSION AS OF 6 WHERE SalesOrderDetailID=10 
```

Restore table to specific version

```sql
RESTORE TABLE DWHDLTDemo3.FactSalesOrderDetail VERSION AS OF 6
```

Set Spark Settings

```sql
SET spark.databricks.delta.retentionDurationCheck.enabled = false
```

Run Vacuum Dry

```sql
VACUUM DWHDLTDemo3.FactSalesOrderDetail RETAIN 0 HOURS  DRY RUN 
```

```sql
VACUUM DWHDLTDemo3.FactSalesOrderDetail RETAIN 0 HOURS
```

Describe history

```sql
DESCRIBE HISTORY DWHDLTDemo3.FactSalesOrderDetail
```

Try to restore to specific version

```sql
RESTORE TABLE DWHDLTDemo3.FactSalesOrderDetail VERSION AS OF 2
```

