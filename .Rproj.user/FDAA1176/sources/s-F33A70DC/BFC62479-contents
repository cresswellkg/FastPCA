#' Function for plotting FastPCA objects
#'
#' @param PCA_ob Output from FastPCA. Required
#' @param PC1 Principal component that will be plotted on x-axis. Default is 1
#' @param PC2 Principal component that will be plotted on y-axis. Default is 2
#' @param label Parameter determining whether points should be labeled. Labels
#' are determined by the row names of the original object which are determined
#' by column names of the original data. Default is TRUE
#' @import ggplot2
#' @import magrittr
#' @return Plot of the two specified principal components
#' @export
#' @details Simple plotting function for FastPCA output. Takes the FastPCA
#' object and PCs of interest as input. Also supports labeling.
#' @examples
#' #Create a simulated matrix
#' x = matrix(runif(900,0,20), nrow = 30, ncol = 30)
#' #Get the first 10 PCs
#' PCs <- FastPCA(x, PCs = 10)

plotPCs = function(PCA_ob, PC1 = 1, PC2 = 2, label = TRUE) {

  if (!all(names(PCA_ob) %in% c("scores", "loadings"))) {
   stop("Please use object from FastPCA")
  }

  if (is.null(row.names(PCA_ob$loadings))) {
    PC_Frame = data.frame(PCA_ob$loadings[,PC1], PCA_ob$loadings[,PC2])
  } else {
  PC_Frame = data.frame(PCA_ob$loadings[,PC1], PCA_ob$loadings[,PC2],
                        label = row.names(PCA_ob$loadings))
  }

  PC_plot = ggplot2::ggplot(PC_Frame, ggplot2::aes(x = PC_Frame[,1], y = PC_Frame[,2])) +
    ggplot2::geom_point() + ggplot2::labs(x = paste0("PC ", PC1),
                                          y = paste0("PC ", PC2))

  if (label & (ncol(PC_Frame)==3)) {
    PC_plot  +
      ggplot2::geom_text(ggplot2::aes(label = PC_Frame$label), vjust = 1.5)
  } else {
    PC_plot
  }
}

