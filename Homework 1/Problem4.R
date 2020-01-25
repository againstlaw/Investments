
# Problem 4

r = 0.07/12     # monthly rate

T = 12*30       # number of monthly payments

PV = 400000     # mortgage


# (a) What is the effective annual rate?

EAR = (1+r)^12-1


# (b) What is the monthly payment?

C = PV*r/(1-1/(1+r)^T)


# (c) How much do you owe the bank immediately after the twentieth monthly payment?

TT = 20

# quick way
# sum of the remaining cash flows

n = 1:(T-TT)

balance = sum(C/(1+r)^n)

#N=T-TT
#C/r*(1-1/(1+r)^N)

