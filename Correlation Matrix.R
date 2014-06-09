### correlation matrix vignettes: http://cran.r-project.org/web/packages/corrplot/vignettes/corrplot-intro.html

# lists all the datasets in loaded packages
#data()

# loads corrplot package
library(corrplot)


# brings in data
d <- auto
v <- vote
b <- baseball
View(b)


# eliminates variables which are not numeric
d2 <- d[ , -which(names(d) %in% c("Model", "Origin"))]
names(b)
b2 <- b[ , -which(names(b) %in% c("Name", "League", "Team", "Position"))]
#View(b2)


# drops NAs
d3 <- d2[complete.cases(d2 * 0), , drop=FALSE]
#View(d3)
b3 <- b2[complete.cases(b2 * 0), , drop=FALSE]


# creates correlation matrix
c <- cor(d3)
bc <- cor(b3)
#View(c)


# plots correlation matrices
corrplot(c, method = "color")
corrplot(bc, method = "color")
#corrplot.mixed(c, lower = "number", upper = "circle")


# reorders correlation matrix in order to discover patterns
corrplot(c, order = "AOE")
corrplot(c, order = "hclust")
corrplot(c, order = "FPC")
corrplot(c, order = "alphabet")


# "hclust" reordering also allows you to draw specified number of boxes, based on the results of hierarchial clustering
corrplot(c, order = "hclust", addrect = 2)
corrplot(c, order = "hclust", addrect = 3)




