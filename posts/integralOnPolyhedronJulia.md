---
title: "Integration over a polyhedron with Julia"
author: "Stéphane Laurent"
date: '2022-12-03'
tags: julia
output:
  md_document:
    variant: markdown
    preserve_yaml: true
  html_document:
    highlight: kate
    keep_md: no
highlighter: pandoc-solarized
---

The Julia function `integrateOnSimplex` provided in [this
gist](https://gist.github.com/stla/57ef3a2dcd869d4b6809fb80f1a4300b)
allows to compute the integral of a function over a simplex or more
generally a union of simplices (a simplex is a triangle in dimension 2,
a tetrahedron in dimension 3). I will package it soon, under the name
**SimplicialCubature**.

The Delaunay tessellation of a convex polyhedron in $\mathbb{R}^n$
provides a partition of this convex polyhedron into $n$-dimensional
simplices. Therefore, once you have a way to integrate a function over a
simplex, you are able to integrate over a convex polyhedron.

Suppose for example you have to evaluate the integral $$
\int_{-5}^4\int_{-5}^{3-x}\int_{-10}^{6-x-y} f(x,y,z)
\,\mathrm{d}z\,\mathrm{d}y\,\mathrm{d}x
$$ for a certain function $f$.

The domain of integration is defined by the set of inequalities: $$
\left\{\begin{matrix}
-5 & \leq & x & \leq & 4 \\
-5 & \leq & y & \leq & 3-x \\
-10 & \leq & z & \leq & 6-x-y
\end{matrix}
\right.
$$ which is equivalent to $$
\left\{\begin{matrix}
-x & \leq & 5 \\
x & \leq & 4 \\
-y & \leq & 5 \\
x+y & \leq & 3 \\
-z & \leq & 10 \\
x+y+z & \leq & 6
\end{matrix}
\right..
$$ This set of inequalities defines a convex polyhedron. We can get the
vertices of this polyhedron with the `Polyhedra` package:

``` julia
# define the polyhedron Ax <= b and get its vertices
using Polyhedra
A = [
  -1  0  0;   # -x
   1  0  0;   # x
   0 -1  0;   # -y
   1  1  0;   # x + y
   0  0 -1;   # -z
   1  1  1.0  # x + y + z
]
b = [5; 4; 5; 3; 10; 6.0]
H = hrep(A, b)
PH = polyhedron(H)
vertices = collect(points(PH))
## 8-element Vector{Vector{Float64}}
##  [4.0, -1.0, 3.0]
##  [-5.0, 8.0, 3.0]
##  [4.0, -1.0, -10.0]
##  [-5.0, 8.0, -10.0]
##  [4.0, -5.0, 7.0]
##  [-5.0, -5.0, 16.0]
##  [4.0, -5.0, -10.0]
##  [-5.0, -5.0, -10.0]
```

Then, to evaluate the integral, we proceed as follows:

-   split the polyhedron into simplices (tetrahedra) with the Delaunay
    algorithm, implemented in the `MiniQhull` package;

-   evaluate the integral over the union of these simplices with the
    `integrateOnSimplex` function.

Let's go. We split the polyhedron into tetrahedra:

``` julia
# decompose the polyhedron into simplices (tetrahedra)
using MiniQhull # to use delaunay()
indices = delaunay(hcat(vertices...))
_, ntetrahedra = size(indices)
tetrahedra = Vector{Vector{Vector{Float64}}}(undef, ntetrahedra)
for j in 1:ntetrahedra
  ids = vec(indices[:, j])
  tetrahedra[j] = vertices[ids]
end
```

Now we are ready to use the `integrateOnSimplex` function. We take as
example the function $f(x, y, z) = x + yz$.

``` julia
# function to be integrated
function f(x)
  return x[1] + x[2]*x[3]
end
# integral
I = integrateOnSimplex(f, tetrahedra)
I.integral
## -5358.300000000004
```

Note that for this example we can do better. The function $f$ is
polynomial. So we can get the exact value of its integral over a
simplex; see [the previous
post](https://laustep.github.io/stlahblog/posts/integratePolynomialOnSimplex.html).