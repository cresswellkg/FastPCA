# Introduction

`FastPCA` is a simple implementation of principal component analysis designed to run extremley fast on matrices of varying sizes. Additionally, `FastPCA` provides users the ability to only calculate a couple PCs at time. This allows users who are only interested in the first couple PCs to save large amounts of computing time when compared with base R implementation of PCA. The workhorse function of the algorithm is the `PRIMME` eigensolver (https://cran.r-project.org/web/packages/PRIMME/index.html) which allows for both partial eigendecompositon and a great increase in speed.

## Installation

```{r, eval = FALSE, message=FALSE}
devtools::install_github("cresswellkg/FastPCA")
library(FastPCA)
```

## Comparing run speeds 

Below we compare run speeds with princomp from the stat package and corpcor's (https://cran.r-project.org/web/packages/corpcor/index.html) fast.svd function 

```
#Simulating a square matrix
square_mat = matrix(runif(3000^2, 0, 200), 3000, 3000)
#Running on the matrix while only calculating first 2 PCs
time = proc.time()
FastPCA(square_mat, PCs = 2)
proc.time()-time

user  system elapsed 
18.37    0.09   18.44 

#Repeating with first 10 PCs
time = proc.time()
FastPCA(square_mat, PCs = 10)
proc.time()-time

user  system elapsed 
19.82    0.12   20.33 

#Now with base R
time = proc.time()
princomp(square_mat)
proc.time()-time

user  system elapsed 
71.35    0.25   71.97 

```
## Runtimes on wide matrices

It is a known problem that PCA can be exceptionally slow on large p, small n matrices. These matrices are common in genomics with large-scale GWAS studies. Here, the PCA step is limited by the speed of the correlation/covariance calculation which we optimize using the coop package.

```{r}
#Simulating a 50x5000 wide matrix
wide_mat = matrix(runif(50*50000, 0, 200), 50, 5000)
#Running on the matrix while only calculating first 2 PCs
time = proc.time()
FastPCA(wide_mat, PCs = 10)
proc.time()-time

user  system elapsed 
2.84    0.05    2.92 

#Using princomp
time = proc.time()
princomp(wide_mat)
proc.time()-time

user  system elapsed 
69.89    0.17   70.30 
```
## Runtime on long matrices

Like all PCA methods, FastPCA is most efficient on long matrices. Thus, we demonstrate this with an exceptionally large matrix (5000000 x 50).

```{r}
#Simulating a 5000000x50 long matrix
long_mat = matrix(runif(5e+06*50, 0, 200), 5000000, 50)
#Running on the matrix while only calculating first 2 PCs
time = proc.time()
pcs = FastPCA(long_mat, PCs = 10)
proc.time()-time

user  system elapsed 
14.80    2.73   16.25 

time = proc.time()
pc_princomp = princomp(long_mat)
proc.time()-time

user  system elapsed 
37.14    1.84   39.31 
```

```
#Redoing PCs
pcs = FastPCA(long_mat, PCs = 10)
#Plotting 1st and 3rd PC
plotPCs(pcs, PC1 = 1, PC = 3)
```
