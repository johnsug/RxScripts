
## loan parameters
d <- data.frame(PV=c(1657.00, 541.02, 944.47, 6163.45, 6074.16, 1952.01, 2656.43, 4512.80),
                int=c(.055, .055, .055, .063, .063, .063, .063, .063),
                pmt=c(28.01, 12.04, 15.95, 106.54, 99.95, 41.74, 43.33, 73.53))
d$pmt1 <- d$pmt + round((500-421.09+12.04)/7,2)
d$pmt2 <- d$pmt1 + round(d$pmt1[3]/6,2) 
d$pmt3 <- d$pmt2 + round(d$pmt2[6]/5,2)
d$pmt4 <- d$pmt3 + round(d$pmt3[1]/4,2)
d$pmt5 <- d$pmt4 + round(d$pmt4[7]/3,2)
d$pmt6 <- d$pmt5 + round(d$pmt5[8]/2,2)
d$pmt7 <- d$pmt6 + d$pmt5[4]
d[2,4:10] <- 0
d[3,5:10] <- 0 
d[6,6:10] <- 0
d[1,7:10] <- 0
d[7,8:10] <- 0
d[8,9:10] <- 0
d[4,10] <- 0

## schedule data frame
s <- data.frame(month=rep(1:12, 5), 
                year=rep(2016:2020, each=12),
                loan1=0,
                loan2=0,
                loan3=0,
                loan4=0,
                loan5=0,
                loan6=0,
                loan7=0,
                loan8=0)
s0 <- head(s,0)
s0[1,1] <- 12
s0[1,2] <- 2015
s0[1,3:10] <- c(d$PV)
s <- rbind(s0, s)
s[1,4] <- 0 ## early payoff, 12/22/2015

## amortization parameters
pmt_col <- 4         ## indicates which payment to be using
split_count <- 7     ## indicates number of splits for terminating payment
is_live <- rep(1,8)  ## vector to indicate if payment is still live
is_live[2] <- 0      ## set loan #2 to zero, due to early payoff

## amortization loop
for(i in 2:nrow(s)){
  # apply interest
  s[i,3:10] <- s[i-1,3:10] + round(s[i-1,3:10] * d$int/12,2) 
  
  # make payment
  s[i,3:10] <- s[i,3:10] - d[,pmt_col]
  
  # zero out payment if less than zero, then advance loop parameters
  for(j in 1:8){
    if(s[i,j+2]<0){
      is_live[j] <- 0
      balance_pmt <- round(s[i,j+2] / split_count,2)
      s[i,j+2] <- 0
      s[i,3:10] <- s[i,3:10] + balance_pmt * is_live
      pmt_col <- pmt_col + 1                          ## advance to next pmt amount
      split_count <- split_count - 1                  ## reduce number of splits next time around
    }
  }
}
s[1,4] <- d[2,1]                                      ## add back payment paid off in December
