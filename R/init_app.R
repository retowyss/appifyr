#' Create App
#'
#' @return project directory is set up
#' @export
#'
#' @importFrom magrittr %>%
#' @importFrom readr read_file write_file
#'
create_app <- function(template = "website") {
  write_file("^app$\n", ".Rbuildignore", append = TRUE)
  dir.create("inst/www", recursive = TRUE)
  dir.create("app")
  system.file(paste0("rmd/", template, "/"), package = "appifyr") %>%
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

  roxygen_skeleton <- read_file(system.file("txt/roxygen_skeleton.txt", package = "appifyr"))

  imports <- app_rmd %>%
    map(extract_pkgs) %>%
    flatten() %>%
    flatten() %>%
    map(extract_pkg_names) %>%
    as_vector() %>%
    unique() %>%
    setdiff("appifyr") %>%
    glue("#' @import {package}", package = .) %>%
    reduce(~ glue("{.x}\n{.y}"))

  r_code <- app_rmd %>%
    map(extract_r_functions) %>%
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
build_app <- function(app_dir = "app/website/") {
  render_site(input = app_dir)
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
grab_app_rmd <- function(app_dir = "app/website/") {
  map(paste0(app_dir, dir(app_dir, pattern = ".*\\.Rmd$")), read_file)
}


#' Extract R functions from Rmd
#'
#' @param rmd
#'
#' @return list of R functions
#' @export
#'
#' @importFrom stringr str_extract_all
#'
extract_r_functions <- function(rmd) {
  rfrx <- "\\n[a-zA-Z\\.]{1}.*(\\<\\-|\\=)[:blank:]*function\\(.*\\)[:blank:]*(\\n|.|)*?\\n\\}"
  str_extract_all(rmd, pattern = rfrx)
}

#' Extract the package name
#'
#' @param pkgs "library(pkg)" or "require(pkg)"
#'
#' @return a package name, e.g. dplyr
#' @export
#'
#' @importFrom stringr str_replace
#'
extract_pkg_names <- function(pkg) {
  pkg <- str_replace(pkg, pattern = "^.{8}", replacement = "")
  str_replace(pkg, pattern = ".{1}$", replacement = "")
}


#' Extract packages
#'
#' @param rmd
#'
#' @return require(pkg) or library(pkg)
#' @export
#'
extract_pkgs <- function(rmd) {
  str_extract_all(rmd, pattern = c("library\\(.*\\)", "require\\(.*\\)"))
}
