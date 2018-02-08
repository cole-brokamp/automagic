#' Get system dependencies for R packages
#'
#' Calls the r-hub "sysreqs" API. Platform is currently hardcoded for Ubuntu
#' 16.04 (\code{linux-x86_64-debian-gcc})
#'
#' @param pkgs a character vector of package names
#'
#' @export
#' @importFrom magrittr %>%
#' @importFrom httr GET content

get_sysreqs <- function(pkgs){

  platform <- "linux-x86_64-debian-gcc"

  paste0('https://sysreqs.r-hub.io/pkg/',
         paste(pkgs, collapse= ','),
         '/',
         platform) %>%
    httr::GET() %>%
    httr::content(type = 'application/json', as = 'parsed')
}
