

# Par Value of bond.
ParValue=100

# 1-year zero-coupon Bond A
Price_A=95.238

# To find the 1-year spot rate r1
# APR with annual compounding.
f = function(x) Price_A-ParValue/(1+x)
rA = uniroot(f, c(0, 1), tol=0.0001)
r1 = rA$root


# 2-year coupon Bond B
Price_B=98.438

# Coupon payments are annual.
rcB=0.05
couponB=ParValue*rcB

# To find the 2-year spot rate r2
# APR with annual compounding.
ff = function(x) Price_B-couponB/(1+r1)-(ParValue+couponB)/(1+x)^2
rB = uniroot(ff, c(0, 1), tol=0.0001)
r2 = rB$root


# 2-year coupon Bond C
rcC=0.07
couponC=ParValue*rcC
Price_C=couponC/(1+r1)+(ParValue+couponC)/(1+r2)^2
