#Begin All Roads Code Listing
library(tigris)
library(sf)
#Stores data for faster access
options(tigris_use_cache = TRUE)

#################################################################
# I. Download shapefile
#################################################################
rds<-roads(state="PA", county="Philadelphia")
#rds<-roads(state="PA", county=c("Philadelphia", "Delaware"))

co <- counties("PA") #Limits the counties to Pennsylvania
co <- co[co$NAME=="Philadelphia", ] 

plot(st_geometry(co), main = "Philadelphia County", sub = "All Roads")
plot(st_geometry(rds), add = TRUE)


#End All Roads Code Listing
