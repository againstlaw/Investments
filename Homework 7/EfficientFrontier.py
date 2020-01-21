

import pandas as pd
import pandas_datareader.data as web
import numpy as np
import scipy as sp
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

Price.index=pd.to_datetime(Price.index)



# select prices at start of each week
SelectPrice = Price.loc[[i for i in Price.index if int(i.strftime('%W'))>0]]

myPrice = SelectPrice.groupby(by=[SelectPrice.index.year, SelectPrice.index.strftime('%W')]).head(1)

mydates = myPrice.index


# weekly return
ret_Weekly = myPrice/myPrice.shift(1)-1

r_Weekly = myPrice.pct_change()

ret_Weekly = ret_Weekly.dropna()

print(ret_Weekly.mean())

print(ret_Weekly.std())


covariance = ret_Weekly.cov()

corr = ret_Weekly.corr()

Rtn=ret_Weekly.mean()



# --- Brute-force calculation ---

zz=0
R_bf=[]
S_bf=[]
for j in np.linspace(-1, 1, num=21):
    for k in np.linspace(-1, 1, num=21):
        for l in np.linspace(-1, 1, num=21):
            for m in np.linspace(-1, 1, num=21):
                for n in np.linspace(-1, 1, num=21):
                    w_bf = np.array([ j, k, l, m, n ])
                    if w_bf.sum()==1.0:
                        zz += 1
                        R_bf.append(np.dot(w_bf,Rtn))
                        S_bf.append(np.sqrt(np.dot(np.dot(w_bf,covariance),w_bf)))


#colors = np.random.rand(len(R_bf))
#colors = np.linspace(1,10,len(R_bf))
#plt.scatter(S_bf,R_bf, s=1, c=colors, label='portfolio')

plt.plot(S_bf,R_bf,'o', c='k', markersize=1, label='portfolio')
plt.legend(loc='best')
plt.title('Efficient Frontier', fontsize=16)
plt.xlabel('Risk', fontsize=12)
plt.ylabel('Return', fontsize=12)
plt.grid(True, axis='both')




