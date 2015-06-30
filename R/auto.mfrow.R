#' @title Space-efficient dimenions for figure panels
#'
#' @description When generating multipanel figures, automatically determines arguments to \code{par(mfrow=c(x,y))} that use space most efficiently, finding the balance between minimizing empty panels and achieving square panel dimensions.
#'
#' @param x numeric, the number of panels
#' @param tall logical, if FALSE (the default), non-square panel arrangements will have more columns than rows (e.g., \code{mfrow=c(2,3)}).
#'
#' @details 
#' \code{auto.mfrow} will often produce figures with "empty" panels - \code{auto.mfrow} does not (necessarily) find dimenions suitable for publication, as for prime numbers this would often lead to 1-by-X or X-by-1 dimensions that would run off the screen/ page when \code{x} was large, which \code{auto.mfrow} avoids by permitting ampty panels. The ideal balance between non-square panel dimenions and empty panels is subjective, but the dimensions are found by the values of \code{nr} and \code{nc} that minimize the following expression: \code{abs(sqrt(x)-(nr)) + abs(sqrt(x)-(nc)) + abs(nr*nc-x)}, with output switching between nr-by-nc and nc-by-nr depending on the value of \code{tall}).
#'
#' @seealso See \code{\link{rbLib-package}} for package overview.
#'
#' @examples
#' N <- 5
#' par(mfrow=auto.mfrow(N))
#' for(i in 1:N){plot(1:i)}
#'
#' # Example also showing number of panels given number of plots
#' panels <- c()
#' empty <- c()
#' for(i in 1:25){
#' 	panels[i] <- prod(auto.mfrow(i))
#' 	empty[i] <- panels[i] - i
#' }
#' par(mfrow=auto.mfrow(2, tall=TRUE), mar=c(2.5,2.5,0.25,0.25), mgp=c(1.15,0.25, 0), tcl=-0.15, ps=10)
#' plot(panels, xlab="Number of plots", ylab="number of panels")
#' abline(a=0,b=1)
#' plot(empty, xlab="Number of plots", ylab="number of empty panels", type="o")

auto.mfrow <- function(x, tall=FALSE){
	stopifnot(x>0)
	stopifnot(length(x)==1)
	
	if(x==1L){return(c(1,1))}
	
	ran <- 2:max(floor((x-1)/2),1)
	ran2 <- pmax(ceiling(x/(ran)),1)
	rem <- abs(x - ran2*ran)
	
	score <- abs(sqrt(x)-(ran)) + abs(sqrt(x)-(ran2)) + rem
	mf1 <- ran[which.min(score)]
	mf2 <- ran2[which.min(score)]
	
	return(sort(c(mf1, mf2), tall))
}