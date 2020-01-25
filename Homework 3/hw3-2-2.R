# Problem Set 3 Solution
# mysoln is a list to store your answers

# Cohort #2   Group #2
mysoln = list(student = c("Georgios Terzakis", "Yue Yu", "Xiaoqing Lu", "Chong Cao"))


# 1

# your intermediary code to get your answers here

# par value of bond
ParValue=100

# Spot Rate (annual compounding)
r1=0.05
r2=0.055
r3=0.065

# 3-year bond with annual coupon rate 10%
rc=0.1
coupon=ParValue*rc
t=c(1,2,3)

# To calculate bond price
cashflow=c(coupon, coupon, ParValue+coupon)
discount=c(1/(1+r1), 1/(1+r2)^2, 1/(1+r3)^3)
price=sum(cashflow*discount)

# Yield to Maturity (YTM)
# f = function(x) Price-coupon/(1+x)-coupon/(1+x)^2-(ParValue+coupon)/(1+x)^3
f = function(x) {
  cash=c(coupon, coupon, ParValue+coupon)
  disc=c(1/(1+x), 1/(1+x)^2, 1/(1+x)^3)
  price-sum(cash*disc)
}
r = uniroot(f, c(0, 1), tol=0.0001)
ytm = r$root


discfac=c(1/(1+ytm), 1/(1+ytm)^2, 1/(1+ytm)^3)    # discount factor in terms of ytm
w=cashflow*discfac/Price    # weight
D=sum(t*w)    # duration


# forward rates
r12=(1+r2)^2/(1+r1)-1           # between years 1 and 2
r13=sqrt((1+r3)^3/(1+r1))-1     # between years 1 and 3
r23=(1+r3)^3/(1+r2)^2-1         # between years 2 and 3


# 3-year return
# reinvest coupon with forward rates
Total=coupon*(1+r13)^2+coupon*(1+r23)+coupon+ParValue
return.3yr=(Total-price)/price

return.annual=(Total/price)^(1/3)-1    # APR

# save down your final answers for part a, b, and c
a = c(price, ytm)
b = c(r12,r13,r23)
c = return.3yr

# add answers to list for "Q1"
mysoln[["Q1"]] = list(a=a, b=b, c=c)



# 2
# put a and c in pdf

r.1yr=0.06
r.3yr=0.07

# Create function to calculate forward rate
f = function(x) (1+r.1yr)*(1+x)^2-(1+r.3yr)^3
r = uniroot(f, c(0, 1), tol=0.0001)
b = r$root

cash=1000000*(1+b)^2
PV=1000000*(1+b)^2/(1+r.3yr)^3

mysoln[["Q2"]] = list(b=b)


# 3

# your intermediary code to get your answers here

# Bond A is a 5-year bond with a 1% annual coupon.
rcA=0.01
couponA=ParValue*rcA
TA=5

# Bond B is a 10-year bond with a 1% annual coupon.
rcB=0.01
couponB=ParValue*rcB
TB=10

# Bond C is a 5-year bond with a 4% annual coupon.
rcC=0.04
couponC=ParValue*rcC
TC=5

# Bond D is a 10-year bond with a 4% annual coupon.
rcD=0.04
couponD=ParValue*rcD
TD=10

# Yield to Maturity (YTM)
ytm=0.035

# Create function to calculate bond price
f = function(rc,T,r) {
  val=0
  N=T*2
  coupon=ParValue*rc/2
  for(i in 1:N) {
    val = val + coupon/(1+r/2)^i
  }
  val=val+ParValue/(1+r/2)^N
}

PriceA=f(rcA,TA,ytm)
PriceB=f(rcB,TB,ytm)
PriceC=f(rcC,TC,ytm)
PriceD=f(rcD,TD,ytm)

b = c(PriceA,PriceB,PriceC,PriceD)     #(Bond A, Bond B, Bond C, Bond D)


# Suppose the yield increases to 3.8% from 3.5%.
ytm2=0.038

PriceA2=f(rcA,TA,ytm2)
PriceB2=f(rcB,TB,ytm2)
PriceC2=f(rcC,TC,ytm2)
PriceD2=f(rcD,TD,ytm2)

c.prices = c(PriceA2,PriceB2,PriceC2,PriceD2)     #(Bond A, Bond B, Bond C, Bond D)
c.changes = (c.prices-b)/b    #(Bond A % Chg, Bond B % Chg, Bond C % Chg, Bond D % Chg) in decimal form


# Suppose the yield decreases to 3.2% from 3.5%.
ytm3=0.032

PriceA3=f(rcA,TA,ytm3)
PriceB3=f(rcB,TB,ytm3)
PriceC3=f(rcC,TC,ytm3)
PriceD3=f(rcD,TD,ytm3)

d.prices = c(PriceA3,PriceB3,PriceC3,PriceD3)    #(Bond A, Bond B, Bond C, Bond D)
d.changes = (d.prices-b)/b    #(Bond A % Chg, Bond B % Chg, Bond C % Chg, Bond D % Chg) in decimal form


# duration
# Create function to calculate bond duration
ff = function(rc,T,r) {
  N=T*2
  coupon=ParValue*rc/2   # semiannual coupon
  cashflow=numeric(N)+coupon
  cashflow[N]=cashflow[N]+ParValue
  discount=numeric(N)
  t=numeric(N)
  for(i in 1:N) {
    discount[i]=1/(1+r/2)^i
    t[i]=i*0.5
  }
  Price=sum(cashflow*discount)
  w=cashflow*discount/Price    # weight
  D=sum(w*t)
}

DuraA=ff(rcA,TA,ytm)
DuraB=ff(rcB,TB,ytm)
DuraC=ff(rcC,TC,ytm)
DuraD=ff(rcD,TD,ytm)

e = c(DuraA,DuraB,DuraC,DuraD)    #(Bond A duration, Bond B duration, Bond C duration, Bond D duration)
yu=ytm2-ytm
yd=ytm3-ytm

eu=-e*yu     # price changes for 3.0->3.5 yld chg
ed=-e*yd     # price changes for 3.0->2.5 yld chg

# save down your final answers for part b,c,d,and e (a and f in PDF writeup)
#a = "Put in PDF Write Up"
#f = "Put in PDF Write up" 

# add answers to list for "Q3"
mysoln[["Q3"]] = list(#a=a, put in PDF writeup only
  b=b, 
  c.pric = c.prices, 
  c.chg = c.changes, #changes are percent changes in decimal
  d.pric = d.prices, 
  d.chg = d.changes, #changes are percent changes in decimal
  e = e,
  eu = eu,
  ed = ed)
#f = f put in PDF writeup only



# 4

# your intermediary code to get your answers here

# (a)
# hedging portfolio
# x units of bond A, y units of bond B, z units of bond C
# the same cash flow with the 31-year custom-made bond
# 0*x+4*y+6*z=0
# 104y+106z=1 million
# 100*x=2 million
# AX=B
A=matrix(c(0, 4, 6, 0, 104, 106, 100, 0, 0), nr=3, byrow=TRUE)
B=matrix(c(0, 1000000, 2000000), nr=3)

result=solve(A,B)

bondA.weight=result[1]
bondB.weight=result[2]
bondC.weight=result[3]


# (b)
r=0.06
t=c(30,31)
cashflow=c(1000000, 2000000)
discount=c(1/(1+r)^30, 1/(1+r)^31)
Price=sum(cashflow*discount) # bond price
w=cashflow*discount/Price    # weight
D=sum(w*t)   # duration

# par value of bond
ParValue=100

# zero-coupon bond
Price.10yr=ParValue/(1+r)^10
Price.15yr=ParValue/(1+r)^15

# Macaulay duration of a zero-coupon bond is equal to the time to maturity of the bond.
D.10yr=10
D.15yr=15

# same market value:   x*Price.10yr+y*Price.15yr=Price
# same duration
AA=matrix(c(Price.10yr, Price.15yr, Price.10yr/Price*D.10yr, Price.15yr/Price*D.15yr), nr=2, byrow=TRUE)
BB=matrix(c(Price, D), nr=2)

result2=solve(AA,BB)

bond.10yr.weight=result2[1]
bond.15yr.weight=result2[2]


# answers
# Note: Remember to add conclusions in write-up
a = c(bondA.weight, bondB.weight, bondC.weight)
b = c(bond.10yr.weight, bond.15yr.weight)

#c = "Put in PDF writeup"
#d = "Put in PDF writeup"

# add answers to list for "Q4"
mysoln[["Q4"]] =  list(a=a, b=b) #c and d in writeup


# return my solution
mysoln

