# authors: Arun, Bronwyn, Manish
# date: 2020-01-23

"Creates eda plots for the pre-processed training data from the Vegas Strip data (from https://archive.ics.uci.edu/ml/machine-learning-databases/00397/LasVegasTripAdvisorReviews-Dataset.csv).
Saves the plots as a pdf and png file.
Usage: src/eda_wisc.r --train=<train> --out_dir=<out_dir>
  
Options:
--train=<train>     Path (including filename) to training data (which needs to be saved as a feather file)
--out_dir=<out_dir> Path to directory where the plots should be saved
" -> doc

library(feather)
library(tidyverse)
library(caret)
library(docopt)
library(ggridges)
library(ggthemes)
theme_set(theme_minimal())

opt <- docopt(doc)

main <- function(train, out_dir) {
  
  # visualize predictor distributions by class
  train_data <- read_csv2(train)
  
  train_data_fig_1 <- train_data %>%
    select(pool, gym, tennis_court, spa, casino, free_internet, score)%>%
    gather(key = amenity, value = has_amenity, -score) %>% 
    ggplot(aes(x = score, colour = has_amenity, fill = has_amenity)) +
    facet_wrap(. ~ amenity, scale = "free", ncol = 3) +
    geom_density(alpha = 0.4) + 
    labs(x = "Score", y = "Density", colour = "Has amenity", fill = "Has amenity")
  
  train_data_fig_2 <- train_data %>%
    select(member_years,num_reviews,helpful_votes,hotel_stars,rooms,num_hotel_reviews, score)%>%
    gather(key = predictor, value = value, -score)%>%
    ggplot(aes(x = value, y = as.factor(score), colour = as.factor(score), fill = as.factor(score))) +
    facet_wrap(. ~ predictor, scale = "free")+
    geom_density_ridges(alpha = 0.2)+ 
    labs(x = "", y = "Score", colour = "Score", fill = "Score")
  
  
  ggsave("score_distributions_across_predictors.png", 
         train_data_fig_1,
         width = 10, 
         height = 4)
  ggsave("numeric_predictor_distributions_across_scores.png", 
         train_data_fig_2,
         width = 10, 
         height = 4)
}

main(opt[["--train"]], opt[["--out_dir"]])