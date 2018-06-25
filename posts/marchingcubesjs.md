---
author: Stéphane Laurent
date: '2018-06-25'
highlighter: 'pandoc-solarized'
output:
  html_document:
    highlight: kate
    keep_md: False
  md_document:
    preserve_yaml: True
    variant: markdown
prettify: True
prettifycss: minimal
tags: 'javascript, graphics, maths'
title: Marching cubes with Javascript
---

In [this gist of
mine](https://gist.github.com/stla/69bbbd59fab9d46cc5f49860eaf9f052),
there is a Javascript implementation of the marching cubes algorithm.
The code is an adaptation of the algorithm implemented in `misc3d`, a R
package written by Dai Feng and Luke Tierney.

The algorithm returns a triangulation of an isosurface, that is to say
the surface defined by an implicit equation $$
f(x,y,z) = \ell.
$$

The triangulation is returned by

``` {.js}
marchingCubes(f, l, xmin, xmax, ymin, ymax, zmin, zmax, nx, ny, nz)
```

where `xmin` and `xmax` are the bounds of the $x$ variable and `nx` is
the number of subdivisions between `xmin` and `xmax`, and similarly for
the $y$ and $z$ variables.

The output is a $(n \times 3)$-array of vertices. Grouping the rows by
chunks of three provides the triangles.

As an illustration, below is a Dupin cyclide triangulated by the
marching cubes algorithm and rendered with `three.js`.

<iframe src="../frames/threejs_cyclide.html" width="100%" height="500px" scrolling="no" frameborder="0">
</iframe>
