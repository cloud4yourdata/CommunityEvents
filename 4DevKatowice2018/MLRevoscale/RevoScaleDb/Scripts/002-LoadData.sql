TRUNCATE TABLE dbo.Wines;
INSERT INTO dbo.Wines(
	[Facidity],
	[Vacidity],
	[Citric],
	[Sugar],
	[Chlorides],
	[Fsulfur], 
    [Tsulfur],
	[Density],
	[pH],
	[Sulphates],
	[Alcohol],
	[Quality],
	[Color]
)
EXECUTE   sp_execute_external_script                      
@language = N'Python'                     
,@script = N'
import pandas as pd
localWinePath = "d:\\Repos\\Cloud4YourData\\Demos\\4DevKatowice2018\\MLRevoscale\\Data\\wines.csv"
OutputDataSet = pd.read_csv(localWinePath, sep=";")
'

SELECT COUNT(*) FROM dbo.Wines WHERE Color ='white'   
SELECT COUNT(*) FROM dbo.Wines WHERE Color ='red'  

---
TRUNCATE TABLE [dbo].[WineTrain];
INSERT INTO [dbo].[WineTrain] 
SELECT TOP 70 PERCENT 
[Id] AS [WineId],
[Facidity],
	[Vacidity],
	[Citric],
	[Sugar],
	[Chlorides],
	[Fsulfur], 
    [Tsulfur],
	[Density],
	[pH],
	[Sulphates],
	[Alcohol],
	[Quality],
	[Color]        
FROM [dbo].[Wines] WHERE [Color] ='white'       
UNION ALL
SELECT TOP 70 PERCENT 
[Id] AS [WineId],
[Facidity],
	[Vacidity],
	[Citric],
	[Sugar],
	[Chlorides],
	[Fsulfur], 
    [Tsulfur],
	[Density],
	[pH],
	[Sulphates],
	[Alcohol],
	[Quality],
	[Color]        
FROM [dbo].[Wines] WHERE [Color] ='red' 

TRUNCATE TABLE [dbo].[WineTest];
INSERT INTO [dbo].[WineTest]
SELECT 
[Id] AS [WineId],
[Facidity],
	[Vacidity],
	[Citric],
	[Sugar],
	[Chlorides],
	[Fsulfur], 
    [Tsulfur],
	[Density],
	[pH],
	[Sulphates],
	[Alcohol],
	[Quality],
	[Color]        
FROM [dbo].[Wines] WHERE [Id] NOT 
IN (SELECT [WineId] FROM [dbo].[WineTrain])

SELECT * FROM  [dbo].[WineTrain]