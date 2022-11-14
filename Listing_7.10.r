#Two mode point neighbor identification and Local analyses
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
#save values for plotting below
#################################################################
# V. Local Moran's I Plot
#################################################################
mt <- moran.test(origin$net_cost_attnd, weight_mat, zero.policy = TRUE)
#label for x-axis and y-axis
label_x = "Net Cost Attendance"
label_y = "Lagged Net Cost Attendance"
mp <- moran.plot(origin$net_cost_attnd, weight_mat, zero.policy=T, labels=origin$UNITID,xlab = label_x, ylab = label_y)
title(main="Moran's Plot", cex.main=2, col.main="grey11", font.main=2, sub=paste("Plot includes 133 public 2-year colleges (Moran's I = ", round(mt$ estimate[1], 3), ", p < .0001)", sep=""),cex.sub=1.15, col.sub="grey11", font.sub=2,)
#################################################################
# VI. Access shapefile and subset
#################################################################
usa <- states()
sts <- names(table(pts[pts$REGION==1|pts$REGION==2, c("STABBR")]))
usa <- usa[usa$STUSPS %in% c(sts),]
#################################################################
# VII. Load function to plot
#################################################################
source(sprintf("https://docs.google.com/uc?id=%s&export=download", "1AqvxPgRvTj0GxJItZpVFwjgwL-ruesyL"))
#Add coords object
coords<-cbind(origin$LONGITUD,origin$LATITUDE)
moran_points(y=origin$net_cost_attnd,shapefile=usa, moran_plot=mp, weight_mat=weight_mat, color="Accent", legend.pos="bottomright")
#Code ends
