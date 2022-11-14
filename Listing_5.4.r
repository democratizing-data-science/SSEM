#As the Crow FLies
#install.packages("rgeos")
#install.packages("igraph")
library(rgeos)
library(tigris)
library(sf)
library(igraph)
#Stores data for faster access
options(tigris_use_cache = TRUE)
#################################################################
# I. Load IPEDS zcta irs data 
#################################################################
#This is IPEDS IRS ZCTA CO dataset (see code Listing 4.17)
pt <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", "14Z5Ypl7MbWz8ySFKtjOUPT9EKfU3mioT"))
#################################################################
# II. Subsetting to only two schools UPenn and CCP
#################################################################
coords_CCP <- cbind(pt$LONGITUD[pt$UNITID==215239], pt$LATITUDE[pt$UNITID==215239])
coords_UPenn <- cbind(pt$LONGITUD[pt$UNITID==215062], pt$LATITUDE[pt$UNITID==215062])
#################################################################
# III. Calculate distance between two points
#################################################################
crowdist<- spDists(coords_CCP,  coords_UPenn, longlat=T)*0.621371192237
#Result is in KM, to change to miles we multiply by 0.621371192237
#################################################################
# IV. Calculate distance among many points
#################################################################
#First points inside Philadelphia borders
co <- counties("PA") #Limits the counties to Pennsylvania
co <- co[co$NAME=="Philadelphia", ]
#Transform to simple features
pt <- st_as_sf(x = pt,
coords = c("LONGITUD", "LATITUDE"),
crs=st_crs(co))
#Remove Points Outside Philadelphia county, first source the function described in code Listing 4.10
source(sprintf("https://docs.google.com/uc?id=%s&export=download", "1fDnDVPVexfDi77IzaFHEQWS8TDIaW9Le"))
rmv_obj_outside(high_level=co, low_level=pt)
#Function retunrs an object called "sec_object_trim" so, save as pt again
pt <- sec_object_trim
# Retain only Philadelphia 2- and 4-year public and private not for profit 4-year colleges
pt <- pt[pt$SECTOR<3|pt$SECTOR==4, ]
#################################################################
# V. Extract coordinates of interest and create distance matrix
#################################################################
destination = st_coordinates(pt)
crowdists<- round(spDists(destination,  destination, longlat=T)*0.621371192237, 3)
rownames(crowdists) <- pt$UNITID
colnames(crowdists) <- pt$UNITID
#################################################################
# VI. Move from a matrix to an edgelist with distance measures
#################################################################
g<-graph.adjacency(crowdists, mode="upper", weighted = TRUE)
g<-data.frame(cbind(get.edgelist(g)), crow_flies_dis=E(g)$weight)
g
#################################################################
# VII. Compute Multiple distances with different point types (non-square matrix)
#################################################################
#Read second file
origins <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", "1PffhCIYGdYukuF3sdDTxCwYp5l6-v8lM"))
origins <- origins[origins$Name=="Whitehall Apts."|origins$Name=="Westpark Plaza"|origins$Name=="Spring Garden Apts."|origins$Name=="Raymond Rosen Manor",c("Name", "longitude","latitude")]
#Create matrix of coordinates
origin <- cbind(origins$longitude, origins$latitude)
#Compute distances
dist <- round(spDists(origin, destination, longlat=T)*0.621371192237, 3)
rownames(dist) <- origins$Name
colnames(dist) <- pt$UNITID
#Apply Network transformations
g<-graph.incidence(dist, weighted = TRUE)
g<-data.frame(cbind(get.edgelist(g)), crow_flies_dis=E(g)$weight)
g
#Code ends