CREATE TABLE [dbo].[TempInfoFactDB]
(
	[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[Date] DATE NOT NULL,
	[Device] VARCHAR(50) NOT NULL,
	[DeviceLat] FLOAT,
	[DeviceLon] FLOAT,
	[AvgTemp] FLOAT
)
