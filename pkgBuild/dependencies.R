
update_dependencies <- function(){
	devtools::use_package("graphics", type="Imports")
	devtools::use_package("grDevices", type="Imports")
	devtools::use_package("utils", type="Imports")
	
	devtools::use_package("numbers", type="Suggests")
	devtools::use_package("ssh.utils", type="Suggests")
}



