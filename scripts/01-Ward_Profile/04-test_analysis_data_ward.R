#### Preamble ####
# Purpose: Tests the integrity and validity of the ward datasets
# Author: Jiwon Choi
# Date: 26 November 2024
# Contact: jwon.choi@mail.utoronto.ca
# License: MIT
# Pre-requisites: Data pre-processing scripts to clean the data

#### Workspace setup ####
library(tidyverse)
library(testthat)

# Load the datasets
data_age <- read_csv("../../data/02-analysis_data/ward_data_age.csv")
data_dwelling <- read_csv("../../data/02-analysis_data/ward_data_dwelling_type.csv")
data_household <- read_csv("../../data/02-analysis_data/ward_data_household_size.csv")

#### Test data_age ####
test_that("age dataset is not empty", {
  expect_gt(nrow(data_age), 0)
})

test_that("age dataset contains expected columns", {
  expected_columns <- c("City of Toronto Profiles", "Toronto", paste0("Ward", 1:25))
  expect_true(all(expected_columns %in% names(data_age)))
})

test_that("age dataset contains valid population values", {
  expect_true(all(data_age[2:nrow(data_age), -1] >= 0, na.rm = TRUE)) # Skip the profile names
})

#### Test data_dwelling ####
test_that("dwelling dataset is not empty", {
  expect_gt(nrow(data_dwelling), 0)
})

test_that("dwelling dataset contains expected columns", {
  expected_columns <- c("City of Toronto Profiles", "Toronto", paste0("Ward", 1:25))
  expect_true(all(expected_columns %in% names(data_dwelling)))
})

test_that("dwelling dataset contains valid counts", {
  expect_true(all(data_dwelling[2:nrow(data_dwelling), -1] >= 0, na.rm = TRUE)) # Skip the profile names
})

#### Test data_household ####
test_that("household dataset is not empty", {
  expect_gt(nrow(data_household), 0)
})

test_that("household dataset contains expected columns", {
  expected_columns <- c("City of Toronto Profiles", "Toronto", paste0("Ward", 1:25))
  expect_true(all(expected_columns %in% names(data_household)))
})

test_that("household dataset contains valid household counts", {
  expect_true(all(data_household[2:nrow(data_household), -1] >= 0, na.rm = TRUE)) # Skip the profile names
})

#### Additional tests for dataset consistency ####
# Ensure no NA values in the numeric columns across datasets
test_that("no missing values in numeric columns", {
  expect_true(all(!is.na(data_age[,-1])))
  expect_true(all(!is.na(data_dwelling[,-1])))
  expect_true(all(!is.na(data_household[,-1])))
})

# Ensure datasets cover the same wards (consistency check)
test_that("datasets cover the same wards", {
  wards_age <- names(data_age)[-c(1, 2)]
  wards_dwelling <- names(data_dwelling)[-c(1, 2)]
  wards_household <- names(data_household)[-c(1, 2)]
  expect_setequal(wards_age, wards_dwelling)
  expect_setequal(wards_dwelling, wards_household)
})
