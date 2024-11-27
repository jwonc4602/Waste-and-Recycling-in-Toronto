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

# Define the age groups
age_groups <- list(
  "Minors" = c("0 to 4 years", "5 to 9 years", "10 to 14 years", "15 to 19 years"),
  "Adult" = c("20 to 24 years", "25 to 29 years", "30 to 34 years", "35 to 39 years"),
  "Middle_Age_Adult" = c("40 to 44 years", "45 to 49 years", "50 to 54 years", "55 to 59 years"),
  "Senior_Adult" = c("60 to 64 years", "65 to 69 years", "70 to 74 years", "75 to 79 years",
                     "80 to 84 years", "85 to 89 years", "90 years and over")
)

# Assuming your data frame is `ward_data_age`
# Transpose the dataset to make calculations easier
ward_data_age_long <- as.data.frame(t(ward_data_age[-1]))
colnames(ward_data_age_long) <- ward_data_age[[1]]

# Calculate age group sums
age_group_sums <- sapply(age_groups, function(group) {
  rowSums(ward_data_age_long[, group, drop = FALSE], na.rm = TRUE)
})

# Convert back to a data frame with proper labels
age_group_sums_df <- data.frame(Total = rownames(age_group_sums), age_group_sums, row.names = NULL)

# Rename the "Total" column to "Variable"
colnames(age_group_sums_df)[colnames(age_group_sums_df) == "Total"] <- "Variable"


### Subset 2: Rows from 22nd to 30th ###
ward_data_dwelling_type <- ward_data[22:30, ]

# Create an empty dataframe to store the aggregated results
aggregated_data <- data.frame(
  `City of Toronto Profiles` = c(
    "Low_Density_Housing",
    "Medium_Density_Housing",
    "High_Density_Housing",
    "Other_Types"
  ),
  stringsAsFactors = FALSE
)

# Aggregate values for each category
aggregated_data$Toronto <- c(
  sum(ward_data_dwelling_type[ward_data_dwelling_type$`City of Toronto Profiles` %in% 
                                c("Single-detached house", "Semi-detached house"), "Toronto"]),
  sum(ward_data_dwelling_type[ward_data_dwelling_type$`City of Toronto Profiles` %in% 
                                c("Row house", "Apartment or flat in a duplex"), "Toronto"]),
  sum(ward_data_dwelling_type[ward_data_dwelling_type$`City of Toronto Profiles` %in% 
                                c("Apartment in a building that has fewer than five storeys", 
                                  "Apartment in a building that has five or more storeys"), "Toronto"]),
  sum(ward_data_dwelling_type[ward_data_dwelling_type$`City of Toronto Profiles` %in% 
                                c("Other single-attached house", "Movable dwelling"), "Toronto"])
)

# Aggregate values for each ward
for (ward in colnames(ward_data_dwelling_type)[-1]) { # Skip the first column (categories)
  aggregated_data[[ward]] <- c(
    sum(ward_data_dwelling_type[ward_data_dwelling_type$`City of Toronto Profiles` %in% 
                                  c("Single-detached house", "Semi-detached house"), ward]),
    sum(ward_data_dwelling_type[ward_data_dwelling_type$`City of Toronto Profiles` %in% 
                                  c("Row house", "Apartment or flat in a duplex"), ward]),
    sum(ward_data_dwelling_type[ward_data_dwelling_type$`City of Toronto Profiles` %in% 
                                  c("Apartment in a building that has fewer than five storeys", 
                                    "Apartment in a building that has five or more storeys"), ward]),
    sum(ward_data_dwelling_type[ward_data_dwelling_type$`City of Toronto Profiles` %in% 
                                  c("Other single-attached house", "Movable dwelling"), ward])
  )
}

# Replace the original dataset with the aggregated one
ward_data_dwelling_type <- aggregated_data


### Subset 3: Rows from 88th to 93r d###
ward_data_household_size <- ward_data[88:93, ]

# Create an empty dataframe for aggregated results
aggregated_household_data <- data.frame(
  `City of Toronto Profiles` = c(
    "Small_Households",
    "Medium_Households",
    "Large_Households"
  ),
  stringsAsFactors = FALSE
)

# Aggregate values for each category
aggregated_household_data$Toronto <- c(
  sum(ward_data_household_size[ward_data_household_size$`City of Toronto Profiles` %in% 
                                 c("1 person", "2 persons"), "Toronto"]),
  sum(ward_data_household_size[ward_data_household_size$`City of Toronto Profiles` %in% 
                                 c("3 persons", "4 persons"), "Toronto"]),
  sum(ward_data_household_size[ward_data_household_size$`City of Toronto Profiles` == 
                                 "5 or more persons", "Toronto"])
)

# Aggregate values for each ward
for (ward in colnames(ward_data_household_size)[-1]) { # Skip the first column (categories)
  aggregated_household_data[[ward]] <- c(
    sum(ward_data_household_size[ward_data_household_size$`City of Toronto Profiles` %in% 
                                   c("1 person", "2 persons"), ward]),
    sum(ward_data_household_size[ward_data_household_size$`City of Toronto Profiles` %in% 
                                   c("3 persons", "4 persons"), ward]),
    sum(ward_data_household_size[ward_data_household_size$`City of Toronto Profiles` == 
                                   "5 or more persons", ward])
  )
}

# Replace the original dataset with the aggregated one
ward_data_household_size <- aggregated_household_data

#### Transpose the subsets while retaining Ward ####
# Function to transpose data and keep the Ward column
transpose_with_ward <- function(data) {
  # Assume the first column is "Ward" or the identifier column
  ward_column <- data[[1]]  # Extract the Ward column
  data_transposed <- as.data.frame(t(data[-1]))  # Transpose the rest of the data, excluding Ward
  colnames(data_transposed) <- ward_column  # Assign Ward values as column names
  data_transposed <- tibble::rownames_to_column(data_transposed, var = "Variable")  # Add row names as a column
  return(data_transposed)
}

# Apply the function to each subset
ward_data_dwelling_type_transposed <- transpose_with_ward(ward_data_dwelling_type)
ward_data_household_size_transposed <- transpose_with_ward(ward_data_household_size)

#### Remove the row labeled "Toronto" ####
remove_toronto_row <- function(data) {
  # Filter out the "Toronto" row (assuming it's labeled in the first column)
  data <- data %>% filter(Variable != "Toronto")
  return(data)
}

age_group_sums_df <- remove_toronto_row(age_group_sums_df)
ward_data_dwelling_type_transposed <- remove_toronto_row(ward_data_dwelling_type_transposed)
ward_data_household_size_transposed <- remove_toronto_row(ward_data_household_size_transposed)

#### Save the datasets ####
write_csv(age_group_sums_df, "data/02-analysis_data/ward_data_age.csv")
write_csv(ward_data_dwelling_type_transposed, "data/02-analysis_data/ward_data_dwelling_type.csv")
write_csv(ward_data_household_size_transposed, "data/02-analysis_data/ward_data_household_size.csv")

