#' Create a Random Id
#'
#' @description Creates a random identifier from a-zA-Z. This function
#'   is used internally to generate unique identifiers for HTML elements.
#'
#' @param n Length of the id (default: 10)
#' @param prefix Optional prefix to add to the random ID
#'
#' @return A random id string
#' @export
#' @examples
#' \dontrun{
#' create_id()
#' create_id(15)
#' create_id(8, prefix = "app_")
#' }
#'
create_id <- function(n = 10, prefix = "") {
  if (!is.numeric(n) || n <= 0 || n != as.integer(n)) {
    stop("'n' must be a positive integer")
  }
  
  if (!is.character(prefix)) {
    stop("'prefix' must be a character string")
  }
  
  # Generate a random ID using letters and numbers
  random_part <- paste0(
    sample(c(letters, LETTERS, 0:9), n, replace = TRUE),
    collapse = ""
  )
  
  paste0(prefix, random_part)
}

#' Ensure Id Postfix
#'
#' @description Ensures that an ID postfix is available, either using
#'   the provided value or generating a random one.
#'
#' @param postfix Character string when set by user, else NULL
#'
#' @return The postfix or a random postfix
#' @export
#' @examples
#' \dontrun{
#' # Returns a random ID
#' ensure_id_postfix(NULL)
#' 
#' # Returns "myid"
#' ensure_id_postfix("myid")
#' }
#'
ensure_id_postfix <- function(postfix) {
  if (!is.null(postfix)) {
    if (!is.character(postfix) || length(postfix) != 1 || nchar(postfix) == 0) {
      stop("'postfix' must be NULL or a non-empty character string")
    }
    return(postfix)
  }
  
  create_id()
}
