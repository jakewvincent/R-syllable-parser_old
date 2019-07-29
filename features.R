features <- data.frame(segment = c("i", "y", "ɨ", "ʉ", "ɯ", "u", "ɪ", "ʏ", "ʊ", "e", "ø", "ɘ", "ɵ", "ɤ",
                                   "o", "ɛ", "œ", "ə", "ɞ", "ʌ", "ɔ", "æ", "ɶ", "a", "ɑ", "ɒ", "j", "ʋ",
                                   "ɥ", "w", "ʙ", "l", "r", "ɾ", "ɹ", "ʎ", "ʟ", "ʀ", "m", "ɱ", "n", "ɳ",
                                   "ɲ", "ŋ", "ɴ", "p", "b", "ɸ", "β", "f", "v", "θ", "ð", "t", "d", "s",
                                   "z", "ʃ", "ʒ", "ʦ", "ʣ", "ʧ", "ʤ", "c", "ɟ", "ç", "ʝ", "k", "g", "x",
                                   "ɣ", "q", "ɢ", "χ", "ʁ", "\u0127", "ʕ", "h", "ɦ", "ʔ", "ɚ"),
                       syllabic = c(rep(1, 26), rep(0, 54), 1),
                       consonantal = c(rep(0, 30), rep(1, 47), rep(0, 2), 1, 0),
                       approximant = c(rep(1, 38), rep(0, 42), 1),
                       sonorant = c(rep(1, 45), rep(0, 35), 1),
                       nasal = c(rep(0, 38), rep(1, 7), rep(0, 35), 0),
                       continuant = c(rep(1, 38), rep(0, 9), rep(1, 6), rep(0, 2), rep(1, 4), rep(0, 6),
                                      rep(1, 2), rep(0, 2), rep(1, 2), rep(0, 2), rep(1, 6), 0, 1),
                       delrel = c(rep(NA, 45), rep(0, 2), rep(1, 6), rep(0, 2), rep(1, 8),
                                  rep(0, 2), rep(1, 2), rep(0, 2), rep(1, 2), rep(0, 2),
                                  rep(1, 6), 0, NA),
                       trill = c(rep(0, 30), 1, 0, 1, rep(0, 4), 1, rep(0, 42), 0),
                       tap = c(rep(0, 33), 1, rep(0, 46), 0),
                       voice = c(rep(1, 45), rep(c(0, 1), 17), 0, 1),
                       sprgl = c(rep(0, 77), 1, 1, rep(0, 2)),
                       constrgl = c(rep(0, 79), 1, 0),
                       labial = c(rep(c(0, 1), 4), rep(c(1, 0), 8), rep(c(0, 1), 2), rep(1, 3),
                                  rep(0, 7), rep(1, 2), rep(0, 5), rep(1, 6), rep(0, 30)),
                       round = c(rep(c(0, 1), 4), rep(c(1, 0), 8), 0, 1, rep(0, 2), rep(1, 2), rep(0, 51)),
                       labiodental = c(rep(0, 27), 1, rep(0, 11), 1, rep(0, 9), rep(1, 2), rep(0, 30)),
                       coronal = c(rep(0, 31), rep(1, 5), rep(0, 4), rep(1, 3), rep(0, 8), rep(1, 16),
                                   rep(0, 13), 1),
                       anterior = c(rep(NA, 31), rep(1, 3), rep(0, 2), rep(NA, 4), 1, rep(0, 2),
                                    rep(NA, 8), rep(1, 6), rep(0, 2), rep(1, 2), rep(0, 6), rep(NA, 13), 1),
                       distributed = c(rep(NA, 31), rep(0, 3), rep(1, 2), rep(NA, 4), rep(0, 2), 1,
                                       rep(NA, 8), rep(1, 2), rep(0, 4), rep(1, 2), rep(0, 2), rep(1, 6),
                                       rep(NA, 13), 1),
                       strident = c(rep(NA, 31), rep(0, 5), rep(NA, 4), rep(0, 3), rep(NA, 8), rep(0, 4),
                                    rep(1, 8), rep(0, 4), rep(NA, 13), 0),
                       lateral = c(rep(NA, 26), rep(0, 5), 1, rep(0, 3), rep(1, 2), rep(0, 44)),
                       dorsal = c(rep(1, 27), 0, rep(1, 2), rep(0, 5), rep(1, 3), rep(0, 4), rep(1, 3),
                                  rep(0, 18), rep(1, 14), rep(0, 3), 1),
                       high = c(rep(1, 9), rep(0, 17), 1, NA, rep(1, 2), rep(NA, 5), rep(1, 2), 0,
                                rep(NA, 4), rep(1, 2), 0, rep(NA, 18), rep(1, 8), rep(0, 6), rep(NA, 3), 0),
                       low = c(rep(0, 21), rep(1, 5), 0, NA, rep(0, 2), rep(NA, 5), rep(0, 3), rep(NA, 4),
                               rep(0, 3), rep(NA, 18), rep(0, 12), rep(1, 2), rep(NA, 3), 0),
                       front = c(rep(1, 2), rep(0, 4), rep(1, 2), 0, rep(1, 2), rep(0, 4), rep(1, 2),
                                 rep(0, 4), rep(1, 2), rep(0, 3), 1, NA, 1, 0, rep(NA, 5), 1, NA, 0,
                                 rep(NA, 4), 1, NA, 0, rep(NA, 18), rep(1, 4), rep(0, 10), rep(NA, 3), 0),
                       back = c(rep(0, 4), rep(1, 2), rep(0, 2), 1, rep(0, 4), rep(1, 2), rep(0, 4),
                                rep(1, 2), rep(0, 3), rep(1, 2), 0, NA, 0, 1, rep(NA, 5), 0, NA, 1,
                                rep(NA, 4), 0, NA, 1, rep(NA, 18), rep(0, 8), rep(1, 6), rep(NA, 3), 0),
                       tense = c(rep(1, 6), rep(0, 3), rep(1, 6), rep(0, 6), rep(NA, 5), 1, NA, rep(1, 2),
                                 rep(NA, 50), 0))

# Add sonority as a column, where the sonority levels are represented by numbers from 1-6
# 1 = stops, 2 = fricatives, 3 = nasals, 4 = liquids, 5 = glides, 6 = vowels
features %>%
  mutate(sonority = ifelse(syllabic == "1", "6",
                           ifelse(syllabic == "0" &
                                    consonantal == "0" &
                                    approximant == "1" &
                                    sonorant == "1", "5",
                                  ifelse(syllabic == "0" &
                                           consonantal == "1" &
                                           approximant == "1" &
                                           sonorant == "1", "4",
                                         ifelse(nasal == "1", "3",
                                                ifelse(sonorant == "0" &
                                                         continuant == "1", "2",
                                                       ifelse(sonorant == "0" &
                                                                continuant == "0", "1", ""))))))) -> features
# Move sonority to be second column
features <- features[,c(1, 28, 2:27)]

class(features) <- c("unicode_df", "data.frame")