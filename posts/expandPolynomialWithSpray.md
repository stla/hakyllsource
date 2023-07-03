---
title: "Fast expansion of a polynomial with R"
author: "Stéphane Laurent"
date: '2023-07-04'
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

In [this previous
post](https://laustep.github.io/stlahblog/posts/caracas01.html), [this
previous
post](https://laustep.github.io/stlahblog/posts/caracas02.html), and
[this previous
post](https://laustep.github.io/stlahblog/posts/juliaPolynomialExpansion.html),
I showed how to expand a polynomial with symbolic parameters. In the
first two posts, I used the R package **caracas**, a wrapper of
**SymPy**, and in the third post I used Julia.

Now I've found a pure R solution, with the help of the **spray**
package, and it is very fast. That's what I'm going to demonstrate here,
with the same example I treated with Julia.

We will lost something as compared to Julia: the **spray** package does
not handle rational numbers, so we will replace them by their double
approximation. We could use the **qspray** package instead, to deal with
the rational numbers.

Here is the starting polynomial expression:

``` r
# define the polynomial expression as a function
f <- function(x, y, z, w, sqrt3) {
  ((x^2+y^2+z^2+w^2+145/3)^2-4*(9*z^2+16*w^2))^2 * 
    ((x^2+y^2+z^2+w^2+145/3)^2+296*(x^2+y^2)-4*(9*z^2+16*w^2)) - 
    16*(x^2+y^2)*(x^2+y^2+z^2+w^2+145/3)^2 * 
    (37*(x^2+y^2+z^2+w^2+145/3)^2-1369*(x^2+y^2)-7*(225*z^2+448*w^2)) - 
    sqrt3*16/9*(x^3-3*x*y^2) * 
    (110*(x^2+y^2+z^2+w^2+145/3)^3-148*(x^2+y^2+z^2+w^2+145/3) * 
       (110*x^2+110*y^2-297*z^2+480*w^2)) - 
    64*(x^2+y^2)*(3*(729*z^4+4096*w^4)+168*(x^2+y^2)*(15*z^2-22*w^2)) + 
    64*(12100/27*(x^3-3*x*y^2)^2-7056*(3*x^2*y-y^3)^2)-592240896*z^2*w^2
}
```

We transform it to the polynomial of interest:

``` r
# there are 3 variables (x,y,z) and 6 parameters (w0,a,b,c,d,sqrt3)
library(spray)
x     <- lone(1, 9)
y     <- lone(2, 9)
z     <- lone(3, 9)
w0    <- lone(4, 9)
a     <- lone(5, 9)
b     <- lone(6, 9)
c     <- lone(7, 9)
d     <- lone(8, 9)
sqrt3 <- lone(9, 9)

# define the substitutions
X <- a*x  - b*y  - c*z  - d*w0
Y <- a*y  + b*x  + c*w0 - d*z
Z <- a*z  - b*w0 + c*x  + d*y
W <- a*w0 + b*z  - c*y  + d*x

# here is the polynomial of interest
P <- f(X, Y, Z, W, sqrt3)
```

Now we take the "xyz" part of each term:

``` r
# the exponents of x, y, z
xyz_powers <- P[["index"]][, c(1L, 2L, 3L)]

# the "keys" xyz(i,j,k) for POV-Ray
xyz_povray <- apply(xyz_powers, 1L, function(comp) {
  sprintf("xyz(%s): ", toString(comp))
})
```

Now we take the remaining part of each term:

``` r
# the other exponents, those of w0, a, b, c, d, sqrt3
other_powers <- P[["index"]][, c(4L, 5L, 6L, 7L, 8L, 9L)]

# the polynomials in w0, a, b, c, d, sqrt3
nterms <- length(P)
coeffs <- P[["value"]]
polynomials <- lapply(1L:nterms, function(i) {
  spray(other_powers[i, ], coeffs[i])
})
```

And we group these polynomials, putting together those which share the
same "xyz" part:

``` r
# group the polynomials which have the same x,y,z exponents
polynomials_groups <- sapply(split(polynomials, xyz_povray), function(polys) {
  polysum <- polys[[1]]
  for(poly in polys[-1]) {
    polysum <- spray_add(
      polysum$index, polysum$value, poly$index, poly$value
    )
  }
  as.spray(polysum)
}, simplify = FALSE)
# remove the empty polynomials, if there are some
polynomials_groups <- Filter(Negate(is.empty), polynomials_groups)
```

We want these polynomials as character strings:

``` r
# there's no as.character function for sprays (polynomials), so we make one
asCharacter <- function(poly) {
  op <- options(sprayvars = c("w0", "a", "b", "c", "d", "sqrt3"))
  x <- capture.output(print_spray_polyform(poly))
  options(op)
  paste0(x, collapse = " ")
}

polynomials_strings <- 
  sapply(polynomials_groups, asCharacter, simplify = FALSE)
```

And that's it. We have everything needed to construct the POV-Ray code:

``` r
head(polynomials_strings, 2L)
## $`xyz(0, 0, 0): `
## [1] "12749128107.8532 +1760*w0^7*c^6*d*sqrt3 -6*w0^10*d^10 +w0^12*b^12 +60*w0^12*b^2*c^4*d^6 +180*w0^12*a^4*b^2*c^2*d^4 +9498*w0^8*b^4*c^4 +44148*w0^8*a^4*b^2*d^2 +180*w0^12*a^4*b^2*c^4*d^2 +1068*w0^10*a^4*c^4*d^2 +30*w0^12*a^2*c^8*d^2 +2196*w0^10*a^4*b^2*d^4 +2519250.2222222*w0^6*a^2*b^4 +10209.6666667*w0^8*a^8 +6*w0^12*a^10*d^2 -12537.3333333*w0^8*a^2*d^6 +31964*w0^8*b^6*d^2 +2076*w0^10*b^4*c^4*d^2 +182*w0^10*b^10 +296*w0^10*a^2*c^6*d^2 +w0^12*a^12 +593516.8888889*w0^6*b^4*d^2 +2076*w0^10*b^4*c^2*d^4 -2933.3333333*w0^9*a^2*c^4*d^3*sqrt3 -1345147.5555556*w0^6*a^2*c^2*d^2 -1760*w0^9*a^2*c^6*d*sqrt3 -4697.3333333*w0^8*b^2*c^6 +18996*w0^8*b^4*c^2*d^2 -14022*w0^8*a^4*c^4 +386*w0^10*a^8*d^2 +6*w0^12*a^10*c^2 -317738.6666667*w0^7*b^2*c^4*d*sqrt3 -60*w0^10*c^6*d^4 +15*w0^12*a^4*c^8 +2136*w0^10*b^6*c^2*d^2 +180*w0^12*a^2*b^4*c^4*d^2 +60*w0^12*a^6*b^2*c^4 -6876*w0^8*a^2*b^2*c^4 +67668*w0^8*a^2*b^4*d^2 +60*w0^12*b^4*c^6*d^2 +15*w0^12*a^8*b^4 +30*w0^12*a^8*c^2*d^2 +20*w0^12*a^6*c^6 +632*w0^10*b^2*c^2*d^6 +722*w0^10*b^8*c^2 +67668*w0^8*a^2*b^4*c^2 +120*w0^12*a^6*b^2*c^2*d^2 -28355.5555556*w0^5*d^5*sqrt3 -37612*w0^8*a^2*c^2*d^4 +6*w0^12*a^2*d^10 -1124*w0^8*c^6*d^2 +1105545.7777778*w0^6*a^2*b^2*c^2 +722*w0^10*b^8*d^2 -586.6666667*w0^9*a^6*c^2*d*sqrt3 +6*w0^12*a^10*b^2 +2933.3333333*w0^7*c^4*d^3*sqrt3 -1173.3333333*w0^9*c^4*d^5*sqrt3 -1760*w0^9*a^2*b^4*c^2*d*sqrt3 +6*w0^12*a^2*b^10 +60*w0^12*a^2*b^4*d^6 +3144*w0^10*a^2*b^2*c^2*d^4 +30*w0^12*a^8*b^2*d^2 +30*w0^12*a^2*b^2*d^8 +356*w0^10*a^4*c^6 +1484*w0^10*a^4*b^6 +56711.1111111*w0^5*c^2*d^3*sqrt3 +44148*w0^8*a^4*b^2*c^2 +90*w0^12*a^4*c^4*d^4 +6*w0^12*a^2*c^10 -1124*w0^8*c^2*d^6 -37612*w0^8*a^2*c^4*d^2 +564*w0^10*a^6*c^4 -4733659.2592593*w0^5*a^2*d^3*sqrt3 +2552*w0^10*a^2*b^6*c^2 +15*w0^12*b^8*c^4 +85066.6666667*w0^5*c^4*d*sqrt3 +60*w0^12*a^2*b^6*c^4 +60*w0^12*b^6*c^2*d^4 -3520*w0^9*a^2*b^2*c^4*d*sqrt3 +1173.3333333*w0^9*a^2*b^2*d^5*sqrt3 +15*w0^12*a^4*d^8 +30*w0^12*a^8*b^2*c^2 +18049.6666667*w0^8*b^8 -1409995.5555556*w0^6*b^2*c^2*d^2 +w0^12*c^12 +60*w0^12*b^6*c^4*d^2 -14022*w0^8*a^4*d^4 +w0^12*d^12 +98*w0^10*a^10 +1048*w0^10*a^2*b^2*c^6 +90*w0^12*a^4*b^4*d^4 +60*w0^12*a^6*b^2*d^4 +5147478.5185185*w0^5*b^2*d^3*sqrt3 +31964*w0^8*b^6*c^2 +993249552.469136*w0^2*b^2 -281*w0^8*d^8 +30*w0^12*a^2*b^2*c^8 +90*w0^12*a^4*b^4*c^4 -656447.2222222*w0^4*d^4 +8444*w0^8*a^6*c^2 -211825.7777778*w0^7*b^2*c^2*d^3*sqrt3 +586.6666667*w0^7*c^2*d^5*sqrt3 +15*w0^12*b^4*d^8 +1073624.7407407*w0^6*b^6 -1760*w0^9*a^4*b^2*c^2*d*sqrt3 -66241728.3950617*w0^3*c^2*d*sqrt3 -1760*w0^9*b^2*c^6*d*sqrt3 +20*w0^12*a^6*b^6 -586.6666667*w0^9*b^6*c^2*d*sqrt3 +60*w0^12*b^2*c^6*d^4 +106499.5555556*w0^7*b^4*d^3*sqrt3 -656447.2222222*w0^4*c^4 -586.6666667*w0^9*b^2*c^2*d^5*sqrt3 +30*w0^12*a^2*b^8*c^2 +60*w0^12*a^4*b^6*d^2 -9660598.1481482*w0^4*b^2*d^2 -12537.3333333*w0^8*a^2*c^6 -97937.7777778*w0^7*a^4*d^3*sqrt3 -672573.7777778*w0^6*a^2*c^4 +586.6666667*w0^9*a^4*b^2*d^3*sqrt3 -1312894.4444444*w0^4*c^2*d^2 +3324*w0^10*a^4*b^4*d^2 +60*w0^12*a^4*b^6*c^2 +1880*w0^10*a^6*b^2*d^2 +586.6666667*w0^9*a^2*b^4*d^3*sqrt3 +5400*w0^10*a^2*b^4*c^2*d^2 +1048*w0^10*a^2*b^2*d^6 +23850915.7407407*w0^4*a^4 +60*w0^12*a^2*b^6*d^4 +60*w0^12*a^4*b^2*c^6 +586.6666667*w0^9*a^4*d^5*sqrt3 -27975709.2592593*w0^4*a^2*d^2 -30*w0^10*c^2*d^8 +60*w0^12*a^2*c^6*d^4 -30*w0^10*c^8*d^2 -704997.7777778*w0^6*b^2*d^4 +30*w0^12*a^2*b^8*d^2 +120*w0^12*a^2*b^2*c^6*d^2 +46326.6666667*w0^8*a^6*b^2 +255375.5555556*w0^6*d^6 +1068*w0^10*b^6*d^4 +20*w0^12*c^6*d^6 +60*w0^12*a^6*b^4*d^2 -224889.9259259*w0^6*c^6 +120*w0^12*a^2*b^2*c^2*d^6 +60*w0^12*a^6*b^4*c^2 +62006.6666667*w0^8*a^2*b^6 +8561.7777778*w0^7*a^2*b^2*d^3*sqrt3 +492736.7407407*w0^6*a^6 +60*w0^12*a^2*c^4*d^6 +3647719.5555556*w0^6*c^4*d^2 +60*w0^12*a^4*c^2*d^6 +20*w0^12*b^6*c^6 +15*w0^12*c^4*d^8 +15*w0^12*b^8*d^4 +6*w0^12*c^2*d^10 -14092*w0^8*b^2*c^2*d^4 +586.6666667*w0^9*b^2*d^7*sqrt3 +158*w0^10*b^2*d^8 +2700*w0^10*a^2*b^4*d^4 -32744490.7407408*w0^2*c^2 +586.6666667*w0^9*a^2*d^7*sqrt3 +692*w0^10*b^4*c^6 +90*w0^12*b^4*c^4*d^4 -704997.7777778*w0^6*b^2*c^4 +593516.8888889*w0^6*b^4*c^2 +195.5555556*w0^9*d^9*sqrt3 -25685.3333333*w0^7*a^2*b^2*c^2*d*sqrt3 +45052.8888889*w0^6*a^4*c^2 -6*w0^10*c^10 -319498.6666667*w0^7*b^4*c^2*d*sqrt3 +42166026.8518519*w0^4*b^4 +195.5555556*w0^9*b^6*d^3*sqrt3 +1105545.7777778*w0^6*a^2*b^2*d^2 +293813.3333333*w0^7*a^4*c^2*d*sqrt3 -586.6666667*w0^9*c^8*d*sqrt3 -531718486.740741*w0^4*a^2*b^2 +120*w0^12*a^2*b^6*c^2*d^2 -2933.3333333*w0^9*b^2*c^4*d^3*sqrt3 +2552*w0^10*a^2*b^6*d^2 +296*w0^10*a^2*c^2*d^6 +2700*w0^10*a^2*b^4*c^4 -32744490.7407408*w0^2*d^2 +6*w0^12*b^2*d^10 +444*w0^10*a^2*c^4*d^4 +3144*w0^10*a^2*b^2*c^4*d^2 +105912.8888889*w0^7*b^2*d^5*sqrt3 +195.5555556*w0^9*a^6*d^3*sqrt3 -3556262.6666667*w0^6*c^2*d^4 +180*w0^12*a^4*b^4*c^2*d^2 -4697.3333333*w0^8*b^2*d^6 +2196*w0^10*a^4*b^2*c^4 -15442435.5555556*w0^5*b^2*c^2*d*sqrt3 +6*w0^12*b^2*c^10 -60*w0^10*c^4*d^6 +158*w0^10*b^2*c^8 -1564.4444444*w0^9*c^6*d^3*sqrt3 +1880*w0^10*a^6*b^2*c^2 +295573.3333333*w0^7*a^2*c^4*d*sqrt3 +632*w0^10*b^2*c^6*d^2 +6*w0^12*b^10*d^2 +6*w0^12*b^10*c^2 +1068*w0^10*b^6*c^4 +60*w0^12*b^4*c^2*d^6 -1173.3333333*w0^9*a^4*c^2*d^3*sqrt3 +14200977.7777778*w0^5*a^2*c^2*d*sqrt3 +8444*w0^8*a^6*d^2 +564*w0^10*a^6*d^4 +15*w0^12*c^8*d^4 +9498*w0^8*b^4*d^4 +15*w0^12*a^8*d^4 +574*w0^10*a^8*b^2 -27975709.2592593*w0^4*a^2*c^2 +15*w0^12*b^4*c^8 +15*w0^12*a^4*b^8 -9660598.1481482*w0^4*b^2*c^2 +534826682.098766*w0^2*a^2 +60*w0^12*a^2*b^4*c^6 +180*w0^12*a^2*b^2*c^4*d^4 -98524.4444444*w0^7*a^2*d^5*sqrt3 +60*w0^12*a^6*c^2*d^4 +20*w0^12*b^6*d^6 +1960314.2222222*w0^6*a^4*b^2 +586.6666667*w0^9*b^4*d^5*sqrt3 +1068*w0^10*a^4*c^2*d^4 -1173.3333333*w0^9*b^4*c^2*d^3*sqrt3 +80074*w0^8*a^4*b^4 +20*w0^12*a^6*d^6 +74*w0^10*a^2*c^8 -14092*w0^8*b^2*c^4*d^2 +948*w0^10*b^2*c^4*d^4 +3324*w0^10*a^4*b^4*c^2 +30*w0^12*b^2*c^8*d^2 -586.6666667*w0^7*d^7*sqrt3 -1760*w0^9*b^4*c^4*d*sqrt3 +30*w0^12*b^2*c^2*d^8 +30*w0^12*a^2*c^2*d^8 -1686*w0^8*c^4*d^4 +15*w0^12*a^8*c^4 +180*w0^12*a^2*b^4*c^2*d^4 +356*w0^10*a^4*d^6 +692*w0^10*b^4*d^6 -6876*w0^8*a^2*b^2*d^4 +74*w0^10*a^2*d^8 -28044*w0^8*a^4*c^2*d^2 +826*w0^10*a^2*b^8 +1316*w0^10*a^6*b^4 +60*w0^12*a^4*b^2*d^6 +30*w0^12*b^8*c^2*d^2 -2346.6666667*w0^9*a^2*b^2*c^2*d^3*sqrt3 +6*w0^12*c^10*d^2 +1128*w0^10*a^6*c^2*d^2 +197048.8888889*w0^7*a^2*c^2*d^3*sqrt3 +60*w0^12*a^4*c^6*d^2 +60*w0^12*a^6*c^4*d^2 -672573.7777778*w0^6*a^2*d^4 +386*w0^10*a^8*c^2 +45052.8888889*w0^6*a^4*d^2 -13752*w0^8*a^2*b^2*c^2*d^2 +4392*w0^10*a^4*b^2*c^2*d^2 +22080576.1316872*w0^3*d^3*sqrt3 -586.6666667*w0^9*a^2*c^2*d^5*sqrt3 -1760*w0^9*a^4*c^4*d*sqrt3 -281*w0^8*c^8"
## 
## $`xyz(0, 0, 1): `
## [1] "-20384*w0^7*a*b^7 -672*w0^9*a*b^7*c^2 -672*w0^9*a*b^3*c^6 -408874.6666667*w0^6*a^3*b*d^3*sqrt3 -25685.3333333*w0^6*a^2*b^2*c^3*sqrt3 -15680*w0^7*a*b*c^6 +5280*w0^8*a^4*b^2*c*d^2*sqrt3 -84672*w0^7*a^3*b*c^2*d^2 -2235744*w0^5*a^3*b^3 +85066.6666667*w0^4*c^5*sqrt3 -1760*w0^8*a^4*b^2*c^3*sqrt3 -408874.6666667*w0^6*a*b*d^5*sqrt3 -672*w0^9*a*b*c^2*d^6 +5280*w0^8*b^2*c*d^6*sqrt3 -1008*w0^9*a^5*b*c^4 -168*w0^9*a^9*b -881440*w0^6*a^4*c*d^2*sqrt3 +14200977.7777778*w0^4*a^2*c^3*sqrt3 +198725185.185185*w0^2*c*d^2*sqrt3 -2016*w0^9*a^5*b^3*c^2 -672*w0^9*a^3*b*d^6 +5280*w0^8*b^4*c*d^4*sqrt3 -672*w0^9*a*b^7*d^2 +129696*w0^5*a*b*c^2*d^2 -1403248*w0^5*a*b^5 -51744*w0^7*a*b^3*d^4 -672*w0^9*a*b^3*d^6 +1226624*w0^6*a*b*c^4*d*sqrt3 -56448*w0^7*a*b^5*d^2 -4032*w0^9*a^3*b^3*c^2*d^2 +953216*w0^6*b^2*c*d^4*sqrt3 -170133.3333333*w0^4*c^3*d^2*sqrt3 -94080*w0^7*a^3*b^3*c^2 +958496*w0^6*b^4*c*d^2*sqrt3 -2016*w0^9*a^3*b^3*c^4 -162976*w0^5*a*b^3*c^2 -672*w0^9*a^7*b*d^2 -2016*w0^9*a^5*b^3*d^2 -42336*w0^7*a^5*b^3 +1760*w0^8*a^2*c^5*d^2*sqrt3 +293813.3333333*w0^6*a^4*c^3*sqrt3 +5280*w0^8*a^4*c*d^4*sqrt3 +4693.3333333*w0^8*c^3*d^6*sqrt3 +5280*w0^8*a^2*c*d^6*sqrt3 -672*w0^9*a^7*b*c^2 -2016*w0^9*a^3*b*c^4*d^2 +1226624*w0^6*a^3*b*c^2*d*sqrt3 -672*w0^9*a^3*b^7 -8800*w0^6*c^3*d^4*sqrt3 -37632*w0^7*a^5*b*d^2 -1760*w0^8*a^4*c^5*sqrt3 +635477.3333333*w0^6*b^2*c^3*d^2*sqrt3 -672*w0^9*a^7*b^3 -586.6666667*w0^8*a^6*c^3*sqrt3 +1760*w0^8*a^6*c*d^2*sqrt3 -586.6666667*w0^8*c^9*sqrt3 -42602933.3333333*w0^4*a^2*c*d^2*sqrt3 +1760*w0^8*b^6*c*d^2*sqrt3 -168*w0^9*a*b*c^8 -15680*w0^7*a*b*d^6 +64848*w0^5*a*b*d^4 +8644778.6666667*w0^5*c^5*d -255200*w0^4*c*d^4*sqrt3 -42336*w0^7*a^3*b*d^4 -47040*w0^7*a*b*c^2*d^4 -5280*w0^6*c*d^6*sqrt3 -3520*w0^8*a^2*b^2*c^5*sqrt3 -19762275.5555556*w0^4*a*b*d^3*sqrt3 -37632*w0^7*a^5*b*c^2 -408874.6666667*w0^6*a*b^3*d^3*sqrt3 -1008*w0^9*a*b*c^4*d^4 -964208*w0^5*a^5*b -672*w0^9*a*b*c^6*d^2 -47040*w0^7*a*b*c^4*d^2 +1158840636.44444*w0^3*a^3*b -15442435.5555556*w0^4*b^2*c^3*sqrt3 -886720*w0^6*a^2*c*d^4*sqrt3 -1008*w0^9*a^5*b*d^4 -1008*w0^9*a*b^5*c^4 -2016*w0^9*a^3*b*c^2*d^4 +77056*w0^6*a^2*b^2*c*d^2*sqrt3 -2016*w0^9*a*b^5*c^2*d^2 +8800*w0^8*b^2*c^3*d^4*sqrt3 +8800*w0^8*a^2*c^3*d^4*sqrt3 -36630222.2222222*w0^3*a*b*c^2 +295573.3333333*w0^6*a^2*c^5*sqrt3 -56448*w0^7*a*b^5*c^2 +3520*w0^8*b^4*c^3*d^2*sqrt3 +1760*w0^8*c*d^8*sqrt3 -103488*w0^7*a*b^3*c^2*d^2 -1760*w0^8*a^2*c^7*sqrt3 -2016*w0^9*a^3*b^5*d^2 -2016*w0^9*a*b^3*c^2*d^4 -586.6666667*w0^8*b^6*c^3*sqrt3 -162976*w0^5*a*b^3*d^2 +1760*w0^6*c^7*sqrt3 -319498.6666667*w0^6*b^4*c^3*sqrt3 -66241728.3950617*w0^2*c^3*sqrt3 +817749.3333333*w0^6*a*b*c^2*d^3*sqrt3 -168*w0^9*a*b^9 -28815928.8888889*w0^5*c^3*d^3 -1008*w0^9*a*b^5*d^4 -51744*w0^7*a^3*b^5 +59286826.6666667*w0^4*a*b*c^2*d*sqrt3 -672*w0^9*a^3*b*c^6 -1008*w0^9*a^5*b^5 -2030880*w0^5*a^3*b*c^2 -591146.6666667*w0^6*a^2*c^3*d^2*sqrt3 -1232101080.88889*w0^3*a*b^3 -2016*w0^9*a^3*b^3*d^4 +1760*w0^8*b^2*c^5*d^2*sqrt3 +3520*w0^8*a^4*c^3*d^2*sqrt3 +64848*w0^5*a*b*c^4 -916845740.740741*w0*a*b +1226624*w0^6*a*b^3*c^2*d*sqrt3 -2016*w0^9*a*b^3*c^4*d^2 -2016*w0^9*a^3*b^5*c^2 -317738.6666667*w0^6*b^2*c^5*sqrt3 -168*w0^9*a*b*d^8 +7040*w0^8*a^2*b^2*c^3*d^2*sqrt3 -36630222.2222222*w0^3*a*b*d^2 +3520*w0^8*c^5*d^4*sqrt3 -1760*w0^8*b^2*c^7*sqrt3 +5280*w0^8*a^2*b^4*c*d^2*sqrt3 -1760*w0^8*a^2*b^4*c^3*sqrt3 +46327306.6666667*w0^4*b^2*c*d^2*sqrt3 -51744*w0^7*a*b^3*c^4 +8644778.6666667*w0^5*c*d^5 -10976*w0^7*a^7*b -94080*w0^7*a^3*b^3*d^2 -2030880*w0^5*a^3*b*d^2 -2016*w0^9*a^5*b*c^2*d^2 +10560*w0^8*a^2*b^2*c*d^4*sqrt3 -1760*w0^8*b^4*c^5*sqrt3 -42336*w0^7*a^3*b*c^4 -1760*w0^6*c^5*d^2*sqrt3"
```
