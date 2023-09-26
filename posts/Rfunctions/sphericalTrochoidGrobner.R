sphericalTrochoid <- function(t) {
  A <- cos(omega)
  B <- sin(omega)
  f <- 3*b - b*A + d*A*cos(3*t)
  cbind(
    f * cos(t) + d * sin(t)*sin(3*t),
    f * sin(t) - d * cos(t)*sin(3*t),
    B * (b - d*cos(3*t))
  )
}
# parameters
omega <- 1.4
b <- 5
d <- 10
# sampling
t_ <- seq(0, 2*pi, length.out = 360L)
stSample <- sphericalTrochoid(t_)
# we will plot the supporting sphere as well
a <- 3*b
h <- (b - a*cos(omega)) / sin(omega) # altitude of center 
R <- sqrt(a^2 + h^2 + d^2 - b^2)     # radius

library(rgl)
sphereMesh <- cgalMeshes::sphereMesh(z = h, r = R, iterations = 5L)
open3d(windowRect = 50 + c(0, 0, 512, 512), zoom = 0.7)
shade3d(sphereMesh, color = "yellow", alpha = 0.5, polygon_offset = 1)
lines3d(stSample, lwd = 3)

movie3d(
  spin3d(axis = c(0, 0, 1), rpm = 60),
  duration = 1, fps = 60,
  movie = "zzpic", dir = ".",
  convert = FALSE, webshot = FALSE,
  startTime = 1/60
)

library(gifski)
gifski(
  Sys.glob("zzpic*.png"),
  "sphericalTrochoid.gif",
  width = 512, height = 512,
  delay = 1/10
)
file.remove(Sys.glob("zzpic*.png"))

# giacR ####
library(giacR)

equations <- paste(
  "x = (3*b - b*A + d*A*cos3t)*cost + d*sint*sin3t",
  "y = (3*b - b*A + d*A*cos3t)*sint - d*cost*sin3t",
  "z = B*(b - d*cos3t)", 
  sep = ", "
)
relations <- paste(
  "A^2 + B^2 = 1", 
  "cost^2 + sint^2 = 1",
  "cos3t = 4*cost^3 - 3*cost", 
  "sin3t = (4*cost^2 - 1)*sint", 
  sep = ", "
)
variables <- "cost, sint, cos3t, sin3t"
constants <- "A, B, b, d"

giac <- Giac$new()
results <- giac$implicitization(equations, relations, variables, constants)
giac$close()
length(results)

( fxyz <- results[11L] )

# ####
library(rmarchingcubes)
A <- cos(omega)
B <- sin(omega)
f <- function(x, y, z) {
  eval(parse(text = fxyz))
}
n <- 300L
x_ <- y_ <- seq(-R*1.1, R*1.1, length.out = n)
z_ <- seq(h - R - 0.1, h + R + 0.1, length.out = n)
Grid <- expand.grid(X = x_, Y = y_, Z = z_)
voxel <- with(Grid, array(f(X, Y, Z), dim = c(n, n, n)))
surf <- contour3d(voxel, level = 0, x_, y_, z_)
mesh <- tmesh3d(
  vertices = t(surf$vertices),
  indices  = t(surf$triangles),
  normals  = surf$normals
)
# plot
open3d(windowRect = 50 + c(0, 0, 512, 512))
shade3d(mesh, color = "darkviolet")

movie3d(
  spin3d(axis = c(0, 0, 1), rpm = 60),
  duration = 1, fps = 60,
  movie = "zzpic", dir = ".",
  convert = FALSE, webshot = FALSE,
  startTime = 1/60
)

library(gifski)
gifski(
  Sys.glob("zzpic*.png"),
  "sphericalTrochoid_mesh.gif",
  width = 512, height = 512,
  delay = 1/8
)
file.remove(Sys.glob("zzpic*.png"))

# clip to cylinder
fn <- function(x, y, z) x*x + y*y
cmesh <- clipMesh3d(mesh, fn, bound = (R*1.1)^2, greater = FALSE)
# plot everything
open3d(windowRect = 50 + c(0, 0, 512, 512), zoom = 0.75)
shade3d(sphereMesh, color = "orange", alpha = 0.4, polygon_offset = 1)
shade3d(cmesh, color = "darkviolet", polygon_offset = 1)
lines3d(stSample, lwd = 3, color = "chartreuse")

movie3d(
  spin3d(axis = c(0, 0, 1), rpm = 20),
  duration = 1, fps = 120,
  movie = "zzpic", dir = ".",
  convert = FALSE, webshot = FALSE,
  startTime = 1/120
)

library(gifski)
gifski(
  Sys.glob("zzpic*.png"),
  "sphericalTrochoid_plotall.gif",
  width = 512, height = 512,
  delay = 1/15
)
file.remove(Sys.glob("zzpic*.png"))
