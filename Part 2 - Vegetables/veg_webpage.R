library(shiny)
library(shinydashboard)
library(tidyverse)

ui <- dashboardPage(skin = "black",
  dashboardHeader(title = "Veggie Data"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Introduction", tabName = "intro", icon = icon("chevron-right")),
      menuItem("Substances", tabName = "substances", icon = icon("chevron-right"),
               menuSubItem("Individual Substances", tabName = "substances", icon = icon("chevron-right")),
               menuSubItem("Chemicals", tabName = "chemicals", icon = icon("chevron-right")),
               menuSubItem("Restricted Use Chemicals", tabName = "rchem", icon = icon("chevron-right"))),
      menuItem("Toxicity", tabName = "toxicity", icon = icon("chevron-right")),
      menuItem("Effects on Humans", tabName = "deaths", icon = icon("chevron-right"))
    )
  ),
  
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(
        tabName = "intro",
          h2("Introduction", align = "center"),
          p("In order to control for pests and diseases, the government started 
            spraying vegetables with different chemicals. We will be looking at
            how different vegetables are treated differently, specifically 
            brocolli, brussel sprouts, and cauliflower based on:",
            style = "font-family: 'arial'"),
          br(),
          p("- Number of chemical used on each vegetable",
            style = "font-family: 'arial'"),
          p("- The types of chemicals used on each vegetable",
            style = "font-family: 'arial'"),
          p("- The toxicity of the restricted use chemicals",
            style = "font-family: 'arial'"),
          br(),
          p("Data was gathered from:", a("https://quickstats.nass.usda.gov/"),
            style = "font-family: 'arial'")
      ),
      
      tabItem(
        
        tabName = "substances",
        h2("A Breakdown of the Different Substances Used on Vegetables", 
           align = "center"),
        p("First let's understand the types of chemicals that are used on our vegetables:",
          style = "font-family: 'arial'"),
        fluidRow(align = "center",
          plotOutput("plot1", height = 500, width = 700)   
        ),
        br(),
        p("-",strong("Chemical:"), "Substances such as fungicides, herbicides, and insecticides which are used to kill pests",
          style = "font-family: 'arial'"),
        p("-",strong("Fertilizer:"), "Used to help promote the growth of vegetables by providing them with extra nutrients",
          style = "font-family: 'arial'"),
        p("-",strong("Restricted Use Chemicals:"), "Chemicals carefully monitored by the EPA due to their potentially harmful effects",
          style = "font-family: 'arial'")

      ),

      tabItem(
        
        tabName = "chemicals",
        h2("A Breakdown of the Different Chemicals Used on Vegetables", 
           align = "center"),
        p("Now let's break up the chemicals into their various subgroups:",
          style = "font-family: 'arial'"),
        fluidRow(align = "center",
          plotOutput("plot2", height = 500, width = 700)
        ),
        br(),
        p("-",strong("Insecticide:"), "Substances used to kill insects",
          style = "font-family: 'arial'"),
        p("-",strong("Fungicide:"), "Substances used to kill fungi (mushrooms)",
          style = "font-family: 'arial'"),
        p("-",strong("Herbicide:"), "Substances used to kill harmful or unwanted plants",
          style = "font-family: 'arial'"),
        p("-",strong("Other:"), "Chemicals that do not fit into any of the other categories",
          style = "font-family: 'arial'")
        
      ),
      
      tabItem(
        
        tabName = "rchem",
        h2("A Breakdown of the Different Restricted Use Chemicals Used on Vegetables", 
           align = "center"),
        p("Since the restricted use chemicals are monitored by the EPA due to their potentially harmful side effects, 
          let's look more closely at how they are used to treat our vegetables*:",
          style = "font-family: 'arial'"),
        fluidRow(align = "center",
          plotOutput("plot3", height = 500, width = 700)
        ),
        br(),
        p(em("*Brussel sprouts are not shown since they either have no restricted chemical
             use, or the measurements for amount of chemicals used was withheld"),
          style = "font-family: 'arial'")
        
      ),
      
      tabItem(
        tabName = "toxicity",
        h2("The Toxicity of the Restricted Use Chemicals",
          align = "center"),
        p("By looking at the LD50**, or the amount in g/lbs that is needed to kill half of the population, we can determine the toxicity of these different chemicals:",
          style = "font-family: 'arial'"),
        fluidRow(align = "center",
          plotOutput("plot4", height = 500, width = 700)
        ),
        br(),
        p("-",strong("High:"), "LD50 < 0.0226796",
          style = "font-family: 'arial'"),
        p("-",strong("Medium:"), "0.0231332 < LD50 < 0.226796",
          style = "font-family: 'arial'"),
        p("-",strong("Low:"), "LD50 > 0.226796",
          style = "font-family: 'arial'"),
        br(),
        
        p(em("**These categories were determined by using criteria from:",
             a("http://pmep.cce.cornell.edu/profiles/extoxnet/TIB/dose-response.html")),
          style = "font-family: 'arial'")
        
      ),

      tabItem(
        tabName = "deaths",
        h2("The Potential Human Deaths Due to Restricted Use Chemicals"),
        p("Based on the measurements provided by the USDA, the number of deaths due to each chemical is shown below:",
          style = "font-family: 'arial'"),
        fluidRow(align = "center",
          plotOutput("plot5", height = 500, width = 700)
        ),
        br(),
        p("Its is important to note the x axis labels; the one above shows possible human deaths 
          based on how much chemical was used (measured in pounds), however, the specifics of that measurement are never explained.",
          style = "font-family: 'arial'"),
        p("Thus, a more reliable measure of possible human deaths uses the measurements in terms of lbs/acre/year:",
          style = "font-family: 'arial'"),
        fluidRow(align = "center",
          plotOutput("plot6", height = 500, width = 700)
        ),
        br(),
        p("While it is still unclear about the exact procedures by which these chemicals are put onto the vegetables, if we look at the
          extreme case in which the entire years worth of chemicals was sprayed on one acre of vegetables all at once, the numbers shows 
          are the number of people each chemical would kill. However, it should be safe to assume that this is not the case, and that the 
          applications occur over time which allows does not allow the chemicals to accumulate and allows for a safe consumption of vegetables.",
          style = "font-family: 'arial'")
      )

    )
  )
)
  
  server <- function(input, output) {
    veg <- readRDS("~/Data Science in R - MA415/MA415-Homework5/Part 2 - Vegetables/Clean_Veg_Data.RDS")
    rc <- readRDS("~/Data Science in R - MA415/MA415-Homework5/Part 2 - Vegetables/Restricted_Chem_Data.RDS")
    rc.1 <- rc %>% filter(Value != "(D)" & Value != "(Z)") %>% 
      filter(Commodity != "VEGETABLE TOTALS") %>% 
      mutate_each_(funs(as.numeric), 12) %>% 
      mutate(Deaths = Value/`g/lb`)
    
    output$plot1 <- renderPlot({
      chem_avg <- veg %>%
        select(Commodity, Label) %>%
        filter(Commodity != "VEGETABLE TOTALS") %>%
        group_by(Commodity, Label) %>%
        summarize(`Label Totals` = n()) %>%
        mutate(Percentage = `Label Totals` / sum(`Label Totals`))
      
      ggplot(chem_avg, aes(fill = Label, y = Percentage, x = Commodity)) +
        geom_bar(stat = "identity", position = "fill") +
        theme(
          title = element_text(size = 20),
          axis.title.y = element_text(size = 15),
          axis.text.y = element_text(size = 12),
          axis.text.x = element_text(face = "bold"),
          legend.title = element_text(size = 15, face = "bold")
        ) +
        labs(title = "Substances Used on Vegetables",
             x = "")
    })
    
    output$plot2 <- renderPlot({
      type_avg <- veg %>% 
        select(Commodity, Label, Type) %>% 
        filter(Commodity != "VEGETABLE TOTALS") %>% 
        replace(., is.na(.), "FERTILIZER") %>% 
        filter(Type != "FERTILIZER") %>% 
        group_by(Commodity, Label, Type) %>% 
        summarize(`Type Totals` = n()) %>% 
        mutate(Percentage = `Type Totals`/ sum(`Type Totals`))
      
      ggplot(type_avg, aes(fill = Type, y=Percentage, x=Commodity)) + 
        geom_bar( stat="identity", position="fill") +
        labs(title="Chemical Types Used on Vegetables", 
             x="") +
        theme(title = element_text(size = 20),
              axis.title.y = element_text(size = 15),
              axis.text.y = element_text(size = 12),
              axis.text.x = element_text(face = "bold"),
              legend.title = element_text(size = 15, face = "bold"))
      
    })
    
    output$plot3 <- renderPlot({
      
      rc_type_avg <- rc %>% 
        select(Commodity, Label, Type) %>% 
        filter(Commodity != "VEGETABLE TOTALS") %>%
        replace(., is.na(.), "FERTILIZER") %>% 
        group_by(Commodity, Label, Type) %>% 
        summarize(`Type Totals` = n()) %>% 
        mutate(Percentage = `Type Totals`/ sum(`Type Totals`))
      
      ggplot(rc_type_avg, aes(fill = Type, y=Percentage, x=Commodity)) + 
        geom_bar( stat="identity", position="fill") +
        labs(title="Restriced Chemical Types Used on Vegetables", 
             x="") +
        theme(title = element_text(size = 20),
              axis.title.y = element_text(size = 15),
              axis.text.y = element_text(size = 12),
              axis.text.x = element_text(face = "bold"),
              legend.title = element_text(size = 15, face = "bold"))
      
    })
    
    output$plot4 <- renderPlot({
      
        ggplot(rc.1, aes(x = Treatment, y = `g/lb`, colour = Toxicity)) +
          geom_point(size = 5) +
          scale_color_manual(values=c("red", "green", "orange"),
                             breaks=c("High","Medium","Low")) +
          theme(title = element_text(size = 20),
                axis.title.y = element_text(size = 15),
                axis.text.y = element_text(size = 12),
                legend.title = element_text(size = 15, face = "bold"),
                legend.text = element_text(size = 12),
                panel.grid.minor.x=element_blank(),
                panel.grid.major.x=element_blank(),
                axis.text.x = element_text(angle = 90,
                                           vjust = 0.5,
                                           face = "bold")) +
          labs(title = "LD50 Values of Restricted Chemicals",
               y = "LD50 (g/lbs)")
      
    })
    
    output$plot5 <- renderPlot({
      
      rc.2 <- rc.1 %>% filter(Measurment == " MEASURED IN LB")
      ggplot(rc.2, aes(fill = Commodity, y = Deaths, x = Treatment)) + 
        geom_bar(position="dodge", stat="identity") +
        theme(axis.text.x = element_text(angle = 90,
                                         vjust = 0.5)) +
        labs(title = "Possible Deaths Due to Restricted Chemical Use",
             x = "Treatment (lbs)",
             y = "Deaths")  +
        theme(title = element_text(size = 15))
      
    })
    
    output$plot6 <- renderPlot({
      
      rc.3 <- rc.1 %>% filter(Measurment == " MEASURED IN LB / ACRE / YEAR")
      ggplot(rc.3, aes(fill = Commodity, y = Deaths, x = Treatment)) + 
        geom_bar(position="dodge", stat="identity") +
        theme(axis.text.x = element_text(angle = 90,
                                         vjust = 0.5)) +
        labs(title = "Possible Deaths Due to Restricted Chemical Use",
             x = "Treatment (lbs/acre/year)",
             y = "Deaths") +
        theme(title = element_text(size = 15))
      
    })
    
    
    
  }
  
  shinyApp(ui, server)
  