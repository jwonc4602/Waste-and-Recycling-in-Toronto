#### Preamble ####
# Purpose: Simulates litter bin dataset
# Author: Jiwon Choi
# Date: 26 November 2024
# Contact: jwon.choi@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` package must be installed

#### Workspace setup ####
library(tidyverse)
set.seed(1234)  # Ensure reproducibility

#### Simulate data ####
# Define possible values for each column
wards <- unique(c(1:10))  # Simulate wards from 1 to 10
days_serviced <- c(5, 6, 7)  # Possible service days
asset_types <- c("WR1", "WR2", "WR3", "WR4")  # Asset types
statuses <- c("Existing", "Temporarily Removed", "Removed")  # Status options

# Simulate a dataset with 200 rows
simulated_data <- tibble(
  WARD = sample(wards, size = 200, replace = TRUE),
  `DAYS SERVICED` = sample(days_serviced, size = 200, replace = TRUE),
  `ASSET TYPE` = sample(asset_types, size = 200, replace = TRUE),
  STATUS = sample(statuses, size = 200, replace = TRUE)
)

#### Save data ####
# Save the simulated dataset
write_csv(simulated_data, "data/00-simulated_data/simulated_data.csv")

