---
title: "Boolean operations on meshes with R(CGAL)"
author: "Stéphane Laurent"
date: '2022-05-14'
tags: geometry, R, rgl, graphics, C++
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

I'm still working on my package **RCGAL**, that I already present in [a
previous post](./SurfaceReconstruction.html).

This previous post was about the reconstruction of surfaces. Now I
implemented the *Boolean operations on meshes*. Here are some simple
examples.

#### Union of two cubes:

![](./figures/cubesUnion.png)

#### Intersection of two cubes (one rotated):

![](./figures/interCubeRotatedCube.gif)

#### Difference of two cubes:

![](./figures/cubesDifference.png)

#### Intersection of a cube and a truncated icosahedron:

![](./figures/cubesIntersection.png)

The code generating these plots is given in the RCGAL examples.

Now let's turn to a more interesting example.

## The compound of five tetrahedra

The compound of five tetrahedra is provided by **RCGAL**. These are five
tetrahedra in a pretty configuration, each centered at the origin. You
can get their meshes by typing `tetrahedraCompound`. This is a list with
two components: a field `meshes` providing for each tetrahderon its
vertices and its faces, and a field `rglmeshes`, similar to `meshes` but
these meshes are ready for plotting with the **rgl** package. Here it
is:

``` r
library(RCGAL)
library(rgl)
rglmeshes <- tetrahedraCompound[["rglmeshes"]]
open3d(windowRect = c(50, 50, 562, 562), zoom = 0.75)
bg3d("#363940")
colors <- hcl.colors(5, palette = "Spectral")
invisible(lapply(
  1:5, function(i) shade3d(rglmeshes[[i]], color = colors[i])
))
```

![](./figures/tetrahedraCompound.gif)

I wondered for a long time what is the intersection of these five
tetrahedra. But I didn't have any tool to compute it. Now I have. Let's
see.

``` r
# compute the intersection ####
inter <- MeshesIntersection(
  tetrahedraCompound[["meshes"]], numbersType = "lazyExact", clean = TRUE
)
# plot ####
open3d(windowRect = c(50, 50, 562, 562), zoom = 0.75)
bg3d("#363940")
# first the five tetrahedra with transparency ####
invisible(lapply(
  rglmeshes, shade3d, color = "yellow", alpha = 0.1
))
# now the intersection ####
rglinter <- tmesh3d(
  "vertices"    = t(inter[["vertices"]]),
  "indices"     = t(inter[["faces"]]),
  "homogeneous" = FALSE
)
shade3d(rglinter, color = "gainsboro")
# and finally the edges ####
plotEdges(
  inter[["vertices"]], inter[["exteriorEdges"]],
  only = inter[["exteriorVertices"]], color = "darkmagenta"
)
```

Here is the result:

![](./figures/tetrahedraCompoundIntersection.gif)

This is an icosahedron, I think.

Unfortunately, R CMD CHECK still throws some warnings which prevent me
to publish this package on CRAN. I hope this issue will be solved.
