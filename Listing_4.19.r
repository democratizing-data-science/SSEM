#Access IPEDS data
library(stringr)
#################################################################
# I. Download Directory File (NCES's IPEDS Data)
#################################################################
ipeds <- paste('https://nces.ed.gov/ipeds/datacenter/data/HD2020.zip')
a<-getwd() #to save locally
download.file(ipeds, destfile = paste(a,"HD2020.zip",sep="/"))
ipeds <- read.csv(unz(paste(a,"HD2020.zip", sep="/"), "hd2020.csv"))
ipeds <- ipeds[ ,c("UNITID", "INSTNM", "ZIP","SECTOR", "CONTROL", "LONGITUD", "LATITUDE")]
#################################################################
# II. Download Financial Aid information from IPEDS
#################################################################
finaid <- paste('https://nces.ed.gov/ipeds/datacenter/data/SFA1920.zip')
download.file(finaid, destfile = paste(a,"SFA1920.zip",sep="/"))
finaid <- read.csv(unz(paste(a,"SFA1920.zip", sep="/"), "sfa1920.csv"))
finaid <- finaid[ ,c("UNITID", "GISTN2","GISTWF2", "UPGRNTP", "UPGRNTA")]
#creating an indicator of first time in-state students living at home
finaid$propliv_home <- round(finaid$GISTWF2/finaid$GISTN2, 3)
#################################################################
# III. Merging these two datasets by "UNITID" key
#################################################################
ipeds <- merge(ipeds, finaid, by="UNITID") 
table(is.na(ipeds$GISTN2),ipeds$CONTROL)#63 publics with "NA"
#################################################################
# IV. Prepare merger key with zctairs data
#################################################################
ipeds$ZIP <- substr(ipeds$ZIP, 1, 5)
#################################################################
# V. Load zctairs data and pad its "zip" column
#################################################################
zctairs <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", "10G10tsUodeWbC8ZMGJiWo0ildj5VSloI"))
zctairs$zip <- str_pad(zctairs$zip, 5, pad = "0")#padding needed
#################################################################
# VI. Merge datasets
#################################################################
ipeds <- merge(ipeds, zctairs, by.x="ZIP", by.y="zip") 
write.csv(ipeds, "ipeds_ZCTA_CO_irs.csv", row.names=F, na="")
#code ends