# Define a function that converts a string of IPA characters into a string of Cs and Vs

# Old function
cvify <- function(text) {
  if (NA %in% text) {
    warning("Input contains NA(s), which I don't know how to CVify!")
    return(0)
  } else {
    text <- as.character(text)
    if (length(text) > 1) {
      CVs <- NA
      for (word in 1:length(text)) {
        split_text <- unlist(strsplit(text[word], split = ""))
        split_text_tbl <- matrix(split_text)
        CV_string <- NA
        for (segment in 1:length(split_text_tbl[,1])) {
          features[which(features[,"segment"] == split_text_tbl[segment,1]), "syllabic"] -> syllabic
          ifelse(syllabic == "1", "V", "C") -> CV_string[segment]
        }
        CVified_tbl <- cbind(split_text_tbl, CV_string)
        paste(CVified_tbl[,2], collapse = "") -> CVs[word]
      }
    } else {
      split_text <- unlist(strsplit(text, split = ""))
      matrix(split_text) -> split_text_tbl
      CV_string <- NA
      for (segment in 1:length(split_text_tbl[,1])) {
        features[which(features[,"segment"] == split_text_tbl[segment,1]), "syllabic"] -> syllabic
        ifelse(syllabic == "1", "V", "C") -> CV_string[segment]
      }
      CVified_tbl <- cbind(split_text_tbl, CV_string)
      paste(CVified_tbl[,2], collapse = "") -> CVs
    }
    return(CVs)
  }
}

# Vowel & consonant lists
all_vowels <- paste(as.character(subset(features,
                                        syllabic == 1)[,"segment"]),
                    collapse = "|")
all_consonants <- paste(as.character(subset(features,
                                            syllabic == 0)[,"segment"]),
                        collapse = "|")

# New function:
cv <- function(text) {
  text <- as.character(text)
  
  # Split string into component chars
  #split_text <- strsplit(text, split = "")
  sapply(text,
         function(y){
           # Recursive gsub function. The object that the first gsub function takes is the output of the embedded gsub function.
           gsub(pattern = all_vowels,
                replacement = "V",
                x = gsub(pattern = all_consonants,
                         replacement = "C",
                         x = y))
         }) -> output
  return(output)
}