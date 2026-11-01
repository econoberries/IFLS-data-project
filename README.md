# IFLS Data Preparation Project

A reproducible, R-based workflow for organizing, documenting, converting, validating, cleaning, and linking **Indonesian Family Life Survey (IFLS)** data across waves 1–5.

## Purpose

This repository is for **data engineering and documentation**, separate from downstream research and causal analysis. It supports wave-specific datasets and future longitudinal panels without modifying the original Stata sources.

## Project structure

- `01_data/` — local raw Stata files, converted CSVs, metadata, cleaned data, and panels
- `02_scripts/` — setup, package installation, conversion, exploration, cleaning, and panel scripts
- `03_documentation/` — R Markdown overviews, Book K exploration, dictionaries, and merging guidance
- `04_outputs/` — generated tables and figures
- `05_tests/` — synthetic tests and validation checks
- `IFLS_Data_Preparation.Rproj` — RStudio project file

Git does not store empty directories, so local data/output subdirectories are created by the setup script.

## Getting started

Open `IFLS_Data_Preparation.Rproj` in RStudio, ensure the working directory is the project root, and run:

```r
source("02_scripts/00_setup_folders.R")
source("02_scripts/01_install_packages.R")
```

Copy your locally obtained IFLS Stata files into `01_data/01_raw_dta/`, keeping wave-specific folders. The conversion, exploration, cleaning, and panel scripts are **scaffolds**, not yet production-ready: they require porting and validating the earlier converter and careful audits of questionnaires and identifiers.

## Data safeguards

**Do not commit respondent-level IFLS microdata or other restricted data.** The `.gitignore` excludes raw and generated datasets. Keep source `.dta` files unchanged; record labels and special codes in metadata; verify `pidlink` and household linkage rather than assuming one-to-one merges.

## Planned milestones

1. Audit file inventories and questionnaire books for each wave.
2. Port and test the existing Stata-to-CSV conversion pipeline.
3. Build variable dictionaries and document missing/special codes.
4. Implement reproducible book-level cleaning and checks.
5. Construct and validate cross-wave individual and household panels.
