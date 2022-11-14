#Data Access
library(plyr)
library(sf)
library(stringr)
library(tigris)
library(tidycensus)
options(tigris_use_cache = TRUE)
#################################################################
# I. Load Key and Download ACS Data for Poverty
#################################################################
readRenviron("~/.Renviron")
povunder50 <- get_acs(geography = "zcta", variables = "C17002_002", year = 2020)
total <- get_acs(geography = "zcta", variables = "C17002_001", year = 2020)
poverty <- data.frame(zip = gsub("ZCTA5 ", "", total$NAME), 
           povunder50 = round(povunder50$estimate/total$estimate, 3)) 
#################################################################
# II. Median Income
#################################################################
medincome <- get_acs(geography = "zcta", variables = "B07011_001", year = 2020)
medincome <- data.frame(zip = gsub("ZCTA5 ", "", medincome$NAME), 
           medincome = medincome$estimate) 
#################################################################
# III. Unemployed in labor force (civilian)
#################################################################
unplymt <- get_acs(geography = "zcta", variables = "B23025_005", year = 2020)
total <- get_acs(geography = "zcta", variables = "B23025_003", year = 2020)
unplymt <- data.frame(zip = gsub("ZCTA5 ", "", total$NAME), 
           unplymt = round(unplymt$estimate/total$estimate, 3)) 
#################################################################
# IV. Housing Quality Plumbing Facilities Example
#################################################################
noplumbing <- get_acs(geography = "zcta", variables = "B25047_003", year = 2020)
total <- get_acs(geography = "zcta", variables = "B25047_001", year = 2020)
noplumbing <- data.frame(zip = gsub("ZCTA5 ", "", total$NAME), 
           noplumbing = round(noplumbing$estimate/total$estimate, 3)) 
#################################################################
# V. Women Only Householders
#################################################################
singlemom <- get_acs(geography = "zcta", variables = "B09002_015", year = 2020)
total <- get_acs(geography = "zcta", variables = "B09002_001", year = 2020)
singlemom <- data.frame(zip = gsub("ZCTA5 ", "", total$NAME), 
           singlemom = round(singlemom$estimate/total$estimate, 3)) 
#################################################################
# V. Joining all databases using the "zip" key
#################################################################
zcta <- join_all(list(poverty, medincome, unplymt, noplumbing, singlemom), by = 'zip', type = 'left')
#################################################################
# VI. Crosswalking county
#################################################################
co <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", "1vVzPC32yfANg24QHsk5YqcaQ_7ugTw1p"))
cross <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", "1w7Fe-3hFV50gm7DDR_IXQunDCz8oIyOI"))
#Padding
co$county <- str_pad(co$county, 5, pad = "0")
#Also for cross due to missing leading "0"s
cross$zip <- str_pad(cross$zip, 5, pad = "0")
cross$county <- str_pad(cross$county, 5, pad = "0")

zcta$county <- cross$county[match(zcta$zip, cross$zip)] 
zcta <- join(zcta, co, by="county") #the key is now county
zcta$state <- cross$usps_zip_pref_state[match(zcta$zip, cross$zip)] 
write.csv(zcta, "zcta2020.csv", row.names=F, na="")
#################################################################
# VI. Bring everything to the shapefile for a SPLACE database
#################################################################
zcta <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", "1-j6EEHeaOvlP3V5QZamG4z3-u0iv6ExM"))
zcta$zip <- str_pad(zcta$zip, 5, pad = "0")#padding needed
zip <- zctas()
zip <- geo_join(zip, zcta, "ZCTA5CE10", "zip", how="left")