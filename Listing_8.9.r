#Code Listing GW Procedures
#################################################################
# I. Load dataset including higher and lower level identifiers
#################################################################
pub2year <- read.csv(sprintf("https://docs.google.com/uc?id=%s&
export=download", "1edrhML0zMITE32zfWNcAIedD4agvN9bO"))
#################################################################
# II. Load one-mode matrix and apply transformation
#################################################################
mat <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=
download", "1mxA6tCZHiK6KuUWeCJuxn3pmFzTDXRWz"))
rownames(mat) <- mat$X
mat$X <- NULL
mat<-as.matrix(mat)
#################################################################
# III. Preparation
#################################################################
#These features were those identified with Boruta, we still recommend that identification, but is certainly not required
features <- c("prop_fac_fulltime_i", "prop_Pell_grant_i", "transf_rate_FTE_i", "White_i", "prop_part_time_i", "povunder50", "medincome", "singlemom", "prop_crime", "propbenft")
#Model has all the features created, but in addition includes the outcome of interest. The features and the predictors need to match for the function to work.
model <- as.formula(net_cost_attnd ~ prop_fac_fulltime_i + prop_Pell_grant_i + transf_rate_FTE_i + White_i + prop_part_time_i + povunder50 + medincome + singlemom + prop_crime + propbenft) 
#The function needs
#features: just identified above
#model: just identified above, 
#db database with "LONGITUD" and "LATITUDE" coordinates, names should match
#mat: matrix of distances or travel times, in this case is travel times
#################################################################
# IV. Source the Function and Execute the Summary Statistics
#################################################################
source(sprintf("https://docs.google.com/uc?id=%s&export=download", "1qBRtFkiuZICoy5YsrZuMUAYamcDX5GBs"))
#Execute
GW_summary(model=model, 
		   db=pub2year, 
		   mat=mat, 
		   features=features, 
		   multiscale.iterations = 100)
#################################################################
# V. Bootstrapped Regression Results. Are there significant variations?
#################################################################
GW_regression(model=model, 
			  db=pub2year, 
			  mat=mat, 
			  features=features, 
			  shapefile="states",#(other options are: zctas, counties, my.shapefile, and bounding.box)
			  shape.ID = "STUSPS",#key to be merged to be used with content of higher below
			  higher="state", 
			  number.simulations = 100)
#Code ends