# This script defines miscellaneous functions used by the syllable parser.

# Define functions w/ the same functionality as LEFT and RIGHT in Excel
right = function(text, n_char) {
  substr(text, nchar(text) - n_char + 1, nchar(text))
}
left = function(text, n_char) {
  substr(text, 1, n_char)
}

# Modify default print rule
# NOTE: REQUIRES CHANGING THE CLASS OF ANY DF W/ UNICODE IN IT. FOR EXAMPLE:
#       class(d) <- c("unicode_df", "data.frame") 

# this is print.default from base R with only two lines modified, see #old# 
print.unicode_df <- function (x, ..., digits = NULL, quote = FALSE, right = TRUE, row.names = TRUE) {
  n <- length(row.names(x)) 
  if (length(x) == 0L) { 
    cat(sprintf(ngettext(n, "data frame with 0 columns and %d row", 
                         "data frame with 0 columns and %d rows",
                         domain = "R-base"), 
                n),
        "\n",
        sep = "") 
  }
  else if (n == 0L) { 
    print.default(names(x),
                  quote = FALSE) 
    cat(gettext("<0 rows> (or 0-length row.names)\n")) 
  } 
  else { 
    #old# m <- as.matrix(format.data.frame(x, digits = digits, 
    #old#     na.encode = FALSE)) 
    m <- as.matrix(x) 
    if (!isTRUE(row.names)) 
      dimnames(m)[[1L]] <- if (identical(row.names, FALSE)) 
        rep.int("", n) 
    else row.names 
    print(m, ..., quote = quote, right = right) 
  } 
  invisible(x) 
}

# Define special source function for sourcing files w/ unicode chars in Windows
source.utf8 <- function(f) {
  l <- readLines(f, encoding="UTF-8")
  eval(parse(text=l),envir=.GlobalEnv)
}

# Define transcription lookup function (transcribe())
transcribe <- function(text) {
  subset(cmudict, word == text, select = transcription)[1,1] -> transcribed
  return(transcribed)
}

# Random word function
random_word <- function(){
  cmudictipa[sample(1:nrow(cmudictipa), 1),"word"] -> rw
  return(rw)
}