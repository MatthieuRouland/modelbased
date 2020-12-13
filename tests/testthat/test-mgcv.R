if (require("testthat") && require("modelbased") && require("mgcv") && require("emmeans")) {
  model <- mgcv::gam(Sepal.Length ~ Species + s(Sepal.Width, by = Species), data = iris)


  test_that("estimate_means - mgcv gam", {
    estim <- estimate_means(model)
    testthat::expect_equal(c(nrow(estim), ncol(estim)), c(3, 5))
  })

  test_that("estimate_contrasts - mgcv gam", {
    estim <- estimate_contrasts(model)
    testthat::expect_equal(c(nrow(estim), ncol(estim)), c(3, 10))
  })

  test_that("estimate_response - mgcv gam", {
    estim <- estimate_response(model)
    testthat::expect_equal(c(nrow(estim), ncol(estim)), c(150, 5))
  })

  test_that("estimate_link - mgcv gam", {
    estim <- estimate_link(model)
    testthat::expect_equal(c(nrow(estim), ncol(estim)), c(52, 5))
  })

  model <- mgcv::gam(Sepal.Length ~ Petal.Length + s(Sepal.Width) + s(Species, bs = "fs"), data = iris)
  # estim <- modelbased::estimate_link(model)

  model <- mgcv::gamm(Sepal.Length ~ Petal.Length + s(Sepal.Width), random = list(Species = ~1), data = iris)

  test_that("estimate_response - mgcv gamm", {
    estim <- estimate_response(model)
    testthat::expect_equal(c(nrow(estim), ncol(estim)), c(150, 5))
  })

  test_that("estimate_link - mgcv gamm", {
    estim <- estimate_link(model, length = 4)
    testthat::expect_equal(c(nrow(estim), ncol(estim)), c(16, 5))
  })


  # Gamm4 -------------------------------------------------------------------

  # model <- gamm4::gamm4(Sepal.Length ~ Petal.Length + s(Sepal.Width), random=~(1|Species), data = iris)
  #
  # test_that("estimate_response - gamm4", {
  #   estim <- estimate_response(model)
  #   testthat::expect_equal(c(nrow(estim), ncol(estim)), c(150, 5))
  # })
  #
  # test_that("estimate_link - gamm4", {
  #   estim <- estimate_link(model, length=4)
  #   testthat::expect_equal(c(nrow(estim), ncol(estim)), c(16, 5))
  # })
}