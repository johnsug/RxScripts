### loads the Data Mining with R (DMwR) package, and others needed for the chapter
library(DMwR)
library(xts)
library(quantmod)

##install.packages('')
update.packages()

### examples of xts objects
data(GSPC)
library(xts)
x1 <- xts(rnorm(100), seq(as.POSIXct('2000-01-01'), len = 100, by = 'day'))
x1[1:5]

x2 <- xts(rnorm(100), seq(as.POSIXct('2000-01-01 13:00'), len = 100, by = 'min'))
x2[1:5]

x3 <- xts(rnorm(3), as.Date(c('2005-01-01', '2005-01-10', '2005-01-12')))
x3

## examples of querying data
x1['2000-01-05']
x1['20000105']
x1['2000-04']
x1['2000-03-27/']
x1['2000-02-26/2000-03-03']
x1['/2000-01-03']

library(quantmod)
getSymbols('~GSPC')


###################################################
### Defining the Prediction Tasks
###################################################
T.ind <- function(quotes,tgt.margin=0.025,n.days=10) {
  v <- apply(HLC(quotes),1,mean)

  r <- matrix(NA,ncol=n.days,nrow=NROW(quotes))
  ## The following statment is wrong in the book (page 109)!
  for(x in 1:n.days) r[,x] <- Next(Delt(Cl(quotes),v,k=x),x)

  x <- apply(r,1,function(x) sum(x[x > tgt.margin | x < -tgt.margin]))
  if (is.xts(quotes)) xts(x,time(quotes)) else x
}

candleChart(last(GSPC,'3 months'),theme='white',TA=NULL)
avgPrice <- function(p) apply(HLC(p),1,mean)
addAvgPrice <- newTA(FUN=avgPrice,col=1,legend='AvgPrice')
addT.ind <- newTA(FUN=T.ind,col='red',legend='tgtRet')
addAvgPrice(on=1)
addT.ind()

myATR <- function(x) ATR(HLC(x))[,'atr']
mySMI <- function(x) SMI(HLC(x))[,'SMI']
myADX <- function(x) ADX(HLC(x))[,'ADX']
myAroon <- function(x) aroon(x[,c('High','Low')])$oscillator
myBB <- function(x) BBands(HLC(x))[,'pctB']
myChaikinVol <- function(x) Delt(chaikinVolatility(x[,c("High","Low")]))[,1]
myCLV <- function(x) EMA(CLV(HLC(x)))[,1]
myEMV <- function(x) EMV(x[,c('High','Low')],x[,'Volume'])[,2]
myMACD <- function(x) MACD(Cl(x))[,2]
myMFI <- function(x) MFI(x[,c("High","Low","Close")], x[,"Volume"])
mySAR <- function(x) SAR(x[,c('High','Close')]) [,1]
myVolat <- function(x) volatility(OHLC(x),calc="garman")[,1]

data.model <- specifyModel(T.ind(GSPC) ~ Delt(Cl(GSPC),k=1) + myATR(GSPC) 
              + myADX(GSPC) + myEMV(GSPC) + myVolat(GSPC) + myMACD(GSPC) 
              + mySAR(GSPC) + runMean(Cl(GSPC))) 

Tdata.train <- as.data.frame(modelData(data.model,
			data.window=c('1970-01-02','1999-12-31')))
Tdata.eval <- na.omit(as.data.frame(modelData(data.model,
			data.window=c('2000-01-01','2009-09-15'))))
Tform <- as.formula('T.ind.GSPC ~ .')


###################################################
### The Prediction Models
###################################################
set.seed(1234)
library(nnet)
norm.data <- scale(Tdata.train)
nn <- nnet(Tform,norm.data[1:1000,],size=10,decay=0.01,maxit=1000,
	linout=T,trace=F)
norm.preds <- predict(nn,norm.data[1001:2000,])
preds <- unscale(norm.preds,norm.data)

















