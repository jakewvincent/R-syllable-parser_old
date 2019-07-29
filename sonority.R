# Define a function that replaces IPA characters with their sonority value

# Old function
sonority_old <- function(text){
  text <- as.character(text)
  if (length(text) > 1) {
    s_levels <- NA
    for (word in 1:length(text)) {
      split_text <- unlist(strsplit(text[word], split = ""))
      split_text_tbl <- matrix(split_text)
      son_string <- NA
      for (seg in 1:length(split_text_tbl[,1])) {
        features[which(features[,"segment"] == split_text_tbl[seg,1]), "sonority"] -> son_string[seg]
      }
      sonified_tbl <- cbind(split_text_tbl, son_string)
      paste(sonified_tbl[,2], collapse = "") -> s_levels[word]
    }
  } else {
    split_text <- unlist(strsplit(text, split = ""))
    matrix(split_text) -> split_text_tbl
    son_string <- NA
    for (seg in 1:length(split_text_tbl[,1])) {
      features[which(features[,"segment"] == split_text_tbl[seg,1]), "sonority"] -> son_string[seg]
    }
    sonified_tbl <- cbind(split_text_tbl, son_string)
    paste(sonified_tbl[,2], collapse = "") -> s_levels
  }
  return(s_levels)
}

# Make vector of IPA characters for each sonority level
# Assume there are 6 sonority levels
stops_affs <- paste(as.character(subset(features,
                                        continuant == 0 & sonorant == 0)[,"segment"]),
                    collapse = "|")
fricatives <- paste(as.character(subset(features,
                                        sonorant == 0 & continuant == 1)[,"segment"]),
                    collapse = "|")
nasals <- paste(as.character(subset(features,
                                    nasal == 1)[,"segment"]),
                collapse = "|")
liquids <-  paste(as.character(subset(features,
                                      consonantal == 1 & approximant == 1)[,"segment"]),
                  collapse = "|")
glides <- paste(as.character(subset(features,
                                    syllabic == 0 & consonantal == 0)[,"segment"]),
                collapse = "|")
vowels <- paste(as.character(subset(features,
                                    syllabic == 1)[,"segment"]),
                collapse = "|")

# New function
sonority <- function(text) {
  text <- as.character(text)
  sapply(text,
         function(y){
           gsub(pattern = stops_affs,
                replacement = "1",
                x = gsub(pattern = fricatives,
                         replacement = "2",
                         x = gsub(pattern = nasals,
                                  replacement = "3",
                                  x = gsub(pattern = liquids,
                                           replacement = "4",
                                           x = gsub(pattern = glides,
                                                    replacement = "5",
                                                    x = gsub(pattern = vowels,
                                                             replacement = "6",
                                                             x = y))))))
         })
}