# nocov start
#' Build App
#'
#' @param app_dir path to the app (default: app/website)
#'
#' @return invisible
#' @export
#'
#'

build_app <- function(app_dir = "app/website") {
  render_site(input = app_dir)
  if (file_exists("NAMESPACE")) {
    file_delete("NAMESPACE")
  }
  document(roclets = c('rd', 'collate', 'namespace', 'vignette'))
  install()
  invisible()
}
