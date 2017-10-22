#' Check Arguments
#'
#' @description Check the actual inputs of a function against the provided
#'     inputs for the form inputs. If inputs do not match then a
#'     helpful message will be displayed. Returns invisible otherwise.
#'
#' @param f A function
#' @param input_names Vector of input names
#'
#' @return invisible or error
#' @export
#'
#' @importFrom methods formalArgs
#' @importFrom glue glue
#' @importFrom purrr reduce
#'
#' @examples
#'
#' # This passes
#' check_inputs(rnorm, c("n", "mean", "sd"))
#' check_inputs(rnorm, c("n"))
#'
check_inputs <- function(f, input_names) {
  if(!all(input_names %in% formalArgs(f))) {
    function_inputs <- f %>%
      formals() %>%
      names() %>%
      reduce(paste, sep = ", ")
    input_names_str <- reduce(input_names, paste, sep = ", ")
    m <- glue("
         The arguments ({input_names_str}) you specified \\
         do not match the arguments to \\
         your function ({function_inputs})!
         ")
    message(m)
    stop()
  } else {
    invisible()
  }
}

#' Ensure Id Postfix
#'
#' @param postfix charchter when set by user else NULL
#'
#' @return the postfix or a random postfix
#' @export
#'
#' @importFrom purrr is_null is_scalar_atomic
#'
ensure_id_postfix <- function(postfix) {
  stopifnot(is_null(postfix) | is_scalar_atomic(postfix) & length(postfix) > 0)
  if(is_null(postfix)) {
    create_id()
  } else {
    postfix
  }
}
