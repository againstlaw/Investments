
library(quantmod)

getSymbols(c("MSFT","INTC","LUV","MCD","JNJ"), src = "yahoo", from = "1989-12-29", to = "2018-09-28")

stocks = as.xts(data.frame( MSFT = MSFT[, "MSFT.Adjusted"], INTC = INTC[, "INTC.Adjusted"], LUV = LUV[, "LUV.Adjusted"], 
                            MCD = MCD[, "MCD.Adjusted"], JNJ = JNJ[, "JNJ.Adjusted"]))
head(stocks)


plot(as.zoo(stocks), screens = 1, col = c("black","red","blue","purple","green"),
     main = "MSFT & INTC & LUV & MCD & JNJ", xlab = "Date", ylab = "Adjusted Stock Price")

legend("topleft", legend=c("Microsoft","Intel","Southwest","McDonald's","Johnson & Johnson"), 
       lty=c(1,1), col=c("black","red","blue","purple","green"), lwd=c(2,2), cex=1, bty="n")


# return
r1 = dailyReturn(Ad(MSFT))
r2 = dailyReturn(Ad(INTC))
r3 = dailyReturn(Ad(LUV))
r4 = dailyReturn(Ad(MCD))
r5 = dailyReturn(Ad(JNJ))

return.data=merge(r1,r2,r3,r4,r5)
colnames(return.data) = c("MSFT","INTC","LUV","MCD","JNJ")

# Load the data
df <- read.csv( "FamaFrench.csv", header = TRUE )
FF=df[17088:24331, c(1,2,5)]
colnames(FF) = c("Date", "Mkt.Rf", "Rf")

data = data.frame(return.data, FF[,c(2,3)])

# as.numeric
# as.character
data$MSFT = as.numeric(data$MSFT)
data$INTC = as.numeric(data$INTC)
data$LUV = as.numeric(data$LUV)
data$MCD = as.numeric(data$MCD)
data$JNJ = as.numeric(data$JNJ)
data$Mkt.Rf=as.numeric(as.character(data$Mkt.Rf))/100
data$Rf=as.numeric(as.character(data$Rf))/100


# regress excess stock returns on excess market returns
m1 = lm(formula = (MSFT-Rf) ~ Mkt.Rf, data = data)
m2 = lm(formula = (INTC-Rf) ~ Mkt.Rf, data = data)
m3 = lm(formula = (LUV-Rf) ~ Mkt.Rf, data = data)
m4 = lm(formula = (MCD-Rf) ~ Mkt.Rf, data = data)
m5 = lm(formula = (JNJ-Rf) ~ Mkt.Rf, data = data)

summary(m1)
summary(m2)
summary(m3)
summary(m4)
summary(m5)


# Yearly return
Microsoft.avg.Annual = mean(weeklyReturn(Ad(MSFT)))*52
Intel.avg.Annual = mean(weeklyReturn(Ad(INTC)))*52
Southwest.avg.Annual = mean(weeklyReturn(Ad(LUV)))*52
McDonald.avg.Annual = mean(weeklyReturn(Ad(MCD)))*52
Johnson.avg.Annual = mean(weeklyReturn(Ad(JNJ)))*52
