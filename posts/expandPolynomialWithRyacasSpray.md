---
title: "Fast expansion of a polynomial with R - part 2"
author: "Stéphane Laurent"
date: '2023-07-05'
tags: R, maths, povray
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

In [the previous
post](https://laustep.github.io/stlahblog/posts/expandPolynomialWithSpray.html),
I showed how to expand a polynomial with symbolic parameters with the
help of the **spray** package. As I said, it has one problem: it doesn't
preserve the rational numbers in the polynomial expression.

I'm going to provide a solution here which overcomes this problem, with
the help of the **Ryacas** package. In fact I provide a solution with
the packages **Ryacas** and **partitions**, and then I improve it with
the help of the **spray** package.

Here is the polynomial expression I use for the illustration:

``` r
expr <- "((x*x+y*y+1)*(a*x*x+b*y*y)+z*z*(b*x*x+a*y*y)-2*(a-b)*x*y*z-a*b*(x*x+y*y))^2-4*(x*x+y*y)*(a*x*x+b*y*y-x*y*z*(a-b))^2"
```

In fact, the equation `expr(x,y,z) = 0` defines a solid Möbius strip.
That is why I was interested in this expression, because I wanted to
draw the solid Möbius strip with POV-Ray. It is nice, in spite of a sad
artifact (please leave a comment if you know how to get rid of it):

![](./figures/SolidMobiusStrip_POV.gif)

Let's assign this expression to Yacas and let's have a look at the
degrees of the three variables `x`, `y` and `z`:

``` r
library(Ryacas)
yac_assign(expr, "POLY")
yac_str("Degree(POLY, x)")
## [1] "8"
yac_str("Degree(POLY, y)")
## [1] "8"
yac_str("Degree(POLY, z)")
## [1] "4"
```

The degrees are 8, 8 and 4 respectively. So we can get all possible
combinations $(i,j,k)$ of $x^iy^jz^k$ with the `blockparts` function of
the `partitions` package:

``` r
library(partitions)
combins <- blockparts(c(8L, 8L, 4L))
dim(combins)
## [1]   3 405
```

There are $405$ such combinations. Of course they don't all appear in
the polynomial, and that is the point we will improve later. For the
moment we will iterate over all these combinations. Here is the function
which takes one combination and returns the corresponding coefficient of
$x^iy^jz^k$ in terms of $a$ and $b$, written in POV-Ray syntax:

``` r
f <- function(combin) {
  xyz <- sprintf("xyz(%s): ", toString(combin))
  coef <- yac_str(sprintf(
    "ExpandBrackets(Coef(Coef(Coef(POLY, x, %d), y, %d), z, %d))",
    combin[1L], combin[2L], combin[3L]
  ))
  if(coef == "0") return(NULL)
  coef <- gsub("([ab])\\^(\\d+)", "pow(\\1,\\2)", x = coef)
  paste0(xyz, coef, ",")
}
# for example:
f(c(2L, 6L, 0L))
## [1] "xyz(2, 6, 0): 2*pow(b,2)+2*b*a,"
```

Then we get the POV-Ray code as follows:

``` r
povray <- apply(combins, 2L, f)
cat(povray, sep = "\n", file = "SolidMobiusStrip.pov")
```

The file ***SolidMobiusStrip.pov***:

``` {.povray .numberLines}
xyz(4, 0, 0): pow(a,2)*pow(b,2)-2*pow(a,2)*b+pow(a,2),
xyz(6, 0, 0): (-2)*pow(a,2)*b-2*pow(a,2),
xyz(8, 0, 0): pow(a,2),
xyz(2, 2, 0): 2*pow(b,2)*pow(a,2)-2*pow(b,2)*a+(-2)*b*pow(a,2)+2*b*a,
xyz(4, 2, 0): (-2)*pow(b,2)*a+(-4)*b*pow(a,2)-4*b*a-2*pow(a,2),
xyz(6, 2, 0): 2*pow(a,2)+2*a*b,
xyz(0, 4, 0): pow(b,2)*pow(a,2)-2*pow(b,2)*a+pow(b,2),
xyz(2, 4, 0): (-4)*pow(b,2)*a-2*pow(b,2)+(-2)*b*pow(a,2)-4*b*a,
xyz(4, 4, 0): pow(b,2)+4*b*a+pow(a,2),
xyz(0, 6, 0): (-2)*pow(b,2)*a-2*pow(b,2),
xyz(2, 6, 0): 2*pow(b,2)+2*b*a,
xyz(0, 8, 0): pow(b,2),
xyz(3, 1, 1): 4*pow(a,2)*b-4*pow(a,2)+(-4)*a*pow(b,2)+4*a*b,
xyz(5, 1, 1): 4*pow(a,2)-4*a*b,
xyz(1, 3, 1): 4*pow(a,2)*b+(-4)*a*pow(b,2)-4*a*b+4*pow(b,2),
xyz(3, 3, 1): 4*pow(a,2)-4*pow(b,2),
xyz(1, 5, 1): 4*a*b-4*pow(b,2),
xyz(4, 0, 2): (-2)*a*pow(b,2)+2*a*b,
xyz(6, 0, 2): 2*b*a,
xyz(2, 2, 2): (-2)*pow(b,2)*a+6*pow(b,2)+(-2)*b*pow(a,2)-8*b*a+6*pow(a,2),
xyz(4, 2, 2): (-2)*pow(a,2)+10*a*b-2*pow(b,2),
xyz(0, 4, 2): (-2)*b*pow(a,2)+2*b*a,
xyz(2, 4, 2): (-2)*pow(a,2)+10*a*b-2*pow(b,2),
xyz(0, 6, 2): 2*a*b,
xyz(3, 1, 3): 4*pow(b,2)-4*b*a,
xyz(1, 3, 3): (-4)*pow(a,2)+4*a*b,
xyz(4, 0, 4): pow(b,2),
xyz(2, 2, 4): 2*a*b,
xyz(0, 4, 4): pow(a,2)
```

Now we will restrict the $405$ combinations. There are only $29$
combinations of exponents in the polynomial expansion. How to get them?
With **spray**. We don't care if there are rational numbers in the
polynomial because we will take the exponents only.

``` r
library(spray)
x <- lone(1L, 5L)
y <- lone(2L, 5L)
z <- lone(3L, 5L)
a <- lone(4L, 5L)
b <- lone(5L, 5L)
P <- ((x*x+y*y+1)*(a*x*x+b*y*y) + z*z*(b*x*x+a*y*y) - 
        2*(a-b)*x*y*z - a*b*(x*x+y*y))^2 - 
  4*(x*x+y*y)*(a*x*x+b*y*y-x*y*z*(a-b))^2
exponents <- index(P)
exponents_xyz <- unique(exponents[, c(1L, 2L, 3L)])
dim(exponents_xyz)
## [1] 29  3
```

Indeed, there are $29$ combinations. Now we can proceed as before and
get the POV-Ray within a couple of seconds:

``` r
povray <- apply(exponents_xyz, 1L, f)
cat(povray, sep = "\n", file = "SolidMobiusStrip.pov")
```
