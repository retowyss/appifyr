#' App Form
#'
#' @description This function creates the html from container.
#'
#' @param id The html-id for the form.
#' @param class The css classes to be applied to the form tag
#' @param button_id The html-id for the button
#' @param ... Any  number of html tags to be inserted into the form body.
#'
#' @return html form tag
#' @export
#'
#' @importFrom htmltools tags
#'
html_container_form <- function(id, class, button_id, ...) {
  tags$form(
    id = id,
    class = class,
    tags$fieldset(class = "row", list(...)),
    tags$button(
      id = button_id,
      class = "btn btn-primary",
      type = "button",
      "Submit"
    )
  )
}

#' Container for Output
#'
#' @description TThe ouput container is the target for the r function result.
#'
#' @param id The html-id for the ouput container
#' @param height The height for the plot
#'
#' @return target div for the plot
#' @export
#'
#' @importFrom htmltools div
#'
html_container_output <- function(id, height) {
  div(
    style = paste0("height: ", height, "px;"),
    class = "well",
    id = id
  )
}
