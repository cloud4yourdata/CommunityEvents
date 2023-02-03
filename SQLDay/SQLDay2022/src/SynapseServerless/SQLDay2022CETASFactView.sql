CREATE OR ALTER VIEW vwFactSalesOrderDetail 
AS
SELECT sd.SalesOrderDetailID AS SalesOrderDetailID	,
	sh.SalesOrderID AS SalesOrderID	,
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