# Helper: convert one Stata file without modifying its source.
convert_one_dta <- function(source_file, raw_root, csv_root, parquet_root,
                            metadata_root, overwrite = FALSE) {
  stopifnot(file.exists(source_file), dir.exists(raw_root))
  relative <- substring(normalizePath(source_file, winslash = "/"),
                        nchar(normalizePath(raw_root, winslash = "/")) + 2L)
  if (startsWith(relative, "/") || startsWith(relative, "../") ||
      identical(relative, source_file)) stop("Source file is outside raw_root.")
  stem <- tools::file_path_sans_ext(relative)
  csv_file <- file.path(csv_root, paste0(stem, ".csv"))
  parquet_file <- file.path(parquet_root, paste0(stem, ".parquet"))
  metadata_file <- file.path(metadata_root, paste0(stem, "_variables.csv"))
  outputs <- c(csv_file, parquet_file, metadata_file)
  if (!overwrite && any(file.exists(outputs))) {
    return(data.frame(source = relative, status = "skipped_existing",
                      rows = NA_integer_, columns = NA_integer_))
  }
  for (path in outputs) dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
  data <- haven::read_dta(source_file)
  variable_labels <- vapply(data, function(x) {
    lab <- attr(x, "label", exact = TRUE)
    if (is.null(lab)) "" else as.character(lab)[1]
  }, character(1))
  value_labels <- vapply(data, function(x) {
    lab <- attr(x, "labels", exact = TRUE)
    if (is.null(lab)) "" else paste(paste(names(lab), unname(lab), sep = "="), collapse = "; ")
  }, character(1))
  metadata <- data.frame(variable = names(data), class = vapply(data, function(x) paste(class(x), collapse = "/"), character(1)),
                         variable_label = variable_labels, value_labels = value_labels)
  # CSV is for convenience only; labels and Stata tagged missingness are not round-trip safe.
  csv_data <- haven::zap_labels(data)
  csv_data <- haven::zap_missing(csv_data)
  readr::write_csv(csv_data, csv_file)
  arrow::write_parquet(csv_data, parquet_file)
  readr::write_csv(metadata, metadata_file)
  data.frame(source = relative, status = "converted", rows = nrow(data), columns = ncol(data))
}
