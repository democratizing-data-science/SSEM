#Code Listing multilevel SAR with one and two-mode point data
#################################################################
# I. Load dataset of points 
#################################################################
#Data collected a of August 26, 2022
mig_deaths <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", "1PWkmGzt5UcTssqNXtBJ2glLVfI4_uA4Y"))
#Live dataset obtained from https://humaneborders.info/app/map.asp
#This dataset is updated constantly
mig_deaths<-read.csv("https://humaneborders.info/app/getTableByMultipleSearch.asp?sex=&cod=&county=&corridors=&sm=&years=&name=&detail=full&format=csv")

#Add a title for static plots
plot.title = "Body Locations"
#If a more informative ID is wanted:
mig_deaths$new.ID <- paste("Sex: ", mig_deaths$Sex, 
"Age: ", mig_deaths$Age, 
"Cause: ", mig_deaths$Cause.of.Death, 
"Date: ", mig_deaths$Reporting.Date)

mig_deaths$Death_Cause <- ifelse(mig_deaths$Cause.of.Death=="Blunt Force Injury"|mig_deaths$Cause.of.Death=="Gunshot Wound"|mig_deaths$Cause.of.Death=="Other Injury / Homicide"|mig_deaths$Cause.of.Death=="Asphyxia", "Assassinated", 
ifelse(mig_deaths$Cause.of.Death=="Exposure"|mig_deaths$Cause.of.Death=="Drowning"|mig_deaths$Cause.of.Death=="Lightning Strike"|mig_deaths$Cause.of.Death=="Heart Disease", "Exposure_Hardship", 
ifelse(mig_deaths$Cause.of.Death=="Undetermined"|mig_deaths$Cause.of.Death=="Skeletal Remains", "Undetermined.Unknown", "Other")))
#################################################################
# III. Source and application of function
#################################################################
source(sprintf("https://docs.google.com/uc?id=%s&export=download", "1Pnqw3eslk0fnYYn0XALSyKJcf_WNi06t"))
point_density(db=mig_deaths, 
	db.ID="new.ID", 
	Cat.Analysis="Death_Cause",#Option "NULL"
	plot.title=plot.title, 
	shapefile="zctas",# states, zctas, counties my.shapefile
	class=5, HTML="N", # or Y
	radius = 50, 
	grid.size = 50/10,
	long = "Longitude", #column in db
	lat = "Latitude")   #column in db
#Code Ends
