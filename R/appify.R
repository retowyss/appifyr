#' Appify
#'
#' @param f A function from your package or written in your Rmd document.
#' @param inputs Inputs to your function for which a form will be created.
#' @param input_check Should inputs be checked against function inputs
#'     (default = `TRUE`)?
#' @param id_postfix Advanced users may wish to set the html-id postfix. The
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
#' @importFrom purrr map set_names flatten
#' @importFrom htmltools div
#' @importFrom methods formalArgs
#'
appify <- function(f,
                   inputs = list(),
                   id_postfix = NULL,
                   input_check = TRUE,
                   plot_height = 600,
                   position_flip = FALSE) {

  r_fun <-  as.character(substitute(f))
  input_names <- names(inputs)

  if(input_check) check_inputs(f, input_names)
  id_postfix <- ensure_id_postfix(id_postfix)

  ids <- list(
    canvas = paste0("canvas-", id_postfix),
    button = paste0("button-", id_postfix),
    r_fun = r_fun,
    args = map(input_names, ~paste0("input-", ., "-", id_postfix)) %>%
      set_names(input_names)
  )

  html <- (function() {
    selectors <- input_names %>%
      map(function(x) {inputs[[x]](id = ids$args[x])}) %>%
      flatten()

    form <- app_form(
      id = paste0("form-", id_postfix),
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
