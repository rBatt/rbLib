#' Add Polar Glyph
#' 
#' Convert data (time series) to polar coordinates, and add circular data as a point (glyph) at a reference point in a figure
#' 
#' @param x,y numeric coordinates to be converted into circular units
#' @param ctr_pt the point at which to add the glyph
#' @param rad_range numeric range (length 2) for the glyph starting and stopping locations around the circle, in units of radians; default is a full circle, with starting point at 3 o'clock;
#' @param g.cex numeric (positive value) multiplicative glyph expansion; glyph size is tied to character size, hence cex. Values above 1 increase circle radius.
#' @param col fill color for glyph
#' @param lwd line width for (semi-) circle outlining glyph perimeter at maximum value (radius)
#' @param lcol the color of the line outline the glyph
#' 
#' @details
#' The glyph represents a time series that is plotted with a filled color between the time series line and the x-axis, then that polygon is wrapped around a centroid (the reference point). 
#' 
#' The parameter \code{rad_range} controls how far around the centroid the glyph is wrapped, and the location of the start and end points. The values should be in increasing order, and the glyph is plotted in a counterclockwise direction. Use of this convention is not checked, and may produce surprising results if the radius range is not supplied accordingly.
#' 
#' @return Invisibly returns \code{NULL}
#' 
#' @seealso For another approach to adding miniaturized time series data to a specific location on a figure, see \code{\link{sparklines}}.
#' 
#' @examples
#' x <- sample(1:75, 50) #rnorm(50)
#' y <- cumsum(rnorm(50))[rank(x)] + x*0.05
#' ctr_pt <- c(x[30], y[30])
#' g.cex <- 0.75
#' col <- adjustcolor("blue", 0.5)
#' 
#' dev.new()
#' plot(x[order(x)],y[order(x)],type='l')
#' polarGlyph(x, y, ctr_pt, rad_range=c(0.5*pi,pi*1.5), g.cex=1, col=adjustcolor("red", 0.5), lwd=1, lcol="red")
#' polarGlyph(x, y, ctr_pt, rad_range=c(1.5*pi,pi*2.5), g.cex=1, col=adjustcolor("blue", 0.5), lwd=1, lcol='blue')
#' 
#' @export
polarGlyph <- function(x, y, ctr_pt, rad_range=c(0,2*pi), g.cex=1, col="black", lwd=1, lcol="black"){

	xo <- order(x)
	x <- x[xo]
	y <- y[xo]

	x <- x/max(x)
	x <- x - min(x)

	y <- y/max(y)
	y <- y - min(y)

	r <- y/max(y)#/10 #sqrt(x^2 + y^2)
	# phi <- x/max(x)*2*pi #atan2(y, x)
	rad_seq <- do.call('seq', c(as.list(rad_range),length.out=list(length(x))))
	phi <- x/max(x)*diff(range(rad_seq)) + rad_seq[1]

	yr <- diff(par()$usr[3:4])
	xr <- diff(par()$usr[1:2])
	cxy <- mean(par("cin"))/par("pin")*c(xr,yr)*g.cex #par("cxy") # par("cin")/par("pin")
	cx <- cxy[1]
	cy <- cxy[2] #[2]

	pol_x <- r * cos(phi) * cx
	pol_y <- r * sin(phi) * cy

	len <- length(pol_x)
	xc <- ctr_pt[1]
	yc <- ctr_pt[2]
	
	pseq <- do.call('seq', c(as.list(rad_range),length.out=list(100)))
	polygon(c(xc+pol_x, rep(xc,len)), c(yc+pol_y, rep(yc, len)), col=col, border=NA)
	lines(cos(pseq)*cx+xc, sin(pseq)*cy+yc, type='l', lwd=lwd, col=lcol)
	
	invisible(NULL)
}
