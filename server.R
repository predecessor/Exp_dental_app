experiment <- expand.grid(
  price = c("low","medium","high"),
  variety = c("black","green","red"),
  kind = c("bags","granulated","leafy"),
  aroma = c("yes","no")
)

design <- caFactorialDesign(data = experiment,type="orthogonal")

d <- as.data.frame(t(as.data.frame(design)))

# d$Attributes <- rownames(d)
# 
# d1 <- d[, c("4", "9")]
# names(d1) <- c("Alternative 1", "Alternative 2")
# 
# d2 <- d[, c("4", "10")]
# names(d2) <- c("Alternative 1", "Alternative 2")
# d3 <- d[, c("4", "17")]
# names(d3) <- c("Alternative 1", "Alternative 2")
# d4 <- d[, c("4", "21")]
# names(d4) <- c("Alternative 1", "Alternative 2")
# 
# d5 <- d[, c("4", "23")]
# names(d5) <- c("Alternative 1", "Alternative 2")
# d6 <- d[, c("4", "29")]
# names(d6) <- c("Alternative 1", "Alternative 2")
# d7 <- d[, c("4", "42")]
# names(d7) <- c("Alternative 1", "Alternative 2")
# d8 <- d[, c("4", "52")]
# names(d8) <- c("Alternative 1", "Alternative 2")

create_alternatives <- function(d, static, names_out = c("Alternative 1", "Alternative 2")) {
  cols <- names(d)[names(d) != static]
  lapply(cols, function(x) {
    dat <- d[, c(static, x)]
    names(dat) <- names_out
    dat
  })
}

assign_block <- function(d, n) {
  #r <- runif(1)
  #if(r > 0.5) {
  if(n %% 2 == 0) {
    return(create_alternatives(d, "4"))
  } else {
    return(create_alternatives(d, "52", c("Alternative 3", "Alternative 4")))
  }
}

print(runif(1))

#alts <- assign_block(d)
n <- nrow(dat.frame)

alts <- assign_block(d, n)

server <- function(input, output, session) {
  
  
  observe(print(alts))
  
  rv <- reactiveValues(page = 1)
  
  observe({
    toggleState(id = "prevBtn", condition = rv$page > 1)
    toggleState(id = "nextBtn", condition = rv$page < NUM_PAGES)
    hide(selector = ".page")
    show(sprintf("step%s", rv$page))
  })
  
  observe({
    if(rv$page == 2) {
      if(length(a1()) == 0 || length(a2()) == 0 || length(a3()) == 0 || length(a4()) == 0) {
        disable(id = "nextBtn")
        return()
      } else if(a1() == "None" || a2() == "None" || a3() == "None" || a4() == "None") {
        disable(id = "nextBtn")
      } else {
        enable(id = "nextBtn")
      }
    }
  })
  
  observe({
    if(rv$page == 3) {
      if(length(a5()) == 0 || length(a6()) == 0 || length(a7()) == 0 || length(a8()) == 0) {
        disable(id = "nextBtn")
        return()
      } else if(a5() == "None" || a6() == "None" || a7() == "None" || a8() == "None") {
        disable(id = "nextBtn")
      } else {
        enable(id = "nextBtn")
      }
    }
  })
  
  navPage <- function(direction) {
    rv$page <- rv$page + direction
  }
  
  observeEvent(input$prevBtn, navPage(-1))
  observeEvent(input$nextBtn, navPage(1))
  
  output$distPlot <- renderPlot({
    ggplot(dat.frame, aes(responses_df$var1)) +
      geom_density(adjust = 1/2) +
      geom_vline(xintercept = input$var1) +
      theme_minimal()
    
  })
  output$message <- renderPrint({
    if (input$var1 < 30) {
      print("You belong to the 50 percent LEAST preventive people")
    }
    else {
      print("You belong to the 50 percent MOST preventive people")
    }
  })
  
  observe({
    # check if all mandatory fields have a value
    mandatoryFilled <-
      vapply(fieldsMandatory,
             function(x) {
               !is.null(input[[x]]) && input[[x]] != ""
             },
             logical(1))
    mandatoryFilled <- all(mandatoryFilled)
    # enable/disable the submit button
    shinyjs::toggleState(id = "submit", condition = mandatoryFilled)
  })
  
  formData <- reactive({
    data <- sapply(fieldsAll, function(x) input[[x]])
    data <- c(data, choice1 = a1(), choice2 = a2(), choice3 = a3(),
              choice4 = a4(), choice5 = a5(), choice6 = a6(),
              choice7 = a7(), choice8 = a8(), likerts(),levelanxes())
    data <- c(data, timestamp = epochTime())
    data <- t(data)
    data
  })
  
  
  saveData <- function(data) {
    fileName <- sprintf("%s_%s.csv",
                        epochTime(),
                        digest::digest(data))
    
    write.csv(
      x = data,
      file = file.path(responsesDir, fileName),
      row.names = FALSE,
      quote = TRUE
    )
  }
  
  observeEvent(input$submit, {
    saveData(formData())
    shinyjs::hide("levelanx_input")
    shinyjs::show("thankyou_msg")
    shinyjs::hide("pager")
  })
  
  # 
  # a1 <- callModule(choiceDataTable, "one", d1)
  # a2 <- callModule(choiceDataTable, "two", d2)
  # a3 <- callModule(choiceDataTable, "three", d3)
  # a4 <- callModule(choiceDataTable, "four", d4)
  # 
  # a5 <- callModule(choiceDataTable, "five", d5)
  # a6 <- callModule(choiceDataTable, "six", d6)
  # a7 <- callModule(choiceDataTable, "seven", d7)
  # a8 <- callModule(choiceDataTable, "eight", d8)
  # 
  a1 <- callModule(choiceDataTable, "one", alts[[1]])
  a2 <- callModule(choiceDataTable, "two", alts[[2]])
  a3 <- callModule(choiceDataTable, "three", alts[[3]])
  a4 <- callModule(choiceDataTable, "four", alts[[4]])
  
  a5 <- callModule(choiceDataTable, "five", alts[[5]])
  a6 <- callModule(choiceDataTable, "six", alts[[6]])
  a7 <- callModule(choiceDataTable, "seven", alts[[7]])
  a8 <- callModule(choiceDataTable, "eight", alts[[8]])
  

  likerts <- callModule(likertQuestions, "likert")
  #levelanxes <- callModule(levelanxQuestions,"levelanx")
  levelanxes <- callModule(likertQuestions,"levelanx")
  
  output$likert_plot <- renderPlot({
    likert_frame <- dat.frame[, grepl("likert", names(dat.frame))]
    likert_frame[,] <- lapply(likert_frame, function(x) factor(x, levels = likert_choices))
    names(likert_frame) <- likert_questions
    
    likert_summ <- likert(likert_frame)
    plot(likert_summ, group.order = likert_questions)
  })
    
  }