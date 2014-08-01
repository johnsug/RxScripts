
# needed libraries
library(maps)
library(ggplot2)
library(animation)

setwd("C:/Users/JS033085/Desktop")

# states
all_states <- map_data("state")
##states <- subset(all_states, region %in% c("idaho", "nevada", "utah", "colorado", "arizona"))
states <- subset(all_states, region %in% c("idaho", "montana", "wyoming", "nevada", "utah", "colorado", "arizona", "new mexico"))

# data
topic <- c("1. Be of Good Cheer", "2. Faith", "3. Repentence", "4. Covenants", "5. Priesthood", 
            "6. Zion", "7. Christ", "8. Coming to Christ", "9. Marriage and Families", "10. ???")
address <- c("3300 Vista Avenue", "1575 North Skyline Drive", "55 North Main Street", "525 North 400 West", "1401 North Research Way", 
             "2790 Crossroads Boulevard", "Center Street and 300 East", "777 West Lake Mead Parkway", "850 South Bluff Street", " ")
city <- c("Boise", "Idaho Falls", "Logan", "Centerville", "Orem", "Grand Junction", "Ephraim", "Henderson", "St. George", "Phoenix")
state <- c("ID", "ID", "UT", "UT", "UT", "CO", "UT", "NV", "UT", "AZ")
lat <- c(43.572948, 43.510077, 41.732683, 40.923113, 40.323131, 39.11517, 39.359759, 36.031928, 37.093733, 33.45)
long <- c(-116.214705, -112.063966, -111.834975, -111.886312, -111.68169, -108.535558, -111.579505, -115.008983, -113.587282, -112.0667)
d <- data.frame(topic, address, city, state, lat, long)

# creates pngs
for (i in 0:10){
  p <- ggplot() + geom_polygon(data=states, aes(x=long, y=lat, group=group), colour="white", fill="lightblue", alpha=.25)
  p <- p + geom_point(data=d[0:i,], aes(x=long, y=lat), color="red") + xlab("") + ylab("")
  p <- p + geom_text(data=d[0:i,], hjust=0.5, vjust=-0.5, aes(x=long, y=lat, label=topic), colour="grey10", size=4.5)
  png(file=paste("plot",i,".png", sep=""), height=450, width=450)
  print(p)
  dev.off()
}

# slows down animation speed
#ani.options(interval=.5)

# call ImageMagick and turn pngs into one single gif
files = matrix(sprintf("plot%d.png", 0:10))
im.convert(files, output = 'Rainfall.gif')

# delete files when done
#file.remove(files)















