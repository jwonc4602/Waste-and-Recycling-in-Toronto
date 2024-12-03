# Waste and Recycling in Toronto

## Overview

This repository analyzes waste management in Toronto from 2021 to 2024, focusing on efficiency and equity. It examines how demographics, housing, and waste collection patterns affect servicing needs and highlights ways to optimize resource allocation. The findings provide practical insights and a framework for fair and sustainable urban waste systems.

## File Structure

The repo is structured as:

-   `data/00-simulated_data` contains the simulated datasets.
-   `data/01-raw_data` contains the raw data as obtained from [Open Data Toronto](https://open.toronto.ca/).
    - [Litter Bin Data](https://open.toronto.ca/dataset/litter-bin-collection-frequency/)
    - [Ward Profile Data](https://open.toronto.ca/dataset/ward-profiles-25-ward-model/)
-   `data/02-analysis_data` contains the cleaned dataset that was constructed.
-   `model` contains fitted model. 
-   `other` contains model card, and sketches.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate, download and clean data and modelling.
    -   `scripts/00-Litter_Bin` contains the R scripts used to simulate, download and clean data for litter bin data.
    -   `scripts/01-Ward_Profile` contains the R scripts used to simulate, download and clean data for ward profile data.

## Statement on LLM usage

None of the components of this work involved the use of LLMs.
