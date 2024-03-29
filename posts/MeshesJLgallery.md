---
title: "My 'Meshes.jl' gallery"
author: "Stéphane Laurent"
date: "2023-10-12"
tags: julia, graphics, geometry
output:
  md_document:
    variant: markdown
    preserve_yaml: true
  html_document:
    highlight: kate
    keep_md: no
highlighter: pandoc-solarized
---

I really like the Julia package **Meshes.jl**. In this post, I show some
pictures and animations I did with this package.

### Hopf torus

If you know my blog, then you know my fascination for Hopf tori. Here is
one.

![](./figures/jl_HopfTorus.gif)

[Code](https://gist.github.com/stla/2e00dbb08079bc41b7eb26544c2608f6)

### Hopf torus circle by circle

The same one, but plotted circle by circle.

![](./figures/jl_HopfTorus_CbyC.png)

[Code](https://gist.github.com/stla/50e904e3a974a801659d495efa565adf)

### Nested Steiner chain

I already showed on this blog how to draw a nested Steiner chain with
different programming languages. Here is the Julia way.

![](./figures/jl_SteinerChain_4-3.gif)

[Code](https://gist.github.com/stla/6d97e31721cec447b3c401bcc2529660)

### Barth sextic

One of my favorite isosurfaces. It is done with the help of the
**MarchingCubes.jl** package.

![](./figures/jl_BarthSextic.gif)

[Code](https://gist.github.com/stla/706af2eaae5419f66765343e3fde06e8)

### Hyperbolic icosahedron

It is constructed with the help of the [gyrovector space
theory](https://laustep.github.io/stlahblog/posts/hyperbolicPolyhedra.html).

![](./figures/jl_gyroIcosahedron.png)

One can change the hyperbolic curvature:

![](./figures/jl_gyroIcosahedron.gif)

[Code](https://gist.github.com/stla/5a854243fa64290ec8dc0780db29ef34)

### Linked cyclides

Now we switch to the 4D world. Here are three linked cyclides.

![](./figures/jl_LinkedCyclides.png)

[Code](https://gist.github.com/stla/a8f307695118cd9fbea08a8cca7ba49a)

### Tesseract

Also known as the hypercube.

![](./figures/jl_tesseract.gif)

[Code](https://gist.github.com/stla/32426518a9e0b089ec51f4d81b3f2738)

### Duoprism 3,30

I already showed on this blog how to draw a duoprism with different
programming languages. Here is the Julia way.

![](./figures/jl_Duoprism_3-30.gif)

[Code](https://gist.github.com/stla/fa76ff2022b780db881c12f73e40a354#file-duoprism3-jl)

### Duoprism 30,30

And here is the (30,30)-duoprism.

![](./figures/jl_Duoprism_30-30.gif)

[Code](https://gist.github.com/stla/fa76ff2022b780db881c12f73e40a354#file-duoprism3-jl)
