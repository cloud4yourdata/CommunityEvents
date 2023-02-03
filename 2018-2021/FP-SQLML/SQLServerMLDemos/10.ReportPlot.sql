CREATE OR ALTER PROCEDURE dbo.usp_Plot
AS
BEGIN
 DECLARE @py_script NVARCHAR(MAX);
SET @py_script =N'
import pandas as pd
import pickle
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from sklearn import datasets
from sklearn.decomposition import PCA

# import some data to play with
iris = datasets.load_iris()
X = iris.data[:, :2]  # we only take the first two features.
y = iris.target

x_min, x_max = X[:, 0].min() - .5, X[:, 0].max() + .5
y_min, y_max = X[:, 1].min() - .5, X[:, 1].max() + .5
fig = plt.figure(2, figsize=(8, 6))
plt.clf()

# Plot the training points
plt.scatter(X[:, 0], X[:, 1], c=y, cmap=plt.cm.Set1,
            edgecolor="k")
plt.xlabel("Sepal length")
plt.ylabel("Sepal width")

plt.xlim(x_min, x_max)
plt.ylim(y_min, y_max)
plt.xticks(())
plt.yticks(())
fig.savefig("C:\\tmp\\2222.png")
plot0 = pd.DataFrame(data =[pickle.dumps(fig)], columns =["plot"])
plt.clf()
OutputDataSet = plot0'
EXEC sp_execute_external_script
				@language = N'Python',
				@script = @py_script
WITH RESULT SETS ((plot varbinary(max)))

END