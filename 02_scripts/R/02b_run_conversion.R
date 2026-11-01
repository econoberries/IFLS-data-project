# Discover, filter, and convert source files. Source the helper first.
run_ifls_conversion <- function(wave = "ifls5", dataset = "all",
                                overwrite = FALSE, project_root = ".") {
  root <- normalizePath(project_root, winslash = "/", mustWork = TRUE)
  raw_root <- file.path(root, "01_data", "01_raw_dta")
  if (!dir.exists(raw_root)) stop("Raw Stata directory does not exist: ", raw_root)
  all_files <- list.files(raw_root, pattern = "\\.[dD][tT][aA]$", recursive = TRUE,
                          full.names = TRUE)
  if (!length(all_files)) stop("No .dta files found under ", raw_root)
  relative <- substring(normalizePath(all_files, winslash = "/"),
                        nchar(normalizePath(raw_root, winslash = "/")) + 2L)
  wave <- tolower(wave)
  if (wave != "all") {
    selected_wave <- tolower(strsplit(relative, "/", fixed = TRUE))
    # Wave is the first folder immediately under 01_raw_dta.
    keep <- tolower(sub("/.*$", "", relative)) == wave
    all_files <- all_files[keep]
    relative <- relative[keep]
  }
  if (dataset != "all") {
    # Match filename stem, case-insensitively; names can repeat across books.
    stems <- tolower(tools::file_path_sans_ext(basename(all_files)))
    keep <- stems == tolower(dataset)
    all_files <- all_files[keep]
    relative <- relative[keep]
  }
  if (!length(all_files)) stop("No matching .dta files for wave=", wave, " and dataset=", dataset)
  if (dataset != "all" && length(all_files) > 1L)
    message("Multiple files share this name; converting all matches: ", paste(relative, collapse = ", "))
  source(file.path(root, "02_scripts/R/02a_convert_one_dta.R"), local = TRUE)
  results <- lapply(all_files, function(file) {
    tryCatch(convert_one_dta(file, raw_root,
                             file.path(root, "01_data/02_raw_csv"),
                             file.path(root, "01_data/03_raw_parquet"),
                             file.path(root, "01_data/03_metadata"),
                             overwrite = overwrite),
             error = function(e) data.frame(source = file, status = paste0("error: ", conditionMessage(e)),
                                            rows = NA_integer_, columns = NA_integer_))
  })
  log <- do.call(rbind, results)
  log_dir <- file.path(root, "05_outputs/quality_reports")
  dir.create(log_dir, recursive = TRUE, showWarnings = FALSE)
  log_file <- file.path(log_dir, paste0("conversion_", format(Sys.time(), "%Y%m%d_%H%M%S"), ".csv"))
  readr::write_csv(log, log_file)
  message("Processed ", nrow(log), " source files. Log: ", log_file)
  log
}
