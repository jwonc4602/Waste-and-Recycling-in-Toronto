#### Preamble ####
# Purpose: Tests the integrity and validity of the cleaned litter bin dataset
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
# Test that the dataset has 10,468 rows
test_that("dataset has 10,468 rows", {
  expect_equal(nrow(data), 10468)
})

# Test that the dataset has 4 columns
test_that("dataset has 4 columns", {
  expect_equal(ncol(data), 4)
})

# Test that the WARD column is character type
test_that("'WARD' is character", {
  expect_type(data$WARD, "character")
})

# Test that the DAYS SERVICED column is numeric
test_that("'DAYS SERVICED' is numeric", {
  expect_type(data$'DAYS SERVICED', "double")
})

# Test that the ASSET TYPE column is character type
test_that("'ASSET TYPE' is character", {
  expect_type(data$'ASSET TYPE', "character")
})

# Test that the STATUS column is character type
test_that("'STATUS' is character", {
  expect_type(data$STATUS, "character")
})

# Test that there are no missing values in the dataset
test_that("no missing values in dataset", {
  expect_true(all(!is.na(data)))
})

# Test that WARD contains unique values (e.g., no unrecognized wards)
test_that("'WARD' column has expected values", {
  valid_wards <- c("Ward1", "Ward2", "Ward3", "Ward4", "Ward5", "Ward6", "Ward7", "Ward8", 
                   "Ward9", "Ward10", "Ward11", "Ward12", "Ward13", "Ward14", "Ward15", 
                   "Ward16", "Ward17", "Ward18", "Ward19", "Ward20", "Ward21", "Ward22", 
                   "Ward23", "Ward24", "Ward25")
  expect_true(all(data$WARD %in% valid_wards))
})

# Test that ASSET TYPE contains expected categories
test_that("'ASSET TYPE' column has expected categories", {
  valid_asset_types <- c("WR1", "WR2", "WR3", "WR4", "WR5")
  expect_true(all(data$'ASSET TYPE' %in% valid_asset_types))
})

# Test that STATUS contains expected statuses
test_that("'STATUS' column has expected statuses", {
  valid_statuses <- c("Existing", "Temporarily Removed", "Permanently Removed")
  expect_true(all(data$STATUS %in% valid_statuses))
})

# Test that DAYS SERVICED has values within a reasonable range (e.g., 1 to 7)
test_that("'DAYS SERVICED' values are within 1 to 7", {
  expect_true(all(data$'DAYS SERVICED' >= 1 & data$'DAYS SERVICED' <= 7))
})