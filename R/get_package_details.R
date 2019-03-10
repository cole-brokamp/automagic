#' get package details
#'
#' Uses \code{packageDescription} to get details about given package from R library on local machine.
#' Currently only supports CRAN and GitHub packages
#'
#' @param pkg_name package name
#'
#' @return A list of package characteristics.
#'   "Package", "Repository", and "Version" for CRAN packages.
#'   "Package", "GithubUsername", "GithubRepo", "GithubRef", and "GithubSHA1" for Github packages.
#' @importFrom utils packageDescription
#' @export

get_package_details <- function(pkg_name) {
  if (!requireNamespace(pkg_name, quietly = TRUE)){
      warning('skipping ', pkg_name, ' because it is not installed')
      return(invisible(NULL))
  }
  pkg_d <- packageDescription(pkg_name)
  is.cran <- !is.null(pkg_d$Repository) && pkg_d$Repository == 'CRAN'
  is.github <- !is.null(pkg_d$GithubRepo)
  is.base <- !is.null(pkg_d$Priority) && pkg_d$Priority == 'base'
  if (!is.cran & !is.github & !is.base) stop('CRAN or GitHub info for ',pkg_name,
  ' not found. Other packages repos are not supported.',
  call.=FALSE)
  if (is.cran) return(pkg_d[c('Package','Repository','Version')])
  if (is.github) return(pkg_d[c('Package','GithubUsername','GithubRepo','GithubRef','GithubSHA1')])
}

