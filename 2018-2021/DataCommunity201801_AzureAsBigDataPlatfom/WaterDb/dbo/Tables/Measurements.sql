CREATE TABLE [dbo].[Measurements]
(
	Id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	ObjectId INT NOT NULL,
	MeasDate DATE NOT NULL,
	MinWaterLevel FLOAT NOT NULL,
	MaxWaterLevel FLOAT NOT NULL,
	AvgWaterLevel FLOAT NOT NULL,
	MinTemperature FLOAT NOT NULL,
	MaxTemperature FLOAT NOT NULL,
	AvgTemperature FLOAT NOT NULL,
	MinHumidity FLOAT NOT NULL,
	MaxHumidity FLOAT NOT NULL,
	AvgHumidity FLOAT NOT NULL
)
