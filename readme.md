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

## Install & Usage

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
appifyr::build_app()
```

And run it with:

```
opencpu::ocpu_start_app("MyApp")
```
1. [Documentation](https://retowyss.github.io/appifyr/)
2. A short walkthrough and demo is on Youtube : [appifyr - Write R Get Apps - First Glimpse](https://www.youtube.com/watch?v=CAlBD6_T374)

## Example

```
require(appifyr)
```

Write your R function.

```
require(ggplot2)

iris_clustering <- function(color_1, color_2, color_3) {
  clusters <- kmeans(iris[, 1:4], centers = 3, nstart = 3)
  iris_clustered <- cbind(iris, clusters = factor(clusters$cluster))
  
  ggplot(iris_clustered, aes(x = Sepal.Width, y = Petal.Width, color = clusters)) +
    geom_point() +
    scale_color_manual(values = c(color_1, color_2, color_3)) +
    ggtitle("Kmeans Clustering") + 
    theme_minimal()
}
```

`appifyr`'s `appify` requires two inputs: 

1. a function `f` and 
2. a list `inputs`. 

That's it.

```
appify(
  f = "iris_clustering", 
  inps = list(
    color_1 = inp_dropdown(1:12),
    color_2 = inp_dropdown(1:12),
    color_3 = inp_dropdown(1:12)
  )
)
```
