#' Install package from CRAN or GitHub
#'
#' @details If a package is not availble in the R library, attempt to install it
#'   from CRAN.  If not available on CRAN, attempt to install the package from
#'   GitHub based on the "best guess".
#'
#'   This function does not check package versions.  Specify
#'   \code{force_install=TRUE} to force installation of the package, updating it
#'   to the latest available version. Note that this function attempts to
#'   install its packages based on a best guess and is meant for use in
#'   automatically setting up an R programming environment. Do not use for
#'   installing packages if you have the option to install with other tools like
#'   \code{\link[utils]{install.packages}} or one of the various GitHub
#'   installers.
#'
#' @param pkg name of package to install
#' @param force_install install even if package is in library (warning! this
#'   could install a newer or older version of an already installed package)
#'
#' @export
#' @importFrom pacman p_iscran
#' @importFrom pacman p_library
#' @importFrom pacman p_version
#' @importFrom utils install.packages
#' @importFrom githubinstall gh_suggest
#' @importFrom githubinstall gh_install_packages
#'
#' @seealso \code{\link{parse_packages}}, \code{\link{automagic}}
#'
#' @examples
#' install_package('utils')
#'
install_package <- function(pkg,force_install=FALSE) {
  set_repo()
  if (!force_install & pkg %in% pacman::p_library()) {
    message(paste0(pkg,' already installed (version ',pacman::p_version(pkg),')'))
  } else if (pacman::p_iscran(pkg)) {
    message(paste0('installing ',pkg,' from CRAN...'))
    utils::install.packages(pkg,repos='https://cran.rstudio.com')
  } else {
    gh_guess <- githubinstall::gh_suggest(pkg)[1]
    message(paste0('installing ',pkg,' as ',gh_guess,' from GitHub...'))
    githubinstall::gh_install_packages(gh_guess,ask=FALSE,verbose=FALSE)
  }
}



