context("get_package_details")

test_that("returns NULL if package is not installed",{
    expect_equal(
        get_package_details("package.that.not.here"),
        NULL
    )
})
