# Download most recent CMU dictionary file & apply formatting

# Load required packages
require(stringr)
require(RCurl)


  ## TO DO:
  ## Use version checker latest version value to find the file of the latest version

# Make url for most recent version
latest_cmudict_url <- paste("http://svn.code.sf.net/p/cmusphinx/code/trunk/cmudict/cmudict-", latest_version, sep = "")

# Determine accessibility of the dictionary page
url.exists(latest_cmudict_url) -> result

# If the url doesn't exist, send an internet connection warning. Otherwise, read the file in as a csv.
if (result == FALSE) {
  warning(c("Couldn't connect to ",
            latest_cmudict_url,
            ". Please make sure you are connected to the internet. Proceeding without downloading the latest version of the dictionary."))
} else {
  # Download dictionary
  message("Downloading dictionary...")
  cmudict_raw <- read_lines(file = url(latest_cmudict_url),
                            skip = 0,
                            n_max = -1L,
                            na = character())
  message("Download complete.")
}