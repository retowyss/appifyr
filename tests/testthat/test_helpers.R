library(appifyr)

# Tests for our modernized create_id() function
test_that("create_id generates IDs with correct properties", {
  # Default behavior (10 characters)
  id1 <- create_id()
  expect_type(id1, "character")
  expect_equal(nchar(id1), 10)
  
  # Custom length
  id2 <- create_id(5)
  expect_equal(nchar(id2), 5)
  
  # Custom length with prefix
  id3 <- create_id(8, prefix = "app-")
  expect_equal(nchar(id3), 12)  # 8 random chars + 4 prefix chars
  expect_equal(substr(id3, 1, 4), "app-")
  
  # Verify that different calls produce different IDs
  id4 <- create_id()
  id5 <- create_id()
  expect_false(id4 == id5)
})

test_that("create_id validates inputs properly", {
  expect_error(create_id("10"), "'n' must be a positive integer")
  expect_error(create_id(0), "'n' must be a positive integer")
  expect_error(create_id(-5), "'n' must be a positive integer")
  expect_error(create_id(10, prefix = 123), "'prefix' must be a character string")
})

# Tests for our modernized ensure_id_postfix() function
test_that("ensure_id_postfix handles valid inputs correctly", {
  # When given NULL, generates a random ID
  random_id <- ensure_id_postfix(NULL)
  expect_type(random_id, "character")
  expect_equal(nchar(random_id), 10)  # Should match our default create_id() length
  
  # When given a valid string, returns it unchanged
  expect_equal(ensure_id_postfix("test-id"), "test-id")
  expect_equal(ensure_id_postfix("a"), "a")
})

test_that("ensure_id_postfix validates inputs properly", {
  expect_error(ensure_id_postfix(""), "'postfix' must be NULL or a non-empty character string")
  expect_error(ensure_id_postfix(c("a", "b")), "'postfix' must be NULL or a non-empty character string")
  expect_error(ensure_id_postfix(123), "'postfix' must be NULL or a non-empty character string")
})

