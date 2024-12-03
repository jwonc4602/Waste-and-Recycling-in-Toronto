#### Preamble ####
# Purpose: Tests the structure and validity of the simulated datasets
# Author: Jiwon Choi
# Date: 26 November 2024
# Contact: jwon.choi@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - The `tidyverse` package must be installed and loaded
# - 00-simulate_data_ward.R must have been run
# - The `testthat` package must be installed and loaded

#### Workspace setup ####
library(tidyverse)
library(testthat)

# Load the datasets
age_data <- read_csv("../../data/00-simulated_data/simulated_age_data.csv")
dwelling_data <- read_csv("../../data/00-simulated_data/simulated_dwelling_data.csv")
household_data <- read_csv("../../data/00-simulated_data/simulated_household_data.csv")

#### Test Age Dataset ####

# Test if the age dataset was successfully loaded
test_that("Age Dataset: Successfully loaded", {
  expect_true(exists("age_data"))
})

# Check if the age dataset has the correct number of rows
test_that("Age Dataset: Correct number of rows", {
  expected_age_rows <- 19  # 19 age groups
  expect_equal(nrow(age_data), expected_age_rows)
})

# Check if the age dataset has the correct number of columns
test_that("Age Dataset: Correct number of columns", {
  expected_wards <- 25  # Wards 1 to 25
  expect_equal(ncol(age_data), expected_wards + 2)  # +2 for 'City of Toronto Profiles' and 'Toronto'
})

#### Test Dwelling Type Dataset ####

# Test if the dwelling type dataset was successfully loaded
test_that("Dwelling Dataset: Successfully loaded", {
  expect_true(exists("dwelling_data"))
})

# Check if the dwelling type dataset has the correct number of rows
test_that("Dwelling Dataset: Correct number of rows", {
  expected_dwelling_rows <- 8  # 8 dwelling types
  expect_equal(nrow(dwelling_data), expected_dwelling_rows)
})

# Check if the dwelling type dataset has the correct number of columns
test_that("Dwelling Dataset: Correct number of columns", {
  expected_wards <- 25  # Wards 1 to 25
  expect_equal(ncol(dwelling_data), expected_wards + 2)  # +2 for 'City of Toronto Profiles' and 'Toronto'
})

#### Test Household Size Dataset ####

# Test if the household size dataset was successfully loaded
test_that("Household Dataset: Successfully loaded", {
  expect_true(exists("household_data"))
})

# Check if the household size dataset has the correct number of rows
test_that("Household Dataset: Correct number of rows", {
  expected_household_rows <- 6  # 6 household sizes
  expect_equal(nrow(household_data), expected_household_rows)
})

# Check if the household size dataset has the correct number of columns
test_that("Household Dataset: Correct number of columns", {
  expected_wards <- 25  # Wards 1 to 25
  expect_equal(ncol(household_data), expected_wards + 2)  # +2 for 'City of Toronto Profiles' and 'Toronto'
})

#### General Validity Tests ####

# Check if all datasets contain no missing values
test_that("All datasets contain no missing values", {
  datasets <- list(age_data = age_data, dwelling_data = dwelling_data, household_data = household_data)
  
  for (name in names(datasets)) {
    data <- datasets[[name]]
    expect_true(all(!is.na(data)), info = paste(name, "dataset contains missing values."))
  }
})

#### Completion Message ####
# Message to indicate that all tests have been run
message("All tests completed successfully.")
