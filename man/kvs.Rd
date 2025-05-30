% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{kvs}
\alias{kvs}
\title{Key-Value Pairs for Dropdown Examples}
\format{
A named list with various types of values:
\describe{
  \item{colors}{Character vector of color names}
  \item{numbers}{Numeric values from 1 to 10}
  \item{options}{Logical values (TRUE/FALSE)}
  \item{categories}{Factor levels for categorical data}
}
}
\usage{
kvs
}
\description{
A dataset containing example key-value pairs that can be used to demonstrate
the \code{\link{inp_dropdown}} function. This provides a convenient way to test
dropdown functionality without needing to create sample data.
}
\examples{
\dontrun{
# Create a dropdown input using the kvs dataset
inp_dropdown(kvs$colors, label = "Select a color")

# Create a dropdown with numbers
inp_dropdown(kvs$numbers, label = "Choose a number", width = 3)
}
}
\keyword{datasets}
