# This is the master script for the syllable parser
# Author: Jake Vincent
# Website: https://jakewvincent.github.io | https://people.ucsc.edu/~jwvincen
# Contact: jakewvincent@gmail.com | jwvincen@ucsc.edu

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
# Import phonological distinctive feature chart
source(file = "features.R")
# Import CV function
source(file = "cvify.R")
# Import sonority function
source(file = "sonority.R")
# Import 

# Import preinstalled cmudict
cmudict_preinstalled <- read_csv(file = "cmudict_preinstalled.csv",
                                 col_names = TRUE,
                                 col_types = cols(.default = col_character()))
preinstalled_version <- as.character(cmudict_preinstalled[1,1])

response <- readline(prompt = "Check for updates to the CMU Pronouncing Dictionary? Input 'y' to check for updates or 'n' to skip and press enter: ")
if (str_detect(response, "y|Y")) {
  # Import CMU latest version checker
  source(file = "cmudict_version_checker.R")
  
  if (latest_version != preinstalled_version) {
    response <- readline(prompt = "Do you wish to download the latest version of cmudict? Input 'y' or 'n' and press enter: ")
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