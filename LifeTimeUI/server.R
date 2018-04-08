

# This is the server logic of a Shiny web application. You can run the

# application by clicking 'Run App' above.

#

# Find out more about building applications with Shiny here:

#

#    http://shiny.rstudio.com


library(shiny)
stpt <- Sys.time()+200
# Define server logic required to draw a histogram

shinyServer(function(input, output, session) {
  
  st <- reactiveValues(flag = 0, 
                       Breath  = 0)
  
  observeEvent(input$start,{st$flag<-1})
  
  observeEvent(input$pause,{st$flag<-0})

  observeEvent(input$stop,{st$Breath<-0 
                             st$flag<-0})
 
  
  observe({
    if(st$flag==1){
      invalidateLater(input$slider2*1000)}
    print(input$slider2)
    isolate({
      st$Data <- mtcars
      st$Breath<-st$Breath+1})
  })
  
  output$value3 <- renderPrint({ st$Breath})
  output$plot <- renderPlot({plot(st$Data$mpg[1:st$Breath], st$Data$cyl[1:st$Breath])})
  output$summary <- renderPrint({summary(st$Data)})
  output$table <- renderTable({data})

})