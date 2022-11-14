#Visualizing Moran's I Points
library(RColorBrewer)
library(spdep)
library(tigris)
options(tigris_use_cache = TRUE)
#################################################################
# I. Access 2020-21 Score Card Data data and subset to NorthEast
#################################################################
#Researchers can use the files from College Score Card (CSC) or the one stored in our server
pts <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", "17BLZ9bE0oRmU0OvwI3d_6y9NHeOE6ycM"))
origin <- pts[(pts$HIGHDEG==2&pts$CONTROL==1)&(pts$REGION==1|pts$REGION==2), c("UNITID", "LONGITUD", "LATITUDE")]
#Merge or join
origin$net_cost_attnd <- as.numeric(pts$NPT4_PUB[match(origin$UNITID, pts$UNITID)])
origin <- origin[!is.na(origin$net_cost_attnd),]
dim(origin)
#################################################################
# II. Access shapefile and subset
#################################################################
usa <- states()
sts <- names(table(pts[pts$REGION==1|pts$REGION==2, c("STABBR")]))
usa <- usa[usa$STUSPS %in% c(sts),]
#################################################################
# III. Access the 'travel_times' function and obtain travel times
#################################################################
source(sprintf("https://docs.google.com/uc?id=%s&export=download", "1OMKoETbOqyXFm758k8vsFZrU8dX5mnmw"))
#This function renders an edgelist and a matrix
travel_times(origin, origin)
#################################################################
# IV. rad Function
#################################################################
#Source the function(s)
source(sprintf("https://docs.google.com/uc?id=%s&export=download",
 "1p-wJ9lPR3gq5LvJKMyDZHiM91T9y09E6"))
weight_mat <- rad(edgelistf, 46.6)
mt <- moran.test(origin$net_cost_attnd, weight_mat, zero.policy=TRUE)
#This resulted in 37 of the 133 units without neighbors
#################################################################
# V. Local Moran's I Plot
#################################################################
#label for x-axis and y-axis
label_x = "Net Cost Attendance"
label_y = "Lagged Net Cost Attendance"
mp <- moran.plot(origin$net_cost_attnd, weight_mat, zero.policy=T, labels=origin$UNITID,xlab = label_x, ylab = label_y)
title(main="Moran's Plot", cex.main=2, col.main="grey11", font.main=2, sub=paste("Plot includes 133 public 2-year colleges (Moran's I = ", round(mt$ estimate[1], 3), ", p < .0001)", sep=""),cex.sub=1.15, col.sub="grey11", font.sub=2,)
#################################################################
# VI. Load function to plot
#################################################################
source(sprintf("https://docs.google.com/uc?id=%s&export=download", "1AqvxPgRvTj0GxJItZpVFwjgwL-ruesyL"))
#Add coords object
coords<-cbind(origin$LONGITUD,origin$LATITUDE)
moran_points(y=origin$net_cost_attnd,shapefile=usa, moran_plot=mp, weight_mat=weight_mat, color="Accent", legend.pos="bottomright")
#Code ends
