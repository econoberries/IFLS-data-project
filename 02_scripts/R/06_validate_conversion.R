# Validate a converted IFLS Stata dataset against CSV, Parquet and metadata.
# Run from the repository root after conversion.
validate_ifls_conversion <- function(wave, dataset, book = "hh", project_root = ".") {
  stopifnot(is.character(wave), length(wave) == 1L,
            is.character(dataset), length(dataset) == 1L)
  stem <- file.path(wave, book, dataset)
  root <- normalizePath(project_root, winslash = "/", mustWork = TRUE)
  dta <- file.path(root, "01_data/01_raw_dta", paste0(stem, ".dta"))
  csv <- file.path(root, "01_data/02_raw_csv", paste0(stem, ".csv"))
  parquet <- file.path(root, "01_data/03_raw_parquet", paste0(stem, ".parquet"))
  metadata <- file.path(root, "01_data/03_metadata", paste0(stem, "_variables.csv"))
  files <- c(dta, csv, parquet, metadata)
  if (!all(file.exists(files))) stop("Missing files: ", paste(files[!file.exists(files)], collapse = ", "))
  original <- haven::read_dta(dta)
  csv_data <- readr::read_csv(csv, show_col_types = FALSE, name_repair = "minimal")
  parquet_data <- arrow::read_parquet(parquet, as_data_frame = TRUE)
  meta <- readr::read_csv(metadata, show_col_types = FALSE)
  checks <- c(
    csv_rows = nrow(csv_data) == nrow(original),
    parquet_rows = nrow(parquet_data) == nrow(original),
    csv_columns = identical(names(csv_data), names(original)),
    parquet_columns = identical(names(parquet_data), names(original)),
    metadata_columns = identical(meta$variable, names(original))
  )
  # Type and value equality are not asserted: CSV may infer types differently,
  # and Stata labels/tagged missing codes require metadata-specific checks.
  result <- data.frame(check = names(checks), passed = unname(checks))
  print(result)
  if (!all(checks)) stop("Conversion validation failed: ", paste(names(checks)[!checks], collapse = ", "))
  invisible(result)
}

# Example:
# source("02_scripts/R/06_validate_conversion.R")
# validate_ifls_conversion("ifls5", "bk_ar1", book = "hh")
