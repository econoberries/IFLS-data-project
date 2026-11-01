# Data directories

Run `02_scripts/00_setup_folders.R` to create local directories:

- `01_raw_dta/`: original Stata files (read-only source)
- `02_raw_csv/`: unmodified CSV conversions
- `03_metadata/`: variable labels, formats, and conversion inventories
- `04_cleaned/`: cleaned wave-specific datasets
- `05_panel/`: longitudinal linked datasets

**Never commit IFLS respondent-level data.** Raw and generated datasets are ignored by Git.
