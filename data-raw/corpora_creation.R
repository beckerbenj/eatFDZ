# current hotfixes
# --------------------------------------
english_words <- read.table("C:/Users/beckerbz/Desktop/words.txt")[[1]]
usethis::use_data(english_words, overwrite = TRUE)

german_words_ori <- read.table("C:/Users/beckerbz/Desktop/words_german.txt", encoding = "UTF-8")[[1]]
german_words <- german_words_ori[-c(151400, 151401)]
usethis::use_data(german_words, overwrite = TRUE)


usethis::use_data(english_words, german_words, overwrite = TRUE, internal = TRUE)



# tbd
# --------------------------------------
## download coprora programmatically

library(RCurl)
x <- getURL("https://github.com/dwyl/english-words/blob/master/words_alpha.txt")
y <- read.table(text = x)

test <- read.table(url("https://github.com/dwyl/english-words/blob/master/words_alpha.txt"))
str(test)




# --------------------------------------
# https://github.com/davidak/wortliste
readr::guess_encoding("C:/Users/beckerbz/Desktop/words_german.txt", n_max = -1, threshold = 0.1)

german_words <- read.table("C:/Users/beckerbz/Desktop/words_german.txt", encoding = "UTF-8", fileEncoding = "UTF-8")[[1]]

#german_words <- read.table("C:/Users/beckerbz/Desktop/words_german.txt", encoding = "windows-1252")[[1]]
german_words <- read.table("C:/Users/beckerbz/Desktop/words_german.txt", encoding = "ASCII")[[1]]
german_words <- eatGADS::fixEncoding(german_words, input = "ASCII")

str(german_words)


# ----------
german_words[206000]
german_words[10891]
german_words[151400]



grep("xc3", german_words, value = TRUE)
grep("\U00E0", german_words, value = TRUE)
grep("\U00E1", german_words, value = TRUE)
grep("^Piet", german_words, value = TRUE)
grep("^Piet", german_words)

## german is challenging (Konjugationen, Umlaute, ...)
# try fixencoding! (use preemptively on corpus?)

# https://german.stackexchange.com/questions/25114/suche-eine-umfassende-datenbank-aller-deutschen-w%C3%B6rter

# downloaded OpenOffice dictionary, but only explanations on declinations etc. (https://github.com/tatuylonen/wiktextract)
# try wiki: https://kaikki.org/dictionary/German/ (but only slightly more words than currently)
# https://kaikki.org/dictionary/rawdata.html

"\U00E0"
"\U00E1"
