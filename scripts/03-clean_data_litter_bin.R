#### Preamble ####
# Purpose: Cleans the raw litter bin data for analysis of equity and prediction models.
# Author: Jiwon Choi
# Date: 26 November 2024
# Contact: jwon.choi@mail.utoronto.ca
# License: MIT
# Pre-requisites: 02-download_data.R
# Any other information needed? Ensure the tidyverse and readr libraries are installed.

#### Workspace setup ####
library(tidyverse)
library(readr)

# Load the raw dataset
litter_bin_data <- read_csv("data/01-raw_data/raw_data.csv")

# Select only the needed columns and drop rows with missing values
cleaned_data_with_BIA <- litter_bin_data %>%
  select(
    WARD,            # Ward information
    BIA,             # Business Improvement Area
    `DAYS SERVICED`, # Number of days the bin is serviced
    `ASSET TYPE`,    # Type of litter bin
    STATUS           # Status of the bin (active/inactive)
  ) %>%
  drop_na()          # Remove rows with any missing values

cleaned_data <- litter_bin_data %>%
  select(
    WARD,            # Ward information
    `DAYS SERVICED`, # Number of days the bin is serviced
    `ASSET TYPE`,    # Type of litter bin
    STATUS           # Status of the bin (active/inactive)
  ) %>%
  drop_na()          # Remove rows with any missing values

#### Save data ####
write_csv(cleaned_data_with_BIA, "data/02-analysis_data/cleaned_data_BIA.csv")
write_csv(cleaned_data, "data/02-analysis_data/cleaned_data.csv")

