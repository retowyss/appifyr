#' Argument To JSON
#'
#' @param an argument name, e.g. "n"
#' @param id html id
#'
#' @return json body code,
#' @export
#'
#' @importFrom magrittr %>%
#' @importFrom readr read_file
#' @importFrom glue glue
#'
#' @examples
#'
#' arg_to_json("n", "xGkrZCuuI")
#'
arg_to_json <- function(an, id) {
  system.file("js/glue/json.js", package = "appifyr") %>%
    read_file() %>%
    glue(
      .open = "<<",
      .close = ">>",
      an = an,
      id = id
    ) %>%
    as.character()
}

#' Arguments To JSON
#'
#' @param ans argument names
#' @param id html identifier
#'
#' @return json body code
#' @export
#'
#' @importFrom magrittr %>%
#' @importFrom purrr map
#' @importFrom glue collapse
#'
#' @examples
#' args_to_json(list("n", "mean", "sd"), "xGkrZCuuI")
#'
args_to_json <- function(ans, id) {
  ans %>%
    map(arg_to_json, id = id) %>%
    collapse(sep = ",\n") %>%
    as.character()
}
