
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


covariance = np.array(ret_Weekly.cov())
corr = np.array(ret_Weekly.corr())
Rtn = np.array(ret_Weekly.mean())
Sigma = np.array(ret_Weekly.std())

nAssets = len(Rtn)

r = np.arange(0.001,0.006,0.0001)
N = len(r)


from numpy.linalg import inv

one = np.ones(nAssets)
X = np.dot(np.dot(Rtn, inv(covariance)), Rtn)
Y = np.dot(np.dot(Rtn, inv(covariance)), one)
Z = np.dot(np.dot(one.T, inv(covariance)), one)
D = X*Z-Y**2
g = 1/D*(X*np.dot(inv(covariance),one)-Y*(np.dot(inv(covariance),Rtn)))
h = 1/D*(Z*np.dot(inv(covariance),Rtn)-Y*(np.dot(inv(covariance),one)))


r_max = 0.007
r_min = 0.001
dr = 0.00001
N = int((r_max-r_min)/dr)+1

zz = 0
W_p=[]
R_p=[]
S_p=[]
for j in np.linspace(r_min, r_max, num=N):
    w_j = g+h*j
    W_p.append(w_j.T)
    R_p.append(np.dot(w_j.T, Rtn))
    S_p.append(np.sqrt(np.dot(np.dot(w_j.T, covariance), w_j)))
    zz += 1



# minimum-variance portfolio (MVP)
minvar = min(S_p)
minpos = S_p.index(min(S_p))
minR = R_p[minpos]
minW = W_p[minpos]

print(minvar)
print(minR)
print(minW)



# Construct the tangency portfolio

# Load Fama-French data
FFdata = pd.read_excel(filename, sheet_name = SheetNames[-1], header = 4, index_col = 0)
FFdata.index = pd.to_datetime(FFdata.index, format='%Y%m%d')

FirstDay = Price.index[0]
myFFdata = FFdata.loc[FFdata.index >= FirstDay]

Rf_daily = myFFdata.RF/100

Rf_Price_daily = (1+Rf_daily).cumprod()

# select Rf_Prices at start of each week
Select_Price_daily = Rf_Price_daily.loc[[i for i in Rf_Price_daily.index if int(i.strftime('%W'))>0]]

Rf_Price_Weekly = Select_Price_daily.groupby(by=[Select_Price_daily.index.year, Select_Price_daily.index.strftime('%W')]).head(1)

Rf_dates = Rf_Price_Weekly.index

Rf_Weekly = Rf_Price_Weekly.pct_change()

Rf = Rf_Weekly.mean()

# find the max Sharpe Ratio
SharpeRatio = np.divide(np.subtract(R_p,Rf),S_p)

maxSR =  SharpeRatio.max()
maxpos = SharpeRatio.argmax()


TangentRtn = R_p[maxpos]
TangentSigma = S_p[maxpos]
TangentPortfolio = W_p[maxpos]


# Maximize utility
A = 5
myw = (TangentRtn-Rf)/A/TangentSigma**2

ww = myw*TangentPortfolio
wf = 1-ww.sum()


R_opt = myw*(TangentRtn-Rf)+Rf
Sigma_opt = myw*TangentSigma
Utility = R_opt-A/2*Sigma_opt**2


# Capital Allocation Line (CAL)
sig_max = 0.06
sig_min = 0.00
dsig = 0.001
Nsig = int((sig_max-sig_min)/dsig)+1

mySigma = np.linspace(sig_min, sig_max, num=Nsig)

myr = Rf + maxSR*mySigma



plt.plot(Sigma, Rtn, 'o', c='k', markersize=5, label='stocks')
plt.plot(S_p, R_p, '-r', lw=2, label='efficient frontier')
plt.plot(mySigma, myr, '-b', lw=2, label='capital allocation line')
plt.plot(TangentSigma, TangentRtn, 'o', c='g', markersize=5, label='tangent portfolio')
plt.legend(loc='best')
plt.title('Efficient Frontier', fontsize=16)
plt.xlabel('Risk', fontsize=12)
plt.ylabel('Weekly return', fontsize=12)
plt.grid(True, axis='both')



