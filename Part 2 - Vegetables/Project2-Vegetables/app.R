#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)

veg <- readRDS("Clean_Veg_Data.RDS")
rc <- readRDS("Restricted_Chem_Data.RDS")

# Looks at the distribution of different pesticide types per vegetable

chem_avg <- veg %>% 
  select(Commodity, Label) %>% 
  filter(Commodity != "VEGETABLE TOTALS") %>% 
  group_by(Commodity, Label) %>% 
  summarize(`Label Totals` = n()) %>% 
  mutate(Percentage = `Label Totals`/ sum(`Label Totals`))

type_avg <- veg %>% 
  select(Commodity, Label, Type) %>% 
  filter(Commodity != "VEGETABLE TOTALS") %>% 
  replace(., is.na(.), "FERTILIZER") %>% 
  filter(Type != "FERTILIZER") %>% 
  group_by(Commodity, Label, Type) %>% 
  summarize(`Type Totals` = n()) %>% 
  mutate(Percentage = `Type Totals`/ sum(`Type Totals`))

rc.1 <- rc %>% filter(Value != "(D)" & Value != "(Z)") %>% 
  filter(Commodity != "VEGETABLE TOTALS") %>% 
  mutate_each_(funs(as.numeric), 12) %>% 
  mutate(Deaths = Value/`g/lb`)

rc_type_avg <- rc %>% 
  select(Commodity, Label, Type) %>% 
  filter(Commodity != "VEGETABLE TOTALS") %>%
  replace(., is.na(.), "FERTILIZER") %>% 
  group_by(Commodity, Label, Type) %>% 
  summarize(`Type Totals` = n()) %>% 
  mutate(Percentage = `Type Totals`/ sum(`Type Totals`))

rc.2 <- rc.1 %>% filter(Measurment == " MEASURED IN LB")
rc.3 <- rc.1 %>% filter(Measurment == " MEASURED IN LB / ACRE / YEAR")

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("What are Veggies are Made With"),
   
   # Sidebar with a slider input for number of bins 
   # sidebarLayout(
   #   sidebarPanel(
   #     helpText("Look at the types of substances that are used on your vegetables."),
   #     
   #     selectInput("var", 
   #                 label = "Choose a variable to display",
   #                 choices = c("Breakdown of Substances", 
   #                             "Breakdown of Chemicals",
   #                             "Restricted Chemical Usage", 
   #                             "Toxicity of Restricted Chemicals",
   #                             "Potential Deaths Based on Restricted Chemical Measurments"),
   #                 selected = "Breakdown of Substances")
   #   ),
     
     mainPanel(
       #textOutput("selected_var")
       "blah blah blah",
       plotOutput("chemPlot"),
       "blah blah blah"
     )
   )
#)      


server <- function(input, output) {
  
  # output$selected_var <- renderText({ 
  #   paste("You have selected:", input$var)
  # })
  
  # Define server logic required to draw a histogram
  output$chemPlot <- renderPlot({
    ggplot(chem_avg, aes(fill = Label, y=Percentage, x=Commodity)) +
      geom_bar( stat="identity", position="fill") +
      theme(title = element_text(size = 20),
            axis.title.y = element_text(size = 15),
            axis.text.y = element_text(size = 12),
            axis.text.x = element_text(face = "bold"),
            legend.title = element_text(size = 15, face = "bold")) +
      labs(title="Substances Used on Vegetables",
           x="")
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)

