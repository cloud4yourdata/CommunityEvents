# SQL 2022 Demo 1

## Demo 1

### Azure Synapse Serverless -CETAS

#### Init -Create DB and Data Source (Done -Skip on Demo)

```sql
CREATE DATABASE [SQLDay2022Demo]
COLLATE Latin1_General_100_BIN2_UTF8;

USE [SQLDay2022Demo];

CREATE MASTER KEY ENCRYPTION BY PASSWORD ='*******';
CREATE DATABASE SCOPED CREDENTIAL DataLakeManagedIdentityCredential
WITH IDENTITY='Managed Identity';

CREATE EXTERNAL DATA SOURCE [DataLake] 
WITH 
 (LOCATION = N'abfss://datalake@datalake2demos.dfs.core.windows.net',
  CREDENTIAL = [DataLakeManagedIdentityCredential])

CREATE EXTERNAL FILE FORMAT PARQUET_FORMAT
WITH
(  
    FORMAT_TYPE = PARQUET,
    DATA_COMPRESSION = 'org.apache.hadoop.io.compress.SnappyCodec'
);

CREATE SCHEMA stage AUTHORIZATION dbo;
```

#### Create views - DLH Adventure Works (Done Skip on demo)

```sql
USE SQLDay2022Demo;

CREATE OR ALTER VIEW DimProductModel
AS
SELECT *
FROM
    OPENROWSET(
        BULK 'https://datalake2demos.dfs.core.windows.net/datalake/analytics_zone/DWHS/DWHDLTDemo/tables/DimProductModel/',
        FORMAT = 'DELTA'
    ) AS [result];
    ;

CREATE OR ALTER VIEW DimSalesPerson
AS
SELECT *
FROM
    OPENROWSET(
        BULK 'https://datalake2demos.dfs.core.windows.net/datalake/analytics_zone/DWHS/DWHDLTDemo/tables/DimSalesPerson/',
        FORMAT = 'DELTA'
    ) AS [result]

CREATE OR ALTER VIEW DimSalesTerritory
AS
SELECT
     *
FROM
    OPENROWSET(
        BULK 'https://datalake2demos.dfs.core.windows.net/datalake/analytics_zone/DWHS/DWHDLTDemo/tables/DimSalesTerritory/',
        FORMAT = 'DELTA'
    ) AS [result]

CREATE OR ALTER VIEW DimShipMethod
AS
SELECT
     *
FROM
    OPENROWSET(
        BULK 'https://datalake2demos.dfs.core.windows.net/datalake/analytics_zone/DWHS/DWHDLTDemo/tables/DimShipMethod/',
        FORMAT = 'DELTA'
    ) AS [result]


CREATE OR ALTER VIEW stage.Sales_SalesOrderDetail
AS 
SELECT
     *
FROM
    OPENROWSET(
        BULK 'https://datalake2demos.dfs.core.windows.net/datalake/analytics_zone/Stage/DSAdventureWorks2019/sales_salesorderdetail/',
        FORMAT = 'DELTA'
    ) AS [result]

CREATE OR ALTER VIEW stage.Sales_SalesOrderHeader
AS
SELECT
     *
FROM
    OPENROWSET(
        BULK 'https://datalake2demos.dfs.core.windows.net/datalake/analytics_zone/Stage/DSAdventureWorks2019/sales_salesorderheader/',
        FORMAT = 'DELTA'
    ) AS [result]
```

#### Create Fact View (Done -Skip on demo)

```sql
CREATE OR ALTER VIEW vwFactSalesOrderDetail 
AS
SELECT sd.SalesOrderDetailID AS SalesOrderDetailID	,--NK
	sh.SalesOrderID AS SalesOrderID	,--NK
	dp.ProductID
	,dc.CustomerID
	,dsp.SalesPersonID
	,dsm.ShipMethodID
	,dst.TerritoryID
	,sd.SpecialOfferID AS SpecialOfferID
	,sh.[Status] AS SalesOrderStatus
	,sh.OnlineOrderFlag AS SalesOnlineOrderFlag
	,sh.AccountNumber AS SalesOrderAccountNumber
	,sh.BillToAddressID AS BillToAddressID
	,sh.ShipToAddressID AS ShipToAddressID
	,CAST(sd.ModifiedDate AS DATE) AS SalesOrderDetailModifiedDateKey
	,CAST(sh.OrderDate AS DATE) AS SalesOrderDateKey
	,CAST(sh.DueDate AS DATE) AS SalesOrderDueDateKey
	,CAST(sh.ShipDate AS DATE) AS SalesOrderShipDateKey
	,CAST(sh.ModifiedDate AS DATE) AS SalesOrderModifiedDateKey
	,sd.OrderQty
	,sd.UnitPrice
	,sd.UnitPriceDiscount
	,sd.LineTotal
	,sh.SubTotal AS SalesOrderSubTotal
	,sh.TaxAmt AS SalesOrderTaxAmount
	,sh.Freight AS SalesOrderFreightAmount
	,sh.TotalDue AS SalesOrderTotalDueAmount
	,sd.dczIsDeleted AS IsDeleted 
FROM stage.Sales_SalesOrderDetail sd
LEFT JOIN stage.Sales_SalesOrderHeader sh ON sd.SalesOrderID = sh.SalesOrderID AND sh.dczIsCurrent=1
LEFT JOIN dbo.DimProduct dp ON dp.ProductID = sd.ProductID 
LEFT JOIN dbo.DimCustomer dc ON dc.CustomerID = sh.CustomerID 
LEFT JOIN dbo.DimSalesPerson dsp ON dsp.SalesPersonID = sh.SalesPersonID 
LEFT JOIN dbo.DimShipMethod dsm ON dsm.ShipMethodID = sh.ShipMethodID 
LEFT JOIN dbo.DimSalesTerritory dst ON dst.TerritoryID = sh.TerritoryID 
WHERE sd.dczIsCurrent = 1


SELECT TOP 100 * FROM vwFactSalesOrderDetail 
```

#### Install qpi (Done -Skip on demo)

•[GitHub - ](https://github.com/JocaPC/qpi)[JocaPC](https://github.com/JocaPC/qpi)[/](https://github.com/JocaPC/qpi)[qpi](https://github.com/JocaPC/qpi)[: Query Performance Insight - analyze performance of your SQL Server Database Engine](https://github.com/JocaPC/qpi)

#### Show data from view (SSMS)

```sql
SELECT  * FROM vwFactSalesOrderDetail 
```

#### Drop existing external table location 

Location **/analytics_zone/DWHS/DWHDLTDemo/tables/ExtFactSalesOrderDetail**

```sql
DROP EXTERNAL TABLE FactSalesOrderDetail;
```

#### Create external table - materialize view (SSMS)

```sql
CREATE EXTERNAL TABLE FactSalesOrderDetail
WITH (
    LOCATION = '/analytics_zone/DWHS/DWHDLTDemo/tables/ExtFactSalesOrderDetail/Version=1',
    DATA_SOURCE = DataLake,  
    FILE_FORMAT = PARQUET_FORMAT
)  
AS
SELECT * FROM vwFactSalesOrderDetail ;
```

#### Refresh fact table (SSMS)

```sql

DROP EXTERNAL TABLE FactSalesOrderDetail;
CREATE EXTERNAL TABLE FactSalesOrderDetail
WITH (
    LOCATION = '/analytics_zone/DWHS/DWHDLTDemo/tables/ExtFactSalesOrderDetail/Version=2',
    DATA_SOURCE = DataLake,  
    FILE_FORMAT = PARQUET_FORMAT
)  
AS
SELECT * FROM vwFactSalesOrderDetail
```

#### Check Results (SSMS)

```sql
SELECT * FROM FactSalesOrderDetail
```



#### QPI -Show recommendations (SSMS)

```sql
SELECT * FROM qpi.recommendations
```

#### QPI - Show history (SSMS)

```sql
SELECT TOP 10 * FROM qpi.query_history WHERE query_text LIKE '%FactSalesOrderDetail%' 
ORDER BY start_time DESC
```

#### QPI -Compare queries (SSMS) -(Set proper queries Ids based on query_history)

```
SELECT * FROM qpi.cmp_queries('{EF727ABD-3CDD-439F-B853-23C22E5AD5CD}','{4D63F5A6-C864-443F-A284-38642DAE6F4D}')

```

