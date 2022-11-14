#Code Listing multilevel SAR with one and two-mode point data
#################################################################
# I. Load dataset including higher and lower level identifiers
#################################################################
pub2year <- read.csv(sprintf("https://docs.google.com/uc?id=%s&
export=download", "1edrhML0zMITE32zfWNcAIedD4agvN9bO"))
#Concatenate the list of features to be tested (this matches the features selected in Boruta:
features <- c("Intercept", "prop_fac_fulltime_i", "povunder50", "medincome", "unplymt", "noplumbing", "singlemom", "prop_crime",  "prop_Pell_grant_i", "transf_rate_FTE_i", "White_i", "prop_part_time_i", "propbenft")
#y = "net_cost_attnd"
#higher = "state"
#lower = "UNITID"
#shapefile = c("states","counties","zctas")
#db = pub2year
#Make sure your dataset has columns called LONGITUD and LATITUDE
#################################################################
# II. Matrix loading two-mode distances for SAR 
#################################################################
mat <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=
download", "1ysKOT57XVKYrKwlna_ocLTnIqIM759Ky"))
#Recall we created this matrix in code Listing 8.5
rownames(mat) <- mat$X
mat$X <- NULL
mat<-as.matrix(mat)
#################################################################
# III. Application to two-mode data
#################################################################
source(sprintf("https://docs.google.com/uc?id=%s&export=download", "1mmyCizxzAnLUBG9ETTqOjqlnEGVOZO7e"))
multilevel_SAR(y="net_cost_attnd", 
	features=features, 
	db=pub2year, 
	mat=mat, 
	shapefile="states", 
	shape.ID = "STUSPS", #only needed if using your own shapefile
	higher="state", 
	lower="UNITID", 
	dist_trT=46.6)
#################################################################
# IV. Creation of a one-mode matrix of travel times
#################################################################
pub2year <- read.csv(sprintf("https://docs.google.com/uc?id=%s&
export=download", "1edrhML0zMITE32zfWNcAIedD4agvN9bO"))
origin <- pub2year[ , c("UNITID","LONGITUD","LATITUDE")]
#Access the 'travel_times' function and obtain travel times
source(sprintf("https://docs.google.com/uc?id=%s&export=download"
, "1OMKoETbOqyXFm758k8vsFZrU8dX5mnmw"))
#This function renders an edgelist and a matrix
travel_times(origin, origin)
write.csv(matf, "trav_times_2-year.csv")
#Code Ends
#################################################################
# V. Application to one-mode data
#################################################################
#First load one-mode matrix and make sure step I is executed
mat <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=
download", "1mxA6tCZHiK6KuUWeCJuxn3pmFzTDXRWz"))
rownames(mat) <- mat$X
mat$X <- NULL
mat<-as.matrix(mat)
#Apply function using this new one-mode mat 
source(sprintf("https://docs.google.com/uc?id=%s&export=download", "1mmyCizxzAnLUBG9ETTqOjqlnEGVOZO7e"))

#If providing your own shapefile, save it as
# library(sf)
# my.shapefile <- st_read("G:\\My Drive\\my_own_shapefile.shp")

multilevel_SAR(y="net_cost_attnd", 
	features=features, #as defined in section I above
	db=pub2year, 
	mat=mat, 
	shapefile="states",
 	shape.ID = "STUSPS", #only needed if using your own shapefile
	higher="state", 
	lower="UNITID", 
	dist_trT=46.6)
#Code Ends