library(shiny)
library(shinydashboard)
library(tidyverse)
library(ggplot2)
library(DT)
library(readr)

shinyServer(function(input, output, session) {
  
  Baseball <- read_csv("./data/BaseballTeams.csv")
  
  observeEvent(input$team, {
    updateSelectInput(session, "team", choices=c("All Teams", unique(Baseball$Team)), selected="All Teams")
  },
  once=TRUE)
  
  output$data <- renderDT({
    df <- Baseball
    updateSelectInput(session,"xvar",choices=colnames(df))
    updateSelectInput(session,"yvar", choices=colnames(df),selected="EarnedRunAverage")
    return(df)
  })
  
  output$plot <- renderPlot({
    if(input$team == "All Teams") ({ p <- ggplot(data=Baseball %>% filter(Season >= input$year[1], 
                               Season <= input$year[2]),
          aes(x=.data[[input$xvar]],y=.data[[input$yvar]])) + geom_point(alpha=.4) + theme_minimal()
    
    if(input$lines == 1 ) p <- p + geom_smooth(se=FALSE, color="red")
    
    if(input$lines == 2)  p <- p + geom_smooth(method="lm", se=FALSE, color="red")
    
    })
    
    else ({ p <- ggplot(data=Baseball %>% filter(Team == input$team) %>% 
                                                filter(Season >= input$year[1], 
                                                       Season <= input$year[2]), 
                                               aes(x=.data[[input$xvar]],y=.data[[input$yvar]])) + 
        geom_point(size=4, aes(color=Team)) + theme_minimal()
    
      if(input$lines == 1) p <- p + geom_smooth(se=FALSE)  + facet_wrap(vars(Team))
    
      if(input$lines == 2) p <- p + geom_smooth(method="lm", se=FALSE) + facet_wrap(vars(Team))
      
    })

    return(p)
  })
  
  output$histx <- renderPlot ({
    if(input$team == "All Teams") 
       p <- ggplot(data=Baseball %>% filter(Season >= input$year[1], 
                                              Season <= input$year[2]),
                                                aes(x=.data[[input$xvar]])) + 
        geom_histogram() + theme_classic() + theme(axis.title.y=element_blank(),
                                                   axis.ticks.y=element_blank(),
                                                   axis.text.y=element_blank())
    
    else p <- ggplot(data=Baseball %>% filter(Team == input$team) %>% 
                          filter(Season >= input$year[1], 
                                 Season <= input$year[2]), 
                        aes(x=.data[[input$xvar]])) + 
      geom_histogram() + theme_classic() + theme(axis.title.y=element_blank(),
                                                 axis.ticks.y=element_blank(),
                                                 axis.text.y=element_blank())
    
    return(p)
  })
  
  output$histy <- renderPlot ({
    if(input$team == "All Teams") 
      p <- ggplot(data=Baseball %>% filter(Season >= input$year[1], 
                                           Season <= input$year[2]),
                  aes(x=.data[[input$yvar]])) + 
        geom_histogram() + theme_classic() + theme(axis.title.y=element_blank(),
                                                   axis.ticks.y=element_blank(),
                                                   axis.text.y=element_blank())
    
    else p <- ggplot(data=Baseball %>% filter(Team == input$team) %>% 
                       filter(Season >= input$year[1], 
                              Season <= input$year[2]), 
                     aes(x=.data[[input$yvar]])) + 
        geom_histogram() + theme_classic() + theme(axis.title.y=element_blank(),
                                                   axis.ticks.y=element_blank(),
                                                   axis.text.y=element_blank())
    
    return(p)
    
  })
  
})
