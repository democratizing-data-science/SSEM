#From Polygons to Neighbors
library(spdep)
library(tigris)
options(tigris_use_cache = TRUE)
#################################################################
# I. Load a polygons shapefile, the United Stats in this Case 
#################################################################
states <- states()
"%ni%" <- Negate("%in%")
#Limit the identification to the contiguous Unites States
states<-states[states$NAME %ni% c('Alaska','American Samoa','Commonwealth of the Northern Mariana Islands','Guam','Hawaii','United States Virgin Islands','Puerto Rico'),]
#Get coordinates for plotting
coords<-(cbind(as.numeric(states$INTPTLON), as.numeric(states$INTPTLAT)))
#################################################################
# II. Apply Rook's 
#################################################################
nrook<-poly2nb(states, queen=FALSE)
plot(st_geometry(states), border="grey", main="Rook's Method")
plot(nrook, coords, add=TRUE)
#################################################################
# III. Apply Queen's 
#################################################################
nqueen<-poly2nb(states, queen=TRUE)
plot(st_geometry(states), border="grey", main="Queen's Method")
plot(nqueen, coords, add=TRUE, col="magenta")
#################################################################
# IV. Differences Between Rook's and Queen's 
#################################################################
plot(st_geometry(states), border="grey", main="Comparison")
plot(nqueen, coords, add=TRUE, col="magenta")
plot(nrook, coords, add=TRUE)
#Highlighting states when differences took place 
plot(st_geometry(states[states$STUSPS %in% c("AZ","UT","CO","NM"),]), border="blue", add=TRUE)
#Code ends