#' Estimate contrasts
#'
#'
#' @inheritParams estimate_contrasts.stanreg
#' @inheritParams estimate_means.lm
#' @param adjust The p-values adjustment method for multi-comparisons. Can be
#'   one of "holm" (default), "tukey", "hochberg", "hommel", "bonferroni", "BH",
#'   "BY", "fdr" or "none". See the p-value adjustment section in the
#'   \code{emmeans::test} documentation.
#'
#' @examples
#' library(modelbased)
#'
#' model <- lm(Sepal.Width ~ Species, data = iris)
#' estimate_contrasts(model)
#'
#' model <- lm(Sepal.Width ~ Species * Petal.Width, data = iris)
#' estimate_contrasts(model)
#' estimate_contrasts(model, fixed = "Petal.Width")
#' estimate_contrasts(model, modulate = "Petal.Width", length = 4)
#' estimate_contrasts(model, levels = "Petal.Width", length = 4)
#'
#' if (require("lme4")) {
#'   data <- iris
#'   data$Petal.Length_factor <- ifelse(data$Petal.Length < 4.2, "A", "B")
#'
#'   model <- lmer(Sepal.Width ~ Species + (1 | Petal.Length_factor), data = data)
#'   estimate_contrasts(model)
#' }
#' @return A dataframe of estimated contrasts.
#'
#' @importFrom emmeans contrast
#' @importFrom stats mad median sd setNames confint
#' @importFrom bayestestR describe_posterior
#' @export
estimate_contrasts.lm <- function(model, levels = NULL, fixed = NULL, modulate = NULL, transform = "none", length = 10, standardize = TRUE, standardize_robust = FALSE, ci = 0.95, adjust = "holm", ...) {
  args <- .guess_arguments(model, levels = levels, fixed = fixed, modulate = modulate)

  estimated <- .emmeans_wrapper(model, levels = args$levels, fixed = args$fixed, modulate = args$modulate, transform = transform, length = length, ...)
  contrasts <- emmeans::contrast(estimated,
    by = c(.clean_argument(args$fixed), .clean_argument(args$modulate)),
    method = "pairwise",
    adjust = adjust,
    ...
  )


  # Summary
  contrasts <- as.data.frame(merge(as.data.frame(contrasts), stats::confint(contrasts, level = ci, adjust = adjust)))
  contrasts <- .clean_names_frequentist(contrasts)

  # Reorder columns
  order_SE <- grep("SE", names(contrasts))
  col_order <- c("CI_low", "CI_high", "t", "z", "df", "p")
  contrasts <- cbind(contrasts[c(1:order_SE)], contrasts[col_order[col_order %in% names(contrasts)]])

  # Standardized differences
  if (standardize & transform != "response") {
    contrasts <- cbind(contrasts, .standardize_contrasts(contrasts, model, robust = standardize_robust))
  }


  # Format contrasts
  names <- contrasts$contrast

  # Separate Contrasts from Others
  # if (!is.null(fixed) | !is.null(modulate)) {
  if (!is.null(args$modulate)) {
    others <- strsplit(as.character(names), ", ")
    others <- data.frame(do.call(rbind, others))
    names(others) <- unlist(sapply(others, .find_name_level))
    others <- as.data.frame(sapply(others, .remove_name_level), stringsAsFactors = FALSE)
    levelcols <- data.frame("Contrast" = others$Contrast)
    others$Contrast <- NULL
    others <- as.data.frame(sapply(others, as.numeric_ifnumeric), stringsAsFactors = FALSE)
  } else {
    others <- data.frame()
    levelcols <- data.frame("Contrast" = names)
  }


  # Format contrasts names
  levelcols <- .format_names_contrasts(model, levelcols, transform = transform)

  contrasts$contrast <- NULL
  if (nrow(others) != nrow(levelcols)) {
    contrasts <- cbind(levelcols, contrasts)
  } else {
    contrasts <- cbind(levelcols, others, contrasts)
  }

  attributes(contrasts) <- c(
    attributes(contrasts),
    list(
      levels = args$levels,
      fixed = args$fixed,
      modulate = args$modulate,
      transform = transform,
      ci = ci,
      adjust = adjust,
      response = insight::find_response(model)
    )
  )

  class(contrasts) <- c("estimate_contrasts", class(contrasts))
  contrasts
}


#' @export
estimate_contrasts.merMod <- estimate_contrasts.lm

#' @export
estimate_contrasts.glmmTMB <- estimate_contrasts.lm
