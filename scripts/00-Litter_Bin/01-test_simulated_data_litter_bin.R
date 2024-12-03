#### Preamble ####
# Purpose: Tests the structure and validity of the simulated litter bin dataset.
# Author: Jiwon Choi
# Date: 26 November 2024
# Contact: jwon.choi@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - The `tidyverse` package must be installed and loaded
# - 00-simulate_data_litter_bin.R must have been run
# - The `testthat` package must be installed and loaded

#### Workspace setup ####
library(tidyverse)
library(testthat)

# Load the dataset
analysis_data <- read_csv("../../data/00-simulated_data/simulated_data.csv")

#### Test data ####

# Test if the data was successfully loaded
test_that("Dataset is successfully loaded", {
  expect_true(exists("analysis_data"))
})

# Check if the dataset has 200 rows
test_that("Dataset has 200 rows", {
  expect_equal(nrow(analysis_data), 200)
})

# Check if the dataset has 4 columns
test_that("Dataset has 4 columns", {
  expect_equal(ncol(analysis_data), 4)
})

# Check if all values in the 'WARD' column are valid
test_that("WARD column contains only valid values", {
  valid_wards <- unique(1:10)  # Wards from 1 to 10
  expect_true(all(analysis_data$WARD %in% valid_wards))
})

# Check if the 'DAYS SERVICED' column contains only valid values
test_that("DAYS SERVICED column contains only valid values", {
  valid_days <- c(5, 6, 7)
  expect_true(all(analysis_data$`DAYS SERVICED` %in% valid_days))
})

# Check if the 'ASSET TYPE' column contains only valid values
test_that("ASSET TYPE column contains only valid values", {
  valid_asset_types <- c("WR1", "WR2", "WR3", "WR4")
  expect_true(all(analysis_data$`ASSET TYPE` %in% valid_asset_types))
})

# Check if the 'STATUS' column contains only valid values
test_that("STATUS column contains only valid values", {
  valid_statuses <- c("Existing", "Temporarily Removed", "Removed")
  expect_true(all(analysis_data$STATUS %in% valid_statuses))
})

# Check if there are any missing values in the dataset
test_that("Dataset contains no missing values", {
  expect_true(all(!is.na(analysis_data)))
})

# Check if there are no empty strings in the dataset
test_that("Dataset contains no empty strings", {
  expect_true(all(analysis_data$WARD != "" & 
                    analysis_data$`DAYS SERVICED` != "" & 
                    analysis_data$`ASSET TYPE` != "" & 
                    analysis_data$STATUS != ""))
})

# Check if the 'STATUS' column has at least two unique values
test_that("STATUS column contains at least two unique values", {
  expect_gte(n_distinct(analysis_data$STATUS), 2)
})
