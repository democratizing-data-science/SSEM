#Code Listing SAR with two-mode point data
library(spdep)
library(spatialreg)
#################################################################
# I. Load datasets including travel time matrix
#################################################################
pub2year <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", "1edrhML0zMITE32zfWNcAIedD4agvN9bO"))
mat <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", "1ysKOT57XVKYrKwlna_ocLTnIqIM759Ky"))
#Check order is the same if not, adjust
table(mat$X==pub2year$UNITID)
#TRUE 
# 799
rownames(mat) <- mat$X 
mat$X <- NULL
mat<-as.matrix(mat)
#################################################################
# II. Network Transformations
#################################################################
#Rows are public 2-year institutions, columns are 4-year colleges
#Identify neighboring structures using commuting by bus time
mat <- ifelse(mat > 46.6, 0, ifelse(mat > 0, 1, mat))
#Transformation
mat <- mat%*%t(mat)
#Save diagonal info
numb_neigh <- diag(mat)
#Capture neighbors number
pub2year$numb_neigh <- diag(mat)[match(pub2year$UNITID, rownames(mat))]
#Remove diagonal
diag(mat) <- 0
#Create a weight
mat <- round(mat/rowSums(mat),5)
#Replace missing with zeroes
mat [is.na(mat)]<-0
#With 46.6 minutes as the threshold, 356 units remained disconnected should we remove them?
table(rowSums(mat)==0)
# Create weight matrix
weight_mat <- mat2listw(mat)
#################################################################
# III. Traditional Moran's I structure with first order neighbors
#################################################################
moran.test(pub2year$net_cost_attnd, weight_mat, zero.policy=TRUE)
#Moran I statistic standard deviate = 3.0816, p-value = 0.001029
#alternative hypothesis: greater
#sample estimates:
#Moran I statistic       Expectation          Variance 
#      0.129707241      -0.002262443       0.001833976 
#################################################################
# IV. Moran's I After Removing neighborless Units
#################################################################
sub_matw <- subset(weight_mat[[2]], subset=card(weight_mat[[2]])> 0)
sub_matw
#making this a spatial points dataframe
coordinates(pub2year) <- c("LONGITUD", "LATITUDE")
pub2year_sub <- subset(pub2year, subset=card(weight_mat[[2]]) > 0)
moran.test(pub2year_sub$net_cost_attnd, nb2listw(sub_matw))
#Moran I statistic standard deviate = 5.0593, p-value = 2.104e-07
#alternative hypothesis: greater
#sample estimates:
#Moran I statistic       Expectation          Variance 
#      0.208866757      -0.002262443       0.001741451
#################################################################
# V. Boruta Procedures
#################################################################
source(sprintf("https://docs.google.com/uc?id=%s&export=download", "1bbIAdZkWUmwO_GSHC7ZDninb7hgtlb4_"))
#To use provide the name of outcome of interes as follows
y = "net_cost_attnd"
#Additionally, concatenate the list of features to be tested:
features <- c("instruct_expendts_i", "prop_fac_fulltime_i", "prop_Pell_grant_i", "transf_rate_FTE_i", "White_i", "prop_part_time_i", "povunder50", "medincome", "unplymt", "noplumbing", "singlemom", "prop_crime", "propbenft", "numb_neigh")
#Finally, provide the database name as db=features_sub in our case.
#Optional: you can set the name of the outcome to be displayed in the HTML plot with
name_html_plot <- "Net Cost of Attendance"
#The number of runs to assess relevance is 1000, you can change it with maxRuns=number
#Execute
boruta_html(y, features, db=pub2year_sub, maxIterations=1000)
#Outputs are two plots, one static in R and one interactive in HTML
#see https://rpubs.com/msgc/point_based_Boruta
#################################################################
# VI. SAR Models
#################################################################
#Empty model for comparison
SAR_null <- spdep::spautolm(formula = net_cost_attnd ~ 1, data = pub2year_sub, nb2listw(sub_matw))
summary(SAR_null)
#Full model which may include multicollinearity issues
SAR_full <- spdep::spautolm(formula = net_cost_attnd ~ instruct_expendts_i + prop_fac_fulltime_i + prop_Pell_grant_i + transf_rate_FTE_i + White_i + prop_part_time_i + povunder50 + medincome + unplymt + noplumbing + singlemom + prop_crime + propbenft + numb_neigh, data = pub2year_sub, nb2listw(sub_matw))
SAR_Boruta <- spdep::spautolm(formula = net_cost_attnd ~ prop_fac_fulltime_i + prop_Pell_grant_i + transf_rate_FTE_i + White_i + prop_part_time_i + povunder50 + medincome + singlemom + prop_crime + propbenft + numb_neigh,
data = pub2year_sub, nb2listw(sub_matw))
#################################################################
# VII. Testing RSODA of Three Models
#################################################################
source(sprintf("https://docs.google.com/uc?id=%s&export=download"
, "1ZKEeAobCnOublGDzO4oGmaTe7G9PgrK9"))
par(mfrow=c(1,3))
SAR_res_test(SAR_null, nb2listw(sub_matw))
SAR_res_test(SAR_full, nb2listw(sub_matw))
SAR_res_test(SAR_Boruta, nb2listw(sub_matw))
#Code Ends