library(ggplot2)
library(RColorBrewer)

x1 <- 1
x2 <- 1

for (i in 1:rpois(1,100)){
  z <- runif(1)
  if (z < .167) x1[i] <- "John"
    else if (z < .333) x1[i] <- "Katie"
    else if (z < .50) x1[i] <- "Hannah"
    else if (z < .667) x1[i] <- "Adam"
    else if (z < .833) x1[i] <- "Caleb"
    else x1[i] <- "Cecily"
  x2[i] <- sum(rpois(rpois(1,2),15))
}
x1 <- as.factor(x1)
df <- data.frame(name=x1, count=x2)


p <- ggplot(df, aes(x=name, y=count, fill=name)) + 
     geom_boxplot(colour = NA, coef = 0, outlier.colour = NA) +    ## coef = 0 -> no whiskers; outlier.colour = NA -> no outliers
     guides(fill=FALSE) + 
     coord_flip() +
     stat_summary(fun.y=median, colour="red", geom="point", size=4, shape=19, show_guide = FALSE) +
     ggtitle("Whiskerless Boxplots") + xlab("") + ylab("Count")

p <- p + theme(panel.grid.minor.y=element_blank(), panel.grid.major.y=element_blank())
p + scale_fill_brewer(palette="Spectral") + theme(panel.grid.major = element_line(colour = "black", linetype = "dotted", size=1)) + 
                                            theme(panel.grid.minor.x = element_blank())

p + geom_boxplot(colour = "brown", fill = NA, coef=1, outlier.colour = NA)


#############################

year <- c(2002:2013)
cpi <- c(.047, .040, .044, .042, .040, .044, .037, .032, .034, .030, .037, .025)
mmi <- c(.0, .0, .0,   .0,   .0,   .0,   .0,   .078, .073, .069, .063, .054) 
MMI.10.14 <- c(18074, 19393, 20728, 22030, 23215)

df <- data.frame(year, cpi, mmi)




df <- subset(df, df$year > '2008')
df

g <- ggplot(df, aes(x=year, y=cpi)) + geom_line(color="blue", linetype="dotdash")
g + ggplot(df, aes(x=year, y=mmi)) + geom_line(color="red", linetype="dotdash")


dev.copy(png, file = "brew.png")
dev.off()

#############################

p + scale_fill_brewer(palette="Reds")
p + scale_fill_brewer(palette="Oranges")
p + scale_fill_brewer(palette="Greens")
p + scale_fill_brewer(palette="Blues")
p + scale_fill_brewer(palette="Purples")
p + scale_fill_brewer(palette="Greys")

p + scale_fill_brewer(palette="Accent")
p + scale_fill_brewer(palette="Dark2")
p + scale_fill_brewer(palette="Paired")
p + scale_fill_brewer(palette="Pastel1")  ## like
p + scale_fill_brewer(palette="Pastel2")  ## like
p + scale_fill_brewer(palette="Set1")
p + scale_fill_brewer(palette="Set2")
p + scale_fill_brewer(palette="Set3")

p + scale_fill_brewer(palette="YlOrRd")   ## like
p + scale_fill_brewer(palette="YlOrBr")
p + scale_fill_brewer(palette="YlGnBu")   ## like like
p + scale_fill_brewer(palette="YlGn")     ## like
p + scale_fill_brewer(palette="RdPu")
p + scale_fill_brewer(palette="PuRd")
p + scale_fill_brewer(palette="PuBuGn")
p + scale_fill_brewer(palette="PuBu")
p + scale_fill_brewer(palette="OrRd")     ## like
p + scale_fill_brewer(palette="GnBu")     ## like
p + scale_fill_brewer(palette="BuPu")
p + scale_fill_brewer(palette="BuGn")

p + scale_fill_brewer(palette="Spectral") ## really like this one
p + scale_fill_brewer(palette="RdYlGn")   ## like
p + scale_fill_brewer(palette="RdYlBu")   ## like
p + scale_fill_brewer(palette="RdGy")
p + scale_fill_brewer(palette="RdBu")
p + scale_fill_brewer(palette="PuOr")
p + scale_fill_brewer(palette="PRGn")
p + scale_fill_brewer(palette="PiYG")
p + scale_fill_brewer(palette="BrBG")


## see http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/
