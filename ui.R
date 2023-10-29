ui <- fluidPage(
  # Application title
  titlePanel("DT Editor Minimal Example"),
  shinyjs::useShinyjs(),
  
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
  ),
  
  helpText("Note: Remember to save any updates!"),
  br(),
  DTUI("mainTable"),
  shiny::br()
)