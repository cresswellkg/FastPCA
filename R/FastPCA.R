#' Fast PCA for large matrices
#'
#' PCA algorithm designed to run fast and scale well to large matrices
#'
#' @import PRIMME
#' @import coop
#' @param orig_dat matrix or data frame containing uncenter and unscaled data
#' @param PCs Number of principal components to calculate. Default is 2 and the
#' maximum is the number of columns of the input data.
#' @param cor Logical determining whether the covariance matrix or correlation
#' matrix should be used for calculating PCs. Default is FALSE meaning covariance.
#' TRUE indicates correlation
#' @param precomp Logical indicating whether to the raw input matrix should be
#' used for PCA. If TRUE, cor is ignored. Default is FALSE
#' @return \item{scores}{Principal component scores for each PC}
#' @return \item{loadings}{ Component loadings}
#' @export
#' @details FastPCA is a simple function for performing PCA that has been
#' optimized for speed. FastPCA takes advantage of the PRIMME eigensolver which
#' allows for faster eigendecomposition than the base R eigen() function.
#' Additionally, we use optimized correlation and covariance functions from
#' coop to greatly increase overall speed compared to the base R functions.
#' This function does not use approximations so all results are identical to
#' those returned from stats::prcomp
#' @examples
#' #Create a simulated matrix
#' x = matrix(runif(900,0,20), nrow = 30, ncol = 30)
#' #Get the first 10 PCs
#' PCs <- FastPCA(x, PCs = 10)


FastPCA = function(orig_dat, PCs = 2, cor = FALSE, precomp = FALSE) {

  #Center and scale
  cent_mat = orig_dat - rep(1, nrow(orig_dat)) %*% t(colMeans(orig_dat))

  #Calculate covariance, correlation or neither depending on inputs
  if (precomp == TRUE) {
    relat = cent_mat
  } else if ((cor == TRUE) & (precomp == FALSE)) {
    relat = coop::pcor(cent_mat)
  } else {
    relat = coop::covar(cent_mat)
  }

  #Get appropriate number of eigenvectors
  eig_vals = PRIMME::eigs_sym(relat, PCs)

  #Pull out eigenvectors
  loadings = eig_vals$vectors

  #Name column based on PC
  colnames(loadings) = paste0("Comp ", 1:ncol(loadings))

  #Check for column names and label rows when necessary
  if (!is.null(colnames(orig_dat)))
  row.names(loadings) = colnames(orig_dat)

  #Get scores
  scores = t((t(eig_vals$vectors)%*%t(cent_mat)))
  return(list(scores = scores, loadings = loadings))
}

