#install.packages(c("conjoint","DT","shinyjs","shiny","devtools","dplyr","digest","likert","ggplot2"))

#install.packages("modeest")
#install.packages(c("reshape","RcolorBrewer","ggthemes","stringr"))
#install.packages("dplyr")


library(modeest)
library(conjoint)
library(DT)
library(shinyjs)
library(shiny)
library(devtools)
library(dplyr)
library(digest)
library(likert)
library(ggplot2)

library(reshape2)
library(RColorBrewer)
library(ggthemes)
library(stringr)

source("choiceDataTable.R")
source("likertQuestions.R")


NUM_PAGES <- 5

likert_questions <- paste("Question", 1:19)

likert_choices <- c("Strongly Disagree", "Disagree", "Neutral", "Agree", "Strongly Agree")

levelanx_choices<-c("Not anxious","Slightly Anxious","Fairly Anxious","Very Anxious", "Extremely Anxious")

fieldsMandatory <- c("var1", "id", "radio")

labelMandatory <- function(label) {
  tagList(
    label,
    span("*", class = "mandatory_star")
  )
}

appCSS <-
  ".mandatory_star { color: red; }"

fieldsAll <- c("var1", "id", "block1")
responsesDir <- file.path("responses")
epochTime <- function() {
  as.integer(Sys.time())
}

responses_file_path <- file.path("responses", list.files("responses"))
list_responses <- lapply(responses_file_path, read.csv)
responses_df <- do.call(what = rbind, args = list_responses)
dat.frame<-as.data.frame(responses_df)
dat.frame


