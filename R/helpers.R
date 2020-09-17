#' Create a Random Id
#'
#' @description Creates a random identifier from a-zA-Z.
#'
#' @param n Length of the id (default: 32)
#'
#' @return a random id
#'
create_id <- function(n = 32) {
  reduce(sample(c(letters, LETTERS), n, replace = T), paste0)
}

#' Ensure Id Postfix
#'
#' @param postfix charchter when set by user else NULL
#'
#' @return the postfix or a random postfix
#'
ensure_id_postfix <- function(postfix) {
  stopifnot(is_null(postfix) | is_scalar_atomic(postfix) & nchar(postfix) > 0)
  if (is_null(postfix)) {
    create_id()
  } else {
    postfix
  }
}
