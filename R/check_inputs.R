#' Check Arguments
#'
#' @description Check the actual inputs of a function against the provided
#'     inputs for the form inputs. If inputs do not match then a
#'     helpful message will be displayed. Returns invisible otherwise.
#'
#' @param f A function
#' @param input_names Vector of input names
#'
#' @return
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
#' # This fails
#' check_inputs(rnorm, c("n", "mean", "q"))
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
