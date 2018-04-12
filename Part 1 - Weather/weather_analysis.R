library(imputeTS)
library(tidyverse)
library(openair)

wd <- readRDS("~/Data Science in R - MA415/MA415-Homework5/Part 1 - Weather/Weather_Data.RDS")
### Create time series for air and sea temperature

air_vector <- as.vector(wd["ATMP"])
air_vector[air_vector == 999] <- NA
air_vector <- na.interpolation(air_vector, option = "linear")

air_ts <- ts(air_vector, start = c(1977, 9), end = c(2009, 12))

# replace 999 values with NA then replace NA with mean or interporlation
sea_vector <- as.vector(wd["WTMP"])
sea_vector[sea_vector == 999] <- NA
sea_vector <- na.interpolation(sea_vector, option = "linear")

sea_ts <- ts(sea_vector, start = c(1977, 9), end = c(2009, 12))

# Add visuals
ts.plot(air_ts, gpars=list(xlab="Time", ylab="Temperature", lty=c(1:3),
                           main = "Time Series of Air Temperature from 1985 to 2017",
                           lwd = 2,
                           font.lab = 3,
                           las = 1,
                           col = 'cyan'))

ts.plot(sea_ts, gpars=list(xlab="Time", ylab="Temperature", lty=c(1:3),
                           main = "Time Series of Sea Temperature from 1985 to 2017",
                           lwd = 2,
                           font.lab = 3,
                           las = 1,
                           col = 'green'))

### Perform statistical tests

# Sea Temperatures

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

t.test(sea_1985 ,sea_2017)

# Air Temperatures

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

t.test(air_1985 ,air_2017)

