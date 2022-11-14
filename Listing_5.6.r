library(tigris)
loptions(tigris_use_cache = TRUE)
#################################################################
# I. Load roads shapefile and point IPEDS data 
#################################################################
rds <- roads("PA", c("Philadelphia"))
#This is IPEDS IRS ZCTA CO dataset (see code Listing 4.17)
pt <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", "14Z5Ypl7MbWz8ySFKtjOUPT9EKfU3mioT"))
#################################################################
# II. Subsetting to only two schools UPenn and CCP
#################################################################
pt <- pt[pt$UNITID==215062|pt$UNITID==215239, c("UNITID", "LONGITUD", "LATITUDE")]
#################################################################
# III. Source the function
#################################################################
#Function "humans_walk_two" requires two elements:
#pts sf object with the points of interest (here CCP and UPenn)
#rds sf object. 
#This function computes all steps as described below 
source(sprintf("https://docs.google.com/uc?id=%s&export=download", "1JOfpFXZeA85WA7JyE_9Y0jUqCD3sgRkk"))
#To use, you need two inputs, pts and rds, result will be a distance data frame
(as_human_walk_dist<-humans_walk_two(pt, rds))
#Code ends
