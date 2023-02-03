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

dir_name = 'd:\\Repos\\Cloud4YourData\\SQLDay2018\\Misc\\DS'

def grid_search(model, params, data_train_x, data_train_y):
    num_samples = len(data_train_y)
    num_features = data_train_x.shape[1]
    grid_search = model_selection.GridSearchCV(model, params, n_jobs=-1, cv = 10, scoring='neg_mean_squared_log_error') 
    grid_search.fit(data_train_x, data_train_y)

    return grid_search.best_estimator_, grid_search

def remove_columns(dataset, columns_to_remove):
    for column in columns_to_remove:
        dataset = dataset.loc[:, dataset.columns != column]

    return dataset

def add_total_porch_area(dataset):
    dataset['PorchArea'] = dataset['OpenPorchSF'] + dataset['EnclosedPorch'] + dataset['3SsnPorch'] +dataset['ScreenPorch']
    return dataset

def encode_ordered_labels(dataset, order, columns):
    for column in columns:
        dataset[column] = dataset[column].replace(order)

    return dataset

def load_data(file_name):
    dataset = pd.read_csv(file_name, sep=',')

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

def split_set(data_train):
    data_train_x = data_train.loc[:, data_train.columns != COLUMN_Y].copy()
    data_train_y = data_train.loc[:, data_train.columns == COLUMN_Y].values.flatten()
    return model_selection.train_test_split(data_train_x, data_train_y, test_size=0.3)

def predict(model, error, data_test_id, data_test_x):
    data_pred_y = model.predict(data_test_x)
    data_pred_y = pd.DataFrame(np.round(data_pred_y).astype(int), columns=[COLUMN_Y])

    result = pd.concat([data_test_id, data_pred_y], axis=1)

    file_name = type(model).__name__ + '_' + time.strftime("%Y%m%d_%H%M") + '_Local' + str(error) + '_KaggleXXXX' + '.csv'
    result.to_csv('Data\\Results\\' + file_name, index=False, sep=',')

def calculate_score(model, data_valid_x, data_valid_y):
    data_pred_y = model.predict(data_valid_x)

    rmse = round(math.sqrt(metrics.mean_squared_log_error(data_valid_y, data_pred_y)), 4)
    print("PREDICTION RMSE:\t%s" % rmse)
    return rmse

def convert_from_ft_to_m(dataset, column, mult = 1):
    ft_to_m = 0.09290304
    dataset[column] = round(dataset[column] * ft_to_m * mult)
    return dataset

def convert_year_to_range(dataset, column):
    dataset.loc[dataset[column] <= 1940, column] = 1
    dataset.loc[(dataset[column] > 1940) & (dataset[column] <= 1960), column] = 2
    dataset.loc[(dataset[column] > 1960) & (dataset[column] <= 1980), column] = 3
    dataset.loc[(dataset[column] > 1980) & (dataset[column] <= 1990), column] = 4
    dataset.loc[(dataset[column] > 1990) & (dataset[column] <= 2000), column] = 5
    dataset.loc[(dataset[column] > 2000), column] = 6

    return dataset

def convert_month_sold_to_season(dataset):
    dataset.loc[dataset['MoSold'].isin([12, 1, 2]), 'MoSold'] = 1 # winter
    dataset.loc[dataset['MoSold'].isin([9, 10, 11]), 'MoSold'] = 2 # autumn
    dataset.loc[dataset['MoSold'].isin([3, 4, 5]), 'MoSold'] = 3 # spring
    dataset.loc[dataset['MoSold'].isin([6, 7, 8]), 'MoSold'] = 4 # summer
    return dataset

def convert_year_sold_to_age(dataset):
    dataset['YrSold'] = 2010 - dataset['YrSold']
    return dataset

def remove_upper_outliers(dataset, column, value):
    for index, row in dataset.iterrows():
        if row[column] > value:
            dataset.at[index, column] = value
    return dataset

def remove_lower_outliers(dataset, column, value):
    for index, row in dataset.iterrows():
        if row[column] < value:
            dataset.at[index, column] = value
    return dataset

def add_has_pool_column(dataset):
    dataset['HasPool'] = [1 if pool_area > 0 else 0 for pool_area in dataset['PoolArea'].values.flatten()]
    return dataset

def normalize(dataset, columns, max_value):
    for column in columns:
        dataset[column] = dataset[column] / max_value
    return dataset

data_train_id, data_train = load_data(dir_name + '\\train.csv')
data_train_x, data_valid_x, data_train_y, data_valid_y = split_set(data_train)

#model, gs = grid_search(ensemble.ExtraTreesRegressor(), 
#                    {
#                        'max_depth' : [2, 10],
#                    }, data_train_x, data_train_y)

model = ensemble.ExtraTreesRegressor()
model.fit(data_train_x, data_train_y)

rmse = calculate_score(model, data_valid_x, data_valid_y)
joblib.dump(model, dir_name + '\\housePricesModel.pkl')

