library(quantmod)
library(xts)
library(tseries)
library(nortest)
library(forecast)

#2009/01/01 to 2020/12/31
getSymbols("^GSPC", from = '2009-01-01',
           to = "2020-12-31",warnings = FALSE,
           auto.assign = TRUE)
View(GSPC)
plot(log(GSPC$GSPC.Adjusted))
prices = GSPC$GSPC.Adjusted
dt =index(GSPC)
sp500 = xts(prices,dt)
plot(sp500,main = "")
title(main="S&P500 Time Series", xlab = "Time", ylab = "Adj Close price")
#test = log(GSPC$GSPC.Adjusted)
#plot(test)

View(GSPC)
class(GSPC) # check what class the data are
names(GSPC) # get column (header) names
coredata(GSPC) # what are the core data (prices)
 # time data

#creating a time series

####(ii) session 2 in class solution
#lret = diff(log(sp500))
#plot(lret)
#or
lret = quantmod::periodReturn(sp500,period="daily", type="log")
lret = lret[-1,]
#main_title = "S&P500 Returns"
plot(lret,main ="", lty = "solid")
title(main="S&P500 Returns",xlab="Time",ylab="Log Returns",)

#sp500_sds <- rollapply(lret, width = 7, FUN = sd, by = 2, align = "right")
#sp500_sds <- na.omit(sp500_sds)
#line(sp500_sds,col="green")

####(iii)
#lret = na.omit(lret)
View(lret)
#summary(lret2)
#View(lret2)
par(mfrow=c(1,2)) 
acf(lret,main = "ACF") #confirm the lag
pacf(lret,main = "PACF")


###(iv)
Box.test(lret, type = "Ljung-Box")
summary(sp500)

###(v)stationarity
adf.test(lret)
#adf.test(lret2,alternative = c("stationary"))
#adf.test(lret2,alternative = c("explosive"))

tseries::kpss.test(lret,null ="Trend")

###(vi)Shapiro–Francia test
sf.test(lret2)
####session 4
shapiro.test(as.vector(lret))
?shapiro.test()
count(lret)





m <-auto.arima(lret)
m
checkresiduals(m)
NewFit1 =  arima(lret, order = c(6, 0, 2))
n
checkresiduals(n)

confint(n, level = 0.98)



confint(m, level = 0.98)

acf(ts(m$residuals))
pacf(ts(m$residuals))

mforecast = forecast(m,level = c(95),h=10)
mforecast
plot(mforecast)

Box.test(mforecast$residuals,lag = 5, type = "Ljung-Box")
Box.test(mforecast$residuals,lag = 10, type = "Ljung-Box")
Box.test(mforecast$residuals,lag = 15, type = "Ljung-Box")
checkresiduals(m)
View(lret)

View(lret1)

NewFit <- arima(lret, order = c(4, 0, 4), fixed = c(NA,NA,NA,NA,0,NA,NA,NA,NA))
NewFit
checkresiduals(NewFit)
confint(NewFit,level = 0.98)
res <- resid(NewFit)
res
Box.test(res, type = "Ljung-Box")
checkresiduals(NewFit)
#box test of the old fit
res2 <- resid(m)
Box.test(res2, type = "Ljung-Box")

x<-arima(lret,order = c(6,0,2))
confint(x,level = 0.98)
checkresiduals(x)
NewFit <- arima(lret, order = c(6, 0, 2), fixed = c(NA,NA,0,0,0,NA,NA,NA,NA))
NewFit
checkresiduals(NewFit)
mean(x$residuals)



qqnorm(lret) qqline(lret)



n = arima(sp500, order = c(6, 1, 2))
n
checkresiduals(n)
confint(n,level = 0.98)
NewFit <- arima(lret, order = c(6, 0, 2), fixed = c(NA,NA,0,0,0,NA,NA,NA,NA))

checkresiduals(NewFit)
