
# problem 1

C=10000

T=3

r=0.06


# effective Annual Rate (EAR)
r1=r

FV1=C*(1+r1)^T


# quarterly APR

r2=(1+r/4)^4-1

FV2=C*(1+r2)^T

FV22=C*(1+r/4)^(4*T)


# monthly APR

r3=(1+r/12)^12-1

FV3=C*(1+r3)^T

FV33=C*(1+r/12)^(12*T)
