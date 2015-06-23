#' @title Sync files
#'
#' @description \code{sync} copies files from \code{a} to \code{b}, and from \code{b} to \code{a.} No deletions. 
#'
#' @param a path of one directory
#' @param b path of a second directory
#' @param exclude character vector of files or folders to exclude; paths are relative
#'
#' @details
#' Uses 2 consecutive calls to rsync, switch the order of the path arguments between the 2 calls. First time copies files from a to b, second time it copies files from b to a. Specifically, the command is \code{rsync -azuP --stats "a" "b"}, followed by \code{rsync -azuP --stats "b" "a"}. The \code{-a} is arhive mode (recursive, most file attributes), \code{-z} enables compression, \code{-u} only moves files that are new or updated, and \code{-P} prints progress. \code{--stats} prints more information. No files are ever deleted. I.e., the directories end up containing the most up-to-date files in both directories, and files previously only contained in one directory are simply copied to the other.
#'
#' @seealso \code{\link{mirror}} if the contens of a master directory should be copied to a backup directory, potentially deleting files in the backup that are not contained in the master. See \code{\link{rbLib-package}} for package overview.
#'
#' @note When syncing the contents of a directory, remember that it is important to include a forward slash (\code{/}) at the end of both paths \code{a} and \code{b}; omitting in the second will create an extra copy in the first. If slash omitted from both, the top level name will exist 3 times and include two replicates. This is just basic \code{rsync} syntax, but it is easy to forget.
#' @examples
#' \dontrun{
#' # I have a project in a folder called 'CyanoIso'
#' # I want two copies of this folder and its contents on my computer
#'	a <- "Documents/School&Work/WiscResearch/CyanoIso/"
#'	b <- "Dropbox/Cyanotopes/CyanoIso/" # omitting the last slash will create an extra copy of CyanoIso in a
#'  exclude <- c(".git", "Data")
#'	(sync(a, b, exclude))
#' }
sync <- function(a, b, exclude=""){
	# sync a and b	
	rsync.cmd0 <- "rsync -azuP --stats "
	
	exclude2 <- paste0("\'", exclude, "\'")
	ex <- paste0("--exclude ", exclude2, collapse=" ")
	rsync.cmd <- paste0(rsync.cmd0, ex, " ")
	
	a2b <- paste0(
		rsync.cmd,
		"\"", a, "\" ",
		"\"", b, "\""
	)
	
	b2a <- paste0(
		rsync.cmd,
		"\"", b, "\" ",
		"\"", a, "\""
	)
	
	system(a2b)
	system(b2a)
}




