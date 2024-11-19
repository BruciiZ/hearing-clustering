# Convert XPT file into a csv file

rm(list=ls())
setwd('/Users/bruce/Desktop/Prof. Wang lab/hearing-clustering')
library(haven)
library(tidyverse)
library(dplyr)

# Read data

df_1516raw <- read_xpt("data/1516/AUX_I.XPT")
df_1516demo <- read_xpt('data/1516/DEMO_I.XPT')

df_1720raw <- read_xpt("data/1720/P_AUX.XPT")
df_1720demo <- read_xpt('data/1720/P_DEMO.XPT')

# Extract only the hearing data
var_list <- c('AUXU500R', 'AUXU1K1R', 'AUXU2KR', 'AUXU3KR', 'AUXU4KR', 'AUXU6KR', 'AUXU8KR',
              'AUXU500L', 'AUXU1K1L', 'AUXU2KL', 'AUXU3KL', 'AUXU4KL', 'AUXU6KL', 'AUXU8KL')

df_1516 <- df_1516raw %>%
  select(all_of(var_list))

df_1720 <- df_1720raw %>%
  select(all_of(var_list))

write_csv(df_1516, "data/nhanes_1516.csv")
write_csv(df_1720, "data/nhanes_1720.csv")

# Extract the age data and joining

var_list <- c('SEQN', 'AUXU500R', 'AUXU1K1R', 'AUXU2KR', 'AUXU3KR', 'AUXU4KR', 'AUXU6KR', 'AUXU8KR',
              'AUXU500L', 'AUXU1K1L', 'AUXU2KL', 'AUXU3KL', 'AUXU4KL', 'AUXU6KL', 'AUXU8KL')

df_1516 <- df_1516raw %>%
  select(all_of(var_list))
df_1720 <- df_1720raw %>%
  select(all_of(var_list))

df_1516demo <- df_1516demo %>%
  select("SEQN", "RIDAGEYR")
df_1720demo <- df_1720demo %>%
  select("SEQN", "RIDAGEYR")

df_1516 <- left_join(df_1516, df_1516demo, by = "SEQN")
df_1720 <- left_join(df_1720, df_1720demo, by = "SEQN")

write_csv(df_1516, "data/nhanes_1516_age.csv")
write_csv(df_1720, "data/nhanes_1720_age.csv")

# Merge the two waves
dfMerge <- bind_rows(df_1516, df_1720)

length(unique(dfMerge$SEQN)) == nrow(dfMerge)

# Write the merged dataset
write_csv(dfMerge, "data/nhanes_1520_age.csv")