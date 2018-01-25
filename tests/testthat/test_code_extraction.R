library(appifyr)
library(testthat)
context("Extractors")

test_that("extract_pkg_name extracts the package name", {
  # No quotes
  expect_equal(appifyr:::extract_pkg_names("require(foo)"), "foo")
  expect_equal(appifyr:::extract_pkg_names("library(foo)"), "foo")
  # Single quotes
  expect_equal(appifyr:::extract_pkg_names("require('bar')"), "bar")
  expect_equal(appifyr:::extract_pkg_names("library('bar')"), "bar")
  # Double quotes
  expect_equal(appifyr:::extract_pkg_names('require("baz")'), "baz")
  expect_equal(appifyr:::extract_pkg_names('library("baz")'), "baz")
})


test_that("extract_r_functions extracts r functions", {
  r_fun <- "\nfoo <- function(x) {\n  x\n}"
  expect_equal(appifyr:::extract_r_functions(r_fun), list(r_fun))
})

test_that("extract_r_functions extracts r functions", {
  expect_equal(appifyr:::extract_pkgs("library(foo)")[[1]], "library(foo)")
  expect_equal(appifyr:::extract_pkgs("require(foo)")[[2]], "require(foo)")
})
