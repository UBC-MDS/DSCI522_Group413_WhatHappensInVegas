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
library(ggplot2)
library(GGally)
```

    ## Warning: package 'GGally' was built under R version 3.5.3

    ## 
    ## Attaching package: 'GGally'

    ## The following object is masked from 'package:dplyr':
    ## 
    ##     nasa

``` r
library(repr)
```

    ## Warning: package 'repr' was built under R version 3.5.3

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

### EDA 1:- Cleaning and wrangling data

Checking top rows and column names of the dataset.

``` r
head(training_set)
```

    ## # A tibble: 6 x 20
    ##   `User country` `Nr. reviews` `Nr. hotel revi~ `Helpful votes` Score
    ##   <chr>                  <dbl>            <dbl>           <dbl> <dbl>
    ## 1 USA                       11                4              13     5
    ## 2 USA                      119               21              75     3
    ## 3 USA                       36                9              25     5
    ## 4 UK                        14                7              14     4
    ## 5 UK                        45               12              46     4
    ## 6 USA                        2                1               4     4
    ## # ... with 15 more variables: `Period of stay` <chr>, `Traveler
    ## #   type` <chr>, Pool <chr>, Gym <chr>, `Tennis court` <chr>, Spa <chr>,
    ## #   Casino <chr>, `Free internet` <chr>, `Hotel name` <chr>, `Hotel
    ## #   stars` <dbl>, `Nr. rooms` <dbl>, `User continent` <chr>, `Member
    ## #   years` <dbl>, `Review month` <chr>, `Review weekday` <chr>

``` r
colnames(training_set)
```

    ##  [1] "User country"      "Nr. reviews"       "Nr. hotel reviews"
    ##  [4] "Helpful votes"     "Score"             "Period of stay"   
    ##  [7] "Traveler type"     "Pool"              "Gym"              
    ## [10] "Tennis court"      "Spa"               "Casino"           
    ## [13] "Free internet"     "Hotel name"        "Hotel stars"      
    ## [16] "Nr. rooms"         "User continent"    "Member years"     
    ## [19] "Review month"      "Review weekday"

The dataset has 20 columns, out of which 19 are features and `Score` is
response variable for which relationship based on estimators need to be
determined.

The column/feature names are clearly not tidyverse compliant and have
white spaces which are a bit difficult to deal with during data
analysis.

``` r
#changing column names

colnames(training_set) <- c("user_country", "num_reviews", "num_hotel_reviews", "helpful_votes", "score", "stay_period", "traveller_type", "pool", "gym", "tennis_court", "spa", "casino", "free_internet", "hotel_name", "hotel_stars", "rooms", "user_continent", "member_years", "review_month", "review_weekday")

head(training_set)
```

    ## # A tibble: 6 x 20
    ##   user_country num_reviews num_hotel_revie~ helpful_votes score stay_period
    ##   <chr>              <dbl>            <dbl>         <dbl> <dbl> <chr>      
    ## 1 USA                   11                4            13     5 Dec-Feb    
    ## 2 USA                  119               21            75     3 Dec-Feb    
    ## 3 USA                   36                9            25     5 Mar-May    
    ## 4 UK                    14                7            14     4 Mar-May    
    ## 5 UK                    45               12            46     4 Mar-May    
    ## 6 USA                    2                1             4     4 Mar-May    
    ## # ... with 14 more variables: traveller_type <chr>, pool <chr>, gym <chr>,
    ## #   tennis_court <chr>, spa <chr>, casino <chr>, free_internet <chr>,
    ## #   hotel_name <chr>, hotel_stars <dbl>, rooms <dbl>,
    ## #   user_continent <chr>, member_years <dbl>, review_month <chr>,
    ## #   review_weekday <chr>

Checking for any NAs in the dataset.

``` r
any(is.na(training_set))
```

    ## [1] FALSE

This is good as we do not have any NAs in the dataset.

Checking datatype for individual columns in dataset.

``` r
str(training_set)
```

    ## Classes 'tbl_df', 'tbl' and 'data.frame':    378 obs. of  20 variables:
    ##  $ user_country     : chr  "USA" "USA" "USA" "UK" ...
    ##  $ num_reviews      : num  11 119 36 14 45 2 24 12 102 20 ...
    ##  $ num_hotel_reviews: num  4 21 9 7 12 1 3 7 24 9 ...
    ##  $ helpful_votes    : num  13 75 25 14 46 4 8 11 58 24 ...
    ##  $ score            : num  5 3 5 4 4 4 4 3 2 3 ...
    ##  $ stay_period      : chr  "Dec-Feb" "Dec-Feb" "Mar-May" "Mar-May" ...
    ##  $ traveller_type   : chr  "Friends" "Business" "Families" "Friends" ...
    ##  $ pool             : chr  "NO" "NO" "NO" "NO" ...
    ##  $ gym              : chr  "YES" "YES" "YES" "YES" ...
    ##  $ tennis_court     : chr  "NO" "NO" "NO" "NO" ...
    ##  $ spa              : chr  "NO" "NO" "NO" "NO" ...
    ##  $ casino           : chr  "YES" "YES" "YES" "YES" ...
    ##  $ free_internet    : chr  "YES" "YES" "YES" "YES" ...
    ##  $ hotel_name       : chr  "Circus Circus Hotel & Casino Las Vegas" "Circus Circus Hotel & Casino Las Vegas" "Circus Circus Hotel & Casino Las Vegas" "Circus Circus Hotel & Casino Las Vegas" ...
    ##  $ hotel_stars      : num  3 3 3 3 3 3 3 3 3 3 ...
    ##  $ rooms            : num  3773 3773 3773 3773 3773 ...
    ##  $ user_continent   : chr  "North America" "North America" "North America" "Europe" ...
    ##  $ member_years     : num  9 3 2 6 4 0 3 5 9 4 ...
    ##  $ review_month     : chr  "January" "January" "February" "February" ...
    ##  $ review_weekday   : chr  "Thursday" "Friday" "Saturday" "Friday" ...

``` r
# checking summary info for the training dataframe

summary(training_set)
```

    ##  user_country        num_reviews     num_hotel_reviews helpful_votes   
    ##  Length:378         Min.   :  1.00   Min.   :  0.00    Min.   :  0.00  
    ##  Class :character   1st Qu.: 12.00   1st Qu.:  5.00    1st Qu.:  7.25  
    ##  Mode  :character   Median : 23.00   Median :  9.00    Median : 16.00  
    ##                     Mean   : 44.78   Mean   : 15.30    Mean   : 31.29  
    ##                     3rd Qu.: 50.00   3rd Qu.: 17.75    3rd Qu.: 31.75  
    ##                     Max.   :608.00   Max.   :263.00    Max.   :365.00  
    ##      score       stay_period        traveller_type         pool          
    ##  Min.   :1.000   Length:378         Length:378         Length:378        
    ##  1st Qu.:4.000   Class :character   Class :character   Class :character  
    ##  Median :4.000   Mode  :character   Mode  :character   Mode  :character  
    ##  Mean   :4.122                                                           
    ##  3rd Qu.:5.000                                                           
    ##  Max.   :5.000                                                           
    ##      gym            tennis_court           spa           
    ##  Length:378         Length:378         Length:378        
    ##  Class :character   Class :character   Class :character  
    ##  Mode  :character   Mode  :character   Mode  :character  
    ##                                                          
    ##                                                          
    ##                                                          
    ##     casino          free_internet       hotel_name         hotel_stars   
    ##  Length:378         Length:378         Length:378         Min.   :3.000  
    ##  Class :character   Class :character   Class :character   1st Qu.:3.500  
    ##  Mode  :character   Mode  :character   Mode  :character   Median :4.000  
    ##                                                           Mean   :4.143  
    ##                                                           3rd Qu.:5.000  
    ##                                                           Max.   :5.000  
    ##      rooms      user_continent      member_years        review_month      
    ##  Min.   : 188   Length:378         Min.   :-1806.0000   Length:378        
    ##  1st Qu.: 826   Class :character   1st Qu.:    2.0000   Class :character  
    ##  Median :2700   Mode  :character   Median :    4.0000   Mode  :character  
    ##  Mean   :2196                      Mean   :   -0.4392                     
    ##  3rd Qu.:3025                      3rd Qu.:    6.7500                     
    ##  Max.   :4027                      Max.   :   13.0000                     
    ##  review_weekday    
    ##  Length:378        
    ##  Class :character  
    ##  Mode  :character  
    ##                    
    ##                    
    ## 

Clearly based on summary statistics, the column `member_years` has
negative values which seems incorrect as number of years of membership
of a customer cannot be negative.

``` r
sort(training_set$member_years)[1:10]
```

    ##  [1] -1806     0     0     0     0     0     0     0     0     0

Replacing the minimum value by 0 as it logically makes sense to do so.

``` r
training_set[training_set$member_years== -1806,"member_years" ] = 0 

min(training_set$member_years)
```

    ## [1] 0

### EDA 2 :- Exploring relationship b/w features and hotel score

Now we have clean data with no NA values, we can start inspecting
individual features to see if we can identify any relationship between
target score and the features.

``` r
str(training_set)
```

    ## Classes 'tbl_df', 'tbl' and 'data.frame':    378 obs. of  20 variables:
    ##  $ user_country     : chr  "USA" "USA" "USA" "UK" ...
    ##  $ num_reviews      : num  11 119 36 14 45 2 24 12 102 20 ...
    ##  $ num_hotel_reviews: num  4 21 9 7 12 1 3 7 24 9 ...
    ##  $ helpful_votes    : num  13 75 25 14 46 4 8 11 58 24 ...
    ##  $ score            : num  5 3 5 4 4 4 4 3 2 3 ...
    ##  $ stay_period      : chr  "Dec-Feb" "Dec-Feb" "Mar-May" "Mar-May" ...
    ##  $ traveller_type   : chr  "Friends" "Business" "Families" "Friends" ...
    ##  $ pool             : chr  "NO" "NO" "NO" "NO" ...
    ##  $ gym              : chr  "YES" "YES" "YES" "YES" ...
    ##  $ tennis_court     : chr  "NO" "NO" "NO" "NO" ...
    ##  $ spa              : chr  "NO" "NO" "NO" "NO" ...
    ##  $ casino           : chr  "YES" "YES" "YES" "YES" ...
    ##  $ free_internet    : chr  "YES" "YES" "YES" "YES" ...
    ##  $ hotel_name       : chr  "Circus Circus Hotel & Casino Las Vegas" "Circus Circus Hotel & Casino Las Vegas" "Circus Circus Hotel & Casino Las Vegas" "Circus Circus Hotel & Casino Las Vegas" ...
    ##  $ hotel_stars      : num  3 3 3 3 3 3 3 3 3 3 ...
    ##  $ rooms            : num  3773 3773 3773 3773 3773 ...
    ##  $ user_continent   : chr  "North America" "North America" "North America" "Europe" ...
    ##  $ member_years     : num  9 3 2 6 4 0 3 5 9 4 ...
    ##  $ review_month     : chr  "January" "January" "February" "February" ...
    ##  $ review_weekday   : chr  "Thursday" "Friday" "Saturday" "Friday" ...

Clearly the dataset has two kind of features.

  - **User specific** : user\_country, member\_years, user\_continent,
    traveller\_type etc.
  - **Hotel Specific** : rooms, free\_internet, hotel\_stars etc.

And within each category we have both categorical and numerical
features.

We can first re-arrange columns for better interpretation and **remove
hotel name** column as we do not want it to be one of the features.

``` r
training_set <- training_set[c("user_country", "user_continent", "traveller_type",  "stay_period","review_month", "review_weekday", "member_years", "num_reviews", "helpful_votes", "pool", "gym", "tennis_court", "spa", "casino", "free_internet", "hotel_stars", "rooms", "num_hotel_reviews","score")]

head(training_set)
```

    ## # A tibble: 6 x 19
    ##   user_country user_continent traveller_type stay_period review_month
    ##   <chr>        <chr>          <chr>          <chr>       <chr>       
    ## 1 USA          North America  Friends        Dec-Feb     January     
    ## 2 USA          North America  Business       Dec-Feb     January     
    ## 3 USA          North America  Families       Mar-May     February    
    ## 4 UK           Europe         Friends        Mar-May     February    
    ## 5 UK           Europe         Couples        Mar-May     April       
    ## 6 USA          North America  Families       Mar-May     April       
    ## # ... with 14 more variables: review_weekday <chr>, member_years <dbl>,
    ## #   num_reviews <dbl>, helpful_votes <dbl>, pool <chr>, gym <chr>,
    ## #   tennis_court <chr>, spa <chr>, casino <chr>, free_internet <chr>,
    ## #   hotel_stars <dbl>, rooms <dbl>, num_hotel_reviews <dbl>, score <dbl>

Creating vectors for different categories of features.

``` r
user_specific_features <- c("user_country", "user_continent", "traveller_type",  "stay_period","review_month", "review_weekday", "member_years", "num_reviews", "helpful_votes")

hotel_specific_features <- c("pool", "gym", "tennis_court", "spa", "casino", "free_internet", "hotel_stars", "rooms", "num_hotel_reviews")


categorical_features <- c("user_country", "user_continent", "traveller_type",  "stay_period","review_month", "review_weekday", "pool", "gym", "tennis_court", "spa", "casino", "free_internet", "hotel_stars")

numerical_features <- c( "member_years", "num_reviews", "helpful_votes",  "rooms", "num_hotel_reviews")
```

We already explored the numerical features and checked min/max values
using `summary()` statistics earlier. Lets try exploring the
`categorical features`.

``` r
for (category in categorical_features){
  print(category)
  print(table(training_set[category]))
  cat("\n")
  cat("\n")
}
```

    ## [1] "user_country"
    ## 
    ##            Australia              Belgium               Brazil 
    ##                   23                    1                    4 
    ##               Canada                China              Croatia 
    ##                   50                    1                    1 
    ##       Czech Republic                Egypt              Finland 
    ##                    1                    5                    3 
    ##               France              Germany               Greece 
    ##                    1                    5                    1 
    ##               Hawaii             Honduras                India 
    ##                    2                    1                   10 
    ##                 Iran              Ireland               Israel 
    ##                    1                   11                    3 
    ##                Italy                Japan                Kenya 
    ##                    1                    1                    1 
    ##                Korea               Kuwait             Malaysia 
    ##                    1                    1                    3 
    ##               Mexico          Netherlands           New Zeland 
    ##                    5                    2                    4 
    ##               Norway         Phillippines          Puerto Rico 
    ##                    1                    1                    1 
    ##            Singapore                Swiss                Syria 
    ##                    3                    1                    1 
    ##               Taiwan             Thailand                   UK 
    ##                    1                    2                   58 
    ## United Arab Emirates                  USA 
    ##                    1                  165 
    ## 
    ## 
    ## [1] "user_continent"
    ## 
    ##        Africa          Asia        Europe North America       Oceania 
    ##             6            30            87           223            27 
    ## South America 
    ##             5 
    ## 
    ## 
    ## [1] "traveller_type"
    ## 
    ## Business  Couples Families  Friends     Solo 
    ##       55      154       89       62       18 
    ## 
    ## 
    ## [1] "stay_period"
    ## 
    ## Dec-Feb Jun-Aug Mar-May Sep-Nov 
    ##      91      94     101      92 
    ## 
    ## 
    ## [1] "review_month"
    ## 
    ##     April    August  December  February   January      July      June 
    ##        29        30        33        33        27        34        30 
    ##     March       May  November   October September 
    ##        34        36        33        27        32 
    ## 
    ## 
    ## [1] "review_weekday"
    ## 
    ##    Friday    Monday  Saturday    Sunday  Thursday   Tuesday Wednesday 
    ##        56        52        42        59        51        54        64 
    ## 
    ## 
    ## [1] "pool"
    ## 
    ##  NO YES 
    ##  18 360 
    ## 
    ## 
    ## [1] "gym"
    ## 
    ##  NO YES 
    ##  18 360 
    ## 
    ## 
    ## [1] "tennis_court"
    ## 
    ##  NO YES 
    ## 288  90 
    ## 
    ## 
    ## [1] "spa"
    ## 
    ##  NO YES 
    ##  90 288 
    ## 
    ## 
    ## [1] "casino"
    ## 
    ##  NO YES 
    ##  36 342 
    ## 
    ## 
    ## [1] "free_internet"
    ## 
    ##  NO YES 
    ##  18 360 
    ## 
    ## 
    ## [1] "hotel_stars"
    ## 
    ##   3 3.5   4 4.5   5 
    ##  72  54  90  18 144

Interestingly, to our surprise there are a few hotels on Vegas Strip
which do not have casino.

Also based on initial exploration of individual groups in each category;
we are suspicious that users’ `countries` should not have an impact on
the hotel score. Also there were more visitors from some of the
countries(USA, Canada, Australia) as compared to others(France etc.).
Plus we may have a new user from different country so our model will
more potentially fail to generalize and it might be a good idea to use
`user_continents` instead. We will however do some more visualization
analysis to confirm same.

#### Inspecting Score’s relationship with hotel specific features

``` r
options(repr.plot.height = 8, repr.plot.width = 8)
ggpairs(data = training_set, columns = c(hotel_specific_features, "score"))
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](EDA_vegas_strip_data_files/figure-gfm/unnamed-chunk-13-1.png)<!-- -->