#Point Delimitation and Batch distance
library(stringr)
library(tigris)
library(sf)
#Stores data for faster access
options(tigris_use_cache = TRUE)
#################################################################
# I. Load zctairs data and pad its "zip" column
#################################################################
#This is IPEDS IRS ZCTA CO dataset (see code Listing 4.17)
pt <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", "14Z5Ypl7MbWz8ySFKtjOUPT9EKfU3mioT"))
#################################################################
# II. Make the points file a sf object
#################################################################
# Access Philadelphia county
co <- counties("PA") #Limits the counties to Pennsylvania
co <- co[co$NAME=="Philadelphia", ]
#Transform
pt <- st_as_sf(x = pt,
coords = c("LONGITUD", "LATITUDE"),
crs=st_crs(co))
#################################################################
# III. Keep Only Points Inside Philadelphia county
#################################################################
#Remove Points Outside Philadelphia county, first source the function described in code Listing 4.10
source(sprintf("https://docs.google.com/uc?id=%s&export=download", "1fDnDVPVexfDi77IzaFHEQWS8TDIaW9Le"))
rmv_obj_outside(high_level=co, low_level=pt)
#Function retunrs an object called "sec_object_trim" so, save as pt again
pt <- sec_object_trim
pt <- pt[pt$SECTOR<3|pt$SECTOR==4, ]
#################################################################
# IV. Retrieve "pt" geocoded data frame for function & load roads
#################################################################
pt<-data.frame(ID=pt$UNITID, long=st_coordinates(pt)[,1],lat=st_coordinates(pt)[,2] )
rds <- roads("PA", c("Philadelphia"))#, class="sp")
#################################################################
# V. Source and Apply the function
#################################################################
source(sprintf("https://docs.google.com/uc?id=%s&export=download", "1LMAB0OlBI7HzB5dt4jHtqAuE01782Sg8"))
#To use, you need two inputs, pt and rds, result will be a distance data frame and a matrix
(human_walk_dist<-humans_walk_batch(pt, rds))
#Code ends