---
title: "The torus and the elliptic cyclide"
author: "Stéphane Laurent"
date: '2023-10-02'
tags: R, rgl, maths, geometry
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

The most used parameterization of the ordinary torus (the donut) is: $$
\textrm{torus}_{R,r}(u, v) = 
\begin{pmatrix}
(R + r \cos v) \cos u \\
(R + r \cos v) \sin u \\
r \sin v
\end{pmatrix}.
$$

The [elliptic Dupin
cyclide](https://en.wikipedia.org/wiki/Dupin_cyclide) is a
generalization of the torus. It has three nonnegative parameters
$c < \mu < a$, and its usual parameterization is, letting
$b = \sqrt{a^2 - c^2}$: $$
\textrm{cyclide}_{a, c, \mu}(u, v) = 
\begin{pmatrix}
\dfrac{\mu  (c - a \cos u \cos v) + b^2 \cos v}{a - c \cos u \cos v} \\
\dfrac{b (a - \mu \cos u) \sin v}{a - c \cos u \cos v} \\
\dfrac{b (c \cos v - \mu) \sin u}{a - c \cos u \cos v}
\end{pmatrix}.
$$ The picture below shows such a cyclide in its symmetry plane
$\{z = 0\}$:

![](./figures/cyclide_parameters.png)

For $c=0$, this is the torus.

Here is a cyclide in 3D (image taken from [this
post](https://laustep.github.io/stlahblog/posts/plotly_trisurf.html)):

![](./figures/cyclide_parametric_colored.png)

I think almost everything you can do with a torus, you can do it with a
cyclide. For example, a parameterization of the $(p,q)$-torus knot is $$
\textrm{torus}_{R, r}(pt, qt), \qquad 0 \leqslant t < 2\pi.
$$ Then, the *$(p,q)$-cyclide knot* is parameterized by $$
\textrm{cyclide}_{a, c, \mu}(pt, qt), \qquad 0 \leqslant t < 2\pi.
$$ ![](./figures/cyclideKnot.gif)

Here is a *cyclidoidal helix*:

![](./figures/cyclidoidalHelix.gif)

And here is a rotoid dancing around a cyclide:

![](./figures/cyclidoidalRotoid.gif)

I found the way to do this animation for the torus on [this
website](https://www.frassek.org/), and then I adapted it to the
cyclide.

The R code used to generate these animations is available in [this
gist](https://gist.github.com/stla/836d149189db9cea3d683868c1520776).
