#' Dropdown
#'
#' @param label The label to display above the input field
#' @param width The width in bootstrap grid units (defaul 4)
#' @param opts Either a list of (key1 = value1, ..., keyn = valuen) or a two
#'     column dateframe with column names "key" and "value"
#'
#' @return
#' @export
#'
#' @importFrom magrittr %>%
#' @importFrom purrr pmap map_dfc
#' @importFrom tidyr gather
#' @importFrom htmltools tags
#' @importFrom dplyr mutate if_else
#'
#' @examples
dropdown <- function(label = "", width = 4, opts) {
  stopifnot(width %in% 1:12)
  if(class(opts) == "list") {
    opts <- opts %>%
      map_dfc(identity) %>%
      gather(key = "key", value = "value")
  } else if("data.frame" %in% class(opts)) {
    opts <- mutate(opts, key = as.character(key))
  } else {
    stop()
  }

  opts <- mutate(
    opts,
    value = ifelse(
      rep(suppressWarnings(any(is.na(as.numeric(as.character(value))))), length(value)),
      as.character(value),
      as.numeric(as.character(value))
    )
  )

  function(id) {
    list(div(class = paste0("col-sm-", width),
     tags$label(label),
     tags$select(
       id = id,
       class = "form-group form-control",
       pmap(opts, function(value, key) {
         tags$option(value = value, key)
       })
     )
    ))
  }
}


#' Title
#'
#' @param label The label to display above the input field
#' @param width The width in bootstrap grid units (defaul 4)
#'
#' @return
#' @export
#'
#' @examples
dropdown_color <- function(label = "", width = 4) {
  opts <- data.frame(
    key = c(
      "Blue", "Deep Purple", "Red", "Green", "Deep Orange", "Grey", "Black"
    ),
    value = c(
      "#2196F3", "#673AB7", "#F44336","#4CAF50", "#FF5722", "#9E9E9E", "#000000"
    ), stringsAsFactors = F
  )
  dropdown(label = label, width = width, opts = opts)
}



#' #' Input Slider
#' #'
#' #' @param label The label to display above the input field
#' #' @param width The width in bootstrap grid units (defaul 4)
#' #' @param to
#' #' @param by
#' #'
#' #' @return
#' #' @export
#' #'
#' #' @examples
#' slider <- function(label = "", width = 4, from = 0, to = 100, by = 10) {
#'   list(render = function(id) {
#'     list(div(class = paste0("col-sm-", width),
#'       tags$label(label),
#'       div(
#'         class = "input-group",
#'         span(class = "input-group-addon", from),
#'         tags$input(
#'           id = id,
#'           class = "form-control",
#'           type = "range",
#'           min = from,
#'           max = to,
#'           step = by
#'         ),
#'         span(class = "input-group-addon", to)
#'       )
#'     ))
#'   })
#' }


#' Number Input
#'
#' @param label The label to display above the input field
#' @param width The width in bootstrap grid units (defaul 4)
#' @param from The minimum value to accept as an input
#' @param to The maximum value to accept as an input
#'
#' @return html form input of type number
#' @export
#'
#' @importFrom htmltools tags
#'
number <- function(label = "", width = 4, from = 0, to = 100) {
  function(id) {
    list(div(class = paste0("col-sm-", width),
      tags$label(label),
      tags$input(
        id = id,
        class = "form-control",
        type = "number",
        min = from,
        max = to
      )
    ))
  }
}
