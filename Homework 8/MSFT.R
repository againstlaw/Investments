
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

Microsoft.avg = mean(r1)
Microsoft.std = sd(r1)
Microsoft.avg.Annual = Microsoft.avg * 252
Microsoft.std.Annual = Microsoft.std * sqrt(252)


# Load the data
df <- read.csv( "FamaFrench.csv", header = TRUE )

# read data
FF=df[17088:24331, c(1,2,5)]

colnames(FF) = c("Date", "Mkt.Rf", "Rf")

MSFTdata = data.frame(r1,FF[,c(2,3)])

# as.numeric
# as.character
MSFTdata$daily.returns=as.numeric(MSFTdata$daily.returns)
MSFTdata$Mkt.Rf=as.numeric(as.character(MSFTdata$Mkt.Rf))/100
MSFTdata$Rf=as.numeric(as.character(MSFTdata$Rf))/100

plot(MSFTdata$Mkt.Rf, MSFTdata$daily.returns-(MSFTdata$Rf), type="p", pch=16, col="red", cex=0.5)

# regress excess stock returns on excess market returns
out = lm(formula = (daily.returns-Rf) ~ Mkt.Rf, data = MSFTdata)
abline(out, lwd=2, col="black")
summary(out)



