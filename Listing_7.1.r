#Moran's I procedures
library(spdep)
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
# IV. Moran's I approximation via regression
#################################################################
#Crete lagged values
usa$lag.propbenft <- lag.listw(nqueenw, usa$propbenft)
#Estimate the coefficient associated with unit's I impact on its neighbor's performance
M1 <- lm(usa$lag.propbenft ~ usa$propbenft)
#What is the magnitude of this coefficient? Same as Moran's I?
summary(M1)
#Coefficients:
#              Estimate Std. Error t value Pr(>|t|)    
#(Intercept)   0.043730   0.006648   6.578 3.58e-08 ***
#usa$propbenft 0.493325   0.076104   6.482 5.00e-08 ***
#---
#Signif. codes:  0 *** 0.001 ** 0.01 * 0.05 . 0.1  1
#Meaning of this positive value
plot(usa$lag.propbenft ~ usa$propbenft, pch=20, asp=1, las=1)
abline(M1, col="blue")
#################################################################
# V. Moran's I p-value via Monte-Carlo simulations
#################################################################
#Monte-Carlo Simulations method
set.seed(47)
moran.mc(usa$propbenft, nqueenw, zero.policy=T, nsim=10000)
#        Monte-Carlo simulation of Moran I
#data:  usa$propbenft 
#weights: nqueenw
#number of simulations + 1: 10001 

#statistic = 0.49332, observed rank = 10001, p-value = 9.999e-05
#alternative hypothesis: greater

#Plotting reuslt Monte-Carlo Simulations method
plot(moran.mc(usa$propbenft, nqueenw, zero.policy=T, nsim=10000))
#Code Ends