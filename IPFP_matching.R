################################################################################
####         the IPFP algorithm for the Choo-Siow 2006 model                ####
################################################################################


################################################################################
####     muopt = solveipfp(phi, nx, my tol=1e-6)                            ####
####        phi: (n, m) matrix of joint surpluses                           ####
####           [assumes 0 for singles]                                      ####
####        nx: size n vector of margins for men                            ####
####        my: size m vector of margins for women                          ####
####        tol: we stop when iterations differ by less than tol            ####
################################################################################


################################################################################
####      the algorithm works with tx and ty, the square roots              ####
####       of mu(x, 0) and mu(0, y)                                         ####
################################################################################


################################################################################
####    one IPFP step: updates (tx, ty) given z=exp(Phi/2) and margins      ####
################################################################################

compz <- function(phi) {
  z <- exp(phi * 0.5)
  ## we return
  z
}


ipfpiter <- function(txy, z, nx, my) {
  tz <- t(z)
  tx <- txy[[1]]
  lx <- crossprod(z, tx)
  ty1 <- (sqrt(lx * lx + 4* my) - lx) * 0.5
  ly1 <- crossprod(tz, ty1)
  tx1 <- (sqrt(ly1 * ly1 + 4 * nx) - ly1) * 0.5
  ## we return
  list(tx1, ty1)
}

################################################################################
####           Euclidean distance between two iterations                    ####
####              is used as a test of convergence                          ####
####               could be replaced with another test                      ####
################################################################################


distxy <- function(txy1, txy, nx, my) {
  tx1 <- txy1[[1]]
  tx <- txy[[1]]
  ty1 <- txy1[[2]]
  ty <- txy[[2]]
  distx2 <- sum(nx * (tx - tx1) * (tx - tx1))
  disty2 <- sum(my * (ty - ty1) * (ty - ty1))
  ## we return
  sqrt(distx2 + disty2)
}



################################################################################
####   main program: solves IPFP for given phi and margins (nx, my)         ####
################################################################################

solveipfp <- function(phi, nx, my, tol=1e-6) {
  n <- NROW(phi)
  m <- NCOL(phi)
  z <- compz(phi)
  sumz <- sum(z)
  nIndivs <- sum(nx) + sum(my)
  bigc <- sqrt(nIndivs/(2.0 * sumz + n + m))
  ## initialize tx = sqrt(mux0) and ty = sqrt(mu0y)
  tx <- bigc + numeric(n)
  ty <- bigc + numeric(m)
  txy <- list(tx, ty)
  ## iterate
  diter <- +Inf
  niter <- 0
  while (diter > tol) {
    txy1 <- ipfpiter(txy, z, nx, my)
    diter <- distxy(txy1, txy, nx, my)
    niter <- niter + 1
    txy <- txy1
  }
  tx <- as.vector(txy[[1]])
  ty <-  as.vector(txy[[2]])
  ## the following applies the Choo and Siow matching formula
  muXY <- (tx %o% ty) * z
  muX0 <- nx - rowSums(muXY)
  mu0Y <- my - colSums(muXY)
  ## we return
  list(muXY, muX0, mu0Y)
}

