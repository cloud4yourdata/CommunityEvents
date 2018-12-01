import math
import time
import random
import pickle
import numpy as np
import pandas as pd
from collections import namedtuple
from sklearn import model_selection
from sklearn import ensemble
from sklearn import preprocessing
from sklearn import metrics
from sklearn import linear_model
from sklearn.externals import joblib
COLUMN_ID = 'Id'
COLUMN_Y = 'SalePrice'
def prepare_data(dataset):
    
    dataset = add_total_porch_area(dataset)

    dataset = encode_ordered_labels(dataset,
        {'Reg': 4, 'IR1': 3, 'IR2': 2, 'IR3': 1},
        ['LotShape'])
    dataset = encode_ordered_labels(dataset,
        {'1Fam': 5, '2fmCon': 4, 'Duplex': 3, 'TwnhsE': 2, 'Twnhs': 1},
        ['BldgType'])
    dataset = encode_ordered_labels(dataset,
        {'Ex': 5, 'Gd': 4, 'TA': 3, 'Fa': 2, 'Po': 1, 'NA': 0},
        ['ExterQual', 'ExterCond', 'HeatingQC', 'KitchenQual', 'GarageQual', 'GarageCond'])
    dataset = encode_ordered_labels(dataset,
        {'Y': 1, 'N': 0},
        ['CentralAir'])
    dataset = convert_from_ft_to_m(dataset, 'LotArea', 0.01) # convert to AR
    dataset = convert_year_to_range(dataset, 'YearBuilt')
    dataset = convert_year_to_range(dataset, 'YearRemodAdd')
    dataset = convert_year_to_range(dataset, 'GarageYrBlt')

    dataset = convert_month_sold_to_season(dataset)
    dataset = convert_year_sold_to_age(dataset)

    dataset = convert_from_ft_to_m(dataset, 'TotalBsmtSF')
    dataset = convert_from_ft_to_m(dataset, '1stFlrSF')
    dataset = convert_from_ft_to_m(dataset, '2ndFlrSF')
    dataset = convert_from_ft_to_m(dataset, 'GrLivArea')
    dataset = convert_from_ft_to_m(dataset, 'GarageArea')
    dataset = convert_from_ft_to_m(dataset, 'PorchArea')

    dataset_id = dataset.loc[:, dataset.columns == COLUMN_ID]

    dataset = dataset.fillna(0)

    dataset = remove_columns(dataset, ['LowQualFinSF', 'PoolArea', 'CentralAir'])

    return dataset_id, remove_columns(dataset, [COLUMN_ID, 'MSZoning', 'MSSubClass', 'LotFrontage', 'Street', 'Alley', 'LandContour', 'Utilities', 'LotConfig', 'LandSlope', 'Neighborhood', 'Condition1', 'Condition2', 'HouseStyle', 'RoofStyle', 'RoofMatl', 'Exterior1st', 'Exterior2nd', 'MasVnrType', 'MasVnrArea', 'Foundation', 'BsmtQual', 'BsmtCond', 'BsmtExposure', 'BsmtFinType1', 'BsmtFinSF1', 'BsmtFinType2', 'BsmtFinSF2', 'BsmtUnfSF', 'Heating', 'Electrical', 'PavedDrive', 'PoolQC', 'Fence', 'MiscFeature', 'MiscVal', 'SaleType', 'SaleCondition', 'OpenPorchSF', 'EnclosedPorch', '3SsnPorch', 'ScreenPorch', 'Functional', 'GarageType', 'GarageFinish', 'FireplaceQu', 'WoodDeckSF'])

def add_header(dataset, header_file,dataColName ='Content'):
    header = pd.read_csv(header_file, sep=',')
    df = header.drop(0)
    print(df['LotArea'].dtypes)
    df1 = pd.DataFrame(data[dataColName].str.split(',', expand=True))
    df1.columns =list(header);
    df = df.append(df1,ignore_index=True)
    #df['GarageYrBlt']=df.GarageYrBlt.astype(int)
    return df

header_file_name ="d:\\tmp\\housePricesHeader.csv"
data_file = "d:\\tmp\\Python_HousePrices.csv";
data = pd.read_csv(data_file,names =['Content'])




df = add_header (data, header_file_name) 
df = df.replace('NA',np.nan, regex=True)
df = df.apply(pd.to_numeric, errors='ignore')

##data_test_id, data_test_x = prepare_data(df)
print(df.head())

print(list(df))
print(df['GarageYrBlt'])
print(df['GarageYrBlt'].dtypes)
