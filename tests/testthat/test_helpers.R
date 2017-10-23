library(appify)
context("Helpers: Check Inputs")

test_that("check_inputs throws errors", {
  expect_error(check_inputs(rnorm, c("n", "sd", "q")))
  expect_error(check_inputs(rnorm, c("q")))
})

test_that("check_inputs is silent", {
  expect_silent(check_inputs(rnorm, c("n", "sd", "mean")))
})

context("Helpers: Create Id")

test_that("create_id id has correct length", {
  expect_equal(nchar(create_id()), 32)
  expect_equal(nchar(create_id(1)), 1)
  expect_equal(nchar(create_id(1337)), 1337)
})

context("Helpers: Ensure Id Postfix")

test_that("ensure_id_postfix throws error", {
  expect_error(ensure_id_postfix(""))
  expect_error(ensure_id_postfix(c(1, 2)))
})

test_that("ensure_id_postfix returns identity", {
  expect_equal(ensure_id_postfix("bar"), "bar")
  expect_equal(ensure_id_postfix("1"), "1")
  expect_equal(ensure_id_postfix(1), 1)
})

