# authors: Arun, Bronwyn, Manish
# date: 2020-01-23

"""Fits a linear regression model on the pre-processed training data from the Vegas strip data (from https://archive.ics.uci.edu/ml/machine-learning-databases/00397/LasVegasTripAdvisorReviews-Dataset.csv).
Saves the model as a rds file.
Usage: src/down_data.py --out_type=<out_type> --url=<url> --out_file=<out_file>
Options:
--out_type=<out_type>    Type of file to write locally (script supports either feather or csv)
--url=<url>              URL from where to download the data (must be in standard csv format)
--out_file=<out_file>    Path (including filename) of where to locally write the file
"""
  
from docopt import docopt
import requests
import os
import pandas as pd
import feather

opt = docopt(__doc__)

def main(out_type, url, out_file):
  try: 
    request = requests.get(url)
    request.status_code == 200
  except Exception as req:
    print("Website at the provided url does not exist.")
    print(req)
    
  data = pd.read_csv(url, header=None)
  
  if out_type == "csv":
    try:
      data.to_csv(out_file, index = False)
    except:
      os.makedirs(os.path.dirname(out_file))
      data.to_csv(out_file, index = False)
  elif out_type == "feather":
    try:  
      feather.write_dataframe(data, out_file)
    except:
      os.makedirs(os.path.dirname(out_file))
      feather.write_dataframe(data, out_file)

if __name__ == "__main__":
  main(opt["--out_type"], opt["--url"], opt["--out_file"])
