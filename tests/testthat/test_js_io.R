library(appify)
context("JS Input Output")

test_that("js_rplot runs and returns list", {
  expect_type(
    js_rplot(
      canvas = "A",
      button = "B",
      f_name = "foo",
      args = list(A = "a_bar", B = "b_bar")
    ),
    "list"
  )
  expect_type(
    js_rplot(
      canvas = "canvas",
      button = "button",
      f_name = "f_name",
      args = list(arg1 = "arg1", arg2 = "arg2", arg3 = 3)
    ),
    "list"
  )
})
