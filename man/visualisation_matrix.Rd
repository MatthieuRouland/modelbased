% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/visualisation_matrix.R
\name{visualisation_matrix}
\alias{visualisation_matrix}
\title{Create a reference grid}
\usage{
visualisation_matrix(
  x,
  target = "all",
  length = 10,
  factors = "reference",
  numerics = "mean",
  preserve_range = FALSE,
  standardize = FALSE,
  standardize_robust = FALSE,
  reference = x,
  na.rm = TRUE,
  ...
)
}
\arguments{
\item{x}{An object from which to construct the reference grid.}

\item{target}{Can be "all" or list of characters indicating columns of interest. Can also contain assignments (e.g., \code{target = "Sepal.Length = 2"} or \code{target = c("Sepal.Length = 2", "Species = 'setosa'")} - note the usage of single and double quotes to assign strings within strings). The remaining variables will be fixed.}

\item{length}{Length of numeric target variables.}

\item{factors}{Type of summary for factors. Can be "combination" (include all unique values), "reference" (set at the reference level) or "mode" (set at the most common level).}

\item{numerics}{Type of summary for numeric values. Can be "combination" (include all unique values), any function ("mean", "median", ...) or a value (e.g., \code{numerics = 0}).}

\item{preserve_range}{In the case of combinations between numeric variables and factors, setting \code{preserve_range = TRUE} removes observations where the value of the numeric variable is originally not present in the range of its factor level.}

\item{standardize}{The numeric target value is spread as deviations from the mean, with the central value being the mean (or the median if \code{standardize_robust} is TRUE). For instance, if \code{x} is a vector of mean 1 and SD 2.5, and a standardized grid is required of length 3, the result will be \code{c(Mean-1*SD, Mean, Mean+1*SD)}, i.e., \code{c(-1.5, 1, 3.5)}. Each value represents deviations (in terms of SD or MAD) from the central value. This needs the \code{length} argument to be an even integer, so that the central value represent the mean.}

\item{standardize_robust}{Standardization based on median and MAD (a robust equivalent of the SD).}

\item{reference}{The reference vector from which to compute the mean and SD.}

\item{na.rm}{Remove NaNs.}

\item{...}{Arguments passed to or from other methods.}
}
\value{
Reference grid data frame.
}
\description{
Create a reference matrix, useful for visualisation, with evenly spread and combined values.
}
\examples{
library(modelbased)

visualisation_matrix(iris, target = "Sepal.Length")
visualisation_matrix(iris, target = "Sepal.Length", factors = "combinations")
visualisation_matrix(iris, target = c("Sepal.Length", "Species"), length = 3)
visualisation_matrix(iris, target = c("Sepal.Length", "Species"), numerics = 0)
visualisation_matrix(iris, target = c("Sepal.Length = 3", "Species"))
visualisation_matrix(iris, target = c("Sepal.Length = c(3, 1)", "Species = 'setosa'"))
visualisation_matrix(iris, target = "Sepal.Length", standardize = TRUE, length = 3)
}
