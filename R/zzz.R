.onLoad <- function(libname = find.package('automagic'), pkgname = 'automagic') {
  # CRAN Note avoidance
  if(getRversion() >= "2.15.1")
    utils::globalVariables(c('GithubUsername','GithubRepo','GithubSHA1','Repository'))
  invisible()
}
