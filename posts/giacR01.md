---
title: "Gröbner implicitization and the 'giacR' package"
author: "Stéphane Laurent"
date: '2023-07-19'
tags: R, maths
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

I considerably improved the computation of the Gröbner bases in the
[**qspray**](https://laustep.github.io/stlahblog/posts/Groebner01.html)
package, and I implemented something new: *Gröbner implicitization*. The
Gröbner implicitization is able to transform a system of parametric
equations to an implicit equation. Let's see the example of the ellipse:

``` r
library(qspray)
# variables 
cost <- qlone(1)
sint <- qlone(2)
# parameters
a <- qlone(3)
b <- qlone(4)
#
nvariables <- 2
parameters <- c("a", "b")
equations <- list(
  "x" = a * cost,
  "y" = b * sint
)
relations <- list(
  cost^2 + sint^2 - 1 # = 0
)
# 
eqs <- 
  implicitization(nvariables, parameters, equations, relations)
## a^2*b^2 - b^2*x^2 - a^2*y^2
```

You see, `a^2*b^2 - b^2*x^2 - a^2*y^2 = 0` is the implicit equation of
the ellipse.

Gröbner implicitization is based on Gröbner bases. Unfortunately, while
I considerably improved it, my implementation of the Gröbner bases can
be slow, very slow. For the ellipse above, it is fast. But I tried for
example to implicitize the parametric equations of the Enneper surface,
and the computation was not terminated after 24 hours.

No worries. I have a new package coming to the rescue:
[**giacR**](https://github.com/stla/giacR). This is an interface to the
*Giac* computer algebra system, which powers the graphical interface
*Xcas*. It is extremely efficient, and it is able to compute Gröbner
bases.

Gröbner implicitization is not implemented in Giac. So I implemented it
myself. Here is the implicit equation of the Enneper surface:

``` r
library(giacR)
giac <- Giac$new()

equations <-
  "x = 3*u + 3*u*v^2 - u^3, y = 3*v + 3*u^2*v - v^3, z = 3*u^2 - 3*v^2"
variables <- "u, v"

giac$implicitization(equations = equations, variables = variables)
## [1] "-19683*x^6+59049*x^4*y^2-10935*x^4*z^3-118098*x^4*z^2+59049*x^4*z-59049*x^2*y^4-56862*x^2*y^2*z^3-118098*x^2*y^2*z-1296*x^2*z^6-34992*x^2*z^5-174960*x^2*z^4+314928*x^2*z^3+19683*y^6-10935*y^4*z^3+118098*y^4*z^2+59049*y^4*z+1296*y^2*z^6-34992*y^2*z^5+174960*y^2*z^4+314928*y^2*z^3+64*z^9-10368*z^7+419904*z^5"
```

Finally we close the Giac session:

``` r
giac$close()
## [1] TRUE
```
