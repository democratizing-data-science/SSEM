#################################################################
# I. Load datasets including shapefile
#################################################################
spatio_panel_visual <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", "1vuBGEmHnnqe3Hm982t6cLER-UH5BdjJM"))
#Some leading zeroes may have lost, so we need to pad
panel_data$GEOID<-str_pad(panel_data$GEOID, 11, pad = "0")
#Download the shapefile at the tract level
my.shape.file<-tracts("CA", county = c("053", "069", "081", "085", "087"))
#################################################################
# II. Identify features, source the function and execute
#################################################################
#All features of interest
features <- c("prop_18_24_access_male","prop_18_24_access_female")
#Source the function
source(sprintf("https://docs.google.com/uc?id=%s&export=download", "1ZDer8rC-Yi-ZVlK6OWXVznBNUrN4hNqJ"))
#Execute the function
visual_panel(db=panel_data, #database with time and ID
	features=features, #indicators to be ploted by year
	shapefile=my.shape.file, #loaded locally or from tigris
	shape.ID="GEOID", #ID to be merged with db ID
	db.ID="GEOID", #ID to be merged with shapefile ID
	db.time="year", #Year column in db
	HTML="N", #Whether static N, or HTML Y should be rendered
	class=5) #Number of classes for the features to map
#Code Ends