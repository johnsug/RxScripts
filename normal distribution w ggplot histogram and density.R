library(ggplot2)
library(RColorBrewer)
library(triangle)

# mode function
estimate_mode <- function(x) {
  d <- density(x)
  d$x[which.max(d$y)]
}

plot(mtcars$mpg, mtcars$hp)
abline(lm(hp~mpg, data=mtcars), col="red")


# quick boxplots
draws <- round(rnorm(n=50, 4, 1),2)
states <- sample(state.abb, 7)
states <- sample(states, 50, replace=TRUE)
d <- data.frame(Region=states, Count=draws)
g10 <- ggplot(d, aes(x=Region, y=Count, fill=Region)) + geom_boxplot() + guides(fill=FALSE) + coord_flip()
g10 <- g10 + scale_fill_brewer(palette="RdBu")
g10
png(file="outliers.png", width=800, height=800)
print(g10)
dev.off()


#########################################################################################################
# distributions
n = 1000000

x <- seq(0,5,.05)
num = floor(n/length(x))
rem = n - length(x)*num

norms <- data.frame(obs=1:n, value=rnorm(n,4,4))
bi <- data.frame(obs=1:n, value=c(rnorm(.4*n,-2,3), rnorm(.6*n,12,3)))
lnorm <- data.frame(obs=1:n, value=rlnorm(n,1,.3))
lnorm <- subset(lnorm, value < 10)
wei <- data.frame(obs=1:n, value=rweibull(n,150,1))
wei <- subset(wei, value > .925)
uni <- data.frame(obs=1:n, value=c(rep(x,num), sample(x,rem))) #runif(n,0,5))
tri <- data.frame(obs=1:n, value=rtriangle(n, a=0, b=1))
# hack to make the triangle plot look better
tri[1,2] <- -.5
tri[2,2] <- 1.5

uni[1,2] <- -2
uni[2,2] <- 7

beta[1,2] <- -0.1
beta[2,2] <- 1.1


# create plots


p1 <- ggplot(norms, aes(x=value)) + geom_density(alpha=.2, fill="red") + ggtitle("Normal") + 
  theme(axis.title.x = element_blank(), axis.title.y = element_blank())
p2 <- ggplot(uni, aes(x=value)) + geom_density(alpha=.2, fill="orange") + ggtitle("Uniform") + 
  theme(axis.title.x = element_blank(), axis.title.y = element_blank())
p3 <- ggplot(tri, aes(x=value)) + geom_density(alpha=.2, fill="yellow") + ggtitle("Triangular") + 
  theme(axis.title.x = element_blank(), axis.title.y = element_blank())

p4 <- ggplot(bi, aes(x=value)) + geom_density(alpha=.2, fill="green") + ggtitle("Bi-Modal") + 
  theme(axis.title.x = element_blank(), axis.title.y = element_blank())
p5 <- ggplot(lnorm, aes(x=value)) + geom_density( alpha=.2, fill="blue") + ggtitle("Right Skewed") + 
  theme(axis.title.x = element_blank(), axis.title.y = element_blank())
p6 <- ggplot(wei, aes(x=value)) + geom_density(alpha=.2, fill="purple") + ggtitle("Left Skewed") + 
  theme(axis.title.x = element_blank(), axis.title.y = element_blank())

png(file="shapes.png", height=250, width=700)
print(multiplot(p1, p4, 
                p2, p5, 
                p3, p6,
                cols=3))
dev.off()

################################################################################################################################################

zz <- rpois(100,3)
zz[1] <- 10
zz[2] <- 12
types <- sample(c("whales", "sharks", "shrimp", "fish"), 100, TRUE)
zz <- data.frame(creature=types, score=zz)

g <- ggplot(zz, aes(x=creature, y=score, fill=creature)) + geom_boxplot(alpha=.25) + stat_boxplot(geom ='errorbar') + coord_flip() + 
      xlab("") + ylab("") + guides(fill=FALSE)
g

png(file="outliers.png", height=200, width=600)
print(g)
dev.off()


################################################################################################################################################


# data
norms <- rnorm(n=2000, mean=2, sd=sqrt(2))
g <- ggplot(data.frame(draw=norms), aes(x=draw)) + geom_histogram(binwidth=.5, colour="black", fill="white") + labs(x = NULL, y = NULL)

# mean
g2 <- g + geom_vline(aes(xintercept=mean(norms, na.rm=T)), # Ignore NA values for mean
               color="red", linetype="dashed", size=1.25) + ggtitle("mean")
g2
png(file="mean.png")
print(g2)
dev.off()

# median
g3 <- g + geom_vline(aes(xintercept=median(norms)), color="blue", linetype="dashed", size=1.25) + ggtitle("median")
g3
png(file="median.png")
print(g3)
dev.off()

# mode
g4 <- g + geom_vline(aes(xintercept=estimate_mode(norms)), color="purple", linetype="dashed", size=1.25) + ggtitle("mode")
g4
png(file="mode.png")
print(g4)
dev.off()

# variance
lower.b2 <- mean(norms) - 2*var(norms)
lower.b <- mean(norms) - var(norms)
upper.b <- mean(norms) + var(norms)
upper.b2 <- mean(norms) + 2*var(norms)
g5 <- g + geom_vline(aes(xintercept=lower.b2), color="purple", linetype="dashed", size=1.25) + 
          geom_vline(aes(xintercept=lower.b), color="blue", linetype="dashed", size=1.25) +
          geom_vline(aes(xintercept=mean(norms)), color="lightblue", linetype="dashed", size=1.25) +
          geom_vline(aes(xintercept=upper.b), color="blue", linetype="dashed", size=1.25) +
          geom_vline(aes(xintercept=upper.b2), color="purple", linetype="dashed", size=1.25) + ggtitle("variance")
g5

png(file="var.png")
print(g5)
dev.off()

# more vars
library(reshape)

n = 250000
df <- data.frame(x = rnorm(n, 0, .5), y = rnorm(n, 0, .65), z = rnorm(n, 0, .85))
df.m <- melt(df)
g6 <- ggplot(df.m, aes(x=value, fill=variable)) + geom_density(alpha=.3) + labs(x=NULL, y=NULL) + theme(legend.position="none") + 
        geom_vline(aes(xintercept=0), linetype="dashed")
g6
png(file="vars.png")
print(g6)
dev.off()


# outliers
library(ggplot2)
df <- data.frame(cond = factor( rep(c("A","B"), each=200) ), 
                 rating = c(rnorm(200),rnorm(200, mean=.8)))
df[1,2] <- 3.7
df[3,2] <- 3.5
df[5,2] <- 3.1

g7 <- ggplot(df, aes(x=cond, y=rating, fill=cond)) + geom_boxplot() + guides(fill=FALSE) #+ coord_flip()
png(file="outliers.png")
print(g7)
dev.off()




p <- rpois(n=2000, lambda=2)
n <- rnorm(n=2000, mean=2, sd=sqrt(2))
ln <- rlnorm(n=2000, meanlog=log(2)-0.5*log(2), sdlog=sqrt(log(2)))
c <- rcauchy(n=2000, location=0, scale=.0004)

mean(p)
mean(n)
mean(ln)
mean(c)

var(p)
var(n)
var(ln)
var(c)

df.p <- data.frame(draw=p)
df.n <- data.frame(draw=n)
df.ln <- data.frame(draw=ln)
df.c <- data.frame(draw=c)

ggplot(df.p, aes(x=draw)) + geom_histogram(binwidth=1, colour="black", fill="white") + ggtitle("Draws from Poisson Distribution")
ggplot(df.n, aes(x=draw)) + geom_histogram(binwidth=1, colour="black", fill="white") + ggtitle("Draws from Normal Distribution")
ggplot(df.ln, aes(x=draw)) + geom_histogram(binwidth=1, colour="black", fill="white") + ggtitle("Draws from Lognormal Distribution")
ggplot(df.c, aes(x=draw)) + geom_histogram(binwidth=1, colour="black", fill="white") + ggtitle("Draws from Cauchy Distribution")



c <- log(rcauchy(n=2000, location=0, scale=.0001))
mean(c)
var(c)
df.c <- data.frame(draw=c)
ggplot(df.c, aes(x=draw)) + geom_histogram(binwidth=1, colour="black", fill="white") + ggtitle("Draws from Cauchy Distribution")












# Multiple plot function
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  require(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}
