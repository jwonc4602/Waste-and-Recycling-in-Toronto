#### Preamble ####
# Purpose: Tests the integrity and validity of the transposed waste management dataset
# Author: Jiwon Choi
# Date: 27 November 2024
# Contact: jwon.choi@mail.utoronto.ca
# License: MIT
# Pre-requisites: 02-download_data_litter_bin.R, 03-clean_data_litter_bin.R

#### Workspace setup ####
library(tidyverse)
library(testthat)

# Load the dataset
data <- read_csv("../../data/02-analysis_data/cleaned_data_litter.csv")

#### Test data ####
# Test that the dataset has the correct number of rows (should match unique WARD count + Value_Label as header)
test_that("dataset has correct number of rows", {
  expected_rows <- 25  # Assuming 25 wards + header row
  expect_equal(nrow(data), expected_rows)
})

# Test that the dataset has the correct number of columns (metrics from Value_Label)
test_that("dataset has correct number of columns", {
  expected_cols <- 12  # Based on unique Value_Label categories
  expect_equal(ncol(data), expected_cols)
})

# Test that the WARD column is character type
test_that("'WARD' column is character", {
  expect_type(data$WARD, "character")
})

# Test that metric columns contain numeric data
test_that("metric columns contain numeric data", {
  metric_cols <- names(data)[-1]  # Exclude 'WARD'
  expect_true(all(sapply(data[metric_cols], is.numeric)))
})

# Test that all metric columns have non-negative values
test_that("metric columns have non-negative values", {
  metric_cols <- names(data)[-1]  # Exclude 'WARD'
  expect_true(all(sapply(data[metric_cols], function(col) all(col >= 0))))
})

# Test that the metric columns contain expected metrics
test_that("metric columns contain expected metrics", {
  # Dynamically generate expected metrics from available data
  actual_metrics <- names(data)[-1]  # Exclude 'WARD'
  available_metrics <- c(
    paste0("Days serviced - ", c(1, 3, 4, 5, 7)),
    paste0("Asset type - ", c('WR1', 'WR2', 'WR3', 'WR4')),
    paste0("Status - ", c("Existing", "Temporarily Removed"))
  )
  expect_equal(sort(actual_metrics), sort(available_metrics))
})

