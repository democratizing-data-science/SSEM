#Two-mode to One-mode neighbor Transformation
library(spdep)
library(tigris)
options(tigris_use_cache = TRUE)
#################################################################
# I. Access IPEDS data and subset to Pennsylvania 
#################################################################
pts <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", "14Z5Ypl7MbWz8ySFKtjOUPT9EKfU3mioT"))
origin <- pts[pts$STATE=="PA"&(pts$SECTOR==4|pts$SECTOR==5), c("UNITID","LONGITUD","LATITUDE")]
destination <- pts[pts$STATE=="PA"&(pts$SECTOR==1|pts$SECTOR==2), c("UNITID","LONGITUD","LATITUDE")]
#################################################################
# II. Access the 'travel_times' function and obtain times
#################################################################
source(sprintf("https://docs.google.com/uc?id=%s&export=download"
, "1OMKoETbOqyXFm758k8vsFZrU8dX5mnmw"))
travel_times(origin, destination)
#This function renders an edgelist and a matrix
#################################################################
# III. Apply transformations retaining 2-year institutions
#################################################################
#save original matrix of distances
mat <- matf 
#Identify neighboring structures as before but using this matrix
mat <- ifelse(mat > 27.6, 0, ifelse(mat > 0, 1, mat))
#Transformation
mat <- mat%*%t(mat)
#Save diagonal info
numb_neigh <- diag(mat)
#Remove diagonal
diag(mat) <- 0
#Create a weight
mat <- round(mat/rowSums(mat),5)
#Replace missing with zeroes
mat [is.na(mat)]<-0
#Create a neighboring unit
test.listw <- mat2listw(mat)
#################################################################
# IV. Mapping these connections after transformations
#################################################################
#Transform comm_dist object above to matrix
coords <- cbind(origin$LONGITUD, origin$LATITUDE)#used to plot
#Convert to a list of neighbors
#Get PA shapefile
pa <- states()
pa <- pa[pa$STUSPS=="PA",]
#Plot the resulting neighboring structure
plot(st_geometry(pa), main=paste("Map representing", nrow(origin), "2-year colleges in PA connected by having a common
4-year neighbor (in blue) within 27.6 minutes of commuting distance (red no neighbor)"))
plot(test.listw, coords=coords, add=TRUE)
color <- ifelse(numb_neigh==0, "red", "blue")
points(coords, col=color)
#Code ends