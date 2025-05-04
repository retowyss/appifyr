#' Create App From Function and Inputs
#'
#' @param f a function as a string
#' @param inps a list of inputs, see \code{?inp_text}, \code{?inp_number}
#'     and \code{?inp_dropdown}
#' @param out the output type (currently the only valid value is \code{"plot"},
#'     with \code{"table"} planned for future releases)
#' @param id html identifier, when \code{NULL} the id will be generated
#'     randomly. If you set the id manually, make sure it is unique.
#' @param theme CSS framework to use. Currently only "bootstrap4" is supported.
#'
#' @return An object of class "appifyr_app" containing the HTML components
#'   that can be included in R Markdown documents or Shiny applications.
#'
#' @export
#'
#' @examples
#' # Simple histogram function
#' # hist_fun <- function(n, bins) {
#' #   hist(rnorm(n), breaks = bins)
#' # }
#' # 
#' # Create app with numeric inputs
#' app <- appify(
#'   f = "hist_fun", 
#'   inps = list(
#'     n = inp_number(from = 10, to = 1000, label = "Sample Size"),
#'     bins = inp_number(from = 5, to = 30, label = "Number of Bins")
#'   )
#' )
#'
appify <- function(f, inps, out = "plot", id = NULL, theme = "bootstrap4") {
  # Validate inputs
  if (!is.character(f) || length(f) != 1) {
    stop("'f' must be a single character string naming a function")
  }
  
  valid_outputs <- c("plot")
  if (!out %in% valid_outputs) {
    stop(sprintf("'out' must be one of: %s", paste(valid_outputs, collapse = ", ")))
  }
  
  if (!is.null(id) && (!is.character(id) || length(id) != 1)) {
    stop("'id' must be NULL or a single character string")
  }
  
  valid_themes <- c("bootstrap4")
  if (!theme %in% valid_themes) {
    stop(sprintf("'theme' must be one of: %s", paste(valid_themes, collapse = ", ")))
  }
  
  id <- ensure_id_postfix(id)
  inps <- set_label(inps)

  form <- imap(inps, ~ fg_to_html(g = .x, id = paste0(.y, "-", id), theme = theme))

  form <- html_container_form(
    id = paste0("form-", id),
    button_id = paste0("submit-", id),
    class = "well",
    form,
    theme = theme
  )

  # The output container needs an id as well - renamed from 'out' to 'out_container'
  out_container <- html_container_output(id = paste0("target-", id), height = 600, theme = theme)

  js_inner <- rplot(id = id, rf = f, json = args_to_json(names(inps), id)) %>%
    paste0(collapse = "\n")

  jscript <- str_interp('<script type = "text/javascript">${js_inner}</script>')

  # Create the app HTML content
  app_html <- htmltools::tags$div(form, out_container, htmltools::HTML(jscript))
  
  # Return as an appifyr_app object
  structure(
    list(
      html = app_html,
      function_name = f,
      inputs = inps,
      output_type = out,  # This should be the original string parameter, not the HTML container
      id = id,
      theme = theme
    ),
    class = "appifyr_app"
  )
}

#' Print method for appifyr_app objects
#'
#' @param x An appifyr_app object
#' @param ... Additional arguments (not used)
#'
#' @return The app object invisibly
#' @export
print.appifyr_app <- function(x, ...) {
  cat("appifyr app: ", x$function_name, "\n")
  cat("Inputs:\n")
  for (name in names(x$inputs)) {
    cat("  -", name, ":", class(x$inputs[[name]])[["fg"]], "\n")
  }
  cat("Output type:", x$output_type, "\n")
  cat("HTML ID:", x$id, "\n")
  cat("Theme:", x$theme, "\n")
  
  # Print the actual HTML
  print(x$html)
  
  invisible(x)
}

#' App Form
#'
#' @description This function creates the html form container.
#'
#' @param id The html-id for the form.
#' @param class The css classes to be applied to the form tag
#' @param button_id The html-id for the button
#' @param ... Any number of html tags to be inserted into the form body.
#' @param theme The CSS framework theme to use
#'
#' @return html form tag
#'
html_container_form <- function(id, class, button_id, ..., theme = "bootstrap4") {
  tags$form(
    id = id,
    class = class,
    tags$fieldset(class = "row", list(...)),
    tags$button(
      id = button_id,
      class = if (theme == "bootstrap4") "btn btn-primary" else "button primary",
      type = "button",
      "Submit"
    )
  )
}

#' Container for Output
#'
#' @description The output container is the target for the r function result.
#'
#' @param id The html-id for the output container
#' @param height The height for the plot
#' @param theme The CSS framework theme to use
#'
#' @return target div for the plot
#'
html_container_output <- function(id, height, theme = "bootstrap4") {
  div(
    style = paste0("height: ", height, "px;"),
    class = if (theme == "bootstrap4") "well" else "output-container",
    id = id
  )
}

#' Form Group To HTML
#'
#' @param g a form group list
#' @param id an id
#' @param theme CSS framework theme to use
#'
#' @return html
#'
fg_to_html <- function(g, id, theme = "bootstrap4") {
  f <- switch(g$fg,
    "text"     = fg_text,
    "number"   = fg_number,
    "dropdown" = fg_dropdown,
    stop(sprintf("Unknown form group type: %s", g$fg))
  )
  do.call(f, args = list(g = g, id = id, theme = theme))
}

#' Translate Form Group List to HTML
#'
#' @inheritParams fg_text
#'
#' @return html
#'
fg_number <- function(g, id, theme = "bootstrap4") {
  input <- tags$input(
    id    = id,
    class = if (theme == "bootstrap4") "form-control" else "input",
    type  = "number",
    min   = g$opts$from,
    max   = g$opts$to,
    step  = g$opts$step
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
fg_dropdown <- function(g, id, theme = "bootstrap4") {
  input <- tags$select(
    id = id,
    class = if (theme == "bootstrap4") "form-group form-control" else "select",
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
#' @param theme CSS framework theme to use
#'
#' @return html
#'
fg_text <- function(g, id, theme = "bootstrap4") {
  input <- tags$input(
    id    = id,
    class = if (theme == "bootstrap4") "form-control" else "input",
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
#' @return An object of class "appifyr_input" and "appifyr_text_input"
#' @export
#'
#' @examples
#' inp_text()
#' inp_text(label = "Plot Title")
#' inp_text(width = 6)
#' inp_text(label = "Description", width = 12)
#'
inp_text <- function(label = NULL, width = 4, ...) {
  if (!width %in% 1:12) {
    stop("'width' must be an integer between 1 and 12")
  }
  structure(
    list(
      fg    = "text",
      label = label,
      width = width,
      dots  = list(...)
    ),
    class = c("appifyr_input", "appifyr_text_input")
  )
}

#' Dropdown Input Form Group
#'
#' @param kv a vector, a list or a dataframe
#' @inheritParams inp_text
#'
#' @return An object of class "appifyr_input" and "appifyr_dropdown_input"
#' @export
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
  if (!width %in% 1:12) {
    stop("'width' must be an integer between 1 and 12")
  }
  
  if (missing(kv) || length(kv) == 0) {
    stop("'kv' must be provided and cannot be empty")
  }
  
  inp <- list(
    fg    = "dropdown",
    label = label,
    width = width,
    dots  = list(...)
  )
  
  if ("list" %in% class(kv)) {
    if (any(names(kv) == "")) {
      stop("All elements in 'kv' list must be named")
    }
    kv <- list_to_df(kv)
  } else if ("data.frame" %in% class(kv)) {
    if (!all(c("key", "value") %in% names(kv))) {
      stop("Dataframe 'kv' must have 'key' and 'value' columns")
    }
    kv <- df_to_df(kv)
  } else if (is_atomic(kv)) {
    kv <- atomic_to_df(kv)
  } else {
    stop("'kv' must be a vector, list, or dataframe")
  }
  
  inp$opts <- kv
  structure(inp, class = c("appifyr_input", "appifyr_dropdown_input"))
}

#' Number Input Form Group
#'
#' @param from a number
#' @param to  a number
#' @param step the step size for the number input
#' @inheritParams inp_text
#'
#' @return An object of class "appifyr_input" and "appifyr_number_input"
#' @export
#'
#' @examples
#' inp_number()
#' inp_number(from = 0, to = 1e9)
#' inp_number(from = 1, to = 7, label = "This Is A Survey")
#' inp_number(from = 0, to = 1, step = 0.1, label = "Probability")
#'
inp_number <- function(from = 0,
                       to = 100,
                       step = 1,
                       label = NULL,
                       width = 4,
                       ...) {
  if (!width %in% 1:12) {
    stop("'width' must be an integer between 1 and 12")
  }
  
  if (!is_scalar_atomic(from) || !is_scalar_atomic(to) || !is_scalar_atomic(step)) {
    stop("'from', 'to', and 'step' must be atomic scalar values")
  }
  
  if (from >= to) {
    stop("'from' must be less than 'to'")
  }
  
  if (step <= 0) {
    stop("'step' must be greater than 0")
  }

  structure(
    list(
      fg = "number",
      label = label,
      width = width,
      opts = list(
        from = as.double(from), 
        to = as.double(to),
        step = as.double(step)
      ),
      dots = list(...)
    ),
    class = c("appifyr_input", "appifyr_number_input")
  )
}

#' Convert Key Value List To Dataframe
#'
#' @param x a list
#'
#' @return a dataframe
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
df_to_df <- function(x) {
  tibble(key = factor_to_chr(x$key), value = factor_to_chr(x$value))
}

#' Convert Factor To Character
#'
#' @param x a vector
#'
#' @return a vector
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
args_to_json <- function(ans, id) {
  json_list <- map(ans, arg_to_json, id = id)
  as.character(paste0(json_list, collapse = ",\n"))
}
