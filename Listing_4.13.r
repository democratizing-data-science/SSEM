#Begin Goecoding from ZCTAs Code Listing
#install.packages("stringr")
library(stringr)
library(sf)
library(tigris)
options(tigris_use_cache = TRUE)
#################################################################
# I. Download shapefile and retrieve lat & long as a data frame
#################################################################
zip <- zctas()
zip_df <- as.data.frame(zip[, c("GEOID10", "INTPTLAT10", "INTPTLON10")])[ ,-4]
zip_df$lat <- as.numeric(zip_df$INTPTLAT10)
zip_df$long <- as.numeric(zip_df$INTPTLON10)

#################################################################
# II. Save the resulting database for posterior use
#################################################################
a<-getwd()
write.csv(zip_df, paste(a,"zip_df.csv", sep="/"), row.names=FALSE)
zip_df <- read.csv(paste(a,"zip_df.csv", sep="/"))
#During the saving and reading process leading zeroes are lost
#We can retrieve them with the pad function
zip_df$GEOID10 <- str_pad(zip_df$GEOID10, 5, pad = "0")

#################################################################
# III. Access the CCD schools universe file 
#################################################################
ccd <- paste('https://nces.ed.gov/ccd/Data/zip/ccd_sch_029_2021_w_0a_02032021.zip')
a<-getwd() #to save locally
download.file(ccd, destfile = paste(a,"ccd_sch_029_2021_w_0a_02032021.zip",sep="/"))
ccd <- read.csv(unz(paste(a,"ccd_sch_029_2021_w_0a_02032021.zip",sep="/"), "ccd_sch_029_2021_w_0a_02032021.csv"))
ccd <- ccd[ccd$ST=="PA",]
#Just in case, pad the column of interest again
ccd$LZIP<-str_pad(ccd$LZIP, 5, pad = "0") #Location address

#################################################################
# IV. Match and set as a sf object and plot
#################################################################
ccd$lat <- zip_df$lat[match(ccd$LZIP, zip_df$GEOID10)]
ccd$long <- zip_df$long[match(ccd$LZIP, zip_df$GEOID10)]

# Are there missing cases? If so, remove
table(is.na(ccd$long))
head(ccd[is.na(ccd$long),c("LZIP", "SCH_NAME")], table(is.na(ccd$long))[2])

usa<-states()
ccd_sh <- st_as_sf(x = ccd[!is.na(ccd$long), ],
          coords = c("long", "lat"),
          crs=st_crs(usa))

plot(st_geometry(usa[usa$NAME=="Pennsylvania",]), main="Pennsylvania", sub="Schools or Academies (N = 2,960), with 15 missing cases")
plot(st_geometry(ccd_sh), add = TRUE, col="#CD1076")
#End Goecoding from ZCTAs Code Listing