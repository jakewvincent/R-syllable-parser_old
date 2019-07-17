# If dict has been successfully downloaded, do some cleanup
if (exists("cmudict_raw") == TRUE) {
  message("Formatting dictionary...")
  # Remove comment lines
  message("Removing comments...")
  cmudict_raw %<>% subset(left(., 3) != ";;;")
  # Replace spaces with commas, starting w/ double spaces
  cmudict_raw %<>% str_replace_all("\\s\\s", ",")
  cmudict_raw %<>% str_replace_all("\\s", ",")
  
  # Find out which row is longest by counting commas
      # Remove non-word characters from line beginnings
      message("Removing non-word characters...")
      cmudict_raw %<>% str_replace_all("(?<=^)[^\\w]", "")
  longest <- 0
  message("Finding longest word...")
  for (n in 1:length(cmudict_raw)) {
    str_count(cmudict_raw[n], ",") -> fields
    if (fields > longest) {
      longest <- fields
    }
  }
  
  # Add version to cmudict_raw
  message("Storing version information...")
  cmudict_raw <- c(latest_version, cmudict_raw)
  
  # Equalize # of fields (add fields to rows that are shorter than row w/ the highest # of fields)
  message("Equalizing row lengths...")
  for (n in 1:length(cmudict_raw)) {
    # Get diff btw current row and longest row
    to_add <- longest - str_count(cmudict_raw[n], ",")
    # Add # of commas necessary to match longest row
    cmudict_raw[n] <- paste(c(cmudict_raw[n], rep(",", to_add)), collapse = "")
  }
  
  # Save as csv
  message("Storing and reading as csv...")
  write_lines(cmudict_raw,
              path = "cmudict_raw.csv",
              append = FALSE)
  
  # Make a data.frame from cmudict_raw
  cmudict_dld <- read_csv(file = "cmudict_raw.csv",
                          col_names = c("word", paste("segment", 1:longest, sep = "")),
                          col_types = cols(.default = col_character()))
  
  # Enrich dictionary with stress information
  message("Extracting stress information...")
    # Find max number of primary and secondary stresses
    # Count the number of primary and secondary stresses in each word
    prim_stress_counts <- str_count(apply(cmudict_dld[2:last_seg_col],
                                          1,
                                          paste,
                                          collapse = ""),
                                    "1")
    sec_stress_counts <- str_count(apply(cmudict_dld[2:last_seg_col],
                                         1,
                                         paste,
                                         collapse = ""),
                                   "2")
    
    # Get the highest number for each
    max_prim_stress <- max(prim_stress_counts)
    max_sec_stress <- max(sec_stress_counts)
    
    # Add appropriate # of cols for each kind of stress
    cmudict_dld[,paste("prstr",
                       1:max_prim_stress,
                       sep = "")] <- NA
    cmudict_dld[,paste("secstr",
                       1:max_sec_stress,
                       sep = "")] <- NA
    
    ## Extract stress info into newly created columns
    # Last segment column
    last_seg_col <- longest + 1
    # Last primary stress column
    last_pstress_col <- last_seg_col + max_prim_stress
    
    ## Following is deprecated
    # Make a copy of cmudict_dld for testing purposes
    #cmudict_test <- cmudict_dld
    #
    #forloop_start <- Sys.time()
    ## For each segment in each row, if segment is stressed, put segment # into the appropriate stress column
    #for (row in 2:nrow(cmudict_dld)) {
    #  nthprimary <- 1
    #  nthsecondary <- 1
    #  for (segment in 2:last_seg_col) {
    #    if (is.na(cmudict_dld[row, segment]) == FALSE) {
    #      if (right(cmudict_dld[row, segment], 1) == "1") {
    #        # Copy the column name to the row corresponding to the nth primary stress
    #        colnames(cmudict_dld)[segment] -> cmudict_dld[row, last_seg_col + nthprimary]
    #        # And increase the counter by one
    #        nthprimary <- nthprimary + 1
    #      } else {
    #        if (right(cmudict_dld[row, segment], 1) == "2") {
    #          # Copy the column name to the row corresponding to the nth secondary stress
    #          colnames(cmudict_dld)[segment] -> cmudict_dld[row, last_pstress_col + nthsecondary]
    #          # And increase the counter by one
    #          nthsecondary <- nthsecondary + 1
    #        }
    #      }
    #    }
    #  }
    #  # Make a status message that updates on the same line. x = % of rows that have been analyzed.
    #  x <- round((row/nrow(cmudict_dld))*100, digits = 2)
    #  message(x,
    #          " percent done extracting stress information.",
    #          "\r",
    #          appendLF=FALSE)
    #  flush.console()
    #}
    #forloop_end <- Sys.time()
    #forloop_total <- forloop_end - forloop_start
    
    # Create a df w/ primary stress positions (by name of column, which reflects segment #)
    prim_stress_locs <- as.data.frame(
      t(apply(cmudict_dld,
              1, # Apply by row
              function(x){
                # Save the colnames of the segments that end in 1 (bear primary stress)
                r_s <- colnames(cmudict_dld)[which(right(x, 1) == "1")]
                # Concatenate these colnames w/ the num of NAs necessary to make the length 6
                c(r_s,
                  rep(NA,
                      max_prim_stress-length(unlist(r_s))))
                }
              )
        ),
      stringsAsFactors = FALSE
      )
    # Add primary stress locations to main cmudict df
    cmudict_dld[,(last_seg_col+1):last_pstress_col] <- prim_stress_locs
    
    # Create a df w/ secondary stress positions
    sec_stress_locs <- as.data.frame(
      t(apply(cmudict_dld,
              1, # Apply by row
              function(x){
                # Save the colnames of the segments that end in 1 (bear primary stress)
                r_s <- colnames(cmudict_dld)[which(right(x, 1) == "2")]
                # Concatenate these colnames w/ the num of NAs necessary to make the length 6
                c(r_s,
                  rep(NA,
                      max_sec_stress-length(unlist(r_s))))
                }
              )
        ),
      stringsAsFactors = FALSE
      )
    # Add secondary stress locations to main cmudict df
    cmudict_dld[,(last_pstress_col+1):(last_pstress_col+max_sec_stress)] <- sec_stress_locs
    
    # Convert arpabet characters to IPA characters
    # TO-DO: Make this an external file that's imported so that it's user-adjustable
    message("Converting ARPABET codes into IPA characters. This may take a while...")
    for (segment in 2:last_seg_col) {
      str_replace_all(pull(cmudict_dld[,segment]),
                      c("AA0" = "ɑ",
                        "AA1" = "ɑ",
                        "AA2" = "ɑ",
                        "AE0" = "æ",
                        "AE1" = "æ",
                        "AE2" = "æ",
                        "AH0" = "ə",
                        "AH1" = "ʌ",
                        "AH2" = "ʌ",
                        "AO0" = "ɔ",
                        "AO1" = "ɔ",
                        "AO2" = "ɔ",
                        "AW0" = "aʊ",
                        "AW1" = "aʊ",
                        "AW2" = "aʊ",
                        "AY0" = "aɪ",
                        "AY1" = "aɪ",
                        "AY2" = "aɪ",
                        "B" = "b",
                        "CH" = "ʧ",
                        "DH" = "ð",
                        "D" = "d",
                        "EH0" = "ɛ",
                        "EH1" = "ɛ",
                        "EH2" = "ɛ",
                        "ER0" = "ɚ",
                        "ER1" = "ɚ",
                        "ER2" = "ɚ",
                        "EY0" = "eɪ",
                        "EY1" = "eɪ",
                        "EY2" = "eɪ",
                        "F" = "f",
                        "HH" = "h",
                        "IH0" = "ɪ",
                        "IH1" = "ɪ",
                        "IH2" = "ɪ",
                        "IY0" = "i",
                        "IY1" = "i",
                        "IY2" = "i",
                        "JH" = "ʤ",
                        "K" = "k",
                        "L" = "l",
                        "M" = "m",
                        "NG" = "ŋ",
                        "G" = "g",
                        "N" = "n",
                        "OW0" = "oʊ",
                        "OW1" = "oʊ",
                        "OW2" = "oʊ",
                        "OY0" = "ɔɪ",
                        "OY1" = "ɔɪ",
                        "OY2" = "ɔɪ",
                        "P" = "p",
                        "R" = "ɹ",
                        "SH" = "ʃ",
                        "S" = "s",
                        "TH" = "θ",
                        "T" = "t",
                        "UH0" = "ʊ",
                        "UH1" = "ʊ",
                        "UH2" = "ʊ",
                        "UW0" = "u",
                        "UW1" = "u",
                        "UW2" = "u",
                        "V" = "v",
                        "W" = "w",
                        "Y" = "j",
                        "ZH" = "ʒ",
                        "Z" = "z")) -> cmudict_dld[,segment]
      message("Converting segment ",
              segment,
              " throughout the dictionary.",
              "\r",
              appendLF=FALSE)
      flush.console()
    }
    
    message("ARPABET-to-IPA conversion complete.")
  
  # Let user know formatting is done
  message("Formatting complete.")
}