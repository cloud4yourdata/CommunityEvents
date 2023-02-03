
#import matplotlib.pyplot as plt
#from mpl_toolkits.mplot3d import Axes3D
#from sklearn import datasets
#from sklearn.decomposition import PCA
#import matplotlib.image as mpimg

## import some data to play with
#iris = datasets.load_iris()
#X = iris.data[:, :2]  # we only take the first two features.
#y = iris.target

#x_min, x_max = X[:, 0].min() - .5, X[:, 0].max() + .5
#y_min, y_max = X[:, 1].min() - .5, X[:, 1].max() + .5

## To getter a better understanding of interaction of the dimensions
## plot the first three PCA dimensions
#fig = plt.figure(1, figsize=(8, 6))

#ax = Axes3D(fig, elev=-150, azim=110)
#X_reduced = PCA(n_components=3).fit_transform(iris.data)
#ax.scatter(X_reduced[:, 0], X_reduced[:, 1], X_reduced[:, 2], c=y,
#           cmap=plt.cm.Set1, edgecolor='k', s=40)
#ax.set_title("First three PCA directions")
#ax.set_xlabel("1st eigenvector")
#ax.w_xaxis.set_ticklabels([])
#ax.set_ylabel("2nd eigenvector")
#ax.w_yaxis.set_ticklabels([])
#ax.set_zlabel("3rd eigenvector")
#ax.w_zaxis.set_ticklabels([])

import pyodbc
import pickle
import os
conn_str = 'Driver=SQL Server;Server=.;Database=SQLML;Trusted_Connection=True;'
cnxn = pyodbc.connect(conn_str)
cursor = cnxn.cursor()
cursor.execute("EXEC dbo.usp_Plot")
tables = cursor.fetchall()
for i in range(0, len(tables)):
    fig = pickle.loads(tables[i][0])
    fig.savefig('C:\\tmp\\'+str(i)+'.png')
print("The plots are saved in directory")