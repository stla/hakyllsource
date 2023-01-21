---
title: "More on the 'Reorient' transformation"
author: "Stéphane Laurent"
date: '2023-01-21'
tags: R, maths, geometry
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

I presented the 'Reorient' rotation in [a previous
post](https://laustep.github.io/stlahblog/posts/ReorientTransformation.html).

I figured out three things:

-   there's an easy precise definition of this rotation, that I didn't
    give;
-   this rotation has a simple quaternion representation;
-   this is the rotation I used to construct a mesh of a [torus passing
    through three
    points](https://laustep.github.io/stlahblog/posts/rglTorus.html).

Here is the function returning the matrix of this rotation:

``` r
# Cross product of two 3D vectors.
crossProduct <- function(v, w){
  c(
    v[2L] * w[3L] - v[3L] * w[2L],
    v[3L] * w[1L] - v[1L] * w[3L],
    v[1L] * w[2L] - v[2L] * w[1L]
  )
}
# The 'Reorient' rotation matrix. 
Reorient_Trans <- function(Axis1, Axis2){
  vX1 <- Axis1 / sqrt(c(crossprod(Axis1)))
  vX2 <- Axis2 / sqrt(c(crossprod(Axis2)))
  Y <- crossProduct(vX1, vX2)
  vY <- Y / sqrt(c(crossprod(Y)))
  Z1 <- crossProduct(vX1, vY)
  vZ1 <- Z1 / sqrt(c(crossprod(Z1)))
  Z2 <- crossProduct(vX2, vY)
  vZ2 <- Z2 / sqrt(c(crossprod(Z2)))
  M1 <- cbind(vX1, vY, vZ1)
  M2 <- rbind(vX2, vY, vZ2)
  M1 %*% M2
}
```

This rotation sends `Axis2` to `Axis1`. Actually it would be more
natural to take its inverse (whose matrix is obtained by transposition)
but I used it in the `transform3d` function of the **rgl** package and
this function requires the inverse of the transformation to be applied
(oddly).

Here is how to get its inverse from a quaternion:

``` r
library(onion)
# Get a rotation matrix sending `u` to `v`; 
#   the vectors `u` and `v` must be normalized.
uvRotation <- function(u, v) {
  re <- sqrt((1 + sum(u*v))/2)
  w <- crossProduct(u, v) / 2 / re
  q <- as.quaternion(c(re, w), single = TRUE)
  as.orthogonal(q) # quaternion to rotation matrix
}
```

As you can see, these two rotations indeed are inverse (transpose) of
each other:

``` r
u <- c(0, 0, 1)
v <- c(1, 1, 1) / sqrt(3)
Reorient_Trans(u, v)
##            [,1]       [,2]       [,3]
## [1,]  0.7886751 -0.2113249 -0.5773503
## [2,] -0.2113249  0.7886751 -0.5773503
## [3,]  0.5773503  0.5773503  0.5773503
uvRotation(u, v)
##            [,1]       [,2]      [,3]
## [1,]  0.7886751 -0.2113249 0.5773503
## [2,] -0.2113249  0.7886751 0.5773503
## [3,] -0.5773503 -0.5773503 0.5773503
```

Thus, `uvRotation(u, v)` is a rotation sending `u` to `v`. Such a
rotation is not unique. We can give a precise definition of this
rotation: this is the rotation which sends the plane orthogonal to `u`
and passing through the origin to the plane orthogonal to `v` and
passing through the origin.

And as I said in the introduction, this is the rotation I used to
construct a mesh of a torus "passing through three points". Indeed, I
firstly constructed a torus having $\{z = 0\}$ as equatorial plane, and
then I mapped it with a rotation and a translation. The rotation in
question is simply the `uvRotation(u, v)` transformation with
$u = (0,0,1)$, orthogonal to the plane $\{z = 0\}$, and $v$ the normal
of the plane passing through the three points. And the translation is
the one sending the origin to the circumcenter of the three points.
