# Define a function that replaces IPA characters with their sonority value

sonority <- function(text){
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