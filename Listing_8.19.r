#Code Listing Social multilevel SAR 
#################################################################
# I. Load datasets including higher and lower level matrices
#################################################################
attributes <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", "1e0GtrRS5PFFNdnd1e4fJcjeuBZ6deF7g"))
advice_mat <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", "1dbZDumTH9dFwNStIKKEO9bhx_ftYtLam"))
offices <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", "11YlXM5-bnLP_1x6M6DqO3LlP1aQl-EkF"))
#################################################################
# II. Preparation
#################################################################
features<-c("Intercept", "partner", "male")
#Delta matrix is build from infomation of ID lower level indicator
#and information of higher level indicator
#################################################################
# III. Source function and apply
#################################################################
source(sprintf("https://docs.google.com/uc?id=%s&export=download", "11ZNF9OjiVVdATUTlKzy9YD-RmMKxSn9O"))
social_multilevel_SAR(db=attributes, #lower database
		      higher="office", #ID higher indicator
		      lower="id", #ID lower indicator 
		      mat_lower = advice_mat, #W mat
		      mat_nesting = offices, #M mat
		      features = features, #For model
		      y = "HrRATE90") #Outcome indicator
#Code Ends
