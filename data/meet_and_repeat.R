# hsanez
# 11.12.2022
# Course Project IODS
# Assignment 6 - Analysis of longitudinal data, data wrangling part
# Data downloaded 11.12.2022 18:50 EET from 
# BPRS --> https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt
# rats --> https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt
# Outcome datafiles:
## BPRS_long.csv
## rats_long.csv



## Data wrangling (5p.)

library(tidyverse)
#library(dplyr)
library(ggplot2)


#### 1 Read and review data ####

# read data
BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep =" ", header = T)
rats <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", header = TRUE, sep = '\t')

# See structure and dimensions of the data
str(BPRS);dim(BPRS)

# variable names
names(BPRS)

# View data
View(BPRS)

# Summaries of the data
summary(BPRS)

# idem for rats data
str(rats);dim(rats)
names(rats)
View(rats)
summary(rats)


#### 2 ####
# Convert categorical data to factors
## treatment and subject for BPRS0
## ID and Group for rats0

BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)

rats$ID <- factor(rats$ID)
rats$Group <- factor(rats$Group)

# check change
str(BPRS)
str(rats)

#### 3 ####
# Convert data from wide to long format

# BPRS, pivot from wide to long, arrange by weeks
BPRSL <- pivot_longer(BPRS, cols=-c(treatment,subject), names_to = "weeks",values_to = "bprs") %>%
  arrange(weeks) %>%
  mutate(week = as.integer(substr(weeks, start=5, stop=nchar(weeks))))

head(BPRSL);dim(BPRSL)

# rats, pivot from wide to long, arrange by time, add time column
ratsL <- pivot_longer(rats, cols = -c(ID, Group), names_to = 'WD', values_to = 'Weight') %>% 
  mutate(Time = as.integer(substr(WD, 3, nchar(WD)))) %>%
  arrange(Time)

head(ratsL);dim(ratsL)


#### 4 ####
# Compare wide and long data forms

# BPRS
# glimpse and dimensions of wide data
head(BPRS);dim(BPRS)
# glimpse and dimensions of long data
head(BPRSL);dim(BPRSL)
# column names wide and long
colnames(BPRS);colnames(BPRSL)
# structure of wide and long
str(BPRS); str(BPRSL)

# rats
head(rats);dim(rats)
head(ratsL);dim(ratsL)
colnames(rats);colnames(ratsL)
str(rats); str(ratsL)

### The wide data format has more columns, and each row is an individual; we have multiple observations of the same individual divided in different columns.
### The long format has less columns but more rows since the observations from each individual are divided on multiple rows.

# write wrangled datasets to data folder
#write.csv(BPRSL, file='BPRS_long.csv')
#write.csv(ratsL, file='rats_long.csv')


#check the data reads correctly
BPRSL_test <- read.csv('BPRS_long.csv', row.names=1)
  head(BPRSL_test);dim(BPRSL_test)

ratsL_test <- read.csv('rats_long.csv', row.names = 1)
  head(ratsL_test);dim(ratsL_test)


# Looking good!-> Data wrangling complete!
