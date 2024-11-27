#### Preamble ####
# Purpose: Cleans the raw litter bin data for analysis of equity and prediction models.
# Author: Jiwon Choi
# Date: 26 November 2024
# Contact: jwon.choi@mail.utoronto.ca
# License: MIT
# Pre-requisites: 02-download_data.R
# Any other information needed? Ensure the tidyverse and readr libraries are installed.

#### Workspace setup ####
library(tidyverse)
library(readr)

# Load the raw dataset
litter_bin_data <- read_csv("data/01-raw_data/raw_data_litter_bin.csv")

cleaned_data <- litter_bin_data %>%
  select(
    WARD,            # Ward information
    `DAYS SERVICED`, # Number of days the bin is serviced
    `ASSET TYPE`,    # Type of litter bin
    STATUS           # Status of the bin (active/inactive)
  ) %>%
  drop_na()          # Remove rows with any missing values

# Convert WARD to Ward1, Ward2, ..., Ward25 format and ensure the order
cleaned_data <- cleaned_data %>%
  mutate(WARD = paste0("Ward", as.numeric(WARD))) %>%
  mutate(WARD = factor(WARD, levels = paste0("Ward", 1:25))) # Explicitly order WARD

# Reshape the data to wide format
wide_data <- cleaned_data %>%
  mutate(across(
    .cols = c(`DAYS SERVICED`, `ASSET TYPE`, STATUS),
    .fns = as.character # Convert all columns to character to ensure compatibility
  )) %>%
  pivot_longer(
    cols = c(`DAYS SERVICED`, `ASSET TYPE`, STATUS),
    names_to = "Variable",
    values_to = "Value"
  ) %>%
  mutate(Value_Label = case_when(
    Variable == "DAYS SERVICED" ~ paste0("Days serviced - ", Value),
    Variable == "ASSET TYPE" ~ paste0("Asset type - ", Value),
    Variable == "STATUS" ~ paste0("Status - ", Value)
  )) %>%
  # Explicitly order Value_Label
  mutate(Value_Label = factor(
    Value_Label,
    levels = c(
      # List days serviced in ascending order
      paste0("Days serviced - ", sort(as.numeric(unique(litter_bin_data$`DAYS SERVICED`)))),
      # List asset types alphabetically
      paste0("Asset type - ", sort(unique(litter_bin_data$`ASSET TYPE`))),
      # List statuses alphabetically
      paste0("Status - ", sort(unique(litter_bin_data$STATUS)))
    )
  )) %>%
  group_by(WARD, Value_Label) %>%
  summarise(Count = n(), .groups = "drop") %>%
  pivot_wider(
    names_from = WARD,
    values_from = Count,
    values_fill = 0
  )

# Save the transformed dataset
write_csv(wide_data, "data/02-analysis_data/cleaned_data_litter.csv")

