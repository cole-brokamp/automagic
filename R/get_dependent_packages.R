#' get packages required to run R code
#'
#' @details parses all R and Rmd files in a directory and uses \code{\link{parse_packages}}
#'     to find all R packages required for the code to run
#'
#' @param directory folder to search for R and Rmd files
#'
#' @return a vector of package names
#' @export
get_dependent_packages <- function(directory = getwd()) {
  fls <- list.files(path=directory,pattern='^.*\\.R$|^.*\\.Rmd$',
                    full.names=TRUE,recursive=TRUE,ignore.case=TRUE)
  fls <- fls[!grepl("renv", fls)]
  pkg_names <- unlist(sapply(fls,parse_packages))
  pkg_names <- unique(pkg_names)
  if (length(pkg_names)==0) {
    message('warning: no packages found in specified directory')
    return(invisible(NULL))
  }
  return(unname(pkg_names))
}
