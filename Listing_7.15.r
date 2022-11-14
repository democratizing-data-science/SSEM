#SODA 2.0
# install.packages("splitstackshape")
library(splitstackshape)
library(spdep)
library(igraph)
#################################################################
# I. Load coauthorship data 
#################################################################
coauthors <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", "1FaVVTKaspX_pYDKbbZ89o-nDRdNwd1yA"))
#################################################################
# II. Initial transformations
#################################################################
#Transforming data to adjacency matrix
coauthors<-as.data.frame(coauthors[,2])
colnames(coauthors)<-"AU"
a1<-cSplit(coauthors, splitCols = "AU", sep = ";", direction = "wide", drop = TRUE) 
#################################################################
# III. Edgelist transformations
#################################################################
source(sprintf("https://docs.google.com/uc?id=%s&export=download"
, "1GbRObJI0f-85PLmoaqKFevS5HWH21ceN"))
edgelist <- adjacency_2_edgelist(a1)
#################################################################
# IV. Edgelist to graph to matrix transformations
#################################################################
#create a graph from edgelist object
g<- graph.data.frame(edgelist, directed = FALSE)
#Create a count for co-publications
E(g)$weight <- 1 
g.c <- simplify(g)#g.c only has unique relationships with strength
#Move to matrix form from graph
mat<-as.matrix(as_adjacency_matrix(g.c, attr="weight"))
#################################################################
# V. Matrix to weight matrix transformation  
#################################################################
#Row standardization
mat <-mat /rowSums(mat)
summary(rowSums(mat))
# Replacing potential NAN to zeros although we have none
mat[is.na(mat)]<-0
#Creating matrices of influence
coauthorsw<-mat2listw(mat)
#################################################################
# VI. Estimating individual number of publications
#################################################################
#Go back to original dataset and split to create individual count
a1<-cSplit(coauthors, splitCols = "AU", sep = ";", direction = "wide", drop = FALSE) #retain the matrix form version of the
head(a1)
#Add publication number and apply transformation
a1$AU<-1:nrow(a1)
head(a1)
a1 <- as.matrix(a1)
#Create a link of each authors to her/his publication
ind_edgelist <- cbind(a1[, 1], c(a1[, -1]))
#This process adds NAs by if number of coauthors is less than the maximum number of coauthors in the entire network, accordingly, we have to remove NAs
ind_edgelist<-ind_edgelist[!is.na(ind_edgelist[,2]),]
#Estimate individual-level count
pub_no <- as.data.frame(table(ind_edgelist[,2]))
dim(pub_no)
#this incluses 210 authors with one publication and solo authorhip
#[1] 4787    2
#Final outcome indicator
ydata <- data.frame(ID=rownames(mat), pub_no = pub_no$Freq[match(rownames(mat), pub_no$Var1)])
head(ydata)
#################################################################
# VII. Moran's I procedures (question 1)
#################################################################
moran.test(ydata$pub_no, coauthorsw, zero.policy=TRUE)
#Moran I statistic standard deviate = 22.24, p-value < 2.2e-16
#alternative hypothesis: greater
#sample estimates:
#Moran I statistic       Expectation          Variance 
#     0.2860609683     -0.0002185315      0.0001656965
#################################################################
# VIII. How many orders for Moran's I significance? (question 2)
#################################################################
plot.spcor(sp.correlogram(coauthorsw$neighbours,
ydata$pub_no, order = 10, method = "I", zero.policy=T),
xlab = "Social lags", main = "Social correlogram:
Autocorrelation with CIs")
#################################################################
# IX. Higher order neighbors (question 2)
#################################################################
fourth_order_n <- nblag(coauthorsw[[2]], maxlag=4)
high_order <- nblag_cumul(fourth_order_n)
high_order4 <- nb2listw(high_order, style="W", zero.policy=T)
mt <- moran.test(ydata$pub_no, high_order4, zero.policy=TRUE)
#weights: high_order4    
#Moran I statistic standard deviate = 14.249, p-value < 2.2e-16
#alternative hypothesis: greater
#sample estimates:
#Moran I statistic       Expectation          Variance 
#     0.1738486234     -0.0002185315      0.0001492236 
#################################################################
# X. Local Moran's I clusters and outliers (question 3)
#################################################################
label_x = "Indvidual No. of publications"
label_y = "Lagged Indvidual No. of publications"
mp <- moran.plot(ydata$pub_no, high_order4, zero.policy=T,
labels=ydata$ID, xlab = label_x, ylab = label_y, xlim=c(-2,8))
title(main="Moran's Plot", cex.main=2, col.main="grey11", font.main=2, sub=paste("Plot includes 4,577 authors (Moran's I = ", round(mt$ estimate[1], 3), ", p < .0001)", sep
=""),cex.sub=1.15, col.sub="grey11", font.sub=2,)
#Code Ends