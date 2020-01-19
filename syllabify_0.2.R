# Parse by indexing linear string, using onsets found in the cmu dictionary
# Parse stepwise by nucleus, onset, and coda; identifying dipththongs as a single nucleus
syllabify <- function(input, diphthong_list, onset_list, verbosity) {
  
  # Required packages
  require(stringr)
  
  # If diphthongs aren't specified, set it to American English diphthongs
  if (missing(diphthong_list)) {
    diphthong_list <- c("aɪ", "aʊ", "eɪ", "oʊ", "ɔɪ")
    #warning("No diphthongs provided. Using Standard American English diphthongs.")
  }
  
  # If licit onsets not supplied, use this list
  if (missing(onset_list)) {
    onset_list <- c("ʃɹ", "θɹ", "bɹ", "bj", "bl", "dɹ", "dw", "fɹ",
                    "fj", "fl", "gɹ", "gl", "gw", "hj", "hw", "kɹ",
                    "kj", "kl", "kw", "mj", "pɹ", "pj", "pl", "sk",
                    "sl", "sm", "sn", "sp", "st", "sw", "tɹ", "tw")
    # Removed: ʃl, ʃm, ʃn, ʃw, bw (two bilabials), dj, gj, sv, ts, 
  }
  
  # If verbosity not specified, select non-verbose
  if (missing(verbosity)) {
    verbosity <- "non-verbose"
  }
  
  # Make a df to store syllabification info
  syllabification <- data.frame(NA)
  
  # Assign colnames
  colnames(syllabification) <- "input"
  
  # Give the df the unicode_df class so it's printed correctly
  class(syllabification) <- c("unicode_df",
                              "data.frame")
  
  # Syllabify each word in the input, adding its information to each row
  for (word in 1:length(input)) {
    # Add the word to the df
    syllabification[word, 1] <- input[word]
    
    # Index ea segment by splitting word into component chars & associating ea w/ a # corresponding to its string-linear position
    split_word <- unlist(strsplit(as.character(input[word]), split = ""))
    char_index <- as.data.frame(as.matrix(split_word))
    class(char_index) <- c("unicode_df",
                           "data.frame")
    colnames(char_index)[1] <- "segment"
    char_index[,"position"] <- 1:length(split_word)
    char_index[,"sonority"] <- sonority(split_word)
    char_index[,"parsed"] <- FALSE
    char_index[,"syllable"] <- 0
    
    ### Determine syllable nuclei ###
    # Extract vowels
    vowels <- subset(char_index,
                     cvify(segment) == "V")
    
    # Get adjacent vowels (if there is more than one vowel in the word) & determine if they're diphthongs
    if (length(vowels$segment) > 1){
      ## Make a df to store each sequence of two vowels
      vowel_bigrams <- as.data.frame(matrix(ncol = 2))
      ## Set x to 1; each time the loop runs it will be increased by one so that the next bigram can be extracted
      x <- 1
      ## Get positions in linear string of original word of bigrams of extracted vowels
      for (vowel in 1:nrow(vowels)) {
        # If we didn't just parse the last vowel (if x is not equal to the number of vowels in the word), ...
        if (x != nrow(vowels)) {
          # ...then get the positions of those vowels and put in the vowel_bigram df
          vowel_bigrams[vowel,] <- vowels[x:(x+1),"position"]
          x <- x+1
        }
      }
      ## Get the diffs btw the pos'ns in the linear str to see which vowels were adjacent to each other in the original word
      vowel_bigrams$diff <- vowel_bigrams[,2] - vowel_bigrams[,1]
      ## If any vowels have a position difference of 1 (were actually adjacent to each other in the original string), subset only to them
      if (1 %in% vowel_bigrams$diff){
        ## Subset to originally adjacent vowels
        adjacent_vowels <- subset(vowel_bigrams,
                                  diff == 1)
        class(adjacent_vowels) <- c("unicode_df",
                                    "data.frame")
        ## Extract the adjacent vowels using their positions & paste them together in a new column
        for (pair in 1:nrow(adjacent_vowels)) {
          adjacent_vowels[pair,"bigram"] <- paste(as.character(char_index[,"segment"][adjacent_vowels[pair,1]]),
                                                  as.character(char_index[,"segment"][adjacent_vowels[pair,2]]),
                                                  sep = "")
        }
        ## See if any of these bigrams match the known diphthongs & indicate in adjacent_vowels w/ TRUE or FALSE
        for (bigram in 1:nrow(adjacent_vowels)) {
          # If the bigram is in the list of diphthongs, mark it as TRUE
          if(adjacent_vowels[bigram,"bigram"] %in% diphthong_list){
            adjacent_vowels[bigram,"diphthong"] <- TRUE
          } else {
            # Otherwise, mark it as false
            adjacent_vowels[bigram,"diphthong"] <- FALSE
          }
        }
        # Save the bigrams that are recognized diphthongs if there are any
        if (TRUE %in% adjacent_vowels$diphthong){
          diphthongs <- droplevels(subset(adjacent_vowels,
                                          diphthong == TRUE))
          class(diphthongs) <- c("unicode_df",
                                 "data.frame")
        }
      }
    }
    
    # Add column to vowel df that says whether the vowel is part of a diphthong (TRUE) or monophthong (FALSE), ...
    # and if it is part of a diphthong, which diphthong it's a part of (by which row in the diphthongs df it's in).
    for (vowel in 1:nrow(vowels)) {
      if (exists("diphthongs")) {
        if (vowels$position[vowel] %in% as.character(as.matrix(diphthongs[,1:2]))) {
          vowels[vowel,"in.diphthong"] <- TRUE
          vowels[vowel,"which.diphthong"] <- row(diphthongs[,1:2])[which(diphthongs[,1:2] == vowels$position[vowel])]
        } else {
          vowels[vowel,"in.diphthong"] <- FALSE
          # If the vowel isn't part of a diphthong, set "which.diphthong" to 0. Anything that's an actual diphthong will never be assigned zero, ...
          # since row numbers (in the diphthongs df) start w/ 1. Needs to be 0 b/c otherwise it's NA, in which case ...
          # an error is returned when testing if two vowel characters are part of the same diphthong.
          vowels[vowel,"which.diphthong"] <- 0
        }
      } else {
        vowels[vowel,"in.diphthong"] <- FALSE
        # If the vowel isn't part of a diphthong, set "which.diphthong" to 0. Anything that's an actual diphthong will never be assigned zero, ...
        # since row numbers (in the diphthongs df) start w/ 1. Needs to be 0 b/c otherwise it's NA, in which case an error is returned when testing if two vowel characters are part of the same diphthong.
        vowels[vowel,"which.diphthong"] <- 0
      }
    }
    
    # We now have enough information to say which vowel segments are associated w/ which syllables
    # Cycle through the vowel df and create a vector for the syllable nuclei in this word
    nuclei <- NA
    x <- 1
    for (vowel in 1:nrow(vowels)) {
      # If the vowel is not part of a diphthong, add it to the list of nuclei
      if (vowels[vowel,"in.diphthong"] == FALSE) {
        nuclei[x] <- as.character(vowels[vowel,"segment"])
        # Change parsed status to TRUE
        char_index[vowels[vowel,"position"],]$parsed <- TRUE
        # Indicate which syllable this vowel was parsed into
        char_index[vowels[vowel,"position"],]$syllable <- paste(c("\u03C3.", x),
                                                                collapse = "")
        # Add one to the syllable counter
        x <- x+1
      } else {
        # If we're not at the last vowel in vowels and the vowel and the following vowel are part of a diphthong together, paste them together as the next nucleus
        if (vowel != nrow(vowels)) {
          if (vowels[vowel,"which.diphthong"] > 0 & vowels[vowel,"which.diphthong"] == vowels[vowel+1,"which.diphthong"]) {
            nuclei[x] <- paste(as.character(vowels[vowel:(vowel+1),"segment"]),
                               collapse = "")
            # Change parsed status for both vowels to TRUE
            char_index[vowels[vowel,"position"],]$parsed <- TRUE
            char_index[vowels[vowel,"position"]+1,]$parsed <- TRUE
            # Indicate which syllable this vowel and the following vowel was parsed into
            char_index[vowels[vowel,"position"],]$syllable <- paste(c("\u03C3.", x),
                                                                    collapse = "")
            char_index[vowels[vowel,"position"]+1,]$syllable <- paste(c("\u03C3.", x),
                                                                      collapse = "")
            x <- x+1
          }
        }
      }
    }
    
    # Add nuclei to syllabification table for current word
    for (nucleus in 1:length(nuclei)) {
      syllabification[word,paste(c("\u03C3", nucleus),
                                 collapse = ".")] <- as.character(nuclei[nucleus])
    }
    
    # Remove vowel-related objects (IMPORTANT; this can screw up the next word if more than one word is supplied to the function)
    if (exists("vowel_bigrams")) {
      rm(vowel_bigrams)
    }
    if (exists("adjacent_vowels")) {
      rm(adjacent_vowels)
    }
    if (exists("diphthongs")){
      rm(diphthongs)
    }
    
    message("Step 1: Identify syllable nuclei: ",
            paste(syllabification[,2:ncol(syllabification)],
                  collapse = ", "))
    
    
    
    ### Parse onsets ###
    # For each unparsed consonant in the character index, starting from the end of the word, ...
    for (consonant in rev(subset(char_index, parsed == FALSE)$position)) {
      # If the consonant is preceding the first vowel, parse it into the first syllable
      if (char_index[consonant,"position"] < vowels[1,"position"]) {
        syllabification[word,"\u03C3.1"] <- paste(c(as.character((char_index[,"segment"])[consonant]),
                                                    syllabification[word,"\u03C3.1"]),
                                                  collapse = "")
        # Indicate that it is now parsed and that it went into the first syllable
        char_index[consonant,"parsed"] <- TRUE
        char_index[consonant,"syllable"] <- "\u03C3.1"
      } else {
        # Otherwise, if the position of the unparsed consonant immediately precedes a vowel, parse it with that vowel
        if ((char_index[consonant,"position"]+1) %in% vowels$position) {
          syllabification[word,char_index[consonant+1,"syllable"]] <- paste(c(as.character(char_index[consonant,"segment"]),
                                                                              syllabification[word,char_index[consonant+1,"syllable"]]),
                                                                            collapse = "")
          # Indicate that it is now parsed and that it went into the syllable of the vowel that follows it
          char_index[consonant,"parsed"] <- TRUE
          char_index[consonant,"syllable"] <- char_index[consonant+1, "syllable"]
        } else {
          # Otherwise, if the position of the unparsed consonant does NOT immediately precede the end of the word, AND immediately precedes another consonant, ...
          # check if the string formed by pasting those two consonants together is in the list of licit onsets
          if (is.na(as.character(char_index[consonant+1, "segment"])) == FALSE){
            #if (6 %in% char_index[consonant:nrow(char_index), "sonority"]) {}
              if (cvify(as.character(char_index[consonant+1,"segment"])) == "C") {
                # If those two characters pasted together is in the list of licit onsets, then parse the current consonant into the syllable of the following consonant
                if (paste(c(as.character(char_index[consonant, "segment"]),
                            as.character(char_index[consonant+1, "segment"])),
                          collapse = "") %in% onset_list) {
                  syllabification[word,char_index[consonant+1,"syllable"]] <- paste(c(as.character(char_index[consonant,"segment"]),
                                                                                      syllabification[word,char_index[consonant+1,"syllable"]]),
                                                                                    collapse = "")
                  # And mark that segment's parsed status as TRUE and indicate which syllable it was parsed into
                  char_index[consonant,"parsed"] <- TRUE
                  char_index[consonant,"syllable"] <- char_index[consonant+1, "syllable"]
                }
              }
            #}
          }
        }
      }
    }
    
    message("Step 2: Identify syllable onsets: ",
            paste(syllabification[,2:ncol(syllabification)],
                  collapse = ", "))
    
    ### Parse codas ###
    # For each unparsed consonant in the character index, starting from the beginning of the word, ...
    for (consonant in subset(char_index, parsed == FALSE)$position) {
      # Parse that consonant into the coda of the syllable into which the preceding segment was parsed
      syllabification[word, char_index[consonant-1,"syllable"]] <- paste(c(syllabification[word, char_index[consonant-1,"syllable"]],
                                                                           as.character(char_index[consonant,"segment"])),
                                                                         collapse = "")
      # And mark that segment's parsed status as TRUE and indicate which syllable it was parsed into
      char_index[consonant, "parsed"] <- TRUE
      char_index[consonant, "syllable"] <- char_index[consonant-1, "syllable"]
    }
    
    message("Step 3: Identify syllable codas: ",
            paste(syllabification[,2:ncol(syllabification)],
                  collapse = ", "))
    
    if (verbosity == "verbose") {
      print(char_index)
    }
  }
  # For each column in syllabification tbl, create collapsed version of syllabified word, using periods to separate syllables
  #  for (word in nrow(syllabification)) {
  #    for (syllable in )
  #  }
  return(syllabification)
}

random_word <- function(){
  cmudictipa[sample(1:nrow(cmudictipa), 1),"word"] -> rw
  return(rw)
}