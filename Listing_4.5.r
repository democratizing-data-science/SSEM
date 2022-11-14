#Begin Census Tract Level Code Listing
#install.packages("tigris", dependencies = TRUE)
#install.packages("sf", dependencies = TRUE)
library(tigris)
library(sf)
#Stores data for faster access
options(tigris_use_cache = TRUE)

#################################################################
# I. Download shapefile
#################################################################
tract <- tracts(state=NULL, cb=TRUE) #73,868 polygons
tract <- tracts("PA", county = c("Philadelphia")) #restricted

#################################################################
# I. Download shapefile
#################################################################
plot(st_geometry(tract), lwd = 0.01, border = "grey11", bg="grey89", main="County Aggregate (N = 1)", cex.main=3, col="#969696", sub="Men and Women Mean College Access = 0.394 (SD = 0.267)", cex.sub=2)

#uncomment if needed
#source(sprintf("https://docs.google.com/uc?id=%s&export=download", "1fO8Pze1-GZ6fW7JHs3b1YkrPRAPXzO6J"))
plotCircle(-75.205, 39.9532, 3)#Plot circle 3 miles University City

#End Census Tract Level Code Listing