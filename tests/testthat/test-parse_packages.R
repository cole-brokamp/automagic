context("parse_packages")
test_that("Identifies packages correctly in .R files",{
  expect_equal(
    parse_packages("samples/simple.R"),
    c("stats","boot","methods","splines","tools", "MASS")
  )
})
