from revoscalepy import rx_import
from revoscalepy import rx_dforest
from revoscalepy import rx_dtree
from revoscalepy  import  RxSqlServerData
from revoscalepy import rx_serialize_model
import  pyodbc

# Connection string to connect to SQL Server named instance
conn_str = 'Driver=SQL Server;Server=.;Database=SQLML;Trusted_Connection=True;'
sql_query ='SELECT "Sepal.Length","Sepal.Width","Petal.Length","Petal.Width",Species ' \
    'FROM dbo.vw_iris_training';

data_source = RxSqlServerData(sql_query =sql_query,
                              connection_string=conn_str
                              )
iris_train_data = rx_import(input_data=data_source )
iris_train_data["Species"] = iris_train_data["Species"].astype("category")

model = rx_dforest("Species ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width",
                         data = iris_train_data
                         )
trained_rx_dforest_model = rx_serialize_model(model, realtime_scoring_only = True);
#Save model
conn = pyodbc.connect(conn_str)
cursor = conn.cursor()
cursor.execute("DELETE FROM dbo.iris_models WHERE model_name ='rxDForest' AND model_language ='Python'");
cursor.execute("INSERT INTO dbo.iris_models(model,model_name,model_language) values (?,?, ?)", 
               trained_rx_dforest_model,'rxDForest','Python')
conn.commit()
