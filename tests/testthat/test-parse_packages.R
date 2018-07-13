context("parse_paackages")
test_that("parse_packages identifies packages correctly",{
  expect_equal(
    parse_packages("samples/simple.R"),
    c("stats","boot","methods","tools")
  )
})
