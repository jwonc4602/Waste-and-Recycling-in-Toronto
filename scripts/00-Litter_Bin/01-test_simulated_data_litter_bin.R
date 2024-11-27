#### Preamble ####
# Purpose: Tests the structure and validity of the simulated waste management dataset.
# Author: Jiwon Choi
# Date: 26 November 2024
# Contact: jwon.choi@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - The `tidyverse` package must be installed and loaded
# - 00-simulate_data.R must have been run

#### Workspace setup ####
library(tidyverse)

analysis_data <- read_csv("data/00-simulated_data/simulated_data.csv")

# Test if the data was successfully loaded
if (exists("analysis_data")) {
  message("Test Passed: The dataset was successfully loaded.")
} else {
  stop("Test Failed: The dataset could not be loaded.")
}


#### Test data ####

# Check if the dataset has 200 rows
if (nrow(analysis_data) == 200) {
  message("Test Passed: The dataset has 200 rows.")
} else {
  stop("Test Failed: The dataset does not have 200 rows.")
}

# Check if the dataset has 4 columns
if (ncol(analysis_data) == 4) {
  message("Test Passed: The dataset has 4 columns.")
} else {
  stop("Test Failed: The dataset does not have 4 columns.")
}

# Check if all values in the 'WARD' column are valid
valid_wards <- unique(1:10)  # Wards from 1 to 10

if (all(analysis_data$WARD %in% valid_wards)) {
  message("Test Passed: The 'WARD' column contains only valid ward numbers.")
} else {
  stop("Test Failed: The 'WARD' column contains invalid ward numbers.")
}

# Check if the 'DAYS SERVICED' column contains only valid values
valid_days <- c(5, 6, 7)

if (all(analysis_data$`DAYS SERVICED` %in% valid_days)) {
  message("Test Passed: The 'DAYS SERVICED' column contains only valid values.")
} else {
  stop("Test Failed: The 'DAYS SERVICED' column contains invalid values.")
}

# Check if the 'ASSET TYPE' column contains only valid values
valid_asset_types <- c("WR1", "WR2", "WR3", "WR4")

if (all(analysis_data$`ASSET TYPE` %in% valid_asset_types)) {
  message("Test Passed: The 'ASSET TYPE' column contains only valid values.")
} else {
  stop("Test Failed: The 'ASSET TYPE' column contains invalid values.")
}

# Check if the 'STATUS' column contains only valid values
valid_statuses <- c("Existing", "Temporarily Removed", "Removed")

if (all(analysis_data$STATUS %in% valid_statuses)) {
  message("Test Passed: The 'STATUS' column contains only valid values.")
} else {
  stop("Test Failed: The 'STATUS' column contains invalid values.")
}

# Check if there are any missing values in the dataset
if (all(!is.na(analysis_data))) {
  message("Test Passed: The dataset contains no missing values.")
} else {
  stop("Test Failed: The dataset contains missing values.")
}

# Check if there are no empty strings in the dataset
if (all(analysis_data$WARD != "" & analysis_data$`DAYS SERVICED` != "" & 
        analysis_data$`ASSET TYPE` != "" & analysis_data$STATUS != "")) {
  message("Test Passed: There are no empty strings in the dataset.")
} else {
  stop("Test Failed: There are empty strings in one or more columns.")
}

# Check if the 'STATUS' column has at least two unique values
if (n_distinct(analysis_data$STATUS) >= 2) {
  message("Test Passed: The 'STATUS' column contains at least two unique values.")
} else {
  stop("Test Failed: The 'STATUS' column contains less than two unique values.")
}

