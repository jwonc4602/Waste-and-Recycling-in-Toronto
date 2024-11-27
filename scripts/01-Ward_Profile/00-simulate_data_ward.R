#### Preamble ####
# Purpose: Simulates datasets for age, dwelling type, and household size distributions
# Author: Jiwon Choi
# Date: 26 November 2024
# Contact: jwon.choi@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` package must be installed

#### Workspace setup ####
library(tidyverse)
set.seed(1234)  # Ensure reproducibility

#### Simulate Age Data ####
# Define age groups and wards
age_groups <- c(
  "Total - Age", "0 to 4 years", "5 to 9 years", "10 to 14 years", 
  "15 to 19 years", "20 to 24 years", "25 to 29 years", "30 to 34 years", 
  "35 to 39 years", "40 to 44 years", "45 to 49 years", "50 to 54 years", 
  "55 to 59 years", "60 to 64 years", "65 to 69 years", "70 to 74 years", 
  "75 to 79 years", "80 to 84 years", "85 years and over"
)
wards <- paste0("Ward", 1:25)

# Simulate values for each ward
simulated_age_data <- tibble(
  `City of Toronto Profiles` = age_groups,
  Toronto = round(runif(length(age_groups), 500000, 3000000), 0)
) %>%
  bind_cols(map_dfc(wards, ~ tibble(!!.x := round(runif(length(age_groups), 5000, 150000), 0))))

#### Simulate Dwelling Type Data ####
# Define dwelling types
dwelling_types <- c(
  "Total - Occupied private dwellings by structural type of dwelling - 25% sample data", 
  "Single-detached house", "Semi-detached house", "Row house", 
  "Apartment or flat in a duplex", "Apartment in a building with five or more storeys", 
  "Other single-attached house", "Movable dwelling"
)

# Simulate values for each ward
simulated_dwelling_data <- tibble(
  `City of Toronto Profiles` = dwelling_types,
  Toronto = round(runif(length(dwelling_types), 50000, 1500000), 0)
) %>%
  bind_cols(map_dfc(wards, ~ tibble(!!.x := round(runif(length(dwelling_types), 500, 80000), 0))))

#### Simulate Household Size Data ####
# Define household sizes
household_sizes <- c(
  "Total - Private households by household size - 25% sample data", 
  "1 person", "2 persons", "3 persons", "4 persons", "5 or more persons"
)

# Simulate values for each ward
simulated_household_data <- tibble(
  `City of Toronto Profiles` = household_sizes,
  Toronto = round(runif(length(household_sizes), 50000, 1500000), 0)
) %>%
  bind_cols(map_dfc(wards, ~ tibble(!!.x := round(runif(length(household_sizes), 500, 80000), 0))))

#### Save Data ####
# Ensure the directory exists
dir.create("data/00-simulated_data", recursive = TRUE, showWarnings = FALSE)

# Save the datasets to CSV files
write_csv(simulated_age_data, "data/00-simulated_data/simulated_age_data.csv")
write_csv(simulated_dwelling_data, "data/00-simulated_data/simulated_dwelling_data.csv")
write_csv(simulated_household_data, "data/00-simulated_data/simulated_household_data.csv")
