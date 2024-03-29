---
author: Stéphane Laurent
date: '2022-01-20'
highlighter: 'pandoc-solarized'
output:
  html_document:
    highlight: kate
    keep_md: no
  md_document:
    preserve_yaml: True
    variant: markdown
tags: 'graphics, python, pyvista, geometry'
title: My PyVista artworks
---

I like the Python library **PyVista** very much. In this blog post I
show a sample of the animations I realized with this library.

Github repositories
===================

[PyVistaMiscellanous](https://github.com/stla/PyVistaMiscellanous)
contains numerous pictures and animations.

A 3-30 duoprism, realized with the method given
[here](https://laustep.github.io/stlahblog/posts/Duoprism.html).

![](https://github.com/stla/PyVistaMiscellanous/raw/main/Duoprism_3-30.gif)

Some [Hopf
tori](https://laustep.github.io/stlahblog/posts/HopfTorus2.html) in
orbit, forming like a [Steiner
chain](https://laustep.github.io/stlahblog/posts/SteinerChains.html).

![](https://github.com/stla/PyVistaMiscellanous/raw/main/HopfToriSteinerOrbit.gif)

Some connected [linked
cyclides](https://laustep.github.io/stlahblog/posts/linkedCyclidesParametric.html),
looking like a flower.

![](https://github.com/stla/PyVistaMiscellanous/raw/main/flower_cyclides.gif)

The [orbit of the modular
tessellation](https://laustep.github.io/stlahblog/posts/ModularTessellationOrbit.html),
with spheres instead of circles.

![](https://github.com/stla/PyVistaMiscellanous/raw/main/ModularTessellation.gif)

A bouquet of roses. It's surprising that one can obtain such a realistic
rose with parametric equations.
[Here](https://laustep.github.io/stlahblog/frames/threejs_RosesBouquet.html)
is an interactive **three.js** version.

![](https://github.com/stla/PyVistaMiscellanous/raw/main/TwentyRoses.gif)

The metamorphosis of a torus to a solid Möbius strip, with an electric
texture.

![](https://github.com/stla/PyVistaMiscellanous/raw/main/SolidMobiusStripElectric.gif)

A metamorphosis of three tori to a kind of cage. Credit to *ICN5D*, a
member of the [Hi.gher Space forum](http://hi.gher.space/forum/).

![](https://github.com/stla/PyVistaMiscellanous/raw/main/ICN5D_cage.gif)

------------------------------------------------------------------------

The [PyApollony](https://github.com/stla/PyApollony) repository contains
three Apollonian fractals.

![](https://github.com/stla/PyApollony/raw/main/examples/ApollonianFractal1.gif)

------------------------------------------------------------------------

The [PyCyclides](https://github.com/stla/PyCyclides) repository hosts a
package to draw some linked cyclides. It contains a **PyVista**
application to play with them:

![](https://github.com/stla/PyCyclides/raw/main/examples/example5.gif)

------------------------------------------------------------------------

[PyPlaneGeometry](https://github.com/stla/PyPlaneGeometry) is a Python
version of my R package
[PlaneGeometry](https://cran.r-project.org/web//packages/PlaneGeometry/vignettes/examples.html).
I call this animation the *Malfatti-Apollonian gasket*:

![](https://github.com/stla/PyPlaneGeometry/raw/main/planegeometry/examples/MalfattiApollonian.gif)

And here is an elliptical nested Steiner chain:

![](https://github.com/stla/PyPlaneGeometry/raw/main/planegeometry/examples/EllipticalNestedSteinerChains3D_3.gif)

------------------------------------------------------------------------

[PySteiner](https://github.com/stla/PySteiner) is a package to draw
nested Steiner chains. Here is one, with its enveloping cyclides:

![](https://github.com/stla/PySteiner/raw/main/examples/Steiner_3-3-5.gif)

------------------------------------------------------------------------

[PyTorusThreePoints](https://github.com/stla/PyTorusThreePoints) is a
package allowing to draw a torus whose equator passes through three
points. Actually you don't need that with **PyVista**: it is easy to get
a circle passing through three points, and with **PyVista** you can
easily make it tubular.

![](https://github.com/stla/PyTorusThreePoints/raw/main/examples/VillarceauCircles.gif)

------------------------------------------------------------------------

[PyHyperbolic3D](https://github.com/stla/PyHyperbolic3D) is a package
allowing to draw hyperbolic triangles and tubular hyperbolic segments,
with the help of Ungar's theory presented in [this
post](https://laustep.github.io/stlahblog/posts/hyperbolicPolyhedra.html).

![](https://github.com/stla/PyHyperbolic3D/raw/main/examples/icosahedron_colored.gif)

There's also
[PyMobiusHyperbolic](https://github.com/stla/PyMobiusHyperbolic) which
provides functions to draw hyperbolic stuff, also based on Ungar's
theory, but it deals with the Poincaré model, whereas **PyHyperbolic3D**
deals with the hyperboloid model. In fact these two packages are not
restricted to 3D graphics, 2D pictures are possible too, but do not
involve **PyVista**:

![](https://github.com/stla/PyMobiusHyperbolic/raw/main/examples/tesselation_3-7.png)

**PyPlaneGeometry** (see above) has been used to draw this hyperbolic
tessellation.

Gists
=====

I also use some gists to store my animations. Here are [twenty Hopf
tori](https://gist.github.com/stla/7fc562f3eb1704491aff69132b7221dd):

![](https://gist.github.com/stla/7fc562f3eb1704491aff69132b7221dd/raw/a99b90810b40ff31767f0e7bdf2538e015aabad8/TwentyHopfTori.gif)

In [this
gist](https://gist.github.com/stla/189dbed406a023189e85a328603707c8) you
can find a rotating Hopf torus with an electric texture:

![](https://gist.github.com/stla/189dbed406a023189e85a328603707c8/raw/83a4d391e369ea6488e7a1b60e65a2c88d0a9de4/HopfTorusElectricOrbital.gif)

A [compound of five hyperbolic
tetrahedra](https://gist.github.com/stla/7a3178906d512b7ff4e4318e41828dd8),
made with the help of [Ungar's
theory](https://laustep.github.io/stlahblog/posts/hyperbolicPolyhedra.html):

![](https://gist.github.com/stla/7a3178906d512b7ff4e4318e41828dd8/raw/47a709984a822260f4afa0d09514fadf065d48bb/CompoundFiveHyperbolicTetrahedra.gif)

[Here](https://gist.github.com/stla/b23b18c9b936fa90c9147a27f1266c1d)
there is an animation of some [slices of the
tiger](https://laustep.github.io/stlahblog/posts/slicedHypersurface.html):

![](https://gist.github.com/stla/b23b18c9b936fa90c9147a27f1266c1d/raw/2aae46cfa5bf30f1fd79b83e10012dbba39dbaf1/slicedTiger.gif)

In [this
gist](https://gist.github.com/stla/f7f50025abbf6910f587fe176cc3fe00)
there is a pretty [stereographic
duoprism](https://laustep.github.io/stlahblog/posts/DuoprismStereo.html):

![](https://gist.github.com/stla/f7f50025abbf6910f587fe176cc3fe00/raw/102dd245b1e83ce877f0848e36c5a16f5b679d1e/StereoDuoprism_3-30.gif)

[This
gist](https://gist.github.com/stla/83925fce019921ec12440ad05fdcd213)
shows an animation made from the runcinated tesseract, a 4D polytope. It
is stereographically projected in 3D but I kept only the tetrahedrals
cells, and it is in rotation in the 4D space.

![](https://gist.github.com/stla/83925fce019921ec12440ad05fdcd213/raw/839458ffc08d4d07ff6c4775c405fa3683866738/RTT.gif)

I hope you enjoyed the presentation.
