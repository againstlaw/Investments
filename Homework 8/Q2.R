
# Question #2

# market return
Rm1=0.05
Rm2=0.20

# Aggressive Stock
RnA1=0.02
RnA2=0.32
betaA=(RnA2-RnA1)/(Rm2-Rm1)


# Defensive Stock
RnD1=0.035
RnD2=0.14
betaD=(RnD2-RnD1)/(Rm2-Rm1)


#Rf=(RnA1-betaA*Rm1)/(1-betaA)

#Rf=(RnD1-betaD*Rm1)/(1-betaD)


# if the market return is equally likely to be 5% or 20%
RnA=0.5*(RnA1+RnA2)
RnD=0.5*(RnD1+RnD2)


Rf=0.08
RM=0.5*(0.05+0.2)
slope=RM-Rf

plot(c(betaA,betaD), c(RnA,RnD), type="n", pch=19, col="red", cex=1.5,
     main = "Security Market Line (SML)",
     xlim=c(0.0,2.5), ylim=c(0.0, 0.20), xlab = expression(beta), ylab = "E(R)")

abline(Rf,slope,lwd=2)

points(betaA, RnA, pch=19, col="red", cex=1.5)
text(1.8, 0.15, "Aggressive Stock", col="red", pos=4)
points(betaD, RnD, pch=19, col="blue", cex=1.5)
text(0.5, 0.07, "Defensive Stock", col="blue", pos=4)

# alpha

ERA=Rf+slope*betaA   # CAPM
alphaA=RnA-ERA

ERD=Rf+slope*betaD   # CAPM
alphaD=RnD-ERD


