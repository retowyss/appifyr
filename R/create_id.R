#' Create a Random Id
#'
#' @param n Length of the id (default: 32)
#'
#' @return a random id
#' @export
#'
#' @importFrom purrr reduce
#'
#' @examples
#'
#' id <- create_id()
#'
#' my_id <- create_id(42)
#'
create_id <- function(n = 32) {
  c(letters, LETTERS) %>%
    sample(n, replace = T) %>%
    reduce(paste0)
}
