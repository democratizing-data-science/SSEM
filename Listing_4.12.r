#Begin Points Geocoding Code Listing
#install.packages("tidygeocoder")
library(tidygeocoder)
library(tigris)
library(sf)
#Stores data for faster access
options(tigris_use_cache = TRUE)

#################################################################
# I. Download and laod file with addresses (e.g., NCES's Common Core Data)
#################################################################
ccd <- paste('https://nces.ed.gov/ccd/Data/zip/ccd_sch_029_2021_w_0a_02032021.zip')
a<-getwd() #to save locally
download.file(ccd, destfile = paste(a,"ccd_sch_029_2021_w_0a_02032021.zip",sep="/"))
ccd <- read.csv(unz(paste(a,"ccd_sch_029_2021_w_0a_02032021.zip",sep="/"), "ccd_sch_029_2021_w_0a_02032021.csv"))

#################################################################
# II. Limit geocoding to PA addresses and compose address
#################################################################
ccd <- ccd[ccd$ST=="PA",]
ccd$address <- paste(ccd$LSTREET1, ccd$LCITY, ccd$LSTATE, ccd$LZIP, sep=" ")

#################################################################
# III. Geocode using ArcGIS free service and match results
#################################################################
ccd_geo <- geo(address = ccd$address, method = 'arcgis')
ccd$lat <- ccd_geo$lat[match(ccd$address, ccd_geo$address)]
ccd$long <- ccd_geo$long[match(ccd$address, ccd_geo$address)]

#The previous process was needed for we have repeated addresses if our database only has unique addresses the geocoding may be achieved with one line
#If so, uncomment the following line
#ccd <- cbind(ccd, geo(address = ccd$address, method = 'arcgis')[,2:3])

#################################################################
# IV. Transforming to a points shapefile and plot
#################################################################
#First let's download the state and county shapefiles
usa<-states()
#Get Philadelphia county
co <- counties("PA") #Limits the counties to Pennsylvania
co <- co[co$NAME=="Philadelphia", ]

#Each of these files has the same coordinate reference system ("Geodetic CRS:  NAD83") as discussed in Chapter 3
ccd_sh <- st_as_sf(x = ccd,
          coords = c("long", "lat"),
          crs=st_crs(usa))
#################################################################
# V. Ready to plot first State
#################################################################
par(mfrow=c(1,3))
plot(st_geometry(usa[usa$NAME=="Pennsylvania",]), main="Pennsylvania", sub="Schools or Academies (N = 2,975)")
plot(st_geometry(ccd_sh), add = TRUE, col="#CD1076")

#County applying the function "st-bbox" to crop the points object to Philadelphia county using dhe object "co"
ccdt <-st_crop(ccd_sh, st_bbox(co))
plot(st_geometry(co), main="Only Philadelphia County", sub="Schools or Academies (N = 360)")
plot(st_geometry(ccdt), add = TRUE, col="#CD1076")

#################################################################
# VI. Remove schools outside Philadelphia county
#################################################################
#If interested in removing schools outside of the county boundaries apply the ``rmv_obj_outside'' function
source(sprintf("https://docs.google.com/uc?id=%s&export=download", "1fDnDVPVexfDi77IzaFHEQWS8TDIaW9Le"))
rmv_obj_outside(high_level=co, low_level=ccdt)
#Function retunrs an object called "sec_object_trim"
#Now we can plot this resulting "sec_object_trim" file as follows
plot(st_geometry(co), main="Only Philadelphia County", sub="Schools or Academies (N = 309)")
plot(st_geometry(sec_object_trim), add = TRUE, col="#CD1076")
#End Points Geocoding Code Listing



