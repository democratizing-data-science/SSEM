#Regression and Moran's I
library(spdep)
library(tigris)
options(tigris_use_cache = TRUE)
#################################################################
# I. Load polygons shapefile and the State level IRS database 
#################################################################
usa <- states()
"%ni%" <- Negate("%in%")
irs_state <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", "10MOXrw2H_QN3rCsqvXIKQtiJ9c0yGJH5"))
#################################################################
# II. Remove states with no boundary-based neighbors and join 
#################################################################
#Removing disconnected states
usa <- usa[usa$NAME %ni% c("Hawaii","Alaska"),]
#Joining datasets, the inner option removes units with no match
usa <- geo_join(usa, irs_state, "STUSPS", "STATE", how="inner")
#################################################################
# III. Create neighborhood list and matrix of weights
#################################################################
#usa is our polygon shapefile with attributes of interest
nqueen <- poly2nb(usa, queen=TRUE)
#using the neighborhood list, create rowstandardized weights
nqueenw <- nb2listw(nqueen, style="W", zero.policy=T)
#################################################################
# IV. Moran's I approach
#################################################################
#First test for spatial dependence, analytic/frequentist method
moran.test(usa$propbenft, nqueenw, zero.policy=T)
#Moran I statistic standard deviate = 5.3667, p-value = 4.01e-08
#alternative hypothesis: greater
#sample estimates:
#Moran I statistic       Expectation          Variance 
#      0.493324878      -0.020833333       0.009178733
#################################################################
# V. Empty OLS regression model
#################################################################
model1 <- lm(formula = propbenft ~ 1, data = usa)
#we can manually retrieve the residuals from this model as
res<-residuals(model1)
#################################################################
# VI. Residual Autocorrelation 
#################################################################
#and then proceed to test for residual dependence
moran.test(res, nqueenw, zero.policy=TRUE)
#Moran I statistic standard deviate = 5.3667, p-value = 4.01e-08
#alternative hypothesis: greater
#sample estimates:
#Moran I statistic       Expectation          Variance 
#      0.493324878      -0.020833333       0.009178733 
#Alternatively, although the result is the same, we can rely on a 
#Moran's I call desgined to work with regression residuals
lm.morantest(model1, nqueenw, zero.policy=TRUE)
#model: lm(formula = propbenft ~ 1, data = usa)
#weights: nqueenw
#Moran I statistic standard deviate = 5.4143, p-value = 3.076e-08
#alternative hypothesis: greater
#sample estimates:
#Observed Moran I      Expectation         Variance 
#     0.493324878     -0.020833333      0.009017862 
#Notably, the exact same result if obtained with the original outcome variable
#################################################################
# VI. Should error term be modeled?
#################################################################
lm.LMtests(model1, nqueenw, zero.policy=TRUE)
#model: lm(formula = propbenft ~ 1, data = usa)
#weights: nqueenw
#LMErr = 24.543, df = 1, p-value = 7.269e-07
#Code Ends
