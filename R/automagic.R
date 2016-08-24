#' Automagically install all required R packages
#'
#' Searches a given directory for all R and R Markdown files, parses them for
#' required packages and attempts to install them from CRAN or GitHub.
#'
#' @param directory folder to search for R and Rmd files
#' @param ... other arguments to \code{\link[automagic]{install_package}},
#'   namely \code{force_install}
#'
#' @export
#' @seealso \code{\link{install_package}}, \code{\link{parse_packages}}
#'
#' @details Used for autosetup of an R programming environment. For example,
#'   when running an R script on a remote server, or distributing an R Shiny app to
#'   another user, or creating a Docker container to run R code.  Just add
#'   \code{automagic::automagic()} to the top of the R file.
#'
#' @examples
#' automagic()


automagic <- function(directory=getwd(),...) {
  fls <- list.files(path=directory,pattern='^.*\\.R$|^.*\\.Rmd$',
                    full.names=TRUE,recursive=TRUE,...)
  pkg_names <- sapply(fls,parse_packages)
  sapply(pkg_names,install_package,...)
}
