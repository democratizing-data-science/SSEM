#Begin Primary and Seconday Roads Code Listing
library(tigris)
library(sf)
#Stores data for faster access
options(tigris_use_cache = TRUE)

#################################################################
# I. Download shapefile
#################################################################
rds <- primary_secondary_roads(state = "Pennsylvania")
par(mfrow=c(1,3))
plot(st_geometry(rds), main="Pennsylvania", sub="Primary and Secondary Roads (N = 13,489)")

#################################################################
# II. Modify shapefile Using Bounding Box of Philadelphia County
#################################################################
#Get Philadelphia county
co <- counties("PA") #Limits the counties to Pennsylvania
co <- co[co$NAME=="Philadelphia", ]

#Apply the function "st-bbox" to crop the rds object to Philadelphia county using dhe object "co"
rds <-st_crop(rds, st_bbox(co))

plot(st_geometry(co), main="Only Philadelphia County", sub="Primary and Secondary Roads (N = 571)")
plot(st_geometry(rds), add = TRUE, col="#CD1076")

#################################################################
# III. Remove Roads Outside Philadelphia county
#################################################################
#Load ``rmv_obj_outside'' function
source(sprintf("https://docs.google.com/uc?id=%s&export=download", "1fDnDVPVexfDi77IzaFHEQWS8TDIaW9Le"))
rmv_obj_outside(high_level=co, low_level=rds)
#Function retunrs an object called "sec_object_trim"
#Now we can plot this resulting "sec_object_trim" file as follows
plot(st_geometry(co), main="Only Philadelphia County", sub="Primary and Secondary Roads (N = 378)")
plot(st_geometry(sec_object_trim), add = TRUE, col="#CD1076")
#End Primary Roads Code Listing