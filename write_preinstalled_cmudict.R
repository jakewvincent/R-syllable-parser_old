## This script saves the pre-packaged version of cmudict.
## It is not called in master.R
## Before running this, run cmudict_downloader.R and cmudict_formatter.R

require(magrittr)
require(readr)

# Import misc. functions
source(file = "misc_functions.R")

# Import dictionary downloader
source(file = "cmudict_downloader.R")

# If user.replacements exists, remove it
if (exists("user.replacements")) {
  rm(user.replacements)
}
# Set user.replacements to "preinstalled" and formatter will avoid
# asking about replacements.
user.replacements <- "preinstalled"

# Import CMU formatter
if (.Platform$OS.type == "windows") {
  source.utf8(f = "cmudict_formatter.R")
} else{
  source(file = "cmudict_formatter.R")
}

# Write the downloaded and formatted dictionary to a csv file
write_csv(
  cmudict_dld,
  path = "cmudict_preinstalled.csv",
  col_names = TRUE
)
