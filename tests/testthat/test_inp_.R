library(appifyr)
context("Text Form Group")

test_that("inp_text errors", {
  expect_error(inp_text(width = 42))
  expect_error(inp_text(width = 0))
  expect_error(inp_text(width = "A"))
})

test_that("inp_text correct", {
  expect_equal(
    inp_text(),
    list(fg = "text", label = NULL, width = 4, dots = list())
  )
  expect_equal(
    inp_text(width = 8),
    list(fg = "text", label = NULL, width = 8, dots = list())
  )
})

context("Dropdown Form Group")

test_that("inp_dropdown error on bad data.frame", {
  expect_error(inp_dropdown(data.frame(key = 1)))
  expect_error(inp_dropdown(data.frame(value = 1)))
})

test_that("inp_dropdown error on empty or unnamed list", {
  expect_error(inp_dropdown(list()))
  expect_error(inp_dropdown(list(1, a = 4)))
  expect_error(inp_dropdown(inp_dropdown))
})

test_that("inp_dropdown equivalent input definitions", {
  li <- list(a = 5, b = 6, c = 7)
  df <- data.frame(key = c("a", "b", "c"), value = 5:7)
  expect_equal(inp_dropdown(li), inp_dropdown(df))
  at <- as.double(1:12)
  df <- data.frame(key = at, value = at)
  expect_equal(inp_dropdown(at), inp_dropdown(df))
  x <- rnorm(100)
  expect_equal(inp_dropdown(x), inp_dropdown(x))
})

context("Number Form Group")

test_that("inp_number error on non-atomic from or to", {
  expect_error(inp_number(from = list()))
  expect_error(inp_number(to = list()))
  expect_error(inp_number(from = c(1, 2)))
  expect_error(inp_number(to = c(3, 4)))
  expect_error(inp_number(to = -1))
  expect_error(inp_number(from = 101))
  a = 1
  expect_error(inp_number(from = a, to = a))
})

test_that("inp_number equivalent input", {
  expect_equal(inp_number(to = 100), inp_number(to = 100L))
})

context("List To Dataframe")

test_that("list_to_df", {
  x <- list(a = 1, b = 2)
  y <- tibble::tibble(key = c("a", "b"), value = c(1, 2))
  expect_equal(appifyr:::list_to_df(x), y)
})

context("Dataframe To Dataframe")

test_that("df_to_df", {
  y <- tibble::tibble(key = c("a", "b"), value = c(1, 2))
  expect_equal(appifyr:::df_to_df(y), y)

  y <- tibble::tibble(key = LETTERS, value = LETTERS)
  expect_equal(appifyr:::df_to_df(y), y)

  x <- tibble::tibble(key = LETTERS, value = factor(LETTERS, LETTERS))
  y <- tibble::tibble(key = LETTERS, value = LETTERS)
  expect_equal(appifyr:::df_to_df(x), y)

  x <- as.double(1:12)
  y <- tibble::tibble(key = x, value = x)
  expect_equal(appifyr:::df_to_df(y), y)
})

context("Atomic To Dataframe")

test_that("df_to_df", {
  x <- as.double(1:12)
  y <- tibble::tibble(key = x, value = x)
  expect_equal(appifyr:::atomic_to_df(x), y)
})
