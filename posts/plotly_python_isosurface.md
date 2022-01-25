---
author: Stéphane Laurent
date: '2022-01-25'
highlighter: 'pandoc-solarized'
output:
  html_document:
    highlight: kate
    keep_md: no
  md_document:
    preserve_yaml: yes
    variant: markdown
  pdf_document: default
rbloggers: yes
tags: 'geometry, plotly, graphics, python, pyvista'
title: Draw an isosurface with Python Plotly with the help of Pyvista
---

**Plotly** isosurfaces are relatively new. I have not tried yet in
Python. I tried in R and I found them a bit slow. [In this
post](https://laustep.github.io/stlahblog/posts/plotly_trisurf.html) I
showed how to plot an isosurface in R **Plotly** with the help of the
**misc3d** package: by constructing a triangular 3D mesh and using the
`mesh3d` type in **Plotly**. Here I will show how to do something
similar in Python, with the help of the **PyVista** package. I don't
know whether this is faster than the built-in way to draw an isosurface
in **Plotly**, but there's at least one advantage: the one I mentioned
[here](https://laustep.github.io/stlahblog/posts/MeshClipping.html),
that is, the possibility to clip the isosurface to a region (usually a
ball). I don't think this is possible with the **Plotly** way (I may be
wrong).

Let's go. I gonna draw the Togliatti surface again. First, the mesh
clipped to a box:

``` {.python}
from math import sqrt
import numpy as np
import pyvista as pv
import plotly.graph_objects as go
import plotly.io as pio # to save the graphics as html

def f(x, y, z):
    return (
        64
        * (x - 1)
        * (
            x**4
            - 4 * x**3
            - 10 * x**2 * y**2
            - 4 * x**2
            + 16 * x
            - 20 * x * y**2
            + 5 * y**4
            + 16
            - 20 * y**2
        )
        - 5
        * sqrt(5 - sqrt(5))
        * (2 * z - sqrt(5 - sqrt(5)))
        * (4 * (x**2 + y**2 - z**2) + (1 + 3 * sqrt(5)))**2
    )
# generate data grid for computing the values
X, Y, Z = np.mgrid[(-5):5:250j, (-5):5:250j, (-4):4:250j]
# create a structured grid
grid = pv.StructuredGrid(X, Y, Z)
# compute and assign the values
values = f(X, Y, Z)
grid.point_data["values"] = values.ravel(order = "F")
# compute the isosurface f(x, y, z) = 0
isosurf = grid.contour(isosurfaces = [0])
mesh0 = isosurf.extract_geometry()
```

Now we clip the Togliatti surface to a ball. The mesh we obtain is named
`mesh`. It is triangular: `mesh.is_all_triangles` returns `True`. If it
were not, we would need to run `mesh.triangulate`. Finally we extract
the triangular faces from this mesh. The easiest way is to reshape the
vector `mesh.faces` to a matrix.

``` {.python}
# surface clipped to the ball of radius 4.8, with the help of `clip_scalar`:
mesh0["dist"] = np.linalg.norm(mesh0.points, axis = 1)
mesh = mesh0.clip_scalar("dist", value = 4.8)
mesh.is_all_triangles # True
# mesh.triangulate()
points = mesh.points
triangles = mesh.faces.reshape(-1, 4)
```

Now it's a child game to plot the isosurface with **Plotly**:

``` {.python}
fig = go.Figure(data=[
    go.Mesh3d(
        x=points[:, 0],
        y=points[:, 1],
        z=points[:, 2],
        colorscale = [[0, 'gold'],
                     [0.5, 'mediumturquoise'],
                     [1, 'magenta']],
        # Intensity of each vertex, which will be interpolated and color-coded
        intensity = np.linspace(0, 1, len(mesh.points)),
        # i, j and k give the vertices of the triangles
        i = triangles[:, 1],
        j = triangles[:, 2],
        k = triangles[:, 3],
        showscale = False
    )
])

fig.show()
```

<iframe src="../frames/Togliatti_plotly_python.html" width="100%" height="512px" scrolling="no" frameborder="0">
</iframe>
