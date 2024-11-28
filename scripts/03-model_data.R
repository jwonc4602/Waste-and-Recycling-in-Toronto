#### Preamble ####
# Purpose: Build and apply a Bayesian logistic regression model to predict the status of litter bins
# Author: Jiwon Choi
# Date: 27 November 2024
# Contact: jwon.choi@mail.utoronto.ca
# License: MIT
# Pre-requisites: 

#### Workspace setup ####
# Load necessary libraries
library(dplyr)
library(rstanarm)
library(ggplot2)

# Read and preprocess datasets
age_data <- read.csv("data/02-analysis_data/ward_data_age.csv")
dwelling_type_data <- read.csv("data/02-analysis_data/ward_data_dwelling_type.csv")
household_size_data <- read.csv("data/02-analysis_data/ward_data_household_size.csv")
litter_data <- read.csv("data/02-analysis_data/cleaned_data_litter.csv")

# Standardize column names for merging
colnames(age_data)[1] <- "Ward"
colnames(dwelling_type_data)[1] <- "Ward"
colnames(household_size_data)[1] <- "Ward"
colnames(litter_data)[1] <- "Ward"

# Merge datasets
data <- litter_data %>%
  left_join(age_data, by = "Ward") %>%
  left_join(dwelling_type_data, by = "Ward") %>%
  left_join(household_size_data, by = "Ward")

# Preprocessing
data$STATUS <- ifelse(data$STATUS == "Existing", 1, 0)
data <- data %>% filter(!is.na(STATUS))  # Remove rows with missing STATUS
data$ASSET.TYPE <- as.factor(data$ASSET.TYPE)
data <- data %>% mutate(across(where(is.numeric) & !all_of("STATUS"), scale))

# Save or view the combined dataset
write.csv(data, "data/02-analysis_data/combined_data.csv")

# Fit Bayesian logistic regression model
model <- stan_glm(
  STATUS ~ ASSET.TYPE + DAYS.SERVICED + Low_Density_Housing +
    Medium_Density_Housing + High_Density_Housing,
  data = data,
  family = binomial(),
  prior = normal(0, 5),
  prior_intercept = normal(0, 5),
  seed = 1234,
  iter = 4000,
  warmup = 2000,
  adapt_delta = 0.95,
  chains = 4
)

# Save the model
saveRDS(model, "models/status_model.rds")

# Ensure the variable types match between the data and the model
data$DAYS.SERVICED <- as.numeric(data$DAYS.SERVICED)
data$Low_Density_Housing <- as.numeric(data$Low_Density_Housing)
data$Medium_Density_Housing <- as.numeric(data$Medium_Density_Housing)
data$High_Density_Housing <- as.numeric(data$High_Density_Housing)

# Predict probabilities and classes
data$Predicted_Probability <- predict(model, newdata = data, type = "response")

# Save the updated dataset with predictions
write.csv(data, "data/02-analysis_data/combined_data_with_predictions.csv", row.names = FALSE)

