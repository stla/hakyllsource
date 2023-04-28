---
title: "Fisheye effect with R"
author: "Stéphane Laurent"
date: '2023-04-29'
tags: R
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

The `fisheye` function below distorts a bitmap image with a [fisheye
effect](https://en.wikipedia.org/wiki/Fisheye_lens) or an anti-fisheye
effect (`rho > 0.5` or `rho < 0.5`).

``` r
fisheye_xy <- function(x, y, rho, stick) {
  p <- c(x, y)
  if(rho == 0.5) {
    return(p)
  }
  m <- c(0.5, 0.5)
  d <- p - m
  r <- sqrt(c(crossprod(d)))
  dnormalized <- d / r
  mnorm <- sqrt(c(crossprod(m)))
  power <- pi / mnorm * (rho - 0.5)
  if(power > 0) {
    bind <- if(stick == "corners") mnorm else m[2L]
    uv <- m + dnormalized * tan(r*power) * bind / tan(bind*power)
  } else {
    bind <- m[2L]
    uv <- m + dnormalized * atan(-10*r*power) * bind / atan(-10*bind*power)
  }
  uv
}

library(imager)
library(cooltools)
#' @importFrom imager load.image add.color squeeze R G B
#' @importFrom cooltools approxfun2
#' @importFrom grDevices col2rgb rgb
#' @param bitmapFile path to a bitmap file (jpg, png, ...)
#' @param rho amount of effect; no effect if 0.5, fisheye if >0.5, 
#'   antifisheye if <0.5
#' @param stick where to stick the image when rho>0.5, to the 
#'   corners or to the borders; if you stick to the corners, a 
#'   part of the image is lost
#' @param bkg background color; it appears only if rho>0.5 and 
#'   stick="borders" 
fisheye <- function(bitmapFile, rho, stick = "corners", bkg = "black") {
  stopifnot(rho > 0, rho < 1)
  stick <- match.arg(stick, c("borders", "corners"))
  # load the image
  img <- load.image(bitmapFile)
  dims <- dim(img)
  nx <- dims[1L]
  ny <- dims[2L]
  nchannels <- dims[4L]
  # if the image is gray, add colors
  if(nchannels == 1L) {
    img <- add.color(img)
  } else if(nchannels != 3L) {
    stop("Cannot process this image.")
  }
  # fisheye matrix
  PSI <- matrix(NA_complex_, nrow = nx, ncol = ny)
  for(i in 1L:nx) {
    x <- (i-1L) / (nx-1L)
    for(j in 1L:ny) {
      y <- (j-1L) / (ny-1L)
      uv <- fisheye_xy(x, y, rho, stick)
      PSI[i, j] <- complex(real = uv[1L], imaginary = uv[2L])
    }
  }
  # take the r, g, b channels
  r <- squeeze(R(img))
  g <- squeeze(G(img))
  b <- squeeze(B(img))
  # interpolation
  x_ <- seq(0, 1, length.out = nx)
  y_ <- seq(0, 1, length.out = ny)
  f_r <- approxfun2(x_, y_, r)
  f_g <- approxfun2(x_, y_, g)
  f_b <- approxfun2(x_, y_, b)
  M_r <- f_r(Re(PSI), Im(PSI))
  M_g <- f_g(Re(PSI), Im(PSI))
  M_b <- f_b(Re(PSI), Im(PSI))
  # set outside color
  RGB <- col2rgb(bkg)[, 1L] / 255
  M_r[is.na(M_r)] <- RGB[1L]
  M_g[is.na(M_g)] <- RGB[2L]
  M_b[is.na(M_b)] <- RGB[3L]
  # convert to hex codes
  rstr <- rgb(M_r, M_g, M_b)
  dim(rstr) <- c(nx, ny)
  # rotate
  t(rstr)
}
```

Let's take for example this picture of Dilbert, named
**dilbert512x512.png**:

![](./figures/dilbert512x512.png)

It has a transparent background. We firstly transform this background it
to a gray color (`#aaaaaa`) with the help of ImageMagick. The command to
do that is:

    convert in.png -background '#aaaaaa' -alpha remove -alpha off out.png

(`magick convert` if you use Windows).

We can run this command from R:

``` r
dilbert_transparent <- "dilbert512x512.png"
dilbert_gray        <- "dilbert_gray.png"
gray_color <- "#aaaaaa"
cmd <- sprintf(
  "convert %s -background '%s' -alpha remove -alpha off %s", 
  dilbert_transparent, gray_color, dilbert_gray
)
system(cmd)
```

Here is **dilbert_gray.png**:

![](./figures/dilbert_gray.png)

Now let's perform a fisheye distortion of this image with `rho=0.95`:

``` r
img <- fisheye(dilbert_gray, rho = 0.95, stick = "borders", bkg = gray_color)
# plot
opar <- par(mar = c(0, 0, 0, 0))
plot(c(-100, 100), c(-100, 100), type = "n", asp = 1, 
     xlab = NA, ylab = NA, axes = FALSE, xaxs = "i", yaxs = "i")
rasterImage(img, -100, -100, 100, 100)
par(opar)
```

![](./figures/dilbert_fisheye.png)

The anti-fisheye effect is obtained by setting `rho<0.5`. We will do it,
with something more: we will get a transparent background at the end.

To do so, first transform the transparent background to a color, for
example green (`#00ff00`):

``` r
dilbert_transparent  <- "dilbert512x512.png"
dilbert_green        <- "dilbert_green.png"
green_color <- "#00ff00"
cmd <- sprintf(
  "convert %s -background '%s' -alpha remove -alpha off %s", 
  dilbert_transparent, green_color, dilbert_green
)
system(cmd)
```

Here is **dilbert_green.png**:

![](./figures/dilbert_green.png)

Now perform the anti-fisheye effect, and use the same green color as
background:

``` r
img <- fisheye(dilbert_green, rho = 0.45, bkg = green_color)
# save image
png("dilbert_antifisheye_green.png", width = 512, height = 512)
opar <- par(mar = c(0, 0, 0, 0))
plot(c(-100, 100), c(-100, 100), type = "n", asp = 1, 
     xlab = NA, ylab = NA, axes = FALSE, xaxs = "i", yaxs = "i")
rasterImage(img, -100, -100, 100, 100)
par(opar)
dev.off()
```

Here is **dilbert_antifisheye_green.png**:

![](./figures/dilbert_antifisheye_green.png)

Finally, using ImageMagick, transform the green color to transparent:

``` r
cmd <- sprintf(
  "convert -fuzz 30% -transparent '%s' %s %s",
  green_color, "dilbert_antifisheye_green.png", "dilbert_antifisheye.png"
)
system(cmd)
```

![](./figures/dilbert_antifisheye.png)
