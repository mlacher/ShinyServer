
library(shiny)
library(LTSerial)
library(serial)
library(ggplot2)

Device<-Open_Serial("COM31")

shinyServer(function(input, output, session) {

  st <- reactiveValues(flag = 0,
                       Breath  = 0)

  observeEvent(input$start,{st$flag<-1
  st$ExhTime<- input$slider2
  st$InhTime<-input$slider1
  st$TotTime<-st$ExhTime+st$InhTime})
  observeEvent(input$pause,{st$flag<-0})
  observeEvent(input$stop,{st$Breath<-0
                             st$flag<-0})

  observe({
    if(st$flag==1){
      invalidateLater(st$TotTime*1000)
    isolate({

      InhTimec<- as.character( (st$InhTime*10)+255+1)
      RWout1<-RW_Serial(Device,InhTimec)
      print(st$TotTime)
      RWout2<-RW_Serial(Device,'517')
      Rout <- R_Serial(Device, (st$TotTime))
      print(ceiling(st$InhTime))
      st$Data <- Meas_Data(Rout)
      st$Data1 <- cbind(st$Data1,st$Data$RotSpeed)
      st$Breath<-st$Breath+1})}
  })

  output$value3 <- renderPrint({ st$Breath})
  #output$plot <- renderPlot({plot(st$Data$Time, st$Data$RotSpeed)})
  output$plot <- renderPlot({qplot(st$Data,  Time,  RotSpeed)
})
  output$summary <- renderPrint({summary(st$Data)})
  output$table <- renderTable({
    st$Data1})

})


