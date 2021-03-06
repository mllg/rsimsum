context("pattern")
library(ggplot2)

test_that("pattern checks arguments properly", {
  data("MIsim", package = "rsimsum")
  data("frailty", package = "rsimsum")
  s <- simsum(data = MIsim, estvarname = "b", true = 0.5, se = "se", methodvar = "method", x = TRUE)
  sm <- multisimsum(data = frailty, par = "par", true = c(trt = -0.50, fv = 0.75), estvarname = "b", se = "se", methodvar = "model", x = TRUE)
  expect_error(pattern(obj = MIsim))
  expect_error(pattern(obj = s, gpars = list(wrong.parameter = 1)))
  expect_error(pattern(obj = sm, par = "hello"))
  expect_error(pattern(obj = sm, gpars = list(wrong.parameter = 1)))
})

test_that("pattern fails when simsum/multisimsum are called with x = FALSE", {
  data("MIsim", package = "rsimsum")
  s <- simsum(data = MIsim, estvarname = "b", true = 0.5, se = "se", methodvar = "method")
  data("frailty", package = "rsimsum")
  sm <- multisimsum(data = frailty, par = "par", true = c(trt = -0.50, fv = 0.75), estvarname = "b", se = "se", methodvar = "model")
  expect_error(pattern(s))
  expect_error(pattern(sm))
  expect_error(pattern(sm, par = "trt"))
})

test_that("pattern returns a ggplot object", {
  data("MIsim", package = "rsimsum")
  data("frailty", package = "rsimsum")
  s <- simsum(data = MIsim, estvarname = "b", true = 0.5, se = "se", methodvar = "method", x = TRUE)
  sm <- multisimsum(data = frailty, par = "par", true = c(trt = -0.50, fv = 0.75), estvarname = "b", se = "se", methodvar = "model", x = TRUE)
  expect_s3_class(pattern(s), class = c("gg", "ggplot"))
  expect_s3_class(pattern(sm), class = c("gg", "ggplot"))
  expect_s3_class(pattern(sm, par = "trt"), class = c("gg", "ggplot"))
})

test_that("pattern works when changing graphical parameters", {
  data("MIsim", package = "rsimsum")
  s <- simsum(data = MIsim, estvarname = "b", true = 0.5, se = "se", methodvar = "method", x = TRUE)
  pattern(s, gpars = list(alpha = 1))
  pattern(s, gpars = list(scales = "free_x"))
  data("frailty", package = "rsimsum")
  sm <- multisimsum(data = frailty, par = "par", true = c(trt = -0.50, fv = 0.75), estvarname = "b", se = "se", methodvar = "model", x = TRUE)
  pattern(sm, gpars = list(alpha = 1))
  pattern(sm, gpars = list(scales = "free_x"))
  pattern(sm, par = "trt", gpars = list(alpha = 1))
  pattern(sm, par = "trt", gpars = list(scales = "free_x"))
})

test_that("pattern with `by` factors", {
  data("relhaz", package = "rsimsum")
  s <- simsum(data = relhaz, estvarname = "theta", true = -0.5, se = "se", methodvar = "model", by = c("n", "baseline"), x = TRUE)
  pattern(s)
  pattern(s, gpars = list(scales = "free_x"))
  data("frailty", package = "rsimsum")
  sm <- multisimsum(data = frailty, par = "par", true = c(trt = -0.50, fv = 0.75), estvarname = "b", se = "se", methodvar = "model", by = "fv_dist", x = TRUE)
  pattern(sm)
})

test_that("pattern produces a proper colour scale when methodvar is not a factor", {
  data("MIsim", package = "rsimsum")
  MIsim$method <- as.numeric(as.factor(MIsim$method))
  s <- simsum(data = MIsim, estvarname = "b", true = 0.5, se = "se", methodvar = "method", x = TRUE)
  pattern(s)
})
