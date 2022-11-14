#Higher Order Moran's I procedures
library(spdep)
library(tigris)
options(tigris_use_cache = TRUE)
#################################################################
# I. Load polygons shapefile and the State level IRS database 
#################################################################
usa <- states()
"%ni%" <- Negate("%in%")
irs_state <- read.csv(sprintf("https://docs.google.com/uc?id=%s&
export=download", "10MOXrw2H_QN3rCsqvXIKQtiJ9c0yGJH5"))
#################################################################
# II. Remove states with no boundary-based neighbors and join 
#################################################################
#Removing disconnected states
usa <- usa[usa$NAME %ni% c("Hawaii","Alaska"),]
#Joining datasets, the inner option removes units with no match
usa <- geo_join(usa, irs_state, "STUSPS", "STATE", how="inner")
#################################################################
# III. Create neighborhood list and matrix of weights
#################################################################
#usa is our polygon shapefile with attributes of interest
nqueen <- poly2nb(usa, queen=TRUE)
#using the neighborhood list, create rowstandardized weights
nqueenw <- nb2listw(nqueen, style="W", zero.policy=T)
#################################################################
# IV. How many orders for Moran's I significance?
#################################################################
plot.spcor(sp.correlogram(nqueenw$neighbours, usa$propbenft, 
order = 10, method = "I",zero.policy=T), xlab = "Spatial lags", 
main = "Spatial correlogram: Autocorrelation with CIs")
#################################################################
# V. Creating spatial neighbors, joining them, and testing
#################################################################
second_order_n <- nblag(nqueen, maxlag=2)
#Second order matrix
nqueen2w <- nb2listw(second_order_n[[2]], style="W", zero.policy=T)
#Retesting
moran.test(usa$propbenft, nqueen2w, zero.policy=T)
#Moran I statistic standard deviate = 4.3107, p-value = 8.137e-06
#alternative hypothesis: greater
#sample estimates:
#Moran I statistic       Expectation          Variance 
#      0.292537491      -0.020833333       0.005284686
#Is it worth joining
high_order <- nblag_cumul(second_order_n)
nqueen2_order <- nb2listw(high_order, style="W", zero.policy=T)
moran.test(usa$propbenft, nqueen2_order, zero.policy=T)
#Moran I statistic standard deviate = 5.3218, p-value = 5.136e-08
#alternative hypothesis: greater
#sample estimates:
#Moran I statistic       Expectation          Variance 
#      0.166527437      -0.020833333       0.001239467
#Code Ends