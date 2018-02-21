choiceDataTableUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    DT::dataTableOutput(ns("dt")),
    radioButtons(ns("r"), "Choose One",
                 c("Alternative 1", "Alternative 2", "None"),
                 selected = "None")
  )
}

choiceDataTable <- function(input, output, session, data) {
  ns <- session$ns
  
  output$dt <- renderDataTable(
    datatable(data, rownames = TRUE,
              selection = list(mode = "single", target = "column"),
              options = list(dom = "t"))
  )
  
  proxy = dataTableProxy(ns("dt"))
  
  observeEvent(input$r, {
    a <- input$r
    if(a == "Alternative 1") {
      proxy %>% selectColumns(1)
    }
    if(a == "Alternative 2") {
      proxy %>% selectColumns(2)
    }
    if(a == "None") {
      proxy %>% selectColumns(NULL)
    }
  })
  
  
  observeEvent(input$dt_columns_selected, {
    r <- input$dt_columns_selected
    s <- if(r == 1) {
      "Alternative 1"
    } else if (r == 2) {
      "Alternative 2"
    } else {
      "None"
    }
    
    updateRadioButtons(session, "r", 
                       selected = s)
  })
  
  selected <- reactive({
    data[, input$dt_columns_selected + 1]
  })
  
  return(reactive(input$dt_columns_selected + 1))
}