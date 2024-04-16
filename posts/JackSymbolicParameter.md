---
title: "Jack polynomials with symbolic parameter"
author: "Stéphane Laurent"
date: '2024-04-16'
tags: R, maths, haskell, julia, Rcpp
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

Nice achievment: I have been able to implement the Jack polynomials with
a symbolic Jack parameter, in Haskell and in R. My Julia package
**JackPolynomials**, a couple of years old, allows to get them as well:

    julia> using JackPolynomials
    julia> JackPolynomial(2, [3; 1])
    (2*alpha^2 + 4*alpha + 2)*x_1^3*x_2 + (4*alpha + 4)*x_1^2*x_2^2 + (2*alpha^2 + 4*alpha + 2)*x_1*x_2^3

But the Haskell implementation and the R implementation required much
more work. As compared to Julia, I also have to implement some stuff to
deal with polynomials with symbolic coefficients. Such stuff is
available in Julia, I didn't have to implement it myself.

In Haskell, the multivariate polynomials with symbolic coefficients are
implemented in my package **hspray**. In R, they are implemented in my
package **symbolicQspray** (I'm tempted to rename it to
**parametricQspray**).

Let's compute a Jack polynomial in R:

``` r
library(jack)
JackSymPol(2, c(3, 1))
## { [ 2*a^2 + 4*a + 2 ] } * X^3.Y  +  { [ 4*a + 4 ] } * X^2.Y^2  +  { [ 2*a^2 + 4*a + 2 ] } * X.Y^3
```

This is a `symbolicQspray` object. The **symbolicQspray** package is
loaded when you load the **jack** package. A `symbolicQspray` object
represents a multivariate polynomial whose coefficients are *fractions
of polynomials with rational coefficients*. However I do not consider
them as polynomials on the field of fractions of polynomials, but rather
as polynomials with rational coefficients depending on some parameters,
the dependence being described by a fraction of polynomials. The
variables of the fractions of polynomials represent these parameters.

Jack polynomials have one parameter, the *Jack parameter*. It is denoted
by `a` in the above output of `JackSymPol`. You do not see any fraction
of polynomials in this output, only polynomials. In fact, from the
definition of the Jack polynomials, as well as from their
implementation, the coefficients of these polynomials *are* fractions of
polynomials in the Jack parameter. But you will never see a fraction in
the output of `JackSymPol`: by an amazing theorem (the [Knop & Sahi
formula](https://en.wikipedia.org/wiki/Jack_function#Combinatorial_formula)),
the coefficients always are polynomials in the Jack parameter.

That explains why there are two levels of enclosing braces around the
coefficients: `{ [ ... ] }`: the right brackets `[` and `]` enclose the
numerator of the fraction (the denominator is dropped since it is one),
and the curly braces `{` and `}` enclose the fraction. I don't want to
remove the right brackets when there's no denominator, because they
indicate that the present object conceptually is a fraction of
polynomials, not a polynomial. With the wording of my packages, this is
a `ratioOfQsprays` object, not a `qspray` object.

The `ratioOfQsprays` objects are defined in my package
**ratioOfQsprays**. A `ratioOfQsprays` object is nothing but a pair of
`qspray` objects (defined in my package **qspray**), the numerator and
the denominator, but the result of an arithmetic operation performed on
these objects is always written as an irreducible fraction. This
irreducible fraction is obtained thanks to the C++ library **CGAL**,
which provides a very fast implementation of the greatest common divisor
and of the division of two multivariate polynomials.

In my Haskell package **hspray**, the "parametric polynomials" are the
objects of type `SymbolicSpray` (that I will possibly rename to
`ParametricSpray`). These objects represent multivariate polynomials
whose coefficients are fractions of *univariate* polynomials, whereas
the R objects `ratioOfQsprays` represent fractions of *multivariate*
polynomials. Univariate fractions of polynomials are enough for the Jack
polynomials. I restricted myself to univariate polynomials because it is
possible to deal with ratios of such polynomials with the
**numeric-prelude** library, and I decided to use this stuff to have
less work to achieve. But I have everything needed to introduce the
fractions of multivariate polynomials and to use them as coefficients.
Maybe in the future. Please let me know if you have a use case.

By the way, I'm wondering who uses my R package **jack**. I can see [it
is downloaded](https://hadley.shinyapps.io/cran-downloads/).
Implementing the Jack polynomials was very interesting, but I do not
know what they are useful for. Same question for my Python package
[**jackpy**](https://github.com/stla/jackpy), which has a couple of
stars on Github. Note that Jack polynomials with symbolic Jack parameter
are not available in this package. This should be probably doable with a
moderate modification of my code.

Note that Jack polynomials are often very long. For example, but this
one is not so long:

``` r
( jp <- JackSymPol(3, c(3, 1)) )
## { [ 2*a^2 + 4*a + 2 ] } * X^3.Y  +  { [ 2*a^2 + 4*a + 2 ] } * X^3.Z  +  { [ 4*a + 4 ] } * X^2.Y^2  +  { [ 6*a + 10 ] } * X^2.Y.Z  +  { [ 4*a + 4 ] } * X^2.Z^2  +  { [ 2*a^2 + 4*a + 2 ] } * X.Y^3  +  { [ 6*a + 10 ] } * X.Y^2.Z  +  { [ 6*a + 10 ] } * X.Y.Z^2  +  { [ 2*a^2 + 4*a + 2 ] } * X.Z^3  +  { [ 2*a^2 + 4*a + 2 ] } * Y^3.Z  +  { [ 4*a + 4 ] } * Y^2.Z^2  +  { [ 2*a^2 + 4*a + 2 ] } * Y.Z^3
```

But these polynomials are symmetric, so you can get a considerably
shorter expression by writing them as a linear combination of the
monomial symmetric polynomials:

``` r
compactSymmetricQspray(jp)
## [1] "{ [ 2*a^2 + 4*a + 2 ] } * M[3, 1]  +  { [ 4*a + 4 ] } * M[2, 2]  +  { [ 6*a + 10 ] } * M[2, 1, 1]"
```

Finally, a few words about the efficiency. Here is a benchmark in R, for
the Jack polynomial of the integer partition $[4, 2, 2, 1]$ with $5$
variables (everything is implemented in C++):

``` r
library(microbenchmark)
microbenchmark(
  JackSymPol = JackSymPol(n, lambda),
  setup = {
    n <- 5
    lambda <- c(4, 2, 2, 1)
  },
  times = 5,
  unit = "seconds"
)
## Unit: seconds
##        expr      min      lq     mean   median       uq      max neval
##  JackSymPol 2.659117 2.76353 3.041557 2.787248 3.427619 3.570271     5
```

Haskell is faster: it takes about $550$ milliseconds. And
unsurprisingly, Julia is the winner: about $350$ milliseconds (with
Julia 1.9.1). So the **Rcpp** implementation is a bit slow.