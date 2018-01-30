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


## 0 to 100 in 6 Lines of Code

```
install.packages("devtools")
devtools::install_github("retowyss/appifyr")
```

To run the app you will need OpenCPU.

```
install.packages("opencpu")
```

Open up a new package (project) in RStudio and give it a name (e.g. MyApp). Then on the console run:

```
appifyr::new_app()
```

This will create a bunch of files. The `app` directory is where your app lives. There is a standard Rmarkdown website template included. Build your app (the template app) with:

```
appifyr::build_app(from_rmd = TRUE)
```

And run it with:

```
opencpu::ocpu_start_app("MyApp")
```

