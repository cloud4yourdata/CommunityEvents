from sklearn.svm import SVC
import pickle

def usqlml_main(df):
    del df['Name']
    if 'FileName' in df.columns:
        del df['FileName']
    modelFile = 'iris_model_svm.bin'
    file = open(modelFile, 'rb')
    svn_model = pickle.load(file)
    file.close()
    results = list(svn_model.predict(df))
    df['Predicted'] =  results
    return df