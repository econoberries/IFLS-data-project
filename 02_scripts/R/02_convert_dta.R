# Edit only these settings for each conversion run.
wave <- "ifls5"      # "ifls1", "ifls2", "ifls2plus", "ifls3", "ifls4", "ifls5", or "all"
dataset <- "bk_ar1"  # Stata filename without .dta, or "all"
overwrite <- FALSE   # TRUE explicitly replaces existing outputs

# Run from the RStudio project root.
source("02_scripts/R/02b_run_conversion.R")
conversion_log <- run_ifls_conversion(wave = wave, dataset = dataset,
                                      overwrite = overwrite, project_root = ".")
print(conversion_log)
