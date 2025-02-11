## Objective: extract hearing data from NHANES
## NHANES 2015-2016 Data Documentation: https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2015/DataFiles/AUX_I.htm
## NHANES 2017-2020 Data Documentation: https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2015/DataFiles/AUX_I.htm

## 2015-2016 only collected 20–69, 2017 - 2020 only collected 6–19 years and 70 years and older

# Convert XPT file into a csv file

rm(list=ls())
setwd('/Users/bruce/Desktop/Prof Wang Lab/hearing-clustering')
library(haven)
library(tidyverse)
library(dplyr)
library(ggplot2)

# Read data

df_1516hear <- read_xpt("data/1516/AUX_I.XPT")
df_1516demo <- read_xpt('data/1516/DEMO_I.XPT')

df_1720hear <- read_xpt("data/1720/P_AUX.XPT")
df_1720demo <- read_xpt('data/1720/P_DEMO.XPT')

# Extract the hearing data

var_list <- c('SEQN', 'AUXU500R', 'AUXU1K1R', 'AUXU2KR', 'AUXU3KR', 'AUXU4KR', 'AUXU6KR', 'AUXU8KR',
              'AUXU500L', 'AUXU1K1L', 'AUXU2KL', 'AUXU3KL', 'AUXU4KL', 'AUXU6KL', 'AUXU8KL')

df_1516 <- df_1516hear %>%
  select(all_of(var_list))
df_1720 <- df_1720hear %>%
  select(all_of(var_list))

write_csv(df_1516, "data/nhanes_1516.csv")
write_csv(df_1720, "data/nhanes_1720.csv")

# Extract the age data

df_1516age <- df_1516demo %>%
  select("SEQN", "RIDAGEYR")
df_1720age <- df_1720demo %>%
  select("SEQN", "RIDAGEYR")

df_1516 <- left_join(df_1516, df_1516age, by = "SEQN")
df_1720 <- left_join(df_1720, df_1720age, by = "SEQN")

# Export to with age data

write_csv(df_1516, "data/nhanes_1516_age.csv")
write_csv(df_1720, "data/nhanes_1720_age.csv")

# Merge the two waves

df_1520 <- bind_rows(df_1516, df_1720)

# Display the age distribution

df_1520 %>%
  ggplot(aes(x = RIDAGEYR)) +
  geom_histogram(bins = 40)

# Sanity check
length(unique(df_1520$SEQN)) == length(df_1520$SEQN)

# Write the merged dataset
write_csv(df_1520, "data/nhanes_1520_age.csv")