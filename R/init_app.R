# nocov start
#' Build App
#'
#' @param app_dir path to the app (default: app/website)
#' @return invisible
#' @importFrom devtools document install
#' @importFrom rmarkdown render_site
#' @export
#'
#'

build_app <- function(app_dir = "app/website") {
  rmarkdown::render_site(input = app_dir)
  if (file_exists("NAMESPACE")) {
    file_delete("NAMESPACE")
  }
  devtools::document(roclets = c('rd', 'collate', 'namespace', 'vignette'))
  devtools::install()
  invisible()
}
