# Convert XPT file into a csv file

rm(list=ls())
setwd('/Users/bruce/Desktop/Prof. Wang lab/hearing-clustering')
library(haven)
library(tidyverse)

df <- read_xpt("data/P_AUX.XPT")

var_list <- c('AUXU500R', 'AUXU1K1R', 'AUXU2KR', 'AUXU3KR', 'AUXU4KR', 'AUXU6KR', 'AUXU8KR',
              'AUXU500L', 'AUXU1K1L', 'AUXU2KL', 'AUXU3KL', 'AUXU4KL', 'AUXU6KL', 'AUXU8KL')
df <- df %>%
  select(all_of(var_list))

write_csv(df, "data/nhanes_1720.csv")
