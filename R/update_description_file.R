#' add missing packages to package DESCRIPTION file
#'
#' @details uses \code{get_dependent_packages()} to find dependencies and
#' adds them to the description file with the desc package
#'
#' @param directory folder to search for R and Rmd files.
#' The DESCRIPTION file is expected to be in this directory.
#'
#' @export
update_description_file <- function(directory = getwd()) {
  description_file_path <- file.path(directory, "DESCRIPTION")
  # check if a descripton file is available
  if (!file.exists(description_file_path)) {
    stop("There is no DESCRIPTION file in this directory.")
  }
  # get dependent packages
  dependent_packages <- get_dependent_packages(directory)
  # get description object
  desc <- desc::description$new(description_file_path)
  # add packages to description object
  purrr::walk(
    .x = dependent_packages,
    .f = function(x, y) {
      y$set_dep(x)
    },
    desc
  )
  # write description object to file system
  desc$write(description_file_path)
}
