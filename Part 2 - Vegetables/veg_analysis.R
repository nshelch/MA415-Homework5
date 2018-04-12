library(tidyverse)

# remove path
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


#  Make stacked percent graphs
ggplot(chem_avg, aes(fill = Label, y=Percentage, x=Commodity)) + 
  geom_bar( stat="identity", position="fill") +
  theme(axis.text.x = element_text(size = 10),
        legend.text = element_text(size = 7)) +
  labs(title="Chemicals Used on Vegetables", 
       x="")
dev.copy(png,'chem_avg.png')
dev.off()

ggplot(type_avg, aes(fill = Type, y=Percentage, x=Commodity)) + 
  geom_bar( stat="identity", position="fill") +
  labs(title="Chemical Types Used on Vegetables", 
       x="")
dev.copy(png,'type_avg.png')
dev.off()


# Look at LD50 within Restricted Use Chemicals
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

ggplot(rc_type_avg, aes(fill = Type, y=Percentage, x=Commodity)) + 
  geom_bar( stat="identity", position="fill") +
  labs(title="Restriced Chemical Types Used on Vegetables", 
       x="")
dev.copy(png,'rc_type_avg.png')
dev.off()


# LD50 Toxicity Measures for Different Chemicals

ggplot(rc.1, aes(x = Treatment, y = `g/lb`, colour = Toxicity)) +
  geom_point(size = 3) +
  scale_color_manual(values=c("red", "green", "orange"),
                     breaks=c("High","Medium","Low")) +
  theme(panel.grid.minor.x=element_blank(),
        panel.grid.major.x=element_blank(),
        axis.text.x = element_text(angle = 90,
                                   vjust = 0.5)) +
  labs(title = "LD50 Values of Restricted Chemicals",
       y = "LD50 (g/lbs)")
dev.copy(png,'toxicity.png')
dev.off()

# Number of Deaths Per Year

rc.2 <- rc.1 %>% filter(Measurment == " MEASURED IN LB")
ggplot(rc.2, aes(fill = Commodity, y = Deaths, x = Treatment)) + 
  geom_bar(position="dodge", stat="identity") +
  theme(axis.text.x = element_text(angle = 90,
                                   vjust = 0.5)) +
  labs(title = "Deaths Due to Restricted Chemical Use",
       x = "Treatment (lbs)",
       y = "Deaths")
dev.copy(png,'death_lbs.png')
dev.off()

rc.3 <- rc.1 %>% filter(Measurment == " MEASURED IN LB / ACRE / YEAR")
ggplot(rc.3, aes(fill = Commodity, y = Deaths, x = Treatment)) + 
  geom_bar(position="dodge", stat="identity") +
  theme(axis.text.x = element_text(angle = 90,
                                   vjust = 0.5)) +
  labs(title = "Deaths Due to Restricted Chemical Use",
       x = "Treatment (lbs/acre/year)",
       y = "Deaths")
dev.copy(png,'death_year.png')
dev.off()
