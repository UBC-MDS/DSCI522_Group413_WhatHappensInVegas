## ----setup, include=FALSE-------------------------------------
knitr::opts_chunk$set(echo = TRUE)




## ----warning=FALSE, message=FALSE-----------------------------

# loading required libraries
library(tidyverse)
library(caret)
library(readr)
library(ggplot2)
library(GGally)
library(repr)
library(gridExtra)





## -------------------------------------------------------------
# reading dataset 
vegas_data <- read_csv2("../data/vegas_data.csv")

#splitting into training test data set  based on hotel names
set.seed(787)
train_index <- caret::createDataPartition(vegas_data$`Hotel name`,  p = 0.75, list = FALSE)
training_set <- vegas_data[train_index,]
test_set <- vegas_data[- train_index,]

dim(training_set)
dim(test_set)


## -------------------------------------------------------------

head(training_set)

colnames(training_set)


## -------------------------------------------------------------
#changing column names

colnames(training_set) <- c("user_country", "num_reviews", "num_hotel_reviews", "helpful_votes", "score", "stay_period", "traveller_type", "pool", "gym", "tennis_court", "spa", "casino", "free_internet", "hotel_name", "hotel_stars", "rooms", "user_continent", "member_years", "review_month", "review_weekday")

head(training_set)



## -------------------------------------------------------------

any(is.na(training_set))



## -------------------------------------------------------------

str(training_set)

# checking summary info for the training dataframe

summary(training_set)


## -------------------------------------------------------------
sort(training_set$member_years)[1:10]



## -------------------------------------------------------------
training_set[training_set$member_years== -1806,"member_years" ] = 0 

min(training_set$member_years)


## -------------------------------------------------------------
str(training_set)



## -------------------------------------------------------------
training_set <- training_set[c("user_country", "user_continent", "traveller_type",  "stay_period","review_month", "review_weekday", "member_years", "num_reviews", "helpful_votes", "pool", "gym", "tennis_court", "spa", "casino", "free_internet", "hotel_stars", "rooms", "num_hotel_reviews","score")]

head(training_set)



## -------------------------------------------------------------

user_specific_features <- c("user_country", "user_continent", "traveller_type",  "stay_period","review_month", "review_weekday", "member_years", "num_reviews", "helpful_votes")

hotel_specific_features <- c("pool", "gym", "tennis_court", "spa", "casino", "free_internet", "hotel_stars", "rooms", "num_hotel_reviews")


categorical_features <- c("user_country", "user_continent", "traveller_type",  "stay_period","review_month", "review_weekday", "pool", "gym", "tennis_court", "spa", "casino", "free_internet", "hotel_stars")

numerical_features <- c( "member_years", "num_reviews", "helpful_votes",  "rooms", "num_hotel_reviews")



## -------------------------------------------------------------
for (category in categorical_features){
  print(category)
  print(table(training_set[category]))
  cat("\n")
  cat("\n")
}




## -------------------------------------------------------------

# function to create plot for categorical features


plot_categorical <- function(df, col_name_x, col_name_y = "score"){
  
  p <-  ggplot(df, aes_string(x = col_name_x, y  = col_name_y))+
    geom_bar(stat = "summary", fun.y = "mean", fill = "royalblue3")+
    geom_jitter()+
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5),panel.background = element_rect(fill =   "lavender"))+
    ggtitle(paste("Average ", col_name_y," vs ", col_name_x))
  p
}

# list to hold plots

cat_plots <- vector('list', length(categorical_features))

cat_plots <- lapply(categorical_features, plot_categorical, df = training_set)

options(repr.plot.height = 10, repr.plot.width = 8)

grid.arrange(cat_plots[[1]], cat_plots[[2]], cat_plots[[3]],  layout_matrix = rbind(c(1,1),c(2,3)))
grid.arrange(cat_plots[[4]], cat_plots[[5]], cat_plots[[6]], cat_plots[[7]])
grid.arrange(cat_plots[[8]], cat_plots[[9]], cat_plots[[10]], cat_plots[[11]])
grid.arrange(cat_plots[[12]], cat_plots[[13]])


## -------------------------------------------------------------
# removing user_countries column

training_set <- training_set[, -c(1)]

# Re-categorizing review months as quarters of a year rather than individual months. 
training_set$review_month <- factor(training_set$review_month)

levels(training_set$review_month) = list("Q1" = c("January", "February", "March"),
                                       "Q2" = c("April", "May", "June"),
                                       "Q3" = c("July", "August", "September"),
                                       "Q4" = c("October", "November", "December"))


# Re-categorizing review_weekday as weekends and weekdays rather than days of the week. 
# including Friday in weekend category

training_set$review_weekday <- factor(training_set$review_weekday)
levels(training_set$review_weekday) <- list("Weekday" = c("Monday", "Tuesday", "Wednesday", "Thursday"),
                                            "Weekend" = c("Friday","Saturday", "Sunday"))


# renaming these columns 

colnames(training_set)[4:5] <- c("review_quarter", "review_day")

# updating categorical feature vector 
categorical_features <- categorical_features[-1]
categorical_features[4:5] <- c("review_quarter", "review_day")

# updating user_specific feature vector
user_specific_features <- user_specific_features[-1]
user_specific_features[4:5] <- c("review_quarter", "review_day")






## -------------------------------------------------------------
# list to hold plots

cat_plots <- vector('list', length(categorical_features))

cat_plots <- lapply(categorical_features, plot_categorical, df = training_set)

grid.arrange(cat_plots[[4]], cat_plots[[5]])



## -------------------------------------------------------------
ggpairs(training_set, c(numerical_features, "score"))+
   theme(panel.background = element_rect(fill =   "lavender"))


