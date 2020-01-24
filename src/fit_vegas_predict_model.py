# authors: Arun, Bronwyn, Manish
# date: 2020-01-23

"""Fits a linear regression model on the pre-processed training data from the Vegas strip data (from https://archive.ics.uci.edu/ml/machine-learning-databases/00397/LasVegasTripAdvisorReviews-Dataset.csv).
Saves the model results.

Usage: src/fit_vegas_predict_model.py  --train=<train> --out_dir=<out_dir>

Options:

--train=<train>     Path (including filename) to training data 
--out_dir=<out_dir> Path to directory where the serialized model should be written
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
        y = alt.X( 'error:Q', title ="Mean Squared Error"),
        color = "error_type").properties(
    title = "MSE error based on number features selected")   
    
    chart.save(out_dir +"/result_features.png")
    
     ## Simple linear regression 
    model = LinearRegression()
    model.fit(X_train, y_train)
    #mean_squared_error(y_test, model.predict(X_test))
    
    #print(np.argsort(model.coef_))
    #
    #np.sort(model.coef_)
    #
    #X_train.columns[np.argsort(model.coef_)]
    
    # based on this features of interest are 
    
    # cols_to_consider = X_train.columns[np.argsort(model.coef_)][[0,1,-1,-2,-3,-4,-5,-6,-7,-8, -10, -12, -14, -18, -21, 4]]
    # cols_to_consider = X_train.columns[np.argsort(model.coef_)][[-1,-2,-3,-4,-5,-6,-7,-8, -10,  -18,  4]]
    cols_to_consider = X_train.columns[np.argsort(model.coef_)][[-1,-2,-3,-4,-5,-6,-7]]
    # hotel specific
    # cols_to_consider = X_train.columns[np.argsort(model.coef_)][[1,4,6,12,13, 16,21,22, 23,25,30]]
    # cols_to_consider = X_train.columns[np.argsort(model.coef_)][[25,30]]
    
    
    #cols_to_consider
    ## saving important features in numpy arraay to disk
    
    np.save(out_dir +"/features_to_use", cols_to_consider, allow_pickle= True)
    
    #test
    #test = np.load("test.npy", allow_pickle = True )
    #print(test)
    # modeling on the important features
    
    X_train = X_train[cols_to_consider]
    X_test =  X_test[cols_to_consider]
    model = LinearRegression()
    model.fit(X_train, y_train)
    #mean_squared_error(y_test, model.predict(X_test))
    
    
    
    ##Checking random forest regressor- best off the shelf method
    #test_ran = RandomForestRegressor()
    #parameters =  {
    #    'n_estimators' : [50,100, 150],
    #    
    #    'max_depth' : [5,10, 15]
    #}
    #
    #model = grid_fit_model(test_ran,X_train,y_train,parameters= parameters, cv=10 )
    
    #print(model_results(model))
    #-1*model.best_score_
    
    # error on test set -- not that good.
    #mean_squared_error(y_test, model.predict(X_test))
    
    
    
    
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
    ax = plt.subplot(111, frame_on=False) # no visible frame
    ax.xaxis.set_visible(False)  # hide the x axis
    ax.yaxis.set_visible(False)  # hide the y axis
    
    table(ax, results_df, loc = "center",  colWidths = [0.5]*len(results_df.columns),
        
        cellLoc = 'center', rowLoc = 'center')
    
    plt.savefig(out_dir +'/error_table.png', bbox_inches='tight')
    
    print("Model fitted based on training data and results are generated ")
    #print()
    #print("Best validation score",-1*model.best_score_)
    #
    ## error on test set -- not that good.
    #print("Error on test set", mean_squared_error(y_test, model.predict(X_test)))
    
    
    #
    #
    #
    ##  Lasso regression - linear regression with regularizaton 
    #rid_model = Lasso()
    #parameters = {
    #    'alpha' : np.logspace(-6, 6, 13)
    #}
    #model = grid_fit_model(rid_model,X_train,y_train,parameters= parameters, cv=10 )
    #print(model_results(model))
    #print("Best validation score",-1*model.best_score_)
    #
    ## error on test set -- not that good.
    #print("Error on test set", mean_squared_error(y_test, model.predict(X_test)))
    
    
    
    #
    #
    ## SVM(lnear kernel)
    ##  Lasso regression - linear regression with regularizaton 
    #svr_model = SVR()
    #parameters = {
    #    'kernel':['linear', 'poly', 'rbf'],
    #    'gamma' : ['scale', 'auto'],'C':[0.01,0.05, 0.1,0.2,0.5,1]  }
    #model = grid_fit_model(svr_model,X_train,y_train,parameters= parameters, cv=10 )
    #print(model_results(model))
    #print("Best validation score",-1*model.best_score_)
    #
    ## error on test set -- not that good.
    #print("Error on test set", mean_squared_error(y_test, model.predict(X_test)))

     
if __name__ == "__main__":
  main(opt["--train"], opt["--out_dir"])
