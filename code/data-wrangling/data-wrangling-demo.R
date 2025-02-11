# Convert XPT file into a csv file

rm(list=ls())
setwd('/Users/bruce/Desktop/Prof Wang Lab/hearing-clustering')
library(haven)
library(tidyverse)
library(dplyr)

# Read data
df_1516demo <- read_xpt('data/1516/DEMO_I.XPT')
df_1720demo <- read_xpt('data/1720/P_DEMO.XPT')

# Extract the demographic factors
var_list <- c('SEQN', 'RIAGENDR', 'RIDAGEYR', 'RIDRETH3', 'DMDEDUC2', 'DMDMARTL')
df_1516 <- df_1516demo %>%
  select(all_of(var_list))
var_list <- c('SEQN', 'RIAGENDR', 'RIDAGEYR', 'RIDRETH3', 'DMDEDUC2', 'DMDMARTZ')
df_1720 <- df_1720demo %>%
  select(all_of(var_list))

# Merge the two dfs
colnames(df_1516) <- c('SEQN', 'sex', 'age', 'race', 'education', 'marital')
colnames(df_1720) <- c('SEQN', 'sex', 'age', 'race', 'education', 'marital')
df_1516 <- df_1516 %>%
  mutate(marital = case_when(
    marital == 1 | marital == 6 ~ 1,
    marital %in% c(2,3,4) ~ 2,
    marital == 5 ~ 3,
    .default = NA
  ))
df_1520 <- bind_rows(df_1516, df_1720)

# Recode the variables
df_1520 <- df_1520 %>%
  filter(!education %in% c(7, 9)) %>%
  filter(!marital %in% c(77, 99)) %>%
  mutate(sex = factor(sex, labels = c("male", "female")),
         race = factor(race, labels = c("mexican american", "other hispanic", "white", "black", "asian", "other")),
         education = factor(education, labels = c("Less than 9th grade", "9-11th grade", "High school graduate", "Some college or AA degree", "College graduate or above")),
         marital = factor(marital, labels = c("partnered", "separated", "never married")))

# Read in the labels
df_label <- read_csv('output/degree_4_kernel_pca_data.csv')
df_label <- df_label %>%
  select(SEQN, label)

# Merge the two dataframes
df_label <- left_join(df_label, df_1520, by = "SEQN")
write_dta(df_label, path = "output/multi.dta", version = 15)