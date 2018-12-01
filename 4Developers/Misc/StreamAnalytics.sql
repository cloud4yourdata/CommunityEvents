--POWER  BI
;WITH SaleInfo AS
(
SELECT se.SerialNumber,se.EventValue1, COUNT(*) AS Total 
 FROM [SweetsMachinesEvents] AS se 
TIMESTAMP BY se.EventTime 
WHERE se.EventType = 1 --Information about the sale
GROUP BY TUMBLINGWINDOW(second,30), se.SerialNumber, se.EventValue1 
)
SELECT si.SerialNumber AS Device, sp.Name AS Product, si.Total
INTO SweetsStream
FROM SaleInfo AS si
JOIN SweetsProducts AS sp ON sp.ProductId = si.EventValue1;

--WARN
SELECT ti.SerialNumber,ti.AvgTemp, d.min AS MinTemp, d.max AS MaxTemp
INTO [SweetsMachinesWarn]
FROM (
SELECT se.SerialNumber, AVG(EventValue1) AS AvgTemp
 FROM [SweetsMachinesEvents] AS se 
 TIMESTAMP BY se.EventTime 
 WHERE se.EventType = 0 --Information about temp
 GROUP BY TUMBLINGWINDOW(second,30), se.SerialNumber 
)
 AS ti
JOIN [SweetsDevices] AS d ON d.id = ti.SerialNumber 
WHERE ti.AvgTemp < d.min OR ti.AvgTemp > d.max ;


--RAW DATA -> ADLS
SELECT * 
INTO [SweetsRawCsvData]
FROM [SweetsMachinesEvents] AS se
    TIMESTAMP BY se.EventTime;

