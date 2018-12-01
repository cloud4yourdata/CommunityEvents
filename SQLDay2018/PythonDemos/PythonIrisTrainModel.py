from sklearn import datasets
from sklearn.svm import SVC
import pickle
import pandas as pd

modelFile = 'd:\Repos\Cloud4YourData\SQLDay2018\Misc\iris_model_svm.bin'
iris = datasets.load_iris()
print(iris.data)
input = pd.DataFrame(iris.data)
#del input[1]

print(input)

clf = SVC()
clf.fit(iris.data, iris.target_names[iris.target]) 

# open a file, where you ant to store the data
#file = open('d:\Repos\Cloud4YourData\SQLDay2018\Misc\iris_model_svm.bin', 'wb')
#trained_model = pickle.dumps(clf)
#pickle.dumps(clf,trained_model)
#file.close()

with open(modelFile, 'wb') as file:
    pickle.dump(clf, file)


