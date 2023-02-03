from sklearn import datasets
from sklearn.svm import SVC
import pickle
import pyodbc
# Connection string to connect to SQL Server named instance
conn_str = 'Driver=SQL Server;Server=.;Database=SQLML;Trusted_Connection=True;'
iris = datasets.load_iris()
clf = SVC()
clf.fit(iris.data, iris.target_names[iris.target]) 
trained_model = pickle.dumps(clf)
print(iris.data)

print(list(clf.predict(iris.data[:150]))) 

#Save model
conn = pyodbc.connect(conn_str)
cursor = conn.cursor()
cursor.execute("DELETE FROM dbo.iris_models WHERE model_name ='SVM' AND model_language ='Python'");
cursor.execute("INSERT INTO dbo.iris_models(model,model_name,model_language) values (?,?, ?)", 
               trained_model,'SVM','Python')
conn.commit()

