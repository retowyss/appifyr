# appify

## Write R Get Apps!

__Have you ever wished that creating an app was as easy as calling a function? Now it is!__

1. Write an R function, 
2. pass it to `appify`, 
3. specify the inputs. 

Done.

## Install

```
install.packages("opencpu")
install.packages("devtools")
devtools::install_github("retowyss/appify")
```

### Demo

Have a look at the template package on Github retowyss/appify-demo, clone it, build it and run it with OpenCPU.

```
opencpu::ocpu_start_app("appify-demo")
```

### Example

Load the package.

```
require(appify)
require(ggplot2)
```

Write your R function.

```

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
