#Point Mapping Procedures
#################################################################
# I. Load dataset including higher and lower level identifiers
#################################################################
pub2year <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", "1edrhML0zMITE32zfWNcAIedD4agvN9bO"))
#################################################################
# II. Identify features to be plotted contained in the database
#################################################################
features <- c("net_cost_attnd", "prop_fac_fulltime_i", "prop_Pell_grant_i", "transf_rate_FTE_i", "White_i", "prop_part_time_i", "povunder50", "medincome", "singlemom", "prop_crime", "propbenft")
#################################################################
# III. Source the point_map function and execute
#################################################################
source(sprintf("https://docs.google.com/uc?id=%s&export=download","14RJvkzJu6jL0aFhms0qKUP5J_jgcvGn1"))
point_map(db=pub2year, #database with polygon attributes
         db.ID="UNITID",#ID of interest in the db object
         features=features,#to be mapped 
         shapefile="my.shapefile",# options: "my.shapefile" "states" "counties" "zctas"
         shape.ID="STUSPS",#only if you provide your own shapefile
         higher="state", #column in db object for merging
         class=5, #Number of categories for distribution
         HTML = "Y")#interactive "Y", static "N"
#Code Ends
