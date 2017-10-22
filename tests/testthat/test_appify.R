library(appify)
context("Check Inputs")

test_that("check_inputs throws errors", {
  expect_error(check_inputs(rnorm, c("n", "sd", "q")))
  expect_error(check_inputs(rnorm, c("q")))
})

test_that("check_inputs is silent", {
  expect_silent(check_inputs(rnorm, c("n", "sd", "mean")))
})

context("Create id")

test_that("create id has correct length", {
  expect_equal(nchar(create_id()), 32)
  expect_equal(nchar(create_id(1)), 1)
  expect_equal(nchar(create_id(1337)), 1337)
})

