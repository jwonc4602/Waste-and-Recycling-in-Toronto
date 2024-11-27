#### Preamble ####
# Purpose: Downloads, processes, renames variables, removes NA rows and columns, and saves the 2023 Ward Profiles Census Data.
# Author: Jiwon Choi
# Date: 26 November 2024
# Contact: jwon.choi@mail.utoronto.ca
# License: MIT
# Pre-requisites: Ensure necessary R libraries are installed.

#### Workspace setup ####
library(tidyverse)
library(readr)

# Load the raw dataset
ward_data <- read_csv("data/01-raw_data/raw_data_ward_profile.csv")

#### Data Cleaning and Subsetting ####
# Subset 1: Rows from 1st to 21st
ward_data_age <- ward_data[1:21, ]

# Subset 2: Rows from 22nd to 30th
ward_data_dwelling_type <- ward_data[22:30, ]

# Subset 3: Rows from 88th to 93rd
ward_data_household_size <- ward_data[88:93, ]

#### Save the datasets ####
write_csv(ward_data_age, "data/02-analysis_data/ward_data_age.csv")
write_csv(ward_data_dwelling_type, "data/02-analysis_data/ward_data_dwelling_type.csv")
write_csv(ward_data_household_size, "data/02-analysis_data/ward_data_household_size.csv")
