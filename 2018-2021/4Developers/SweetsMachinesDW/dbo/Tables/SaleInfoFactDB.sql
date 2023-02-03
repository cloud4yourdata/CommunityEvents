CREATE TABLE [dbo].[SaleInfoFactDB]
(
	[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[Date] DATE NOT NULL,
	[Device] VARCHAR(50) NOT NULL,
	[DeviceLat] FLOAT,
	[DeviceLon] FLOAT,
	[ProductName] VARCHAR(50) NOT NULL,
	[Quantity] INT NOT NULL,
	[Price] DECIMAL (18,4) NOT NULL,
	[TotalValue] DECIMAL(18,4) NOT NULL
)
