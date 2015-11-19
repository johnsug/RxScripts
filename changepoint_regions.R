
# simulate data
set.seed(1)
dat=c(rnorm(30,0,1), 
    rnorm(45,1.5,1),
    runif(20,0,1))

## plot
plot(dat, type="l")

## find change points
pts <- cpt.mean(dat, penalty="SIC", method="PELT", class=FALSE)
pts <- c(0, pts)
cols <- c("red", "yellow", "green")

## plot
plot(cpt.mean(dat, penalty="SIC", method="PELT"))

## shade regions
for(i in 1:3){
  polygon(x=pts[c(0,1,1,0)+i], y=c(-1,-1,1,1)*10000000, col=adjustcolor(cols[i], alpha=0.1), border=NA)
}
