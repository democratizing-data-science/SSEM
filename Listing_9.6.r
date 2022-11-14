mat <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", "1ysKOT57XVKYrKwlna_ocLTnIqIM759Ky"))
rownames(mat) <- mat$X
mat$X <- NULL
mat<-as.matrix(mat)
mat <- ifelse(mat > 46.6, 0, ifelse(mat > 0, 1, mat))
#Transformation
mat <- mat%*%t(mat)
diag(mat) <- 0
mat<-as.data.frame(mat)
#In this case the link label counts numbers of 4-year neighbors in common
link.label="Number of 4-year neighbors in common: ", #for link info.
#Code Ends