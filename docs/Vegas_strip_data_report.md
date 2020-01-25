What happens in vegas: Predicting hotel ratings from amenities provided
================
Bronwyn Baillie, Arun Maria, Manish Joshi </br>
2020/1/24 (updated: 2020-01-25)

# Summary

Here we attempt to build a linear regression model which can use
data(Moro 2017) about the hotel amenities and predict what kind of user
ratings can be expected for the hotel given these amenities are
functional in the hotel. Exploratory data analysis was performed in R(R
Core Team 2019) and only on the training data. Different hotel specific
features were checked against the ratings given to the hotel by the
users. From the preliminary EDA it became apparent that some features do
not have much impact on the hotel ratings whereas certain features such
as the presence of a Swim pool and wifi internet had a positive impact
on the hotel ratings.

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

From the preliminary EDA(Wickham 2017) it became apparent that some
features do not have much impact on the hotel ratings whereas certain
features such as the presence of a Swim pool and wifi internet had a
positive impact on the hotel ratings.

<div class="figure">

<img src="../src/eda_plots/numeric_predictor_distributions_across_scores.png" alt="Figure 1. Hotel scores distribution for numeric features" width="100%" />

<p class="caption">

Figure 1. Hotel scores distribution for numeric features

</p>

</div>

<div class="figure">

<img src="../src/eda_plots/score_distributions_across_predictors.png" alt="Figure 2. Hotel scores distribution for categorical features" width="100%" />

<p class="caption">

Figure 2. Hotel scores distribution for categorical features

</p>

</div>

The training of the model was done in Python(Van Rossum and Drake 2009).
The model(Pedregosa et al. 2011) performed poorly with a high Mean
Square Error when all the features were used in the training dataset.
Linear regression (weights) values were used to determine the important
features and the rest of the features were removed to train data.

<div class="figure">

<img src="../results/result_features.png" alt="Figure 2. Realation between number of features and validation error" width="100%" />

<p class="caption">

Figure 2. Realation between number of features and validation error

</p>

</div>

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

  - Results(Sievert 2018) of the fitting model are as shown below. The
    error metric used is MSE (mean square error)

  - The final error obtained on the unseen test data is 0.867 which is
    similar to the training error obtained. The model generalizes well
    and does not overfit.

<div class="figure">

<img src="../results/error_table.png" alt="Figure 3. The error metric used is Mean Square Error (MSE)." width="100%" />

<p class="caption">

Figure 3. The error metric used is Mean Square Error (MSE).

</p>

</div>

# References

<div id="refs" class="references">

<div id="ref-vegas">

Moro, Rita, S. 2017. “UCI Machine Learning Repository.” University of
California, Irvine, School of Information; Computer Sciences.
<https://archive.ics.uci.edu/ml/datasets/Las+Vegas+Strip>.

</div>

<div id="ref-scikit-learn">

Pedregosa, F., G. Varoquaux, A. Gramfort, V. Michel, B. Thirion, O.
Grisel, M. Blondel, et al. 2011. “Scikit-Learn: Machine Learning in
Python.” *Journal of Machine Learning Research* 12: 2825–30.

</div>

<div id="ref-R">

R Core Team. 2019. *R: A Language and Environment for Statistical
Computing*. Vienna, Austria: R Foundation for Statistical Computing.
<https://www.R-project.org/>.

</div>

<div id="ref-2018-altair">

Sievert, Jacob VanderPlas AND Brian E. Granger AND Jeffrey Heer AND
Dominik Moritz AND Kanit Wongsuphasawat AND Arvind Satyanarayan AND
Eitan Lees AND Ilia Timofeev AND Ben Welsh AND Scott. 2018. “Altair:
Interactive Statistical Visualizations for Python.” *The Journal of Open
Source Software* 3 (32). <http://idl.cs.washington.edu/papers/altair>.

</div>

<div id="ref-Python">

Van Rossum, Guido, and Fred L. Drake. 2009. *Python 3 Reference Manual*.
Scotts Valley, CA: CreateSpace.

</div>

<div id="ref-tidyverse">

Wickham, Hadley. 2017. *Tidyverse: Easily Install and Load the
’Tidyverse’*. <https://CRAN.R-project.org/package=tidyverse>.

</div>

</div>
