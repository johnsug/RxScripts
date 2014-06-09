x.mean <- seq(1:4)
x.sd <- seq(1:4)
x.skew <- seq(1:4)
x.kurt <- seq(1:4)
x.sum <- seq(1:4)

for (i in 1:4){
  x.mean[i] <- mean(d[d$Group==i,"MED_RX_MONTHLY"])
  x.sd[i] <- sd(d[d$Group==i,"MED_RX_MONTHLY"])
  x.skew[i] <- skewness(d[d$Group==i,"MED_RX_MONTHLY"])
  x.kurt[i] <- kurtosis(d[d$Group==i,"MED_RX_MONTHLY"])
  x.sum[i] <- sum(d[d$Group==i,"MED_RX_MONTHLY"])
}

df <- data.frame(x.mean, x.sd, x.skew, x.kurt, x.sum)

x09.mean <- seq(1:4)
x09.sd <- seq(1:4)
x09.skew <- seq(1:4)
x09.kurt <- seq(1:4)
x09.sum <- seq(1:4)

for (i in 1:4){
  x09.mean[i] <- mean(d.09[d.09$Group==i,"MED_RX_MONTHLY"])
  x09.sd[i] <- sd(d.09[d.09$Group==i,"MED_RX_MONTHLY"])
  x09.skew[i] <- skewness(d.09[d.09$Group==i,"MED_RX_MONTHLY"])
  x09.kurt[i] <- kurtosis(d.09[d.09$Group==i,"MED_RX_MONTHLY"])
  x09.sum[i] <- sum(d[d$Group==i,"MED_RX_MONTHLY"])
}

df.09 <- data.frame(x09.mean, x09.sd, x09.skew, x09.kurt, x09.sum)

x10.mean <- seq(1:4)
x10.sd <- seq(1:4)
x10.skew <- seq(1:4)
x10.kurt <- seq(1:4)
x10.sum <- seq(1:4)

for (i in 1:4){
  x10.mean[i] <- mean(d.10[d.10$Group==i,"MED_RX_MONTHLY"])
  x10.sd[i] <- sd(d.10[d.10$Group==i,"MED_RX_MONTHLY"])
  x10.skew[i] <- skewness(d.10[d.10$Group==i,"MED_RX_MONTHLY"])
  x10.kurt[i] <- kurtosis(d.10[d.10$Group==i,"MED_RX_MONTHLY"])
  x10.sum[i] <- sum(d[d$Group==i,"MED_RX_MONTHLY"])
}

df.10 <- data.frame(x10.mean, x10.sd, x10.skew, x10.kurt, x10.sum)

df
df.09
df.10

df.10 - df.09

x <- table(d$YEAR, d$Group)
x.freq <- x

for (i in 1:2){
  for (j in 1:4){
    x.freq[i,j] <- x[i,j] / sum(x[i,1:4]) 
  }
}

x.freq * 100

x.mean <- seq(1:4)
x.sd <- seq(1:4)
x.skew <- seq(1:4)
x.kurt <- seq(1:4)
x.sum <- seq(1:4)

for (i in 1:4){
  x.mean[i] <- mean(d[d$Group==i,"MED_RX_MONTHLY"])
  x.sd[i] <- sd(d[d$Group==i,"MED_RX_MONTHLY"])
  x.skew[i] <- skewness(d[d$Group==i,"MED_RX_MONTHLY"])
  x.kurt[i] <- kurtosis(d[d$Group==i,"MED_RX_MONTHLY"])
  x.sum[i] <- sum(d[d$Group==i,"MED_RX_MONTHLY"])
}

df <- data.frame(x.mean, x.sd, x.skew, x.kurt, x.sum)
df