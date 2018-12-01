'''
  Python reducer UDO definition
'''
from scipy import signal
def usqlml_main(df):
    k = 11
    df['SmoothMesValue'] = signal.medfilt(df['MesValue'],k)
    #MesDate, MesValue, FileName,
    del df['MesDate']
    del df['MesValue']
    del df['FileName']
    return df