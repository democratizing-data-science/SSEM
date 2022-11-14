#I. Read second points dataset
origin <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", "1PffhCIYGdYukuF3sdDTxCwYp5l6-v8lM"))
# Subsetting to only name, Long, and Lat
origin <- origin[origin$Name=="Whitehall Apts."|origin$Name=="Westpark Plaza"|origin$Name=="Spring Garden Apts."|origin$Name=="Raymond Rosen Manor",c("Name", "longitude","latitude")]
origin
#                  Name longitude latitude
#1      Whitehall Apts. -75.07758 40.01359
#2       Westpark Plaza -75.22044 39.96437
#6  Spring Garden Apts. -75.15029 39.96215
#10 Raymond Rosen Manor -75.17106 39.98750
#II. Harmonizing names of origin and destination
colnames(destination) <- c("ID","long","lat")
colnames(origin) <- c("ID","long","lat")
#III. Appending
pt<-rbind(origin, destination)
#IV. Creating full matrix
mat <- as.matrix(dist(pt[,2], pt[,2], method = "euclidean", upper = T))
rownames(mat) <-pt[,1] 
colnames(mat) <-pt[,1]
mat[mat!=0]<-1
#V. Matrix decomposition by type
mat <- mat[1:nrow(origin), (nrow(origin)+1):ncol(mat)]
mat
#                    215062 212054 215239
#Whitehall Apts.          1      1      1
#Westpark Plaza           1      1      1
#Spring Garden Apts.      1      1      1
#Raymond Rosen Manor      1      1      1
#VI. From mat to network
g<-graph.incidence(mat, directed=FALSE)
g
#GRAPH 863c4c3 UN-B 7 12 -- 
# attr: type (v/l), name (v/c)
# edges from 863c4c3 (vertex names):
#[1] Whitehall Apts.    --215062 Whitehall Apts.    --212054 Whitehall Apts.    --215239 Westpark Plaza     --215062
#[5] Westpark Plaza     --212054 Westpark Plaza     --215239 Spring Garden Apts.--215062 Spring Garden Apts.--212054
#[9] Spring Garden Apts.--215239 Raymond Rosen Manor--215062 Raymond Rosen Manor--212054 Raymond Rosen Manor--215239
#VII. From network to edgelist
edgelist <- data.frame(get.edgelist(g))
edgelist
#                    X1     X2
#1      Whitehall Apts. 215062
#2      Whitehall Apts. 212054
#3      Whitehall Apts. 215239
#4       Westpark Plaza 215062
#5       Westpark Plaza 212054
#6       Westpark Plaza 215239
#7  Spring Garden Apts. 215062
#8  Spring Garden Apts. 212054
#9  Spring Garden Apts. 215239
#10 Raymond Rosen Manor 215062
#11 Raymond Rosen Manor 212054
#12 Raymond Rosen Manor 215239
#VIII. From edgelist to network again
g <- graph.data.frame(edgelist)
g
#GRAPH 8649e54 DN-- 7 12 -- 
# attr: name (v/c)
# edges from 8649e54 (vertex names):
#[1] Whitehall Apts.    ->215062 Whitehall Apts.    ->212054 Whitehall Apts.    ->215239 Westpark Plaza     ->215062
#[5] Westpark Plaza     ->212054 Westpark Plaza     ->215239 Spring Garden Apts.->215062 Spring Garden Apts.->212054
#[9] Spring Garden Apts.->215239 Raymond Rosen Manor->215062 Raymond Rosen Manor->212054 Raymond Rosen Manor->215239
#IX. To go back to a matrix we need to add differentiate types
V(g)$type <- V(g)$name %in% origin[,1]
mat <- t(get.incidence(g))
mat
#                    215062 212054 215239
#Whitehall Apts.          1      1      1
#Westpark Plaza           1      1      1
#Spring Garden Apts.      1      1      1
#Raymond Rosen Manor      1      1      1
#Code Ends