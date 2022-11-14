#Begin Primary Roads Code Listing
library(tigris)
library(sf)
#Stores data for faster access
options(tigris_use_cache = TRUE)

#################################################################
# I. Download shapefile
#################################################################
rds <- primary_roads()
par(mfrow=c(1,2))
plot(st_geometry(rds), main="All States, DC, and Puerto Rico", sub="Primary Roads (N = 17,495)")

#################################################################
# II. Modify shapefile Using Bounding Box of Philadelphia County
#################################################################
#Get Philadelphia county
co <- counties("PA") #Limits the counties to Pennsylvania
co <- co[co$NAME=="Philadelphia", ]

#Apply the function "st-bbox" to crop the rds object to Philadelphia county using the object "co"
rds <-st_crop(rds, st_bbox(co))

plot(st_geometry(co), main="Only Philadelphia County", sub="Primary Roads (N = 119)")
plot(st_geometry(rds), add = TRUE, col="#CD1076")

#End Primary Roads Code Listing