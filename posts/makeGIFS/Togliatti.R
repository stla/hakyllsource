library(misc3d)
library(rgl)

f <- function(x,y,z){
  64*(x-1)*
    (x^4-4*x^3-10*x^2*y^2-4*x^2+16*x-20*x*y^2+5*y^4+16-20*y^2) - 
    5*sqrt(5-sqrt(5))*(2*z-sqrt(5-sqrt(5)))*(4*(x^2+y^2-z^2)+(1+3*sqrt(5)))^2
}

# make grid
nx <- 220L; ny <- 220L; nz <- 220L
x <- seq(-5, 5, length.out = nx) 
y <- seq(-5, 5, length.out = ny)
z <- seq(-4, 4, length.out = nz) 
G1 <- expand.grid(x = x, y = y, z = z)
voxel <- array(with(G1, f(x, y, z)), dim = c(nx, ny, nz))
surf <- 
  computeContour3d(voxel, maxvol = max(voxel), level = 0, x = x, y = y, z = z)
triangles <- makeTriangles(surf, smooth = TRUE)
# plot ####
open3d(windowRect = c(50, 50, 450, 450))
par3d(zoom = 0.9)
drawScene.rgl(triangles, add = TRUE, color = "yellowgreen")
# animation ####
movie3d(
  spin3d(axis = c(0, 0, 1), rpm = 15),
  duration = 4, fps = 15,
  movie = "Togliatti_box", dir = ".",
  convert = "convert -dispose previous -loop 0 -delay 1x%d %s*.png %s.%s",
  startTime = 1/60
)

################################################################################
mask <- array(with(G1, x^2+y^2+z^2 < 4.8^2), dim = c(nx, ny, nz))
surf <- computeContour3d(
  voxel, maxvol = max(voxel), level = 0, mask = mask, x = x, y = y, z = z
)
triangles <- makeTriangles(surf, smooth = TRUE)
# plot ####
open3d(windowRect = c(50, 50, 450, 450))
par3d(zoom = 0.9)
drawScene.rgl(triangles, add = TRUE, color = "orange")
# animation ####
movie3d(
  spin3d(axis = c(0, 0, 1), rpm = 15),
  duration = 4, fps = 15,
  movie = "Togliatti_mask", dir = ".",
  convert = "convert -dispose previous -loop 0 -delay 1x%d %s*.png %s.%s",
  startTime = 1/60
)


################################################################################
h <- function(ρ, θ, ϕ){
  x <- ρ * cos(θ) * sin(ϕ)
  y <- ρ * sin(θ) * sin(ϕ)
  z <- ρ * cos(ϕ)
  f(x, y, z)
}
nρ <- 300L; nθ <- 300L; nϕ <- 300L
ρ <- seq(0, 4.8, length.out = nρ) # ρ runs from 0 to the desired radius
θ <- seq(0, 2*pi, length.out = nθ)
ϕ <- seq(0, pi, length.out = nϕ) 
G2 <- expand.grid(ρ=ρ, θ=θ, ϕ=ϕ)
voxel <- array(with(G2, h(ρ, θ, ϕ)), dim = c(nρ, nθ, nϕ))
surf <- 
  computeContour3d(voxel, maxvol = max(voxel), level = 0, x = ρ, y = θ, z = ϕ)
surf <- t(apply(surf, 1L, function(ρθϕ){
  ρ <- ρθϕ[1L]; θ <- ρθϕ[2L]; ϕ <- ρθϕ[3L] 
  c(
    ρ * cos(θ) * sin(ϕ),
    ρ * sin(θ) * sin(ϕ),
    ρ * cos(ϕ)
  )
}))
# plot ####
open3d(windowRect = c(50, 50, 450, 450))
par3d(zoom = 0.9)
drawScene.rgl(makeTriangles(surf, smooth=TRUE), color = "violetred")
# animation ####
movie3d(
  spin3d(axis = c(0, 0, 1), rpm = 15),
  duration = 4, fps = 15,
  movie = "Togliatti_spherical", dir = ".",
  convert = "convert -dispose previous -loop 0 -delay 1x%d %s*.png %s.%s",
  startTime = 1/60
)


################################################################################
voxel <- array(with(G1, f(x, y, z)), dim = c(nx, ny, nz))
surf <- 
  computeContour3d(voxel, maxvol = max(voxel), level = 0, x = x, y = y, z = z)
triangles <- makeTriangles(surf)
mesh <- misc3d:::t2ve(triangles)
rglmesh <- tmesh3d(mesh$vb, mesh$ib, homogeneous = FALSE)
fn <- function(xyz) rowSums(xyz^2)
clippedmesh <- addNormals(clipMesh3d(
  rglmesh, fn, bound = 4.8^2, greater = FALSE
))
# plot ####
open3d(windowRect = c(50, 50, 450, 450))
par3d(zoom = 0.9)
shade3d(clippedmesh, color = "magenta")
# animation ####
movie3d(
  spin3d(axis = c(0, 0, 1), rpm = 15),
  duration = 4, fps = 15,
  movie = "Togliatti_clipped", dir = ".",
  convert = "convert -dispose previous -loop 0 -delay 1x%d %s*.png %s.%s",
  startTime = 1/60
)