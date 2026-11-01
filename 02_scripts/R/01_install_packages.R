# Install core packages only when missing; use renv for reproducible locking later.
packages <- c("haven","readr","dplyr","tidyr","purrr","stringr","knitr","rmarkdown","arrow","yaml","testthat")
missing <- setdiff(packages, rownames(installed.packages()))
if (length(missing)) install.packages(missing)
message("R dependencies available.")
