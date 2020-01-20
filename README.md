*This README is under construction*

# Syllable parser (R implementation)

This set of scripts defines several functions (the foremost of which is `syllabify()`) that together can syllabify a phonetic transcription using principles taught to students in Phonology 1. Some of the provided functions (namely, `transcribe()`) interface with a local copy of the Carnegie Mellon University (CMU) Pronouncing Dictionary, which provides phonetic transcriptions (using ARPABET sequences) for over 134,000 words in the English lexicon. Scripts are also provided that check the dictionary for updates, download the most recent version from the dictionary's website, and format it, including converting ARPABET codes to International Phonetic Alphabet (IPA) characters.

The parser basically uses a strategy taught to undergraduate students of Phonology when they are learning how to determine the syllabification of a word:

1. **Identify syllable nuclei** by looking for the vowels. If there are two adjacent vowels, check if those vowels together are a known diphthong in the language. If they are, consider them part of the same syllable nucleus. Standalone vowels each count as the nucleus of their own syllable.
2. **Identify syllable onsets** (this occurs before step 3 in accordance with the Onset Principle). Automatically parse consonants preceding the first vowel into the first syllable. Parse a consonant immediately preceding any of the other vowels into the syllable of that vowel. If any remaining unparsed consonants are not after the last vowel in the word and have a consonant following them, check if that consonant and the following are a legal onset in the language (defined as a consonant cluster that can occur at the beginning of a word, as long as that word is not a borrowing). If they're a legal onset, parse that consonant into the syllable of the consonant following it. If they're not a legal onset, leave that consonant unparsed.
3. **Identify syllable codas** by parsing any remaining unparsed consonants into the syllables preceding them.

## Getting started

### Prerequisites
1. [R programming language environment](https://www.r-project.org/about.html)
2. The following R packages:
   * [dplyr](https://cran.r-project.org/web/packages/dplyr/index.html)
   * [magrittr](https://cran.r-project.org/web/packages/magrittr/index.html)
   * [RCurl](https://cran.r-project.org/web/packages/RCurl/index.html)
   * [readr](https://cran.r-project.org/web/packages/readr/index.html)
   * [tidyr](https://cran.r-project.org/web/packages/tidyr/index.html)
   * [stringr](https://cran.r-project.org/web/packages/stringr/index.html)
3. Optional packages:
   * [pbapply](https://cran.rstudio.com/web/packages/pbapply/index.html) (Required for progress bars to work in the dictionary formatter)

### Installing
