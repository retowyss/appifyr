library(appifyr)
context("Extractors: Package Names")

test_that("extract_pkg_name extracts the package name", {
  expect_equal(extract_pkg_names("require(appifyr)"), "appifyr")
  expect_equal(extract_pkg_names("require(tidyverse)"), "tidyverse")
  expect_equal(extract_pkg_names("library(appifyr)"), "appifyr")
  expect_equal(extract_pkg_names("library(keras)"), "keras")
})


