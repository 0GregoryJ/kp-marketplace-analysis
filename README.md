<p align="center">
  <img src="docs/assets/banner.png" alt="Understanding Marketplace Performance Across Geographies: Socioeconomic Trends and Future Considerations — SFSU Capstone Project prepared for Kaiser Permanente" width="100%">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Python-3776AB?style=flat-square&logo=python&logoColor=white" alt="Python">
  <img src="https://img.shields.io/badge/SQL-4479A1?style=flat-square&logo=sqlite&logoColor=white" alt="SQL">
  <img src="https://img.shields.io/badge/dbt-FF694B?style=flat-square&logo=dbt&logoColor=white" alt="dbt">
  <img src="https://img.shields.io/badge/DuckDB-FFF000?style=flat-square&logo=duckdb&logoColor=black" alt="DuckDB">
  <img src="https://img.shields.io/badge/scikit--learn-F7931E?style=flat-square&logo=scikitlearn&logoColor=white" alt="scikit-learn">
  <img src="https://img.shields.io/badge/Tableau-E97627?style=flat-square&logo=data:image/svg%2Bxml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNCAyNCI+PHJlY3QgeD0iMTAiIHk9IjEuNSIgd2lkdGg9IjQiIGhlaWdodD0iNiIgZmlsbD0iI2ZmZiIvPjxyZWN0IHg9IjEwIiB5PSIxNi41IiB3aWR0aD0iNCIgaGVpZ2h0PSI2IiBmaWxsPSIjZmZmIi8+PHJlY3QgeD0iMS41IiB5PSIxMCIgd2lkdGg9IjYiIGhlaWdodD0iNCIgZmlsbD0iI2ZmZiIvPjxyZWN0IHg9IjE2LjUiIHk9IjEwIiB3aWR0aD0iNiIgaGVpZ2h0PSI0IiBmaWxsPSIjZmZmIi8+PHJlY3QgeD0iOSIgeT0iOSIgd2lkdGg9IjYiIGhlaWdodD0iNiIgZmlsbD0iI2ZmZiIvPjwvc3ZnPg==" alt="Tableau">
  <img src="https://img.shields.io/badge/Presentation-FBBC04?style=flat-square&logo=googleslides&logoColor=white" alt="Presentation">
  <img src="https://img.shields.io/badge/Exec%20Summary-1A1428?style=flat-square&logo=markdown&logoColor=white" alt="Exec Summary">
  <img src="https://img.shields.io/badge/CMS-Public%20Use%20Files-0B3D91?style=flat-square" alt="CMS Public Use Files">
</p>

## Overview

## Research Questions
- What socioeconomic and market characteristics across geographies are associated with Marketplace performance?
- Which areas currently exhibit these characteristics and outcomes?
- How are these socioeconomic and market characteristics expected to change over the next five to ten years?
- What considerations for future market analysis emerge from these findings?

## Project Scope

## Data Sources
... a table or something detailing the data
- CMS
    - California SBE QHP PUFs (https://www.cms.gov/marketplace/resources/data/state-based-public-use-files)
        - Service area
        - Plan attributes
        - Rates
- Covered California Active member profiles (https://hbex.coveredca.com/data-research/active-member-profiles/)
- Census
    - B19013 (median household income) (https://data.census.gov/table/ACSDT5Y2024.B19013)
    - S1701 (% above/below poverty rate) (https://data.census.gov/table?q=S1701:+POVERTY+STATUS+IN+THE+PAST+12+MONTHS)
    - B01003 (population) (https://data.census.gov/table?q=B01003:+TOTAL+POPULATION)
    - S2701 (coverage status of population) (https://data.census.gov/table?q=S2701:+HEALTH+INSURANCE+COVERAGE+STATUS)

- BLS QCEW (https://www.bls.gov/cew/downloadable-data-files.htm)
- BLS LAUS (https://www.bls.gov/lau/tables.htm)
## Architecture

## Data Model

## Methodology

## Repository Structure
```text
kaiser-marketplace-analysis/
│
├── README.md
├── .gitignore
├── requirements.txt
│
├── data/
│   ├── README.md
│   ├── raw/                # gitignored
│   ├── processed/          # gitignored
│   └── sample/             # optional tiny sample
│
├── dbt/
│   ├── dbt_project.yml
│   ├── models/
│   │   ├── staging/
│   │   │   ├── covered_ca/
│   │   │   ├── census/
│   │   │   ├── bls/
│   │   │   └── cms/
│   │   │
│   │   ├── intermediate/
│   │   │
│   │   └── marts/
│   │       ├── mart_cty_yr_socioeconomic.sql
│   │       ├── mart_cty_yr_market.sql
│   │       └── mart_cty_yr_performance.sql
│   │
│   └── tests/
│
├── scripts/
│   └── ingestion/
│
├── notebooks/
│   ├── 01_eda.ipynb
│   ├── 02_relationship_analysis.ipynb
│   └── 03_forecasting.ipynb
│
├── src/
│   └── modeling/
│
├── outputs/
│   ├── figures/
│   └── tables/
│
└── docs/
    ├── architecture.png
    ├── data_dictionary.md
    └── methodology.md
```

## Setup

## Results

## Limitations

## Future Work

## Disclaimer

This is an SFSU BUS 895 student capstone prepared for a Kaiser Permanente client. Findings are for academic discussion. They do not represent Kaiser Permanente.
