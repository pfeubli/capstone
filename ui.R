#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)

# Define UI for application that draws a histogram
shinyUI(fluidPage(theme = shinytheme("flatly"),
                  
                  # Application title
                  titlePanel("Next Word Prediction"),
                  h5("This app predicts the next word. Enter your text and let the app suggest the next word."),
                  textInput("text", label = h3("Enter your text here:"), value = "Enter text..."),
                  submitButton("Go"),
                  
                  hr(),
                  h5("Next word suggestion:"),
                  fluidRow(column(3, verbatimTextOutput("prediction")))
))
