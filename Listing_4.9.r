library(tigris)
library(sf)
#Stores data for faster access
options(tigris_use_cache = TRUE)
rdsPA <- primary_secondary_roads(state = "Pennsylvania")
rdsDE <- primary_secondary_roads(state = "Delaware")
rdsPADE <- rbind(rdspa, rdsde)
plot(st_geometry(rdsPADE), main="PA in Pink, DE in Black")
plot(st_geometry(rdsPA), add=TRUE, col="#CD1076")
