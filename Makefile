# vegas data pipeline
# author: Arun, Bronwyn, Manish
# date: 2020-01-30

all : data/raw/vegas_data.csv docs/EDA_vegas_strip_data.md data/processed/test_ml.csv data/processed/train_vegas_plot.csv data/processed/training_ml.csv src/eda_plots/numeric_predictor_distributions_across_scores.png src/eda_plots/score_distributions_across_predictors.png results/features_to_use.npy results/finalized_model.sav results/result_features.png results/hyperparameter_results.csv docs/Vegas_strip_data_report.md


# download data
data/raw/vegas_data.csv : src/download_file.R
	Rscript src/download_file.R https://archive.ics.uci.edu/ml/machine-learning-databases/00397/LasVegasTripAdvisorReviews-Dataset.csv data/raw/vegas_data.csv


#EDa markdown
docs/EDA_vegas_strip_data.md : docs/EDA_vegas_strip_data.Rmd
	Rscript -e "rmarkdown::render('docs/EDA_vegas_strip_data.Rmd', output_format = 'github_document')"
	
	

# pre-process data
data/processed/test_ml.csv data/processed/train_vegas_plot.csv data/processed/training_ml.csv : src/pre_process_vegas.R data/raw/vegas_data.csv
	Rscript src/pre_process_vegas.R --input=data/raw/vegas_data.csv --out_dir=data/processed

# create exploratory data analysis figure and write to file
src/eda_plots/numeric_predictor_distributions_across_scores.png src/eda_plots/score_distributions_across_predictors.png : src/eda_figures.R data/processed/train_vegas_plot.csv
	Rscript src/eda_figures.R --train=data/processed/train_vegas_plot.csv --out_dir=src/eda_plots
	
	


# delete older results(if any) tune model
results/features_to_use.npy results/finalized_model.sav results/result_features.png results/hyperparameter_results.csv : src/fit_vegas_predict_model.py data/processed/training_ml.csv
	 rm -rf results
	 python src/fit_vegas_predict_model.py  --train=data/processed/training_ml.csv --out_dir=results


# test model
results/ : src/vegas_test_results.py data/processed/test_ml.csv  
	python src/vegas_test_results.py  --test=data/processed/test_ml.csv --out_dir=results

# render final report
docs/Vegas_strip_data_report.md : docs/Vegas_strip_data_report.Rmd docs/vegas_hotels_refs.bib
	Rscript -e "rmarkdown::render('docs/Vegas_strip_data_report.Rmd', 'github_document')"

clean:
	rm -rf results
	rm -rf data/processed/*
	rm -rf data/raw/*
	rm -rf docs/EDA_vegas_strip_data.html docs/EDA_vegas_strip_data.md docs/EDA_vegas_strip_data_files/* 
	rm -rf docs/Vegas_strip_data_report.md
	rm -rf src/eda_plots/*