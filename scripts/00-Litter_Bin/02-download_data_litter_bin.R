#### Preamble ####
# Purpose: Downloads and saves data from the City of Toronto's Open Data Portal 
#          on litter bin collection frequency for further analysis.
# Author: Jiwon Choi
# Date: 27 November 2024
# Contact: jwon.choi@mail.utoronto.ca
# License: MIT
# Pre-requisites: Ensure necessary R libraries (`opendatatoronto`, `readr`) are installed 
#                 and have an active internet connection to access the data portal.
# Any other information needed? Ensure write permissions to the `data/01-raw_data/` directory 
#                               to save the downloaded dataset.


#### Workspace setup ####
library(opendatatoronto)
library(readr)

# get package
package <- show_package("litter-bin-collection-frequency")
package

# get all resources for this package
resources <- list_package_resources("litter-bin-collection-frequency")

# identify datastore resources; by default, Toronto Open Data sets datastore resource format to CSV for non-geospatial and GeoJSON for geospatial resources
datastore_resources <- filter(resources, tolower(format) %in% c('csv', 'geojson'))

# load the first datastore resource as a sample
data <- filter(datastore_resources, row_number()==1) %>% get_resource()
data

#### Save data ####
# change the_raw_data to whatever name you assigned when you downloaded it.
write_csv(data, "data/01-raw_data/raw_data_litter_bin.csv") 

         
