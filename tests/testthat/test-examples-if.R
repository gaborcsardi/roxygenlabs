
test_that("@examplesIf", {
  out <- roxygen2::roc_proc_text(roxygen2::rd_roclet(), "
    #' @name a
    #' @title a
    #' @examplesIf foo::bar()
    #' maybe-run-this-code
    #' @examplesIf foobar()
    #' and-this
    NULL")[[1]]

  verify_output(test_path("test-rd-examplesIf.txt"), {
    out$get_section("examples")
  })
})

test_that("@examplesIf and R6", {
  results <- roxygen2::roc_proc_text(roxygenlabs_rd(), "
    #' This is an R6 class
    #' @examplesIf foo::bar()
    #' maybe-run-this-code
    #' @examples
    #' unconditional class example
    A <- R6::R6Class(NA,
      public = list(
        #' @description Method 1.
        #' @return Nothing.
        #' @examplesIf cond()
        #' maybe-method-example1
        #' @examples
        #' unconditional method example
        method1 = function() { }
      )
    )
    ")

  tmp <- tempfile()
  on.exit(unlink(tmp, recursive = TRUE), add = TRUE)
  dir.create(tmp)
  dir.create(file.path(tmp, "man"))
  capture_output(
    rdf <- roxygen2::roclet_output(roxygenlabs_rd(), results, base_path = tmp)
  )
  verify_output(test_path("test-rd-examplesIf-R6.txt"), {
    cat(readChar(rdf, n = file.info(rdf)$size, useBytes = TRUE))
  })
})
