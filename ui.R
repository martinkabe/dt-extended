ui <- fluidPage(
  # Application title
  titlePanel("Extended DT"),
  shinyjs::useShinyjs(),
  
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
  ),
  
  helpText("Note: Please remember to save before closing the session."),
  br(),
  DTUI("mainTable"),
  shiny::br()
)