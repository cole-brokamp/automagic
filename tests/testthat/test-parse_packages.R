context("parse_packages")

test_that("Identifies packages correctly in .R files",{
  expect_equal(
    parse_packages("samples/Simple.R"),
    paste0('pkg', 1:11)
  )
})

test_that("Errors for non-exisiting R file",{
    expect_error(parse_packages("samples/not_here.R"))
})
