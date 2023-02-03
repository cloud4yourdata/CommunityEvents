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
