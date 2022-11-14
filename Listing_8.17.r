#Load package
library(spatialreg)
#Estimate empty model
SAR_null <- spatialreg::spautolm(formula = pub_no ~ 1, data = ydata, coauthorsw, zero.policy = TRUE)
#Source function
source(sprintf("https://docs.google.com/uc?id=%s&export=download"
, "1ZKEeAobCnOublGDzO4oGmaTe7G9PgrK9"))
#Assess whether RSODA.20 was handled
SAR_res_test(SAR_null, coauthorsw)
#        Monte-Carlo simulation of Moran I
#data:  resid(model) 
#weights: listw  
#number of simulations + 1: 10001 
#statistic = -0.0042772, observed rank = 4163, p-value = 0.5837
#alternative hypothesis: greater
#Code Ends