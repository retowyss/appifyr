#' The R-Plot Widget
#'
#' @description This function fills the rplot.js glue-partial. The rplot javascript
#'     function is part of the OpenCPU javascript library.
#'
#' @param id id of the corresponding html elements
#' @param rf name of the R function
#' @param json inner json of arguments to the R function
#' @param err error message (default: "Error in R function call: ")
#'
#' @return java script code
#' @export
#'
#' @importFrom magrittr %>%
#' @importFrom readr read_file
#' @importFrom glue glue
#'
#' @examples
#' rplot("xGkrZCuuI", "rnorm", "n : 5")
#' rplot("xGkrZCuuI", "rnorm", "n : 1000, mean : 100, sd : 15")
#'
rplot <- function(id, rf, json, err = "Error: ") {
  system.file("js/glue/rplot.js", package = "appifyr") %>%
    read_file() %>%
    glue(.open = "<<", .close = ">>") %>%
    as.character()
}
