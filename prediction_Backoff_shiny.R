suppressMessages(library(Rcpp))
suppressMessages(library(plyr)) #
suppressMessages(library(dplyr)) ##
suppressMessages(library(data.table)) #
suppressMessages(library(openxlsx))
suppressMessages(library(devtools))
suppressMessages(library(tidyr))
suppressMessages(library(descr))
suppressMessages(library(zoo))
suppressMessages(library(stats))
suppressMessages(library(xlsx))
suppressMessages(library(ggplot2))
suppressMessages(library(gridExtra))
suppressMessages(library(grid))

library(tm)
library(rJava)
library(RWeka)
library(qdap)
library(ANLP)

unigram <- readRDS("unigram.RDS")
bigram <- readRDS("bigram.RDS")
trigram <- readRDS("trigram.RDS")
quadrigram <- readRDS("quadrigram.RDS")

modelsList <- list(unigram, bigram, trigram, quadrigram)

prediction_Backoff_shiny <- function(testline,modelsList){
        maxNGramIndex <- length(modelsList)
        line <- iconv(testline,"latin1","ASCII",sub="")
        line <- line %>% replace_abbreviation %>% replace_contraction %>% removeNumbers %>%  removePunctuation %>% tolower  %>% stripWhitespace
        words <- unlist(strsplit(line, split=" "));
        len <- length(words);
        if(len < maxNGramIndex){
                nGramIndex = len
        }else{
                nGramIndex = maxNGramIndex - 1
        }
        List = list()
        List2 = list()
        for(model in modelsList){
                pattern <- paste0("^",paste(words[(len - nGramIndex + 1):len], collapse = " "),collapse = " ")
                model <- modelsList[[(length(words[(len - nGramIndex + 1):len])+1)]]
                nextwords <- model[grep(pattern,model$word)[1],1:2]
                if(nrow(nextwords) > 0){
                        nextwords$model <- length(words[(len - nGramIndex + 1):len])+1
                        List[[(length(words[(len - nGramIndex + 1):len])+1)]] = nextwords
                        List2[[(length(words[(len - nGramIndex + 1):len])+1)]] <- modelsList[[length(words[(len - nGramIndex + 1):len])]][1:nrow(nextwords),2]
                }
                nGramIndex = nGramIndex - 1
        }
        results <- rbind.fill(List)
        results$score <- results$freq/unlist(List2)
        results <- results[order(-results$score),]
        results <- results[(!is.na(results$freq)),]
        if(length(results) > 0){
                suggestion <- unlist(strsplit(results$word[1]," "))
                suggestion <- suggestion[length(suggestion)]
        } else {
                suggestion <- unigram$word[1]
        }
        return(suggestion)
}
