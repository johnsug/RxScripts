### Insert random NAs in a vector in R
### http://www.r-bloggers.com/insert-random-nas-in-a-vector-in-r/


#create a vector of random values
foo <- rnorm(n=100, mean=20, sd=5)

#randomly choose 15 indices to replace
#this is the step in which I thought I was clever
#because I use which() and %in% in the same line
ind <- which(foo %in% sample(foo, 15))

#now replace those indices in foo with NA
foo[ind]<-NA

#here is our vector with 15 random NAs 
foo



