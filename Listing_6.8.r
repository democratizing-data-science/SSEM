#Two mode neighbor identification
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
# III. Identify neighbors based on travel time threshold
#################################################################
#first using the edgelist object 'edgelistf'
comm_dist <- edgelistf #copy to avoid modifying original
#If distnace if below the threshold, identify as neighbor
comm_dist$neigh <- ifelse(comm_dist$timedist<=27.6, 1, 0) 
#Count number of neighbors per each 2-year college
neigh_numb <- aggregate(neigh ~ X1, FUN=sum, data=comm_dist)
#Add this count back to the edgelist for future use
comm_dist$neigh_numb <- neigh_numb$neigh[match(comm_dist$X1, neigh_numb$X1)]
#################################################################
# IV. Mapping these connections based on matrix transformations
#################################################################
#Transform comm_dist object above to matrix
mat <- as.matrix(get.adjacency(graph.data.frame(comm_dist, directed=T), attr="neigh"))
#Append origin & destinations to extract coordinates for ploting
pt <- rbind(origin, destination)
coords <- cbind(pt$LONGITUD, pt$LATITUDE)#used to plot
#Convert to a list of neighbors
mat <- matphu/rowSums(mat)
mat [is.na(mat)]<-0
test.listw <- mat2listw(mat)
#Get PA shapefile
pa <- states()
pa <- pa[pa$STUSPS=="PA",]
#Plot the resulting neighboring structure
plot(st_geometry(pa), main=paste("Map representing", nrow(origin), "2- (in red) and", nrow(destination), "4-year (in blue) colleges in PA
", table(neigh_numb$neigh==0)[2], "2-year colleges have zero and", table(neigh_numb$neigh>10)[2], "have more than 10 neighbors within 27.6 minutes of commuting distance"))
plot(test.listw, coords=coords, add=TRUE)
points(coords[1:nrow(origin),], col="red")
points(coords[(nrow(origin)+1):nrow(pt),], col="blue")
#Code ends