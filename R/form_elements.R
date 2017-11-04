#' Text Form Group
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
inp_text <- function(label = NULL, width = 4, ...) {
  stopifnot(width %in% 1:12)
  list(
    fg    = "text",
    label = label,
    width = width,
    dots  = list(...)
  )
}

#' Dropdown Form Group
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
inp_dropdown <- function(kv,
                         label = NULL,
                         width = 4,
                         ...) {
  inp <- inp_text(label = label, width = width, ...)
  if ("list" == class(kv)) {
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

#' Number Form Group
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
  inp$opts <- list(
    from = as.double(from),
    to = as.double(to)
  )
  inp
}

#' Convert Key Value List To Dataframe
#'
#' @param x a list
#'
#' @return a dataframe
#'
#' @importFrom magrittr %>%
#' @importFrom purrr imap reduce
#' @importFrom dplyr bind_rows
#' @importFrom tibble tibble
#'
list_to_df <- function(x) {
  x %>%
    imap(function(.x, .y) {
      tibble(
        key = factor_to_chr(.y),
        value = factor_to_chr(.x)
      )
    }) %>%
    reduce(bind_rows)
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
#' @importFrom rlang as_double
#'
factor_to_chr <- function(x) {
  if(is.factor(x) | is.character(x)) {
    as.character(x)
  } else {
    as_double(x)
  }
}
