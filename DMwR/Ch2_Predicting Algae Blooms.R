### loads the Data Mining with R (DMwR) package
suppressPackageStartupMessages(library(DMwR))

### other packages used in the chapter
suppressPackageStartupMessages(library(car))
suppressPackageStartupMessages(library(lattice))
suppressPackageStartupMessages(library(Hmisc))
##install.packages('')

update.packages()

### imports data for project
algae <- read.table("C:/Users/JS033085/Documents/R Code/DMwR/Ch2_Analysis.txt", 
		header = F, dec = ".", col.names = c("season", "size", "speed", 
				"mxpH", "mn02", "C1", "N03", "NH4", "oP04", "P04", 
				"Chla", "a1", "a2", "a3", "a4", "a5", "a6", "a7"),
		na.strings=c("XXXXXXX"))

eval <- read.table("C:/Users/JS033085/Documents/R Code/DMwR/Ch2_Eval.txt", 
		header = F, dec = ".", col.names = c("season", "size", "speed", 
				"mxpH", "mn02", "C1", "N03", "NH4", "oP04", "P04", 
				"Chla"),
		na.strings=c("XXXXXXX"))

sols <- read.table("C:/Users/JS033085/Documents/R Code/DMwR/Ch2_Sols.txt", 
		header = F, dec = ".", col.names = c("a1", "a2", "a3", "a4", 
				"a5", "a6", "a7"),
		na.strings=c("XXXXXXX"))

### summary statistics and graphs
summary(algae)
describe(algae)
hist(algae$mxpH, prob = T)

### niftier summary graphs
##  note: par allows multiple graphs to be placed in one image
##        rug performs plotting
##        jitter randomly pertrudes, slighty, the original values to 
##          eliminate the possibility of two values occupying the same space 
par(mfrow=c(1,2))			
hist(algae$mxpH, prob = T, xlab="", main="Histogram of maximum  pH value", 
    ylim=0:1)
lines(density(algae$mxpH, na.rm=T))		## na.rm=T hides NAs from calculation
rug(jitter(algae$mxpH))
qqPlot(algae$mxpH, main="Normal QQ plot of maxium pH")
par(mfrow=c(1,1))

### boxplot
boxplot(algae$oP04, ylab = "Orthophosphate (oP04)")
rug(jitter(algae$oP04), side = 2)
abline(h = mean(algae$oP04, na.rm = T), lty = 2)	## lty=2 for dashed line

plot(algae$NH4, xlab="")
abline(h = mean(algae$NH4, na.rm = T), lty = 1)
abline(h = mean(algae$NH4, na.rm = T), lty = 2) + sd(algae$NH4, na.rm = t), lty = 2)
abline(h = median(algae$NH4, na.rm = T), lty = 3)
identify(algae$NH4)				## allows you to mark and inspect values

### pulls up summary information for clicked data points
plot(algae$NH4, xlab = "")
clicked.lines <- identify(algae$NH4)
algae[clicked.lines, ]

algae[algae$NH4 > 19000, ]
algae[!is.na(algae$NH4) & algae$NH4 > 19000, ]		## same as above, but handles NAs

library(lattice)
bwplot(size ~ a1, data = algae, ylab = 'River Size', xlab = 'Algae A1')

library(Hmisc)
bwplot(size ~ a1, data = algae, panel = panel.bpplot, 
	probs = seq(.01, .49, by = .01), datadensity = TRUE,
	ylab = 'River Size', xlab = 'Algae A1')

min02 <- equal.count(na.omit(algae$mn02), number = 4, overlap = .2)
stripplot(season ~ a3 | min02, data=algae[!is.na(algae$mn02), ])
## equal.count() creates a factorized version of continuous variable mn02
## the parameter number sets the desired # of bins
## the parameter overlap sets the boundaries

############# Error handling

### removes data with NAs
data(algae)
algae <- na.omit(algae)

### imputation function within DMwR
data(algae)
algae <- algae[-manyNAs(algae), ]
algae <- centralImputation(algae)

### simple linear regression
data(algae)
algae <- algae[-manyNAs(algae), ]
lm(P04 ~ oP04, data = algae)

#histogram of mxpH conditioned by season
histogram(~mxpH | season, data = algae)

#histogram with more natural season ordering
algae$season <- factor(algae$season, levels = c('spring', 'summer', 
			'autumn', 'winter'))
histogram(~mxpH | season, data = algae)

#other histograms
histogram(~mxpH | size, data = algae)
histogram(~mxpH | size * speed, data = algae)	## multi-tiered histogram
stripplot(size ~ mxpH | speed, data = algae, jitter = T)

### k-th nearest neighbors imputation 
algae <- algae[-manyNAs(algae), ]
algae <- knnImputation(algae, k = 10)		## using mean values
algae <- knnImputation(algae, k = 10, meth = "median")	## median


### multiple linear regression 
data(algae)
algae <- algae[-manyNAs(algae), ]
clean.algae <- knnImputation (algae, k=10)
lm.a1 <- lm(a1 ~ ., data = clean.algae[, 1:12])
# note: 
#	  the dot (.) indicates that we want to use all variables in the data
#	  the data parameter sets the data sample to be used to obtain
#		the model
#
summary(lm.a1)
plot(lm.a1)

anova(lm.a1)			## anova helps decide what to eliminate
lm2.a1 <- update(lm.a1, .~. - season)
# update allows us to perform small changes to an existing linear model

anova(lm.a1, lm2.a1)		## anova also compares two linear models
final.lm <- step(lm.a1)		## performs backward elimination
					## can be modified using 'direction' parameter
summary(final.lm)



### regression trees
library(rpart)
data(algae)
algae <- algae[-manyNAs(algae), ]
rt.a1 <- rpart(a1 ~ ., data = algae[, 1:12])
rt.a1
prettyTree(rt.a1)


### cross-validation comparison
cv.rpart <- function(form, train, test, ...){
	m <- rpartXse(form, train, ...)
	p <- predict(m, test)
	mse <- mean((p-resp(form, test))^2)
	c(nmse = mse/mean((mean(resp(form, train))-resp(form, test))^2))
}

cv.lm <- function(form, train, test, ...){
	m <- lm(form, train, ...)
	p <- predict(m, test)
	p <- ifelse(p < 0, 0, p)
	mse <- mean((p-resp(form, test))^2)
	c(nmse = mse/mean((mean(resp(form, train))-resp(form, test))^2))
}

res <- experimentalComparison(
	c(dataset(a1 ~ ., clean.algae[ ,1:12],'a1')),
	c(variants('cv.lm'),
	 variants('cv.rpart', se=c(0,0.5,1))),
	cvSettings(3,10,1234))
summary(res)
plot(res)

getVariant("cv.rpart.v1", res)











