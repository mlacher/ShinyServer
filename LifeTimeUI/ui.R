#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

  # Application title
  #titlePanel("Old Faithful Geyser Data"),
  sidebarLayout(

    # Sidebar panel for inputs ----
    sidebarPanel(

           actionButton("start", label = "Start", width = '30%'),
           actionButton("pause", label = "Pause", width = '30%'),
           actionButton("stop", label = "Stop", width = '30%'),
           h3("Breaths"),
           verbatimTextOutput("value3"),
           # Copy the line below to make a slider bar
           sliderInput("slider1", label = h4("Inh. Time"), min = 0.1,
                       max = 10, value = 0.1),

           # Copy the line below to make a slider bar
           sliderInput("slider2", label = h4("Exh. Time"), min = 1,
                       max = 10, value = 3))

    ,
  mainPanel(
    tabsetPanel(type = "tabs",
                tabPanel("Current Breath", plotOutput("plot")),
                tabPanel("Summary", verbatimTextOutput("summary")),
                tabPanel("Table", tableOutput("table"))
    )

  )

  )
))
