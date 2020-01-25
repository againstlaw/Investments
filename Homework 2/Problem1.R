
# par value of bond
ParValue=100

# Spot Rate (annual compounding)
r1=0.05
r2=0.055
r3=0.06
r4=0.063


# (a) A zero-coupon bond with 3 years to maturity.
rc1=0
PV1=ParValue/(1+r3)^3


# (b) A bond with coupon rate 6% and 2 years to maturity.
rc2=0.06   # coupon interest
coupon=ParValue*rc2
PV2=coupon/(1+r1)+(ParValue+coupon)/(1+r2)^2


# (c) A bond with coupon rate 8% and 4 years to maturity.
rc3=0.08   # coupon interest
coupon=ParValue*rc3
PV3=coupon/(1+r1)+coupon/(1+r2)^2+coupon/(1+r3)^3+(ParValue+coupon)/(1+r4)^4


