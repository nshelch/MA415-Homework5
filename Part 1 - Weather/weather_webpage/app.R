library(shiny)
library(shinydashboard)
library(tidyverse)
library(imputeTS)

ui <- dashboardPage(skin = "black",
                    dashboardHeader(title = "Weather Data"),
                    dashboardSidebar(
                      sidebarMenu(
                        menuItem("Introduction", tabName = "intro", icon = icon("chevron-right")),
                        menuItem("Single Recording", tabName = "single", icon = icon("chevron-right"),
                                 menuSubItem("Air Temperatures", tabName = "air", icon = icon("chevron-right")),
                                 menuSubItem("Sea Temperatures", tabName = "sea", icon = icon("chevron-right"))),
                        menuItem("Conclusion", tabName = "conclusion", icon = icon("chevron-right"))
                      )
                    ),
                  
                    
                    dashboardBody(
                      tabItems(
                        # First tab content
                        tabItem(
                          tabName = "intro",
                          h2("Introduction", align = "center"),
                          p("Given the recent talks regarding climate change and global warming, we decided to look at the air and sea temperatures recorded from buoy 46035 at noon every day in order to analyze whether there has been an overall change in temperatures over the last 30 years.",
                            style = "font-family: 'arial'"),
                          br(),
                          p("Data was gathered from:", a("http://www.ndbc.noaa.gov/station_page.php?station=46035"),
                            style = "font-family: 'arial'")
                        ),
                        
                        tabItem(
                          
                          tabName = "air",
                          h2("Air Temperature Changes Over Time", 
                             align = "center"),
                          p("Let's look at the change in air temperatures over the last 30 years. As we can see on the graph, air temperature has not changed much over the last 30 years, and this evidence is further comfirmed via t-test.",
                            style = "font-family: 'arial'"),
                          fluidRow(
                             plotOutput("plot1", height = 500, width = 700),
                             textOutput("stat1")
                          ),
                          br(),
                          p(strong("Null Hypothesis:"), "mean air temperature 1985 = mean air temperature 2017",
                            style = "font-family: 'arial'"),
                          p(strong("Alternative Hypothesis:"), "mean air temperature 1985 != mean air temperature 2017",
                            style = "font-family: 'arial'"),
                          p(strong("P-Value:"), "0.2817",
                            style = "font-family: 'arial'"),
                          p("Since the P-value is greater than 0.05, we accept the null hypothesis, thus air temperatures have not changed in the last 30 years.")
                        ),
                        
                        tabItem(
                          
                          tabName = "sea",
                          h2("Sea Temperature Changes Over Time", 
                             align = "center"),
                          p("Let's look at the change in sea temperatures over the last 30 years. As we can see on the graph, sea temperature has not changed over the last 30 years, and this evidence is further comfirmed via t-test.",
                            style = "font-family: 'arial'"),
                          fluidRow(
                            plotOutput("plot2", height = 500, width = 700),
                            textOutput("stat2")
                          ),
                          br(),
                          p(strong("Null Hypothesis:"), "mean sea temperature 1985 = mean sea temperature 2017",
                            style = "font-family: 'arial'"),
                          p(strong("Alternative Hypothesis:"), "mean sea temperature 1985 != mean sea temperature 2017",
                            style = "font-family: 'arial'"),
                          p(strong("P-Value:"), "0.373",
                            style = "font-family: 'arial'"),
                          p("Since the P-value is greater than 0.05, we accept the null hypothesis and state that the mean sea temperature has not changed over the last 30 years. ")
                          
                        ),
                        
                        tabItem(
                          
                          tabName = "conclusion",
                          h2("Final Thoughts", 
                             align = "center"),
                          p("Despite the large data size, we encounter issues in terms of inconsistent and missing data:",
                            style = "font-family: 'arial'"),
                          br(),
                          p("- The data from 1985 starts in mid-September, and in later years there are days and potentially weeks which are missing from the data set.",
                            style = "font-family: 'arial'"),
                          p("-- In fact, the year 2013 is completely missing from the data set",
                            style = "font-family: 'arial'"),
                          p("- Furthermore, the sea and air temperature data periodically reports missing values as '999.0' which I modified by replacing it with an interpolation of sea/air temperatures as an attempt to preserve the data.",
                            style = "font-family: 'arial'"),
                          p("- Also, gathering one data point from a 24-hour day does not give us a good estimate of sea temperatures due to such a small sampling size in relation to the amount of potential data points per day.",
                            style = "font-family: 'arial'"),
                          p("-- However, while larger sample sizes will help reduce standard deviation and variance allowing for more precise measurements, there comes a time in which gathering more data doesn't result in huge changes to your statistics",
                            style = "font-family: 'arial'")
                        )
                        
                        
                        
    )
  )
)

server <- function(input, output) {
  
  wd <- readRDS("~/Data Science in R - MA415/MA415-Homework5/Part 1 - Weather/Weather_Data.RDS")
  
  output$plot1 <- renderPlot({
    air_vector <- as.vector(wd["ATMP"])
    air_vector[air_vector == 999] <- NA
    air_vector <- na.interpolation(air_vector, option = "linear")
    air_ts <- ts(air_vector, start = c(1977, 9), end = c(2009, 12))
    
    ts.plot(air_ts, gpars=list(xlab="Time", ylab="Temperature", lty=c(1:3),
                               main = "Time Series of Air Temperature from 1985 to 2017",
                               lwd = 2,
                               font.lab = 3,
                               las = 1,
                               col = 'cyan'))
  })
  
  output$stat1 <- renderPrint({
    # Get the air temperatures from 1985 and 2017
    air_1985 <- wd %>% 
      filter(YYYY == 1985) %>% 
      select("ATMP")
    air_1985[air_1985 == 999] <- NA
    air_1985 <- na.interpolation(air_1985, option = "linear")
    
    air_2017 <- wd %>% 
      filter(YYYY == 2017) %>% 
      select("ATMP")
    air_2017[air_2017 == 999] <- NA
    air_2017 <- na.interpolation(air_2017, option = "linear")
    
    # Perform a two-sided t test
   t.test(air_1985 ,air_2017)  
    
  })
  
  output$plot2 <- renderPlot({
    # Get the sea temperature vector and replace the 999.0 with the mean of the vector
    sea_vector <- as.vector(wd["WTMP"])
    sea_vector[sea_vector == 999] <- NA
    sea_vector <- na.interpolation(sea_vector, option = "linear")
    
    sea_ts <- ts(sea_vector,  start = c(1977, 9), end = c(2009, 12))
    
    ts.plot(sea_ts, gpars=list(xlab="Time", ylab="Temperature", lty=c(1:3),
                               main = "Time Series of Sea Temperature from 1985 to 2017",
                               lwd = 2,
                               font.lab = 3,
                               las = 1,
                               col = 'green'))
    
  })
  
  output$stat2 <- renderPrint({
    
    # Get the sea temperatures from 1985 and 2017, and remove the 999.0 values and replace them with the mean temperature of 1985
    sea_1985 <- wd %>% 
      filter(YYYY == 1985) %>% 
      select("WTMP")
    sea_1985[sea_1985 == 999] <- NA
    sea_1985 <- na.interpolation(sea_1985, option = "linear")
    
    sea_2017 <- wd %>% 
      filter(YYYY == 2017) %>% 
      select("WTMP")
    sea_2017[sea_2017 == 999] <- NA
    sea_2017 <- na.interpolation(sea_2017, option = "linear")
    
    # Run t-test
    t.test(sea_1985 ,sea_2017)
    
  })
  
  
}

shinyApp(ui, server)
