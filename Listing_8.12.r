#Code Listing Panel SAR DiD Procedures
library(tigris)
library(stringr)
options(tigris_use_cache = TRUE)
#################################################################
# I. Load datasets including shapefile
#################################################################
panel_data <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=
download", "1vuBGEmHnnqe3Hm982t6cLER-UH5BdjJM"))
#Some leading zeroes may have lost, so we need to pad
panel_data$GEOID<-str_pad(panel_data$GEOID, 11, pad = "0")
#Download the shapefile at the tract level
my.shape.file<-tracts("CA", county = c("053", "069", "081", "085", "087"))
#################################################################
# II. Model preparation and element identification
#################################################################
modelwomen <- formula(prop_18_24_access_female ~ time + tr + I(time*tr))
modelmen <- formula(prop_18_24_access_male ~ time + tr + I(time*tr))
#elements:
#model: This does not need to follow the DiD framework (i.e, interaction)
#db: longitudinal or repeated cross-sectional data with ID and Time indicators
#shapefile: Our shapefile, read in sf format (the default of tigris)
#shape.ID: The key indicator to allow joining the db and the shapefile
#db.ID: The key indicator to allow joining the db and the shapefile
#db.time: The raw time indicator (i.e., year, days, months, hours) required to balance the database and match this balance with the shapefile.
#################################################################
# III. Function Access and model fit
#################################################################
source(sprintf("https://docs.google.com/uc?id=%s&export=download", "1vpKRVfbSeRcLwN6XYPp7IKfxfReTgVEG"))
# To execute the analyses for men and women, we need to execute the function twice, one with the formula for modelwomen and the other for the formula modelmen
panel_SAR(model=modelwomen, db=panel_data, shapefile=my.shape.file, shape.ID="GEOID", db.ID="GEOID", db.time="year")
panel_SAR(model=modelmen, db=panel_data, shapefile=my.shape.file, shape.ID="GEOID", db.ID="GEOID", db.time="year")
#################################################################
# IV. Placebo Tests
#################################################################
#Eliminate the time data and subset the db to the pre-change time
panel_data$time<-NULL
panel_data <- panel_data[panel_data$year<2012,]
#Create the new time indicator having 2009 as the pre-time and 2010 and 2011 as the false post-time (other configurations may be obtained)
panel_data$time <- ifelse(panel_data$year==2009, 0, 1)
#Code Ends