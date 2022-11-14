#Begin Country Level Code Listing
#install.packages("tigris", dependencies = TRUE)
#install.packages("sf", dependencies = TRUE)
library(tigris)
library(sf)
#Stores data for faster access
options(tigris_use_cache = TRUE)

#################################################################
# I. Download shapefile
#################################################################
usa <- states()

#default result
plot(st_geometry(usa), main="A. Default, includes States and territories")

#################################################################
# II. Modifying, only focusing on the 50 States and DC
#################################################################

#removing territories
# The function %ni% created next, removes all matches of in a row subset call
"%ni%" <- Negate("%in%")
usa <- usa[usa$NAME %ni% c('American Samoa',  'Guam', 'Puerto Rico', 'Commonwealth of the Northern Mariana Islands', 'United States Virgin Islands'), ]
#'Alaska', 'Hawaii' may be added to the %ni% list if you want to exclude them

#Results
plot(st_geometry(usa), main="B. Modified, does not include territories")

#################################################################
#III. Shifting for visualization purposes
#################################################################

#Alaska and Hawaii are difficult to observe
#Apply the function 'shift_geometry()' to bring them closer
usa<-usa %>% 
     shift_geometry()
plot(st_geometry(usa), main="C. Alaska and Hawaii are closer for publication purposes")

#End Country Level Code Listing