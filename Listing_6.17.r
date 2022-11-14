#Nearby Selection
library(tigris)
options(tigris_use_cache = TRUE)
#################################################################
# I. Load roads shapefile and origin and destinations points
#################################################################
rds <- roads("PA", c("Philadelphia"))
origin <- read.csv(sprintf("https://docs.google.com/uc?id=%s&
export=download", "1PffhCIYGdYukuF3sdDTxCwYp5l6-v8lM"))
# Subsetting to only name, Long, and Lat
origin <- origin[origin$Name=="Whitehall Apts."|origin$Name=="Westpark Plaza"|origin$Name=="Spring Garden Apts."|origin$Name=="Raymond Rosen Manor",c("Name", "longitude","latitude")]
#College attended saved as UNITID
origin$UNITID <- NA
origin$UNITID[1] <- 215062
origin$UNITID[2] <- 215062
origin$UNITID[3] <- 211079
origin$UNITID[4] <- 166018
#State where students attended high school
origin$state <- "PA"
#College information
colleges <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", "14Z5Ypl7MbWz8ySFKtjOUPT9EKfU3mioT"))
destination <- colleges[colleges$UNITID==215062|colleges$UNITID==215239|colleges$UNITID==212054, c("UNITID", "LONGITUD", "LATITUDE")]
#make sure the pt object has three columns: 
#################################################################
# II. Append the origin and destination databases
#################################################################
colnames(origin)[1:3] <- c("ID","long","lat")
colnames(destination) <- c("ID","long","lat")
pt <- rbind(origin[,1:3], destination)
#################################################################
# III. Source the "as humans walk" function
#################################################################
#Function "humans_walk_batch" requires two elements:
#pt object with the points of interest public housing units and colleges
#rds sf object. 
#This function computes all steps as described in the chapter 
source(sprintf("https://docs.google.com/uc?id=%s&export=download", "1LMAB0OlBI7HzB5dt4jHtqAuE01782Sg8"))
#To use, you need two inputs, pt and rds, result will be a distance data frame and a matrix
(human_walk_dist<-humans_walk_batch(pt, rds))
#################################################################
# IV. Source and apply the "closest_n" function
#################################################################
#The function 'closest_n' requires the matrix of distances (likely resulting from the humans walk batch function or travel times) and a numeric input indicating the closest number of neighbors from the rows of this matrix.
source(sprintf("https://docs.google.com/uc?id=%s&export=download", "1xyZi187NfyP7v4-4VhnT3I8i7T9pke56"))
closest_n(mat, 3)
#################################################################
# V. Identify closest neighbors in the original file of interest
#################################################################
#Complex ID, this requires the combination of place & college ID
origin$nearby <- edgelist$order[match(paste(origin$ID,origin$UNITID), paste(edgelist$X1,edgelist$X2))]
origin$college_state <- colleges$STATE[match(origin$UNITID, colleges$UNITID)]
origin$out_state_outmig <- ifelse(origin$state!=origin$college_state, 1, ifelse(!is.na(origin$nearby), 0, NA))
origin$in_state_outmig <- ifelse((origin$state==origin$college_state)&(is.na(origin$nearby)), 1, ifelse(origin$out_state_outmig==1, NA, 0))
#Code ends