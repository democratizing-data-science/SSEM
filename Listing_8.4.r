#Addressing Multicollinearity with Boruta for SAR State Level
library(spdep)
library(spatialreg)
library(tigris)
options(tigris_use_cache = TRUE)
#################################################################
# I. Load polygons shapefile and the State level IRS database 
#################################################################
usa <- states()
"%ni%" <- Negate("%in%")
irs_state <- read.csv(sprintf("https://docs.google.com/uc?id=%s&
export=download", "10MOXrw2H_QN3rCsqvXIKQtiJ9c0yGJH5"))
#################################################################
# II. Load ZCTA ACS and County Data (code Listing 4.17)
#################################################################
zcta <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export
=download", "1-j6EEHeaOvlP3V5QZamG4z3-u0iv6ExM"))
head(zcta)
#Aggregate at the state level
acs_state <- aggregate(cbind(povunder50, medincome, unplymt, noplumbing, singlemom, MediIncome, prop_crime) ~ state, data=zcta, FUN=mean)
#Join IRS and ACS
irs_acs_state <- merge(irs_state, acs_state, by.x="STATE", by.y="state")
#################################################################
# III. Remove states with no boundary-based neighbors and join 
#################################################################
#Removing disconnected states
usa <- usa[usa$NAME %ni% c("Hawaii","Alaska"),]
#Joining datasets, the inner option removes units with no match
usa <- geo_join(usa, irs_acs_state, "STUSPS", "STATE", how="inner")
#################################################################
# IV. Create neighborhood list and matrix of weights
#################################################################
#usa is our polygon shapefile with attributes of interest
nqueen <- poly2nb(usa, queen=TRUE)
#using the neighborhood list, create rowstandardized weights
nqueenw <- nb2listw(nqueen, style="W", zero.policy=T)
#################################################################
# V. Source the 'boruta_html' function and apply
#################################################################
source(sprintf("https://docs.google.com/uc?id=%s&export=download"
, "1bbIAdZkWUmwO_GSHC7ZDninb7hgtlb4_"))
#To use provide the name of outcome of interes as follows
y = "propbenft"
#Additionally, concatenate the list of features to be tested:
features <- c("povunder50", "medincome", "unplymt", "noplumbing", "singlemom", "prop_crime")
#Finally, provide the database name as db=usa in our case.
#Optional: you can set the name of the outcome to be displayed in the HTML plot with
name_html_plot <- "Proportion of SLID Beneficiaries"
#The number of runs to assess relevance is 1000, you can change it with maxIterations=number
#Execute
boruta_html(y=y, features=features, db=usa, maxIterations=1000)
#Outputs are two plots, one static in R and one interactive in HTML 
#(see https://rpubs.com/msgc/SAR_Boruta_State)			
#################################################################
# VI. SAR Models
#################################################################
#Empty model for comparison
SAR_null <- spatialreg::spautolm(formula = propbenft ~ 1, data =	usa, nqueenw, zero.policy=TRUE)
summary(SAR_null)
#Full model which may include multicollinearity issues
SAR_full <- spatialreg::spautolm(formula = propbenft ~ povunder50 + medincome + unplymt + noplumbing + singlemom + prop_crime, data =	usa, nqueenw, zero.policy=TRUE)
SAR_Boruta <- spatialreg::spautolm(formula = propbenft ~ povunder50 + medincome + unplymt + noplumbing + singlemom =	usa, nqueenw, zero.policy=TRUE)
#################################################################
# VII. Testing RSODA of Three Models
#################################################################
source(sprintf("https://docs.google.com/uc?id=%s&export=download"
, "1ZKEeAobCnOublGDzO4oGmaTe7G9PgrK9"))
par(mfrow=c(1,3))
SAR_res_test(SAR_null, nqueenw)
SAR_res_test(SAR_full, nqueenw)
SAR_res_test(SAR_Boruta, nqueenw)
#Code Ends
	