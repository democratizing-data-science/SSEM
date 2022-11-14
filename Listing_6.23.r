#Higher Order Neighbors
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
# II. Apply Queen's 
#################################################################
nqueen<-poly2nb(states, queen=TRUE)
> nqueen
Neighbour list object:
Number of regions: 49 
Number of nonzero links: 224 
Percentage nonzero weights: 9.329446 
Average number of links: 4.571429 
#################################################################
# III. Apply Second Order to Queen's as an Input 
#################################################################
second_order_n <- nblag(nqueen, maxlag=2)
> second_order_n 
[[1]]
Neighbour list object:
Number of regions: 49 
Number of nonzero links: 224 
Percentage nonzero weights: 9.329446 
Average number of links: 4.571429 

[[2]]
Neighbour list object:
Number of regions: 49 
Number of nonzero links: 372 
Percentage nonzero weights: 15.49354 
Average number of links: 7.591837 
#################################################################
# III. Plotting and comparing
#################################################################
plot(st_geometry(states), border="grey", main="Queen's Input
with Second Order Neighbors")
plot(nqueen, coords, add=TRUE)
plot(second_order_n[[2]], coords, add=TRUE, col="magenta")
#To zoom in in Maine's case
#plot(st_geometry(states[states$NAME %in% c("Maine", "New Hampshire", "Vermont", "Massachusetts"),]), border="grey", main="Queen's Method
#with Second order")
#plot(nqueen, coords, add=TRUE)
#plot(second_order_n[[2]], coords, add=TRUE, col="magenta")
#Code Ends