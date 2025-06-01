# Model Evaluation Using County-Level Election Data
This R project analyzes the relationships between demographic, economic, and social metrics and 2020 U.S. presidential voting outcomes at the county level. It focuses on model performance evaluation using different regression techniques and diagnostic metrics.

## Project Objectives
- Explore how county-level characteristics predict the share of votes for Trump in the 2020 election.
- Compare predictive performance using:
  - Full variable sets vs. selective subsets (e.g., economic only, social only)
  - Different regression formulations

## Methods and Metrics
- Data joined from ACS (American Community Survey) and voting outcomes
- Linear regression models trained on subsets of variables:
  - Social indicators (e.g., education, race)
  - Economic indicators (e.g., income, employment)
  - Combined datasets
- Model comparison using:
  - Predicted vs. actual Trump vote shares
  - Performance visualizations and summaries

## Files
- `midterm_metrics.Rmd`: Main analysis notebook
- `midterm_metrics.html`: Rendered version of the notebook with outputs
- `data/`: Folder containing required datasets:
  - `countytypes_2000-2020.csv`
  - `state_votes.xlsx`
  - `elections_2020_reg_trump.RData`
  - `county_shfl.RData`
  - `acs_dem/`, `acs_eco/`, `acs_soc/`

## Author
Rachel Kim  
Sciences Po – Spring 2025
