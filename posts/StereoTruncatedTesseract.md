---
author: Stéphane Laurent
date: '2019-12-16'
highlighter: 'pandoc-solarized'
linenums: True
output:
  html_document:
    highlight: kate
    keep_md: False
    toc: True
  md_document:
    preserve_yaml: True
    toc: True
    variant: markdown
prettify: True
prettifycss: minimal
tags: 'R, asymptote, povray, rgl, graphics, geometry'
title: Stereographic truncated tesseract
---

-   [The stereographic truncated
    tesseract](#the-stereographic-truncated-tesseract)
-   [Drawing with rgl (R)](#drawing-with-rgl-r)
-   [Drawing with Asymptote](#drawing-with-asymptote)
-   [Drawing with POV-Ray](#drawing-with-pov-ray)

The stereographic truncated tesseract
=====================================

We show how to draw a stereographic truncated tesseract with rgl (R),
Asymptote, and POV-Ray.

The truncated tesseract is a uniform polychoron. Among its cells, there
are sixteen tetrahedra, and we fill the faces of these tetrahedra.

Using Asymptote and POV-Ray, we include a 4D rotation to animate the
figure.

We call it *stereographic* because we map each edge to the 3-sphere
before applying the stereographic projection.

Drawing with rgl (R)
====================

``` {.r}
library(rgl)
library(cxhull)
library(abind)

# vertices #####################################################################
sqr2p1 <- sqrt(2) + 1
vertices <- rbind(
  c(-1, -sqr2p1, -sqr2p1, -sqr2p1),
  c(-1, -sqr2p1, -sqr2p1, sqr2p1),
  c(-1, -sqr2p1, sqr2p1, -sqr2p1),
  c(-1, -sqr2p1, sqr2p1, sqr2p1),
  c(-1, sqr2p1, -sqr2p1, -sqr2p1),
  c(-1, sqr2p1, -sqr2p1, sqr2p1),
  c(-1, sqr2p1, sqr2p1, -sqr2p1),
  c(-1, sqr2p1, sqr2p1, sqr2p1),
  c(1, -sqr2p1, -sqr2p1, -sqr2p1),
  c(1, -sqr2p1, -sqr2p1, sqr2p1),
  c(1, -sqr2p1, sqr2p1, -sqr2p1),
  c(1, -sqr2p1, sqr2p1, sqr2p1),
  c(1, sqr2p1, -sqr2p1, -sqr2p1),
  c(1, sqr2p1, -sqr2p1, sqr2p1),
  c(1, sqr2p1, sqr2p1, -sqr2p1),
  c(1, sqr2p1, sqr2p1, sqr2p1),
  c(-sqr2p1, -1, -sqr2p1, -sqr2p1),
  c(-sqr2p1, -1, -sqr2p1, sqr2p1),
  c(-sqr2p1, -1, sqr2p1, -sqr2p1),
  c(-sqr2p1, -1, sqr2p1, sqr2p1),
  c(-sqr2p1, 1, -sqr2p1, -sqr2p1),
  c(-sqr2p1, 1, -sqr2p1, sqr2p1),
  c(-sqr2p1, 1, sqr2p1, -sqr2p1),
  c(-sqr2p1, 1, sqr2p1, sqr2p1),
  c(sqr2p1, -1, -sqr2p1, -sqr2p1),
  c(sqr2p1, -1, -sqr2p1, sqr2p1),
  c(sqr2p1, -1, sqr2p1, -sqr2p1),
  c(sqr2p1, -1, sqr2p1, sqr2p1),
  c(sqr2p1, 1, -sqr2p1, -sqr2p1),
  c(sqr2p1, 1, -sqr2p1, sqr2p1),
  c(sqr2p1, 1, sqr2p1, -sqr2p1),
  c(sqr2p1, 1, sqr2p1, sqr2p1),
  c(-sqr2p1, -sqr2p1, -1, -sqr2p1),
  c(-sqr2p1, -sqr2p1, -1, sqr2p1),
  c(-sqr2p1, -sqr2p1, 1, -sqr2p1),
  c(-sqr2p1, -sqr2p1, 1, sqr2p1),
  c(-sqr2p1, sqr2p1, -1, -sqr2p1),
  c(-sqr2p1, sqr2p1, -1, sqr2p1),
  c(-sqr2p1, sqr2p1, 1, -sqr2p1),
  c(-sqr2p1, sqr2p1, 1, sqr2p1),
  c(sqr2p1, -sqr2p1, -1, -sqr2p1),
  c(sqr2p1, -sqr2p1, -1, sqr2p1),
  c(sqr2p1, -sqr2p1, 1, -sqr2p1),
  c(sqr2p1, -sqr2p1, 1, sqr2p1),
  c(sqr2p1, sqr2p1, -1, -sqr2p1),
  c(sqr2p1, sqr2p1, -1, sqr2p1),
  c(sqr2p1, sqr2p1, 1, -sqr2p1),
  c(sqr2p1, sqr2p1, 1, sqr2p1),
  c(-sqr2p1, -sqr2p1, -sqr2p1, -1),
  c(-sqr2p1, -sqr2p1, -sqr2p1, 1),
  c(-sqr2p1, -sqr2p1, sqr2p1, -1),
  c(-sqr2p1, -sqr2p1, sqr2p1, 1),
  c(-sqr2p1, sqr2p1, -sqr2p1, -1),
  c(-sqr2p1, sqr2p1, -sqr2p1, 1),
  c(-sqr2p1, sqr2p1, sqr2p1, -1),
  c(-sqr2p1, sqr2p1, sqr2p1, 1),
  c(sqr2p1, -sqr2p1, -sqr2p1, -1),
  c(sqr2p1, -sqr2p1, -sqr2p1, 1),
  c(sqr2p1, -sqr2p1, sqr2p1, -1),
  c(sqr2p1, -sqr2p1, sqr2p1, 1),
  c(sqr2p1, sqr2p1, -sqr2p1, -1),
  c(sqr2p1, sqr2p1, -sqr2p1, 1),
  c(sqr2p1, sqr2p1, sqr2p1, -1),
  c(sqr2p1, sqr2p1, sqr2p1, 1)
)

# convex hull is the polytope itself, since it is convex #######################
hull <- cxhull(vertices)

# edges ########################################################################
edges <- hull$edges

# (triangular) faces of the tetrahedra ######################################### 
ridgeSizes <- sapply(hull$ridges, function(ridge) length(ridge$vertices))
triangles <- t(sapply(hull$ridges[which(ridgeSizes==3)], 
                      function(ridge) ridge$vertices))

# stereographic projection #####################################################
sproj <- function(p, r){
  c(p[1], p[2], p[3])/(r-p[4])
}

# spherical segment ############################################################
sphericalSegment <- function(P, Q, r, n){
  out <- matrix(NA_real_, nrow = n+1, ncol = 4)
  for(i in 0:n){
    pt <- P + (i/n)*(Q-P)
    out[i+1L, ] <- r/sqrt(c(crossprod(pt))) * pt
  }
  out
}

# stereographic edge ###########################################################
stereoEdge <- function(verts, edge, r, n){
  P <- verts[edge[1], ]
  Q <- verts[edge[2], ]
  PQ <- sphericalSegment(P, Q, r, n)
  pq <- t(apply(PQ, 1, function(M){sproj(M, r)}))
  dists <- sqrt(apply(pq, 1, crossprod))
  cylinder3d(pq, radius = log1p(dists/4)/4, sides = 60)
}

# stereographic subdivision (to fill the triangles) ############################
midpoint4 <- function(A, B, r){
  M <- (A + B) / 2
  lg <- sqrt(c(crossprod(M))) / r
  M / lg
} 

subdiv0 <- function(A, B, C, r){
  mAB <- midpoint4(A, B, r)
  mAC <- midpoint4(A, C, r)
  mBC <- midpoint4(B, C, r)
  out <- array(NA_real_, dim = c(4L, 3L, 4L))
  out[1,,] <- rbind(A, mAB, mAC)
  out[2,,] <- rbind(B, mBC, mAB)
  out[3,,] <- rbind(C, mAC, mBC)
  out[4,,] <- rbind(mAB, mBC, mAC)
  out
}

subdiv <- function(n, A, B, C, r){
  if(n == 1){
    return(subdiv0(A, B, C, r))
  }
  triangles <- subdiv(n-1, A, B, C, r)
  out <- array(NA_real_, dim = c(0L, 3L, 4L))
  for(i in 1:(4^(n-1))){
    trgl <- triangles[i,,]
    out <- abind(out, subdiv0(trgl[1L,], trgl[2L,], trgl[3L,], r), along = 1L)
  }
  out
}

# mesh maker ###################################################################
stereoTriangle <- function(n, A, B, C, r){
  triangles <- subdiv(n, A, B, C, r)
  ntriangles <- dim(triangles)[1L]
  indices <- matrix(1L:(3L*ntriangles), nrow = 3L, ncol = ntriangles)
  vertices <- matrix(NA_real_, nrow = 3L, ncol = 3L*ntriangles)
  for(i in 1L:ntriangles){
    trgl <- triangles[i,,]
    vertices[, 3L*(i-1L)+1L] <- sproj(trgl[1L,], r)
    vertices[, 3L*(i-1L)+2L] <- sproj(trgl[2L,], r)
    vertices[, 3L*(i-1L)+3L] <- sproj(trgl[3L,], r)
  }
  mesh <- tmesh3d(vertices, indices, homogeneous = FALSE)
  Rvcg::vcgClean(mesh, sel = c(0,7), silent = TRUE)
}

# projected vertices ###########################################################
r <- sqrt(1+3*sqr2p1^2)
vs <- t(apply(vertices, 1L, function(M){sproj(M, r)}))

####~~~~ plot ~~~~##############################################################
open3d(windowRect = c(50, 50, 562, 562), zoom = 0.9)
bg3d(rgb(54, 57, 64, maxColorValue = 255))
## plot the edges
for(k in 1L:nrow(edges)){
  edge <- stereoEdge(vertices, edges[k,], r, n = 100)
  shade3d(edge, color = "gold")
}
## plot the vertices
for(i in 1L:nrow(vs)){
  v <- vs[i,]
  spheres3d(v, radius = log1p(sqrt(c(crossprod(v)))/4)/3, color = "gold2")
}
## plot the filled triangles
for(i in 1L:nrow(triangles)){
  trgl <- triangles[i,]
  A <- vertices[trgl[1L], ]
  B <- vertices[trgl[2L], ]
  C <- vertices[trgl[3L], ]
  mesh <- stereoTriangle(6, A, B, C, r)
  shade3d(mesh, color = "red")
}
```

![](figures/truncatedTesseract_stereographic_rgl.gif)

Drawing with Asymptote
======================

``` {.cpp}
settings.render = 4;
settings.outformat = "eps";
import tube;
size(200,0);

currentprojection = orthographic(1, 2, 4);
currentlight = light(gray(0.85), ambient=black, specularfactor=3,
                     (100,100,100), specular=gray(0.9), viewport=false);
currentlight.background = rgb("363940ff");

// files to be saved -----------------------------------------------------------
string[] files = {
    "TT000", "TT001", "TT002", "TT003", "TT004", "TT005",
    "TT006", "TT007", "TT008", "TT009", "TT010", "TT011",
    "TT012", "TT013", "TT014", "TT015", "TT016", "TT017",
    "TT018", "TT019", "TT020", "TT021", "TT022", "TT023",
    "TT024", "TT025", "TT026", "TT027", "TT028", "TT029",
    "TT030", "TT031", "TT032", "TT033", "TT034", "TT035",
    "TT036", "TT037", "TT038", "TT039", "TT040", "TT041",
    "TT042", "TT043", "TT044", "TT045", "TT046", "TT047",
    "TT048", "TT049", "TT050", "TT051", "TT052", "TT053",
    "TT054", "TT055", "TT056", "TT057", "TT058", "TT059",
    "TT060", "TT061", "TT062", "TT063", "TT064", "TT065",
    "TT066", "TT067", "TT068", "TT069", "TT070", "TT071",
    "TT072", "TT073", "TT074", "TT075", "TT076", "TT077",
    "TT078", "TT079", "TT080", "TT081", "TT082", "TT083",
    "TT084", "TT085", "TT086", "TT087", "TT088", "TT089",
    "TT090", "TT091", "TT092", "TT093", "TT094", "TT095",
    "TT096", "TT097", "TT098", "TT099", "TT100", "TT101",
    "TT102", "TT103", "TT104", "TT105", "TT106", "TT107",
    "TT108", "TT109", "TT110", "TT111", "TT112", "TT113",
    "TT114", "TT115", "TT116", "TT117", "TT118", "TT119",
    "TT120", "TT121", "TT122", "TT123", "TT124", "TT125",
    "TT126", "TT127", "TT128", "TT129", "TT130", "TT131",
    "TT132", "TT133", "TT134", "TT135", "TT136", "TT137",
    "TT138", "TT139", "TT140", "TT141", "TT142", "TT143",
    "TT144", "TT145", "TT146", "TT147", "TT148", "TT149",
    "TT150", "TT151", "TT152", "TT153", "TT154", "TT155",
    "TT156", "TT157", "TT158", "TT159", "TT160", "TT161",
    "TT162", "TT163", "TT164", "TT165", "TT166", "TT167",
    "TT168", "TT169", "TT170", "TT171", "TT172", "TT173",
    "TT174", "TT175", "TT176", "TT177", "TT178", "TT179"};

// vertices --------------------------------------------------------------------
struct quadruple {
    real x;
    real y;
    real z;
    real t;
}

quadruple array2quadruple(real[] v){
    quadruple q;
    q.x = v[0]; q.y = v[1]; q.z = v[2]; q.t = v[3];
    return q;
}

real x = 1 + sqrt(2);
real r = sqrt(1 + 3 * x * x);
real[][] vertices0 = {
    {-1.0, -x, -x, -x},
    {-1.0, -x, -x, x},
    {-1.0, -x, x, -x},
    {-1.0, -x, x, x},
    {-1.0, x, -x, -x},
    {-1.0, x, -x, x},
    {-1.0, x, x, -x},
    {-1.0, x, x, x},
    {1.0, -x, -x, -x},
    {1.0, -x, -x, x},
    {1.0, -x, x, -x},
    {1.0, -x, x, x},
    {1.0, x, -x, -x},
    {1.0, x, -x, x},
    {1.0, x, x, -x},
    {1.0, x, x, x},
    {-x, -1.0, -x, -x},
    {-x, -1.0, -x, x},
    {-x, -1.0, x, -x},
    {-x, -1.0, x, x},
    {-x, 1.0, -x, -x},
    {-x, 1.0, -x, x},
    {-x, 1.0, x, -x},
    {-x, 1.0, x, x},
    {x, -1.0, -x, -x},
    {x, -1.0, -x, x},
    {x, -1.0, x, -x},
    {x, -1.0, x, x},
    {x, 1.0, -x, -x},
    {x, 1.0, -x, x},
    {x, 1.0, x, -x},
    {x, 1.0, x, x},
    {-x, -x, -1.0, -x},
    {-x, -x, -1.0, x},
    {-x, -x, 1.0, -x},
    {-x, -x, 1.0, x},
    {-x, x, -1.0, -x},
    {-x, x, -1.0, x},
    {-x, x, 1.0, -x},
    {-x, x, 1.0, x},
    {x, -x, -1.0, -x},
    {x, -x, -1.0, x},
    {x, -x, 1.0, -x},
    {x, -x, 1.0, x},
    {x, x, -1.0, -x},
    {x, x, -1.0, x},
    {x, x, 1.0, -x},
    {x, x, 1.0, x},
    {-x, -x, -x, -1.0},
    {-x, -x, -x, 1.0},
    {-x, -x, x, -1.0},
    {-x, -x, x, 1.0},
    {-x, x, -x, -1.0},
    {-x, x, -x, 1.0},
    {-x, x, x, -1.0},
    {-x, x, x, 1.0},
    {x, -x, -x, -1.0},
    {x, -x, -x, 1.0},
    {x, -x, x, -1.0},
    {x, -x, x, 1.0},
    {x, x, -x, -1.0},
    {x, x, -x, 1.0},
    {x, x, x, -1.0},
    {x, x, x, 1.0} };
    
quadruple[] vertices = new quadruple[vertices0.length];
for(int i = 0; i < vertices0.length; ++i){
    vertices[i] = array2quadruple(vertices0[i]);
}

// edges -----------------------------------------------------------------------
int[][] edges = {
    {0, 8},
    {0, 16},
    {0, 32},
    {0, 48},
    {1, 9},
    {1, 17},
    {1, 33},
    {1, 49},
    {2, 10},
    {2, 18},
    {2, 34},
    {2, 50},
    {3, 11},
    {3, 19},
    {3, 35},
    {3, 51},
    {4, 12},
    {4, 20},
    {4, 36},
    {4, 52},
    {5, 13},
    {5, 21},
    {5, 37},
    {5, 53},
    {6, 14},
    {6, 22},
    {6, 38},
    {6, 54},
    {7, 15},
    {7, 23},
    {7, 39},
    {7, 55},
    {8, 24},
    {8, 40},
    {8, 56},
    {9, 25},
    {9, 41},
    {9, 57},
    {10, 26},
    {10, 42},
    {10, 58},
    {11, 27},
    {11, 43},
    {11, 59},
    {12, 28},
    {12, 44},
    {12, 60},
    {13, 29},
    {13, 45},
    {13, 61},
    {14, 30},
    {14, 46},
    {14, 62},
    {15, 31},
    {15, 47},
    {15, 63},
    {16, 20},
    {16, 32},
    {16, 48},
    {17, 21},
    {17, 33},
    {17, 49},
    {18, 22},
    {18, 34},
    {18, 50},
    {19, 23},
    {19, 35},
    {19, 51},
    {20, 36},
    {20, 52},
    {21, 37},
    {21, 53},
    {22, 38},
    {22, 54},
    {23, 39},
    {23, 55},
    {24, 28},
    {24, 40},
    {24, 56},
    {25, 29},
    {25, 41},
    {25, 57},
    {26, 30},
    {26, 42},
    {26, 58},
    {27, 31},
    {27, 43},
    {27, 59},
    {28, 44},
    {28, 60},
    {29, 45},
    {29, 61},
    {30, 46},
    {30, 62},
    {31, 47},
    {31, 63},
    {32, 34},
    {32, 48},
    {33, 35},
    {33, 49},
    {34, 50},
    {35, 51},
    {36, 38},
    {36, 52},
    {37, 39},
    {37, 53},
    {38, 54},
    {39, 55},
    {40, 42},
    {40, 56},
    {41, 43},
    {41, 57},
    {42, 58},
    {43, 59},
    {44, 46},
    {44, 60},
    {45, 47},
    {45, 61},
    {46, 62},
    {47, 63},
    {48, 49},
    {50, 51},
    {52, 53},
    {54, 55},
    {56, 57},
    {58, 59},
    {60, 61},
    {62, 63} };

// tetrahedra ------------------------------------------------------------------
int[][] tetrahedra = {
    {0, 16, 32, 48},
    {11, 27, 43, 59},
    {12, 28, 44, 60},
    {8, 24, 40, 56},
    {9, 25, 41, 57},
    {15, 31, 47, 63},
    {13, 29, 45, 61},
    {14, 30, 46, 62},
    {10, 26, 42, 58},
    {3, 19, 35, 51},
    {2, 18, 34, 50},
    {1, 17, 33, 49},
    {4, 20, 36, 52},
    {5, 21, 37, 53},
    {6, 22, 38, 54},
    {7, 23, 39, 55} };

// rotation in 4D space (right-isoclinic) --------------------------------------
quadruple rotate4d(real alpha, real beta, real xi, quadruple vec){
    real a = cos(xi);
    real b = sin(alpha)*cos(beta)*sin(xi);
    real c = sin(alpha)*sin(beta)*sin(xi);
    real d = cos(alpha)*sin(xi);
    real p = vec.x;
    real q = vec.y;
    real r = vec.z;
    real s = vec.t;
    quadruple out;
    out.x = a*p - b*q - c*r - d*s;
    out.y = a*q + b*p + c*s - d*r;
    out.z = a*r - b*s + c*p + d*q;
    out.t = a*s + b*r - c*q + d*p;
    return out;
}


// stereographic projection ----------------------------------------------------
triple stereog(quadruple A, real r){
    return (A.x, A.y, A.z) / (r - A.t);
}

// stereographic path ----------------------------------------------------------
path3 stereoPath(quadruple A, quadruple B, real r, int n){
    path3 out;
    for(int i = 0; i <= n; ++i){
        real t = i/n;
        quadruple M;
        real x = (1-t)*A.x + t*B.x;
        real y = (1-t)*A.y + t*B.y;
        real z = (1-t)*A.z + t*B.z;
        real t = (1-t)*A.t + t*B.t;
        real lg = sqrt(x*x + y*y + z*z + t*t) / r;
        M.x = x / lg; M.y = y / lg; M.z = z / lg; M.t = t / lg;
        out = out .. stereog(M, r);
    }
    return out;
}

// section transformation ------------------------------------------------------
transform T(path3 p3, real t, int n){
    triple M = relpoint(p3, t/(n/4));
    return scale(length(M)/15); 
}

// stereographic subdivision (to fill the tetrahedra) --------------------------
quadruple midpoint4(quadruple A, quadruple B, real r){
    quadruple M;
    real x = (A.x + B.x)/2;
    real y = (A.y + B.y)/2;
    real z = (A.z + B.z)/2;
    real t = (A.t + B.t)/2;
    real lg = sqrt(x*x + y*y + z*z + t*t) / r;
    M.x = x / lg; M.y = y / lg; M.z = z / lg; M.t = t / lg;
    return(M);
} 

quadruple[][] subdiv0(quadruple A, quadruple B, quadruple C, real r){
    quadruple m01 = midpoint4(A, B, r);
    quadruple m02 = midpoint4(A, C, r);
    quadruple m12 = midpoint4(B, C, r);
    return new quadruple[][] {
        {A, m01, m02}, 
        {B, m12, m01}, 
        {C, m02, m12}, 
        {m01, m12, m02}
    };
}

quadruple[][] subdiv(int n, quadruple A, quadruple B, quadruple C, real r){
  if(n == 1){
    return subdiv0(A, B, C, r);
  }
  quadruple[][] triangles = subdiv(n-1, A, B, C, r);
  quadruple[][] out = new quadruple[0][3];
  for(int i = 0; i < 4^(n-1); ++i){
    quadruple[] trgl = triangles[i];
    out.append(subdiv0(trgl[0], trgl[1], trgl[2], r));
  }
  return out;
}

// mesh maker ------------------------------------------------------------------
struct Mesh {
    triple[] vertices;
    int[][] indices;
}
Mesh stereoTriangle(int n, quadruple A, quadruple B, quadruple C, real r){
    quadruple[][] triangles = subdiv(n, A, B, C, r);
    triple[] vertices;
    int[][] indices;
    int faceIndex = 0;
    for(int i = 0; i < triangles.length; ++i){
        quadruple[] triangle = triangles[i];
        vertices.push(stereog(triangle[0], r));
        vertices.push(stereog(triangle[1], r));
        vertices.push(stereog(triangle[2], r));
        int[] x = {faceIndex, faceIndex+1, faceIndex+2};
        indices.push(x);
        faceIndex += 3;
    }
    Mesh out;
    out.vertices = vertices;
    out.indices = indices;
    return out;
}


// "bounding box" (to clip the animation) --------------------------------------
path3 boundingbox = scale(0.5,1,1)*circle(c=O, r=4, normal=Z);

// plot ------------------------------------------------------------------------
int n = 75;
int depth = 6;
real alpha = 0, beta = 0;

for(int f = 0; f < 180; ++f){
    // rotation angle
    real xi = 2*f*pi/180;
    // rotated vertices
    quadruple[] vs = new quadruple[vertices.length];
    for(int i = 0; i < vertices.length; ++i){
        vs[i] = rotate4d(alpha, beta, xi, vertices[i]);
    }
    // new picture
    picture pic;
    // draw boundingbox
    draw(pic, boundingbox, rgb("363940ff")+opacity(0));
    // draw edges
    for(int k = 0; k < edges.length; ++k){
        quadruple A = vs[edges[k][0]];
        quadruple B = vs[edges[k][1]];
        path3 p3 = stereoPath(A, B, r, n);
        transform S(real t){
            return T(p3, t, n);
        }
        draw(pic, tube(p3, unitcircle, S), rgb(139, 0, 139), 
                render(compression=Low, merge=true));
    }
    // draw vertices
    for(int i = 0; i < vertices.length; ++i){
        triple Asg = stereog(vs[i], r);
        draw(pic, shift(Asg)*scale3(length(Asg)/10)*unitsphere, purple);
    }
    // draw tetrahedra
    for(int i = 0; i < tetrahedra.length; ++i){
        int[] t = tetrahedra[i];
        Mesh mesh = stereoTriangle(depth, vs[t[0]], vs[t[1]], vs[t[2]], r);
        draw(pic, mesh.vertices, mesh.indices, m = red);
        Mesh mesh = stereoTriangle(depth, vs[t[0]], vs[t[1]], vs[t[3]], r);
        draw(pic, mesh.vertices, mesh.indices, m = red);
        Mesh mesh = stereoTriangle(depth, vs[t[0]], vs[t[2]], vs[t[3]], r);
        draw(pic, mesh.vertices, mesh.indices, m = red);
        Mesh mesh = stereoTriangle(depth, vs[t[1]], vs[t[2]], vs[t[3]], r);
        draw(pic, mesh.vertices, mesh.indices, m = red);
    }
    // add picture and save
    add(pic);
    shipout(files[f], bbox(rgb("363940ff"), FillDraw(rgb("363940ff"))));
    erase();
}   
```

![](figures/truncatedTesseract_stereographic_asy.gif)

Drawing with POV-Ray
====================

``` {.povray}
#version 3.7;
global_settings { assumed_gamma 1 }
#include "colors.inc"
#include "textures.inc"

/* camera */
camera {
    location <-11, 7,-32>
    look_at 0
    angle 45
}

// sun -------------------------------------------------------------------------
light_source {< 1000,3000,-6000> color rgb<1,1,1>*0.9}             // sun 
light_source {<-11, 7,-32>  color rgb<0.9,0.9,1>*0.1 shadowless}   // flash

// sky -------------------------------------------------------------------------
plane{<0,1,0>,1 hollow  
       texture{ pigment{ bozo turbulence 1.3
                         color_map { [0.00 rgb <0.24, 0.32, 1.0>*0.6]
                                     [0.75 rgb <0.24, 0.32, 1.0>*0.6]
                                     [0.83 rgb <1,1,1>]
                                     [0.95 rgb <0.25,0.25,0.25>]
                                     [1.0 rgb <0.5,0.5,0.5>]}
                        scale<1,1,1>*2.5  translate< 0,0,3>
                       }
                finish {ambient 1 diffuse 0} }      
       scale 10000}

// fog on the ground -----------------------------------------------------------
fog { fog_type   2
      distance   50
      color      Gray10  
      fog_offset 0.1
      fog_alt    1.5
      turbulence 1.8
    }

// ground ----------------------------------------------------------------------
plane { <0,1,0>, 0 
    texture {
        pigment { color rgb <0.95,0.9,0.73>*0.35 }
        normal { bumps 2 scale <0.25,0.25,0.25>*0.5 turbulence 0.5 } 
        finish { phong 0.1 }
    } 
} 


/* vertices */
#declare sqr2p1 = sqrt(2) + 1;
#declare v0 = < -1.0 , -sqr2p1 , -sqr2p1 , -sqr2p1 >;
#declare v1 = < -1.0 , -sqr2p1 , -sqr2p1 , sqr2p1 >;
#declare v2 = < -1.0 , -sqr2p1 , sqr2p1 , -sqr2p1 >;
#declare v3 = < -1.0 , -sqr2p1 , sqr2p1 , sqr2p1 >;
#declare v4 = < -1.0 , sqr2p1 , -sqr2p1 , -sqr2p1 >;
#declare v5 = < -1.0 , sqr2p1 , -sqr2p1 , sqr2p1 >;
#declare v6 = < -1.0 , sqr2p1 , sqr2p1 , -sqr2p1 >;
#declare v7 = < -1.0 , sqr2p1 , sqr2p1 , sqr2p1 >;
#declare v8 = < 1.0 , -sqr2p1 , -sqr2p1 , -sqr2p1 >;
#declare v9 = < 1.0 , -sqr2p1 , -sqr2p1 , sqr2p1 >;
#declare v10 = < 1.0 , -sqr2p1 , sqr2p1 , -sqr2p1 >;
#declare v11 = < 1.0 , -sqr2p1 , sqr2p1 , sqr2p1 >;
#declare v12 = < 1.0 , sqr2p1 , -sqr2p1 , -sqr2p1 >;
#declare v13 = < 1.0 , sqr2p1 , -sqr2p1 , sqr2p1 >;
#declare v14 = < 1.0 , sqr2p1 , sqr2p1 , -sqr2p1 >;
#declare v15 = < 1.0 , sqr2p1 , sqr2p1 , sqr2p1 >;
#declare v16 = < -sqr2p1 , -1.0 , -sqr2p1 , -sqr2p1 >;
#declare v17 = < -sqr2p1 , -1.0 , -sqr2p1 , sqr2p1 >;
#declare v18 = < -sqr2p1 , -1.0 , sqr2p1 , -sqr2p1 >;
#declare v19 = < -sqr2p1 , -1.0 , sqr2p1 , sqr2p1 >;
#declare v20 = < -sqr2p1 , 1.0 , -sqr2p1 , -sqr2p1 >;
#declare v21 = < -sqr2p1 , 1.0 , -sqr2p1 , sqr2p1 >;
#declare v22 = < -sqr2p1 , 1.0 , sqr2p1 , -sqr2p1 >;
#declare v23 = < -sqr2p1 , 1.0 , sqr2p1 , sqr2p1 >;
#declare v24 = < sqr2p1 , -1.0 , -sqr2p1 , -sqr2p1 >;
#declare v25 = < sqr2p1 , -1.0 , -sqr2p1 , sqr2p1 >;
#declare v26 = < sqr2p1 , -1.0 , sqr2p1 , -sqr2p1 >;
#declare v27 = < sqr2p1 , -1.0 , sqr2p1 , sqr2p1 >;
#declare v28 = < sqr2p1 , 1.0 , -sqr2p1 , -sqr2p1 >;
#declare v29 = < sqr2p1 , 1.0 , -sqr2p1 , sqr2p1 >;
#declare v30 = < sqr2p1 , 1.0 , sqr2p1 , -sqr2p1 >;
#declare v31 = < sqr2p1 , 1.0 , sqr2p1 , sqr2p1 >;
#declare v32 = < -sqr2p1 , -sqr2p1 , -1.0 , -sqr2p1 >;
#declare v33 = < -sqr2p1 , -sqr2p1 , -1.0 , sqr2p1 >;
#declare v34 = < -sqr2p1 , -sqr2p1 , 1.0 , -sqr2p1 >;
#declare v35 = < -sqr2p1 , -sqr2p1 , 1.0 , sqr2p1 >;
#declare v36 = < -sqr2p1 , sqr2p1 , -1.0 , -sqr2p1 >;
#declare v37 = < -sqr2p1 , sqr2p1 , -1.0 , sqr2p1 >;
#declare v38 = < -sqr2p1 , sqr2p1 , 1.0 , -sqr2p1 >;
#declare v39 = < -sqr2p1 , sqr2p1 , 1.0 , sqr2p1 >;
#declare v40 = < sqr2p1 , -sqr2p1 , -1.0 , -sqr2p1 >;
#declare v41 = < sqr2p1 , -sqr2p1 , -1.0 , sqr2p1 >;
#declare v42 = < sqr2p1 , -sqr2p1 , 1.0 , -sqr2p1 >;
#declare v43 = < sqr2p1 , -sqr2p1 , 1.0 , sqr2p1 >;
#declare v44 = < sqr2p1 , sqr2p1 , -1.0 , -sqr2p1 >;
#declare v45 = < sqr2p1 , sqr2p1 , -1.0 , sqr2p1 >;
#declare v46 = < sqr2p1 , sqr2p1 , 1.0 , -sqr2p1 >;
#declare v47 = < sqr2p1 , sqr2p1 , 1.0 , sqr2p1 >;
#declare v48 = < -sqr2p1 , -sqr2p1 , -sqr2p1 , -1.0 >;
#declare v49 = < -sqr2p1 , -sqr2p1 , -sqr2p1 , 1.0 >;
#declare v50 = < -sqr2p1 , -sqr2p1 , sqr2p1 , -1.0 >;
#declare v51 = < -sqr2p1 , -sqr2p1 , sqr2p1 , 1.0 >;
#declare v52 = < -sqr2p1 , sqr2p1 , -sqr2p1 , -1.0 >;
#declare v53 = < -sqr2p1 , sqr2p1 , -sqr2p1 , 1.0 >;
#declare v54 = < -sqr2p1 , sqr2p1 , sqr2p1 , -1.0 >;
#declare v55 = < -sqr2p1 , sqr2p1 , sqr2p1 , 1.0 >;
#declare v56 = < sqr2p1 , -sqr2p1 , -sqr2p1 , -1.0 >;
#declare v57 = < sqr2p1 , -sqr2p1 , -sqr2p1 , 1.0 >;
#declare v58 = < sqr2p1 , -sqr2p1 , sqr2p1 , -1.0 >;
#declare v59 = < sqr2p1 , -sqr2p1 , sqr2p1 , 1.0 >;
#declare v60 = < sqr2p1 , sqr2p1 , -sqr2p1 , -1.0 >;
#declare v61 = < sqr2p1 , sqr2p1 , -sqr2p1 , 1.0 >;
#declare v62 = < sqr2p1 , sqr2p1 , sqr2p1 , -1.0 >;
#declare v63 = < sqr2p1 , sqr2p1 , sqr2p1 , 1.0 >;
#declare vertices = array[64] 
    {v0,v1,v2,v3,v4,v5,v6,v7,v8,v9,v10,v11,v12,v13,v14,v15,
    v16,v17,v18,v19,v20,v21,v22,v23,v24,v25,v26,v27,v28,v29,v30,v31,
    v32,v33,v34,v35,v36,v37,v38,v39,v40,v41,v42,v43,v44,v45,v46,v47,
    v48,v49,v50,v51,v52,v53,v54,v55,v56,v57,v58,v59,v60,v61,v62,v63};

/* edges */
#declare edges = array[128][2] 
{ { 0 , 8 }
, { 0 , 16 }
, { 0 , 32 }
, { 0 , 48 }
, { 1 , 9 }
, { 1 , 17 }
, { 1 , 33 }
, { 1 , 49 }
, { 2 , 10 }
, { 2 , 18 }
, { 2 , 34 }
, { 2 , 50 }
, { 3 , 11 }
, { 3 , 19 }
, { 3 , 35 }
, { 3 , 51 }
, { 4 , 12 }
, { 4 , 20 }
, { 4 , 36 }
, { 4 , 52 }
, { 5 , 13 }
, { 5 , 21 }
, { 5 , 37 }
, { 5 , 53 }
, { 6 , 14 }
, { 6 , 22 }
, { 6 , 38 }
, { 6 , 54 }
, { 7 , 15 }
, { 7 , 23 }
, { 7 , 39 }
, { 7 , 55 }
, { 8 , 24 }
, { 8 , 40 }
, { 8 , 56 }
, { 9 , 25 }
, { 9 , 41 }
, { 9 , 57 }
, { 10 , 26 }
, { 10 , 42 }
, { 10 , 58 }
, { 11 , 27 }
, { 11 , 43 }
, { 11 , 59 }
, { 12 , 28 }
, { 12 , 44 }
, { 12 , 60 }
, { 13 , 29 }
, { 13 , 45 }
, { 13 , 61 }
, { 14 , 30 }
, { 14 , 46 }
, { 14 , 62 }
, { 15 , 31 }
, { 15 , 47 }
, { 15 , 63 }
, { 16 , 20 }
, { 16 , 32 }
, { 16 , 48 }
, { 17 , 21 }
, { 17 , 33 }
, { 17 , 49 }
, { 18 , 22 }
, { 18 , 34 }
, { 18 , 50 }
, { 19 , 23 }
, { 19 , 35 }
, { 19 , 51 }
, { 20 , 36 }
, { 20 , 52 }
, { 21 , 37 }
, { 21 , 53 }
, { 22 , 38 }
, { 22 , 54 }
, { 23 , 39 }
, { 23 , 55 }
, { 24 , 28 }
, { 24 , 40 }
, { 24 , 56 }
, { 25 , 29 }
, { 25 , 41 }
, { 25 , 57 }
, { 26 , 30 }
, { 26 , 42 }
, { 26 , 58 }
, { 27 , 31 }
, { 27 , 43 }
, { 27 , 59 }
, { 28 , 44 }
, { 28 , 60 }
, { 29 , 45 }
, { 29 , 61 }
, { 30 , 46 }
, { 30 , 62 }
, { 31 , 47 }
, { 31 , 63 }
, { 32 , 34 }
, { 32 , 48 }
, { 33 , 35 }
, { 33 , 49 }
, { 34 , 50 }
, { 35 , 51 }
, { 36 , 38 }
, { 36 , 52 }
, { 37 , 39 }
, { 37 , 53 }
, { 38 , 54 }
, { 39 , 55 }
, { 40 , 42 }
, { 40 , 56 }
, { 41 , 43 }
, { 41 , 57 }
, { 42 , 58 }
, { 43 , 59 }
, { 44 , 46 }
, { 44 , 60 }
, { 45 , 47 }
, { 45 , 61 }
, { 46 , 62 }
, { 47 , 63 }
, { 48 , 49 }
, { 50 , 51 }
, { 52 , 53 }
, { 54 , 55 }
, { 56 , 57 }
, { 58 , 59 }
, { 60 , 61 }
, { 62 , 63 } };

/* tetrahedra */
#declare tetrahedra = array[16][4]
{ { 0 , 16 , 32 , 48 }
, { 11 , 27 , 43 , 59 }
, { 12 , 28 , 44 , 60 }
, { 8 , 24 , 40 , 56 }
, { 9 , 25 , 41 , 57 }
, { 15 , 31 , 47 , 63 }
, { 13 , 29 , 45 , 61 }
, { 14 , 30 , 46 , 62 }
, { 10 , 26 , 42 , 58 }
, { 3 , 19 , 35 , 51 }
, { 2 , 18 , 34 , 50 }
, { 1 , 17 , 33 , 49 }
, { 4 , 20 , 36 , 52 }
, { 5 , 21 , 37 , 53 }
, { 6 , 22 , 38 , 54 }
, { 7 , 23 , 39 , 55 } };

#declare faces = array[64][3];
#for(i, 0, 15)
    #declare faces[4*i][0] = tetrahedra[i][0];
    #declare faces[4*i][1] = tetrahedra[i][1];
    #declare faces[4*i][2] = tetrahedra[i][2];
    #declare faces[4*i+1][0] = tetrahedra[i][0];
    #declare faces[4*i+1][1] = tetrahedra[i][1];
    #declare faces[4*i+1][2] = tetrahedra[i][3];
    #declare faces[4*i+2][0] = tetrahedra[i][0];
    #declare faces[4*i+2][1] = tetrahedra[i][2];
    #declare faces[4*i+2][2] = tetrahedra[i][3];
    #declare faces[4*i+3][0] = tetrahedra[i][1];
    #declare faces[4*i+3][1] = tetrahedra[i][2];
    #declare faces[4*i+3][2] = tetrahedra[i][3];
#end


/* rotation in 4D space */
#macro rotate4d(theta, phi, xi, vec)
    #local a = cos(xi);
    #local b = sin(theta)*cos(phi)*sin(xi);
    #local c = sin(theta)*sin(phi)*sin(xi);
    #local d = cos(theta)*sin(xi);
    #local p = vec.x;
    #local q = vec.y;
    #local r = vec.z;
    #local s = vec.t;
    < a*p - b*q - c*r - d*s
    , a*q + b*p + c*s - d*r
    , a*r - b*s + c*p + d*q
    , a*s + b*r - c*q + d*p >
#end

/* stereographic projection */
#macro StereographicProjection(q, r)
    <q.x,q.y,q.z>/(r-q.t)
#end

/* rotated and projected vertices */
#macro ProjectedVertices(theta, phi, xi, r)
    #local out = array[64];
    #for(i, 0, 63)
        #local out[i] = StereographicProjection(
                            rotate4d(theta,phi,xi,vertices[i]), r
                        );
    #end
    out
#end

/* macro spherical segment */
#macro vlength4(P)
    sqrt(P.x*P.x + P.y*P.y + P.z*P.z + P.t*P.t)
#end

#macro sphericalSegment(P, Q, r, n)
    #local out = array[n+1];
    #for(i, 0, n)
        #local pt = P + (i/n)*(Q-P);
        #local out[i] = r/vlength4(pt) * pt;
    #end
    out
#end

/* macro to draw an edge */
#macro Edge(verts, v1, v2, theta, phi, xi, r, Tex)
    #local P = verts[v1];
    #local Q = verts[v2];
    #local PQ = sphericalSegment(P, Q, r, 100);
    sphere_sweep {
        b_spline 101
        #for(k,0,100)
            #local O = 
                StereographicProjection(rotate4d(theta,phi,xi,PQ[k]), r);
            O log(1+vlength(O)/4)/2
        #end
        texture { 
            Tex
        }
    }
#end

/* stereographic subdivision (to fill the triangular faces) */
#macro midpoint4(A, B, r)
    #local xmid = (A.x + B.x)/2;
    #local ymid = (A.y + B.y)/2;
    #local zmid = (A.z + B.z)/2;
    #local tmid = (A.t + B.t)/2;
    #local lg = sqrt(xmid*xmid + ymid*ymid + zmid*zmid + tmid*tmid) / r;
    < xmid / lg, ymid / lg, zmid / lg, tmid / lg >
#end

#macro subdiv0(A, B, C, r)
    #local mAB = midpoint4(A, B, r);
    #local mAC = midpoint4(A, C, r);
    #local mBC = midpoint4(B, C, r);
    #local trgl1 = array[3] {A, mAB, mAC};
    #local trgl2 = array[3] {B, mAB, mBC};
    #local trgl3 = array[3] {C, mBC, mAC};
    #local trgl4 = array[3] {mAB, mAC, mBC};
    array[4] {trgl1, trgl2, trgl3, trgl4}
#end

#macro subdiv(A, B, C, r, depth)
    #if(depth=1)
        #local out = subdiv0(A, B, C, r);
    #else
        #local triangles = subdiv(A, B, C, r, depth-1);
        #local out = array[pow(4,depth)];
        #for(i, 0, pow(4,depth-1)-1)
            #local trgl = triangles[i];
            #local trgls = subdiv0(trgl[0], trgl[1], trgl[2], r);
            #local out[4*i] = trgls[0];
            #local out[4*i+1] = trgls[1];
            #local out[4*i+2] = trgls[2];
            #local out[4*i+3] = trgls[3];
        #end
    #end
    out
#end

/*-------------------------------------------*/
/*-----      draw the polychoron       ------*/
/*-------------------------------------------*/
#declare theta = pi/2;
#declare phi = 0;
#declare xi = 2*frame_number*pi/180;
#declare r = sqrt(1+3*sqr2p1*sqr2p1); 
#declare depth = 5;

#declare vs = ProjectedVertices(theta, phi, xi, r);

#declare stereoTriangles = array[64];
#for(i, 0, 63)
    #local triangles4 = 
        subdiv(
            vertices[faces[i][0]], 
            vertices[faces[i][1]], 
            vertices[faces[i][2]], r, depth);
    #declare stereoTriangles[i] = array[dimension_size(triangles4,1)][3];
    #for(j, 0, dimension_size(triangles4,1)-1)
        #local trgl4 = triangles4[j];
        #declare stereoTriangles[i][j][0] = 
            StereographicProjection(rotate4d(theta, phi, xi, trgl4[0]), r);
        #declare stereoTriangles[i][j][1] = 
            StereographicProjection(rotate4d(theta, phi, xi, trgl4[1]), r);
        #declare stereoTriangles[i][j][2] = 
            StereographicProjection(rotate4d(theta, phi, xi, trgl4[2]), r);
    #end
#end

#declare edgeTexture = texture {
    pigment { color DarkPurple }
    finish {
      ambient .1
      diffuse .9
      reflection 0
      specular 1
      metallic
    }
};

object {
    union {
        /* draw edges */
        #for(i, 0, 127)
            Edge(vertices, edges[i][0], edges[i][1], 
                    theta, phi, xi, r, edgeTexture)
        #end
        /* draw vertices */ 
        #for(i,0,63)
            sphere {
                vs[i], vlength(vs[i])/15
                texture { edgeTexture }
            }
        #end  
        /* fill triangles */
        mesh {
            #for(i, 0, 63)
                #local trgl = stereoTriangles[i];
                #for(j, 0, dimension_size(trgl,1)-1)
                    triangle {
                        trgl[j][0], trgl[j][1], trgl[j][2]
                    }
                #end
            #end
            texture {
                pigment { Red }
                finish {
                    ambient 0.5
                    reflection 0
                    brilliance 4
                }
            }
        }
     }
     scale 0.5
     translate <-8, 6, -25>
}
```

![](figures/truncatedTesseract_stereographic_povray.gif)
