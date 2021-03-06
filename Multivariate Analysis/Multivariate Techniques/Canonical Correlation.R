#
# Canonical Correlation
# Author: galaa
# Created on 2017/05/11 06:40:00
#

## Data

X <- matrix(
  data = c(62, 82, 78, 60, 60, 60, 63, 70, 65, 65, 89, 65, 64, 94, 82, 63, 61, 65, 72, 80, 61, 62, 97, 60, 60, 65, 80, 82, 70, 63, 60, 60, 70, 63, 90, 66),
  nrow = 12, ncol = 3, byrow = FALSE
)
print(X)

Y <- matrix(
  data = c(75, 90, 68, 71, 60, 72, 72, 69, 61, 66, 93, 61, 60, 85, 71, 80, 60, 70, 76, 60, 80, 70, 95, 85),
  nrow = 12, ncol = 2, byrow = FALSE
)
print(Y)

## Centering

colMeans(X); colMeans(Y)

X <- scale(x = X, center = TRUE, scale = FALSE)
Y <- scale(x = Y, center = TRUE, scale = FALSE)

## Covariation

S.XX <- cov(X); S.YY <- cov(Y); S.XY <- cov(X,Y)

## K matrix and its Singular Value Decomposition

# install.packages("expm") # if required
K <- expm::sqrtm(solve(S.XX)) %*% S.XY %*% expm::sqrtm(solve(S.YY))

K. <- svd(K)
print(K.)

## Canonical Correlation Coefficient

k <- Matrix::rankMatrix(K)
rho <- sqrt(
  eigen(
    K %*% t(K)
  )$values[1:k]
)
print(rho)

## Projection Vectors

a <- expm::sqrtm(solve(S.XX)) %*% K.$u
b <- expm::sqrtm(solve(S.YY)) %*% K.$v

## Canonical Variables

eta <- t( t(a) %*% t(X) )
varphi <- t( t(b) %*% t(Y) )

cor(eta, varphi) # Canonical Correlation Coefficient
cor(eta[,1], varphi[,2])

cov(eta) # $cov(\eta)=I_k$
cov(varphi)

plot(eta[,1], varphi[,1], asp = 1) # scatter plot

## -------------------------------------------------------------------------------------
## Canonical Correlation Analysis with specific function cc() from the package CCA
## -------------------------------------------------------------------------------------

# install.packages("CCA") # if required
CCA::cc(X, Y)

## -------------------------------------------------------------------------------------
## Canonical Correlation Analysis with specific function cancor() from the package stats
## -------------------------------------------------------------------------------------

cancor(x = X, y = Y) # ! it uses QR Decomposition of Data Matrices
