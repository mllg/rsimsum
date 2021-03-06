% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/print.summary.multisimsum.R
\name{print.summary.multisimsum}
\alias{print.summary.multisimsum}
\title{print.summary.multisimsum}
\usage{
\method{print}{summary.multisimsum}(x, digits = 4, sstat = "all", ...)
}
\arguments{
\item{x}{An object of class \code{summary.multisimsum}.}

\item{digits}{Number of significant digits used for printing. Defaults to 4.}

\item{sstat}{Summary statistics to print; can be a scalar value or a vector (for printing multiple summary statistics at once). Possible choices are:
\itemize{
\item \code{all}, all the summary statistics are printed. This is the default option.
\item \code{nsim}, the number of replications with non-missing point estimates and standard error.
\item \code{thetamean}, average point estimate.
\item \code{thetamedian}, median point estimate.
\item \code{se2mean}, average standard error.
\item \code{se2median}, median standard error.
\item \code{bias}, bias in point estimate.
\item \code{empse}, empirical standard error.
\item \code{mse}, mean squared error.
\item \code{relprec}, percentage gain in precision relative to the reference method.
\item \code{modelse}, model-based standard error.
\item \code{relerror}, relative percentage error in standard error.
\item \code{cover}, coverage of a nominal \code{level}\% confidence interval.
\item \code{bccover}, bias corrected coverage of a nominal \code{level}\% confidence interval.
\item \code{power}, power of a (1 - \code{level})\% level test.
}}

\item{...}{Ignored.}
}
\description{
Print method for summary.multisimsum objects
}
\note{
If \code{sstat} is a vector that contains \code{all}, all summary statistics are printed by default.
}
\examples{
data(frailty)
ms <- multisimsum(data = frailty, par = "par", true = c(trt = -0.50,
   fv = 0.75), estvarname = "b", se = "se", methodvar = "model",
   by = "fv_dist")
sms <- summary(ms)
sms
}
