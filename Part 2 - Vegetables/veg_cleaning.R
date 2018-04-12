library(tidyverse)
library(readxl)

veg.1 <- read_xlsx("veg1.xlsx")

## NOTE: D: Withheld to avoid disclosing data for individual operations

# finds the number of distinct entries in each column
num_distinct_per_column <- apply(veg.1, 2, n_distinct)

# lists the names of the non unique columns and unique columns
# non_unique_col <- names(num_distinct_per_column[num_distinct_per_column == 1])
unique_col <- names(num_distinct_per_column[num_distinct_per_column > 1])

# creates a new version of the data in which only the columns which have multiple distinct values remain
veg.2 <- select(veg.1, unique_col)

# renames certain columns 
veg.3 <- dplyr::rename(veg.2, 
                       Geo = `Geo Level`, 
                       State = `State ANSI`,
                       Data = `Data Item`,
                       Category = `Domain Category`)

# organize veg data
veg.4 <- veg.3 %>% 
  separate(Category, into = c("Label", "Quantity"), sep= ",") %>%
  separate(Data, c("Vegetable","Measurment"), sep = ",") %>%
  separate(Vegetable, c("Veggie","Style"), sep = "-") %>%
  select(-Veggie, -Domain) %>%
  separate(Quantity, c("Type","Treatment"), sep = ":") %>%
  separate(Treatment, c("Treatment","Chemical_ID"), sep = "=") %>%
  mutate(Treatment = str_replace(Treatment, "\\(", "" )) %>%
  mutate(Chemical_ID = str_replace(Chemical_ID, "\\)", "" )) %>%
  mutate(Treatment = str_sub(Treatment, start = 2L, end = -2L))

saveRDS(veg.4, "Clean_Veg_Data.RDS")
rm(veg.1,veg.2,veg.3)

# create a separate tibble for restricted use chemicals
# NOTE: LD50 values were gathered from: http://dasnr22.dasnr.okstate.edu/docushare/dsweb/Get/Version-11545/EPP-7457web.pdf
ru <- filter(veg.4, Label == "RESTRICTED USE CHEMICAL")
ld <- read_xlsx("Lethal_Doses.xlsx")
ru.1 <- inner_join(ru, ld, by = "Treatment")

saveRDS(ru.1, "Restricted_Chem_Data.RDS")
