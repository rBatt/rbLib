#' rbLib: Ryan's convenient R functions
#' 
#' The rbLib package is a collection of functions that I've written for specific projects, but which have applications that extend beyond the project that motivated their creation. They may be useful for generic tasks like transferring files, manipulating data, and plotting.
#' 
#' @section Syncing and Running R Scripts Remotely:
#' Note that these scripts were written specifically for the case where the local system is running OSX, and the remote is Linux. For the ssh to work, you have to already have a key so that you don't need to enter a password. See \href{http://www.thegeekstuff.com/2008/11/3-steps-to-perform-ssh-login-without-password-using-ssh-keygen-ssh-copy-id/}{HERE} for how to do that.
#' \tabular{ll}{
	#' \code{\link{pull}} \tab to pull from server \cr
	#' \code{\link{push}} \tab to push to server \cr
	#' \code{\link{run}} \tab to run script on server \cr
	#' \code{\link{prp}} \tab to push to a server, then run script there, then pull from it \cr
#' }
#' 
#' @section Generic Syncing:
#' \tabular{ll}{
	#' \code{\link{sync}} \tab similar to a \code{\link{push}} followed by a \code{\link{pull}}, except more generic in that it doesn't assume one location is remote, the two locations don't need to have same path (necessary if both are local), and includes option to exclude certain directories/ files. Never deletes files. \cr
	#' \code{\link{mirror}} \tab like \code{\link{sync}}, but unidirectional and deletes files at the destination that are not present in the source. \cr
#' }
#' 
#' @section Graphics:
#' Convenient functions for making graphs. Relies heavily on base graphics. Some functions focus on a particular aesthetic, others on creating a full figure.
#' \tabular{ll}{
	#' \code{\link{add.alpha}} \tab add transparency to a color \cr
	#' \code{\link{auto.mfrow}} \tab automatically arrange panels in a figure \cr
	#' \code{\link{mapLegend}} \tab add a color scale legend to a figure \cr
	#' \code{\link{combine_pdf}} \tab combine multiple pdf files into a single pdf, pages independently sized \cr
	#' \code{\link{get.layout}} \tab define \code{\link{layout}} matrix from dimensions and relative widths \cr
	#' \code{\link{polarGlyph}} \tab convert x-y data into polar coordinates, add circular glyph to figure \cr
	#' \code{\link{sparklines}} \tab add miniature time series at reference point in larger figure \cr
	#' \code{\link{zCol}} \tab get colors from values \cr
#' }
#' 
#' @section Data Manipulation:
#' Basic data manipulation tools
#' \tabular{ll}{
	#' \code{\link{roll.recycle}} \tab a rolling window that picks up at the beginning when it reaches the end \cr
	#' \code{\link{renameNow}} \tab add current date-time to a character corresponding to a file name \cr
#' 	}
#' 
#' @docType package
#' @name rbLib
NULL