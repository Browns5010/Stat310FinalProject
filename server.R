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
  
  observeEvent(input$xvar, {
    updateSelectInput(session, "xvar", choices=colnames(Baseball), selected="Season")
  },
  once=TRUE)
  
  observeEvent(input$yvar, {
    updateSelectInput(session, "yvar", choices=colnames(Baseball), selected="Hits")
  },
  once=TRUE)
  
  
  output$data <- renderDT({
    df <- Baseball
    return(df)
  })
  
  output$plot <- renderPlot({
    if(input$team == "All Teams") ({ p <- ggplot(data=Baseball %>% filter(Season >= input$year[1], 
                               Season <= input$year[2]),
          aes(x=.data[[input$xvar]],y=.data[[input$yvar]])) + geom_point(alpha=.4) + theme_minimal() + 
      labs(title="MLB Data Plot (Select, Year, Team, and Variables)", 
           subtitle="Data Provided by Lehman Baseball Database") + 
      geom_smooth(method="loess", span=input$span, se=FALSE, color="red") 
    
    })
    
    else ({ p <- ggplot(data=Baseball %>% filter(Team == input$team) %>% 
                                                filter(Season >= input$year[1], 
                                                       Season <= input$year[2]), 
                                               aes(x=.data[[input$xvar]],y=.data[[input$yvar]])) + 
        geom_point(size=4, aes(color=Team)) + theme_minimal() + 
      labs(title="MLB Data Plot (Select, Year, Team, and Variables)", 
           subtitle="Data Provided by Lehman Baseball Database") + 
      geom_smooth(method="loess", span=input$span, se=FALSE) + facet_wrap(vars(Team))
      
    })

    return(p)
  })
  
  # output$histx <- renderPlot ({
  #   if(input$team == "All Teams")
  #      p <- ggplot(data=Baseball %>% filter(Season >= input$year[1],
  #                                             Season <= input$year[2]),
  #                                               aes(x=.data[[input$xvar]])) +
  #       geom_histogram(bins=input$bins, aes(color="white")) + theme_classic() + theme(axis.title.y=element_blank(),
  #                                                  axis.ticks.y=element_blank(),
  #                                                  axis.text.y=element_blank(),
  #                                                  legend.position="none")
  # 
  #   else p <- ggplot(data=Baseball %>% filter(Team == input$team) %>%
  #                         filter(Season >= input$year[1],
  #                                Season <= input$year[2]),
  #                       aes(x=.data[[input$xvar]])) +
  #     geom_histogram(bins=input$bins, aes(color="white")) + theme_classic() + theme(axis.title.y=element_blank(),
  #                                                axis.ticks.y=element_blank(),
  #                                                axis.text.y=element_blank(),
  #                                                legend.position="none")
  # 
  #   return(p)
  # })
  # 
  # output$histy <- renderPlot ({
  #   if(input$team == "All Teams")
  #     p <- ggplot(data=Baseball %>% filter(Season >= input$year[1],
  #                                          Season <= input$year[2]),
  #                 aes(x=.data[[input$yvar]], color="white")) +
  #       geom_histogram(bins=input$bins1) + theme_classic() + theme(axis.title.y=element_blank(),
  #                                                  axis.ticks.y=element_blank(),
  #                                                  axis.text.y=element_blank(),
  #                                                  legend.position="none")
  # 
  #   else p <- ggplot(data=Baseball %>% filter(Team == input$team) %>%
  #                      filter(Season >= input$year[1],
  #                             Season <= input$year[2]),
  #                    aes(x=.data[[input$yvar]], color="white")) +
  #       geom_histogram(bins=input$bins1) + theme_classic() + theme(axis.title.y=element_blank(),
  #                                                  axis.ticks.y=element_blank(),
  #                                                  axis.text.y=element_blank(),
  #                                                  legend.position="none")
  # 
  #   return(p)
  # 
  # })

})
