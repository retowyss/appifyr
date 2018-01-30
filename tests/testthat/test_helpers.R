library(appifyr)

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
test_that("ensure_id_postfix produces 32 char id", {
  expect_equal(nchar(ensure_id_postfix(NULL)), 32)
})
test_that("ensure_id_postfix returns identity", {
  expect_equal(ensure_id_postfix("bar"), "bar")
  expect_equal(ensure_id_postfix("1"), "1")
  expect_equal(ensure_id_postfix(1), 1)
})

