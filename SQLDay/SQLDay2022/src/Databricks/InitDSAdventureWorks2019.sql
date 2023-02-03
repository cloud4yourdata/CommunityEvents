-- Databricks notebook source
CREATE DATABASE IF NOT EXISTS DSAdventureWorks2019 LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019'

-- COMMAND ----------

CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.dbo_DatabaseLog  USING DELTA   LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/dbo_databaselog'

-- COMMAND ----------

CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.dbo_ErrorLog  USING DELTA   LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/dbo_errorlog'

-- COMMAND ----------

CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.dbo_AWBuildVersion  USING DELTA   LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/dbo_awbuildversion'

-- COMMAND ----------

CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.HumanResources_Shift  USING DELTA   LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/humanresources_shift'

-- COMMAND ----------

CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.HumanResources_EmployeePayHistory  USING DELTA   LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/humanresources_employeepayhistory'

-- COMMAND ----------

CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.HumanResources_JobCandidate USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/humanresources_jobcandidate';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.HumanResources_Department USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/humanresources_department';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.HumanResources_Employee USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/humanresources_employee';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.HumanResources_EmployeeDepartmentHistory USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/humanresources_employeedepartmenthistory';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Person_EmailAddress USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/person_emailaddress';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Person_ContactType USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/person_contacttype';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Person_AddressType USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/person_addresstype';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Person_StateProvince USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/person_stateprovince';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Person_BusinessEntity USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/person_businessentity';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Person_BusinessEntityAddress USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/person_businessentityaddress';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Person_BusinessEntityContact USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/person_businessentitycontact';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Person_CountryRegion USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/person_countryregion';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Person_Person USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/person_person';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Person_Password USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/person_password';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Person_PersonPhone USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/person_personphone';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Person_PhoneNumberType USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/person_phonenumbertype';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Person_Address USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/person_address';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Production_ProductDocument USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/production_productdocument';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Production_ProductModel USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/production_productmodel';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Production_ProductModelProductDescriptionCulture USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/production_productmodelproductdescriptionculture';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Production_BillOfMaterials USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/production_billofmaterials';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Production_ProductCategory USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/production_productcategory';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Production_ProductCostHistory USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/production_productcosthistory';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Production_ProductDescription USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/production_productdescription';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Production_ProductListPriceHistory USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/production_productlistpricehistory';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Production_ProductInventory USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/production_productinventory';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Production_Product USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/production_product';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Production_Illustration USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/production_illustration';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Production_ScrapReason USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/production_scrapreason';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Production_Location USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/production_location';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Production_WorkOrder USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/production_workorder';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Production_UnitMeasure USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/production_unitmeasure';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Production_TransactionHistoryArchive USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/production_transactionhistoryarchive';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Production_ProductSubcategory USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/production_productsubcategory';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Production_ProductModelIllustration USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/production_productmodelillustration';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Production_ProductPhoto USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/production_productphoto';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Production_ProductProductPhoto USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/production_productproductphoto';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Production_TransactionHistory USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/production_transactionhistory';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Production_ProductReview USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/production_productreview';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Production_Culture USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/production_culture';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Production_WorkOrderRouting USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/production_workorderrouting';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Production_Document USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/production_document';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Purchasing_PurchaseOrderHeader USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/purchasing_purchaseorderheader';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Purchasing_Vendor USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/purchasing_vendor';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Purchasing_ProductVendor USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/purchasing_productvendor';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Purchasing_PurchaseOrderDetail USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/purchasing_purchaseorderdetail';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Purchasing_ShipMethod USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/purchasing_shipmethod';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Sales_ShoppingCartItem USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/sales_shoppingcartitem';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Sales_SpecialOffer USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/sales_specialoffer';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Sales_Store USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/sales_store';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Sales_SpecialOfferProduct USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/sales_specialofferproduct';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Sales_SalesOrderHeaderSalesReason USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/sales_salesorderheadersalesreason';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Sales_SalesPerson USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/sales_salesperson';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Sales_SalesReason USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/sales_salesreason';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Sales_SalesTaxRate USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/sales_salestaxrate';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Sales_PersonCreditCard USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/sales_personcreditcard';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Sales_SalesTerritoryHistory USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/sales_salesterritoryhistory';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Sales_SalesTerritory USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/sales_salesterritory';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Sales_SalesPersonQuotaHistory USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/sales_salespersonquotahistory';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Sales_CreditCard USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/sales_creditcard';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Sales_CurrencyRate USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/sales_currencyrate';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Sales_Customer USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/sales_customer';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Sales_SalesOrderDetail USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/sales_salesorderdetail';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Sales_Currency USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/sales_currency';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Sales_CountryRegionCurrency USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/sales_countryregioncurrency';
CREATE TABLE IF NOT EXISTS DSAdventureWorks2019.Sales_SalesOrderHeader USING DELTA LOCATION 'dbfs:/mnt/datalake/analytics_zone/Stage/DSAdventureWorks2019/sales_salesorderheader';

-- COMMAND ----------



-- COMMAND ----------

CREATE DATABASE IF NOT EXISTS DWHSql2022Model LOCATION 'dbfs:/mnt/datalake/analytics_zone/DWHS/DWHSql2022Model'

-- COMMAND ----------

CREATE OR REPLACE VIEW DWHSql2022Model.vwDimCustomer 
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

CREATE
OR REPLACE VIEW DWHSql2022Model.vwDimProductCategory AS
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
  dpc.ProductCategoryKey,
  p.ProductNumber as ProductAlternateKey, --UQ in source system
  p.Name,
  p.Color,
  dpc.Name AS ProductCategoryName,
  CAST(p.dczIsDeleted AS BOOLEAN) AS IsDeleted
FROM
  DSAdventureWorks2019.Production_Product AS p
  LEFT JOIN LIVE.DimProductCategory dpc ON dpc.ProductCategoryID = p.ProductSubcategoryId  AND dpc.DlhIsCurrent = True  
  LEFT JOIN DSAdventureWorks2019.Production_ProductModel pm ON p.ProductModelID = pm.ProductModelID AND pm.dczIsCurrent=True
WHERE
  p.dczIsCurrent = True