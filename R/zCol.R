#' Z Color
#' 
#' Get colors based on values
#' 
#' @param nCols number of colors
#' @param Z numeric vector to determine color
#' 
#' @return
#' a vector of colors
#' 
#' @export
zCol <- function(nCols, Z){
	cols <- grDevices::colorRampPalette(c("#000099", "#00FEFF", "#45FE4F", "#FCFF00", "#FF9400", "#FF3100"))(nCols)
	colVec_ind <- cut(Z, breaks=nCols)
	colVec <- cols[colVec_ind]
	return(colVec)
}