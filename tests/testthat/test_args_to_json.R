library(appifyr)

context("Arguments To JSON")

test_that("arg_to_json is character", {
  expect_type(arg_to_json("A", "42"), "character")
})
test_that("arg_to_json result", {
  r <- "B : (function(){\nvar x = $('#B-xGkrZCuuI').val();\nreturn(isNaN() ? x : parseFloat(x));\n})()"
  expect_equal(arg_to_json("B", "xGkrZCuuI"), r)
  r <- "A : (function(){\nvar x = $('#A-123').val();\nreturn(isNaN() ? x : parseFloat(x));\n})()"
  expect_equal(arg_to_json("A", "123"), r)
})

test_that("args_to_json is character", {
  expect_type(arg_to_json(list("bar"), "1337"), "character")
})
test_that("args_to_json result", {
  r <- "A : (function(){\nvar x = $('#A-123').val();\nreturn(isNaN() ? x : parseFloat(x));\n})()"
  expect_equal(args_to_json("A", "123"), r)
  r <- "A : (function(){\nvar x = $('#A-123').val();\nreturn(isNaN() ? x : parseFloat(x));\n})(),\nB : (function(){\nvar x = $('#B-123').val();\nreturn(isNaN() ? x : parseFloat(x));\n})(),\nC : (function(){\nvar x = $('#C-123').val();\nreturn(isNaN() ? x : parseFloat(x));\n})()"
  expect_equal(args_to_json(list("A", "B", "C"), "123"), r)
})

context("rplot")

test_that("rplot is character", {
  expect_type(rplot(id = 5, rf = "rnorm", json = "n : 4"), "character")
})

test_that("rplot result", {
  id = 5
  json <- args_to_json(list("A", "B", "C"), id = id)
  expect_equal(rplot(id = id, rf = "rnorm", json = json), "$(\"#submit-5\").click(function(){\nvar req = $(\"#target-5\").rplot(\n  \"rnorm\",\n  {A : (function(){\nvar x = $('#A-5').val();\nreturn(isNaN() ? x : parseFloat(x));\n})(),\nB : (function(){\nvar x = $('#B-5').val();\nreturn(isNaN() ? x : parseFloat(x));\n})(),\nC : (function(){\nvar x = $('#C-5').val();\nreturn(isNaN() ? x : parseFloat(x));\n})()}\n);\nreq.fail(function(){\n  alert(Error:  + req.responseText);\n});\n});")
})

