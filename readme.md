# appifyr

[![R-CMD-check](https://github.com/retowyss/appifyr/workflows/R-CMD-check/badge.svg)](https://github.com/retowyss/appifyr/actions?query=workflow%3AR-CMD-check)
[![pkgdown](https://github.com/retowyss/appifyr/workflows/pkgdown/badge.svg)](https://github.com/retowyss/appifyr/actions?query=workflow%3Apkgdown)
[![test-coverage](https://github.com/retowyss/appifyr/workflows/test-coverage/badge.svg)](https://github.com/retowyss/appifyr/actions?query=workflow%3Atest-coverage)

## Create Web Applications from R Functions (Updated May 4, 2025)

**Turn your R functions into interactive web applications with minimal code!**

appifyr bridges the gap between R's analytical capabilities and web interfaces by:

1. Taking regular R functions
2. Automatically generating HTML forms for function parameters
3. Connecting these inputs to OpenCPU API calls
4. Displaying the function outputs (currently plots)

## Quick Start

```r
# Install the package
install.packages("remotes")
remotes::install_github("retowyss/appifyr")

# Create a simple function
histogram_app <- function(n, bins) {
  hist(rnorm(n), breaks = bins, main = "Random Normal Distribution")
}

# Create a web interface for your function
library(appifyr)
app <- appify(
  f = "histogram_app", 
  inps = list(
    n = inp_number(from = 10, to = 1000, label = "Sample Size"),
    bins = inp_number(from = 5, to = 30, label = "Number of Bins")
  )
)

# To run the app, you'll need OpenCPU
# install.packages("opencpu")
# opencpu::ocpu_start_app("YourPackageName")
```

## How It Works

appifyr uses OpenCPU as a backend to create web interfaces for R functions. Unlike Shiny, which requires learning Shiny-specific syntax, appifyr works with regular R functions and requires minimal JavaScript/HTML knowledge.

### Differences from Shiny

* **Shiny**: You start with the goal of creating a specific app and write R code to achieve that goal.
* **appifyr**: You start with existing R code and create an app to visualize your function.

## Documentation and Examples

* [Appifyr Documentation](https://retowyss.github.io/appifyr/)
* [Demo App - Sepals and Petals](http://retowyss.ocpu.io/sepals-and-petals/www/)

## Running Apps

To run apps created with appifyr, you need OpenCPU:

```r
# Install OpenCPU
install.packages("opencpu")

# Clone the demo application
# git clone https://github.com/retowyss/sepals-and-petals.git

# Build and start the app
appifyr::build_app()
opencpu::ocpu_start_app("SepalsAndPetals")
```

## Key Features

* Simple API: The main function `appify()` takes an R function and specifications for inputs
* Intuitive Input Creation: Helper functions like `inp_text()`, `inp_number()`, and `inp_dropdown()`
* Built-in Web Components: Generates Bootstrap-styled form elements and layout
* Integration with OpenCPU: Uses the OpenCPU JavaScript library to handle API calls

## Requirements

* R ≥ 4.1.0
* OpenCPU for running the apps
