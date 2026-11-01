# Install core packages only when missing.
packages <- c("haven", "readr", "dplyr", "tidyr", "purrr", "stringr", "knitr", "rmarkdown")
missing <- setdiff(packages, rownames(installed.packages()))
if (length(missing) > 0) install.packages(missing)
message("Core R packages are available.")
