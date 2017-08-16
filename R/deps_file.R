#' Make a package dependencies (\code{deps.yaml}) file
#'
#' This function parses R code for required packages using
#'  \code{\link{parse_packages}} and then queries the R package library to
#'  determine the exact source and version of each package to install.
#'  Currently, only CRAN and GitHub packages are supported.
#'  Install packages from the `deps.yaml` file using
#'  \code{\link{automagic}{install_deps_file}}
#'
#' @param directory directory containing R code to parse
#'
#' @export
#' @import magrittr
#' @seealso \code{\link{automagic}}
make_deps_file <- function(directory=getwd()) {
  pkg_names <- get_dependent_packages(directory) %>% unique()
  lapply(pkg_names,get_package_details) %>%
    yaml::as.yaml() %>%
    cat(file=file.path(directory,'deps.yaml'))
}


#' Install R packages from a package dependencies (\code{deps.yaml}) file
#'
#' Installs packages from GitHub and CRAN based on Sha1 key and version number
#' respectively, as defined in a \code{deps.yaml} file created by
#' \code{\link{make_deps_file}}
#'
#' @param directory directory containing \code{deps.yaml} file
#'
#' @export
#' @importFrom magrittr %>%
#' @importFrom dplyr filter
#' @importFrom dplyr select
#' @importFrom dplyr contains
#' @importFrom purrr pwalk
#' @importFrom purrr walk2
#' @seealso \code{\link{make_deps_file}}, \code{\link{automagic}}
install_deps_file <- function(directory=getwd()) {

  deps_file <- file.path(directory,'deps.yaml')
  if (! file.exists(deps_file)) stop('deps.yaml not found',call.=FALSE)

  deps <- yaml::yaml.load_file(deps_file) %>%
    dplyr::bind_rows()

  if ('GithubRepo' %in% names(deps)) {
    gh_deps <- deps %>% dplyr::filter(!is.na(GithubRepo))
    if (!nrow(gh_deps) == 0) {
      gh_deps <- gh_deps %>%
        dplyr::mutate(install_calls = paste0(GithubUsername,'/',GithubRepo,'@',GithubSHA1))
      remotes::install_github(gh_deps$install_calls)
    }
  }

  cran_deps <-  deps %>%dplyr::filter(Repository == 'CRAN')
  # install CRAN package given version number
  if (!nrow(cran_deps) == 0) {
    purrr::walk2(cran_deps$Package,cran_deps$Version,devtools::install_version,type='source')
  }
}
