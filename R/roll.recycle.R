#' @title Rolling Window that Recycles
#' 
#' @description A rolling window that will recycle the elements at the start of the vector when the window extends past the end of the vector (and will keep looping through until output of desired length is achieved)
#' 
#' @param vec vector upon which to perform the rolling window
#' @param size integer length of the rolling window
#' @param n integer indicating the total number of windows to apply
#' @param by integer specifying how far the window should advance between applications
#' @param index logical, FALSE (default) returns the elements of \code{vec} subset by the window, TRUE returns the integers specifying the indices of \code{vec} in each window
#' 
#' @details 
#' The idea is to apply a rolling window to a sequence of values that are arranged circularly but are represented by a linear vector. Can be used for generating permutations that retain the original arrangement of its elements (when \code{size==length(vec) & size==n}). Can also reproduce the output of \code{\link{diag}}, although in this case \code{roll.recycle} is a little more than twice as slow, so when producing a matrix in which all non-diagonal elements are 0, just use \code{diag}. Was created to fill a matrix with a few values in a way that recycled the values within a column (if needed) and induced a frame shift across columns; the result was used in statistical simulations of time series.
#' 
#' @seealso See \code{\link{rbLib-package}} for package overview.
#' 
#' @examples
#' # Rolling window around a circle
#' roll.recycle(seq(20,360,by=20), 10, 10, by=2)
#' 
#' # Can create identity matrix
#' # Note that size and by
#' # can be interpreted as nrow and ncol
#' diag(1,10,6)
#' roll.recycle(c(1,rep(0,9)),10,6,-1)
#' 
#' # Recycle and shift position of parameters
#' params <- seq(0,1, by=0.25)
#' ts.length <- 20
#' n.sims <- 5
#' roll.recycle(params, ts.length, n.sims) 
#' 
#' @export
roll.recycle <- function(vec, size, n, by=1, index=FALSE){
	vec.length <- length(vec)
	vals <- (1:size + rep(seq(from=0, by=by, length.out=n), each=size))%%vec.length
	use.inds <- matrix(vals, nrow=size)
	use.inds[use.inds==0] <- vec.length
	if(index){
		use.inds
	}else{
		matrix(vec[use.inds], nrow=size)
	}
	
}