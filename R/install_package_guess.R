#' Install latest version of package from CRAN
#'
#'   If a package is not available in the R library, attempt to install it
#'   from CRAN.  Unlike previous versions of automagic, if the packages is not available on CRAN,
#'   the function will return an error (instead of trying to install from GitHub).
#'   If R is running interactively, then the user will be prompted before installing.
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
#' @param pkg a character vector with the names of packages to install from CRAN
#' @param force_install install even if package is in library (warning! this
#'   could install a newer or older version of an already installed package)
#' @param prompt prompt the user to install a package (defaults to yes if the R session is interactive)
#'
#' @export
#'
install_package_guess <- function(pkg, force_install = FALSE, prompt = interactive()) {
    message("unlike earlier releases, the current version of automagic only supports installing 'best guess' packages from CRAN")
    cran_pkgs <- row.names(utils::available.packages())
    if (pkg %in% cran_pkgs) {
        remotes::install_cran(pkgs = pkg, force = force_install)
    } else {
        stop(pkg, 'not found on CRAN; cannot install it', call. = FALSE)
    }
}
