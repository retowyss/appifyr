#' Appify
#'
#' @param f A function from your package or a function written in your Rmd document.
#' @param inputs Inputs to your function. A form will be created for them.
#' @param input_check Should inputs be checked against function inputs
#'     (default: TRUE)?
#' @param id_postfix Advanced users may wish to set the html-id postfix. The
#'     default value is NULL. appify will then create a random postfix.
#' @param plot_height Pixel value for the plot height. The default value is
#'     600. So, the app including the form will comfortably fit on a
#'     laptop screen.
#' @param position_flip By default (FALSE) the plot will be placed below the
#'     input form.
#'
#' @return html and javascript code
#' @export
#'
#' @importFrom purrr map set_names flatten
#' @importFrom htmltools div
#' @importFrom methods formalArgs
#'
#' @examples
#' # Appify returns html. When included in a Rmarkdown document this will be
#' # display as a form and a canvas.
#' rnorm_plot <- function(n, mean, sd) {
#'   plot(rnorm(n = n, mean = mean, sd = sd))
#' }
#'
#' appify(
#'   f = rnorm_plot,
#'   inputs = list(
#'     n = number("Sample Size"),
#'     mean = number("Distribution Mean"),
#'     sd = number("Distribution Standard Deviation")
#'   )
#' )
#'
appify <- function(f,
                   inputs = list(),
                   id_postfix = NULL,
                   input_check = TRUE,
                   plot_height = 600,
                   position_flip = FALSE) {

  f_name <-  as.character(substitute(f))
  input_names <- names(inputs)

  if(input_check) check_inputs(f, input_names)
  id_postfix <- ensure_id_postfix(id_postfix)

  html_ids <- list(
    canvas = paste0("canvas-", id_postfix),
    button = paste0("button-", id_postfix),
    f_name = f_name,
    args = map(input_names, ~paste0("input-", ., "-", id_postfix)) %>%
      set_names(input_names)
  )

  html <- (function() {
    selectors <- input_names %>%
      map(function(x) {inputs[[x]](id = html_ids$args[x])}) %>%
      flatten()

    form <- html_container_form(
      id = paste0("form-", id_postfix),
      class = "well",
      button_id = html_ids$button,
      selectors
    )

    if(!position_flip) {
      div(form, html_container_output(html_ids$canvas, height = plot_height))
    } else {
      div(html_container_output(html_ids$canvas, height = plot_height), form)
    }
  })()

  div(html, do.call(js_rplot, html_ids))
}
