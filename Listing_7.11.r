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
#################################################################
# IV. Removing Neighborless Units
#################################################################
sub_matw <- subset(weight_mat[[2]], subset=card(weight_mat[[2]]) > 0)
sub_matw
#making coordinates numeric
origin$LATITUDE <- as.numeric(origin$LATITUDE)
origin$LONGITUD <- as.numeric(origin$LONGITUD)
#making this a spatial points dataframe
coordinates(origin) <- c("LONGITUD", "LATITUDE")
origin_sub <- subset(origin, subset=card(weight_mat[[2]]) > 0)
mt <- moran.test(origin_sub$net_cost_attnd, nb2listw(sub_matw))
mt
        Moran I test under randomisation

data:  origin_sub$net_cost_attnd  
weights: nb2listw(sub_matw, zero.policy = TRUE)    

Moran I statistic standard deviate = 4.3617, p-value = 6.454e-06
alternative hypothesis: greater
sample estimates:
Moran I statistic       Expectation          Variance 
      0.394998525      -0.010526316       0.008644272 