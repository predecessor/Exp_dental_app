likertQuestionsInput <- function(id, questions,
                                 choices = c("Strongly Disagree", "Disagree", "Neutral", "Agree", "Strongly Agree"),
                                 ...) {
  ns <- NS(id)
  
  
  lapply(seq_along(questions), function(i) {
    question <- questions[i]
    radioButtons(ns(paste0("likert", i)), question, choices, inline = TRUE, ...)
  })
  
}

likertQuestions <- function(input, output, session) {
  
  likert_inputs <- isolate(names(reactiveValuesToList(input)))
  
  observe(print(likert_inputs))
  
  likerts <- reactive({
    vapply(
      likert_inputs,
      function(x) {
        out <- input[[x]]
        if(length(out) == 0) return("")
        out
      },
      character(1)
    )
  })
  
  return(likerts)
}

