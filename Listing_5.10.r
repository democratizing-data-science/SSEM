#Travel times
# install.packages("osrm")
library(osrm)
library(igraph)
#################################################################
# I. Load housing (origin) data and IPEDS (destination) data
#################################################################
#This is IPEDS IRS ZCTA CO dataset (see code Listing 4.17)
pt <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", "14Z5Ypl7MbWz8ySFKtjOUPT9EKfU3mioT"))
housing <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", "1PffhCIYGdYukuF3sdDTxCwYp5l6-v8lM"))
#################################################################
# II. Subsetting to only schools in PA and Name, Long, and Lat, 
#################################################################
destination<-pt[pt$STATE=="PA",c("INSTNM", "LONGITUD", "LATITUDE")]
#################################################################
# III. Subsetting to only name, Long, and Lat
#################################################################
origin<-housing[,c("Name", "longitude","latitude")]
#################################################################
# IV. Source the 'time_distances' function
#################################################################
source(sprintf("https://docs.google.com/uc?id=%s&export=download", "1OMKoETbOqyXFm758k8vsFZrU8dX5mnmw"))
#################################################################
# V. Apply origin to destination
#################################################################
# This function requires the two objects configured by different units. It automatically saves two products:
# 1. The edgelist with three columns name of origin, name of destination and travel distance
# 2. Matrix of origin in the rows and destinations in the columns (rectangular matrix)
travel_times(origin, destination)
#################################################################
# VI. Apply origin to origin
#################################################################
# This function requires the two objects (those in the origin) configured by the same units. It automatically saves two products:
# 1. The edgelist with three columns name of origin i, name of origin j, and travel distance
# 2. Matrix of origins in the rows and origins in the columns (square matrix)
travel_times(origin, origin)
#################################################################
# VII. Apply destination to destination
#################################################################
# This function requires the two objects (those in the destination) configured by the same units. It automatically saves two products:
# 1. The edgelist with three columns name of destination i, name of destination j, and travel distance
# 2. Matrix of destinations in the rows and destinations in the columns (square matrix)
travel_times(destination, destination)
#Code ends
