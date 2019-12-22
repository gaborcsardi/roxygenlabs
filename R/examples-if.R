
#' @importFrom roxygen2 roxy_tag_parse tag_examples
#' @export

roxy_tag_parse.roxy_tag_examplesIf <- function(x) {
  lines <- unlist(strsplit(x$raw, "\r?\n"))

  condition <- lines[1]
  tryCatch(
    suppressWarnings(parse(text = condition)),
    error = function(err) {
      roxygen2::roxy_tag_warning(x, "failed to parse condition of @examplesIf")
    }
  )

  dontshow <- paste0(
    "\\dontshow{if (",
    condition,
    ") (if (getRversion() >= \"3.4\") withAutoprint else force)(\\{ # examplesIf}"
  )

  x$raw <- paste(
    c(dontshow, lines[-1], "\\dontshow{\\}) # examplesIf}"),
    collapse = "\n"
  )

  x <- tag_examples(x)
}

#' @importFrom roxygen2 roxy_tag_rd rd_section
#' @export

roxy_tag_rd.roxy_tag_examplesIf <- function(x, base_path, env) {
  rd_section("examples", x$val)
}
