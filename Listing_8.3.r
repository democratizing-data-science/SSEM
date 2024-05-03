#SAR State Level
library(spdep)
library(spatialreg)
library(tigris)
options(tigris_use_cache = TRUE)
#################################################################
# I. Load polygons shapefile and the State level IRS database 
#################################################################
usa <- states()
"%ni%" <- Negate("%in%")
irs_state <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", "10MOXrw2H_QN3rCsqvXIKQtiJ9c0yGJH5"))
#################################################################
# II. Load ZCTA ACS and County Data (code Listing 4.17)
#################################################################
zcta <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", "1-j6EEHeaOvlP3V5QZamG4z3-u0iv6ExM"))
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
# V. Run Empty SAR and Observe Lambda Value
#################################################################
SAR_null <- spatialreg::spautolm(formula = propbenft ~ 1, data = usa, nqueenw, zero.policy=TRUE)
summary(SAR_null)
#Residuals:
#        Min          1Q      Median          3Q         Max 
#-0.02332722 -0.00937051  0.00011146  0.00671071  0.02327471 
#Coefficients: 
#             Estimate Std. Error z value  Pr(>|z|)
#(Intercept) 0.0853743  0.0053039  16.097 < 2.2e-16
#Lambda: 0.67137 LR test value: 20.883 p-value: 4.8825e-06 
#Numerical Hessian standard error of lambda: 0.11308 
#Log likelihood: 143.0463 
#ML residual variance (sigma squared): 0.00014887, (sigma: 0.012201)
#Number of observations: 49 
#Number of parameters estimated: 3 
#AIC: -280.09
#################################################################
# VI. Source SAR_res_test function to assess if residuals are iid
#################################################################
#Source function to test for residuals using Monte Carlo simulations
source(sprintf("https://docs.google.com/uc?id=%s&export=download"
, "1ZKEeAobCnOublGDzO4oGmaTe7G9PgrK9"))
SAR_res_test(SAR_null, nqueenw)
#        Monte-Carlo simulation of Moran I
#data:  resid(model) 
#weights: listw  
#number of simulations + 1: 10001 
#statistic = -0.045348, observed rank = 4181, p-value = 0.5809
#alternative hypothesis: greater
#Code ends
