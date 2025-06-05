# Remote Work and Population Change in U.S. Metro Areas

This project investigates how the rise of remote work during the COVID-19 pandemic affected population trends in U.S. metropolitan areas. It uses population change data and estimates of remote work feasibility across cities to test whether areas with more work-from-home jobs experienced larger population declines or slower growth between 2020 and 2022.

## Research Question

Do metropolitan areas with a higher share of remote work-feasible jobs experience greater population loss or slower growth compared to those with fewer such jobs?

## Key Findings

- Cities with more remote-friendly jobs saw significantly lower population growth during the pandemic years.
- A 1 percentage point increase in WFH-feasible jobs is associated with up to 0.93 percentage points less population growth (2020–2021), after controlling for city size.
- Larger cities may mask the full effect due to their economic resilience and attractiveness.

## Files

- `remote-work-population-change.pdf`: Final project report with code, analysis, maps, and visualizations.
- `data/`: Contains datasets used in the analysis (CSV, Excel, RData)

## Methodology

- Linear regression models (with and without controls for metro size)
- Visualization: line plots, histograms, choropleth maps
- Data from:
  - U.S. Census Bureau
  - Dingel & Neiman (2020) WFH Feasibility Study
  - Shapefiles for metro area mapping

## Tools Used

- R (RStudio)
- `dplyr`, `ggplot2`, `tidyr`, `sf`

## Authors

Rachel Kim, Hyunji Park  
Sciences Po – Econometrics with R (Spring 2025)
