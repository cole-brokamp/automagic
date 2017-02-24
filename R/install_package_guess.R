#' Install package from CRAN or GitHub based on best guess
#'
#'   If a package is not availble in the R library, attempt to install it
#'   from CRAN.  If not available on CRAN, attempt to install the package from
#'   GitHub based on the "best guess". If R is running interactively, then
#'   the user will be prompted before installing GitHub packages.
#'
#'   @details This function does not check package versions.  Specify
#'     \code{force_install=TRUE} to force installation of the package, updating it
#'     to the latest available version. Note that this function attempts to
#'     install its packages based on a best guess and is meant for use in
#'     automatically setting up an R programming environment. Do not use for
#'     installing packages if you have the option to install from a \code{deps.yaml} file.
#'     See \code{\link{make_deps_file}} and \code{\link{install_deps_file}} for
#'     installing version specific packages based on a local R library.
#'
#' @param pkg name of package to install
#' @param force_install install even if package is in library (warning! this
#'   could install a newer or older version of an already installed package)
#' @param prompt prompt the user to install a GitHub package (defaults to yes if the R session is interactive)
#'
#' @export
#' @importFrom pacman p_iscran
#' @importFrom pacman p_library
#' @importFrom pacman p_version
#' @importFrom utils install.packages
#' @importFrom githubinstall gh_suggest
#' @importFrom githubinstall gh_install_packages
#'
install_package_guess <- function(pkg,force_install=FALSE,prompt=interactive()) {
  set_repo()
  if (!force_install & pkg %in% pacman::p_library()) {
    message(paste0(pkg,' already installed (version ',pacman::p_version(pkg),')'))
  } else if (pacman::p_iscran(pkg)) {
    message('installing ',pkg,' from CRAN...')
    utils::install.packages(pkg)
  } else {
    message(pkg,' not found on CRAN. Searching on GitHub')
    githubinstall::gh_install_packages(pkg,ask=prompt,verbose=FALSE)
  }
}



set_repo <- function() {
  r <- getOption("repos")
  r["CRAN"] <- "https://cran.rstudio.com"
  options(repos=r)
}
