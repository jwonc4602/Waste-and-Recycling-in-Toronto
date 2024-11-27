#### Preamble ####
# Purpose: Downloads, processes, renames variables, removes NA rows and columns, and saves the 2023 Ward Profiles Census Data.
# Author: Jiwon Choi
# Date: 26 November 2024
# Contact: jwon.choi@mail.utoronto.ca
# License: MIT
# Pre-requisites: Ensure necessary Python libraries are installed.

import os
import pandas as pd
import requests

# Define constants
BASE_URL = "https://ckan0.cf.opendata.inter.prod-toronto.ca"
PACKAGE_ID = "ward-profiles-25-ward-model"
RESOURCE_NAME = "2023-wardprofiles-2011-2021-censusdata"
EXCEL_FILE_NAME = "2023_WardProfiles_2011_2021_CensusData.xlsx"
FINAL_CSV_FILE_NAME = "data/01-raw_data/raw_data_ward_profile.csv"

# API endpoint for retrieving package metadata
PACKAGE_URL = f"{BASE_URL}/api/3/action/package_show"
PACKAGE_PARAMS = {"id": PACKAGE_ID}

# Ensure directories exist
os.makedirs(os.path.dirname(FINAL_CSV_FILE_NAME), exist_ok=True)

# Fetch package metadata
print("Fetching package metadata...")
response = requests.get(PACKAGE_URL, params=PACKAGE_PARAMS)
if response.status_code == 200:
    package = response.json()
    if package.get("success"):
        # Search for the desired resource
        for resource in package["result"]["resources"]:
            if RESOURCE_NAME in resource["name"].lower():
                file_url = resource["url"]
                print(f"Found the resource. Starting download from: {file_url}")
                
                # Download the Excel file
                data_response = requests.get(file_url)
                if data_response.status_code == 200:
                    with open(EXCEL_FILE_NAME, "wb") as f:
                        f.write(data_response.content)
                    print(f"File downloaded and saved as: {EXCEL_FILE_NAME}")
                    
                    # Load the Excel file into a pandas DataFrame
                    print("Loading and processing the dataset...")
                    data = pd.read_excel(EXCEL_FILE_NAME)
                    
                    # Rename columns
                    print("Renaming columns...")
                    new_column_names = {
                        "Unnamed: 1": "Toronto",
                        **{f"Unnamed: {i}": f"Ward{i - 1}" for i in range(2, 27)}
                    }
                    data.rename(columns=new_column_names, inplace=True)
                    
                    # Remove rows and columns with NA values
                    print("Removing rows and columns with missing values...")
                    data.dropna(axis=0, how="any", inplace=True)  # Drop rows with NA
                    data.dropna(axis=1, how="any", inplace=True)  # Drop columns with NA
                    
                    # Save the final cleaned data
                    data.to_csv(FINAL_CSV_FILE_NAME, index=False)
                    print(f"Final cleaned dataset has been saved at: {FINAL_CSV_FILE_NAME}")
                else:
                    print(f"Failed to download the resource. HTTP Status Code: {data_response.status_code}")
                break
        else:
            print(f"Resource '{RESOURCE_NAME}' not found in the package resources.")
    else:
        print("Failed to retrieve package metadata. The response was not successful.")
else:
    print(f"Failed to connect to the API. HTTP Status Code: {response.status_code}")
