#' Parse R code for required packages
#'
#' Parses an R or R Markdown file for the package names that would be required to run the code.
#'
#' @param fl file to parse for required package names
#'
#' @return a vector of package names as character strings
#' @export
#' @seealso \code{\link{install_package_guess}}, \code{\link{automagic}}
#'
#' @details This function uses regular expressions to search through a file
#'   containing R code to find required package names.  It extracts not only
#'   package names denoted by \code{\link[base]{library}} and \code{\link[base]{require}}, but also
#'   packages not attached to the global namespace, but are still called with
#'   \code{\link[base]{::}} or \code{\link[base]{:::}}.
#'
#'   Because it relies on regular expressions, it assumes all packages adhere to
#'   the valid CRAN package name rules (contain only ASCII letters, numbers, and
#'   dot; have at least two characters and start with a letter and not end it a
#'   dot). Code is also tidying internally, making the code more predictable and
#'   easier to parse (removes comments, adds whitespace around operators, etc).
#'   R Markdown files are also supported by extracting only R code using
#'   \code{\link[knitr]{purl}}.
#'
#' @importFrom knitr purl
#' @importFrom formatR tidy_source
#'
#' @examples
#' cat('library(ggplot2)\n # library(curl)\n require(leaflet)\n CB::date_print()\n',file='temp.R')
#' parse_packages('temp.R')
#' unlink('temp.R')

parse_packages <- function(fl){

  if (grepl('.Rmd',fl,fixed=TRUE)) {
    tmp.file <- tempfile()
    knitr::purl(input=fl,output=tmp.file,quiet=TRUE)
    fl <- tmp.file
  }

  lns <- tryCatch(formatR::tidy_source(fl,comment=FALSE,blank=FALSE,arrow=TRUE,
                                brace.newline=TRUE,output=FALSE)$text.mask,
                  error=function(e) {
                    message(paste('Could not parse R code in:',fl))
                    message('Make sure you are specifying the right file name')
                    message('   and check for syntax errors')
                    message(paste0('-----\n',e,'\n-----'))
                  })

  if (is.null(lns)) stop('No parsed text available',call.=FALSE)

  lib.pkgs <- sapply(lns,function(x) regmatches(x,gregexpr('(?<=library\\().*?(?=\\))',x,perl=TRUE)))
  lib.pkgs <- unique(unlist(lib.pkgs))

  req.pkgs <- sapply(lns,function(x) regmatches(x,gregexpr('(?<=require\\().*?(?=\\))',x,perl=TRUE)))
  req.pkgs <- unique(unlist(req.pkgs))

  colon.pkgs <- sapply(lns,function(x) regmatches(x,gregexpr("[A-Za-z0-9\\.]*(?=:{2,3})",x,perl=TRUE)))
  colon.pkgs <- unique(unlist(colon.pkgs))

  # return character vector of unique package names (remove empty string)
  out <- c(lib.pkgs,req.pkgs,colon.pkgs)
  return(out[!out==''])
}
