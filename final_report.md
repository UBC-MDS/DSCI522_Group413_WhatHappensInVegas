New York Airbnb Price Prediction 2019
================
Ofer Mansour, Jacky Ho, Anand Vemparala

  - [“What happens in vegas: Predicting hotel ratings from amenities
    provided”](#what-happens-in-vegas-predicting-hotel-ratings-from-amenities-provided)
      - [About](#about)
      - [Report](#report)
      - [Usage](#usage)
      - [Dependencies](#dependencies)
  - [References](#references)

# “What happens in vegas: Predicting hotel ratings from amenities provided”

  - author: Bronwyn Baillie , Arun Maria , Manish Joshi
  - contributors: Bronwyn Baillie , Arun Maria , Manish Joshi

Demo of a data analysis project for DSCI 522 (Data Science workflows); a
course in the Master of Data Science program at the University of
British Columbia.

## About

Here we attempt to build a linear regression model which can use data
about the hotel amenities and predict what kind of user ratings can be
expected for the hotel given these amenities are functional in the
hotel. Exploratory data analysis was performed in R and only on the
training data. Different hotel specific features were checked against
the ratings given to the hotel by the users. From the preliminary EDA it
became apparent that some features do not have much impact on the hotel
ratings whereas certain features such as the presence of a Swim pool and
wifi internet had a positive impact on the hotel ratings.

Our final liner model performed well on the unseen test data with a test
score of ….. and an overall accuracy calculated to be …

The Dataset chosen for the research project is the “Las Vegas Strip
Dataset” which is a collated information about customer feedback on 21
Hotels located in the Las Vegas Strip. The data is extracted from
popular and well-regarded travel portal “TripAdvisor”. -Moro, S., Rita,
P., & Coelho, J. (2017). Stripping customers’ feedback on hotels through
data mining: The case of Las Vegas Strip. Tourism Management
Perspectives, 23, 41-52. It was sourced from the UCI machine learning
repositories and can be found
[here](https://archive.ics.uci.edu/ml/datasets/Las+Vegas+Strip). Each
row in the data set represents information about the amenities present
in the hotel such as swimming pool, spa, wifi and other contextual data
and the user rating for the hotel.

## Report

The final report can be found

## Usage

To replicate the analysis, clone this GitHub repository, install the
[dependencies](#dependencies) listed below, and run the following
commands at the command line/terminal from the root directory of this
project:

    # download data
    #python src/download_data.py --out_type=feather #--url=http://mlr.cs.umass.edu/ml/machine-learning-databases/breast-cancer-wisconsin/wdbc.data #--out_file=data/raw/wdbc.feather
    
    # run eda report
    #Rscript -e "rmarkdown::render('src/breast_cancer_eda.Rmd')"
    
    # pre-process data
    #Rscript src/pre_process_wisc.r --input=data/raw/wdbc.feather --out_dir=data/processed
    
    # create exploratory data analysis figure and write to file
    #Rscript src/eda_wisc.r --train=data/processed/training.feather --out_dir=results
    
    
    # test model
    #Rscript src/breast_cancer_test_results.r --test=data/processed/test.feather --out_dir=results
    
    # render final report
    #Rscript -e "rmarkdown::render('doc/breast_cancer_predict_report.Rmd', output_format = #'github_document')"

## Dependencies

  - Python 3.7.3 and Python packages:
      - numpy==1.16.4
      - altair==3.2.0
      - selenium==3.141.0
      - sklearn==0.22.1
      - docopt==0.6.1
      - pandas==0.24.2
      - feather-format==0.4.0
  - R version 3.6.1 and R packages:
      - knitr==1.26
      - feather==0.3.5
      - tidyverse==1.3
      - caret==6.0-85
      - ggridges==0.5.2
      - ggthemes==4.2.0
      - ggplot2==3.2.1
      - readr==1.3.1
      - ggally==1.4.0
      - repr==1.0.2
      - gridextra==2.3
      - reticulate==1.14

# References
