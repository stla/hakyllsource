---
author: Stéphane Laurent
date: '2018-06-26'
highlighter: 'pandoc-solarized'
linenums: True
output:
  html_document:
    highlight: kate
    keep_md: False
  md_document:
    preserve_yaml: True
    variant: markdown
prettify: True
prettifycss: minimal
tags: 'javascript, graphics, geometry'
title: 'Drawing a torus with three.js'
---

In previous posts, I have shown how to draw a torus whose equator passes
by three given points with Haskell, R and POV-Ray. In [this
gist](https://gist.github.com/stla/f461877b9426df53d2db2d18db93a2e6) I
provide the code for Asymptote. Here I'm going to provide the code for
`three.js`.

Firstly, below is the Javascript function which returns the
transformation matrix and the radius of the torus. The function takes as
inputs the three points, each given as a `Vector3`, and returns an
object containing the matrix as a `Matrix4` and a number, the radius.

``` {.javascript}
function TorusTransfo(p1, p2, p3) {
  var p12 = new THREE.Vector3();
  p12.addVectors(p1, p2).divideScalar(2);
  var p23 = new THREE.Vector3();
  p23.addVectors(p2, p3).divideScalar(2);
  var xcoef = (p1.y - p2.y) * (p2.z - p3.z) - (p1.z - p2.z) * (p2.y - p3.y);
  var ycoef = (p1.z - p2.z) * (p2.x - p3.x) - (p1.x - p2.x) * (p2.z - p3.z);
  var zcoef = (p1.x - p2.x) * (p2.y - p3.y) - (p1.y - p2.y) * (p2.x - p3.x);
  var offset1 = p1.x * xcoef + p1.y * ycoef + p1.z * zcoef;
  var v12 = p2.clone(); v12.sub(p1);
  var v23 = p3.clone(); v23.sub(p2);
  var offset21 = p12.dot(v12); var offset22 = p23.dot(v23);
  var M = new THREE.Matrix3();
  M.set(xcoef, v12.x, v23.x, ycoef, v12.y, v23.y, zcoef, v12.z, v23.z);
  invM = new THREE.Matrix3();
  invM.getInverse(M);
  // center = invM * (offset1, offset21, offset22)
  var A = invM.toArray();
  var center = new THREE.Vector3(
    A[0] * offset1 + A[1] * offset21 + A[2] * offset22,
    A[3] * offset1 + A[4] * offset21 + A[5] * offset22,
    A[6] * offset1 + A[7] * offset21 + A[8] * offset22
  );
  var v = p1.clone(); v.sub(center);
  var radius = v.length();
  var T = new THREE.Matrix4();
  if (xcoef == 0 && ycoef == 0) {
    T.identity();
    T.setPosition(center);
    return { matrix: T, radius: radius };
  }
  var n = new THREE.Vector3(xcoef, ycoef, zcoef);
  n.normalize();
  var s = Math.sqrt(n.x * n.x + n.y * n.y);
  var a = n.x / s; var b = n.y / s;
  var u = new THREE.Vector3(b, -a, 0);
  var v = new THREE.Vector3(); v.crossVectors(n, u);
  T.set(
    u.x, v.x, n.x, center.x,
    u.y, v.y, n.y, center.y,
    u.z, v.z, n.z, center.z,
    0, 0, 0, 1
  );
  return { matrix: T, radius: radius };
}
```

The `addTorus` function below conveniently adds the torus to a
`three.js` object. The last argument `r` is the desired minor radius of
the torus.

``` {.javascript}
function addTorus(object, p1, p2, p3, r) {
  var TR = TorusTransfo(p1, p2, p3);
  var geom = new THREE.TorusGeometry(TR.radius, r, 32, 100);
  var mesh = new THREE.Mesh(geom, new THREE.MeshNormalMaterial());
  mesh.matrix = TR.matrix;
  mesh.matrixAutoUpdate = false;
  object.add(mesh);
}
```

Then we apply the `addTorus` function as follows. First, define three
points and the desired minor radius:

``` {.javascript}
var A = new THREE.Vector3(0, 0, 0);
var B = new THREE.Vector3(0, 1, 0);
var C = new THREE.Vector3(1, 0, 1);
var r = 0.3;
```

Then add the torus to an object in this way:

``` {.javascript}
var scene = new THREE.Scene();
var object = new THREE.Object3D();
addTorus(object, A, B, C, r);
scene.add(object);
```

As an illustration, below are the [linked
cyclides](https://laustep.github.io/stlahblog/posts/linkedCyclides.html)
plotted with `three.js`. Click on the object and drag the mouse to play
with it. You can get the full code by looking at the source, or by going
to [this
gist](https://gist.github.com/stla/9a9cf6d986ac60d53167912f3eb0074b).

<iframe src="../frames/threejs_linkedCyclides.html" width="100%" height="500px" scrolling="no" frameborder="0">
</iframe>
