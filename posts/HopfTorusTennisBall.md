---
author: Stéphane Laurent
date: '2018-08-30'
highlighter: kate
linenums: True
output:
  html_document:
    keep_md: False
  md_document:
    preserve_yaml: True
    variant: markdown
prettify: True
prettifycss: 'twitter-bootstrap'
tags: 'graphics, geometry, maths'
title: The Hopf torus of the tennis ball curve
---

In [a previous
post](https://laustep.github.io/stlahblog/posts/HopfTorusParametric.html)
I explain the construction of the Hopf torus of a closed curve on the
sphere, and I show the rendering for a certain spherical curve.

On [Paul Bourke's
site](http://paulbourke.net/geometry/spherical/index.html), I've found
another spherical curve for which the corresponding Hopf torus is
prettier.

This spherical curve is defined by the three coordinates $$
\begin{cases}
p_1(t) & = & \sin\bigl(\pi/2 - (\pi/2 - A) \cos(t)\bigr) 
\cos\bigl(t/n + A \sin(2t)\bigr) \\ 
p_2(t) & = & \sin\bigl(\pi/2 - (\pi/2 - A) \cos(t)\bigr) 
\sin\bigl(t/n + A \sin(2t)\bigr) \\ 
p_3(t) & = & \cos\bigl(\pi/2 - (\pi/2 - A) \cos(t)\bigr)
\end{cases}
$$ for $t$ varying from $0$ to $2n\pi$.

This is this curve:

<iframe src="../frames/threejs_TennisBall.html" width="100%" height="500px" scrolling="no" frameborder="0">
</iframe>
For $n=2$ and $A \approx 0.44$ it looks like the curve appearing on a
tennis ball.

For $n=3$ and $A = 0.44$, here is the correspondiing Hopf torus
(rendered with Asymptote):

![](figures/HopfTorusTennisBall.png)

The parameter $n$ defines the number of lobes of the torus. You can play
with it below.

<iframe src="../frames/threejs_HopfTorusParametric2.html" width="100%" height="500px" scrolling="no" frameborder="0">
</iframe>
