---
title: "Elliptic cyclide by inversion of a torus"
author: "Stéphane Laurent"
date: '2023-10-03'
tags: R, rgl, povray, maths, geometry
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

An [elliptic Dupin
cyclide](https://laustep.github.io/stlahblog/posts/torusAndCyclide.html)
can be obtained by
[inversion](https://en.wikipedia.org/wiki/Inversive_geometry) of a torus
with respect to a sphere. In the [previous
post](https://laustep.github.io/stlahblog/posts/torusAndCyclide.html), I
showed a rotoid (an helix) dancing around a cyclide:

![](./figures/cyclidoidalRotoid.gif)

I constructed this dancing rotoid in the same way as the dancing rotoid
around a torus:

![](./figures/rotoidAroundTorus.gif)

Click
[here](https://gist.github.com/stla/46ae563ebe53123cc8cb36590f82bded) if
you want the POV-Ray code for this animation.

Now, what happens if one inverts these two geometrical objects, the
torus and the rotoid, with respect to a sphere? The torus will become a
cyclide, as previously said, and what will happen for the rotoid? Here
is the answer:

![](./figures/cyclidoidalRotoidByInversion.gif)

The R code for this animation is provided in [this
gist](https://gist.github.com/stla/836d149189db9cea3d683868c1520776) (if
it looks complicated, that's because I start with the cyclide, and I
derive the torus and the inversion which yield this cyclide).

Another nice application of this mathematical fact is the construction
of *Steiner chains*:

![](./figures/SteinerChain2D.gif)

(code available in this
[gist](https://gist.github.com/stla/e93995905bb70c54c6bd49acfa9eb635)).

The point $I$ is the center of the circle of inversion. The above
animation shows a 2D Steiner chain but we can do the same in 3D. When
there are six spheres, this is called a *Soddy hexlet*. Here is a Soddy
hexlet with the *Villarceau circles* of the cyclide:

![](./figures/SoddyHexletVillarceau.gif)

The R code which produces this animation is provided in [this
gist](https://gist.github.com/stla/1665769586127f95547cd32a969d1352).

I did the same picture with POV-Ray:

![](./figures/SteinerChainVillarceau.gif)

Go to [this
gist](https://gist.github.com/stla/4a1816abb5de4a5f1c121869a5ec0aaa) if
you want the code.

And maybe you remember [this previous
post](https://laustep.github.io/stlahblog/posts/SteinerChains.html),
where I show how one can construct *nested* 3D Steiner chains.