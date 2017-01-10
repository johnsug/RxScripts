
library(leaflet)
m <- data.table(rbind(c("New England", "Patriots", "AFC", "Gillette Stadium", 1, 42.0909, -71.2643), 
                      c("Kansas City", "Chiefs", "AFC", "Arrowhead Stadium", 2, 39.0489, -94.4839), 
                      c("Pittsburgh", "Steelers", "AFC", "Heinz Field", 3, 40.4468, -80.0158), 
                      c("Houston", "Texans", "AFC", "NRG Stadium", 4, 29.6847, -95.4107), 
                      c("Oakland", "Raiders", "AFC", "Oakland Alameda Coliseum", 5, 37.7516, -122.2005), 
                      c("Miami", "Dolphins", "AFC", "Hard Rock Stadium", 6, 25.9580, -80.2389), 
                      c("Dallas", "Cowboys", "NFC", "AT&T Stadium", 1, 32.7473, -97.0945), 
                      c("Atlanta", "Falcons", "NFC", "Georgia Dome", 2, 33.7577, -84.4008), 
                      c("Seattle", "Seahawks", "NFC", "CenturyLink Field", 3, 47.5952, -122.3316), 
                      c("Green Bay", "Packers", "NFC", "Lambeau Field", 4, 44.5013, -88.0622), 
                      c("New York", "Giants", "NFC", "MetLife Stadium", 5, 40.8128, -74.0742), 
                      c("Detroit", "Lions", "NFC", "Ford Field", 6, 42.3400, -83.0456)))
names(m) <- c("City", "Team", "League", "Stadium", "Seed", "Lat", "Long")
m[, active:=T]
m[City %in% c("Oakland", "Miami", "Detroit", "New York"), active:=F] ## wildcard
m[City %in% c("", "", "", ""), active:=F] ## divisional
m[City %in% c("", ""), active:=F] ## conference
m[City %in% c(""), active:=F] ## title
leaflet(m) %>% 
  addTiles() %>% 
  setView(lat=40, lng=-98, zoom=4) %>% 
  addCircleMarkers(data=m[active==T], lng= ~Long, lat= ~Lat) %>% 
  addCircleMarkers(data=m[active==F], lng= ~Long, lat= ~Lat, col="red")
