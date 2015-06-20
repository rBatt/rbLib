#' @title Push local files to a remote server
#'
#' @description \code{push} makes a remote copy of a new or updated local file(s)
#'
#' @param path Character string for path to be pushed, or path containing file to be pushed
#' @param remoteName Character string for remote server;
#' @param fileName Character string of file within \code{path} to be pushed. If \code{""}, all files in \code{path} are pushed
#'@param verbose logical. print extra output.
#'
#' @details
#'Works via ssh and rsync. Can push all files in a folder, or a specific file in the specified path. The only files that are altered remotely are those that a newer locally (or only present locally). Will not delete a remote file if it isn't already present locally, and will not overwrite a remote file if the local version is older (or absent). Does not change local files. Assumes local and remote file paths are identical.
#'
#' @seealso \code{\link{pull}} for the opposite process, \code{\link{run}} to run script remotely, and \code{\link{prp}} to push run pull. See \code{\link{rbLib-package}} for overview.
#'
#' @examples
#' \dontrun{
#'	path <- "./Documents/School&Work/NCEAS_UnderIce/core/scripts/analysis/"
#'	scriptName <- "reset.sim.R"
#'	remoteName="ryanb@@amphiprion.deenr.rutgers.edu"
#'	(push(path, remoteName, fileName=scriptName))
#' }
push <- function(path, remoteName, fileName="", verbose=FALSE){
	# from local, push script to remote
	path2 <- gsub("&", "\\\\&", path, perl=TRUE)
	
	rsync.cmd <- "rsync -azuP --stats "
	
	push.sh <- paste0(
		rsync.cmd,
		"\"",
		path,
		fileName,
		"\" ",
		remoteName,
		":\'",
		path2,
		"\'"
	)
	if(verbose){
		cat(push.sh, "\n")
		system(push.sh)
	}else{
		invisible(system(push.sh))
	}
}


#' Run a remote script remotely
#'
#' \code{run} runs an R script remotely
#'
#' @param scriptName Character string indicating the name of the script to be run
#' @param path Character string for path to script. Must end with a "/"
#' @param remoteName Character string for remote server in username@@place.edu format. See \code{run.remote} in the package \code{ssh.utils}
#' @param verbose logical. print extra output.
#'
#' @seealso \code{\link{pull}} for the pulling in remote files, \code{\link{push}} to push a local file to the remote server, and \code{\link{prp}} to push run pull. See \code{\link{rbLib-package}} for overview.
#'
#' @examples
#' \dontrun{
#'	path <- "./Documents/School&Work/NCEAS_UnderIce/core/scripts/analysis/"
#'	scriptName <- "reset.sim.R"
#'	remoteName="ryanb@@amphiprion.deenr.rutgers.edu"
#'	(run(scriptName, path, remoteName))
#' }
run <- function(scriptName, path, remoteName, verbose=FALSE){
	# if(require(ssh.utils)){
		# from remote, run script
		rr.cmd.cd <- paste0("cd \'", path, "\'")
		rr.cmd <- paste0("nohup R CMD BATCH ", scriptName, " &")
		blah <- run.remote(paste0(rr.cmd.cd, ";", rr.cmd), remote=remoteName)
	
		if(verbose){
			blah
		}else{
			invisible(blah)
		}
	# }else{
# 		print("Please install ssh.utils to run scripts remotely.")
# 	}
}


#' Pull remote files to local system
#'
#' \code{push} makes a local copy of a new or updated remote file(s)
#'
#' @param path Character string for path to be pulled, or path containing file to be pulled
#' @param remoteName Character string for remote server in username@@place.edu format. See \code{run.remote} in the package \code{ssh.utils}
#' @param fileName Character string of file within \code{path} to be pulled. If \code{""}, all files in \code{path} are pulled
#' @param verbose logical. print extra output.
#'
#' @seealso \code{\link{push}} for the opposite process, \code{\link{run}} to run script remotely, and \code{\link{prp}} to push run pull. See \code{\link{rbLib-package}} for overview.
#'
#' @examples
#' \dontrun{
#'	path <- "./Documents/School&Work/NCEAS_UnderIce/core/scripts/analysis/"
#'	scriptName <- "reset.sim.R"
#'	remoteName="ryanb@@amphiprion.deenr.rutgers.edu"
#'	(pull(path, remoteName, fileName=""))
#' }
pull <- function(path, remoteName, fileName="", verbose=FALSE){
	ss1 <- fileSnapshot(path, full.names=TRUE)
	# from local, pull files updated by script
	path2 <- gsub("&", "\\\\&", path, perl=TRUE)
	rsync.cmd <- "rsync -azuP --stats "
	
	pull.sh <- paste0(
		rsync.cmd,
		remoteName,
		":\'",
		path2,
		fileName,
		"\' \"",
		path,
		"\""
	)
	if(verbose){
		cat(pull.sh, "\n")
		system(pull.sh)
		ss2 <- fileSnapshot(path, full.names=TRUE)
		changedFiles(ss1, ss2)
	}else{
		invisible(system(pull.sh))
	}


}




#' Push, Run, then Pull
#'
#' \code{push} Push local updates to remote, run script remotely, then pull remote updates to local
#'
#' @param path Character string for path to be pulled, or path containing file to be pulled
#' @param scriptName Character string of the script to be run
#' @param remoteName Character string for remote server in username@@place.edu format. See \code{run.remote} in the package \code{ssh.utils}
#' @param verbose logical. print extra output.
#'
#' @seealso \code{\link{pull}} and \code{\link{push}} to sync files, and \code{\link{run}} to run script remotely.  See \code{\link{rbLib-package}} for overview.
#'
#' @examples
#' \dontrun{
#'	path <- "./Documents/School&Work/NCEAS_UnderIce/core/scripts/analysis/"
#'	scriptName <- "reset.sim.R"
#'	remoteName="ryanb@@amphiprion.deenr.rutgers.edu"
#'	prp(path, scriptName, remoteName, verbose=TRUE)
#' }
prp <- function(path, scriptName, remoteName, verbose=FALSE){	
	if(verbose){cat("pushing\n")}
	push(path, remoteName, fileName=scriptName, verbose=verbose)
	
	if(verbose){cat("running\n")}
	run(scriptName, path, remoteName, verbose=verbose)
	
	if(verbose){cat("pulling\n")}
	pull(path, remoteName, fileName="", verbose=verbose)
}
