server <- function(input, output) {
  
  dt<-reactiveVal(readRDS("data/note.rds"))
  
  DTServer("mainTable", dt)
  
}