#Load IPEDS Dataset
pt <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", "14Z5Ypl7MbWz8ySFKtjOUPT9EKfU3mioT"))
#Let us extract the two institutions shown in our first figure of this chapter
destination <- pt[pt$UNITID==215062|pt$UNITID==215239|pt$UNITID==212054, c("UNITID","INSTNM", "LONGITUD","LATITUDE")]
destination #Geocoded Database of Points
UNITID                            INSTNM  LONGITUD LATITUDE
215062        University of Pennsylvania -75.19391 39.95093
215239 Community College of Philadelphia -75.16560 39.96246
212054 Drexel University                 -75.19005 39.95522
origin <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", "1PffhCIYGdYukuF3sdDTxCwYp5l6-v8lM"))
# Subsetting to only name, Long, and Lat
origin <- origin[,c("Name", "longitude","latitude")]
                                   Name longitude latitude
                        Whitehall Apts. -75.07758 40.01359
                         Westpark Plaza -75.22044 39.96437
                    Spring Garden Apts. -75.15029 39.96215
                    Raymond Rosen Manor -75.17106 39.98750
#Code Ends
