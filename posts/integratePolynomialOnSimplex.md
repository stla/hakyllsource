---
title: "Exact integral of a polynomial on a simplex"
author: "Stéphane Laurent"
date: '2022-12-02'
tags: R, python, julia
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

The paper [Simple formula for integration of polynomials on a
simplex](https://arxiv.org/pdf/1908.06736.pdf) by Jean B. Lasserre
provides a method to calculate the exact value of the integral of a
multivariate polynomial on a simplex (i.e. a tetrahedron in dimension
three). I implemented it in **Julia**, **Python**, and **R**.

Integration on simplices is important, because any convex polyhedron can
be decomposed into simplices, thanks to the Delaunay tessellation.
Therefore one can integrate over convex polyhedra once one can integrate
over simplices (I wrote an
[example](https://laustep.github.io/stlahblog/posts/integralPolyhedron.html)
of doing so with **R**).

## Julia

``` julia
using TypedPolynomials
using LinearAlgebra

function integratePolynomialOnSimplex(P, S)
    gens = variables(P)
    n = length(gens)
    v = S[end]    
    B = Array{Float64}(undef, n, 0)
    for i in 1:n
        B = hcat(B, S[i] - v)
    end
    Q = P(gens => v + B * vec(gens))
    s = 0.0
    for t in terms(Q)
        coef = TypedPolynomials.coefficient(t)
        powers = TypedPolynomials.exponents(t)
        j = sum(powers)
        if j == 0
            s = s + coef
            continue
        end
        coef = coef * prod(factorial.(powers))
        s = s + coef / prod((n+1):(n+j))
    end
    return abs(LinearAlgebra.det(B)) / factorial(n) * s
end
```

### Julia example

We define the polynomial to be integrated as follows:

``` julia
using TypedPolynomials
@polyvar x y z
P = x^4 + y + 2*x*y^2 - 3*z
```

*Be careful*. If the expression of your polynomial does not involve one
of the variables, e.g. $P(x, y, z) = x^4 + 2xy^2$, you must define a
polynomial involving this variable:

``` julia
P = x^4 + 2*x*y^2 + 0.0*z
```

Now we define the simplex as a matrix whose rows correspond to the
vertices:

``` julia
# simplex vertices
v1 = [1.0, 1.0, 1.0] 
v2 = [2.0, 2.0, 3.0] 
v3 = [3.0, 4.0, 5.0] 
v4 = [3.0, 2.0, 1.0]
# simplex
S = [v1, v2, v3, v4]
```

And finally we run the function:

``` julia
integratePolynomialOnSimplex(P, S)
```

## Python

``` python
from math import factorial
from sympy import Poly
import numpy as np

def _term(Q, monom):
    coef = Q.coeff_monomial(monom)
    powers = list(monom)
    j = sum(powers)
    if j == 0:
        return coef
    coef = coef * np.prod(list(map(factorial, powers)))
    n = len(monom)
    return coef / np.prod(list(range(n+1, n+j+1)))

def integratePolynomialOnSimplex(P, S):
    gens = P.gens
    n = len(gens)
    S = np.asarray(S)
    v = S[n,:]
    columns = []
    for i in range(n):
        columns.append(S[i,:] - v)    
    B = np.column_stack(tuple(columns))
    dico = {}
    for i in range(n):
        newvar = v[i]
        for j in range(n):
            newvar = newvar + B[i,j]*Poly(gens[j], gens, domain="RR")
        dico[gens[i]] = newvar.as_expr()
    Q = P.subs(dico, simultaneous=True).as_expr().as_poly(gens)
    print(Q)
    monoms = Q.monoms()
    s = 0.0
    for monom in monoms:
        s = s + _term(Q, monom)
    return np.abs(np.linalg.det(B)) / factorial(n) * s
```

### Python example

``` python
# simplex vertices
v1 = [1.0, 1.0, 1.0] 
v2 = [2.0, 2.0, 3.0] 
v3 = [3.0, 4.0, 5.0] 
v4 = [3.0, 2.0, 1.0]
# simplex
S = [v1, v2, v3, v4]

# polynomial to integrate
from sympy import Poly
from sympy.abc import x, y, z
P = Poly(x**4 + y + 2*x*y**2 - 3*z, x, y, z, domain = "RR")

# integral
integratePolynomialOnSimplex(P, S)
```

## R

``` r
library(spray)

integratePolynomialonSimplex <- function(P, S) {
  n <- ncol(S)
  v <- S[n+1L, ]
  B <- t(S[1L:n, ]) - v
  gens <- lapply(1L:n, function(i) lone(i, n))
  newvars <- vector("list", n)
  for(i in 1L:n) {
    newvar <- v[i]
    Bi <- B[i, ]
    for(j in 1L:n) {
      newvar <- newvar + Bi[j] * gens[[j]]
    }
    newvars[[i]] <- newvar
  }
  Q <- 0
  exponents <- P[["index"]]
  coeffs    <- P[["value"]] 
  for(i in 1L:nrow(exponents)) {
    powers <- exponents[i, ]
    term <- 1
    for(j in 1L:n) {
      term <- term * newvars[[j]]^powers[j] 
    }
    Q <- Q + coeffs[i] * term
  }
  s <- 0
  exponents <- Q[["index"]]
  coeffs    <- Q[["value"]] 
  for(i in 1L:nrow(exponents)) {
    coef <- coeffs[i]
    powers <- exponents[i, ]
    d <- sum(powers)
    if(d == 0L) {
      s <- s + coef
      next
    }
    coef <- coef * prod(factorial(powers))
    s <- s + coef / prod((n+1L):(n+d))
  }
  abs(det(B)) / factorial(n) * s
}
```

### R example

``` r
library(spray)

# variables
x <- lone(1, 3)
y <- lone(2, 3)
z <- lone(3, 3)
# polynomial
P <- x^4 + y + 2*x*y^2 - 3*z

# simplex (tetrahedron) vertices
v1 <- c(1, 1, 1)
v2 <- c(2, 2, 3)
v3 <- c(3, 4, 5)
v4 <- c(3, 2, 1)
# simplex
S <- rbind(v1, v2, v3, v4)

# integral
integratePolynomialonSimplex(P, S)
```

## Note

The functions do not check whether the given matrix `S` defines a
non-degenerate simplex. This is equivalent to the invertibility of the
matrix `B` constructed in the functions.
