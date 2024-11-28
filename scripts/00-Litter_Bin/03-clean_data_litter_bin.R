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
litter_bin_data <- read_csv("data/01-raw_data/raw_data_litter_bin.csv")

cleaned_data <- litter_bin_data %>%
  select(
    WARD,            # Ward information
    'DAYS SERVICED', # Number of days the bin is serviced
    'ASSET TYPE',    # Type of litter bin
    STATUS           # Status of the bin (active/inactive)
  ) %>%
  drop_na()          # Remove rows with any missing values

# Convert WARD to Ward1, Ward2, ..., Ward25 format and ensure the order
cleaned_data <- cleaned_data %>%
  mutate(WARD = paste0("Ward", as.numeric(WARD))) %>%
  mutate(WARD = factor(WARD, levels = paste0("Ward", 1:25))) # Explicitly order WARD


# Save the transposed dataset
write_csv(cleaned_data, "data/02-analysis_data/cleaned_data_litter.csv")

