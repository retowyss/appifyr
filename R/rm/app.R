#' #' Title
#' #'
#' #' @param f
#' #' @param inps
#' #' @param run_tests
#' #' @param env
#' #'
#' #' @return
#' #' @export
#' #'
#' #' @importFrom glue glue double_quote
#' #' @importFrom readr write_file
#' #'
#' app <- function(f, inps, run_tests = F, env = parent.frame()) {
#'   id <- create_id()
#'   export <- "' @export"
#'   assign(x = id, value = env)
#'   save(list = id, file = paste0("data/", id, ".rda"))
#'   glue("
#'        #<<export>>
#'        <<f>>_<<id>> <-function(...) {
#'          do.call(what = <<double_quote(f)>>, args = list(...), envir = <<id>>)
#'        }
#'        "
#'        , .open = "<<",
#'        .close = ">>") %>%
#'     write_file(glue("R/<<f>>_<<id>>.R"))
#' }
#'
#' process_inps <- function(inps) {
#'   map(inps, process_inp)
#' }
#'
#' process_inp <- function(inp) {
#'   stopifnot("fg" %in% names())
#'   fg_inner <- switch (inp$fg,
#'     "number" = fg_number(inp$opts),
#'     "dropdown" = fg_dropdown(inp$opts),
#'     "text" = fg_text()
#'   )
#'
#'   fgp <- system.file(glue({"js/glue/fg_{inp$fg}.js"}), package = "appifyr")
#'
#' }
#'
