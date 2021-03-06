#' @title print.dropbig.multisimsum
#' @description Print method for dropbig.simsum objects
#' @param x An object of class `dropbig.multisimsum`.
#' @param ... Ignored.
#' @export
#' @seealso [dropbig.multisimsum()]

print.dropbig.multisimsum <- function(x, ...) {
  if (!is.null(x)) {
    if (nrow(x$big_estvarname) > 0) {
      cat("Dropped point estimates:\n")
      print(x$big_estvarname, row.names = FALSE)
    } else {
      cat("No point estimates were dropped, all were within the limits defined by `max`\n")
    }

    if (nrow(x$big_se) > 0) {
      names(x$big_se) <- c("Row number", "SE")
      print(x$big_se, row.names = FALSE)
    } else {
      cat("\nNo standard errors estimates were dropped, all were within the limits defined by `semax`\n")
    }
  }
}
