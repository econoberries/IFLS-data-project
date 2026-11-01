# IFLS Data Preparation Project

A **hybrid R + Python** repository for reproducible Indonesian Family Life Survey (IFLS) data preparation, documentation, validation and cross-wave harmonization. Downstream econometric and causal ML research belongs in separate analysis projects.

## Division of responsibilities

- **R**: authoritative Stata import, metadata extraction, cleaning, harmonization and panel construction.
- **Python**: independent validation, profiling, cross-language interoperability and ML-ready exports.
- **Parquet**: preferred typed exchange format; CSV optional for compatibility. Variable labels, tagged missingness and questionnaire codes require separate metadata and explicit validation.

Do not maintain competing R and Python cleaning pipelines.

## Structure

- `01_data/`: local raw Stata, CSV, metadata, cleaned, harmonized, panel and research-ready data (ignored by Git)
- `02_scripts/R/`: primary R scripts
- `02_scripts/python/`: Python setup, validation and interoperability scripts
- `03_documentation/`: questionnaires, dictionaries, harmonization and merging guidance
- `04_notebooks/`: language-specific exploratory notebooks
- `05_outputs/`: local quality reports, tables and figures
- `06_tests/`: R/Python tests and synthetic fixtures
- `07_config/`: wave, path and variable mapping configurations

## Getting started

Clone the repository and open `IFLS_Data_Preparation.Rproj` in RStudio. From the repository root:

```r
source("02_scripts/R/00_setup_folders.R")
source("02_scripts/R/01_install_packages.R")
```

For Python 3.11+:

```bash
python3 -m venv .venv
source .venv/bin/activate
python -m pip install -e ".[dev]"
python 02_scripts/python/00_setup.py
python -m pytest
```

On Windows, activate with `.venv\\Scripts\\activate` instead.

The setup scripts only create missing local folders. Do not upload IFLS respondent-level data to GitHub.

## Implementation status

**Phase 1: repository structure and environments initialized.** Python validation and R conversion scripts are scaffolds, not completed pipelines. The earlier R converter must be migrated and validated in Phase 2. `pyproject.toml` provides bounded dependencies; an R `renv.lock` and fully locked Python environment will be generated only after dependencies are installed and tested.

## Next milestones

1. Port and test the existing Stata conversion helper and metadata pipeline.
2. Validate source/export row counts, column order, labels and special missing values.
3. Pilot IFLS5 Book K cleaning and dictionaries.
4. Harmonize earlier waves and audit `pidlink` and split-off households.
5. Export research-defined samples for causal ML.

**Data safety:** Original `.dta` files are immutable. Never commit raw or generated respondent-level data. Use synthetic fixtures for tests.

## First real-data pilot: IFLS 5 Book K

Place your legally obtained `bk_ar1.dta` at `01_data/01_raw_dta/ifls5/hh/bk_ar1.dta`. From the repository root, run:

```r
source("02_scripts/R/00_setup_folders.R")
source("02_scripts/R/01_install_packages.R")
source("02_scripts/R/02_convert_dta.R")
source("02_scripts/R/06_validate_conversion.R")
validate_ifls_conversion("ifls5", "bk_ar1", book = "hh")
```

Then activate the Python environment and independently validate:

```bash
python 02_scripts/python/01_validate_conversion.py --wave ifls5 --book hh --dataset bk_ar1
python -m pytest
```

Change only `wave` and `dataset` at the top of `02_scripts/R/02_convert_dta.R` for subsequent conversions. `dataset = "all"` processes a wave; `wave = "all"` and `dataset = "all"` process all files. The folder directly beneath `01_raw_dta/` must be the wave name. Existing outputs are skipped unless `overwrite = TRUE`.

**Validation limits:** These initial validators check structural integrity only; they do not yet prove equality of all values, types, value labels, or tagged missing values. Real IFLS data must be supplied and tested locally. No real-data validation has been executed by the repository setup.
