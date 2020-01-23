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
  train_data <- read_feather(train) %>% 
    gather(key = predictor, value = value, -class) %>% 
    mutate(predictor = str_replace_all(predictor, "_", " ")) %>% 
    ggplot(aes(x = value, y = class, colour = class, fill = class)) +
    facet_wrap(. ~ predictor, scale = "free", ncol = 4) +
    geom_density_ridges(alpha = 0.8) +
    scale_fill_tableau() +
    scale_colour_tableau() +
    guides(fill = FALSE, color = FALSE) +
    theme(axis.title.x = element_blank(),
          axis.title.y = element_blank())
  ggsave(paste0(out_dir, "/predictor_distributions_across_class.png"), 
         train_data,
         width = 8, 
         height = 10)
}

main(opt[["--train"]], opt[["--out_dir"]])