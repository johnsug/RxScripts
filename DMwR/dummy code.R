### creates factors, even if one level is missing from the data
g <- c("m", "m", "m", "m", "m", "m", "m")
g <- factor(g, levels = c("f", "m"))
g
table(g)

### cross tabulation
a <- factor(c("adult", "adult", "adult", "juvenile", "adult", "juvenile", "adult"))
table(a,g)
plot(a,g)

### marginal frequency table
t <- table(a,g)
margin.table(t,1)
margin.table(t,2)
margin.table(t)

### proportional frequency table
prop.table(t,1)
prop.table(t,2)
prop.table(t)

### sequences (see pg. 14)
x <- 1:1000
seq(-4, 1, 0.5)
seq(from = -4, to = 1, by = 0.5)
seq(from = -4, to = 1, length = 11)
seq(length = 11, from = -4, by = 0.5)

### repeating values (1st parameter = value, 2nd = frequency)
rep(5, 10)
rep("hi", 3)
rep(1:2, 3)

### random numbers
rnorm(10)
rnorm(10, mean = 1, sd = 2)
rt(5, df = 10)	## draw from Student t distribution

### subsetting
x <- c(0, -3, 4, -1, 45, 90, -5)
x > 0
x[x > 0]
x[x <= -2 | x > 5]	## | here means "or"
x[x > 40 & x < 100]	## & here means "and"

### indexes
pH <- c(4.5, 7, 7.3, 8.2, 6.3)
names(pH) <- c("area1", "area 2", "mud", "dam", "middle")
pH
pH["mud"]
pH[c("area1", "dam")]

x[] <- 0

### matrices and arrays
x <- round(rnorm(10, mean = 5, sd = 2.5),0)

m <- x
dim(m) <- c(2,5)				## creates matrix
m

m <- matrix(x, 2, 5)
m

m <- matrix(x, 2, 5, byrow = T)	## populates matrix by rows, instead of by columns
m

results <- matrix(c(10, 30, 40, 50, 43, 56, 21, 30), 2, 4, byrow = T)
colnames(results) <- c("Q1", "Q2", "Q3", "Q4")
rownames(results) <- c("store1", "store2")
results
results["store1", ]
results["store1", , drop = F]		## keeps results in a matrix
results["store1", c("Q1", "Q3")]


### lists (pg. 23-26)
my.list <- list(stud.id=033085,
			stud.name = "John",
			stud.marks = c(14.3, 12, 15, 19))
my.list[[1]]
my.list$stud.id
names(my.list)
names(my.list) <- c("id", "name", "marks")
my.list$id
my.list$parents.names <- c("Ken", "Heidi")
length(my.list)

other <- list(age = 19, sex = "male")
lst <- c(my.list, other)
lst

unlist(lst)					## flattens data


### data frames-- note, text values are automatically coded as factors
my.dataset <- data.frame(site = c('A', 'B', 'A', 'A', 'B'),
	season = c('Winter', 'Summer', 'Summer', 'Spring', 'Fall'),
	pH = c(7.4, 6.3, 8.6, 7.2, 8.9))
my.dataset

my.dataset[3]
my.dataset[3,2]
my.dataset$pH
my.dataset[my.dataset$pH > 7, ]
my.dataset[my.dataset$site == "A", "pH"]
my.dataset[my.dataset$season == "Summer", c("site", "pH")]


attach(my.dataset)		## loads my.dataset into system's memory
my.dataset[site=='B', ]
season

detach(my.dataset)
season

subset(my.dataset, pH > 8)	## simple query off dataframe

### manually enter values into data table (spreadsheet-like view)
my.dataset <- edit(my.dataset)
new.data <- edit(data.frame())

### list datasets already available within R
data()
data(USArrests)			## "creates" a data frame, utilizing data already within R

### functions
se <- function(x) {
	v <- var(x)
	n <- length(x)
	return(sqrt(v/n))
}

my.string <- c(45, 2, 3, 5, 76, 2, 4)
se(my.string)

