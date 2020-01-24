# authors: Arun, Bronwyn, Manish
# date: 2020-01-23

"""Calculates MSE error for test set 

Usage: src/vegas_test_results.py  --test=<test> --out_dir=<out_dir>

Options:

--test=<test>     Path (including filename) to training data 
--out_dir=<out_dir> Path to directory where model results on test set need to be saved
"""
  
# importing required libraries

from docopt import docopt
import os
import matplotlib.pyplot as plt

from pandas.plotting import table
import numpy as np
import selenium

import pickle
import pandas as pd

# regressors / models
from sklearn.linear_model import LinearRegression, LogisticRegression, Lasso, Ridge

from sklearn.svm import  SVR
from sklearn.ensemble import  RandomForestRegressor

# Feature selection
from sklearn.feature_selection import RFE


# other

from sklearn.metrics import mean_squared_error
from sklearn.model_selection import train_test_split, GridSearchCV, cross_val_score
from sklearn.feature_extraction.text import CountVectorizer
import warnings
warnings.simplefilter(action='ignore', category=FutureWarning)

import altair as alt

opt = docopt(__doc__)

def main(test,  out_dir):
    test_data = pd.read_csv(test)
    X = test_data.drop('score', axis =1)
    y = test_data['score']
    
    # loading required features based on training
    cols_to_consider = np.load("results/features_to_use.npy", allow_pickle = True)
    X = X[cols_to_consider]
    
    # fetching trained model and predicting results
    model = pickle.load(open("results/finalized_model.sav", 'rb'))
    y_pred = model.predict(X)
    print("Model evaluated successfully on test data, MSE error - " , round(mean_squared_error( y, y_pred),3))
    # 
     
if __name__ == "__main__":
  main(opt["--test"], opt["--out_dir"])
