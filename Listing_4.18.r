#IRS Data Access
library(stringr)
#################################################################
# I. Download IRS ZCTA Data and Pad ZCTA ket
#################################################################
irs19<-read.csv("https://www.irs.gov/pub/irs-soi/19zpallnoagi.csv")
irs19$ZIPCODE <- str_pad(irs19$ZIPCODE, 5, pad = "0")#padding needed
#################################################################
# II. Load ZCTA ACS and County Data and Pad Key
#################################################################
zcta <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", "1-j6EEHeaOvlP3V5QZamG4z3-u0iv6ExM"))
head(zcta)
zcta$zip <- str_pad(zcta$zip, 5, pad = "0")#padding needed
#################################################################
# III. Calculate proportion beneffited and average SLID amount
#################################################################
irs19$propbenft <- irs19$N03210/irs19$N1
irs19$avgbenft <- irs19$A03210/irs19$N03210
#################################################################
# IV. Join databases and save
#################################################################
zctairs <- merge(zcta, irs19[,c("ZIPCODE","STATE", "N1","N03210","A03210", "propbenft", "avgbenft")], by.x="zip", by.y="ZIPCODE")
write.csv(zctairs, "zctairs.csv", row.names=F, na="")
zip <- zctas()#optional
zip <- geo_join(zip, zcta, "ZCTA5CE10", "zip", how="left") #optional
#################################################################
# V. Save State's Totals
#################################################################
irs19state <- irs19[irs19$ZIPCODE=="00000",c("ZIPCODE","STATE", "N1","N03210","A03210", "propbenft", "avgbenft")]
write.csv(irs19state, "irs19state.csv", row.names=F, na="")
#Code ends