#Begin ZCTAs Level Code Listing
library(sf)
library(tigris)
options(tigris_use_cache = TRUE)

#################################################################
# I. download shapefile
#################################################################
zip <- zctas()
par(mfrow=c(1,2))
plot(st_geometry(zip), main="Default ZCTA Data")
#################################################################
# II. Apply Bounding Box of the Contiguous United States
#################################################################

zip$lat <- as.numeric(zip$INTPTLAT10)
zip$lon <- as.numeric(zip$INTPTLON10)
#subset based on bound boxing
zip<-zip[zip$lon > -124.848 &
         zip$lon < -66.886 &
         zip$lat > 24.3964 &
         zip$lat < 49.3844, ]		   

plot(st_geometry(zip), main="Contiguous USA ZCTA Data")
#End ZCTAs Level Code Listing