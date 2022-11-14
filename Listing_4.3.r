#Begin County Level Code Listing
library(sf)
library(tigris)
options(tigris_use_cache = TRUE)

#################################################################
# I. download shapefile
#################################################################
co <- counties() #Downloads 3233 counties
co <- counties("PA") #Limits the counties to Pennsylvania
co <- co[co$NAME=="Philadelphia", ] #Limits county to Philladelphia

#################################################################
# II. Can merge co with usa as in Figure 2.1
#################################################################
#If needed execute 
#usa <- states()

#We need a function to plot a circle with a given circumference 
#We downloaded with the function "source"
source(sprintf("https://docs.google.com/uc?id=%s&export=download", "1fO8Pze1-GZ6fW7JHs3b1YkrPRAPXzO6J"))

par(mfrow=c(1,2))
plot(st_geometry(usa[usa$NAME=="Pennsylvania"|usa$NAME=="New Jersey" | usa$NAME=="New York",]), 
lwd = 0.01, border = "grey11", bg="grey89", main="Tristate Area, Circled area: Philadelphia County, PA", cex.main=1.5)
plot(st_geometry(co), border = "red", bg="grey11", add=T)

#PlotCircle needs the coordinates of interest (longitude and latitude) and the radius distance in miles from that point
plotCircle(-75.1, 39.99, 15)#Plot a dashed circle of 15 miles around
plot(st_geometry(co), lwd = 0.01, border = "grey11", bg="grey89", main="Zooming in into Philadelphia County, PA", cex.main=1.5)# phudcfIlY

#End County Level Code Listing