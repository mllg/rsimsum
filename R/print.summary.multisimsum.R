#' @title print.summary.multisimsum
#' @description Print method for summary.multisimsum objects
#' @param x An object of class `summary.multisimsum`.
#' @param digits Number of significant digits used for printing. Defaults to 4.
#' @param sstat Summary statistics to print; can be a scalar value or a vector (for printing multiple summary statistics at once). Possible choices are:
#' * `all`, all the summary statistics are printed. This is the default option.
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
#' * `power`, power of a (1 - `level`)\% level test.
#' @param ... Ignored.
#' @note If `sstat` is a vector that contains `all`, all summary statistics are printed by default.
#' @export
#'
#' @examples
#' data(frailty)
#' ms <- multisimsum(data = frailty, par = "par", true = c(trt = -0.50,
#'    fv = 0.75), estvarname = "b", se = "se", methodvar = "model",
#'    by = "fv_dist")
#' sms <- summary(ms)
#' sms
print.summary.multisimsum <- function(x, digits = 4, sstat = "all", ...) {
  ### Check arguments
  arg_checks <- checkmate::makeAssertCollection()

  # `digits` must be an integer value greater than or equal to zero
  checkmate::assert_int(digits, lower = 0, upper = Inf, add = arg_checks)

  # `sstat` must be one of the possible choices
  checkmate::assert_subset(sstat, choices = c("all", "nsim", "thetamean", "thetamedian", "se2mean", "se2median", "bias", "empse", "mse", "relprec", "modelse", "relerror", "cover", "bccover", "power"), add = arg_checks)

  ### Report if there are any errors
  if (!arg_checks$isEmpty()) checkmate::reportAssertions(arg_checks)

  ### Print call to `simsum`
  cat("\nCall:\n\t", paste(deparse(x$call), sep = "\n", collapse = "\n"), "\n", sep = "")

  ### Print `par`, possible estimands
  cat("\nEstimands variable:", x$par, "\n")
  estimands <- unique(x$summ[[x$par]])
  cat("\tUnique estimands:", paste(estimands, collapse = ", "), "\n")
  cat("\tTrue values:", paste(estimands, "=", x$true[estimands], collapse = ", "), "\n")

  ### Print `methodvar` (if any), possible methods, and reference method
  if (!is.null(x$methodvar)) {
    cat("\nMethod variable:", x$methodvar, "\n")
    methods <- unique(x$summ[[x$methodvar]])
    cat("\tUnique methods:", paste(methods, collapse = ", "), "\n")
    cat("\tReference method:", x$ref, "\n")
  } else {
    cat("\nMethod variable: none\n")
  }

  ### Print `by` factors (if any)
  if (!is.null(x$by)) {
    cat("\nBy factors:", paste(x$by, collapse = ", "), "\n")
  } else {
    cat("\nBy factors: none\n")
  }

  ### Select only summary statistics on interest
  if (!("all" %in% sstat)) {
    x$summ <- x$summ[x$summ$stat %in% sstat, ]
  }

  ### Format summary table
  x <- format(x = x, digits = digits)

  ### Make names of the summary table
  names(x$summ)[names(x$summ) == "stat"] <- " "
  names(x$summ)[names(x$summ) == "est"] <- "Estimate"
  if (x$mcse) {
    names(x$summ)[names(x$summ) == "mcse"] <- "MCSE"
    names(x$summ)[names(x$summ) == "lower"] <- paste("Lower", sprintf("%.0f%%", 100 * (x$ci_level)))
    names(x$summ)[names(x$summ) == "upper"] <- paste("Upper", sprintf("%.0f%%", 100 * (x$ci_level)))
  }

  ### Print pretty summary
  par_split <- split(x$summ, f = lapply(x$par, function(f) x$summ[[f]]))
  for (i in seq_along(par_split)) {
    par_split[[i]][[x$par]] <- NULL
    cat("\n", paste(rep("-", options()$width), collapse = ""), "\n")
    cat(paste0("\nSummary statistics for estimand '", names(par_split)[i], "':\n", collapse = ""))
    if (is.null(x$by) & is.null(x$methodvar)) {
      print(par_split[[i]], row.names = FALSE)
    } else if (is.null(x$by) & !is.null(x$methodvar)) {
      methodvar_split <- split(par_split[[i]], f = lapply(x$methodvar, function(f) par_split[[i]][[f]]))
      methodvar_split <- lapply(methodvar_split, function(w) {
        w[[x$methodvar]] <- NULL
        w
      })
      names(methodvar_split) <- methods
      for (i in methods) {
        cat("\n\tMethod =", i, "\n")
        print(methodvar_split[[i]], row.names = FALSE)
      }
    } else if (!is.null(x$by) & is.null(x$methodvar)) {
      by_split <- split(par_split[[i]], f = lapply(x$by, function(f) par_split[[i]][[f]]))
      for (i in seq_along(by_split)) {
        cat("\n\t", paste(paste(x$by, unlist(strsplit(names(by_split)[i], ".", fixed = TRUE)), sep = " = "), collapse = ", "), "\n")
        print(by_split[[i]], row.names = FALSE)
      }
    } else {
      by_split <- split(par_split[[i]], f = lapply(x$by, function(f) par_split[[i]][[f]]))
      for (i in seq_along(by_split)) {
        for (w in x$by) {
          by_split[[i]][[w]] <- NULL
        }
        methodvar_split <- split(by_split[[i]], f = lapply(x$methodvar, function(f) by_split[[i]][[f]]))
        methodvar_split <- lapply(methodvar_split, function(w) {
          w[[x$methodvar]] <- NULL
          w
        })
        names(methodvar_split) <- methods
        for (j in methods) {
          cat(paste0("\n\tMethod = ", j, ","), paste(paste(x$by, unlist(strsplit(names(by_split)[i], ".", fixed = TRUE)), sep = " = "), collapse = ", "), "\n")
          print(methodvar_split[[j]], row.names = FALSE)
        }
      }
    }
  }
}
