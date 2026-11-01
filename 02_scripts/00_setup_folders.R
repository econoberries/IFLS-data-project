# Create local IFLS project directories without modifying source files.
project_folder <- normalizePath(".", winslash = "/", mustWork = TRUE)
folders <- c(
  "01_data/01_raw_dta",
  "01_data/02_raw_csv",
  "01_data/03_metadata",
  "01_data/04_cleaned",
  "01_data/05_panel",
  "04_outputs/tables",
  "04_outputs/figures"
)
for (folder in folders) {
  dir.create(file.path(project_folder, folder), recursive = TRUE, showWarnings = FALSE)
}
message("IFLS project directories are ready in: ", project_folder)
