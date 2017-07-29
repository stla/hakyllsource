inertia <- function(x0=0, y0=0, a, b, r=1/5, l=0.25, d=3, s=0, w=NULL, cols="black", 
                    npoints=101, ...){
  if(length(cols==1)) cols <- rep(cols,3)
  # ellipse:
  f <- function(x) sqrt(round(b^2*(1-(x-x0)^2/a^2),14)) 
  curve(y0 + f(x), from=x0-a, to=x0-a*r, add=TRUE, n=npoints, col=cols[1], ...)
  curve(y0 + f(x), from=x0+a*r, to=x0+a, add=TRUE, n=npoints, col=cols[2], ...)
  curve(y0 - f(x), from=x0-a, to=x0+a, add=TRUE, n=npoints, col=cols[3], ...)
  # arrow:
  segments(x0-s, y0-b, x0-l, y0-b+l/d, col=cols[3], ...)
  segments(x0-s, y0-b, x0-l, y0-b-l/d, col=cols[3], ...)
  if(!is.null(w)){
    segments(x0-s+w, y0-b, x0-l, y0-b+l/d, col=cols[3], ...)
    segments(x0-s+w, y0-b, x0-l, y0-b-l/d, col=cols[3], ...)
  }
}
