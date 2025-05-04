library(appifyr)

# Use testthat 3.0 syntax
test_that("appify returns correct object structure", {
  app <- appify(
    f = "rnorm",
    inps = list(n = inp_number(from = 10, to = 100)),
    id = "test-id"
  )
  
  # Check that it returns the correct class
  expect_s3_class(app, "appifyr_app")
  expect_equal(app$function_name, "rnorm")
  expect_equal(app$id, "test-id")
  expect_equal(app$output_type, "plot")
  expect_equal(app$theme, "bootstrap4")
})

test_that("appify works with different input types", {
  # Test with dropdown from vector
  app1 <- appify(
    f = "rnorm",
    inps = list(
      n = inp_dropdown(1:12),
      m = inp_text(label = "Text")
    ),
    id = "foo-id"
  )
  
  # Test with dropdown from data frame
  app2 <- appify(
    f = "rnorm",
    inps = list(
      n = inp_dropdown(data.frame(key = 1:12, value = 1:12)),
      m = inp_text(label = "Text")
    ),
    id = "foo-id"
  )
  
  # The HTML output should be the same
  expect_equal(app1$html, app2$html)
  
  # Test with dropdown from key-value pairs
  app3 <- appify(
    f = "rnorm",
    inps = list(
      n = inp_dropdown(data.frame(key = c("q", "i"), value = 1:2))
    ),
    id = "foo-id"
  )
  
  app4 <- appify(
    f = "rnorm",
    inps = list(
      n = inp_dropdown(list(q = 1, i = 2))
    ),
    id = "foo-id"
  )
  
  expect_equal(app3$html, app4$html)
  
  # Test number inputs
  app5 <- appify(
    f = "rnorm",
    inps = list(
      n = inp_number()
    ),
    id = "foo-id"
  )
  
  app6 <- appify(
    f = "rnorm",
    inps = list(
      n = inp_number(from = 0, to = 100, step = 1)
    ),
    id = "foo-id"
  )
  
  expect_equal(app5$html, app6$html)
})

test_that("set_label correctly adds missing labels", {
  inps <- list(
    n = list(label = NULL),
    m = list(label = "A")
  )
  outs <- list(
    n = list(label = "n"),
    m = list(label = "A")
  )
  expect_equal(set_label(inps), outs)
})

test_that("inp_text validates input correctly", {
  # Valid input
  expect_s3_class(inp_text(), c("appifyr_input", "appifyr_text_input"))
  expect_s3_class(inp_text(width = 8), c("appifyr_input", "appifyr_text_input"))
  
  # Invalid input
  expect_error(inp_text(width = 42), "'width' must be an integer between 1 and 12")
  expect_error(inp_text(width = 0), "'width' must be an integer between 1 and 12")
  expect_error(inp_text(width = "A"), "'width' must be an integer between 1 and 12")
})

test_that("inp_dropdown validates input correctly", {
  # Valid inputs
  expect_s3_class(inp_dropdown(1:5), c("appifyr_input", "appifyr_dropdown_input"))
  expect_s3_class(
    inp_dropdown(data.frame(key = letters[1:3], value = 1:3)), 
    c("appifyr_input", "appifyr_dropdown_input")
  )
  expect_s3_class(
    inp_dropdown(list(a = 1, b = 2, c = 3)), 
    c("appifyr_input", "appifyr_dropdown_input")
  )
  
  # Invalid inputs
  expect_error(inp_dropdown(data.frame(key = 1)), "Dataframe 'kv' must have 'key' and 'value' columns")
  expect_error(inp_dropdown(data.frame(value = 1)), "Dataframe 'kv' must have 'key' and 'value' columns")
  expect_error(inp_dropdown(list()), "'kv' must be provided and cannot be empty")
  expect_error(inp_dropdown(list(1, a = 4)), "All elements in 'kv' list must be named")
  expect_error(inp_dropdown(width = 13), "'width' must be an integer between 1 and 12")
})

test_that("inp_dropdown creates equivalent outputs from different inputs", {
  # List and dataframe
  li <- list(a = 5, b = 6, c = 7)
  df <- data.frame(key = c("a", "b", "c"), value = 5:7)
  li_result <- inp_dropdown(li)
  df_result <- inp_dropdown(df)
  expect_equal(li_result$opts, df_result$opts)
  
  # Atomic vector and equivalent dataframe
  at <- as.double(1:12)
  df <- data.frame(key = at, value = at)
  at_result <- inp_dropdown(at)
  df_result <- inp_dropdown(df)
  expect_equal(at_result$opts, df_result$opts)
})

test_that("inp_number validates input correctly", {
  # Valid inputs
  expect_s3_class(inp_number(), c("appifyr_input", "appifyr_number_input"))
  expect_s3_class(
    inp_number(from = 0, to = 100, step = 0.1), 
    c("appifyr_input", "appifyr_number_input")
  )
  
  # Invalid inputs
  expect_error(inp_number(from = list()), "'from', 'to', and 'step' must be atomic scalar values")
  expect_error(inp_number(to = list()), "'from', 'to', and 'step' must be atomic scalar values")
  expect_error(inp_number(from = c(1, 2)), "'from', 'to', and 'step' must be atomic scalar values")
  expect_error(inp_number(to = c(3, 4)), "'from', 'to', and 'step' must be atomic scalar values")
  expect_error(inp_number(from = 101, to = 100), "'from' must be less than 'to'")
  expect_error(inp_number(from = 1, to = 1), "'from' must be less than 'to'")
  expect_error(inp_number(step = 0), "'step' must be greater than 0")
  expect_error(inp_number(step = -1), "'step' must be greater than 0")
  expect_error(inp_number(width = 13), "'width' must be an integer between 1 and 12")
})

test_that("inp_number handles double and integer inputs correctly", {
  num_double <- inp_number(from = 0, to = 100.0)
  num_int <- inp_number(from = 0L, to = 100L)
  
  expect_equal(num_double$opts$from, num_int$opts$from)
  expect_equal(num_double$opts$to, num_int$opts$to)
})

test_that("helper functions convert data correctly", {
  # list_to_df
  x <- list(a = 1, b = 2)
  y <- tibble::tibble(key = c("a", "b"), value = c(1, 2))
  expect_equal(list_to_df(x), y)
  
  # df_to_df
  y <- tibble::tibble(key = c("a", "b"), value = c(1, 2))
  expect_equal(df_to_df(y), y)
  
  y <- tibble::tibble(key = LETTERS, value = LETTERS)
  expect_equal(df_to_df(y), y)
  
  x <- tibble::tibble(key = LETTERS, value = factor(LETTERS, LETTERS))
  y <- tibble::tibble(key = LETTERS, value = LETTERS)
  expect_equal(df_to_df(x), y)
  
  # atomic_to_df
  x <- as.double(1:12)
  y <- tibble::tibble(key = x, value = x)
  expect_equal(atomic_to_df(x), y)
})

test_that("create_id functions correctly", {
  # Default length
  id1 <- create_id()
  expect_type(id1, "character")
  expect_equal(nchar(id1), 10)
  
  # Custom length
  id2 <- create_id(15)
  expect_equal(nchar(id2), 15)
  
  # With prefix
  id3 <- create_id(prefix = "test_")
  expect_equal(substr(id3, 1, 5), "test_")
  
  # Error cases
  expect_error(create_id(-1), "'n' must be a positive integer")
  expect_error(create_id("10"), "'n' must be a positive integer")
  expect_error(create_id(10, prefix = 123), "'prefix' must be a character string")
})

test_that("ensure_id_postfix functions correctly", {
  # NULL case generates a random ID
  id1 <- ensure_id_postfix(NULL)
  expect_type(id1, "character")
  
  # Custom ID is returned as-is
  expect_equal(ensure_id_postfix("custom_id"), "custom_id")
  
  # Error cases
  expect_error(ensure_id_postfix(123), "'postfix' must be NULL or a non-empty character string")
  expect_error(ensure_id_postfix(""), "'postfix' must be NULL or a non-empty character string")
  expect_error(ensure_id_postfix(character(0)), "'postfix' must be NULL or a non-empty character string")
})
