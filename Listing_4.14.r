#Crosswalk ZCTAs and Counties Code Listing
#install.packages("plyr")
library(plyr)
library(sf)
library(stringr)
library(tigris)
options(tigris_use_cache = TRUE)
#################################################################
# I. Download shapefile and apply Bounding Box
#################################################################
zip <- zctas()
zip$lat <- as.numeric(zip$INTPTLAT10)
zip$lon <- as.numeric(zip$INTPTLON10)
#subset based on bound boxing
zip<-zip[zip$lon > -124.848 &
zip$lon < -66.886 &
zip$lat > 24.3964 &
zip$lat < 49.3844, ]
#################################################################
# III. Load all databases, including crosswalk
#################################################################
zcta <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", "1vPr4Gg1Qm0XMfbT3hi_06UYDvtgCOlhE"))
co <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", "1vVzPC32yfANg24QHsk5YqcaQ_7ugTw1p"))
cross <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", "1w7Fe-3hFV50gm7DDR_IXQunDCz8oIyOI"))

zcta$zip <- str_pad(zcta$zip, 5, pad = "0")
co$county <- str_pad(co$county, 5, pad = "0")
#Also for cross due to missing leading "0"s
cross$zip <- str_pad(cross$zip, 5, pad = "0")
cross$county <- str_pad(cross$county, 5, pad = "0")
#################################################################
# IV. Apply Crosswalk
#################################################################
zcta$county <- cross$county[match(zcta$zip, cross$zip)] 
zcta <- join(zcta, co, by="county") #the key is now county
#################################################################
# V. Bring everything to the shapefile
#################################################################
zip <- geo_join(zip, zcta, "ZCTA5CE10", "zip", how="left")