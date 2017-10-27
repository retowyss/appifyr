#' Create App
#'
#' @return project directory is set up
#' @export
#'
#' @importFrom magrittr %>%
#' @importFrom readr read_file write_file
#'
create_app <- function() {

  write_file("^app$\n", ".Rbuildignore", append = TRUE)

  dir.create("inst/www", recursive = TRUE)
  dir.create("app")

  system.file("rmd/website/", package = "appifyr") %>%
    file.copy("app", recursive = TRUE)

  if(file.exists("R/hello.R")) file.remove("R/hello.R")

  invisible()
}

#' To R Code
#'
#' @description Translate Rmd code into package code.
#'
#' @return R/your_r_code.R file
#'
#' @importFrom magrittr %>%
#' @importFrom purrr map reduce flatten as_vector pmap
#' @importFrom tibble tibble
#' @importFrom stringr str_extract_all str_extract str_replace str_to_title
#' @importFrom glue glue
#' @importFrom readr read_file write_file
#'
to_r_code <- function() {
  app_rmd <- grab_app_rmd()
  rfregex <- "\\n[a-zA-Z\\.]{1}.*(\\<\\-|\\=)[:blank:]*function\\(.*\\)[:blank:]*(\\n|.|)*?\\n\\}"
  roxygen_skeleton <- read_file(system.file("roxygen_skeleton/roxygen_skeleton.txt", package = "appifyr"))

  imports <- app_rmd %>%
    map(str_extract_all, pattern = c("library\\(.*\\)", "require\\(.*\\)") ) %>%
    flatten() %>%
    flatten() %>%
    map(str_replace, pattern = "^.{8}", replacement = "") %>%
    map(str_replace, pattern = ".{1}$", replacement = "") %>%
    as_vector() %>%
    unique() %>%
    setdiff("appifyr") %>%
    glue("#' @import {package}", package = .) %>%
    reduce(~ glue("{.x}\n{.y}"))

  r_code <- app_rmd %>%
    map(str_extract_all, pattern = rfregex) %>%
    flatten() %>%
    flatten() %>%
    as_vector() %>%
    tibble(code = .) %>%
    mutate(
      title = str_extract(code, "[a-zA-Z\\.]{1}.*? ") %>%
        str_replace("_", " ") %>%
        str_to_title()
    ) %>%
    pmap(function(code, title) {
      glue(roxygen_skeleton)
    })

  if(file.exists("R/your_r_code.R")) file.remove("R/your_r_code.R")
  map(r_code, write_file, "R/your_r_code.R", append = TRUE)

  invisible()
}

#' Build App
#'
#' @return invisible
#' @export
#'
#' @importFrom rmarkdown render_site
#' @importFrom devtools document install
#' @import roxygen2
#'
build_app <- function() {
  render_site(input = 'app/website/')
  to_r_code()
  if(file.exists("NAMESPACE")) file.remove("NAMESPACE")
  document(roclets=c('rd', 'collate', 'namespace', 'vignette'))
  install()
  invisible()
}

#' Grab App Rmd
#'
#' @return list of Rmd contents
#'
#' @importFrom readr read_file
#' @importFrom purrr map
#'
grab_app_rmd <- function() {
  app_dir <- "app/website/"
  map(paste0(app_dir, dir(app_dir, pattern = ".*\\.Rmd$")), read_file)
}
