

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from datetime import datetime


# S&P500 value-weighted index with dividends (vwretd)
# daily returns

df = pd.read_table('p5-sp500.csv', header=0, sep=',', index_col=0)

df.index=pd.to_datetime(df.index, format='%Y%m%d')

ret = df.vwretd


# daily
myArithmetric_avg = ret.mean()

myGeometric_avg = (ret+1).prod()**(1/len(ret))-1


# daily price
Price = (1+ret).cumprod()


# select prices at the end of each month
Price_Monthly = Price.groupby(by=[Price.index.year, Price.index.month]).tail(1)

# business dates at the end of each month
dates_Monthly = Price_Monthly.index

# monthly return
ret_Monthly = Price_Monthly.pct_change()



# select prices at the end of each year
Price_Yearly = Price.groupby(by=[Price.index.year]).tail(1)

# business dates at the end of each year
dates_Yearly = Price_Yearly.index

# yearly return
ret_Yearly = Price_Yearly.pct_change()


# 5-year returns
I=[]
for i in range(len(Price_Yearly)):
    if i%5==0:
        I.append(i)

Price_Five_Yearly = Price_Yearly[I]

ret_Five_Yearly = Price_Five_Yearly.pct_change()





def ArithmetricAnnual(returns,period):
    returns = returns.dropna()
    if period=='day':
        return returns.mean()*252
    elif period=='month':
        return returns.mean()*12
    elif period=='quarter':
        return returns.mean()*4
    elif period=='year':
        return returns.mean()
    else:
        raise Exception("Wrong period")




def GeometricAnnual(returns,period):
    returns = returns.dropna()
    if period=='day':
        return((1+returns).prod()**(252/len(returns))-1)
    elif period=='month':
        return((1+returns).prod()**(12/len(returns))-1)
    elif period=='quarter':
        return((1+returns).prod()**(4/len(returns))-1)
    elif period=='year':
        return((1+returns).prod()**(1/len(returns))-1)
    else:
        raise Exception("Wrong period")




print("Daily returns:")

Arithmetric_avg = ArithmetricAnnual(ret,'day')
print(Arithmetric_avg)


Geometric_avg = GeometricAnnual(ret,'day')
print(Geometric_avg)


print("Monthly returns:")

Arithmetric_avg_Monthly = ArithmetricAnnual(ret_Monthly,'month')
print(Arithmetric_avg_Monthly)


Geometric_avg_Monthly = GeometricAnnual(ret_Monthly,'month')
print(Geometric_avg_Monthly)


print("Yearly returns:")

Arithmetric_avg_Yearly = ArithmetricAnnual(ret_Yearly,'year')
print(Arithmetric_avg_Yearly)


Geometric_avg_Yearly = GeometricAnnual(ret_Yearly,'year')
print(Geometric_avg_Yearly)


print("Five-Yearly returns:")

Arithmetric_avg_Five_Yearly = ret_Five_Yearly.mean()/5
print(Arithmetric_avg_Five_Yearly)


Geometric_avg_Five_Yearly = (1+ret_Five_Yearly).prod()**(1/5/len(ret_Five_Yearly))-1
print(Geometric_avg_Five_Yearly)



fig, axes = plt.subplots(3,1, figsize=(10,7), sharex=True)

axes[0].plot(ret, color='k', lw=2, label='daily')
axes[0].set_title('Daily returns', fontsize=12)

axes[1].plot(ret_Monthly, color='r', lw=2, label='monthly')
axes[1].set_title('Monthly returns', fontsize=12)

axes[2].plot(ret_Yearly, color='b', lw=2, label='yearly')
axes[2].set_title('Yearly returns', fontsize=12)

axes[-1].set_xlabel('Date', fontsize=12)

fig.suptitle('S&P500 vwretd', fontsize=16)


