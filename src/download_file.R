# authors: Arun, Bronwyn, Manish
# date: 2020-01-17

"The script downloads a file from specified url to specified location on location machine.

Usage: src/download_file.R <file_source> <destination_file>

Options:
<file_source>         Takes in a link to the data (this is a required positional argument)
<destination_file>    Takes in a file path (this is a required option)
" -> doc

library(tidyverse)
library(docopt)

opt <- docopt(doc)
print(opt)

main <- function(file_source, destination_file){
  
  download.file(file_source, destination_file)
  
}
  



main(opt$file_source, opt$destination_file)