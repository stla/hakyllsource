---
title: "Hopf Torus (1/3): the equatorial case"
author: "Stéphane Laurent"
date: "2018-05-01"
output:
  md_document:
    variant: markdown
    preserve_yaml: true
  html_document:
    keep_md: no
prettify: yes
linenums: yes
prettifycss: twitter-bootstrap
tags: R, graphics, rgl
highlighter: kate
---

---
author: Stéphane Laurent
date: '2018-05-01'
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
tags: 'R, graphics, rgl'
title: 'Hopf Torus (1/3): the equatorial case'
---

In this series of three articles, we will show how to construct *Hopf
tori*.

Hopf tori takes their origins in the Hopf map $S^3 \to S^2$ defined by
$$
H(p) = \begin{pmatrix}
2(p_2 p_4 - p_1 p_3) \\
2(p_1 p_4 + p_2 p_3) \\
p_1^2 + p_2^2 - p_3^2 - p_4^2 \\
\end{pmatrix}.
$$

Obviously, this map is not bijective. Its main property is that it sends
each great circle of $S^3$ to a same point of $S^2$. Thus, it has, say a
"pseudo-inverse" $H^{-1} \colon S^2 \times S^1 \to S^3$ defined by $$
H^{-1}(q,t) = \frac{1}{\sqrt{2(1+q_3)}} 
\begin{pmatrix} 
q_1 \cos t + q_2 \sin t \\
\sin t (1+q_3)  \\
\cos t (1+q_3)  \\
q_1 \sin t  - q_2 \cos t \\
\end{pmatrix}.
$$

Now let's introduce the stereographic projection: $$
Stereo \colon S^3 -> \mathbb{R}^3 \\
Stereo \, x = \frac{1}{1-x_4}(x_1, x_2, x_3).
$$

Then, we can draw a circle in $\mathbb{R}^3$ as follows:

-   take a point $q$ on $S^2$;

-   calculate the great circle on $S^3$ by applying $H^{-1}(q, S^1)$;

-   maps this great cirlce to $\mathbb{R}^3$ with the stereographic
    projection.

In this article, we will show what happens when we take for $q$ a point
on the equator on $S^2$. Below are the necessary R functions.

``` {.r}
hopfinverse <- function(q, t){ 
  1/sqrt(2*(1+q[3])) * c(q[1]*cos(t)+q[2]*sin(t),
                         sin(t)*(1+q[3]),
                         cos(t)*(1+q[3]),
                         q[1]*sin(t)-q[2]*cos(t)) 
}
stereog <- function(x){
  c(x[1], x[2], x[3])/(1-x[4])
}
```

This is the sphere with the equator:

![](figures/SphereWithEquator.png)

Each point of the equator is mapped to a circle, and the circles form a
torus:

``` {.r}
library(rgl)
view3d(45,45)
t_ <- seq(0, 2*pi, len=200)
phi <- 0
theta_ <- seq(0, 2*pi, len=300)
for(theta in theta_){
  circle4d <- sapply(t_, function(t){
    hopfinverse(c(cos(theta)*cos(phi), sin(theta)*cos(phi), sin(phi)), t)
  })
  circle3d <- t(apply(circle4d, 2, stereog))
  shade3d(cylinder3d(circle3d, radius=0.1), color="purple")
}
```

Indeed, we get a torus, made of circles:

<!-- ![](figures/hopftorus1.gif) -->
<!-- ![](figures/hopftorus1_anim.gif) -->
<div style="text-align:center">
<img src="./figures/hopftorus1.gif" style="float: left; width: 45%; margin-right: 1%; margin-bottom: 0.5em; border:3px solid pink">
<img src="figures/hopftorus1_anim.gif" style="float: left; width: 45%; margin-right: 1%; margin-bottom: 0.5em; border:3px solid pink">
<p style="clear: both;">
</div>
