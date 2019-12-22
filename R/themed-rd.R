
foo <- function(arg, ...) UseMethod("foo")

#' @export

foo.bar <- function(...) print("foo.bar")

roxy_themes <- new.env(parent = emptyenv())

#' @importFrom roxygen2 roxy_tag_parse roxy_meta_get
#' @export

roxy_tag_parse.roxy_tag_theme <- function(x) {
  theme_files <- strsplit(x$raw, " ", fixed = TRUE)[[1]]
  lapply(theme_files, function(f) {
    if (!file.exists(file.path("inst", "doc", f))) {
      roxy_warning("Roxygen theme file does not exist: '", f, "'")
    }
  })
  roxy_themes[[roxy_meta_get("package")]] <- theme_files
  NULL
}

#' Theme R manual pages with roxygen2
#'
#' This roclet allows adding CSS and JS files to the HTML version of the
#' manual pages.
#'
#' To use this roclet, you need to add this to `DESCRIPTION`:
#'
#' ```
#' Roxygen: { library(roxygenlabs); list(markdown = TRUE,
#'     roclets = c("collate", "namespace", "themed_rd")) }
#' ```
#'
#' and then use the `@theme` tag to add CSS/JS files to _all_ manual pages.
#' Multiple file names can be specicified in a single `@theme` tag, and
#' file names are relative to the `inst/doc` directory, within the package.
#'
#' @param test This is a test.
#'
#' @return Roxygen roclet.
#'
#' @importFrom roxygen2 roclet
#' @export

themed_rd <- function(test) {
  roclet(c("themed_rd", "rd"))
}

#' @importFrom roxygen2 roclet_output
#' @export

roclet_output.roclet_themed_rd <- function(x, results, base_path, ...) {
  results <- lapply_with_names(results, add_styles)
  NextMethod()
}

`%||%` <- function(l, r) if (is.null(l)) r else l

lapply_with_names <- function(X, FUN, ...) {
  structure(
    lapply(X, FUN, ...),
    names = names(X) %||% (if (is.character(X)) X)
  )
}

#' @importFrom roxygen2 rd_section

add_styles <- function(page) {
  page$add_section(rd_section("description", style_man()))
  page
}

#' @importFrom roxygen2 roxy_meta_get

style_man <- function() {
  pkg <- roxy_meta_get("package")
  theme_files <- roxy_themes[[pkg]]
  if (length(theme_files) == 0) {
    roxy_warning("No @theme tags for 'theme_rg' roclet")
    return()
  }

  links <- vapply(theme_files, FUN.VALUE = "", function(f) {
    if (grepl("\\.css$", f)) {
      paste0('<link rel="stylesheet" type="text/css" href="../doc/', f, '">')
    } else if (grepl("\\.js$", f)) {
      paste0('<script src="../doc/', f, '"></script>')
    } else {
      roxy_warning("Unknown roxygen theme file type: '", f, "'")
      ""
    }
  })

  do.call("paste0", list("\\if{html}{\\out{", links, "}}"))
}

roxy_warning <- function (..., file = NA, line = NA) {
  message <- paste0(
    if (!is.na(file)) paste0("[", file, ":", line, "] "),
    ...,
    collapse = " "
  )
  warning(message, call. = FALSE, immediate. = TRUE)
}
