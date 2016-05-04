
# Shiny Application for Coursera R Module - Reproducable Applications
# Provides an alternative viewer for data provided by the European Office for Statistics 
#
# Histrorical Employment Data
#

library(googleVis)
library(shiny)

raw_data <- readRDS("namq_nace10_noagg.rds")
country_codes <- readRDS("country_codes_noagg.rds")

nace_lookup <- read.table("nace.csv", sep=",")
unit_lookup <- read.table("unit_measure.csv", sep = ",")
seasons_lookup <- read.table("seasons.csv", sep=",")
indicator_lookup <- read.table("indicators.csv", sep=",")

colors_collection <- c("red","blue","black","brown","green")
major_EU_countries <- c("DE","UK","FR","IT","SP")

current_quarter <- 1

generate_dataset <- function(nace, unit, seasons, indicator) {
  code_nace_r2 <-  nace_lookup[which(nace_lookup$V2 == nace),1] 
  code_unit <- unit_lookup[which(unit_lookup$V2 == unit),1] 
  code_season <- seasons_lookup[which(seasons_lookup$V2 == seasons),1] 
  code_indicator <- indicator_lookup[which(indicator_lookup$V2 == indicator),1] 
  
  temp_data <-   raw_data[which(raw_data$nace_r2==code_nace_r2 &
                                  raw_data$unit==code_unit &
                                  raw_data$s_adj==code_season &
                                  raw_data$indic_na==code_indicator),]
  
  return(temp_data)
}

generate_timeseries <- function(input_data, countries) {
  
  timeseries <- data.frame(row.names = c(1:138))
  
  for(country in countries) {
    new_line <- as.ts(t(input_data[which(input_data$geo == country),][1,1:138]), start=c(2014,2), end=c(1989,3))
    timeseries <- data.frame(timeseries, new_line)
  }
  colnames(timeseries) <- countries
  
  return(timeseries)
}


shinyServer(function(input, output) {

    #Generate Dataset with currently selected options. This is reative as this is quite costly.
    
    temp_data <- reactive({generate_dataset(input$nace, input$unit, input$seasons, input$indicator) })

    timeseries_data <- reactive({generate_timeseries(temp_data(), major_EU_countries)})
    
    output$linePlot <- renderPlot({ plot.ts(timeseries_data(), plot.type = "single", col=colors_collection, xy.labels = c("Quarter", "Value as defined on the left"))
      abline(v=input$quarter, col="red", lwd=5)
      legend('topright', major_EU_countries, col=colors_collection, bty="o", cex=.75, lwd=3)
            })
    
    #Find currently selected quarter
    selected_col_name <- reactive({colnames(raw_data)[input$quarter]})
    
    output$quarter_text <- renderText({paste(substring(selected_col_name(),2,5), substring(selected_col_name(), 6, 7))})
    
    output$trialPlot <- renderPlot({ hist(temp_data()[,selected_col_name()], col="LIGHTBLUE", breaks = 10, main="Histogram", xlab=input$unit)   })
    
    output$googleVisGeo <- renderGvis(({ gvisGeoChart(temp_data(), locationvar="geo", colorvar=selected_col_name(), options=list(region="150"))}))

    output$googleVisBarChart <- renderGvis({
      gvisBarChart(temp_data(), xvar="geo", yvar=selected_col_name(), options=list(width="300px", height="400px"))
    })
})
