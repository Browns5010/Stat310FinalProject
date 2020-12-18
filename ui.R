library(shiny)
library(ggplot2)
library(DT)
library(shinydashboard)

fluidPage(
  titlePanel(title = "MLB Data Machine"),
    sidebarPanel(
    sliderInput("year","Select A Season Range", min=1900, max=2020, value=c(1900,2020), sep=""),
    selectInput("xvar","Select An X Variable", choices=NULL),
    selectInput("yvar","Select A Y Variable", choices=NULL),
    selectInput("team","Select A Team", choices="All Teams", selected = "All Teams", multiple=TRUE),
    sliderInput("span","Select a Smoothness Level For Trend Line", min=0, max=1, value=.5, sep="")
    # sliderInput("bins","Histogram of X Variable Bin Size", min=0, max=500, value=50, sep=""),
    # sliderInput("bins1", "Hisotgram of Y Variable Bin Size", min=0, max=500,value=50, sep="")
   ),
  mainPanel(
    tabsetPanel(
    type="tabs",
    tabPanel("ScatterPlot",plotOutput("plot")),
    tabPanel("Data",DTOutput("data"))
    )
)
)
