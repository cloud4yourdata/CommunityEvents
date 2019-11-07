USE SQLML;

DROP TABLE IF EXISTS Demo;
	CREATE TABLE Demo (Id INT NOT NULL IDENTITY(1, 1) PRIMARY KEY);

INSERT INTO Demo DEFAULT VALUES 
GO 1000
GO

---
DROP TABLE IF EXISTS iris_data
	,iris_models;

	CREATE TABLE iris_data (
		 Id INT NOT NULL IDENTITY              
		,"Sepal.Length" FLOAT NOT NULL
		,"Sepal.Width" FLOAT NOT NULL              
		,"Petal.Length" FLOAT NOT NULL
		,"Petal.Width" FLOAT NOT NULL              
		,"Species" VARCHAR(100) NULL
		);

CREATE TABLE dbo.iris_models (
           id INT NOT NULL IDENTITY(1,1) PRIMARY KEY
	       ,model_name VARCHAR(30) NOT NULL
	,model_language VARCHAR(10) NOT NULL
	,       model VARBINARY(max) NOT NULL
	);
GO

