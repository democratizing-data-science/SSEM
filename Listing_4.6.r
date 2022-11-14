#Begin Census Tract Level Code Listing
library(tigris)
library(sf)
#Stores data for faster access
options(tigris_use_cache = TRUE)

#################################################################
# I. Download shapefile
#################################################################
block <- block_groups(state=NULL, cb=TRUE)# 220,414 polygons
block <- block_groups("PA", county = c("Philadelphia"))

#End Census Tract Level Code Listing
