-- Databricks notebook source
CREATE LIVE TABLE DimCustomer 
 AS
SELECT
  c.CustomerID, --NK
  c.PersonId, 
  p.Title,--SCD1
  p.FirstName,--SCD1
  p.LastName,--SCD1
  c.AccountNumber, 
  c.ModifiedDate,
  c.dczIsDeleted AS IsDeleted
FROM DSAdventureWorks2019.Sales_Customer AS c
LEFT JOIN DSAdventureWorks2019.Person_Person AS p ON c.PersonId=p.BusinessEntityID AND p.dczIsCurrent=1 --SCD1- only newest version
WHERE c.dczIsCurrent=True

-- COMMAND ----------

CREATE LIVE TABLE DimProductCategory AS
SELECT
  ProductCategoryID,  --NK
  Name,
  ModifiedDate,
  dczIsDeleted AS IsDeleted
FROM
  DSAdventureWorks2019.Production_ProductCategory
WHERE
  dczIsCurrent = True --SCD1- only newest version

-- COMMAND ----------

CREATE LIVE TABLE DimProduct AS
SELECT
  p.ProductID, --NK
  dpc.ProductCategoryID,
  p.ProductNumber as ProductAlternateKey, --UQ in source system
  p.Name,
  p.Color,
  dpc.Name AS ProductCategoryName,
  CAST(p.dczIsDeleted AS BOOLEAN) AS IsDeleted
FROM
  DSAdventureWorks2019.Production_Product AS p
  LEFT JOIN LIVE.DimProductCategory dpc ON dpc.ProductCategoryID = p.ProductSubcategoryId   
  LEFT JOIN DSAdventureWorks2019.Production_ProductModel pm ON p.ProductModelID = pm.ProductModelID AND pm.dczIsCurrent=True
WHERE
  p.dczIsCurrent = True

-- COMMAND ----------

CREATE LIVE TABLE DimSalesPerson
 AS
SELECT
      BusinessEntityID AS SalesPersonID 
      ,PersonType
      ,NameStyle
      ,Title
      ,FirstName
      ,MiddleName
      ,LastName
      ,Suffix
      ,EmailPromotion
      ,AdditionalContactInfo
      ,rowguid
      ,ModifiedDate
      ,dczIsDeleted AS IsDeleted  
FROM DSAdventureWorks2019.Person_Person 
WHERE dczIsCurrent=True


-- COMMAND ----------

CREATE LIVE TABLE DimSalesTerritory 
 AS
SELECT TerritoryID
      ,Name
      ,CountryRegionCode
      ,Group  -- keywords as column names
      ,SalesYTD
      ,SalesLastYear
      ,CostYTD
      ,CostLastYear
      ,rowguid
      ,ModifiedDate
      ,dczIsDeleted AS IsDeleted   
FROM DSAdventureWorks2019.Sales_SalesTerritory 
WHERE dczIsCurrent=True 

-- COMMAND ----------

CREATE LIVE TABLE DimShipMethod
 AS
SELECT
  sm.ShipMethodID, --NK 
  sm.Name,
  sm.ShipBase,
  sm.ShipRate,
  sm.Modifieddate,
  sm.dczIsDeleted AS IsDeleted    
FROM DSAdventureWorks2019.Purchasing_ShipMethod AS sm
WHERE sm.dczIsCurrent=True

-- COMMAND ----------

CREATE LIVE TABLE DimProductModel AS
SELECT
  ProductModelID,
  Name,
  CatalogDescription,
  ModifiedDate,
  dczIsDeleted AS IsDeleted
FROM
  DSAdventureWorks2019.Production_ProductModel
WHERE
  dczIsCurrent = True

-- COMMAND ----------

CREATE LIVE TABLE FactSalesOrderDetail AS
SELECT sd.SalesOrderDetailID AS SalesOrderDetailID	,--NK
	sh.SalesOrderID AS SalesOrderID	,--NK
	dp.ProductID
	,dc.CustomerID
	,dsp.SalesPersonID
	,dsm.ShipMethodID
	,dst.TerritoryID
	,sd.SpecialOfferID AS SpecialOfferID
	,sh.STATUS AS SalesOrderStatus
	,sh.OnlineOrderFlag AS SalesOnlineOrderFlag
	,sh.AccountNumber AS SalesOrderAccountNumber
	,sh.BillToAddressID AS BillToAddressID
	,sh.ShipToAddressID AS ShipToAddressID
	,to_date(sd.ModifiedDate) AS SalesOrderDetailModifiedDateKey
	,to_date(sh.OrderDate) AS SalesOrderDateKey
	,to_date(sh.DueDate) AS SalesOrderDueDateKey
	,to_date(sh.ShipDate) AS SalesOrderShipDateKey
	,to_date(sh.ModifiedDate) AS SalesOrderModifiedDateKey
	,sd.OrderQty
	,sd.UnitPrice
	,sd.UnitPriceDiscount
	,sd.LineTotal
	,sh.SubTotal AS SalesOrderSubTotal
	,sh.TaxAmt AS SalesOrderTaxAmount
	,sh.Freight AS SalesOrderFreightAmount
	,sh.TotalDue AS SalesOrderTotalDueAmount
	,sd.dczIsDeleted AS IsDeleted 
FROM DSAdventureWorks2019.Sales_SalesOrderDetail sd
LEFT JOIN DSAdventureWorks2019.Sales_SalesOrderHeader sh ON sd.SalesOrderID = sh.SalesOrderID AND sh.dczIsCurrent=True
LEFT JOIN LIVE.DimProduct dp ON dp.ProductID = sd.ProductID 
LEFT JOIN LIVE.DimCustomer dc ON dc.CustomerID = sh.CustomerID 
LEFT JOIN LIVE.DimSalesPerson dsp ON dsp.SalesPersonID = sh.SalesPersonID 
LEFT JOIN LIVE.DimShipMethod dsm ON dsm.ShipMethodID = sh.ShipMethodID 
LEFT JOIN LIVE.DimSalesTerritory dst ON dst.TerritoryID = sh.TerritoryID 
WHERE sd.dczIsCurrent = True