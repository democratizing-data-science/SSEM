#One mode point neighbor identification and SODA analyses
library(spdep)
#################################################################
# I. Access 2020-21 Score Card Data data and subset to NorthEast
#################################################################
#Researchers can use the files from College Score Card (CSC) or the one stored in our server
pts <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", "17BLZ9bE0oRmU0OvwI3d_6y9NHeOE6ycM"))
origin <- pts[(pts$HIGHDEG==2&pts$CONTROL==1)&(pts$REGION==1|pts$REGION==2), c("UNITID", "LONGITUD", "LATITUDE")]
#Merge or join
origin$net_cost_attnd <- as.numeric(pts$NPT4_PUB[match(origin$UNITID, pts$UNITID)])
origin$LONGITUD<-as.numeric(origin$LONGITUD)
origin$LATITUDE<-as.numeric(origin$LATITUDE)
origin <- origin[!is.na(origin$net_cost_attnd),]
dim(origin)
#################################################################
# II. Access the 'travel_times' function and obtain travel times
#################################################################
source(sprintf("https://docs.google.com/uc?id=%s&export=download", "1OMKoETbOqyXFm758k8vsFZrU8dX5mnmw"))
#This function renders an edgelist and a matrix
travel_times(origin, origin)
#################################################################
# III. rad Function
#################################################################
#Source the function(s)
source(sprintf("https://docs.google.com/uc?id=%s&export=download",
 "1p-wJ9lPR3gq5LvJKMyDZHiM91T9y09E6"))
#weight_mat<-rad(edgelistf, 27.6)
#This resulted in 96 of the 133 units without neighbors
weight_mat <- rad(edgelistf, 46.6)
#This resulted in 37 of the 133 units without neighbors
#################################################################
# IV. How many orders for Moran's I significance?
#################################################################
plot.spcor(sp.correlogram(weight_mat$neighbours, 
origin$net_cost_attnd, order = 10, method = "I", zero.policy=T), 
xlab = "Spatial lags", main = "Spatial correlogram: Autocorrelation with CIs")
#################################################################
# V. Modified Spline Correlogram to Accommodate travel times
#################################################################
source(sprintf("https://docs.google.com/uc?id=%s&export=download",
"16IKgklK7ypG_T0D_N6tuGCWS77Mj0h7o"))
cont_dist_M <- spline_dist_time(z=origin$net_cost_attnd, 
xdist=matf, resamp= 1000)
plot(cont_dist_M, main = "Spline correlogram: MC-Simulations")
#################################################################
# VI. Traditional Moran's I structure with first order neighbors
#################################################################
moran.test(origin$net_cost_attnd, weight_mat, zero.policy=TRUE)
plot(moran.mc(origin$net_cost_attnd, weight_mat, zero.policy=T, nsim=10000))
#Code Ends
