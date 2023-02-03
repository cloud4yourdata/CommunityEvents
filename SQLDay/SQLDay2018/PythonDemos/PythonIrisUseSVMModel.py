from sklearn import datasets
from sklearn.svm import SVC
import pickle
import pandas as pd

modelFile = 'd:\Repos\Cloud4YourData\SQLDay2018\Misc\iris_model_svm.bin'

#load model
file = open(modelFile, 'rb')
svn_model = pickle.load(file)
file.close()

input = pd.DataFrame(iris.data);
results = list(svn_model.predict(input))
input['target'] = iris.target_names[iris.target]
input['pred'] = results
print(input)

