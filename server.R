#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
suppressMessages(library(ANLP))

suppressMessages(library(Rcpp))
suppressMessages(library(plyr))
suppressMessages(library(dplyr))

source("./prediction_Backoff_shiny.R", local = TRUE)

unigram <- readRDS("./unigram.RDS")
bigram <- readRDS("./bigram.RDS")
trigram <- readRDS("./trigram.RDS")
quadrigram <- readRDS("./quadrigram.RDS")

modelsList <-  list(unigram, bigram, trigram, quadrigram)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
        wordprediction <- reactive({
                testString <- input$text
                wordprediction <- prediction_Backoff_shiny(testString,modelsList)
        })
        output$prediction <- renderPrint(wordprediction())
})