
# problem 2

C=500*0.1

n=3

T=10

r=0.05

t=1:T

PV = 0

for (val in t) {
  PV = PV + C/(1+r)^(n*val)
}

