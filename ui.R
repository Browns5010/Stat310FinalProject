library(shiny)
library(ggplot2)
library(DT)
library(shinydashboard)

dashboardPage(
  dashboardHeader(title = "My Dashboard"),
  dashboardSidebar(
    sliderInput("year","Select A Season Range", min=1900, max=2020, value=c(1900,2020), sep=""),
    selectInput("xvar","Select An X Variable", choices="Choose One of the Following"),
    selectInput("yvar","Select A Y Variable", choices="Choose One of the Following"),
    selectInput("team","Select A Team", choices="All Teams", selected = "All Teams"),
    radioButtons("lines","Select a Fit",choices=list("Smooth"=1, "Linear"=2), selected=1)
    ),
  dashboardBody(
    fluidRow(
      box(width=6, 
          status="info", 
          title="MLB Plot by Team and Year",
          solidHeader = TRUE,
          plotOutput("plot")
      ),
      box(width=6,
          status="info",
          title="MLB Data Frame",
          solidHeader=TRUE,
          DTOutput("data"))
  )
)
)
