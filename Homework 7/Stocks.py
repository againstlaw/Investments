# -*- coding: utf-8 -*-
"""
Created on Mon Jan 13 21:13:02 2020

@author: Jason
"""

import pandas as pd
import pandas_datareader.data as web
import numpy as np
import matplotlib.pyplot as plt
from datetime import datetime
import xlrd



# Load data
filename = 'lecture6p.xlsx'

xlsx = xlrd.open_workbook(filename)
SheetNames = xlsx.sheet_names()
NumSheet = len(SheetNames)

data = pd.read_excel(filename, sheet_name = [x for x in SheetNames[:NumSheet-1]], index_col = 'Date')

Price = pd.DataFrame()
Returns = pd.DataFrame()

for i in range(NumSheet-1):
    mydata=data[SheetNames[i]]['Adj Close']
    mydata.name=SheetNames[i]
    Price=pd.concat([Price,mydata], axis=1)
    
    # simple returns
    Lag_mydata=mydata.shift(1)
    myret=(mydata-Lag_mydata)/Lag_mydata
    Returns=pd.concat([Returns,myret], axis=1)

Price=Price.dropna()
Returns=Returns.dropna()

'''
print(Price.head())
print(Returns.head())
'''


# normalized price
Normalized_Price=Price/Price.iloc[0,:]



# recession data from FRED
recession = 'USREC'

start = pd.to_datetime('1990-01-01')
end = pd.datetime.today()

recs = web.DataReader([recession], 'fred', start, end)

recs_2k = recs['2001']
recs_2k8 = recs['2008']


recs2k_bgn = recs_2k.index[0]
recs2k_end = recs_2k.index[-1]

recs2k8_bgn = recs_2k8.index[0]
recs2k8_end = recs_2k8.index[-1]



import seaborn as sns

sns.set_style('white', {"xtick.major.size": 2, "ytick.major.size": 2})
flatui = ["#9b59b6", "#3498db", "#95a5a6", "#e74c3c", "#34495e", "#2ecc71","#f4cae4"]
sns.set_palette(sns.color_palette(flatui,7))


"""
fig, ax = plt.subplots(1,1, figsize=(10,7), sharex=True)
Normalized_Price.plot(ax=ax)

ax.axvspan(recs2k_bgn, recs2k_end, color=sns.xkcd_rgb['grey'], alpha=0.5)
ax.axvspan(recs2k8_bgn, recs2k8_end,  color=sns.xkcd_rgb['grey'], alpha=0.5)

"""

fig, ax = plt.subplots()

Normalized_Price.plot(ax = ax)

ax.axvspan(recs2k_bgn, recs2k_end, color=sns.xkcd_rgb['grey'], alpha=0.5)
ax.axvspan(recs2k8_bgn, recs2k8_end,  color=sns.xkcd_rgb['grey'], alpha=0.5)

ax.legend(loc='lower center', ncol=5, bbox_to_anchor=(0.5, -0.25), fancybox=True, shadow=True)

ax.set_ylabel('Normalized Price', fontsize=12)
ax.grid(True, axis='y', linestyle='dotted')
ax.set_title('Normalized Stock Price', fontsize=16)

#plt.title('Normalized Stock Price', fontsize=16)
