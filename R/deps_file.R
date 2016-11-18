#' Make a .dependencies file
#'
#' @param directory directory containing R code to parse
#'
#' @export
#'
#' This function parses R code and then queries the R package library to
#' determine the exact source and version of each package to install. Currently,
#' only CRAN and GitHub packages are supported using a version number and Sha1
#' key, respectively. Install packages from the .dependencies file using
#' \code{\link[automagic]{install_deps_file}}
make_deps_file <- function(directory=getwd()) {
  packrat::opts$snapshot.recommended.packages(TRUE, persist = FALSE)
  packrat::.snapshotImpl(project = directory,snapshot.sources=FALSE,verbose=FALSE,prompt=FALSE) %>%
    suppressMessages()
  file.rename(from=file.path(directory, 'packrat', 'packrat.lock'),
              to=file.path(directory,'.dependencies'))
  unlink(file.path(directory,'packrat'),recursive=TRUE,force=TRUE)
}

#' Install R packages from a .dependencies file
#'
#' @param directory directory containing .dependencies file
#'
#' @export
#'
#' Installs packages from GitHub and CRAN based on Sha1 key and version number
#' respectively, as defined in a .dependencies file created by
#' \code{\link[automagic]{make_deps_file}}
install_deps_file <- function(directory=getwd()) {
  set_repo()

  deps_file <- file.path(directory,'.dependencies')
  stopifnot(file.exists(deps_file))
  deps <- read.dcf(deps_file) %>%
    as.data.frame(stringsAsFactors = FALSE)

  gh_deps <- deps %>% filter(Source == 'github') %>%
    mutate(install_call = paste0(GithubUsername,'/',GithubRepo,'@',Hash))
  cran_deps <- deps %>% filter(Source == 'CRAN') %>%
    select(-contains('Git'))

  # install CRAN package given version number
  purrr::walk2(cran_deps$Package,cran_deps$Version,devtools::install_version,type='source')

  # install GitHub given Sha1 ref
  purrr::pwalk(list(repo=gh_deps$GithubRepo,
                    username=gh_deps$GithubUsername,
                    ref=gh_deps$GithubSha1),
               devtools::install_github)
}
