
## taken from the following blog post: http://rud.is/b/2015/03/18/making-waffle-charts-in-r-with-the-new-waffle-package/
## see also "swap out small boxes for icons": http://rud.is/b/2015/03/26/pre-cran-waffle-update-isotype-pictograms/

library(devtools)
install_github("waffle", "hrbrmstr")
library(waffle)

savings <- c(`Mortgage ($84,911)`=84911, `Auto and tuition loans ($14,414)`=14414, 
             `Home equity loans ($10,062)`=10062, `Credit Cards ($2,565)`=2565)
waffle(savings/1000, rows=8, size=0.5, 
       title="Average Household Spending Each Year", 
       xlab="1 square == $1000")
