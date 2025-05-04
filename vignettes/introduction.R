## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----eval=FALSE---------------------------------------------------------------
# library(appifyr)
# 
# # Define a simple function that creates a plot
# histogram_app <- function(n, bins) {
#   hist(rnorm(n), breaks = bins, main = "Random Normal Distribution")
# }
# 
# # Create a web interface for this function
# app <- appify(
#   f = "histogram_app",
#   inps = list(
#     n = inp_number(from = 10, to = 1000, label = "Sample Size"),
#     bins = inp_number(from = 5, to = 30, label = "Number of Bins")
#   )
# )
# 
# # The app object contains the HTML needed for the web interface
# print(app)

## ----eval=FALSE---------------------------------------------------------------
# inp_text(label = "Title", width = 6)

## ----eval=FALSE---------------------------------------------------------------
# inp_number(from = 0, to = 100, step = 0.1, label = "Value")

## ----eval=FALSE---------------------------------------------------------------
# # From a vector
# inp_dropdown(c("Option 1", "Option 2", "Option 3"), label = "Choose an option")
# 
# # From a list with custom values
# inp_dropdown(list(Option1 = "value1", Option2 = "value2"))
# 
# # From a data frame with key-value pairs
# df <- data.frame(
#   key = c("Option A", "Option B", "Option C"),
#   value = c(1, 2, 3)
# )
# inp_dropdown(df)

## ----eval=FALSE---------------------------------------------------------------
# # Build the app
# build_app()
# 
# # Run the app with OpenCPU
# opencpu::ocpu_start_app("YourPackageName")

## ----eval=FALSE---------------------------------------------------------------
# library(appifyr)
# 
# # Define a simple model function
# linear_model <- function(n, slope, intercept, noise) {
#   x <- seq(0, 10, length.out = n)
#   y <- slope * x + intercept + rnorm(n, 0, noise)
#   plot(x, y, main = "Linear Model Simulation")
#   abline(intercept, slope, col = "red")
# }
# 
# # Create an interactive app
# appify(
#   f = "linear_model",
#   inps = list(
#     n = inp_number(from = 10, to = 100, label = "Number of points"),
#     slope = inp_number(from = -5, to = 5, step = 0.1, label = "Slope"),
#     intercept = inp_number(from = -10, to = 10, step = 0.1, label = "Intercept"),
#     noise = inp_number(from = 0, to = 5, step = 0.1, label = "Noise level")
#   )
# )

