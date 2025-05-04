#' appifyr: Create Web Applications from R Functions
#'
#' @description
#' The appifyr package enables R users to create interactive web applications
#' using OpenCPU as a backend. It provides a bridge between R's analytical
#' capabilities and web interfaces by automatically generating HTML forms
#' for function parameters, connecting these inputs to OpenCPU API calls,
#' and displaying the function outputs.
#'
#' To learn more about appifyr, start with the vignettes:
#' `browseVignettes(package = "appifyr")`
#'
#' @section Key Functions:
#' \itemize{
#'   \item \code{\link{appify}}: Create a web app from an R function
#'   \item \code{\link{inp_text}}: Create a text input element
#'   \item \code{\link{inp_number}}: Create a numeric input element
#'   \item \code{\link{inp_dropdown}}: Create a dropdown/select input element
#'   \item \code{\link{build_app}}: Build and install the application
#' }
#'
#' @keywords internal
#' @import roxygen2
#' @import purrr
#' @import stringr
#' @import fs
#' @importFrom magrittr %>%
#' @importFrom htmltools tags div HTML
#' @importFrom rmarkdown render_site
#' @importFrom tibble tibble
#' @importFrom glue glue
#' @importFrom readr read_file write_file
#' @importFrom dplyr mutate bind_rows if_else
"_PACKAGE"
