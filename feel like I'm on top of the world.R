
d$xml <- paste0("http://data.fcc.gov/api/block/2010/find?latitude=", 
                 d$latitude, "&longitude=", d$longitude)

d$parse <- vector(length=nrow(d))
for (i in 57965:nrow(d)){
  d$parse[i] <- readLines(d$xml[i])
}

i <- 87965
