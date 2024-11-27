#### Preamble ####
# Purpose: Build a basic regression model for forecasting Asset Type.
# Author: [Your Name]
# Date: [Today's Date]
# Contact: [Your Email Address]
# License: MIT
# Pre-requisites: Cleaned data file should be located in 'data/02-analysis_data/' directory.
# Any other information needed? Ensure tidyverse and rstanarm libraries are installed.

#### Workspace setup ####
library(tidyverse)
library(rstanarm)

#### Read data ####
analysis_data <- read_csv("data/02-analysis_data/cleaned_data.csv")

#### Preprocess data ####
# Ensure ASSET TYPE is numeric for regression
analysis_data <- analysis_data %>%
  mutate(`ASSET TYPE` = as.numeric(factor(`ASSET TYPE`)))

#### Model data ####
# Basic regression: Predicting ASSET TYPE (numeric) based on WARD, BIA, and DAYS SERVICED
asset_type_model <- stan_glm(
  formula = `ASSET TYPE` ~ WARD + `DAYS SERVICED`,
  data = analysis_data,
  family = gaussian(),
  prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
  prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
  prior_aux = exponential(rate = 1, autoscale = TRUE),
  seed = 853
)

#### Save model ####
saveRDS(
  asset_type_model,
  file = "models/asset_type_model_gaussian.rds"
)

#### Model Summary ####
summary(asset_type_model)
