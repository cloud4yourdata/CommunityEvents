from sklearn import datasets
from sklearn.svm import SVC
import pickle
import pyodbc
# Connection string to connect to SQL Server named instance
conn_str = 'Driver=SQL Server;Server=.;Database=SQLML;Trusted_Connection=True;'
conn = pyodbc.connect(conn_str)
cursor = conn.cursor()
cursor.execute("select model FROM dbo.iris_models WHERE model_name='SVM' AND model_language ='Python' ")
rows = cursor.fetchall()     
model = rows[0].model;
svn_model = pickle.loads(model)
iris = datasets.load_iris()
X, y = iris.data, iris.target
print(X.columns.tolist())

results = list(svn_model.predict(iris.data[:3])) 
print(results)

