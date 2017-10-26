# appify

[![Build Status](https://travis-ci.org/retowyss/appify.svg?branch=master)](https://travis-ci.org/retowyss/appify)

## Write R Get Apps!

__Have you ever wished that creating an app was as easy as calling a function? Now it is!__

1. Write an R function, 
2. pass it to `appify`, 
3. specify the inputs. 

Done. There is your app!

> How is this different from Shiny?

Appify and shiny approach building apps from two different points of view. 

* When you use Shiny you start with the goal of creating a specific app. You write R code to achieve that goal. 
* When you use Appify you start with R code. You create the app to visualize your function.

## Install & Usage

```
install.packages("devtools")
devtools::install_github("retowyss/appify")
```

To run the app you will need OpenCPU.

```
install.packages("opencpu")
```

Open up a new package (project) in RStudio and give it a name (e.g. MyApp). Then on the console run:

```
appify::create_app()
```

This will create a bunch of files. The `app` directory is where your app lives. There is a standard Rmarkdown website template included. Build your app (the template app) with:

```
appify::build_app()
```

And run it with:

```
opencpu::ocpu_start_app("MyApp")
```

A short walkthrough and demo is on Youtube : [appify - Write R Get Apps - First Glimpse](https://www.youtube.com/watch?v=CAlBD6_T374)

## Example

```
require(appify)
```

Write your R function.

```
iris_clustering <- function(color_1, color_2, color_3) {
  require(ggplot2)
  clusters <- kmeans(iris[, 1:4], centers = 3, nstart = 3)
  
  iris_clustered <- cbind(iris, clusters = factor(clusters$cluster))
  
  ggplot(iris_clustered, aes(x = Sepal.Width, y = Petal.Width, color = clusters)) +
    geom_point() +
    scale_color_manual(values = c(color_1, color_2, color_3)) +
    ggtitle("Kmeans Clustering") + 
    theme_minimal()
}
```

`appify` has only one top level function `appify`. The function requires two inputs: 

1. a function `f` and 
2. a list `inputs`. 

That's it.

```
appify(
  f = iris_clustering, 
  inputs = list(
    color_1 = dropdown_color("Color 1"),
    color_2 = dropdown_color("Color 2"),
    color_3 = dropdown_color("Color 3")
  )
)
```
