library(appifyr)

test_that("arg_to_json produces valid JavaScript", {
  # Test basic functionality
  result <- arg_to_json("sample_arg", "test_id")
  expect_type(result, "character")
  
  # Check that it contains the expected parts
  expect_match(result, "sample_arg", fixed = TRUE)
  expect_match(result, "test_id", fixed = TRUE)
  expect_match(result, "\\$\\('#sample_arg-test_id'\\)", perl = TRUE)
})

test_that("args_to_json correctly handles multiple arguments", {
  # Single argument case
  single_arg <- args_to_json(c("bar"), "1337")
  expect_type(single_arg, "character")
  expect_equal(single_arg, arg_to_json("bar", "1337"))
  
  # Multiple arguments case
  multi_args <- args_to_json(c("foo", "bar", "baz"), "test_id")
  expect_type(multi_args, "character")
  
  # Should contain all argument names
  expect_match(multi_args, "foo", fixed = TRUE)
  expect_match(multi_args, "bar", fixed = TRUE)
  expect_match(multi_args, "baz", fixed = TRUE)
  
  # Should be a comma-separated list
  expect_match(multi_args, ",", fixed = TRUE)
})

test_that("rplot function generates valid JavaScript", {
  id <- "test_id"
  json <- args_to_json(c("n", "mean", "sd"), id)
  js_code <- rplot(id = id, rf = "rnorm", json = json)
  
  # Check basic properties
  expect_type(js_code, "character")
  
  # Check that it contains the function name and ID
  expect_match(js_code, "rnorm", fixed = TRUE)
  expect_match(js_code, "test_id", fixed = TRUE)
  
  # Check for specific OpenCPU JavaScript patterns
  expect_match(js_code, "\\$\\(\"#submit-test_id\"\\)\\.click", perl = TRUE)
  expect_match(js_code, "\\$\\(\"#target-test_id\"\\)\\.rplot", perl = TRUE)
  
  # Check that it includes error handling
  expect_match(js_code, "req.fail", fixed = TRUE)
  expect_match(js_code, "req.done", fixed = TRUE)
})
