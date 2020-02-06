# authors: Arun, Bronwyn, Manish
# date: 2019-12-18

"Cleans, splits and pre-processes (scales) the Las Vegas strip data(from https://archive.ics.uci.edu/ml/datasets/Las+Vegas+Strip).
Writes the training and test data to separate csv files.

Usage: src/pre_process_vegas.r --input=<input> --out_dir=<out_dir>
  
Options:
--input=<input>       Path (including filename) to raw data (csv file)
--out_dir=<out_dir>   Path to directory where the processed data should be written
" -> doc

# loading required libraries
library(tidyverse)
library(caret)
library(readr)
library(ggplot2)
library(GGally)
library(repr)
library(gridExtra)
library(docopt)
library(reticulate)

opt <- docopt(doc)
print("here")
print(opt)

main <- function(input, out_dir){
  

vegas_data <- read_csv2(input)


#splitting into training test data set  based on hotel names
set.seed(787)
train_index <- caret::createDataPartition(vegas_data$`Hotel name`,  p = 0.75, list = FALSE)
training_set <- vegas_data[train_index,]
test_set <- vegas_data[- train_index,]

# dim(training_set)
# dim(test_set)




colnames(training_set) <- c("user_country", "num_reviews", "num_hotel_reviews", "helpful_votes", "score", "stay_period", "traveller_type", "pool", "gym", "tennis_court", "spa", "casino", "free_internet", "hotel_name", "hotel_stars", "rooms", "user_continent", "member_years", "review_month", "review_weekday")



# checking summary info for the training dataframe

# summary(training_set)
# 

training_set[training_set$member_years== -1806,"member_years" ] = 0 

# min(training_set$member_years)
# 
# 

training_set <- training_set[c("user_country", "user_continent", "traveller_type",  "stay_period","review_month", "review_weekday", "member_years", "num_reviews", "helpful_votes", "pool", "gym", "tennis_court", "spa", "casino", "free_internet", "hotel_stars", "rooms", "num_hotel_reviews","score")]

# head(training_set)




user_specific_features <- c("user_country", "user_continent", "traveller_type",  "stay_period","review_month", "review_weekday", "member_years", "num_reviews", "helpful_votes")

hotel_specific_features <- c("pool", "gym", "tennis_court", "spa", "casino", "free_internet", "hotel_stars", "rooms", "num_hotel_reviews")


categorical_features <- c("user_country", "user_continent", "traveller_type",  "stay_period","review_month", "review_weekday", "pool", "gym", "tennis_court", "spa", "casino", "free_internet", "hotel_stars")

numerical_features <- c( "member_years", "num_reviews", "helpful_votes",  "rooms", "num_hotel_reviews")


#   print(category)
#   print(table(training_set[category]))
#   cat("\n")
#   cat("\n")
# }



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


training_set_plot <- training_set










## preprocessing begins
training_set$hotel_stars = factor(training_set$hotel_stars)

## scaling numeric features
set.seed(14)
preProcValues <- preProcess(training_set[,numerical_features], method = c("center", "scale"))
training_set[, numerical_features] = predict(preProcValues, training_set[,numerical_features])


## converting categorical columns to 1s and 0s
set.seed(12)
dmy <- dummyVars(" ~ .", data = training_set[categorical_features], fullRank=T)
  
training_set <- cbind(data.frame(predict(dmy,training_set[categorical_features])), training_set[c(numerical_features, "score")]  )
  



##APPLYING SAME TRANSFORMATIONS TO TEST SET

colnames(test_set) <- c("user_country", "num_reviews", "num_hotel_reviews", "helpful_votes", "score", "stay_period", "traveller_type", "pool", "gym", "tennis_court", "spa", "casino", "free_internet", "hotel_name", "hotel_stars", "rooms", "user_continent", "member_years", "review_month", "review_weekday")
test_set[test_set$member_years== -1806,"member_years" ] = 0 




test_set <- test_set[c("user_country", "user_continent", "traveller_type",  "stay_period","review_month", "review_weekday", "member_years", "num_reviews", "helpful_votes", "pool", "gym", "tennis_court", "spa", "casino", "free_internet", "hotel_stars", "rooms", "num_hotel_reviews","score")]




user_specific_features <- c("user_country", "user_continent", "traveller_type",  "stay_period","review_month", "review_weekday", "member_years", "num_reviews", "helpful_votes")

hotel_specific_features <- c("pool", "gym", "tennis_court", "spa", "casino", "free_internet", "hotel_stars", "rooms", "num_hotel_reviews")


categorical_features <- c("user_country", "user_continent", "traveller_type",  "stay_period","review_month", "review_weekday", "pool", "gym", "tennis_court", "spa", "casino", "free_internet", "hotel_stars")

numerical_features <- c( "member_years", "num_reviews", "helpful_votes",  "rooms", "num_hotel_reviews")








test_set <- test_set[, -c(1)]

# Re-categorizing review months as quarters of a year rather than individual months. 
test_set$review_month <- factor(test_set$review_month)

levels(test_set$review_month) = list("Q1" = c("January", "February", "March"),
                                     "Q2" = c("April", "May", "June"),
                                     "Q3" = c("July", "August", "September"),
                                     "Q4" = c("October", "November", "December"))


# Re-categorizing review_weekday as weekends and weekdays rather than days of the week. 
# including Friday in weekend category

test_set$review_weekday <- factor(test_set$review_weekday)
levels(test_set$review_weekday) <- list("Weekday" = c("Monday", "Tuesday", "Wednesday", "Thursday"),
                                        "Weekend" = c("Friday","Saturday", "Sunday"))


# renaming these columns 

colnames(test_set)[4:5] <- c("review_quarter", "review_day")

# updating categorical feature vector 
categorical_features <- categorical_features[-1]
categorical_features[4:5] <- c("review_quarter", "review_day")

# updating user_specific feature vector
user_specific_features <- user_specific_features[-1]
user_specific_features[4:5] <- c("review_quarter", "review_day")


## preprocessing begins
test_set$hotel_stars = factor(test_set$hotel_stars)

test_set[, numerical_features] = predict(preProcValues, test_set[,numerical_features])



test_set <- cbind(data.frame(predict(dmy,test_set[categorical_features])), test_set[c(numerical_features, "score")]  )






# write training and test data to csv files
write_csv(training_set_plot, paste0(out_dir, "/train_vegas_plot.csv"))
write_csv(training_set, paste0(out_dir, "/training_ml.csv"))
write_csv(test_set, paste0(out_dir, "/test_ml.csv"))

}

main(opt[["--input"]], opt[["--out_dir"]])


