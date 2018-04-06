#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(LTSerial)
library(car)


Device<-Open_Serial("COM31")

RWout<-RW_Serial(Device,'276')
if (RWout == 20)
{
  abc = 0
}else{
  abc = NA
}

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  st <- reactiveValues(flag = 0, Breath  = 0)
  observeEvent(input$start, {
       st$flag <- 1
 })

  observeEvent(input$stop, {
      st$flag <- 0
  })

  observeEvent(st$flag,{
    if(st$flag==1){
      print(st$flag)
      InhTime<-input$slider1*10
      InhTimec<- as.character(InhTime+255+1)
      print(InhTimec)
      RWout<-RW_Serial(Device,'517')
      Rout <- R_Serial(Device)
      st$Data <- Meas_Data(Rout)
      st$Breath<-st$Breath+1
      st$Wait<- 1
      st$flag <-0
     }
  })



    output$value3 <- renderPrint({ st$Breath})
    output$plot <- renderPlot({plot(st$Data$Time, st$Data$RotSpeed )})
    output$summary <- renderPrint({summary(st$Data)})
    output$table <- renderTable({data
      st$Wait<- 0
      st$flag<-1})



})
