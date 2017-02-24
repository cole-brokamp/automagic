#' Automagically install all required R packages
#'
#' Searches a given directory for all R and R Markdown files, parses them for
#' required packages and attempts to install them from CRAN or GitHub. More importantly,
#' if a `deps.yaml` file was made using \code{\link{make_deps_file}}, automagic
#' will use this rather than try to install based on a best guess.
#'
#' @param directory folder to search for R and Rmd files
#'
#' @export
#' @seealso \code{\link{install_package_guess}}, \code{\link{parse_packages}}



automagic <- function(directory=getwd()) {
  if (file.exists(file.path(directory,'deps.yaml'))) {
    message('\n\ninstalling from deps.yaml file at\n',
            paste0(file.path(directory,'deps.yaml')),'\n\n')
    automagic::install_deps_file(directory=directory)
  } else {
    message('no deps.yaml file found in specified directory')
    message('parsing code and installing packages based on best guess')
    pkgs <- get_dependent_packages(directory)
    sapply(pkgs,install_package_guess)
  }
}
