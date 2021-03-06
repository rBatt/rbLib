% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/prp.R
\name{pull}
\alias{pull}
\title{Pull remote files to local system}
\usage{
pull(path, remoteName, fileName = "", verbose = FALSE, path2)
}
\arguments{
\item{path}{Character string for path to be pulled, or path containing file to be pulled. If \code{path2} is specified, \code{path} refers only to the local destination.}

\item{remoteName}{Character string for remote server in username@place.edu format. See \code{run.remote} in the package \code{ssh.utils}}

\item{fileName}{Character string of file within \code{path} to be pulled. If \code{""}, all files in \code{path} are pulled}

\item{verbose}{logical. print extra output.}

\item{path2}{remote source path; if blank, \code{path2} is the remote equivalent of \code{path}}
}
\description{
\code{pull} makes a local copy of a new or updated remote file(s)
}
\examples{
\dontrun{
path <- "./Documents/School&Work/NCEAS_UnderIce/core/scripts/analysis/"
scriptName <- "reset.sim.R"
remoteName <- "ryanb@amphiprion.deenr.rutgers.edu"
(pull(path, remoteName, fileName=""))
}

}
\seealso{
\code{\link{push}} for the opposite process, \code{\link{run}} to run script remotely, and \code{\link{prp}} to push run pull. See \code{\link{rbLib-package}} for overview.
}

