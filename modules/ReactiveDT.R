DTUI <- function(id) {
  ns <- NS(id)
  tagList(
    ### tags$head() is to customize the download button
    tags$head(tags$style(".butt{background-color:#230682;} .butt{color: #e6ebef;}")),
    downloadButton(
      outputId = ns("downloadDataCSV"),
      label = "Download in CSV",
      class="butt"
    ),
    downloadButton(
      outputId = ns("downloadDataXLSX"),
      label = "Download in XLSX",
      class="butt"
    ),
    actionButton(
      inputId = ns("updateTable"),
      label = "Save",
      icon = icon(name = "floppy-disk", class = "fa-regular fa-floppy-disk")
    ),
    shinycssloaders::withSpinner(DTOutput(ns("mainTable"))),
    actionButton(
      inputId = ns("insertRow"),
      label = "Insert Row",
      icon = icon(name = "plus", class = "fa-solid fa-plus")
    ),
    actionButton(
      inputId = ns("deleteRow"),
      label = "Delete Row",
      icon = icon(name = "minus", class = "fa-solid fa-minus")
    ),
    textOutput(outputId = ns("tableInfo"))
  )
}

DTServer <- function(id, dt) {
  moduleServer(
    id,
    function(input, output, session) {
      
      observeEvent(input$insertRow, {
        t = dt()
        t[nrow(t)+1, ]<-NA
        dt(t)
      })
      
      observeEvent(input$deleteRow, {
        t = dt()
        if (!is.null(input$mainTable_rows_selected)) {
          t <- t[-as.numeric(input$mainTable_rows_selected),]
        }
        dt(t)
      })
      
      observeEvent(input$mainTable_cell_edit, {
        t = dt()
        t[input$mainTable_cell_edit$row, (input$mainTable_cell_edit$col+1)] <- input$mainTable_cell_edit$value
        dt(t)
      })
      
      ### save to RDS part 
      observeEvent(input$updateTable,{
        saveRDS(dt(), "data/note.rds")
        shinyalert(title = "Saved!", type = "success")
      })
      
      ## render DT
      output$mainTable <- renderDT({
        datatable(
          data = dt(),
          selection = 'single',
          options = list(
            dom = 't',
            columnDefs = list(
              list(className = "dt-center", targets = 1:(ncol(dt())-1))
            )
          ),
          rownames= FALSE,
          editable = TRUE
        )%>%
          formatStyle(1:ncol(dt()), `font-family` = "Interstate Black") %>% 
          formatStyle(1:ncol(dt()), fontWeight = "normal")
      })
      
      ### download the table in csv
      output$downloadDataCSV<- downloadHandler(
        filename = function() {
          paste("data", Sys.Date(), ".csv", sep="")
        },
        content = function(file) {
          write.csv(
            dt(),
            file,
            row.names = F
          )
        }
      )
      
      ## download the table in xlsx
      output$downloadDataXLSX<-downloadHandler(
        filename = function(){
          paste("data", Sys.Date(), ".xlsx", sep="")
        },
        content = function(file) {
          # Content to be available for user to download
          wb <- createWorkbook()
          addWorksheet(wb, sheetName = "Data")
          writeData(wb, sheet = 1, x = dt(), startCol = 1, startRow = 1)
          saveWorkbook(wb, file = file, overwrite = TRUE)
        }
      )
      
      ## Print table info
      output$tableInfo<-renderText({
        glue::glue("Table has {nrow(dt())} rows and {ncol(dt())} columns.")
      })
    }
  )
}