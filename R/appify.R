#' Appify
#'
#' @param f A function from your package or written in your Rmd document.
#' @param inputs Inputs to your function for which a form will be created.
#' @param input_check Should inputs be checked against function inputs
#'     (default = `TRUE`)?
#' @param app_space Advanced users may wish to set the html-id postfix. The
#'     default value is NULL. appify will then create a random postfix.
#' @param plot_height Pixel value for the plot height. The default value is
#'     600. So, the app including the form will comfortably fit on a
#'     laptop screen.
#' @param position_flip By default (FALSE) the plot will be placed below the
#'     input form.
#'
#' @return an app - including html and javascript
#' @export
#'
#' @import purrr
#' @import glue
#' @import htmltools
#' @importFrom methods formalArgs
#'
appify <- function(f,
                   inputs = list(),
                   app_space = NULL,
                   input_check = TRUE,
                   plot_height = 600,
                   position_flip = FALSE) {

  r_fun <-  as.character(substitute(f))
  input_names <- names(inputs)

  if(input_check) check_inputs(f, input_names)
  if(is.null(app_space)) app_space <- create_id()

  ids <- list(
    canvas = paste0("canvas-", app_space),
    button = paste0("button-", app_space),
    r_fun = r_fun,
    args = map(input_names, ~paste0("input-", ., "-", app_space)) %>%
      set_names(input_names)
  )

  html <- (function() {
    selectors <- input_names %>%
      map(function(x) {inputs[[x]](id = ids$args[x])}) %>%
      flatten()

    form <- app_form(
      id = paste0("form-", app_space),
      class = "well",
      button_id = ids$button,
      selectors
    )

    if(!position_flip) {
      div(form, canvas(ids$canvas, height = plot_height))
    } else {
      div(canvas(ids$canvas, height = plot_height), form)
    }
  })()

  div(html, do.call(js_rplot, ids))
}
