from sklearn import datasets
import pandas as pd
#iris = datasets.load_iris()
#input = pd.DataFrame(iris.data)
#input['a'] = 'a'
#print(input)

import pandas as pd
df = pd.DataFrame([[100, 2, 1], [1111, 3, 2], [4, 6, 3], [4, 3, 4]], columns=['A', 'B', 'C'])
print(df['A'].iloc[0])
a = len(df);


newDF = pd.DataFrame(len(df),columns =['RowNum']) #creates a new dataframe that's empty
#newDF = newDF.append(oldDF, ignore_index = True) # ignoring index is optional

#print(len(df))