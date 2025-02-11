## Objective: extract hearing data from NHANES 1999 - 2020
## NHANES 2015-2016 Data Documentation: https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2015/DataFiles/AUX_I.htm
## NHANES 2017-2020 Data Documentation: https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2015/DataFiles/AUX_I.htm

# Convert XPT file into a csv file

rm(list=ls())
setwd('/Users/bruce/Desktop/Prof Wang Lab/hearing-clustering')
library(haven)
library(tidyverse)
library(dplyr)
library(ggplot2)

# Read data

# Define the base directory where folders are stored
base_dir <- "data/"

# Get a list of folder names
folders <- list.dirs(base_dir, recursive = FALSE)

# Create an empty list to store data
data_list <- list()

# Loop through each folder and read the XPT file
for (folder in folders) {
  # Find the XPT file in the folder
  xpt_file <- list.files(folder, pattern = "\\.XPT$", full.names = TRUE, ignore.case = TRUE)
  
  # Check if an XPT file is found
  if (length(xpt_file) == 1) {
    # Read the file
    data_list[[basename(folder)]] <- read_xpt(xpt_file)
  } else {
    warning(paste("No XPT file found in", folder))
  }
}

# Define columns to select
var_list <- c('SEQN', 'AUXU500L', 'AUXU1K1L', 'AUXU2KL', 'AUXU3KL', 'AUXU4KL', 'AUXU6KL', 'AUXU8KL',
              'AUXU500R', 'AUXU1K1R', 'AUXU2KR', 'AUXU3KR', 'AUXU4KR', 'AUXU6KR', 'AUXU8KR')

select_columns <- function(df) {
  df <- df %>%
    select(all_of(var_list))
}

data_list <- lapply(data_list, select_columns)
pooled_hearing <- do.call(rbind, data_list)
rownames(pooled_hearing) <- 1:nrow(pooled_hearing)

# Data processing
pooled_hearing <- pooled_hearing[complete.cases(pooled_hearing),]

# Extract the left ears
pooled_hearing_left <- pooled_hearing %>%
  select(all_of(var_list[1:8]))
pooled_hearing_right <- pooled_hearing %>%
  select(all_of(var_list[c(1,9:length(var_list))]))

colnames(pooled_hearing_left) <- c('SEQN', '500 Hz', '1 kHz', '2 kHz', '3 kHz', '4 kHz', '6 kHz', '8 kHz')
colnames(pooled_hearing_right) <- c('SEQN', '500 Hz', '1 kHz', '2 kHz', '3 kHz', '4 kHz', '6 kHz', '8 kHz')
pooled_hearing_all <- bind_rows(pooled_hearing_left, pooled_hearing_right)

pooled_hearing_all <- pooled_hearing_all %>%
  arrange(SEQN)

# Output the dataset
write.csv(pooled_hearing_all, file = "output/pooled_nhanes_1999_2020.csv", row.names = FALSE)