---
title: "Runcinated tesseract (tetrahedra only)"
author: "Stéphane Laurent"
date: '2023-08-10'
tags: R, rgl, povray, geometry, python, graphics
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

The *runcinated tesseract* is a 4D polytope. Thanks to the **cxhull**
package, I extracted all the tetrahedral cells from it, I rounded them
and I plotted them with a 4D rotation and a stereographic projection. I
really like the result.

Here with Python:

![](./figures/runcinatedTesseract1_Python.gif)

Again with Python but with a space background:

![](./figures/runcinatedTesseract2_Python.gif)

Here with R in 3D rotation:

![](./figures/runcinatedTesseract1_R.gif)

Again with R but in 4D rotation:

![](./figures/runcinatedTesseract2_R.gif)

And finally wit POV-Ray:

![](./figures/runcinatedTesseract_POVRay.gif)

If you feel it, try to do it with Asymptote.

## Gists with code:

-   [Python](https://gist.github.com/stla/83925fce019921ec12440ad05fdcd213)

-   [R](https://gist.github.com/stla/61206316a3bc5a38c7268cec7ff3ca20)

-   [POV-Ray](https://gist.github.com/stla/3b5681a09c949b3a717f82f3e38e37fd)
