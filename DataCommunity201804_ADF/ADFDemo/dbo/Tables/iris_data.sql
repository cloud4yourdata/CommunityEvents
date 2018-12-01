CREATE TABLE [dbo].[iris_data](
	[Id] [int] NOT NULL PRIMARY KEY,
	[Sepal.Length] [float] NOT NULL,
	[Sepal.Width] [float] NOT NULL,
	[Petal.Length] [float] NOT NULL,
	[Petal.Width] [float] NOT NULL,
	[Species] [nvarchar](255) NULL
)