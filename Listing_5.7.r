#Batch Distances As Humans Walk One Type
library(tigris)
options(tigris_use_cache = TRUE)
#################################################################
# I. Load roads shapefile and point IPEDS data (One Type)
#################################################################
rds <- roads("PA", c("Philadelphia"))
#This is IPEDS IRS ZCTA CO dataset (see code Listing 4.17)
pt <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", "14Z5Ypl7MbWz8ySFKtjOUPT9EKfU3mioT"))
#################################################################
# II. Subsetting to Three Schools in Philadelphia County
#################################################################
pt <- pt[pt$UNITID==215062|pt$UNITID==215239|pt$UNITID==212054, c("UNITID", "LONGITUD", "LATITUDE")]
#make sure the pt object has three columns: 
#"UNITID", "LONGITUD", "LATITUDE"
#################################################################
# III. Source the function
#################################################################
#Function "humans_walk_batch" requires two elements:
#pt object with the points of interest (here CCP, UPenn, and Drexel)
#rds sf object. 
#This function computes all steps as described in the chapter 
source(sprintf("https://docs.google.com/uc?id=%s&export=download", "1LMAB0OlBI7HzB5dt4jHtqAuE01782Sg8"))
#To use, you need two inputs, pt and rds, result will be a distance data frame and a matrix
(human_walk_dist<-humans_walk_batch(pt, rds))
#Code ends
