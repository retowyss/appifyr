library(appifyr)

context("Arguments To JSON")

test_that("arg_to_json is character", {
  expect_type(appifyr:::arg_to_json("A", "42"), "character")
})

test_that("args_to_json is character", {
  expect_type(appifyr:::args_to_json(list("bar"), "1337"), "character")
})

test_that("args_to_json is equal to arg_to_json for single arg", {
  expect_equal(
    appifyr:::args_to_json(list("bar"), "1337"),
    appifyr:::args_to_json("bar", "1337")
  )
})

context("rplot")

test_that("rplot is character", {
  expect_type(
    appifyr:::rplot(id = 5, rf = "rnorm", json = "n : 4"),
    "character"
  )
  id <- "1337"
  json <- appifyr:::args_to_json(list("bar", "foo", "derp"), id)
  expect_type(
    appifyr:::rplot(id = id, rf = "rnorm", json = json),
    "character"
  )
})
