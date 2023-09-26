---
title: "Hopf torus, circle by circle"
author: "Stéphane Laurent"
date: '2022-06-13'
tags: geometry, R, rgl, graphics, maths
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

Remember my [first
post](https://laustep.github.io/stlahblog/posts/HopfTorus_3over3.html)
on the Hopf torus? I constructed it circle by circle. Below are some
animations of this construction. I save the image each time a circle is
added. The **rgl** package automatically centers the plot, and this
gives a nice effect.

First animation, three lobes, using a [modified stereographic
projection](https://laustep.github.io/stlahblog/posts/ModifiedStereographicProjection.html):

![](./figures/HopfTorusCircleByCircle_3lobes.gif)

Here is the code producing this animation:

``` {.r .numberLines}
# Hopf fiber
HopfFiber <- function(q, t){ 
  1/sqrt(2*(1+q[1L])) * c(q[3L]*cos(t) + q[2L]*sin(t),
                          q[2L]*cos(t) - q[3L]*sin(t),
                          sin(t)*(1+q[1L]),
                          cos(t)*(1+q[1L])) 
}
# Modified stereographic projection
mstereog <- function(x){
  acos(x[4L])/sqrt(1-x[4L]^2) * x[1L:3L]
}

# plot
library(rgl)
open3d(windowRect = c(50, 50, 562, 562))
bg3d("#666970")
view3d(0, 0, zoom = 0.9)
t_ <- seq(0, 2*pi, len = 200L) # 200 subdivisions per circle
u_ <- seq(0, 2*pi, len = 300L) # 300 circles
nlobes <- 3L # number of lobes of the Hopf torus
colors <- colorRampPalette( # colors
  head(trekcolors::trek_pal("klingon"), -2L),
  interpolate = "spline", bias = 0.15
)(150L)
colors <- c(colors, rev(colors))
for(i in 1:length(u_)){
  u <- u_[i]
  x <-  cos(pi/2 - (pi/2-0.44)*cos(nlobes*u))
  z <-  sin(pi/2 - (pi/2-0.44)*cos(nlobes*u)) * cos(u+0.44*sin(2*nlobes*u))
  y <- -sin(pi/2 - (pi/2-0.44)*cos(nlobes*u)) * sin(u+0.44*sin(2*nlobes*u))
  circle4d <- vapply(t_, function(t){
    HopfFiber(c(x, y, z), t)  
  }, numeric(4L))
  circle3d <- t(apply(circle4d, 2L, mstereog))
  shade3d(
    cylinder3d(circle3d, radius = 0.1, sides = 15), 
    color = colors[i]
  )
  rgl.snapshot(sprintf("pic%03d.png", i)) # save
}

# duplicate last pic to make a pause at the end of the animation
for(i in 301L:350L){
  file.copy("pic300.png", sprintf("pic%03d.png", i))
}
# make animation
pngFiles <- list.files(pattern = "^pic?.*png$")
library(gifski)
gifski(
  pngFiles,
  gif_file = "HopfTorusCircleByCircle_3lobes.gif",
  width    = 512, height   = 512,
  delay    = 1/9 # 9 pics per second
)
# delete png files
file.remove(pngFiles)
```

Four lobes, modified stereographic projection, with the 'rocket' color
palette (in **grDevices** package):

![](./figures/HopfTorusCircleByCircle_4lobes.gif)

Two lobes, classical stereographic projection:

![](./figures/HopfTorusCircleByCircle_2lobes.gif)
