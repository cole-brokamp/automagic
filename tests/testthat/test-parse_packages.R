context("parse_packages")

test_that("Identifies packages correctly in .R files",{
  expect_equal(
    parse_packages("samples/Simple.R"),
    c("stats","boot","methods","splines","tools", "MASS", "xfun", "ggplot2", "dplyr", "shiny", "pacman", "sf")
  )
})

test_that("Identifies packages correctly in .Rmd files",{
  expect_equal(
    parse_packages("samples/Simple.Rmd"),
    c("stats","boot","methods","splines","tools", "MASS", "xfun", "ggplot2", "dplyr", "shiny", "pacman", "sf")
  )
})
