#### Preamble ####
# Purpose: Validate the integrity and structure of the cleaned ward datasets
# Author: Jiwon Choi
# Date: 27 November 2024
# Contact: jwon.choi@mail.utoronto.ca
# License: MIT

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
  expected_columns <- c("Variable", "Minors", "Adult", "Middle_Age_Adult", "Senior_Adult")
  expect_true(all(expected_columns %in% names(data_age)))
})

test_that("age dataset contains valid population values", {
  numeric_columns <- data_age[, -1]  # Exclude 'Variable' column
  expect_true(all(numeric_columns >= 0, na.rm = TRUE))
})

#### Test data_dwelling ####
test_that("dwelling dataset is not empty", {
  expect_gt(nrow(data_dwelling), 0)
})

test_that("dwelling dataset contains expected columns", {
  expected_columns <- c("Variable", "Low_Density_Housing", "Medium_Density_Housing", 
                        "High_Density_Housing", "Other_Types")
  expect_true(all(expected_columns %in% names(data_dwelling)))
})

test_that("dwelling dataset contains valid housing counts", {
  numeric_columns <- data_dwelling[, -1]  # Exclude 'Variable' column
  expect_true(all(numeric_columns >= 0, na.rm = TRUE))
})

#### Test data_household ####
test_that("household dataset is not empty", {
  expect_gt(nrow(data_household), 0)
})

test_that("household dataset contains expected columns", {
  expected_columns <- c("Variable", "Small_Households", "Medium_Households", "Large_Households")
  expect_true(all(expected_columns %in% names(data_household)))
})

test_that("household dataset contains valid household counts", {
  numeric_columns <- data_household[, -1]  # Exclude 'Variable' column
  expect_true(all(numeric_columns >= 0, na.rm = TRUE))
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
  wards_age <- data_age$Variable
  wards_dwelling <- data_dwelling$Variable
  wards_household <- data_household$Variable
  expect_setequal(wards_age, wards_dwelling)
  expect_setequal(wards_dwelling, wards_household)
})
