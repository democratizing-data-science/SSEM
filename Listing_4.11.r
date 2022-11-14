#Begin Points Code Listing
library(tigris)
library(sf)
#Stores data for faster access
options(tigris_use_cache = TRUE)

#################################################################
# I. Download shapefile
#################################################################
pt <- landmarks(state="PA", type = "point", year=2021)

#################################################################
# II. Read the MTFCC Code File To Limit to Schools 
#################################################################
#Stored in a secure served file was retrieved from Appendix E in TIGER/Line Shapefiles 2021: Technical Documentation
mtfcc <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", "1omNjgPQPM8aQ6AQgjC8UnicJBhx_9rZN"))

#################################################################
# III. Join Using the Match Function Given the Empasis on one X
#################################################################
pt$type <- mtfcc$Feature.Class[match(pt$MTFCC, mtfcc$MTFCC)]
pt <- pt[pt$type=="School or Academy",]

#################################################################
# IV. Plotting and Cropping
#################################################################
par(mfrow=c(1,2))
usa<-states()

plot(st_geometry(usa[usa$NAME=="Pennsylvania",]), main="Pennsylvania", sub="Schools or Academies (N = 227)")
plot(st_geometry(pt), add = TRUE, col="#CD1076")
#Apply the function "st-bbox" to crop the rds object to Philadelphia county using dhe object "co"

#Get Philadelphia county
co <- counties("PA") #Limits the counties to Pennsylvania
co <- co[co$NAME=="Philadelphia", ]
pt <-st_crop(pt, st_bbox(co))

plot(st_geometry(co), main="Only Philadelphia County", sub="Schools or Academies (N = 21)")
plot(st_geometry(pt), add = TRUE, col="#CD1076")

#End Points Code Listing