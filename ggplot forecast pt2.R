
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

