CREATE TABLE [dbo].[WineTrain]
(
	[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[WineId] INT NOT NULL,
	[Facidity] FLOAT NOT NULL,
	[Vacidity] FLOAT NOT NULL,
	[Citric] FLOAT NOT NULL,
	[Sugar] FLOAT NOT NULL,
	[Chlorides] FLOAT NOT NULL,
	[Fsulfur] FLOAT NOT NULL, 
    [Tsulfur] FLOAT NOT NULL,
	[Density] FLOAT NOT NULL,
	[pH] FLOAT NOT NULL,
	[Sulphates] FLOAT NOT NULL,
	[Alcohol] FLOAT NOT NULL,
	[Quality] INT NOT NULL,
	[Color] VARCHAR(20) NOT NULL
)
