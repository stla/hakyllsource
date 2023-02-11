---
title: "The plasma effect: correction"
author: "Stéphane Laurent"
date: '2023-02-11'
tags: R, graphics
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

There's a kind of error in [the previous
post](https://laustep.github.io/stlahblog/posts/plasmaFourier.html). In
this formula: $$
\exp\Bigl(-\frac{{(i/n-0.5)}^2 + {(j/n-0.5)}^2}{0.025^2} \Bigr),
$$ the indices $i$ and $j$ should range from $0$ to $n$, and $n$ must be
even in order to get something centered. See the corrected code for
details:

``` r
fplasma4 <- function(n = 400L, gaussianMean = -50, gaussianSD = 5) {
  n <- n + 1L
  M <- matrix(
    rnorm(n*n, gaussianMean, gaussianSD), 
    nrow = n, ncol = n
  )
  FT <- dft(M)
  n <- n - 1L
  for(i in seq(n+1L)) {
    for(j in seq(n+1L)) {
      FT[i, j] <- FT[i, j] * 
        exp(-(((i-1L)/n - 0.5)^2 + ((j-1L)/n - 0.5)^2) / 0.025^2)
    }
  }
  IFT <- dft(FT, inverse = TRUE)
  colorMap1(IFT, reverse = c(FALSE, FALSE, TRUE))
}
```

The funny point is that the result is more interesting with the "error".
But it is not bad without it:

![](./figures/plasmaFourier_fixed.gif)
