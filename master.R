# This is the master script for the syllable parser
# Author: Jake Vincent (https://jakewvincent.github.io, https://people.ucsc.edu/~jwvincen)

# Get libraries
require(magrittr)
require(dplyr)
require(stringr)
require(tidyr)
require(dplyr)
require(RCurl)
require(readr)

# Import misc. functions
source(file = "misc_functions.R")

# Import preinstalled cmudict
cmudict_preinstalled <- read_csv(file = "cmudict_preinstalled.csv",
                                 col_names = TRUE,
                                 col_types = cols(.default = col_character()))
preinstalled_version <- as.character(cmudict_preinstalled[1,1])

response <- readline(prompt = "Check for updates to the dictionary? Enter 'y' to check for updates or 'n' to skip: ")
if (str_detect(response, "y|Y")) {
  # Import CMU latest version checker
  source(file = "cmudict_version_checker.R")
  
  if (latest_version != preinstalled_version) {
    response <- readline(prompt = "Do you wish to download the latest version of cmudict? Enter 'y' to download update or 'n' to skip: ")
    if (str_detect(response, "y|Y")) {
      # Import CMU downloader
      source(file = "cmudict_downloader.R")
      
      # Import CMU formatter
      if (.Platform$OS.type == "windows") {
        source.utf8(f = "cmudict_formatter.R")
      } else{
        source(file = "cmudict_formatter.R")
      }
    }
  }
}