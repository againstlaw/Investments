

# Par Value of bond.
ParValue=100


# Coupon payments are semiannual.
rcX=0.04
couponX=ParValue*rcX*0.5

# 6-month Bond X
Price_X=100.98

# To find the 6-month spot rate r0.5
# APR with semiannual compounding.
f = function(x) Price_X-(ParValue+couponX)/(1+x/2)
rX = uniroot(f, c(0, 1), tol=0.0001)
r0 = rX$root


# 1-year Bond Y
Price_Y=103.59

# Coupon payments are semiannual.
rcY=0.06
couponY=ParValue*rcY*0.5

# To find the 1-year spot rate r1
# APR with semiannual compounding.
ff = function(x) Price_Y-couponY/(1+r0/2)-(ParValue+couponY)/(1+x/2)^2
rY = uniroot(ff, c(0, 1), tol=0.0001)
r1 = rY$root

