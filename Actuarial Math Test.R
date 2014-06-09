# My goal is to make a new math problem for future actuarial hires within Cerner Math
# My "deliverable" will be a large data set to be used to determine medical base rates
# The end product should be a matrix w/ ~5,000,000 rows and the following columns
# 1. member id
# 2. age
# 3. sex
# 4. date of service (include 15 months of data)
# 5. claim amount
# 6. ICD9 code
# 7. claim level (hip, hop, phy, rx??)
# 
# population will be a local manufacturing plant with all 
# Things they should pick up on...
# fraudulent claims (maternity claims for males)
# high level of IP compared to OP/PHY (60-20-20) 
#
# ** update to deliverables:
# table #1 = member id, age (as of 1/1/2014), gender
# table #2 = claims table (15 month experience period, all claims assumed to be completed)
# scrap ICD9 codes (for now...)

# working directory
setwd("M:/Dev/JS xxxxxxxx/Development/")

# ******************************************************************************************************
# ******************************************** Member Table ********************************************
# ******************************************************************************************************

# number of employees to simulate
n <- 20000 + round(runif(1) * 100000)    ## 8500 + 1000 rand ~ 400k claims.  

# initialize vectors
emp.age <- 1
emp.sex <- 1
emp.id <- 1
mf.ratio <- .5 + runif(1,-0.0837,0.0915)

# employee age, gender, and ID
for (i in 1:n){
  # age loop
  emp.age[i] <- 18 + round((if(runif(1) < runif(1, 0.74, 0.81)) {runif(1,0,32)} else {runif(1,32,52)}),0)
  # gender loop
  if (runif(1) > mf.ratio) {emp.sex[i] <- "M"}
    else {emp.sex[i] <- "F"}
  # employee ID
  emp.id[i] <- 2710000000 + (i * 100)
}
#emp.sex <- factor(emp.sex)
#plot(emp.sex)

# simulate random numbers to assign employee tiering
rand.tier <- runif(n)
emp.tier <- 1

# randomly-assigned weights for employee-tiering
w1 = runif(1, .36, .44)
w2 = runif(1, .17, .25)
w3 = runif(1, .09, .13)
#w4 = 1 - (w1 + w2 + w3)  # this is implied

# assigns tier levels
for (i in 1:n){
  if (rand.tier[i] < w1) {emp.tier[i] <- "EE"}
    else if (rand.tier[i] < (w1+w2)) {emp.tier[i] <- "ES"}
    else if (rand.tier[i] < (w1+w2+w3)) {emp.tier[i] <- "EC"}
    else {emp.tier[i] <- "EF"}
}
emp.tier <- factor(emp.tier)
#plot(emp.tier)

# assigns number of dependents
fam.size <- 1:n
for (i in 1:n){
  if (emp.tier[i] == "EE") {fam.size[i] <- 1}
  else if (emp.tier[i] == "ES") {fam.size[i] <- 2}
  else if (emp.tier[i] == "EC") {fam.size[i] <- 2 + rpois(1,0.27)}  ## using poisson just for funsies
  else {fam.size[i] <- 3 + rpois(1,0.41)}
} 

# offset vector for member IDs
off <- 1
for (i in 2:n){
  off[i] <- off[i-1] + fam.size[i-1]
}

# declare blank member ID, age, and gender vectors
mem.id <- 1:sum(fam.size)
mem.age <- 1
mem.sex <- 1
mf.ratio <- .5 + runif(1,-0.0837,0.0915)

# generate member IDs
for (i in 1:n){
  j <- off[i]
  for (k in 1:fam.size[i]){
    mem.id[j] <- emp.id[i] + k
    j <- j + 1}  
}

# generate member ages and genders
for (i in 1:n){
  j <- off[i]
  for (k in 1:fam.size[i]){
    mem.id[j] <- emp.id[i] + k
    # employee
    if (k == 1){
      mem.age[j] <- emp.age[i]
      mem.sex[j] <- emp.sex[i]
    }
    # spouse
      else if (k == 2 && (emp.tier[i] == "ES" | emp.tier[i] == "EF")){
        # takes spouses age and randomly adds/subtracts a few years
        mem.age[j] <- emp.age[i] + round(runif(1, 0, 6),0) * (if (runif(1) < .7) {1} else {-1})
        if (mem.sex[j - 1] == "M") {mem.sex[j] <- "F"}
          else {mem.sex[j] <- "M"}
      }
    # children
      else {
        mem.age[j] <- round(runif(1,0,20),0)
        if (runif(1) > mf.ratio) {mem.sex[j] <- "M"}
          else {mem.sex[j] <- "F"}  
      }
    j <- j + 1}
}

# writes employee tier to data frame
member.table <- data.frame(Member.ID=mem.id, Age=mem.age, Gender=mem.sex)

# ******************************************************************************************************
# ******************************************** Claims Table ********************************************
# ******************************************************************************************************
# build up claims table
# 1. Claim ID 
# 2. Member ID
# 3. Date of Service
# 4. Claim Type (Med/Rx)
# 5. Claim Level (Hip/Hop/Phy or Brand/Generic)
# 6. Claim Amount
#

# set experience period dates
exp.period.begin <- as.Date(c("2023-01-01"))  ## for some reason the dates forumlas were off by 10 years
exp.period.end <- as.Date(c("2024-03-31"))    ## so, in order to get 2013-2014 data, I coded 2023-2024

# initialize claims vectors and weights
claim.id <- 1
claim.mem.id <- 1
claim.dos <- 1
claim.type <- 1
claim.level <- 1
claim <- 1
w1 <- runif(1, .074, .137)  ## HIP weight
w2 <- runif(1, .128, .237)  ## HOP weight
#w3 <- 1 - w1 - w2 ## implied, PHY weight
w4 <- runif(1, .642, .714)  ## Rx brand/generic weight
j <- 1

# build claims table
proc.start <- proc.time()
for (i in 1:length(mem.id)){
  k <- 1
  theta <- sum(rpois(1, 5))
  #if (runif(1) > 0.925) {theta = runif(1)}
  while(k < 450){                                                                             ## 450 ~ 365 days * 1.25 years
    rand.med <- runif(1)
    claim.id[j] <- 1000000 + j
    claim.mem.id[j] <- mem.id[i]
    claim.type[j] <- "Medical"
    # claim type loop
    if (rand.med < w1) {claim.level[j] <- "Inpatient"}
      else if (rand.med < (w1+w2)) {claim.level[j] <- "Outpatient"}
      else {claim.level[j] <- "Physician"}
    # date of service poisson process
    k <- k - round(365/1.25/theta * log(1-runif(1), base = exp(1)),0)
    claim.dos[j] <- exp.period.begin + k
    # claim cost loop
    if (claim.level[j] == "Inpatient"){
      rand.med <- runif(1)
        if (rand.med < 0.91) {claim[j] <- round(25*(1 + runif(1)) + rlnorm(1, 2.1, 3.5),2)}   ## regular HIP
          else {claim[j] <- round(150*(sum(rlnorm(1 + rbinom(1, 2, .25), 4.5, 2.1))),2)}      ## catastrophic HIP
        }
      else if (claim.level[j] == "Outpatient") {claim[j] <- round(295 + rlnorm(1, 1.5, 2.5),2)}
      else {claim[j] <- round(runif(1,.5,1.5)*100,2)}
    j <- j + 1
    # sub-loop for rx claims, assuming pharmacy claims will follow medical visits 60%-ish of the time
    rand.rx <- runif(1)
    if (runif(1) > .417) {
      claim.id[j] <- 1000000 + j
      claim.mem.id[j] <- mem.id[i]
      claim.type[j] <- "Pharmacy"
      # rx level loop
      if (rand.rx < w4) {claim.level[j] <- "Generic"}
        else {claim.level[j] <- "Brand"}
      k <- k + rpois(1, 1.2)
      claim.dos[j] <- as.Date(exp.period.begin + k)    
      # claim cost loop
      if (claim.level[j] == "Brand") {claim[j] <- round(sum(runif(rpois(1,2.3)+1,20,45)),2)}
        else {claim[j] <- round(sum(runif(rpois(1,1.7)+1,15,40)),2)}
      j <- j + 1
    }
    # sub-loop for 2nd rx claim
    rand.rx <- runif(1)
    if (runif(1) > .894) {
      claim.id[j] <- 1000000 + j
      claim.mem.id[j] <- mem.id[i]
      claim.type[j] <- "Pharmacy"
      # rx level loop
      if (rand.rx < w4) {claim.level[j] <- "Generic"}
        else {claim.level[j] <- "Brand"}
      k <- k + rpois(1, 0.94)
      claim.dos[j] <- as.Date(exp.period.begin + k)
      # claim cost loop
      if (claim.level[j] == "Brand") {claim[j] <- round(sum(runif(rpois(1,2.3)+1,20,45)),2)}
        else {claim[j] <- round(sum(runif(rpois(1,1.7)+1,15,40)),2)}
      j <- j + 1
    }
  }
}
proc.end <- proc.time()
proc.end - proc.start

# make sure dates all fit into the experience period
for (i in 1:length(claim.dos)){
  if (claim.dos[i] > exp.period.end) {claim.dos[i] <- exp.period.end + 1}  
}

# format dates
library("date")
claim.dos <- date.mmddyy(claim.dos)

# write claims table
claims.table <- data.frame(Claim.ID=claim.id, Member.ID=claim.mem.id, Date.of.Service=claim.dos, Claim.Type=claim.type, 
                           Claim.Level=claim.level, Claim.Amount=claim)

# drop claims not in experience period
claims.table <- claims.table[claims.table$Date.of.Service != "4/1/2014", ]

# reorder claim IDs after dropping above claims
claims.table$Claim.ID <- 1000000 + seq(1:nrow(claims.table))
head(claims.table)
tail(claims.table)

# build crosstables for descriptive statistics
level.sum <- xtabs(claims.table$Claim.Amount ~ claims.table$Claim.Level)
level.count <- xtabs( ~ claims.table$Claim.Level)
level.mean <- level.sum/level.count
sum.stats <- data.frame(t(rbind(Count=level.count, Cost=round(level.sum,2), Average=round(level.mean,2))))

# med crosstable
med <- subset(sum.stats, rownames(sum.stats) == "Inpatient" | rownames(sum.stats) == "Outpatient" | rownames(sum.stats) == "Physician")
x <- colSums(med)
x[3] <- round(x[2] / x[1],2)
med <- rbind(med, x)
rownames(med) <- c(rownames(med)[1:3], "Total")
med.pct <- 1
for (i in 1:4) med.pct[i] <- med$Cost[i]/med$Cost[4]
med.pct <- round(med.pct * 100,1)
med <- cbind(med, Pct=med.pct)

# rx crosstable
rx <- subset(sum.stats, rownames(sum.stats) == "Generic" | rownames(sum.stats) == "Brand")
x <- colSums(rx)
x[3] <- round(x[2] / x[1],2)
rx <- rbind(rx, x)
rownames(rx) <- c(rownames(rx)[1:2], "Total")
rx.pct <- 1
for (i in 1:3) rx.pct[i] <- rx$Cost[i]/rx$Cost[3]
rx.pct <- round(rx.pct * 100,1)
rx <- cbind(rx, Pct=rx.pct)

# med/rx crosstable
type.sum <- xtabs(claims.table$Claim.Amount ~ claims.table$Claim.Type)
type.count <- xtabs( ~ claims.table$Claim.Type)
type.mean <- type.sum/type.count
med.rx <- data.frame(t(rbind(Count=type.count, Cost=round(type.sum,2), Average=round(type.mean,2))))
x <- colSums(med.rx)
x[3] <- round(x[2] / x[1],2)
med.rx <- rbind(med.rx, x)
rownames(med.rx) <- c(rownames(med.rx)[1:2], "Total")
pmpy <- round(med.rx$Cost/n,2)   ## per member per year
pmpm <- round(pmpy/12,2)        ## per member per month
med.rx <- cbind(med.rx, PMPY=pmpy, PMPM=pmpm)
med.rx.pct <- 1
for (i in 1:3) med.rx.pct[i] <- med.rx$PMPM[i]/med.rx$PMPM[3]
med.rx.pct <- round(med.rx.pct * 100,1)
med.rx <- cbind(med.rx, Pct=med.rx.pct)

# print crosstabs to screen
med
rx
med.rx
n
max(claims.table$Claim.Amount)
plot(claims.table$Claim.Amount)

HIP <- subset(claims.table, Claim.Level == "Inpatient")
HOP <- subset(claims.table, Claim.Level == "Outpatient")
PHY <- subset(claims.table, Claim.Level == "Physician")

plot(HIP$Claim.Amount)
plot(HOP$Claim.Amount)
plot(PHY$Claim.Amount)

plot(claims.table$Claim.Amount)
#plot(claims.table$Date.of.Service)

# print member and claims tables
#write.table(member.table, "members.txt", sep="\t")
#write.table(claims.table, "claims.txt", sep="\t")



