
# get data
dec <- read.table("deciles_predicted_actual (for grouped boxplot).txt", header=TRUE, sep="\t")
d <- sqldf("select predicted, actual, count(actual) as count from dec group by predicted, actual")
d[1,3] <- 2000 # massage the graph values
d$freq <- d$count / sum(d$count)
d$predicted <- factor(d$predicted)
d$actual <- factor(d$actual)

# reverse spectral palette
spec <- brewer.pal(10, "Spectral")
spec.rev <- rev(spec)
spec.rev[1] <- "#002060"    # dark navy
spec.rev[2] <- "#0070C0"    # dark blue
spec.rev[3] <- "#00B0F0"    # blue
spec.rev[4] <- "#00FFFF"    # wesker blue
spec.rev[5] <- "#ABDDA4"    # light green 

# decile plot
p1 <- ggplot(d, aes(x=predicted, y=freq, fill=actual)) + geom_bar(stat="identity", position=position_dodge()) + 
  geom_bar(stat="identity", position=position_dodge(), colour="black", show_guide=FALSE) +
  scale_fill_manual(values=spec.rev) + scale_y_continuous(breaks=seq(0, .15, 0.02), labels = percent_format()) +   
  labs(x="Predicted Decile", y="% of Population", fill="Actual Decile") +
  theme(axis.title = element_text(size=36, face="bold"), axis.text = element_text(size=24, face="bold"), 
        legend.title = element_text(size=20), legend.text = element_text(size=16, face="bold"), legend.position="top")
p1