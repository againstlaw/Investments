
# Give an example of a project with no IRR and an example with multiple IRRs.

r = seq(0, 1, 0.0001)

#a = c(-400, 100, 150, 200, 150)     # cash flow, single IRR

a = c(-400, 350, 800, 580, -1450)    # cash flow, multiple IRRs


M=length(r)

N=length(a)

PV = numeric(M)

for(i in 1:M) {
  val=0
  
  for(j in 1:N) {
    val = val + a[j]/(1+r[i])^(j-1)
  }
  
  PV[i] = val
}


# To find the IRR
f = function(x) a[1]+a[2]/(1+x)+a[3]/(1+x)^2+a[4]/(1+x)^3+a[5]/(1+x)^4

IRR1 = uniroot(f, c(0, 0.1), tol=0.0001)

IRR1$root

IRR2 = uniroot(f, c(0.1, 1), tol=0.0001)

IRR2$root


# To plot Present Value vs. Interest Rate
plot(r, PV, type="l", col="red", lwd=3, xlab="r", ylab="PV", main="Multiple IRRs")

abline(h = 0.0, col="black", lwd=3)

text(0.08, -15, "IRR = 7.6%", col="red", pos=4)

text(0.85, -15, "IRR = 81.1%", col="red", pos=2)
