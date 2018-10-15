#' Create App From Function and Inputs
#'
#' @param f a function as a string
#' @param inps a list of inputs, see \code{?inp_text}, \code{?inp_number}
#'     and \code{?inp_dropdown}
#' @param out the output type (currently the only valid value is \code{"plot"})
#' @param id html identifier, when \code{NULL} the id will be generated
#'     randomly. If you set the id manually, make sure it is unique.
#'
#' @return html
#'
#' @export
#'
#' @importFrom purrr imap
#' @importFrom htmltools tags
#'
#' @examples
#' # Assume the function my_function has arguments x, y:
#' # my_function <- function(x, y) {
#' #   # Code
#' # }
#' appify(f = "my_function", inps = list(x = inp_number(), y = inp_number()))
#'
appify <- function(f, inps, out = "plot", id = NULL) {
  stopifnot(out == "plot")
  id <- ensure_id_postfix(id)
  inps <- set_label(inps)

  form <- imap(inps, ~ fg_to_html(g = .x, id = paste0(.y, "-", id)))

  form <- html_container_form(
    id = paste0("form-", id),
    button_id = paste0("submit-", id),
    class = "well",
    form
  )

  # The output container needs an id as well
  out <- html_container_output(id = paste0("target-", id), height = 600)

  jscript <- tags$script(
    type = "text/javascript",
    charset = "utf-8",
    rplot(id = id, rf = f, json = args_to_json(names(inps), id))
  )

  tags$div(form, out, jscript)
}

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

#' Form Group To HTML
#'
#' @param g a form group list
#' @param id an id
#'
#' @return html
#'
fg_to_html <- function(g, id) {
  f <- switch (g$fg,
    "text"     = fg_text,
    "number"   = fg_number,
    "dropdown" = fg_dropdown,
    stop()
  )
  do.call(f, args = list(g = g, id = id))
}

#' Translate Form Group List to HTML
#'
#' @inheritParams fg_text
#'
#' @return html
#'
#' @importFrom htmltools tags
#'
fg_number <- function(g, id) {
  input <- tags$input(
    id    = id,
    class = "form-control",
    type  = "number",
    min   = g$opts$from,
    max   = g$opts$to
  )
  label <- tags$label(g$label)
  tags$div(class = paste0("col-sm-", g$width), label, input)
}

#' Translate Form Group List to HTML
#'
#' @inheritParams fg_text
#'
#' @return html
#'
#' @importFrom purrr pmap
#' @importFrom htmltools tags
#'
fg_dropdown <- function(g, id) {
  input <- tags$select(
    id = id,
    class = "form-group form-control",
    pmap(g$opts, function(value, key) {
      tags$option(value = value, key)
    })
  )
  label <- tags$label(g$label)
  tags$div(class = paste0("col-sm-", g$width), label, input)
}

#' Translate Form Group List to HTML
#'
#' @param g a form group list
#' @param id an id
#'
#' @return html
#'
#' @importFrom htmltools tags
#'
fg_text<- function(g, id) {
  input <- tags$input(
    id    = id,
    class = "form-control",
    type  = "text"
  )
  label <- tags$label(g$label)
  tags$div(
    class = paste0("col-sm-", g$width),
    label,
    input
  )
}

#' Set The Form Group Label
#'
#' @param inps a list of inputs
#'
#' @return form group list with labels
#'
set_label <- function(inps) {
  for (n in names(inps)) {
    if (is.null(inps[[n]][["label"]])) {
      inps[[n]][["label"]] <- n
    }
  }
  inps
}

#' Text Input Form Group
#'
#' @param label label for the form input - this will default to display the
#'     name of the variable
#' @param width the form-group's width in bootstrap grid units
#' @param ... additional arguments passed to the form group parser
#'
#' @return a list
#' @export
#'
#' @examples
#' inp_text()
#' inp_text(label = "Plot Title")
#' inp_text(width = 6)
#' inp_text(label = "Description", width = 12)
#'
inp_text <- function(label = NULL, width = 4, ...) {
  stopifnot(width %in% 1:12)
  list(
    fg    = "text",
    label = label,
    width = width,
    dots  = list(...)
  )
}

#' Dropdown Input Form Group
#'
#' @param kv a vector, a list or a dataframe
#' @inheritParams inp_text
#'
#' @return a list
#' @export
#'
#' @importFrom purrr is_atomic
#'
#' @examples
#' inp_dropdown(c(1, 3, 7, 42))
#' inp_dropdown(names(iris), label = "Select Iris Variable")
#' kv <- data.frame(key = c("A", "B"), value = c(1, 2))
#' inp_dropdown(kv)
#' inp_dropdown(LETTERS, label = "Letters", width = 2)
#' inp_dropdown(list(n = 1, m = 2, k = 4))
#'
inp_dropdown <- function(kv,
                         label = NULL,
                         width = 4,
                         ...) {
  inp <- inp_text(label = label, width = width, ...)
  if ("list" %in% class(kv)) {
    stopifnot(length(kv) > 0 & !("" %in% names(kv)))
    kv <- list_to_df(kv)
  } else if ("data.frame" %in% class(kv)) {
    stopifnot("key" %in% names(kv) & "value" %in% names(kv))
    kv <- df_to_df(kv)
  } else if (is_atomic(kv)) {
    kv <- atomic_to_df(kv)
  } else {
    stop()
  }
  inp$fg <- "dropdown"
  inp$opts <- kv
  inp
}

#' Number Input Form Group
#'
#' @param from a number
#' @param to  a number
#' @inheritParams inp_text
#'
#' @return a list
#' @export
#'
#' @importFrom purrr is_scalar_atomic
#'
#' @examples
#' inp_number()
#' inp_number(from = 0, to = 1e9)
#' inp_number(from = 1, to = 7, label = "This Is A Survey")
#'
inp_number <- function(from = 0,
                       to = 100,
                       label = NULL,
                       width = 4,
                       ...) {
  inp <- inp_text(label = label, width = width, ...)

  stopifnot(!(class(from) == "list" | class(to) == "list"))
  stopifnot(is_scalar_atomic(from) & is_scalar_atomic(to))
  stopifnot(from < to)

  inp$fg <- "number"
  inp$opts <- list(from = as.double(from), to = as.double(to))
  inp
}

#' Convert Key Value List To Dataframe
#'
#' @param x a list
#'
#' @return a dataframe
#'
#' @importFrom purrr imap_dfr
#' @importFrom dplyr bind_rows
#' @importFrom tibble tibble
#'
list_to_df <- function(x) {
  imap_dfr(x, function(.x, .y) {
    tibble(key = factor_to_chr(.y), value = factor_to_chr(.x))
  })
}

#' Convert List Of Values To Dataframe
#'
#' @param x a vector
#'
#' @return a dataframe
#'
#' @importFrom tibble tibble
#'
atomic_to_df <- function(x) {
  x <- factor_to_chr(x)
  tibble(key = x, value = x)
}

#' Convert Dataframe To Dataframe
#'
#' @param x a dataframe
#'
#' @return a dataframe
#'
#' @importFrom tibble tibble
#'
df_to_df <- function(x) {
  tibble(key = factor_to_chr(x$key), value = factor_to_chr(x$value))
}

#' Convert Factor To Character
#'
#' @param x a vector
#'
#' @return a vector
#'
#' @importFrom dplyr if_else
#'
#' @examples
#' appifyr:::factor_to_chr(factor(c("A", "B")))
#' appifyr:::factor_to_chr(factor(1:12))
#'
factor_to_chr <- function(x) {
  if(is.factor(x) | is.character(x)) {
    as.character(x)
  } else {
    as.double(x)
  }
}

#' The R-Plot Widget
#'
#' @description This function fills the rplot.js glue-partial. The rplot javascript
#'     function is part of the OpenCPU javascript library.
#'
#' @param id id of the corresponding html elements
#' @param rf name of the R function
#' @param json inner json of arguments to the R function
#' @param err error message for the javascript alert
#'
#' @return java script code
#'
#' @importFrom magrittr %>%
#' @importFrom readr read_file
#' @importFrom glue glue
#'
#' @examples
#' appifyr:::rplot("xGkrZCuuI", "rnorm", "n : 5")
#' appifyr:::rplot("xGkrZCuuI", "rnorm", "n : 1000, mean : 100, sd : 15")
#'
rplot <- function(id, rf, json, err = "Error: ") {
  system.file("js/glue/rplot.js", package = "appifyr") %>%
    read_file() %>%
    glue(.open = "<<", .close = ">>") %>%
    as.character()
}

#' Argument To JSON
#'
#' @param an argument name, e.g. "n"
#' @param id html id
#'
#' @return json body code,
#'
#' @importFrom readr read_file
#' @importFrom glue glue
#'
arg_to_json <- function(an, id) {
    json <- glue(
      read_file(system.file("js/glue/json.js", package = "appifyr")),
      .open = "<<",
      .close = ">>",
      an = an,
      id = id
    )
    as.character(json)
}

#' Arguments To JSON
#'
#' @param ans argument names
#' @param id html identifier
#'
#' @return json body code
#'
#' @importFrom purrr map
#' @importFrom stringr str_c
#'
args_to_json <- function(ans, id) {
  json_list <- map(ans, arg_to_json, id = id)
  as.character(str_c(json_list, sep = ",\n"))
}
