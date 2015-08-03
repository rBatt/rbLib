#' @title Append date-time to file string
#'
#' @description Add the date/time to a character string right before the file extension. Useful for adding the date to a default file name.
#'
#' @param x one or more character strings ending with an extension (see Details for definition of extension)
#'
#' @details 
#' The file extension is defined by the regular expression pattern \code{"(\\.[^.]+$)"}. I.e., the extension is defined as the final period and the character(s) that follow it (not including end of string etc). Note that \code{"test.csv .,"} will be recognized as havign an extension (".,"), whereas \code{"test.csv ."} will return an error.
#'
#' @seealso See \code{\link{rbLib-package}} for package overview.
#'
#' @examples
#' renameNow(c("test1.csv","test2.txt"))

renameNow <- function(x){
	stopifnot(grepl("(\\.[^.]+$)",x))
	datetime <- format.Date(Sys.time(), format="%Y-%m-%d_%H-%M-%S-%Z")
	gsub("(\\.[^.]+$)",paste0("_",datetime,"\\1"),x)
}