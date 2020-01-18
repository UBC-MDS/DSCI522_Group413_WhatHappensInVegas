EDA on Vegas Strip dataset
================
Arun, Bronwyn, Manish
1/17/2020

``` r
# loading required libraries
library(tidyverse)
```

    ## Warning: package 'tidyverse' was built under R version 3.5.3

    ## -- Attaching packages ----------------------- tidyverse 1.3.0 --

    ## v ggplot2 3.2.1     v purrr   0.3.3
    ## v tibble  2.1.3     v dplyr   0.8.3
    ## v tidyr   1.0.0     v stringr 1.4.0
    ## v readr   1.3.1     v forcats 0.4.0

    ## Warning: package 'ggplot2' was built under R version 3.5.3

    ## Warning: package 'tibble' was built under R version 3.5.3

    ## Warning: package 'tidyr' was built under R version 3.5.3

    ## Warning: package 'readr' was built under R version 3.5.3

    ## Warning: package 'purrr' was built under R version 3.5.3

    ## Warning: package 'dplyr' was built under R version 3.5.3

    ## Warning: package 'stringr' was built under R version 3.5.3

    ## Warning: package 'forcats' was built under R version 3.5.3

    ## -- Conflicts -------------------------- tidyverse_conflicts() --
    ## x dplyr::filter() masks stats::filter()
    ## x dplyr::lag()    masks stats::lag()

``` r
library(caret)
```

    ## Loading required package: lattice

    ## 
    ## Attaching package: 'caret'

    ## The following object is masked from 'package:purrr':
    ## 
    ##     lift

``` r
library(readr)
```

## Introduction and train/test split

In this document we perform exploratory data analysis on `Vegas Strip`
dataaset to see if there is any relationship between different amenities
which hotels provide and the score which guests give to those hotels on
the strip. This exploratory analysis will then be extended to see if a
predictive regression model can be developed to estimate user ratings
based on hotel amenities.

Before doing any EDA splitting dataset into training and test set.

``` r
# reading dataset 
vegas_data <- read_csv2("../data/vegas_data.csv")
```

    ## Using ',' as decimal and '.' as grouping mark. Use read_delim() for more control.

    ## Parsed with column specification:
    ## cols(
    ##   .default = col_character(),
    ##   `Nr. reviews` = col_double(),
    ##   `Nr. hotel reviews` = col_double(),
    ##   `Helpful votes` = col_double(),
    ##   Score = col_double(),
    ##   `Hotel stars` = col_double(),
    ##   `Nr. rooms` = col_double(),
    ##   `Member years` = col_double()
    ## )

    ## See spec(...) for full column specifications.

``` r
#splitting into training test data set  based on hotel names
set.seed(787)
train_index <- caret::createDataPartition(vegas_data$`Hotel name`,  p = 0.75, list = FALSE)
training_set <- vegas_data[train_index,]
test_set <- vegas_data[- train_index,]

dim(training_set)
```

    ## [1] 378  20

``` r
dim(test_set)
```

    ## [1] 126  20

\`\`\`{}

##
