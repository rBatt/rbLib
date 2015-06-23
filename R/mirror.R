#' @title Create mirror of a directory (copy)
#'
#' @description \code{mirror} copies files from \code{from} to \code{to}, deleting any files in \code{to} that are not present in \code{from}. 
#'
#' @param from path of source directory
#' @param to path of destination directory
#' @param exclude character vector of files or folders to exclude; paths are relative
#'
#' @details
#' Uses rsync. Essentially creates a copy of \code{from} at \code{to}.
#'
#' @seealso See \code{\link{sync}} for bidirectional copying w/o deletions (syncing). See \code{\link{rbLib-package}} for package overview.
#'
#' @ note When syncing the contents of a directory, remember that it is important to include a forward slash (\code{/}) at the end of both paths \code{a} and \code{b}; omitting in the second will create an extra copy in the first. If slash omitted from both, the top level name will exist 3 times and include two replicates. This is just basic \code{rsync} syntax, but it is easy to forget.
#' @examples
#' \dontrun{
#' # I have a project in a folder called 'CyanoIso'
#' # I want two copies of this folder and its contents on my computer
#'	from <- "Documents/School&Work/WiscResearch/CyanoIso/"
#'	to <- "Dropbox/Cyanotopes/CyanoIso/" # omitting the last slash will create an extra copy of CyanoIso in from
#'  exclude <- c(".git", "Data")
#'	(mirror(from, to, exclude))
#' }
mirror <- function(from, to, exclude=""){
	# sync a and b	
	rsync.cmd0 <- "rsync -azuP --stats "
	
	exclude2 <- paste0("\'", exclude, "\'")
	ex <- paste0("--exclude ", exclude2, collapse=" ")
	rsync.cmd <- paste0(rsync.cmd0, ex, " ")
	
	from.to <- paste0(
		rsync.cmd,
		"\"", from, "\" ",
		"\"", to, "\""
	)
	
	system(from.to)
}