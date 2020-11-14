---
author: Stéphane Laurent
date: '2020-02-11'
highlighter: 'pandoc-solarized'
output:
  html_document:
    highlight: kate
    keep_md: no
  md_document:
    preserve_yaml: True
    variant: markdown
rbloggers: yes
tags: 'R, maths, geometry, graphics, rgl, asymptote, povray'
title: Drawing a stereographic duoprism
---

In this post, I'll show how to draw a stereographic
[duoprism](./Duoprism.html) using R, Asymptote and POV-Ray.

With R
======

``` {.r .numberLines}
library(rgl)

A <- 8L # number of sides of the first polygon
B <- 4L # number of sides of the second polygon

# construction of the vertices
vertices <- array(NA_real_, dim = c(A,B,4L))
for(i in 1L:A){
  v1 <- c(cos(i/A*2*pi), sin(i/A*2*pi))
  for(j in 1L:B){
    v2 <- c(cos(j/B*2*pi), sin(j/B*2*pi))
    vertices[i,j,] <- c(v1,v2)
  }
}

# construction of the edges
edges <- array(NA_integer_, dim = c(2L,2L,2L*A*B))
dominates <- function(c1, c2){
  c2[1L]>c1[1L] || (c2[1L]==c1[1L] && c2[2L]>c1[2L])
}
counter <- 1L
for(i in seq_len(A)-1L){
  for(j in seq_len(B)-1L){
    c1 <- c(i,j)
    candidate <- c(i, (j-1L)%%B)
    if(dominates(c1, candidate)){
      edges[,,counter] <- cbind(c1, candidate) + 1L
      counter <- counter + 1L
    }
    candidate <- c(i, (j+1L)%%B)
    if(dominates(c1, candidate)){
      edges[,,counter] <- cbind(c1, candidate) + 1L
      counter <- counter + 1L
    }
    candidate <- c((i-1L)%%A, j)
    if(dominates(c1, candidate)){
      edges[,,counter] <- cbind(c1, candidate) + 1L
      counter <- counter + 1L
    }
    candidate <- c((i+1L)%%A, j)
    if(dominates(c1, candidate)){
      edges[,,counter] <- cbind(c1, candidate) + 1L
      counter <- counter + 1L
    }
  }
}

# stereographic projection
stereog <- function(v){
  v[1L:3L] / (sqrt(2) - v[4L])
}

# spherical segment
sphericalSegment <- function(P, Q, n){
  out <- matrix(NA_real_, nrow = n+1L, ncol = 4L)
  for(i in 0L:n){
    pt <- P + (i/n)*(Q-P)
    out[i+1L, ] <- sqrt(2/c(crossprod(pt))) * pt
  }
  out
}

# stereographic edge
stereoEdge <- function(verts, v1, v2){
  P <- verts[v1[1L], v1[2L], ]
  Q <- verts[v2[1L], v2[2L], ]
  PQ <- sphericalSegment(P, Q, 100L)
  pq <- t(apply(PQ, 1L, stereog))
  dists <- sqrt(apply(pq, 1L, crossprod))
  cylinder3d(pq, radius = dists/15, sides = 60)
}

# projected vertices
vs <- apply(vertices, c(1L,2L), stereog)

####~~~~ plot ~~~~####
open3d(windowRect = c(50, 50, 562, 562), zoom = 0.9)
bg3d(rgb(54, 57, 64, maxColorValue = 255))
## plot the edges
for(k in 1L:(2L*A*B)){
  v1 <- edges[, 1L, k]
  v2 <- edges[, 2L, k]
  edge <- stereoEdge(vertices, v1, v2)
  shade3d(edge, color = "gold")
}
## plot the vertices
for(i in 1L:A){
  for(j in 1L:B){
    v <- vs[,i,j]
    spheres3d(v, radius = sqrt(c(crossprod(v)))/10 , color = "gold2")
  }
}
```

![](./figures/DuoprismStereo_R.png)

With Asymptote
==============

``` {.cpp .numberLines}
settings.render = 4;
settings.outformat = "eps";
import tube;
size(200,0);

currentprojection = orthographic(4,4,4);
currentlight = light(gray(0.85), ambient=black, specularfactor=3,
                     (100,100,100), specular=gray(0.9), viewport=false);
currentlight.background = rgb("363940ff");

// files to be saved -----------------------------------------------------------
string[] files = {
    "DP000", "DP001", "DP002", "DP003", "DP004", "DP005",
    "DP006", "DP007", "DP008", "DP009", "DP010", "DP011",
    "DP012", "DP013", "DP014", "DP015", "DP016", "DP017",
    "DP018", "DP019", "DP020", "DP021", "DP022", "DP023",
    "DP024", "DP025", "DP026", "DP027", "DP028", "DP029",
    "DP030", "DP031", "DP032", "DP033", "DP034", "DP035",
    "DP036", "DP037", "DP038", "DP039", "DP040", "DP041",
    "DP042", "DP043", "DP044", "DP045", "DP046", "DP047",
    "DP048", "DP049", "DP050", "DP051", "DP052", "DP053",
    "DP054", "DP055", "DP056", "DP057", "DP058", "DP059",
    "DP060", "DP061", "DP062", "DP063", "DP064", "DP065",
    "DP066", "DP067", "DP068", "DP069", "DP070", "DP071",
    "DP072", "DP073", "DP074", "DP075", "DP076", "DP077",
    "DP078", "DP079", "DP080", "DP081", "DP082", "DP083",
    "DP084", "DP085", "DP086", "DP087", "DP088", "DP089",
    "DP090", "DP091", "DP092", "DP093", "DP094", "DP095",
    "DP096", "DP097", "DP098", "DP099", "DP100", "DP101",
    "DP102", "DP103", "DP104", "DP105", "DP106", "DP107",
    "DP108", "DP109", "DP110", "DP111", "DP112", "DP113",
    "DP114", "DP115", "DP116", "DP117", "DP118", "DP119",
    "DP120", "DP121", "DP122", "DP123", "DP124", "DP125",
    "DP126", "DP127", "DP128", "DP129", "DP130", "DP131",
    "DP132", "DP133", "DP134", "DP135", "DP136", "DP137",
    "DP138", "DP139", "DP140", "DP141", "DP142", "DP143",
    "DP144", "DP145", "DP146", "DP147", "DP148", "DP149",
    "DP150", "DP151", "DP152", "DP153", "DP154", "DP155",
    "DP156", "DP157", "DP158", "DP159", "DP160", "DP161",
    "DP162", "DP163", "DP164", "DP165", "DP166", "DP167",
    "DP168", "DP169", "DP170", "DP171", "DP172", "DP173",
    "DP174", "DP175", "DP176", "DP177", "DP178", "DP179"};

// lexicographic order ---------------------------------------------------------
bool dominates(int[] e1, int[] e2){
    return e2[0]>e1[0] || (e2[0]==e1[0] && e2[1]>e1[1]);
}

// vertices --------------------------------------------------------------------
int A = 8;
int B = 4;

struct quadruple {
    real x;
    real y;
    real z;
    real t;
}

real[][] poly1 = new real[A][2];
for(int i = 0; i < A; ++i){
    poly1[i][0] = cos(i/A*2pi);
    poly1[i][1] = sin(i/A*2pi);
}
real[][] poly2 = new real[B][2];
for(int i = 0; i < B; ++i){
    poly2[i][0] = cos(pi/B+i/B*2pi);
    poly2[i][1] = sin(pi/B+i/B*2pi);
}
quadruple[][] vertices = new quadruple[A][B];
for(int i = 0; i < A; ++i){
    for(int j = 0; j < B; ++j){
        quadruple v;
        v.x = poly1[i][0]; v.y = poly1[i][1]; 
        v.z = poly2[j][0]; v.t = poly2[j][1];
        vertices[i][j] = v;
    }
}

// edges -----------------------------------------------------------------------
int[][][] edges;
for(int i = 0; i < A; ++i){
    for(int j = 0; j < B; ++j){
        int[] e = {i,j};
        int[] candidate = {i,(j-1)%B};
        if(dominates(e,candidate)){
            int[][] edge = {e,candidate}; 
            edges.push(edge);
        }
        int[] candidate = {i,(j+1)%B};
        if(dominates(e,candidate)){
            int[][] edge = {e,candidate}; 
            edges.push(edge);
        }
        int[] candidate = {(i-1)%A,j};
        if(dominates(e,candidate)){
            int[][] edge = {e,candidate}; 
            edges.push(edge);
        }
        int[] candidate = {(i+1)%A,j};
        if(dominates(e,candidate)){
            int[][] edge = {e,candidate}; 
            edges.push(edge);
        }
    }
}

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

// bounding box ----------------------------------------------------------------
real f=3, h = 4.5, g = 1.5;
path3 boundingbox = (-h,0,-f)--(-h,0,g)--(h,0,f)--(h,0,-g)--cycle;

// draw the duoprism -----------------------------------------------------------
int n = 100;
real r = sqrt(2);
real alpha = pi/2, beta = 0;

for(int file = 0; file < 180; ++file){
    real xi = 2*file*pi/180;
    picture pic;
    // draw bounding box
    draw(pic, boundingbox, rgb("363940ff")+opacity(0));
    // draw edges
    for(int k = 0; k < 2*A*B; ++k){
        quadruple A = vertices[edges[k][0][0]][edges[k][0][1]];
        quadruple B = vertices[edges[k][1][0]][edges[k][1][1]];
        path3 p3 = 
            stereoPath(rotate4d(alpha, beta, xi, A), 
                       rotate4d(alpha, beta, xi, B), r, n);
        transform S(real t){
            return T(p3, t, n);
        }
        draw(pic, tube(p3, unitcircle, S), rgb(139,0,139), 
                                render(compression=Low, merge=true));
    }
    // draw vertices
    for(int i = 0; i < A; ++i){
        for(int j = 0; j < B; ++j){
            triple Asg = 
                stereog(rotate4d(alpha, beta, xi, vertices[i][j]), r);
            draw(pic, shift(Asg)*scale3(length(Asg)/10)*unitsphere, purple);
        }
    }
    // add and save picture
    add(pic);
    shipout(files[file], bbox(rgb("363940ff"), FillDraw(rgb("363940ff"))));
    erase();
}

/* to do the animation
gs -dSAFER -dBATCH -dNOPAUSE -dEPSCrop -sDEVICE=png16m -r600 -sOutputFile=zpic%03d.png DP*.eps
mogrify -resize 512x zpic*.png
gifski --fps 12 zpic*.png -o DuoprismStereo.gif
*/
```

![](./figures/DuoprismStereo_Asy.gif)

With POV-Ray
============

``` {.povray .numberLines}
#version 3.7;
global_settings { assumed_gamma 1 }
#include "colors.inc"
#include "textures.inc"

/* camera */
camera {
  location <-11, 7, -32>
  look_at 0
  angle 45
  right x*image_width/image_height
}

// sun -------------------------------------------------------------------------
light_source {< 4000,6000,-6000> color rgb<1,1,1>*0.9}           // sun 
light_source {<-11, 7,-32>  color rgb<0.9,0.9,1>*0.1 shadowless} // flash

// sky -------------------------------------------------------------------------
plane {
  <0,1,0>, 1 hollow  
  texture {
    pigment { 
      bozo turbulence 1.3
      color_map {
        [0.00 rgb <0.24, 0.32, 1.0>*0.6]
        [0.75 rgb <0.24, 0.32, 1.0>*0.6]
        [0.83 rgb <1,1,1>]
        [0.95 rgb <0.25,0.25,0.25>]
        [1.0 rgb <0.5,0.5,0.5>]
      }
      scale<1,1,1>*2.5  translate< 0,0,3>
    }
    finish {
      ambient 1 
      diffuse 0
    } 
  }      
  scale 10000
}

// fog on the ground -----------------------------------------------------------
fog {
  fog_type   2
  distance   50
  color      Gray10  
  fog_offset 0.1
  fog_alt    1.5
  turbulence 1.8
}

// ground ----------------------------------------------------------------------
plane {
  <0,1,0>, 0 
  texture {
    pigment { color rgb <0.95,0.9,0.73>*0.35 }
    normal { bumps 2 scale <0.25,0.25,0.25>*0.5 turbulence 0.5 } 
    finish { phong 0.1 }
  } 
} 


/* ----- vertices ----- */
#declare A = 4;
#declare B = 30;

#declare poly1 = array[A];
#for(i,0,A-1)
  #declare poly1[i] = array[2] {cos(i/A*2*pi), sin(i/A*2*pi)};
#end
#declare poly2 = array[B];
#for(i,0,B-1)
  #declare poly2[i] = array[2] {cos(i/B*2*pi), sin(i/B*2*pi)};
#end
#declare vertices = array[A][B];
#for(i,0,A-1)
  #for(j,0,B-1)
    #declare vertices[i][j] = 
      < poly1[i][0], poly1[i][1], poly2[j][0], poly2[j][1] >;
  #end
#end

/* ----- edges ----- */
#macro dominates(e1,e2)
  (e2[0]>e1[0]) | ((e2[0]=e1[0]) & (e2[1]>e1[1]))
#end
#declare nedges = 2*A*B;
#declare edges = array[nedges];
#declare k=0;
#for(i,0,A-1)
  #for(j,0,B-1)
    #local e = array[2] {i,j};
    #local candidate = array[2] {i,mod(mod(j-1,B)+B,B)};
    #if(dominates(e,candidate))
      #local edge = array[2] {e,candidate};
      #declare edges[k] = edge;
      #declare k = k+1;
    #end
    #local candidate = array[2] {i,mod(mod(j+1,B)+B,B)};
    #if(dominates(e,candidate))
      #local edge = array[2] {e,candidate};
      #declare edges[k] = edge;
      #declare k = k+1;
    #end
    #local candidate = array[2] {mod(mod(i-1,A)+A,A),j};
    #if(dominates(e,candidate))
      #local edge = array[2] {e,candidate};
      #declare edges[k] = edge;
      #declare k = k+1;
    #end
    #local candidate = array[2] {mod(mod(i+1,A)+A,A),j};
    #if(dominates(e,candidate))
      #local edge = array[2] {e,candidate};
      #declare edges[k] = edge;
      #declare k = k+1;
    #end
  #end
#end

/* rotation in 4D space */
#macro rotate4d(theta,phi,xi,vec)
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
#macro StereographicProjection(q)
  <q.x,q.y,q.z> / (sqrt(2)-q.t)
#end

/* rotated and projected vertices */
#macro ProjectedVertices(theta,phi,xi)
  #local out = array[A][B];
  #for(i,0,A-1)
    #for(j,0,B-1)
      #local out[i][j] = StereographicProjection(
                            rotate4d(theta,phi,xi,vertices[i][j])
                          );
    #end
  #end
  out
#end

/* macro spherical segment */
#macro vlength4(P)
  sqrt(P.x*P.x + P.y*P.y + P.z*P.z + P.t*P.t)
#end

#macro sphericalSegment(P, Q, n)
  #local out = array[n+1];
  #for(i, 0, n)
    #local pt = P + (i/n)*(Q-P);
    #local out[i] = sqrt(2)/vlength4(pt) * pt;
  #end
  out
#end

/* macro to draw an edge */
#macro Edge(verts, v1, v2, theta, phi, xi, Tex)
  #local P = verts[v1[0]][v1[1]];
  #local Q = verts[v2[0]][v2[1]];
  #local PQ = sphericalSegment(P, Q, 100);
  sphere_sweep {
    b_spline 101
    #for(k,0,100)
      #local O = 
        StereographicProjection(rotate4d(theta,phi,xi,PQ[k]));
      O vlength(O)/15
    #end
    texture { Tex }
  }
#end

/*-----------------------------------------*/
/*-----      draw the duoprism       ------*/
/*-----------------------------------------*/
#declare theta = pi/2;
#declare phi = 0;
#declare xi = 2*frame_number*pi/180; 

#declare vs = ProjectedVertices(theta, phi, xi);

#declare edgeTexture = texture {
  pigment { color Red }
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
    #for(i, 0, 2*A*B-1)
      Edge(vertices, edges[i][0], edges[i][1], 
                    theta, phi, xi, edgeTexture)
    #end
    /* draw vertices */
    #for(i,0,A-1)
      #for(j,0,B-1)
        sphere {
          vs[i][j], vlength(vs[i][j])/10
          texture { edgeTexture }
        }
      #end
    #end  
  }
  translate <-3, 6, -15>
  scale 0.8
}

/* ini file 
Width = 512
Height = 512
Antialias = On
Antialias_Threshold = 0.3
Input_File_Name = DuoprismStereographic.pov
Initial_Clock = 0
Final_Clock = 1
Initial_Frame = 0
Final_Frame = 179
Subset_Start_Frame = 0
Cyclic_Animation = on
*/
```

![](./figures/DuoprismStereo_POVRAY.gif)

<br/>

Here is another one. This is a hexagonal duoprism with a cell colored in
red.

``` {.povray}
#version 3.7;
global_settings { assumed_gamma 1 } 
#include "colors.inc"
#include "textures.inc"

// camera ----------------------------------------------------------------------
camera {
  location <0, 0,-10>
  look_at 0
  angle 45
  right x*image_width/image_height
}

// light sources ---------------------------------------------------------------
light_source { <0,0,-100> White shadowless } 
light_source { <100,0,-100> White shadowless } 

// moon ------------------------------------------------------------------------
light_source { 
  <-1000, 800, 3000> 
  color White
  shadowless
  looks_like { 
    sphere { 
      <0,0,0>, 300 
      texture { 
        pigment { 
          color Yellow
        }
        normal { 
          bumps 0.5
          scale 50
        }
        finish { 
          emission 0.8   
          diffuse 0.2
          phong 1
        }                                        
      } 
    } 
  } 
} 

// sky -------------------------------------------------------------------------
plane { 
  <0,1,0>, 1 hollow  
  texture { 
    pigment { 
      color rgb <0.01, 0.01, 0.2> 
    }
    finish { 
      emission 0.5 
      diffuse 0.5 
    } 
  }  
  scale 10000
}

// the clouds ------------------------------------------------------------------
plane { 
  <0,1,0>,1 hollow  
  texture { 
    pigment { 
      bozo turbulence 1.3
      color_map { 
        [0.00 rgb <0.24, 0.32, 1.0>*0.6]
        [0.75 rgb <0.24, 0.32, 1.0>*0.6]
        [0.83 rgb <1,1,1>              ]
        [0.95 rgb <0.25,0.25,0.25>     ]
        [1.00 rgb <0.5,0.5,0.5>        ]
      }
      scale 2.5
      translate <0,1,0>
    }
    finish { 
      emission 0.25 
      diffuse 0
    } 
  }      
  scale 5000
}

// fog on the ground -----------------------------------------------------------
fog { 
  fog_type   2
  distance   50
  color      Gray50  
  fog_offset 0.1
  fog_alt    1.5
  turbulence 1.8
}

// sea -------------------------------------------------------------------------
plane { 
  <0,1,0>, -1 hollow
  texture{
    pigment{
      rgb <.098,.098,.439>
    }
    finish {
      ambient 0.15
      diffuse 0.55
      brilliance 6.0
      phong 0.8
      phong_size 120
      reflection 0.2
    }
    normal { 
      bumps 0.95
      turbulence .05 
      scale <1,0.25,1> 
    }
  }
}

// vertices --------------------------------------------------------------------
#declare a = sqrt(3) / 2;
#declare vertices = array[36]
  {
    <a, 0.5, a, 0.5>,
    <a, 0.5, 0.0, 1.0>,
    <a, 0.5, -a, 0.5>,
    <a, 0.5, -a, -0.5>,
    <a, 0.5, 0.0, -1.0>,
    <a, 0.5, a, -0.5>,
    <0.0, 1.0, a, 0.5>,
    <0.0, 1.0, 0.0, 1.0>,
    <0.0, 1.0, -a, 0.5>,
    <0.0, 1.0, -a, -0.5>,
    <0.0, 1.0, 0.0, -1.0>,
    <0.0, 1.0, a, -0.5>,
    <-a, 0.5, a, 0.5>,
    <-a, 0.5, 0.0, 1.0>,
    <-a, 0.5, -a, 0.5>,
    <-a, 0.5, -a, -0.5>,
    <-a, 0.5, 0.0, -1.0>,
    <-a, 0.5, a, -0.5>,
    <-a, -0.5, a, 0.5>,
    <-a, -0.5, 0.0, 1.0>,
    <-a, -0.5, -a, 0.5>,
    <-a, -0.5, -a, -0.5>,
    <-a, -0.5, 0.0, -1.0>,
    <-a, -0.5, a, -0.5>,
    <0.0, -1.0, a, 0.5>,
    <0.0, -1.0, 0.0, 1.0>,
    <0.0, -1.0, -a, 0.5>,
    <0.0, -1.0, -a, -0.5>,
    <0.0, -1.0, 0.0, -1.0>,
    <0.0, -1.0, a, -0.5>,
    <a, -0.5, a, 0.5>,
    <a, -0.5, 0.0, 1.0>,
    <a, -0.5, -a, 0.5>,
    <a, -0.5, -a, -0.5>,
    <a, -0.5, 0.0, -1.0>,
    <a, -0.5, a, -0.5>
  };
#declare facetVertices = array[12] {0,5,6,30,11,35,12,17,18,23,24,29};
#declare otherVertices = array[24] 
  {1,2,3,4,7,8,
  9,10,13,14,15,16,
  19,20,21,22,25,26,
  27,28,31,32,33,34};

// edges -------------------------------------------------------------------
#declare facetEdges = array[18][2]
  {
    {0, 5},
    {0, 6},
    {0, 30},
    {5, 11},
    {5, 35},
    {6, 11},
    {6, 12},
    {11, 17},
    {12, 17},
    {12, 18},
    {17, 23},
    {18, 23},
    {18, 24},
    {23, 29},
    {24, 29},
    {24, 30},
    {29, 35},
    {30, 35}
  };
#declare otherEdges = array[54][2]
  {
    {0, 1},
    {1, 2},
    {1, 7},
    {1, 31},
    {2, 3},
    {2, 8},
    {2, 32},
    {3, 4},
    {3, 9},
    {3, 33},
    {4, 5},
    {4, 10},
    {4, 34},
    {6, 7},
    {7, 8},
    {7, 13},
    {8, 9},
    {8, 14},
    {9, 10},
    {9, 15},
    {10, 11},
    {10, 16},
    {12, 13},
    {13, 14},
    {13, 19},
    {14, 15},
    {14, 20},
    {15, 16},
    {15, 21},
    {16, 17},
    {16, 22},
    {18, 19},
    {19, 20},
    {19, 25},
    {20, 21},
    {20, 26},
    {21, 22},
    {21, 27},
    {22, 23},
    {22, 28},
    {24, 25},
    {25, 26},
    {25, 31},
    {26, 27},
    {26, 32},
    {27, 28},
    {27, 33},
    {28, 29},
    {28, 34},
    {30, 31},
    {31, 32},
    {32, 33},
    {33, 34},
    {34, 35}
  };

// macros ----------------------------------------------------------------------
#macro vlength4(P)
  sqrt(P.x*P.x + P.y*P.y + P.z*P.z + P.t*P.t)
#end

#macro sphericalSegment(P, Q, n)
  #local out = array[n+1];
  #for(i, 0, n)
    #local pt = P + (i/n)*(Q-P);
    #local out[i] = sqrt(2)/vlength4(pt) * pt;
  #end
  out
#end

#macro rotate4d(theta,phi,xi,vec)
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

#macro StereographicProjection(q) 
  acos(q.t/sqrt(2))/sqrt(2-q.t*q.t) * <q.x,q.y,q.z>
#end

#macro ProjectedFacetVertices(theta, phi, xi)
  #local out = array[12];
  #for(i, 0, 11)
    #local out[i] = 
      StereographicProjection(
        rotate4d(theta, phi, xi, vertices[facetVertices[i]])
      );
  #end
  out
#end

#macro ProjectedOtherVertices(theta, phi, xi)
  #local out = array[24];
  #for(i, 0, 23)
    #local out[i] = 
      StereographicProjection(
        rotate4d(theta, phi, xi, vertices[otherVertices[i]])
      );
  #end
  out
#end

// texture ---------------------------------------------------------------------
#declare edgeTexture1 = 
  texture {
    New_Penny
    finish {
      ambient 0.01
      diffuse 2
      reflection 0
      brilliance 8
      specular 0.1
      roughness 0.1
    }
  };

#declare edgeTexture2 = 
  texture {
    pigment { Red }
    finish {
      ambient 0.01
      diffuse 2
      reflection 0
      brilliance 8
      specular 0.1
      roughness 0.1
    }
  };

// draw an edge ----------------------------------------------------------------
#macro Edge(verts, v1, v2, theta, phi, xi, Tex)
  #local P = verts[v1];
  #local Q = verts[v2];
  #local PQ = sphericalSegment(P, Q, 100);
  sphere_sweep {
    b_spline 101
    #for(k,0,100)
      #local O = StereographicProjection(rotate4d(theta,phi,xi,PQ[k]));
      O vlength(O)/20
    #end
    texture { 
        Tex
    }
  }
#end

// draw ------------------------------------------------------------------------
#declare theta = pi/2;
#declare phi = 0;
#declare xi = 2*frame_number*pi/180;
#declare vsFacet = ProjectedFacetVertices(theta, phi, xi);
#declare vsOther = ProjectedOtherVertices(theta, phi, xi);
object {
  union {
    #for(i, 0, 53)
      Edge(vertices, otherEdges[i][0], otherEdges[i][1], 
                            theta, phi, xi, edgeTexture1)
    #end
    #for(i, 0, 17)
      Edge(vertices, facetEdges[i][0], facetEdges[i][1], 
                            theta, phi, xi, edgeTexture2)
    #end
    #for(i, 0, 23)
      sphere {
        vsOther[i], vlength(vsOther[i])/10
        texture { edgeTexture1 }
      }
    #end  
    #for(i, 0, 11)
      sphere {
        vsFacet[i], vlength(vsFacet[i])/10
        texture { edgeTexture2 }
      }
    #end  
  }
  scale 0.5
  rotate <60, 0, 0>
  translate <0, 0.5, -2>
}
```

![](./figures/DuoprismStereo_POVRAY2.gif)
