---
author: Stéphane Laurent
date: '2017-12-03'
highlighter: 'pandoc-solarized'
output:
  html_document:
    keep_md: no
  md_document:
    preserve_yaml: True
    variant: markdown
tags: 'R, maths'
title: Extended Cholesky decomposition in R
---

Let $S$ be a symmetric positive semidefinite matrix of order $d$ having
rank $r$. An *extended Cholesky decomposition* of $S$ is a triplet
$(L,M,P)$ consisting of a lower triangular $r\times r$-matrix $L$, a
$(d-r) \times r$-matrix $M$, and a permutation matrix $P$ of order $d$
such that, setting $$
C = \begin{pmatrix} L & 0 \\ M & 0 \end{pmatrix},
$$ one has $PSP' = CC'$. Besides, setting $$
\widetilde{C} = \begin{pmatrix} L & 0 \\ M & I_{d-r} \end{pmatrix},
$$ one has $S={(\widetilde{C}'P)}'I_d^r \widetilde{C}'P$ where $I_d^r$
is the $d\times d$-matrix
$\begin{pmatrix} I_r & 0 \\ 0 & 0 \end{pmatrix}$.

The R function below calculates an extended Cholesky decomposition.

``` {.r .numberLines}
extendedCholesky <- function(S){
  C <- suppressWarnings(chol(S, pivot=TRUE))
  d <- nrow(C)
  P <- matrix(0, d, d)
  P[cbind(1:d, attr(C,"pivot"))] <- 1
  r <- attr(C, "rank")
  return(list(L = t(C[seq_len(r), seq_len(r), drop=FALSE]), 
              M = t(C[seq_len(r), seq_len(d-r)+r, drop=FALSE]), 
              P = P))
}
```

Let's check:

``` {.r .numberLines}
d <- 3
##~~ check for a rank 1 matrix ~~##
S <- tcrossprod(c(1:d))
#~ extended Cholesky of S ~#
EC <- extendedCholesky(S); P <- EC$P; L <- EC$L; M <- EC$M
#~ C matrix ~#
C <- cbind(rbind(L,M), matrix(0, d, d-ncol(L)))
all.equal(P %*% S %*% t(P), C%*%t(C))
## [1] TRUE
```

``` {.r .numberLines}
#~ C tilde matrix ~#
Ctilde <- cbind(rbind(L,M), 
                rbind(matrix(0, nrow(L), d-nrow(L)), diag(d-nrow(L))))
all.equal(
  t(t(Ctilde)%*%P) %*% 
    diag(c(rep(1, nrow(L)), rep(0, d-nrow(L)))) %*% 
    (t(Ctilde)%*%P), 
  S)
## [1] TRUE
```

``` {.r .numberLines}
##~~ check for a rank 2 matrix ~~##
S <- tcrossprod(c(1:d)) + tcrossprod(d:1)
#~ extended Cholesky of S ~#
EC <- extendedCholesky(S); P <- EC$P; L <- EC$L; M <- EC$M
#~ C matrix ~#
C <- cbind(rbind(L,M), matrix(0, d, d-ncol(L)))
all.equal(P %*% S %*% t(P), C%*%t(C))
## [1] TRUE
```

``` {.r .numberLines}
#~ C tilde matrix ~#
Ctilde <- cbind(rbind(L,M), 
                rbind(matrix(0, nrow(L), d-nrow(L)), diag(d-nrow(L))))
all.equal(
  t(t(Ctilde)%*%P) %*% 
    diag(c(rep(1, nrow(L)), rep(0, d-nrow(L)))) %*% 
    (t(Ctilde)%*%P), 
  S)
## [1] TRUE
```

``` {.r .numberLines}
##~~ check for a rank 3 matrix ~~##
S <- toeplitz(d:1)
#~ extended Cholesky of S ~#
EC <- extendedCholesky(S); P <- EC$P; L <- EC$L; M <- EC$M
#~ C matrix ~#
C <- cbind(rbind(L,M), matrix(0, d, d-ncol(L)))
all.equal(P %*% S %*% t(P), C%*%t(C))
## [1] TRUE
```

``` {.r .numberLines}
#~ C tilde matrix ~#
Ctilde <- cbind(rbind(L,M), 
                rbind(matrix(0, nrow(L), d-nrow(L)), diag(d-nrow(L))))
all.equal(
  t(t(Ctilde)%*%P) %*% 
    diag(c(rep(1, nrow(L)), rep(0, d-nrow(L)))) %*% 
    (t(Ctilde)%*%P), 
  S)
## [1] TRUE
```
