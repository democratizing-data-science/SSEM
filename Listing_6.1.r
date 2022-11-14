install.packages("spdep")
library(spdep)
#################################################################
# I. Load roads shapefile and point IPEDS data 
#################################################################
#Load IPEDS Dataset
pt <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", "14Z5Ypl7MbWz8ySFKtjOUPT9EKfU3mioT"))
#Let us extract the two institutions shown in our first figure of this chapter
pt <- destination[pt$UNITID==215062|pt$UNITID==215239|pt$UNITID==212054, c("UNITID","LONGITUD","LATITUDE")]
#From points to matrix to enter virtuosity of equation (1)
#################################################################
# II. Extract coordinates
#################################################################
coords = cbind(pt$LONGITUD, pt$LATITUDE)
#################################################################
# III. Radius-based function
#################################################################
rad<-dnearneigh(coords, 0, 1.60934, longlat = TRUE)
#The list of weights is obtained from
listwrad<-nb2listw(rad, zero.policy=TRUE)
#################################################################
# IV. Kth neighbor function
#################################################################
klosest<-knn2nb(knearneigh(coords, k=1))
test.listw1c<-nb2listw(klosest)
#################################################################
# V. Inverse distance neighbor process
#################################################################
CT <- max(unlist(nbdists(klosest, coords, longlat = TRUE)))
CT
#Apply radius based
#The result row-standardize these connections
nb.dist.band <- dnearneigh(coords, 0, CT, longlat = TRUE)
#Extracts distances among connections to apply inverse weights
distances <- nbdists(nb.dist.band,coords, longlat = TRUE)
#Take the inverse
invd1 <- lapply(distances, function(x) (1/x))
#Apply those inverse weights
invd.weights <- nb2listw(nb.dist.band, glist = invd1, style="B")
#Code Ends