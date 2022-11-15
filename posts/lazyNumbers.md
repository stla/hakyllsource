---
title: "The lazy numbers in R"
author: "Stéphane Laurent"
date: '2022-11-12'
tags: R, C++, Rcpp, maths
rbloggers: yes
output:
  md_document:
    variant: markdown
    preserve_yaml: true
  html_document:
    highlight: kate
    keep_md: no
highlighter: pandoc-solarized
---

My new package [**lazyNumbers**](https://github.com/stla/lazyNumbers) is
a port of the lazy numbers implemented in the C++ library **CGAL**. The
lazy numbers represent the real numbers and arithmetic on these numbers
is exact.

The ordinary floating-point arithmetic is not exact. Consider for
example the simple operation $1 - 7 \times 0.1$. In double precision, it
is not equal to $0.3$:

``` r
x <- 1 - 7 * 0.1
x == 0.3
## [1] FALSE
```

With the lazy numbers, it is equal to $0.3$:

``` r
library(lazyNumbers)
x <- lazynb(1) - lazynb(7) * lazynb(0.1)
as.double(x) == 0.3
## [1] TRUE
```

***Correction:*** *this is*
[*wrong*](https://laustep.github.io/stlahblog/posts/lazyNumbers2.html)*!*

In fact, when a binary operation involves a lazy number, the other
number is automatically converted to a lazy number, so you can shortly
enter this operation as follows:

``` r
x <- 1 - lazynb(7) * 0.1
as.double(x) == 0.3
## [1] TRUE
```

Let's see a more dramatic example now. Consider the sequence $(u_n)$
recursively defined by $u_1 = 1/7$ and $u_{n+1} = 8 u_n - 1$. You can
easily check that $u_2 = 1/7$, therefore $u_n = 1/7$ for every
$n \geqslant 1$. However, when implemented in double precision, this
sequence quickly goes crazy ($1/7 \approx 0.1428571$):

``` r
u <- function(n) {
  if(n == 1) {
    return(1 / 7)
  }
  8 * u(n-1) - 1
}
u(15)
## [1] 0.1428223
u(18)
## [1] 0.125
u(20)
## [1] -1
u(30)
## [1] -1227133513
```

With the lazy numbers, this sequence never moves from $1/7$:

``` r
u_lazy <- function(n) {
  if(n == 1) {
    return(1 / lazynb(7))
  }
  8 * u_lazy(n-1) - 1
}
as.double(u_lazy(100))
## [1] 0.1428571
```

Let's compare with the multiple precision numbers provided by the
**Rmpfr** package. One has to set the precision of these numbers. Let's
try with $256$ bits (the double precision corresponds to $53$ bits):

``` r
library(Rmpfr)
u_mpfr <- function(n) {
  if(n == 1) {
    return(1 / mpfr(7, prec = 256L))
  }
  8 * u_mpfr(n-1) - 1
}
asNumeric(u_mpfr(30))
## [1] 0.1428571
asNumeric(u_mpfr(85))
## [1] 0.140625
asNumeric(u_mpfr(100))
## [1] -78536544841
```

The sequence goes crazy before the $100^{\textrm{th}}$ term. Of course
we could increase the precision. With the lazy numbers, there's no
precision to set. Moreover they are faster (at least for this example):

``` r
library(microbenchmark)
options(digits = 4L)
microbenchmark(
  lazy = u_lazy(200),
  mpfr = u_mpfr(200),
  times = 20L
)
## Unit: milliseconds
##  expr   min    lq  mean median    uq   max neval cld
##  lazy 38.42 39.57 40.30  40.04 40.68 43.47    20  a 
##  mpfr 59.22 60.09 61.01  60.60 61.94 64.89    20   b
```

Vectors of lazy numbers and matrices of lazy numbers are available in
the **lazyNumbers** package. One can get the inverse and the determinant
of a square lazy matrix.

A thing to note is that the usual mathematical functions such as $\exp$,
$\cos$ or $\sqrt{}$, are not implemented for lazy numbers. Only the
addition, the subtraction, the multiplication, the division and the
absolute value are implemented.
