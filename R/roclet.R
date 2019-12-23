
#' Use this roclet for roxygenlabs tags and extensions
#'
#' To use this `roxygenlabs_rd` roclet, add this to `DESCRIPTION`:
#'
#' ```
#' Roxygen: { library(roxygenlabs); list(markdown = TRUE,
#'     roclets = c("collate", "namespace", "roxygenlabs_rd")) }
#' ```
#'
#' @importFrom roxygen2 roclet
#' @export

roxygenlabs_rd <- function() {
  roclet(c("roxygenlabs_rd", "rd"))
}

#' @importFrom roxygen2 roclet_process
#' @export

roclet_process.roclet_roxygenlabs_rd <- function(x, blocks, env, base_path) {
  blocks <- lapply(blocks, rewrite_examples_if, env, base_path)
  NextMethod()
}

#' @importFrom roxygen2 roclet_output
#' @export

roclet_output.roclet_roxygenlabs_rd <- function(x, results, base_path, ...) {
  pkg <- roxy_meta_get("package")
  if (!is.null(pkg) && !is.null(roxy_themes[[pkg]])) {
    results <- lapply_with_names(results, add_styles)
  }
  results <- lapply_with_names(results, update_r6_examples, base_path)
  NextMethod()
}
