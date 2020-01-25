What happens in vegas: Predicting hotel ratings from amenities provided
================
Bronwyn Baillie, Arun Maria, Manish Joshi </br>
2020/1/24

  - [Summary](#summary)
  - [Introduction](#introduction)
  - [Methods](#methods)
      - [Data](#data)
      - [Analysis](#analysis)
  - [Results](#results)
  - [References](#references)

# Summary

Here we attempt to build a linear regression model which can use data
about the hotel amenities and predict what kind of user ratings can be
expected for the hotel given these amenities are functional in the
hotel. Exploratory data analysis was performed in R and only on the
training data. Different hotel specific features were checked against
the ratings given to the hotel by the users. From the preliminary EDA it
became apparent that some features do not have much impact on the hotel
ratings whereas certain features such as the presence of a Swim pool and
wifi internet had a positive impact on the hotel ratings.

# Introduction

Most travel and hotel bookings are nowadays being made online and one of
the key parameters a potential consumer refers to before deciding on
which hotel to book is the ratings given to a hotel by the previous
users. For this project we are trying to answer the question: Given the
presence of certain amenities in a hotel what is the expected average
user rating for that hotel? Tourism industry professionals, travel
agents, investors and Hotel owners who wish to attract clients can draw
benefit from such a model.

# Methods

## Data

The Dataset chosen for the research project is the “Las Vegas Strip
Dataset” which is a collated information about customer feedback on 21
Hotels located in the Las Vegas Strip. The data is extracted from
popular, respected and well-regarded travel portal “TripAdvisor”. -Moro,
S., Rita, P., & Coelho, J. (2017). Stripping customers’ feedback on
hotels through data mining: The case of Las Vegas Strip. Tourism
Management Perspectives, 23, 41-52. It was sourced from the UCI machine
learning repositories and can be found
[here](https://archive.ics.uci.edu/ml/datasets/Las+Vegas+Strip). Each
row in the data set represents information about the amenities present
in the hotel such as swimming pool, spa, wifi and other contextual data
and the user rating for the hotel.

## Analysis

From the preliminary EDA it became apparent that some features do not
have much impact on the hotel ratings whereas certain features such as
the presence of a Swim pool and wifi internet had a positive impact on
the hotel ratings.

The training of the model was done in Python. The model performed poorly
with a high Mean Square Error when all the features were used in the
training dataset. Linear regression (weights) values were used to
determine the important features and the rest of the features were
removed to train data.
<img src="../results/result_features.png" title="Figure 2. Realation between number of features and validation error" alt="Figure 2. Realation between number of features and validation error" width="100%" />

The features which had a significant impact on the user scores were 1.
Swimming pool, 2.Free Wifi Internet and the Visitor’s continent. These
metrics were in line with what was seen during the EDA stage.

The Model was then trained with a different regression algorithms such
as 1. linear regression 2. RFregressor 3. Lasso 4. ridge regression and
5. SVM. from sklearn package in Python. A 10- fold cross validation was
used to determine the best hyperparameters. It was found that the best
performing algorithm on the validation set was the ridge
regression(regularized Liner regression) and this was chosen as the
final model.

# Results

  - Results of the fitting model are as shown below. The error metric
    used is MSE (mean square error)

  - The final error obtained on the unseen test data is 0.867 which is
    similar to the training error obtained. The model generalizes well
    and does not overfit.

<img src="../results/error_table.png" title="Figure 3. The error metric used is Mean Square Error (MSE)." alt="Figure 3. The error metric used is Mean Square Error (MSE)." width="100%" />

# References