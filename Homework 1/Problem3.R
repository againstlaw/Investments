
# (a) Compute how much money you will have saved at the end of the 35th year.

r=0.04

C=200000*0.3

T=35

n=0:(T-1)

FV=sum(C*(1+r)^n)


# Loop style

val=0

for(i in 1:T) {
  val = val + C*(1+r)^(i-1)
}



# (b) What is the amount you can consume during each of your retirement years?

PV = FV

TT = 20

CC = PV*r/(1-1/(1+r)^TT)

