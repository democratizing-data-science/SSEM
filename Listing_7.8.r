#Visualizing Local Moran's I Estimates for Polygon Data
library(RColorBrewer)
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
# IV. Creating spatial neighbors, joining them, and testing
#################################################################
second_order_n <- nblag(nqueen, maxlag=2)
high_order <- nblag_cumul(second_order_n)
nqueen2_order <- nb2listw(high_order, style="W", zero.policy=T)
#Save the Moran's I result
mt <- moran.test(usa$propbenft, nqueen2_order, zero.policy=T)
#################################################################
# V. Local Moran's I Plot
#################################################################
#label for x-axis and y-axis
label_x = "Prop. SLID Recipients"
label_y = "Lagged Prop. SLID Recipients"
mp <- moran.plot(usa$propbenft, nqueen2_order, zero.policy=T, labels=usa$STUSPS,
xlim=c(.055, .12), xlab = label_x, ylab = label_y)
title(main="Moran's Plot", cex.main=2, col.main="grey11", font.main=2, sub=paste("Plot includes 48 States and DC (Moran's I = ", round(mt$ estimate[1], 3), ", p < .0001)", sep=""),cex.sub=1.15, col.sub="grey11", font.sub=2,)
#################################################################
# VI. Load  minimal code function to plot
#################################################################
source(sprintf("https://docs.google.com/uc?id=%s&export=download", "1AqvxPgRvTj0GxJItZpVFwjgwL-ruesyL"))
moran_polyg(y=usa$propbenft,shapefile=usa, moran_plot=mp, weight_mat=nqueen2_order, color="Accent", legend.pos="bottomright")
#Code ends
