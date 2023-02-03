USE DCSQLServer2022MeetupGliwice;

--Run QUERY, SHOW PLAN
SELECT c.LastName,c.FirstName, SUM(SalesAmount) AS TotalSalesAmount FROM [dbo].[FactInternetSales] AS fis
JOIN dbo.DimCustomerExt AS c ON c.CustomerKey = fis.CustomerKey
GROUP BY c.LastName,c.FirstName;

