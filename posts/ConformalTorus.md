---
title: "Mapping a picture on a donut or a Hopf torus"
author: "Stéphane Laurent"
date: '2022-06-30'
tags: R, maths, geometry, graphics, rgl
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

# The donut torus

Given a number $s \geqslant 1$, the following map: $$
(u, v) \mapsto (x, y, z) = 
\frac{\Bigl(s\cos\frac{u}{s}, s\sin\frac{u}{s}, \sin v\Bigr)}{\sqrt{s^2+1}-\cos v}
$$ is a *conformal parameterization* of the torus (the donut), where
$-s\pi \leqslant u < s\pi$ and $\pi \leqslant v < \pi$. I found it in
[this paper by J.M.
Sullivan](https://static1.bridgesmathart.org/2011/cdrom/proceedings/134/paper_134.pdf).
The number $s$ is the ratio of the major radius over the minor radius.

The conformality of the map has the following consequence: you can
easily map a doubly periodic image on the torus in such a way that it
will perfectly fit on the torus.

## Mapping a checkerboard

Let me show what I mean. The code below generates a mesh of the torus
with a checkerboard mapped on its surface:

``` {.r .numberLines}
library(rgl)
library(Rvcg) # to use vcgUpdateNormals()

torusMesh <- function(s, nu, nv){
  nu <- as.integer(nu)
  nv <- as.integer(nv)
  nunv <- nu * nv
  vs      <- matrix(NA_real_, nrow = 3L, ncol = nunv)
  tris1   <- matrix(NA_integer_, nrow = 3L, ncol = nunv)
  tris2   <- matrix(NA_integer_, nrow = 3L, ncol = nunv)
  u_ <- seq(-pi*s, pi*s, length.out = nu + 1L)[-1L]
  v_ <- seq(-pi, pi, length.out = nv + 1L)[-1L]
  scosu_ <- s * cos(u_ / s)
  ssinu_ <- s * sin(u_ / s)
  sinv_ <- sin(v_)
  w     <- sqrt(s*s + 1) - cos(v_)
  jp1_ <- c(2L:nv, 1L)
  j_ <- 1L:nv
  color <- NULL
  for(i in 1L:(nu-1L)){
    i_nv <- i*nv
    rg <- (i_nv - nv + 1L):i_nv
    vs[, rg] <- rbind(
      scosu_[i] / w,
      ssinu_[i] / w,
      sinv_     / w
    )
    color <- c(
      color,
      if(mod(floor(5 * u_[i] / (pi*s)), 2) == 0){
        ifelse(
          floor(5 * v_ / pi) %% 2 == 0, "yellow", "navy"
        )
      }else{
        ifelse(
          floor(5 * v_ / pi) %% 2 == 0, "navy", "yellow"
        )
      }
    )
    k1 <- i_nv - nv
    k_ <- k1 + j_
    l_ <- k1 + jp1_
    m_ <- i_nv + j_
    tris1[, k_] <- rbind(m_, l_, k_)
    tris2[, k_] <- rbind(m_, i_nv + jp1_, l_)
  }
  i_nv <- nunv
  rg <- (i_nv - nv + 1L):i_nv
  vs[, rg] <- rbind(
    scosu_[nu] / w,
    ssinu_[nu] / w,
    sinv_      / w
  )
  color <- c(
    color,
    ifelse(
      floor(5 * v_ / pi) %% 2 == 0, "yellow", "navy"
    )
  )
  k1 <- i_nv - nv
  l_ <- k1 + jp1_
  k_ <- k1 + j_
  tris1[, k_] <- rbind(j_, l_, k_)
  tris2[, k_] <- rbind(j_, jp1_, l_)
  tmesh <- tmesh3d(
    vertices    = vs,
    indices     = cbind(tris1, tris2),
    homogeneous = FALSE,
    material    = list("color" = color)
  )
  vcgUpdateNormals(tmesh)
}
```

Let's see:

``` r
mesh <- torusMesh(s = sqrt(2), nu = 500, nv = 500)

open3d(windowRect = c(50, 50, 562, 562), zoom = 0.85)
bg3d("gainsboro")
shade3d(mesh)
```

![](./figures/ConformalTorusCheckerboard.gif){width="55%"}

Now you surely see what I mean.

## Mapping a Gray-Scott picture

I am a fan of the [Fronkonstin blog](https://fronkonstin.com/). Maybe
you already see [this article about the Gray-Scott reaction-diffusion
model](https://fronkonstin.com/2019/12/28/reaction-diffusion/) (it
appeared on R-bloggers). It shows how to generate some beautiful
pictures which are doubly periodic. So let's map such a picture on the
donut:

``` {.r .numberLines}
......

fcolor <- colorRamp(viridisLite::magma(255L))
getColors <- function(B){
  rgbs <- fcolor(B)
  rgb(rgbs[, 1L], rgbs[, 2L], rgbs[, 3L], maxColorValue = 255)
}

X <- iterate_Gray_Scott(X, L, DA, DB, 500)
Colors <- getColors(c(X[,,2L]))

mesh <- torusMesh(s = sqrt(2), nu = 600, nv = 600)
mesh[["material"]] <- list("color" = Colors)

open3d(windowRect = c(50, 50, 562, 562), zoom = 0.85)
bg3d("gainsboro")
shade3d(mesh)
```

![](./figures/ConformalTorusGrayScott.gif){width="55%"}

Beautiful!

# The Hopf torus

We can similarly map a picture on a Hopf torus, with this conformal
parameterization:

``` {.r .numberLines}
HT <- function(h, nlobes, t, phi){
  # the spherical curve
  p1 <- sin(h * cos(nlobes*t))
  p2 <- cos(t) * cos(h * cos(nlobes*t))
  p3 <- sin(t) * cos(h * cos(nlobes*t))
  # parameterization
  yden <- sqrt(2*(1+p1))
  y1 <- (1+p1)/yden
  y2 <- p2/yden
  y3 <- p3/yden
  cosphi <- cos(phi)
  sinphi <- sin(phi)
  x1 <- cosphi*y1
  x2 <- sinphi*y1
  x3 <- cosphi*y2 - sinphi*y3
  x4 <- cosphi*y3 + sinphi*y2  
  return(rbind(x1/(1-x4), x2/(1-x4), x3/(1-x4)))
}
```

## Checkerboard

The code to construct the mesh with the checkerboard is similar to the
one for the donut torus:

``` {.r .numberLines}
HopfTorusMesh <- function(h, nlobes, nu, nv){
  nu <- as.integer(nu)
  nv <- as.integer(nv)
  vs    <- matrix(NA_real_, nrow = 3L, ncol = nu*nv)
  tris1 <- matrix(NA_integer_, nrow = 3L, ncol = nu*nv)
  tris2 <- matrix(NA_integer_, nrow = 3L, ncol = nu*nv)
  u_ <- seq(-pi, pi, length.out = nu + 1L)[-1L]
  v_ <- seq(-pi, pi, length.out = nv + 1L)[-1L]
  jp1_ <- c(2L:nv, 1L)
  j_ <- 1L:nv
  color <- NULL
  for(i in 1L:(nu-1L)){
    i_nv <- i*nv
    vs[, (i_nv - nv + 1L):i_nv] <- HT(h, nlobes, u_[i], v_)
    color <- c(
      color,
      if(mod(floor(10 * u_[i] / pi), 2) == 0){
        ifelse(
          floor(10 * v_ / pi) %% 2 == 0, "yellow", "navy"
        )
      }else{
        ifelse(
          floor(10 * v_ / pi) %% 2 == 0, "navy", "yellow"
        )
      }
    )
    k1 <- i_nv - nv
    k_ <- k1 + j_
    l_ <- k1 + jp1_
    m_ <- i_nv + j_
    tris1[, k_] <- rbind(k_, l_, m_)
    tris2[, k_] <- rbind(l_, i_nv + jp1_, m_)
  }
  i_nv <- nu*nv
  vs[, (i_nv - nv + 1L):i_nv] <- HT(h, nlobes, pi, v_)
  color <- c(
    color,
    ifelse(
      floor(10 * v_ / pi) %% 2 == 0, "yellow", "navy"
    )
  )
  k1 <- i_nv - nv
  k_ <- k1 + j_
  l_ <- k1 + jp1_
  tris1[, k_] <- rbind(k_, l_, j_)
  tris2[, k_] <- rbind(l_, jp1_, j_)
  vcgUpdateNormals(tmesh3d(
    vertices    = vs,
    indices     = cbind(tris1, tris2),
    homogeneous = FALSE,
    material    = list("color" = color) 
  ))
}

mesh <- HopfTorusMesh(h = 0.4, nlobes = 4, nu = 500, nv = 500)

open3d(windowRect = c(50, 50, 562, 562), zoom = 0.85)
bg3d("gainsboro")
shade3d(mesh)
```

![](./figures/ConformalHopfTorusCheckerboard.gif){width="55%"}

I really like it.

## Gray-Scott picture

To map the Gray-Scott picture, we proceed as for the donut torus. Here
is the result:

![](./figures/ConformalHopfTorusGrayScott.gif){width="55%"}