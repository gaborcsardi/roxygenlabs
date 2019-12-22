
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
