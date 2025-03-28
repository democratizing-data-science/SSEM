#Batch Distances As Humans Walk Two Types
library(tigris)
options(tigris_use_cache = TRUE)
#################################################################
# I. Load roads shapefile and origin and destinations points
#################################################################
rds <- roads("PA", c("Philadelphia"))
origin <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", "1PffhCIYGdYukuF3sdDTxCwYp5l6-v8lM"))
# Subsetting to only name, Long, and Lat
origin <- origin[origin$Name=="Whitehall Apts."|origin$Name=="Westpark Plaza"|origin$Name=="Spring Garden Apts."|origin$Name=="Raymond Rosen Manor",c("Name", "longitude","latitude")]
destination <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", "14Z5Ypl7MbWz8ySFKtjOUPT9EKfU3mioT"))
destination <- destination[destination$UNITID==215062|destination$UNITID==215239|destination$UNITID==212054, c("UNITID", "LONGITUD", "LATITUDE")]
#make sure the pt object has three columns: 
#################################################################
# I. Append the origin and destination databases
#################################################################
colnames(origin) <- c("ID","long","lat")
colnames(destination) <- c("ID","long","lat")
pt <- rbind(origin, destination)
#################################################################
# III. Source the function
#################################################################
#Function "humans_walk_batch" requires two elements:
#pt object with the points of interest public housing units and colleges
#rds sf object. 
#This function computes all steps as described in the chapter 
source(sprintf("https://docs.google.com/uc?id=%s&export=download", "1LMAB0OlBI7HzB5dt4jHtqAuE01782Sg8"))
#To use, you need two inputs, pt and rds, result will be a distance data frame and a matrix
(human_walk_dist<-humans_walk_batch(pt, rds))
#Example of results shown in this code Listing
                    X1     X2 walkg_dist
1      Whitehall Apts. 215062   9.862289
2      Whitehall Apts. 212054   9.423974
3      Whitehall Apts. 215239   7.617817
4       Westpark Plaza 215062   2.194310
5       Westpark Plaza 212054   2.244887
6       Westpark Plaza 215239   3.779508
7  Spring Garden Apts. 215062   3.185044
8  Spring Garden Apts. 212054   2.820927
9  Spring Garden Apts. 215239   1.043083
10 Raymond Rosen Manor 215062   3.692746
11 Raymond Rosen Manor 212054   3.230734
12 Raymond Rosen Manor 215239   2.247852
> mat
                      215062   212054   215239
Whitehall Apts.     9.862289 9.423974 7.617817
Westpark Plaza      2.194310 2.244887 3.779508
Spring Garden Apts. 3.185044 2.820927 1.043083
Raymond Rosen Manor 3.692746 3.230734 2.247852
#Code ends
