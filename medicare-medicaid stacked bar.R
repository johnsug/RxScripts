
## using data from: http://www.cms.gov/Outreach-and-Education/Medicare-Learning-Network-MLN/MLNProducts/downloads/Medicare_Beneficiaries_Dual_Eligibles_At_a_Glance.pdf

# libraries
library(ggplot2)
library(plyr)

# package data
d <- data.frame(Program=c(rep('1',100), rep('2',20), rep('3',15), rep('4',200)), Status=c(rep('Low',135), rep('Disabled',200)))
revalue(d$Program, c("1"="QMB", "2"="SLMB", "3"="QI", "4"="QDWI"))

# plot
ggplot(d, aes(Status, fill=Program)) + geom_bar() + coord_flip()

