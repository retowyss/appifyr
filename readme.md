# appifyr

[![Build Status](https://travis-ci.org/retowyss/appifyr.svg?branch=master)](https://travis-ci.org/retowyss/appifyr)
[![Coverage status](https://codecov.io/gh/retowyss/appifyr/branch/master/graph/badge.svg)](https://codecov.io/github/retowyss/appifyr?branch=master)

## Write R Get Apps!

__Have you ever wished that creating an app was as easy as calling a function? Now it is!__

1. Write an R function, 
2. pass it to `appify`, 
3. specify the inputs. 

Done. There is your app!

> How is this different from Shiny?

Appify and shiny approach building apps from two different points of view. 

* When you use Shiny you start with the goal of creating a specific app. You write R code to achieve that goal. 
* When you use Appifyr you start with R code. You create the app to visualize your function.

To get started go to:

1. [Appifyr Documentation](https://retowyss.github.io/appifyr/)
2. [Demo App - Sepals and Petals](http://retowyss.ocpu.io/sepals-and-petals/www/)


## Getting Started

```
install.packages("devtools")
devtools::install_github("retowyss/appifyr")
```

To run the app you will need OpenCPU.

```
install.packages("opencpu")
```

Then clone the SepalsAndPetals (retowyss/sepals-and-petals) demo application and open the project.

```
appifyr::build_app()
opencpu::ocpu_start_app("SepalsAndPetals")
```

