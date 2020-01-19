*This README is under construction*

# Syllable parser (R implementation)

This set of scripts defines several functions (the foremost of which is `syllabify()`) that together can syllabify a phonetic transcription using principles taught to students in Phonology 1. Some of the provided functions (namely, `transcribe()`) interface with a local copy of the Carnegie Mellon University (CMU) Pronouncing Dictionary, which provides phonetic transcriptions (using ARPABET sequences) for over 134,000 words in the English lexicon. Scripts are also provided that check the dictionary for updates, download the most recent version from the dictionary's website, and format it, including converting ARPABET codes to International Phonetic Alphabet (IPA) characters.

The parser uses a particular strategy taught to undergraduate students of Phonology when they are learning how to determine the syllabification of a word.

## Getting started

### Prerequisites
1. [R programming language environment](https://www.r-project.org/about.html)
2. The following R packages:
    a. [dplyr](https://cran.r-project.org/web/packages/dplyr/index.html)
    b. [magrittr](https://cran.r-project.org/web/packages/magrittr/index.html)
    c. [RCurl](https://cran.r-project.org/web/packages/RCurl/index.html)
    d. [readr](https://cran.r-project.org/web/packages/readr/index.html)
    e. [tidyr](https://cran.r-project.org/web/packages/tidyr/index.html)
    f. [stringr](https://cran.r-project.org/web/packages/stringr/index.html)
3. Optional packages:
    a. [pbapply](https://cran.rstudio.com/web/packages/pbapply/index.html) (Required for progress bars to work in the dictionary formatter)

### Installing
