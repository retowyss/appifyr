library(appifyr)

context("Arguments To JSON")
test_that("arg_to_json is character", {
  expect_type(arg_to_json("A", "42"), "character")
})
test_that("args_to_json is character", {
  expect_type(args_to_json(list("bar"), "1337"), "character")
})
test_that("args_to_json is equal to arg_to_json for single arg", {
  expect_equal(args_to_json(list("bar"), "1337"), args_to_json("bar", "1337"))
})

context("rplot")
test_that("rplot is character", {
  id <- "1337"
  json <- args_to_json(list("bar", "foo", "derp"), id)
  expect_type(rplot(id = id, rf = "rnorm", json = json), "character")
  expect_type(rplot(id = 5, rf = "rnorm", json = "n : 4"), "character")
})
