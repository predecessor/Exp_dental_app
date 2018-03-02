ui <- fluidPage(
  useShinyjs(),
  hidden(
    list(
      div(class = "page",
          id = paste0("step", 1),
          sidebarLayout(
            sidebarPanel(
              sliderInput("var1", labelMandatory("how many times are you brushing your teeth every month?"),
                          0, 60, 2, ticks = FALSE),
              textInput("id", "How often do you use flossing per month", ""),
              # Make a list of checkboxes
              radioButtons("radio", label = h3("Radio buttons"),
                           choices = list("Choice 1" = 1, "Choice 2" = 2))
            ),
            mainPanel(plotOutput("distPlot"), textOutput("message"))
          )
      ),
      div(class = "page",
          id = paste0("step", 2),
          choiceDataTableUI("one"),
          choiceDataTableUI("two"),
          choiceDataTableUI("three"),
          choiceDataTableUI("four")
      ),
      div(class = "page",
          id = paste0("step", 3),
          choiceDataTableUI("five"),
          choiceDataTableUI("six"),
          choiceDataTableUI("seven"),
          choiceDataTableUI("eight")
      ),
      div(class = "page",
          id = paste0("step", 4),
          fluidPage(
            column(12, align = "center",
                   div(
                     id = "likert_input",
                     likertQuestionsInput("likert", questions = c("I believe that there is likelihood to get tooth decay",
                                                                  "I believe that there is possibility of getting gum disease",
                                                                  "I believe that my teeth condition is good", "I am too busy to visit a dentist",
                                                                  "I do not think that the money spent on dental care are worth",
                                                                  "I think that dental visit costs are too high","I believe that tooth decay is a serious problem",
                                                                  "I believe in adverse effect of dental problems on my health",
                                                                  "I believe in the effectiveness of dental visits to prevent tooth decay","I believe that getting sick is a matter of luck",
                                                                  "I believe myself as being healthier than the average person",
                                                                  "I believe that taking care of myself can avoid illness","I am able to find the energy to manage your dental or oral health",
                                                                  "I am able to fill in dental forms e.g. enrolment forms",
                                                                  "I am able to take a friend or family with you in the dental office",
                                                                  "I am able to pay to visit a dentist", "I am confident that I can brush all my teeth and not just the front, visible ones",
                                                                  "I am confident that I can apply flossing properly",
                                                                  "I am confident that I can brush my teeth more than twice a day, if I think that there is a good reason for doing so (eg, I have eaten sweets)"), choices = likert_choices,
                                          selected = "Neutral")
                    
                   )))),
      div(class = "page",
                       id = paste0("step", 5),
                       fluidPage(
                         column(12, align = "center",
                                div(
                                  id = "levelanx_input",
                                  likertQuestionsInput("levelanx", questions=c("If you went to your dentist for treatment tomorrow, how would you feel?",
                                                                               "If you were sitting in the waiting room (waiting for treatment), how would you feel?",
                                                                               "If you were about to have a tooth drilled, how would you feel?",
                                                                               "If you were about to have your teeth scaled and polished, how would you feel?"),
                                                       choices=levelanx_choices, selected="Fairly Anxious"),
                                  
                                  actionButton("submit", "Submit", class = "btn-primary")
                                  ),
                   shinyjs::hidden(
                     div(
                       id = "thankyou_msg",
                       h3("Thanks, your response was submitted successfully!"),
                       plotOutput("likert_plot")
                     )
                   )
            )
          )
      )
    )
),
  br(),
  column(12, align = "center",
         actionButton("prevBtn", "< Previous"),
         actionButton("nextBtn", "Next >")
  )
 )


