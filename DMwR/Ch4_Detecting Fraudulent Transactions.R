### loads the Data Mining with R (DMwR) package, and others needed for the chapter
library(DMwR)

##install.packages('')
update.packages()

data(sales)
head(sales)
summary(sales)
nlevels(sales$ID)
nlevels(sales$Prod)

table(sales$Insp)/nrow(sales) * 100
sales$Uprice <- sales$Val/sales$Quant
summary(sales$Uprice)

## deletes sales where both quantity and price are missing
sales <- sales[-which(is.na(sales$Quant) & is.na(sales$Val)),]

## deletes products where all transactions are unknown
sales <- sales[!sales$Prod %in% c('p2442', 'p2443'), ]

## updates the product factor list b/c we just deleted two products
nlevels(sales$Prod)			## check before rerunning factor function
sales$Prod <- factor(sales$Prod)
nlevels(sales$Prod)			## check after rerunning factor function


###################################################################
### impute data

tPrice <- tapply(sales[sales$Insp != 'fraud','Uprice'],
                 list(sales[sales$Insp != 'fraud','Prod']),
                 median,na.rm=T)

noQuant <- which(is.na(sales$Quant))
sales[noQuant,'Quant'] <- ceiling(sales[noQuant,'Val'] /
                                  tPrice[sales[noQuant,'Prod']])
noVal <- which(is.na(sales$Val))
sales[noVal,'Val'] <- sales[noVal,'Quant'] *
                      tPrice[sales[noVal,'Prod']]

sales$Uprice <- sales$Val/sales$Quant
###################################################################




