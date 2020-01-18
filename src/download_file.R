# authors: Arun, Bronwyn, Manish
# date: 2020-01-17

"The script downloads a file from specified url to specified location on location machine.

Usage: download_file.R <file_source> <destination_file>
" -> doc

library(tidyverse)
library(docopt)

opt <- docopt(doc)
print(opt)

main <- function(file_source, destination_file){
  
  download.file(file_source, destination_file)
}
  



main(opt$file_source, opt$destination_file)