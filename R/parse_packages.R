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
#' @examples \dontrun{
#' cat('library(ggplot2)\n # library(curl)\n require(leaflet)\n CB::date_print()\n',file='temp.R')
#' parse_packages('temp.R')
#' unlink('temp.R')
#' }

parse_packages <- function(fl){
    lns <- get_lines(fl)
    rgxs <- list(library = '(?<=(library\\()|(library\\(["\']{1}))[[:alnum:]|.]+',
                 require = '(?<=(require\\()|(require\\(["\']{1}))[[:alnum:]|.]+',
                 colon = "[[:alnum:]|.]*(?=:{2,3})")

    found_pkgs <- purrr::map(rgxs, finder, lns = lns) %>% unlist() %>% unique()
    found_pkgs <- found_pkgs[! found_pkgs %in% c('', ' ')]
    return(found_pkgs)
}

finder <- function(rgx, lns) regmatches(lns, gregexpr(rgx, lns, perl = TRUE)) %>% unlist()

get_lines <- function(file_name) {
    if (grepl('.Rmd', file_name, fixed=TRUE)) {
        tmp.file <- tempfile()
        knitr::purl(input=file_name, output=tmp.file, quiet=TRUE)
        file_name <- tmp.file
    }
    lns <- tryCatch(formatR::tidy_source(file_name, comment = FALSE, blank = FALSE, arrow = TRUE,
                                         brace.newline = TRUE, output = FALSE)$text.mask,
                    error = function(e) {
                        message(paste('Could not parse R code in:', file_name))
                        message('   Make sure you are specifying the right file name')
                        message('   and check for syntax errors')
                        stop("", call. = FALSE)
                    })
    if (is.null(lns)) stop('No parsed text available', call. = FALSE)
    return(lns)
}
