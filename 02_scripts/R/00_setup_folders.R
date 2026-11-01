# Run from the repository root (RStudio project).
project_folder <- normalizePath(".", winslash = "/", mustWork = TRUE)
if (!file.exists(file.path(project_folder, "IFLS_Data_Preparation.Rproj"))) stop("Open the IFLS RStudio project before running setup.")
folders <- c("01_data/01_raw_dta","01_data/02_raw_csv","01_data/03_metadata","01_data/04_cleaned","01_data/05_harmonized","01_data/06_panel","01_data/07_research_ready","05_outputs/tables","05_outputs/figures","05_outputs/quality_reports")
for (folder in folders) dir.create(file.path(project_folder, folder), recursive = TRUE, showWarnings = FALSE)
message("Local directories ready: ", project_folder)
