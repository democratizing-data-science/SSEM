#Code Listing Geographical Network Visualizations one- & two-mode
#################################################################
# I. Load datasets 
#################################################################
#If you have two-mode data, you may need two datasets or one with all information of the two unit types
pub2year <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", "1edrhML0zMITE32zfWNcAIedD4agvN9bO"))
pubpriv4year <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", "1QDpwPoicEljBoQv18rIUz3uzh1ochf_4"))
#################################################################
# II. Matrix loading two-mode 
#################################################################
mat <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", "1ysKOT57XVKYrKwlna_ocLTnIqIM759Ky"))
#Recall we created this matrix in code Listing 8.5
rownames(mat) <- mat$X
mat$X <- NULL
#################################################################
# II. Source function and execute
#################################################################
source(sprintf("https://docs.google.com/uc?id=%s&export=download", "1QA1ZD7hbHmcfG52quvcoq2lU5z5dP7lO"))
geographical_networks(db=pub2year, #main mode data
	db2=pubpriv4year, #second mode data
	db.ID="UNITID", #ID column in db and db2
	y = "net_cost_attnd", #outcome of interest in db and db2
	higher="state", #column in db to join with shapefile
	lat="LATITUDE", #column in db and db2
	long="LONGITUD", #column in db and db2 
	mat=mat, #matrix of distance or travel times (two-mode)
	threshold=46.6, #threshold to detect neighbors
	shapefile="states",#zctas, counties, states, my.shapefile
	shape.ID="STUSPS", #if my.shapefile specify this column
	neighborless="Y", #plot units without neighbors Y or N
	link.label="Commuting times in minutes: ", #for link info
	unit.weight=20, #weight of units given number of neighbors
	link.weight=20) #width of link given travel times/distance
#################################################################
# III. Matrix loading One-mode 
#################################################################
mat <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", "1mxA6tCZHiK6KuUWeCJuxn3pmFzTDXRWz"))
rownames(mat) <- mat$X
mat$X <- NULL
#################################################################
# IV. Source function and execute
#################################################################
source(sprintf("https://docs.google.com/uc?id=%s&export=download", "1QA1ZD7hbHmcfG52quvcoq2lU5z5dP7lO"))
geographical_networks(db=pub2year, #main mode data
	db2=pub2year, #main mode data needed for columns of matrix
	db.ID="UNITID", #ID column in db and db2
	y = "net_cost_attnd", #outcome of interest in db and db2
	higher="state", #column in db to join with shapefile
	lat="LATITUDE", #column in db and db2
	long="LONGITUD", #column in db and db2
	mat=mat, #matrix of distance or travel times (one-mode)
	threshold=46.6, #threshold to detect neighbors
	shapefile="states", #zctas, counties, states, my.shapefile
	shape.ID="STUSPS", #if my.shapefile specify this column
	neighborless="Y", #plot units without neighbors Y or N
	link.label="Commuting times in minutes: ", #for link info
	unit.weight=20, #weight of units given number of neighbors
	link.weight=20) #width of link given travel times/distance
#Code Ends