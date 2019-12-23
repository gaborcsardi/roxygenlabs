
#' Conditional examples
#'
#' @includeRmd man/chunks/examplesIf.Rmd
#' @name examplesIf
NULL

#' @importFrom roxygen2 roxy_tag_parse tag_examples roxy_tag_warning
#' @export

roxy_tag_parse.roxy_tag_examplesIf <- function(x) {
  lines <- unlist(strsplit(x$raw, "\r?\n"))

  condition <- lines[1]
  tryCatch(
    suppressWarnings(parse(text = condition)),
    error = function(err) {
      roxy_tag_warning(x, "failed to parse condition of @examplesIf")
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

#' @importFrom roxygen2 roxy_tag

rewrite_examples_if <- function(block, env, base_path) {
  if (! "R6ClassGenerator" %in% class(block$object$value)) return(block)
  block <- rewrite_text_srcrefs(block)
  ex <- Filter(function(x) x$tag %in% c("examples", "examplesIf"), block$tags)
  wexifs <- vapply(block$tags, function(x) x$tag == "examplesIf", TRUE)
  if (sum(wexifs) == 0) return(block)
  block$tags[wexifs] <- lapply(block$tags[wexifs], remove_condition)
  block$tags <- c(
    block$tags,
    list(roxy_tag("r6_examples_if", raw = "", val = ex))
  )
  block
}

#' @export

roxy_tag_rd.roxy_tag_r6_examples_if <- function(x, base_path, env) {
  rd_section("r6_examples_if", x$val)
}

#' @export

format.rd_section_r6_examples_if <- function(x, ...) {
  "<conditional rd examples>"
}

#' @importFrom utils head tail
#' @importFrom roxygen2 roxy_tag_warning

remove_condition <- function(tag) {
  tag$tag <- "examples"
  lines <- strsplit(tag$val, "\n", fixed = TRUE)[[1]]
  if (length(lines) < 2) {
    roxy_tag_warning(tag, "Corrupted tag?")
    return(tag)
  }
  lines <- tail(head(lines, -1), -1)
  tag$val <- paste(lines, collapse = "\n")
  tag
}

rewrite_text_srcrefs <- function(block) {
  if (length(block$tags) == 0) return(block)
  if (!identical(block$tags[[1]]$file, "<text>")) return(block)
  wr6 <- vapply(block$tags, "[[", "", "tag") == ".r6data"
  if (sum(wr6) == 0) return(block)
  block$tags[[which(wr6)[1]]]$val$self$file <- "<text>"
  block
}

update_r6_examples <- function(topic, base_path) {
  if (!topic$has_section("r6_examples_if")) return(topic)
  ex <- topic$sections$r6_examples_if$val
  topic$sections$r6_examples_if <- NULL
  topic$sections$examples <- NULL
  for (e in ex) {
    topic$add_section(roxy_tag_rd(e, base_path, env = emptyenv()))
  }
  topic
}
