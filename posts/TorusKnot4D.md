---
title: "Four-dimensional torus knots"
author: "Stéphane Laurent"
date: '2024-05-13'
tags: R, maths, rgl, geometry
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

Here is a parameterization of a four-dimensional torus knot: $$
p(\theta, \phi) = \begin{pmatrix}
\cos\theta \cdot \cos\phi \\
\cos\theta \cdot \sin\phi \\
\sin\theta \cdot \cos 3\phi/2 \\
\sin\theta \cdot \cos 3\phi/2
\end{pmatrix}
$$ It takes its values in the 3-sphere. We use the stereographic
projection to project from the 3-sphere to the three-dimensional space,
and then we will try to visualize the stereographic projection of this
knot.

``` r
trefoil4D <- function(theta, phi) {
  cbind(
    cos(theta) * cos(phi), 
    cos(theta) * sin(phi), 
    sin(theta) * cos(1.5*phi), 
    sin(theta) * sin(1.5*phi)
  )
}

trefoil3D <- function(theta, phi) {
  q <- trefoil4D(theta, phi)
  q[, c(1L,2L,3L)] / (1 - q[, 4L])
}
```

One possible way to visualize it consists in plotting some tubes around
the curves $\phi \mapsto \textrm{Stereo}\bigl(p(\theta, \phi)\bigr)$ for
a series of values of $\theta$.

``` r
library(rgl)
# take 6 values of theta
theta_ <- seq(0, by = 0.175, length.out = 6L)
# phi ranges from 0 to 4*pi
phi_   <- seq(0, 4*pi, length.out = 400L)
# plot
open3d(windowRect = 50 + c(0, 0, 512, 512), zoom = 0.95)
for(theta in theta_) {
  pts <- trefoil3D(theta, phi_)
  tube <- addNormals(
    cylinder3d(pts, radius = 0.05, sides = 30),
  )
  shade3d(tube, color = "navy")
}
```

![](./figures/TrefoilKnot4D_tubes.gif)

Another way to visualize it consists in plotting again such tubes and to
plot the surfaces between them, using alternating colors. But wait, I
will comment that after displaying this plot. I use the `parametricMesh`
function of the [**cgalMeshes**
package](https://github.com/stla/cgalMeshes) to create the meshes of the
surfaces (this package has been archived on CRAN but hopefully it will
be back soon).

``` r
library(cgalMeshes)
# tubes
phi_ <- seq(0, 4*pi, length.out = 400L)
pts <- trefoil3D(pi/12, phi_)
tube1 <- addNormals(
  cylinder3d(pts, radius = 0.05, sides = 30),
)
pts <- trefoil3D(pi/6, phi_)
tube2 <- addNormals(
  cylinder3d(pts, radius = 0.05, sides = 30),
)
pts <- trefoil3D(pi/4, phi_)
tube3 <- addNormals(
  cylinder3d(pts, radius = 0.05, sides = 30),
)
# surfaces; we need to transpose in order to use `parametricMesh`
trefoil <- function(theta, phi) {
  t(trefoil3D(theta, phi))
}
mesh1 <- addNormals(parametricMesh(
  trefoil, c(0, pi/12), c(0, 4*pi), periodic = c(FALSE, TRUE),
  nu = 50L, nv = 600L
))
mesh2 <- addNormals(parametricMesh(
  trefoil, c(pi/12, pi/6), c(0, 4*pi), periodic = c(FALSE, TRUE),
  nu = 50L, nv = 600L
))
mesh3 <- addNormals(parametricMesh(
  trefoil, c(pi/6, pi/4), c(0, 4*pi), periodic = c(FALSE, TRUE),
  nu = 50L, nv = 600L
))
# plot
open3d(windowRect = 50 + c(0, 0, 512, 512), zoom = 0.9)
shade3d(mesh1, color = "navy")
shade3d(mesh2, color = "yellow")
shade3d(mesh3, color = "navy")
shade3d(tube1, color = "darkred")
shade3d(tube2, color = "darkred")
shade3d(tube3, color = "darkred")
```

![](./figures/TrefoilKnot4D_fillings.gif)

Now here is my promised comment. Do you notice something strange? I said
we will fill the surfaces between the tubes. However there are three
tubes and there are three surfaces.

Go to [this
gist](https://gist.github.com/stla/74e14eeac39d75d1bc1945c7cb1fd54e) if
you want to play with other four-dimensional torus knots.