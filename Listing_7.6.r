#Two mode point neighbor identification and SODA analyses
library(spdep)
#################################################################
# I. Access 2020-21 Score Card Data data and subset to NorthEast
#################################################################
#Researchers can use the files from College Score Card (CSC) or the one stored in our server
pts <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", "17BLZ9bE0oRmU0OvwI3d_6y9NHeOE6ycM"))
origin <- pts[(pts$HIGHDEG==2&pts$CONTROL==1)&(pts$REGION==1|pts$REGION==2), c("UNITID", "LONGITUD", "LATITUDE")]
destination <- pts[(pts$HIGHDEG>2&pts$CONTROL<3)&(pts$REGION==1|pts$REGION==2), c("UNITID","LONGITUD","LATITUDE")]
#Merge or join
origin$net_cost_attnd <- as.numeric(pts$NPT4_PUB[match(origin$UNITID, pts$UNITID)])
origin <- origin[!is.na(origin$net_cost_attnd),]
dim(origin)
#################################################################
# II. Access the 'travel_times' function and obtain travel times
#################################################################
source(sprintf("https://docs.google.com/uc?id=%s&export=download", "1OMKoETbOqyXFm758k8vsFZrU8dX5mnmw"))
#This function renders an edgelist and a matrix
travel_times(origin[,1:3], destination)
#################################################################
# III. Transformations
#################################################################
#Save a copy of matrix of travel times to avoid losing info.
mat <- matf
#Identify neighboring structures as before but using this matrix
mat <- ifelse(mat > 46.6, 0, ifelse(mat > 0, 1, mat))
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
#Note that with a 27.6 threshold, 67 units would remain diconnected
#With 46.6 minutes as the threshold, 25 units remained disconnected
#################################################################
# IV. Create weight matrix
#################################################################
weight_mat <- mat2listw(mat)
#################################################################
# V. How many orders for Moran's I significance?
#################################################################
plot.spcor(sp.correlogram(weight_mat$neighbours, 
origin$net_cost_attnd, order = 10, method = "I", zero.policy=T), 
xlab = "Spatial lags", main = "Spatial correlogram: Autocorrelation with CIs")
#################################################################
# VI. Modified Spline Correlogram to Accommodate travel times
#################################################################
source(sprintf("https://docs.google.com/uc?id=%s&export=download",
"16IKgklK7ypG_T0D_N6tuGCWS77Mj0h7o"))
#Distances should be among 2-year colleges then need to compute
#these distances again
travel_times(origin, origin)#and use matf resulting from the call
cont_dist_M <- spline_dist_time(z=origin$net_cost_attnd, 
xdist=matf, resamp= 1000)
plot(cont_dist_M, main = "Spline correlogram: MC-Simulations")
#################################################################
# VII. Traditional Moran's I structure with first order neighbors
#################################################################
moran.test(origin$net_cost_attnd, weight_mat, zero.policy=TRUE)
plot(moran.mc(origin$net_cost_attnd, weight_mat, zero.policy=T, nsim=10000))
#################################################################
# VIII. Local Moran's I 
#################################################################
moran.plot(origin$net_cost_attnd, weight_mat, zero.policy=TRUE)
#Code Ends