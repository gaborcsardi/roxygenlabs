
<!-- README.md is generated from README.Rmd. Please edit that file -->

# roxygenlabs

> Experimental ‘roxygen’ Tags and Extensions

[![Linux Build
Status](https://travis-ci.org/gaborcsardi/roxygenlabs.svg?branch=master)](https://travis-ci.org/gaborcsardi/roxygenlabs)
[![Windows Build
status](https://ci.appveyor.com/api/projects/status/github/gaborcsardi/roxygenlabs?svg=true)](https://ci.appveyor.com/project/gaborcsardi/roxygenlabs)
[![](http://www.r-pkg.org/badges/version/roxygenlabs)](http://www.r-pkg.org/pkg/roxygenlabs)
[![CRAN RStudio mirror
downloads](http://cranlogs.r-pkg.org/badges/roxygenlabs)](http://www.r-pkg.org/pkg/roxygenlabs)

Experimental ‘roxygen’ Tags and Extensions

## Installation

Once on CRAN, install the package with

``` r
install.packages("roxygenlabs")x
```

## Usage

Currently there is no official way to load a package when running
`devtools::document()` or `roxygen2::roxygenize()`, but you can use a
trick: put the package loading code into the `Roxygen` field in
`DESCRIPTION`:

    Roxygen: { library(roxygenlabs); list(markdown = TRUE) }

### Conditional examples

The `@examplesIf` tag implements conditional examples, that do not run
when running `example()` and `R CMD check`, unless some condition holds.
You can use this mechanism to avoid running some examples on CRAN and/or
during `R CMD check`, without adding boilerplate code to the examples
themselves. The following example only runs if the computer is online:

    #' @examplesIf curl::has_internet()
    #' curl::curl_fetch_memory("https://httpbin.org/status/200")

If you never want to run an example, use `FALSE` as the condition. This
makes sense for examples that take a very long time to run:

    #' @examplesIf FALSE
    #' some very long running computation...

### CSS and Javascript themes

The `@theme` tag allows adding CSS and JS files to the HTML version of
the manual pages.

To support `@theme`, you need to use the `roxygenlabs_rd` roclet. E.g.
add this to `DESCRIPTION`:

    Roxygen: { library(roxygenlabs); list(markdown = TRUE,
        roclets = c("collate", "namespace", "roxygenlabs_rd")) }

and then use the `@theme` tag to add CSS/JS files to *all* manual pages.
Multiple file names can be specicified in a single `@theme` tag, and
file names are relative to the `inst/doc` directory, within the package:

    #' @theme assets/extra.css assets/rd.js

See the `assets/extra.css` and `assets/rd.js` files, included in the
package, for an example CSS/JS theme that has the following changes
compared to plain Rd documentation:

  - R code is syntax-highlighted. This includes R code in the “Usage”
    and “Examples” sections, R code created via “r” fences in roxygen’s
    markdown, and R code chunks produced by roxygen’s `@includeRmd` tag.
  - Add a “Copy” button to R code chunks, to copy them to the clipboard.
  - Headings have a new style, including a serif font.
  - More spacious formatting of arguments and list.
  - Restrict the width of the manual page, to avoid very long lines.

## License

MIT © RStudio
