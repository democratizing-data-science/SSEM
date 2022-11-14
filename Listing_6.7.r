#Load edgelist
pt <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", "1ouf0NcpHBz6Qw-ExRr_ksXMu56oTmYs8"))
#Source the functions
source(sprintf("https://docs.google.com/uc?id=%s&export=download", "1p-wJ9lPR3gq5LvJKMyDZHiM91T9y09E6"))
mix_r_k <- rad_kth_inv(pt)
#[1] "The maximum closest distance threshold in this dataset is 500"
#> mix_r_k
#Characteristics of weights list object:
#Neighbour list object:
#Number of regions: 4 
#Number of nonzero links: 8 
#Percentage nonzero weights: 50 
#Average number of links: 2 

#Weights style: M 
#Weights constants summary:
#  n nn    S0      S1       S2
#M 4 16 0.016 6.4e-05 0.000256

mix_r_k <- rad_kth_inv(pt[ , c(1,2,4)])
#[1] "The maximum closest distance threshold in this dataset is 500"
#> mix_r_k
#Characteristics of weights list object:
#Neighbour list object:
#Number of regions: 4 
#Number of nonzero links: 6 
#Percentage nonzero weights: 37.5 
#Average number of links: 1.5 

#Weights style: M 
#Weights constants summary:
#  n nn    S0      S1      S2
#M 4 16 0.012 4.8e-05 0.00016
#Code Ends