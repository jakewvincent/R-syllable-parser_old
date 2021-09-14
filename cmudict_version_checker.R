## Get current version of CMU pronouncing dictionary

# Load required packages
require(RCurl)

# See if the website can be accessed
message("Making sure the cmu dictionary can be accessed...")
result <- url.exists("http://svn.code.sf.net/p/cmusphinx/code/trunk/cmudict/")

# If the result is FALSE, give a warning. If not, download file.
if (result == FALSE) {
  warning("Couldn't connect to http://svn.code.sf.net/p/cmusphinx/code/trunk/cmudict/. Please make sure you have an internet connection. Proceeding without checking latest dictionary version.")
} else {
  # Download version
  message("Cmudict website accessed successfully. Checking most recent version...")
  cmu_versions_raw <- read.csv(url("http://svn.code.sf.net/p/cmusphinx/code/trunk/cmudict/"))
}

# Get rid of html tags, first two elements in matrix
cmu_versions_raw <- str_replace_all(cmu_versions_raw[3:length(cmu_versions_raw[, 1]), 1], "<.+?>", "")

# Save rows w/ "cmudict" to a separate df, cmu_versions
cmu_versions <- NA
x <- 1
for (n in 1:length(cmu_versions_raw)) {
  if (str_detect(cmu_versions_raw[n], "cmudict") == TRUE) {
    cmu_versions[x] <- cmu_versions_raw[n]
    x <- x + 1
  }
}
cmu_versions_raw <- cmu_versions

# Get rid of "phones" & "symbols" versions
cmu_versions <- NA
x <- 1
for (n in 1:length(cmu_versions_raw)) {
  if (str_detect(cmu_versions_raw[n],
                 "\\.phones") == TRUE |
      str_detect(cmu_versions_raw[n],
                 "\\.symbols") == TRUE) {
    # Do nothing
  } else {
    cmu_versions[x] <- cmu_versions_raw[n]
    x <- x + 1
  }
}

# Extract strings that start w/ a number, through the end of the string
cmu_versions <- str_extract_all(cmu_versions, "\\d.+?$", simplify = TRUE)

# Convert to df
cmu_versions <- as.data.frame(as.matrix(cmu_versions), stringsAsFactors = FALSE)

# Rearrange rows in descending order so the most recent version is at the top
cmu_versions <- arrange(cmu_versions, desc(V1))

# Name most recent version
latest_version <- cmu_versions[1,1]

if (latest_version == preinstalled_version) {
  message("You have the most recent version of cmudict and do not need to update the dictionary.")
} else {
  message("The most recent version of cmudict is ",
          latest_version,
          ", and the pre-installed version is ",
          preinstalled_version,
          ".")
}
