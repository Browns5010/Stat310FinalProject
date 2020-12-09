library(shiny)
library(ggplot2)
library(DT)
library(shinydashboard)

dashboardPage(
  dashboardHeader(title = "My Dashboard"),
  dashboardSidebar(
    sliderInput("year","Select A Season Range", min=1900, max=2020, value=c(1900,2020), sep=""),
    selectInput("xvar","Select An X Variable", choices=NULL),
    selectInput("yvar","Select A Y Variable", choices=NULL),
    selectInput("team","Select A Team", choices="All Teams", selected = "All Teams", multiple=TRUE),
    radioButtons("lines","Select a Fit",choices=list("Smooth"=1, "Linear"=2), selected=1)
    ),
  dashboardBody(
    fluidRow(
      box(width=6,
          status="info", 
          title="MLB Data Plot",
          solidHeader = TRUE,
          plotOutput("plot")
      ),
      box(width=6,
          status="info",
          title="MLB Y Variable Histogram",
          solidHeader=TRUE,
          plotOutput("histy")
      ),
      box(width=6,
          status="info",
          title="MLB X Variable Histogram",
          solidHeader=TRUE,
          plotOutput("histx")
      ),
      box(width=6,
          status="info",
          title="MLB Data Table",
          solidHeader=TRUE,
          DTOutput("data"))
  )
)
)
