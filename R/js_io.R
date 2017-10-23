#' Make R-Plot JavaScript
#'
#' @description Creates Javascript that handles the communication between
#'     OpenCPU and the website/webapp.
#'
#' @param canvas html-id of canvas
#' @param button html-id of submit button
#' @param f_name R function (as character)
#' @param args list of (argname = html-id)
#'
#' @return html script tag
#' @export
#'
#' @importFrom magrittr %>%
#' @importFrom htmltools tags
#' @importFrom readr read_file
#' @importFrom glue collapse glue
#'
js_rplot <- function(canvas, button, f_name, args) {
  arg_str <- '<<names(args)>> : (function(){x = $("#<<args>>").val(); return(isNaN(x) ? x : parseFloat(x))})()'
  json_body <-  arg_str %>%
    glue(args = args, .open = "<<", .close = ">>") %>%
    collapse(sep = ",\n")

  read_file(system.file("js/rplot.js", package = "appr")) %>%
    glue(
      .open = "<<",
      .close = ">>",
      canvas = canvas,
      button = button,
      r_fun = f_name
    ) %>%
    glue(.open = "<<", .close = ">>", args = json_body) %>%
    tags$script(type = "text/javascript", charset = "utf-8")
}
