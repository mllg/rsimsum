#' @title get_data.multisimsum
#' @description Extract data from a multisimsum object
#' @param x An object of class `multisimsum`.
#' @param sstat Summary statistics to include; can be a scalar value or a vector. Possible choices are:
#' * `all`, all the summary statistics are returned This is the default option.
#' * `nsim`, the number of replications with non-missing point estimates and standard error.
#' * `thetamean`, average point estimate.
#' * `thetamedian`, median point estimate.
#' * `se2mean`, average standard error.
#' * `se2median`, median standard error.
#' * `bias`, bias in point estimate.
#' * `empse`, empirical standard error.
#' * `mse`, mean squared error.
#' * `relprec`, percentage gain in precision relative to the reference method.
#' * `modelse`, model-based standard error.
#' * `relerror`, relative percentage error in standard error.
#' * `cover`, coverage of a nominal `level`\% confidence interval.
#' * `bccover`, bias corrected coverage of a nominal `level`\% confidence interval.
#' * `power`, power of a (1 - `level`)\% level test.#'
#' @param ... Ignored.
#' @return A `data.frame` containing summary statistics from a simulation study.
#' @seealso [multisimsum()], [get_data()]
#' @export
#'
#' @examples
#' data(frailty)
#' ms <- multisimsum(data = frailty, par = "par", true = c(trt = -0.50,
#'    fv = 0.75), estvarname = "b", se = "se", methodvar = "model",
#'    by = "fv_dist")
#' get_data(ms)
get_data.multisimsum <- function(x, sstat = "all", ...) {
  ### Check arguments
  arg_checks <- checkmate::makeAssertCollection()

  # `sstat` must be one of the possible choices
  checkmate::assert_subset(sstat, choices = c("all", "nsim", "thetamean", "thetamedian", "se2mean", "se2median", "bias", "empse", "mse", "relprec", "modelse", "relerror", "cover", "bccover", "power"), add = arg_checks)

  ### Report if there are any errors
  if (!arg_checks$isEmpty()) checkmate::reportAssertions(arg_checks)

  ### Select only summary statistics on interest
  if (!("all" %in% sstat)) {
    x$summ <- x$summ[x$summ$stat %in% sstat, ]
  }

  ### Return data
  x$summ
}
