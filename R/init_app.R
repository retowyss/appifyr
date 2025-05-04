# nocov start
#' Build and Install an appifyr Application
#'
#' This function builds an appifyr application by rendering the R Markdown site,
#' documenting the package, and installing it for use with OpenCPU.
#'
#' @param app_dir Path to the app directory (default: "app/website")
#' @param document Logical; whether to run roxygen2 documentation (default: TRUE)
#' @param install Logical; whether to install the package (default: TRUE)
#' @param quiet Logical; whether to suppress output messages (default: FALSE)
#'
#' @return Invisibly returns TRUE if successful
#' @importFrom devtools document install
#' @importFrom rmarkdown render_site
#' @importFrom fs file_exists file_delete
#' @export
#'
#' @examples
#' \dontrun{
#' # Build the app with default settings
#' build_app()
#'
#' # Build without installing
#' build_app(install = FALSE)
#'
#' # Build a specific app directory
#' build_app("my_custom_app/website")
#' }
build_app <- function(app_dir = "app/website", 
                     document = TRUE,
                     install = TRUE,
                     quiet = FALSE) {
  
  # Validate inputs
  if (!is.character(app_dir) || length(app_dir) != 1) {
    stop("'app_dir' must be a single character string")
  }
  
  if (!dir.exists(app_dir)) {
    stop(sprintf("App directory '%s' does not exist", app_dir))
  }
  
  # Render the R Markdown site
  message("Rendering R Markdown site in ", app_dir, "...")
  site_result <- try(rmarkdown::render_site(input = app_dir, quiet = quiet), silent = TRUE)
  
  if (inherits(site_result, "try-error")) {
    warning("Failed to render site: ", attr(site_result, "condition")$message)
  }
  
  # Document the package if requested
  if (document) {
    message("Documenting package...")
    
    # Delete NAMESPACE if it exists to allow roxygen2 to regenerate it
    if (fs::file_exists("NAMESPACE")) {
      fs::file_delete("NAMESPACE")
    }
    
    # Run documentation
    doc_result <- try(
      devtools::document(roclets = c('rd', 'collate', 'namespace', 'vignette'), quiet = quiet),
      silent = TRUE
    )
    
    if (inherits(doc_result, "try-error")) {
      warning("Failed to document package: ", attr(doc_result, "condition")$message)
    }
  }
  
  # Install the package if requested
  if (install) {
    message("Installing package...")
    install_result <- try(devtools::install(quiet = quiet), silent = TRUE)
    
    if (inherits(install_result, "try-error")) {
      warning("Failed to install package: ", attr(install_result, "condition")$message)
      return(invisible(FALSE))
    }
  }
  
  message("Build completed successfully")
  invisible(TRUE)
}
# nocov end
