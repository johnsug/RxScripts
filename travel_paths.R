
## inspired by https://flowingdata.com/2011/05/11/how-to-map-connections-with-great-circles/

## load packages
library(maps)
library(geosphere)

## travel data
td <- data.frame(Lat=c(38.92, 38.79, 38.92, 33.87, 35.71, 38.92, 44.88, 37.78, 40.79, 38.92, 
                       36.12, 42.21, 38.92, 41.98, 39.79, 44.88, 38.92, 40.78, 40.36, 40.78, 38.92), 
                 Long=c(-94.37, -90.51, -94.37, -84.68, -83.51, -94.37, -93.22, -122.42, -111.98, -94.37, 
                        -115.17, -83.35, -94.37, -87.90, -86.15, -93.22, -94.37, -73.87, -74.67, -73.87, -94.37), 
                 stringsAsFactors=FALSE)

## draw map
map("usa", col="#d4ebf2", fill=TRUE, bg="white", lwd=0.05, xlim=c(-130, -65), ylim=c(25, 50), lty=0)
title("12 Month Travel")

## draw travel paths
for (i in 2:nrow(td)) {
  t1 <- d[i-1,]
  t2 <- d[i,]
  gc <- gcIntermediate(c(t1$Long, t1$Lat), c(t2$Long, t2$Lat), n=100, addStartEnd=TRUE)
  lines(gc, lwd=0.8)
}
