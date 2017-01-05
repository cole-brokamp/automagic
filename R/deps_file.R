#' Make a .dependencies file
#'
#' @param directory directory containing R code to parse
#'
#' @export
#' @details This function parses R code and then queries the R package library to
#' determine the exact source and version of each package to install. Currently,
#' only CRAN and GitHub packages are supported using a version number and Sha1
#' key, respectively. Install packages from the .dependencies file using
#' \code{\link[automagic]{install_deps_file}}
#' @seealso \code{\link{automagic}}
make_deps_file <- function(directory=getwd()) {
  packrat::opts$snapshot.recommended.packages(TRUE, persist = FALSE)
  packrat::.snapshotImpl(project = directory,snapshot.sources=FALSE,verbose=FALSE,prompt=FALSE)
  file.rename(from=file.path(directory, 'packrat', 'packrat.lock'),
              to=file.path(directory,'.dependencies'))
  on.exit(unlink(file.path(directory,'packrat'),recursive=TRUE,force=TRUE))
}

#' Install R packages from a .dependencies file
#'
#' @param directory directory containing .dependencies file
#'
#' @export
#' @details Installs packages from GitHub and CRAN based on Sha1 key and version number
#' respectively, as defined in a .dependencies file created by
#' \code{\link[automagic]{make_deps_file}}
#' #' @seealso \code{\link{automagic}}
install_deps_file <- function(directory=getwd()) {
  set_repo()

  deps_file <- file.path(directory,'.dependencies')
  stopifnot(file.exists(deps_file))
  deps <- read.dcf(deps_file)
  deps <- as.data.frame(deps,stringsAsFactors = FALSE)

  gh_deps <-  dplyr::filter(deps,deps$Source == 'github')
  if (!nrow(gh_deps) == 0) {
    gh_deps$install_call <- with(gh_deps,paste0(GithubUsername,'/',GithubRepo,'@',Hash))
  }
  cran_deps <- dplyr::filter(deps,deps$Source == 'CRAN')
  cran_deps <- dplyr::select(cran_deps,-dplyr::contains('Git'))

  # install CRAN package given version number
  purrr::walk2(cran_deps$Package,cran_deps$Version,devtools::install_version,type='source')

  # install GitHub given Sha1 ref
  if (!nrow(gh_deps) == 0) {
    purrr::pwalk(list(repo=gh_deps$GithubRepo,
                      username=gh_deps$GithubUsername,
                      ref=gh_deps$GithubSha1),
                 devtools::install_github)
  }
}
