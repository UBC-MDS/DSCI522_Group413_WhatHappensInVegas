# authors: Arun, Bronwyn, Manish
# date: 2020-01-23

"""Fits a linear regression model on the pre-processed training data from the Vegas strip data (from https://archive.ics.uci.edu/ml/machine-learning-databases/00397/LasVegasTripAdvisorReviews-Dataset.csv).
Saves the model results.

Usage: src/fit_vegas_predict_model.py  --train=<train> --out_dir=<out_dir>

Options:

--train=<train>     Path (including filename) to training data 
--out_dir=<out_dir> Path to directory where the serialized model results should be written
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

def main(train,  out_dir):
    out_dir = "results"
    os.makedirs(out_dir)
    
    # Loading Dividing data into training and test set features
    vegas_data = pd.read_csv(train )
    
    vegas_data.head()
    X = vegas_data.drop('score', axis =1)
    y = vegas_data['score']
    
    # splitting data further into training and test set to see if our results can generalize
    
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size =0.2, random_state =5)
    
    
    
    #functions used 
    
    
    def fit_and_report(model, X, y, Xv, yv, mode = 'regression'):
        """
        The functon fits a model(regression or classification) based on mode
        and then calcualtes the training set and validaton set error 
        
        Parameters
        ---------
        model - name of model object
        X - training set features(predictors)
        y - training set label(response variable)
        Xv - validation set features(predictors)
        yv - validation set label(response variable)
        mode -  can take two values - regression or classification 
        
        
        Returns
        --------
        errors - A list of two elements with first element as error on training set 
                and second element as error on test set
        
       
        """
        model.fit(X, y)
        if mode.lower().startswith('regress'):
            errors = [mean_squared_error(y, model.predict(X)), mean_squared_error(yv, model.predict(Xv))]
        if mode.lower().startswith('classif'):
            errors = [1  - model.score(X,y), 1 - model.score(Xv,yv)]        
        return errors
    
    
    
    ## functions to fit model
    
    def grid_fit_model(model, X_train, y_train,  parameters= None, cv = 5):
        """
        Function to fit a model based parameters specified.
        
        """
        if parameters is None:
            model.fit(X_train,y_train)
            return model 
        else :
            grid_model = GridSearchCV(model, param_grid = parameters, cv= cv, 
                                      scoring = 'neg_mean_squared_error', return_train_score=True, iid = True)
            grid_model.fit(X_train, y_train)
            return grid_model
        
        
        
    def model_results(model):
        """
        Function to show results of model
        
        """
        
        results = pd.DataFrame(model.cv_results_)[['params', 'mean_train_score', 'mean_test_score']]
        results['mean_train_error'] = -results['mean_train_score']
        results['mean_valid_error'] = -results['mean_test_score']
        results = results.drop(['mean_train_score','mean_test_score'], axis = 1)
        return results
    
    
    
    #FEATURE ENGINEERING
        
    
    # feature Engineering 
    
    results = { 'features_selected' :[],
              'train_error': [],
              'validation_error':[]}
    
    
    for i in range(1,X_train.shape[1]):
        lin_model = LinearRegression()
        rec_model = RFE(lin_model, n_features_to_select=i, step=1)
        results['features_selected'].append(i)
        results['train_error'].append(fit_and_report(rec_model, X_train, y_train,X_test, y_test, "regression" )[0])
        results['validation_error'].append(fit_and_report(rec_model, X_train, y_train,X_test, y_test, "regression" )[1])
        
    errors_df = pd.DataFrame(results)
    errors_df = pd.melt(errors_df, id_vars=['features_selected'], value_vars=['train_error', 'validation_error'],
         var_name='error_type', value_name='error')
    
    #errors_df.head()
    
    chart = alt.Chart(errors_df).mark_line().encode(
        x =alt.X( 'features_selected:Q', title ="Number of Features selected"),
        y = alt.Y( 'error:Q', title ="Mean Squared Error"),
        color = "error_type").properties(
    title = "MSE error based on number features selected")   
    
    chart.save(out_dir +"/result_features.png")
    
     ## Simple linear regression 
    model = LinearRegression()
    model.fit(X_train, y_train)
    cols_to_consider = X_train.columns[np.argsort(model.coef_)][[-1,-2,-3,-4,-5,-6,-7]]

    ## saving important features in numpy arraay to disk
    
    np.save(out_dir +"/features_to_use", cols_to_consider, allow_pickle= True)
    
    
    X_train = X_train[cols_to_consider]
    X_test =  X_test[cols_to_consider]
    model = LinearRegression()
    model.fit(X_train, y_train)
   
    
    
    # Ridge regression 
    rid_model = Ridge()
    parameters = {
        'alpha' : np.logspace(-6, 6, 13)
    }
    model = grid_fit_model(rid_model,X_train,y_train,parameters= parameters, cv=10 )
    
    
    #saving model
    filename = '/finalized_model.sav'
    pickle.dump(model, open(out_dir +filename, 'wb'))
     # EDIT: see deprecation warnings below

    #exporting results on test set
    results_df = model_results(model)
    results_df['alpha'] = np.logspace(-6, 6, 13) 
    results_df['Training'] = results_df['mean_train_error'] 
    results_df['Validation'] = results_df['mean_valid_error'] 
    results_df = results_df.drop(columns = ["params","mean_train_error","mean_valid_error" ])
    results_df = results_df.melt(id_vars = ["alpha"], value_vars = ["Training","Validation"], var_name = "error_type", value_name = "mean_error")
    results_df.to_csv(out_dir + "/hyperparamter_results.csv")
    chart = alt.Chart(results_df).mark_line().encode(
        x = alt.X( 'alpha:Q', title ="alpha", scale = alt.Scale(type = 'log')),
        y = alt.Y( 'mean_error:Q', title ="Mean Squared Error"),
        color = alt.Color("error_type", title = "Error Type")).properties(
    title = "MSE error based on hyperparameter alpha")

    chart.save(out_dir +"/cv_results.png")
    
  
if __name__ == "__main__":
  main(opt["--train"], opt["--out_dir"])
