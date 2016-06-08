
library(ggplot2)

# sample data
year <- 1:10
sales <- c(400, 605, 771, 1123, 1451, 1897, 2541, 3233, 3379, 5001)
d <- data.frame(year, sales)

#### how to forecast ############################################################################
## two steps:
# 1. use xlim to extend the range
# 2. use the fullrange=TRUE statement in the stat_smooth function

# linear plot
p <- ggplot(data=d, aes(x=year, y=sales)) + geom_point() + xlim(1,12)
p <- p + stat_smooth(method="lm", formula=y~x, fill="red", alpha=0.2, fullrange=TRUE)
p

#### different models ########################################################################### 

# exponential plot
p <- ggplot(data=d, aes(x=year, y=sales)) + geom_point() + xlim(1,12)
p <- p + stat_smooth(method="lm", formula=y~exp(x), fill="orange", alpha=0.2, fullrange=TRUE)
p

# log plot
p <- ggplot(data=d, aes(x=year, y=sales)) + geom_point() + xlim(1,12)
p <- p + stat_smooth(method="lm", formula=y~log(x), fill="yellow", alpha=0.2, fullrange=TRUE)
p

# quadratic plot
p <- ggplot(data=d, aes(x=year, y=sales)) + geom_point() + xlim(1,12)
p <- p + stat_smooth(method="lm", formula=y ~ poly(x, 2), fill="green", alpha=0.2, fullrange=TRUE)
p

# cubic plot
p <- ggplot(data=d, aes(x=year, y=sales)) + geom_point() + xlim(1,12)
p <- p + stat_smooth(method="lm", formula=y ~ poly(x, 3), fill="purple", alpha=0.2, fullrange=TRUE)
p


### other stat_smotth methods to try ############################################################
# glm
# loess ### cannot extrapolate w/ loess




### pt 2 ########################################################################################

## import data
dat <- read.csv("storage_tier1.csv", header=TRUE)
dat$Date <- as.character(dat$Date)
dat$Date <- as.Date(dat$Date, "%m/%d/%Y")

## forecast
library(ggplot2)
g <- ggplot(data=dat, aes(x=Date, y=Usable_TB)) + geom_point() + labs(y="Usable TBs", title="GGPlot Forecast") +
      stat_smooth(method="lm", formula=y ~ poly(x, 2), fill="green", alpha=0.2, fullrange=TRUE) + 
      scale_x_date(name='Date', breaks='6 months', minor_breaks='1 months',labels=date_format("%b-%y"), limits = as.Date(c('2012-01-01', '2015-01-01')))
 
## print
g

## ggplot results table
tbl <- ggplot_build(g)$data[[2]]
tbl
