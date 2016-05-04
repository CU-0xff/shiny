
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(googleVis)

nace_lookup <- read.table("nace.csv", sep=",")
unit_lookup <- read.table("unit_measure.csv", sep = ",")
seasons_lookup <- read.table("seasons.csv", sep=",")
indicator_lookup <- read.table("indicators.csv", sep=",")
country_lookup <- read.table("country_codes.csv", sep=",")


shinyUI(fluidPage(

  # Application title
  titlePanel("European Union Employment Data"),

  
  sidebarLayout(
    sidebarPanel(
      h3("Usage"),
      p("Below you can find a browser of Eurostat employment data. Please refer to EUROSTAT and the slidify documentation regarding the data source and applied data clearance."),
      p("Follow the simple steps below. First select the qualifiers, then change the quarter."),
      h3("Step 1 - Qualifying Factors"),
      p("First select the qualifying factors to select which data shall be displayed"),
      p("Industry Sector"),
      selectInput("nace", "NACE", as.vector(nace_lookup[,2])),
      p("Unit to be displayed"),
      selectInput("unit", "Unit", as.vector(unit_lookup[,2])),
      p("Seasonal aggregation"),
      selectInput("seasons", "Seasons", as.vector(seasons_lookup[,2])),
      p("Type of Employment"),
      selectInput("indicator","Indicators", as.vector(indicator_lookup[,2])),
      h3("Step 2 - Move selector to choose which quarter is displayed"),
      p("Year and Quarter to be displayed"),
      sliderInput("quarter", "Quarter", 1, 138, 1),
      verbatimTextOutput("quarter_text"),
      p("Note: Earlier years contain only few data points.")
    ),
    # Show a plot of the generated distribution
    mainPanel(
      h3("European Employment Data"),
      p("Below is an overview plot of the major European countries. The red line indicates the currently selected quarter"),
      plotOutput("linePlot"),
      h2("Geographical Comparison"),
      p("Comparison of the data on the selected quarter"),
      htmlOutput("googleVisGeo"),
      h2("Histeresis of Countries"),
      plotOutput("trialPlot"),
      h2("Country Comparison"),
      htmlOutput("googleVisBarChart")
    )
  )
))
