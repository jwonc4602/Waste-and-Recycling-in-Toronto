#### Preamble ####
# Purpose: Tests the integrity and validity of the aggregated waste management dataset
# Author: Jiwon Choi
# Date: 26 November 2024
# Contact: jwon.choi@mail.utoronto.ca
# License: MIT
# Pre-requisites: 02-download_data_litter_bin.R, 03-clean_data_litter_bin.R

#### Workspace setup ####
library(tidyverse)
library(testthat)

# Load the dataset
data <- read_csv("../../data/02-analysis_data/cleaned_data_litter.csv")

#### Test data ####
# Test that the dataset has the correct number of rows (5 rows for metrics)
test_that("dataset has 11 rows", {
  expect_equal(nrow(data), 11)
})

# Test that the dataset has the correct number of columns (26 columns for wards and labels)
test_that("dataset has 26 columns", {
  expect_equal(ncol(data), 26)
})

# Test that the `Value_Label` column is character type
test_that("'Value_Label' column is character", {
  expect_type(data$Value_Label, "character")
})

# Test that the ward columns contain numeric data
test_that("ward columns contain numeric data", {
  numeric_cols <- names(data)[-1]  # Exclude 'Value_Label'
  expect_true(all(sapply(data[numeric_cols], is.numeric)))
})

# Test that all ward columns have non-negative values
test_that("ward columns have non-negative values", {
  numeric_cols <- names(data)[-1]  # Exclude 'Value_Label'
  expect_true(all(sapply(data[numeric_cols], function(col) all(col >= 0))))
})

# Test that the `Value_Label` column contains expected metrics
test_that("'Value_Label' contains expected metrics", {
  expected_labels <- c("Days serviced - 1", "Days serviced - 3", "Days serviced - 4", "Days serviced - 5", "Days serviced - 7",
                       "Asset type - WR1", "Asset type - WR2", "Asset type - WR3", "Asset type - WR4", "Asset type - WR5",
                       "Status - Existing", "Status - Temporarily Removed")
  expect_true(all(data$Value_Label %in% expected_labels))
})

# Test that ward columns match expected names
test_that("ward columns match expected names", {
  expected_wards <- paste0("Ward", 1:25)
  actual_wards <- names(data)[-1]  # Exclude 'Value_Label'
  expect_equal(actual_wards, expected_wards)
})
