library(shiny)
library(shinydashboard)
library(tidyverse)
library(ggplot2)
library(DT)
library(readr)

shinyServer(function(input, output, session) {
  
  Baseball <- read_csv("./data/BaseballTeams.csv")
  
  observeEvent(input$team, {
    updateSelectInput(session, "team", choices=c("All Teams", unique(Baseball$franchID)), selected="All Teams")
  },
  once=TRUE)
  
  output$plot <- renderPlot({
    if(input$team == "All Teams")p <- ggplot(data=Baseball %>% filter(yearID >= input$year[1], 
                               yearID <= input$year[2]),
          aes(x=.data[[input$xvar]],y=.data[[input$yvar]])) + geom_point()
    
    if(input$team != "All Teams")p <- ggplot(data=Baseball %>% filter(franchID == input$team) %>% 
                                                filter(yearID >= input$year[1], 
                                                       yearID <= input$year[2]), 
                                               aes(x=.data[[input$xvar]],y=.data[[input$yvar]])) + 
        geom_point(size=4) 
    
    if(input$lines == 1) p <- p + geom_smooth(se=FALSE) 
    
    if(input$lines == 2) p <- p + geom_smooth(method="lm", se=FALSE)

    return(p)
  })
  
  output$data <- renderDT({
    df <- Baseball
    updateSelectInput(session,"xvar",choices=colnames(df))
    updateSelectInput(session,"yvar", choices=colnames(df), selected="ERA")
    return(df)
  })
  
})
