
# Problem Set 6 Solution
# mysoln is a list to store your answers

# Cohort #2   Group #2
mysoln = list(student = c("Georgios Terzakis", "Yue Yu", "Xiaoqing Lu", "Chong Cao"))


# Get stock data from Yahoo Finance.
# Intel and Microsoft (12/29/1989 - 9/28/2018)

#install.packages("quantmod")

library(quantmod)

getSymbols(c("INTC","MSFT"), src = "yahoo", from = "1989-12-29", to = "2018-09-28")

stocks = as.xts(data.frame(INTC = INTC[, "INTC.Adjusted"], MSFT = MSFT[, "MSFT.Adjusted"]))
head(stocks)


plot(as.zoo(stocks), screens = 1, col = c("red","blue"),
     main = "MSFT & INTC", xlab = "Date", ylab = "Adjusted Stock Price")

legend("topleft", legend=c("Intel", "Microsoft"), 
       lty=c(1,1), col=c("red", "blue"), lwd=c(2,2), cex=1, bty="n")


# Construct weekly simple total returns from the price data.
# To include dividends.
x = weeklyReturn(Ad(INTC))
Intel.avg = mean(x)
Intel.std = sd(x)

y = weeklyReturn(Ad(MSFT))
Microsoft.avg = mean(y)
Microsoft.std = sd(y)

# To annualize the mean and volatility.
Intel.Annual.avg = Intel.avg*52
Intel.Annual.std = Intel.std*sqrt(52)

Microsoft.Annual.avg = Microsoft.avg*52
Microsoft.Annual.std = Microsoft.std*sqrt(52)


StockReturn = as.xts(data.frame(x, y))
colnames(StockReturn) = c("INTC.return", "MSFT.return")
head(StockReturn)

plot(as.zoo(StockReturn), screens = 1, col = c("red","blue"), 
     main = "Weekly return", xlab = "Date", ylab = "weekly return")

legend("topleft", legend=c("Intel", "Microsoft"), 
       lty=c(1,1), col=c("red", "blue"), lwd=c(2,2), cex=1, bty="n")


mysoln[["Q1"]] = list(Intel.Annual.avg=Intel.Annual.avg, Intel.Annual.std=Intel.Annual.std, Microsoft.Annual.avg=Microsoft.Annual.avg, Microsoft.Annual.std=Microsoft.Annual.std)



# Question 2
# How will you allocate your capital between the risk-free asset and Intel?
Rf=0.01    # risk-free interest
A = 4      # level of risk aversion
Rr = Intel.Annual.avg
Vr = Intel.Annual.std^2
w = (Rr-Rf)/A/Vr

# expected return
R = w*(Rr-Rf)+Rf

# volatility of the portfolio
Sigma = w*Intel.Annual.std


# the risk-free asset and Microsoft
Rr2 = Microsoft.Annual.avg
Vr2 = Microsoft.Annual.std^2
w2 = (Rr2-Rf)/A/Vr2

# expected return
R2 = w2*(Rr2-Rf)+Rf

# volatility of the portfolio
Sigma2 = w2*Microsoft.Annual.std


mysoln[["Q2"]] = list(Intel=w, Return=R, Std.Dev=Sigma, Microsoft=w2, Return=R2, Std.Dev=Sigma2)


# Question 4
# Construct the mean-variance frontier for the Intel-Microsoft combination.
rho = as.numeric(cor(x,y))

w.Intel = seq(0,1,by=0.01)
R.portfolio = w.Intel*Intel.Annual.avg + (1-w.Intel)*Microsoft.Annual.avg
Sigma.portfolio = sqrt(w.Intel^2*Intel.Annual.std^2 + (1-w.Intel)^2*Microsoft.Annual.std^2 + 2*w.Intel*(1-w.Intel)*rho*Intel.Annual.std*Microsoft.Annual.std)

plot(Sigma.portfolio, R.portfolio, type="l", lty=1, lwd=2, col = "blue", 
     main = "Mean-Variance Optimization & Portfolio Frontier",
     xlab = "Standard Deviation", ylab = "Expected Return")

# Indicate the minimum-variance portfolio
p.minvar = which.min(Sigma.portfolio)
Sigma.minvar = Sigma.portfolio[p.minvar]
R.minvar = R.portfolio[p.minvar]


# return my solution
mysoln

