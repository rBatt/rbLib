#' Combine Multiple Files into a Single PDF
#' 
#' Uses GhostScript to combine multiple files into a single pdf
#' 
#' @param inputNames a character vector of files to combine; can include path
#' @param outputName the name of the merged pdf file
#' 
#' @details
#' Sets a few options, including the option to not rotate the images as they are combined. Only tested by me on OSX
#' 
#' @export
combine_pdf <- function(inputNames, outputName){
	
	
	iN <- paste(sapply(inputNames, path.expand), collapse=" ")
	cmd <- paste0("gs -dNOPAUSE -sDEVICE=pdfwrite -sOUTPUTFILE=", outputName, " -dBATCH -dAutoRotatePages=/None ", iN)
	
	system(cmd)	
}