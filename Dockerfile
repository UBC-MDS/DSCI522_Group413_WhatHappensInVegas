FROM debian:stable

# checking for updates and installing other dependencies of R
RUN apt-get update 
RUN apt-get install apt-utils -y
RUN apt-get install libssl-dev -y
RUN apt-get install libxml2-dev -y
RUN apt-get install libcurl4-openssl-dev -y


# install R
RUN apt-get install r-base r-base-dev -y 


# install R packages
RUN Rscript -e "install.packages('docopt')"
RUN Rscript -e "install.packages('gridExtra')"
RUN Rscript -e "install.packages('repr')"
RUN Rscript -e "install.packages('GGally')"
RUN Rscript -e "install.packages('ggplot2')"
RUN Rscript -e "install.packages('readr')"
RUN Rscript -e "install.packages('reticulate')"
RUN Rscript -e "install.packages('ggridges')"
RUN Rscript -e "install.packages('ggthemes')"
RUN Rscript -e "install.packages('tidyverse')"
RUN Rscript -e "install.packages('kableExtra')"
RUN Rscript -e "install.packages('caret')"


#install python
RUN apt-get install python3 -y 


# install pip
RUN apt install python3-pip -y


# altair
RUN pip3 install altair vega_datasets

# pandas
RUN pip3 install pandas
#install numpy
RUN pip3 install numpy

# install seleniums
RUN pip3 install -U selenium

# install docopt
RUN pip3 install docopt==0.6.2
RUN pip3 install -U scikit-learn
RUN pip3 install matplotlib


# install wget and unzip
RUN apt-get install wget -y
RUN apt-get install unzip 

# install chromium and chromedriver
RUN apt-get update && apt install -y chromium && apt-get install -y libnss3 && apt-get install unzip

# Install chromedriver
RUN wget -q "https://chromedriver.storage.googleapis.com/79.0.3945.36/chromedriver_linux64.zip" -O /tmp/chromedriver.zip \
    && unzip /tmp/chromedriver.zip -d /usr/bin/ \
    && rm /tmp/chromedriver.zip && chown root:root /usr/bin/chromedriver && chmod +x /usr/bin/chromedriver
    
    
#install pandoc
RUN apt-get install pandoc -y
RUN apt-get install pandoc-citeproc -y
