library(tidyverse)

buoy <- 46035
year <- c(1985:2012,2014:2017)

# Read in the data

for (ii in 1:length(year)){
  nam <- paste("wd", year[ii], sep = "_")
  X <- read.table(sprintf("http://www.ndbc.noaa.gov/view_text_file.php?filename=%dh%d.txt.gz&dir=data/historical/stdmet/", 
                          buoy, year[ii]), header = TRUE, fill = TRUE)
  if (year[ii] == 2006){
    col_names <- names(X)
  }
  # Gives appropriate column names since the files from 2007 onward have two headers with a # in front
  if (year[ii] >= 2007){
    names(X) <- col_names
  }
  # Extract the data we are interested in and ensures uniformaty across data sets
  rel_data <- X %>%
    filter(hh %in% 10:14) %>%
    select(1:4, ATMP, WTMP)
  names(rel_data)[1:4] <- c("YYYY", "MM","DD","hh")
  # Converts a 2 digit year into a 4 digit format
  if (year[ii] < 1999){
    rel_data <- mutate(rel_data, YYYY = sum(1900, YYYY[1]))
  }
  assign(nam, rel_data)
  saveRDS(rel_data, sprintf("wd_4hour_%d.RDS",year[ii]))
}

rm(X, rel_data)

# Combines all the years into one tibble
weather_data <- bind_rows(wd_1985, wd_1986, wd_1987, wd_1988, wd_1989, wd_1990,
                          wd_1991, wd_1992, wd_1993, wd_1994, wd_1995, wd_1996,
                          wd_1997, wd_1998, wd_1999, wd_2000, wd_2001, wd_2002,
                          wd_2003, wd_2004, wd_2005, wd_2006, wd_2007, wd_2008,
                          wd_2009, wd_2010, wd_2011, wd_2012, wd_2014, wd_2015,
                          wd_2016, wd_2017)
saveRDS(weather_data, "Weather_Data_4hour.RDS")
