library(igraph)
#I. Load IPEDS Dataset
destination <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", "14Z5Ypl7MbWz8ySFKtjOUPT9EKfU3mioT"))
 #Let us extract the two institutions shown in our first figure of this chapter
 destination <- destination[destination$UNITID==215062|destination$UNITID==215239|destination$UNITID==212054, c("UNITID","LONGITUD","LATITUDE")]
 #II. From points to matrix to enter virtuosity of equation (1)
 mat<- as.matrix(dist(destination[,2], destination[,2], method = "euclidean", upper = T))
 rownames(mat) <-destination[,1] 
 colnames(mat) <-destination[,1]
 mat[mat!=0]<-1
 mat
#       215062 212054 215239
#215062      0      1      1
#212054      1      0      1
#215239      1      1      0
# III. mat is a squared matrix, we can read it as a graph
g<-graph.adjacency(mat, mode="upper")
g
#IGRAPH d6109f3 UN-- 3 3 -- 
#+ attr: name (v/c)
#+ edges from d6109f3 (vertex names):
#[1] 215062--212054 215062--215239 212054--215239
#IV. Once we have this graph we can move to an edgelist
edgelist <- data.frame(get.edgelist(g))
edgelist
#      X1     X2
#1 215062 212054
#2 215062 215239
#3 212054 215239
#V. And go back to a graph or matrix
mat <- get.adjacency(graph.data.frame(edgelist))
mat
#3 x 3 sparse Matrix of class "dgCMatrix"
#       215062 212054 215239
#215062      .      1      1
#212054      .      .      1
#215239      .      .      .
#Code Ends