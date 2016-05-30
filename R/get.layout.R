#' @title Get matrix for figure layout
#' 
#' @description Get the matrix corresponding to the layout of panels in a figure, given relative widths of columns in that figure
#' 
#' @param nr number of rows in the figure
#' @param nc number of columns in the figure
#' @param ratios numeric vector with length equal to \code{nc} specifying relative widths of panels
#' @param return_r logical. if FALSE (default) a layout matrix is returned; otherwise returns a vector specifying same relative widths as \code{ratios}, but as integers.
#' 
#' @details 
#' Returns a matrix that can be supplied to \code{\link{layout}} to specify the arrangement and size of figure panels. Current version assumes that all rows will have equal height, but that columns may have variable width; however, \code{get.layout} can be called twice to generate the matrix specifying variable widths and heights (see examples), so long as all panels in a given row have the same height, and all panels in a given column have the same width. Also note that the ratios do not need to be integers - this feature makes it easy and fast to adjust figure layout.
#' 
#' @seealso See \code{\link{rbLib-package}} for package overview.
#' 
#' @examples
#' layout(get.layout(nr=3, nc=3, ratios=c(4.2, 3, 8.1)))
#' for(i in 1:9){plot(rnorm(5))}
#' 
#' # calling get.layout twice can allow you to specify
#' # variable widths and variable heights
#' c.h <- get.layout(nr=3, nc=3, ratios=c(4.2, 3, 8.1)) # from previous example
#' r.w <- get.layout(3, 3, c(1.5, 2, 2.5), TRUE) # integers of relative widths
#' layout.mat <- matrix(rep(c(c.h), rep(r.w, ncol(c.h))), ncol=ncol(c.h))
#' layout(layout.mat)
#' for(i in 1:9){plot(rnorm(5))}
#' 
#' @export
get.layout <- function(nr, nc, ratios, return_r=FALSE){
	requireNamespace("numbers", quietly = TRUE)
	stopifnot(nc>1)
	stopifnot(length(ratios)==nc)
	
	ratios2 <- ratios * prod(mapply(function(x)numbers::contFrac(x)$rat[2], ratios))
	r <- ratios2/numbers::mGCD(ratios2)
	
	if(return_r){return(r)}
	
	figs.in.prev.row <- (0:(nr-1))*nc # number of figures in the previous row of the layout matrix
	nc.layout <- sum(r) # number of columns in the layout matrix
	update.fig.count <- rep(figs.in.prev.row, each=nc.layout) # 
	
	v <- 1:nc
	v.in <- rep(v, r) + update.fig.count
	out <- matrix(v.in, nrow=nr, ncol=length(v.in)/nr, byrow=TRUE)
	
	return(out)
}