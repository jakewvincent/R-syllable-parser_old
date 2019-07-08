syllabify <- function(text) {
  # Make a df to store syllabification info
  syllabification <- data.frame(NA, NA, NA, NA)
  # Assign colnames
  colnames(syllabification) <- c("word", "CV_seq", "son_seq", "vowel_pos")
  # Give df the unicode_df class so it's printed correctly
  class(syllabification) <- c("unicode_df", "data.frame")
  # Syllabify each word in the input, adding its information to each row
  for (word in 1:length(text)) {
    # Add that word and CV sequence info and sonority info to the first row of the df
    syllabification[word,1:3] <- c(text[word],
                                   cvify(text[word]),
                                   sonority(text[word]))
    # Get the positions (indices) of the vowels in the word, collapse into a string, and put in table
    vowels <- which(unlist(strsplit(as.character(syllabification[word,"son_seq"]), split = "")) == 6)
    n_sylls <- length(vowels)
    vowel_pos <- paste(vowels, collapse = ", ")
    syllabification[word,"vowel_pos"] <- vowel_pos
    
    # Perform first-pass syllabification, putting any consonants possible into onsets (Parse > Onset > NoCoda)
        # Make an object that will store the position of the last vowel parsed. start w/ 0.
        last <- 0
        # Split up the word into a vector, where each character has a slot in the vector
        split_word <- unlist(strsplit(text[word], split = ""))
    for (syllable in 1:n_sylls) {
      # Get all the segments up to the vowel, collapse them, and store them in the df as a syllable
      syllabification[word, (4+syllable)] <- paste(split_word[(last+1):vowels[syllable]], collapse = "")
      # Save the linear string position of the last vowel in the word that was parsed into a syllable
      last <- vowels[syllable]
      # If we're at the last syllable, ...
      if (syllable == n_sylls) {
        # And if there's something after the vowel (i.e. the pos'n of last vowel ≠ length of word), ...
        if (vowels[syllable] != length(split_word)) {
          # Then tack the remaining stuff onto the end of the last syllable
          syllabification[word, 4+syllable] <- paste(c(syllabification[word, 4+syllable], split_word[(last+1):length(split_word)]), collapse = "")
        }
      }
    }
  }
  # Label the syllable columns
  colnames(syllabification)[5:length(colnames(syllabification))] <- paste("\u03C3", seq_along(5:length(colnames(syllabification))), sep = "")
  return(syllabification)
}