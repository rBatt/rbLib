#' @title Push local files to a remote server
#'
#' @description \code{push} makes a remote copy of a new or updated local file(s)
#'
#' @param path Character string for path to be pushed, or path containing file to be pushed. If \code{path2} is specified, \code{path} refers only to local source path.
#' @param remoteName Character string for remote server;
#' @param fileName Character string of file within \code{path} to be pushed. If \code{""}, all files in \code{path} are pushed
#'@param verbose logical. print extra output.
#'@param path2 remote destination path; if blank, \code{path2} is the remote equivalent of \code{path}
#'
#' @details
#'Works via ssh and rsync. Can push all files in a folder, or a specific file in the specified path. The only files that are altered remotely are those that a newer locally (or only present locally). Will not delete a remote file if it isn't already present locally, and will not overwrite a remote file if the local version is older (or absent). Does not change local files. Assumes local and remote file paths are identical unless \code{path2} is specified.
#'
#' @seealso \code{\link{pull}} for the opposite process, \code{\link{run}} to run script remotely, and \code{\link{prp}} to push run pull. See \code{\link{rbLib-package}} for overview.
#'
#' @examples
#' \dontrun{
#' path <- "./Documents/School&Work/NCEAS_UnderIce/core/scripts/analysis/"
#' scriptName <- "reset.sim.R"
#' remoteName <- "ryanb@@amphiprion.deenr.rutgers.edu"
#' (push(path, remoteName, fileName=scriptName))
#' }
push <- function(path, remoteName, fileName="", verbose=FALSE, path2){
	# from local, push script to remote

	if(missing(path2)){
		path2 <- gsub("&", "\\\\&", path, perl=TRUE)
	}
	
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
#' @description \code{run} runs an R script remotely
#'
#' @param scriptName Character string indicating the name of the script to be run
#' @param path Character string for path to script. Must end with a "/"
#' @param remoteName Character string for remote server in username@@place.edu format. See \code{run.remote} in the package \code{ssh.utils}
#' @param verbose logical. print extra output.
#' @param debugMode logical. whether the run should load a file called '.RData' present in the directory, and if it should save a file (image) by the same name on exit.
#'
#' @seealso \code{\link{pull}} for the pulling in remote files, \code{\link{push}} to push a local file to the remote server, and \code{\link{prp}} to push run pull. See \code{\link{rbLib-package}} for overview.
#'
#' @examples
#' \dontrun{
#' path <- "./Documents/School&Work/NCEAS_UnderIce/core/scripts/analysis/"
#' scriptName <- "reset.sim.R"
#' remoteName <- "ryanb@@amphiprion.deenr.rutgers.edu"
#' (run(scriptName, path, remoteName))
#' }
run <- function(scriptName, path, remoteName, verbose=FALSE, debugMode=FALSE){
	# if(require(ssh.utils)){
		# from remote, run script
		rr.cmd.cd <- paste0("cd \'", path, "\'")
		if(debugMode){
			rr.cmd <- paste0("nohup R CMD BATCH ", scriptName, " &")
		}else{
			rr.cmd <- paste0("nohup R CMD BATCH --vanilla --no-save ", scriptName, " &")
		}
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
#' @description \code{pull} makes a local copy of a new or updated remote file(s)
#'
#' @param path Character string for path to be pulled, or path containing file to be pulled. If \code{path2} is specified, \code{path} refers only to the local destination.
#' @param remoteName Character string for remote server in username@@place.edu format. See \code{run.remote} in the package \code{ssh.utils}
#' @param fileName Character string of file within \code{path} to be pulled. If \code{""}, all files in \code{path} are pulled
#' @param verbose logical. print extra output.
#'@param path2 remote source path; if blank, \code{path2} is the remote equivalent of \code{path}
#'
#' @seealso \code{\link{push}} for the opposite process, \code{\link{run}} to run script remotely, and \code{\link{prp}} to push run pull. See \code{\link{rbLib-package}} for overview.
#'
#' @examples
#' \dontrun{
#' path <- "./Documents/School&Work/NCEAS_UnderIce/core/scripts/analysis/"
#' scriptName <- "reset.sim.R"
#' remoteName <- "ryanb@@amphiprion.deenr.rutgers.edu"
#' (pull(path, remoteName, fileName=""))
#' }
pull <- function(path, remoteName, fileName="", verbose=FALSE, path2){
	ss1 <- fileSnapshot(path, full.names=TRUE)
	# from local, pull files updated by script
	if(missing(path2)){
		path2 <- gsub("&", "\\\\&", path, perl=TRUE)
	}
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
#' @description \code{prp} pushes local updates to remote, runs script remotely, then pulls remote updates to local
#'
#' @param path Character string for path to be pulled, or path containing file to be pulled
#' @param scriptName Character string of the script to be run
#' @param remoteName Character string for remote server in username@@place.edu format. See \code{run.remote} in the package \code{ssh.utils}
#' @param verbose logical. print extra output.
#' @param debugMode logical. whether the run should load a file called '.RData' present in the directory, and if it should save a file (image) by the same name on exit.
#'@param path2 remote path; if blank, \code{path2} is the remote equivalent of \code{path}
#'
#' @seealso \code{\link{pull}} and \code{\link{push}} to sync files, and \code{\link{run}} to run script remotely.  See \code{\link{rbLib-package}} for overview.
#'
#' @examples
#' \dontrun{
#' path <- "./Documents/School&Work/NCEAS_UnderIce/core/scripts/analysis/"
#' scriptName <- "reset.sim.R"
#' remoteName <- "ryanb@@amphiprion.deenr.rutgers.edu"
#' prp(path, scriptName, remoteName, verbose=TRUE)
#' }
prp <- function(path, scriptName, remoteName, verbose=FALSE, debugMode=FALSE, path2){
	if(missing(path2)){
		path2 <- gsub("&", "\\\\&", path, perl=TRUE)
	}
		
	if(verbose){cat("pushing\n")}
	push(path, remoteName, fileName=scriptName, verbose=verbose, path2=path2)

	if(verbose){cat("running\n")}
	run(scriptName, path=path2, remoteName, verbose=verbose, debugMode=debugMode)
	
	if(verbose){cat("pulling\n")}
	pull(path, remoteName, fileName="", verbose=verbose, path2=path2)
}
