# hsanez
# 27.11.2022
# Course Project IODS
# Assignment 4 - clustering and classification, data wrangling part
# Data downloaded 27.11.2022 22:18 EET from https://archive.ics.uci.edu/ml/machine-learning-databases/00320/
# Datafiles:
## human_development.csv
## gender_inequality.csv
# Documentation:
## https://hdr.undp.org/data-center/human-development-index#/indicies/HDI
## https://hdr.undp.org/system/files/documents//technical-notes-calculating-human-development-indices.pdf
# Meta files:
## https://github.com/KimmoVehkalahti/Helsinki-Open-Data-Science/blob/master/datasets/human_meta.txt

library(tidyverse)
library(dplyr)
library(ggplot2)

#### 2 ####
# read data
hd <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human_development.csv")
gii <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/gender_inequality.csv", na = "..")


#### 3 ####
# See structure and dimentions of the data
str(hd);dim(hd)
str(gii);dim(gii)

# Summaries of the variables
summary(hd)
summary(gii)


#### 4 ####
# Rename variables with shorter names (see Meta files)
# Percent Representation in parliament is % of women (see HDI technical notes)
hd2 <- hd %>% rename(
  'HDI_rank' = 'HDI Rank',
  'HDI' = 'Human Development Index (HDI)',
  'Life.Exp' = 'Life Expectancy at Birth',
  'Edu.Exp' = 'Expected Years of Education',
  'Edu.Mean' = 'Mean Years of Education',
  'GNI' = 'Gross National Income (GNI) per Capita',
  'GNI.minus.HDI_rank' = 'GNI per Capita Rank Minus HDI Rank'
)

gii2 <- gii %>% rename(
  'GII_rank'= 'GII Rank',
  'GII' = 'Gender Inequality Index (GII)',
  'Mat.Mor' = 'Maternal Mortality Ratio',
  'Ado.Birth' = 'Adolescent Birth Rate',
  'Parli.F' = 'Percent Representation in Parliament',
  'Edu2.F' = 'Population with Secondary Education (Female)',
  'Edu2.M' = 'Population with Secondary Education (Male)',
  'Labo.F' = 'Labour Force Participation Rate (Female)',
  'Labo.M' = 'Labour Force Participation Rate (Male)'
)


#### 5 ####
# Add new variables edu2F / edu2M and labF / labM

gii2 <- mutate(gii2, Edu2.FM=Edu2.F/Edu2.M,
               Labo.FM=Labo.F/Labo.M)


#### 6 ####
# Join the two dataset by Country. Keep only those with both datasets (innerjoin())
human <- inner_join(hd2, gii2, by='Country')
dim(human)

#save new dataset to data folder
#write_csv(human, file="human.csv")

#check it reads correctly
read_csv("human.csv")


# Looking good!-> Data wrangling complete!


# Renaming with dplyr
# https://github.com/KimmoVehkalahti/Helsinki-Open-Data-Science/blob/master/datasets/human_meta.txt




#### ASSIGNMENT 5 ####
# hsanez
# 30.11.2022
# DATA WRANGLING PART


### 1. Mutating the data using 'stringr'

# access the stringr package (part of `tidyverse`)
library(stringr)

# Read data where the GNI-variable is of type 'character'
hum0 <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human1.txt", 
                    sep =",", header = T)

# Alternatively our own dataset
# hum <- read_csv("human.csv")

# Structure and dimensions of the data
str(hum0); dim(hum0)
# GNI
str(hum0$GNI)

# remove the commas from GNI and print out a numeric version of it
hum0$GNI <- str_replace(hum$GNI, pattern=",", replace ="") %>% as.numeric()

# check GNI structure
str(hum0$GNI)



### 2. Exclude unneeded variables

# Define variables to keep
keep_vars <- c( "Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")

# subset data with variables to keep and check result
hum2 <- hum0 %>% select(all_of(keep_vars))
str(hum2); dim(hum2)



### 3. Remove rows with missing values and check result
hum2 <- filter(hum2, complete.cases(hum2))
str(hum2);dim(hum2)



### 4. Remove observations which relate to regions instead of countries

# glimpse at the start and end of the data
head(hum2)
tail(hum2)
# it seems that regions are at the end  of  the dataset.
tail(hum2, 15) # We can see 7 regions at the bottom of the dataset

# We know from the assignment information that we should end up with 155 observations so let's remove the 7 regions we see at the end of the 'Country' variable.
hum3 <- hum2[1:(nrow(hum2)-7), ]
# check dimensions
dim(hum3) # 155 observations, look's good!



### 5. Define row names

# add countries as rownames
rownames(hum3) <- hum3$Country
head(hum3)

# remove 'Country' variable
hum <- select(hum3, -Country)
dim(hum) # 155 observations, 8 variables

# save data
# OBS! To save or row names we need to save this dataset with write.csv(), not write_csv()
# ALSO NOTICE THIS WHILW READING THE DATA! use read.csv()
#write.csv(hum, file='human_row_names.csv', row.names=TRUE)

#check it reads correctly
humm <- read.csv('human_row_names.csv', row.names = 1)
head(humm)

# Looking good!-> Data wrangling complete!


# Resources
# https://stackoverflow.com/questions/13271820/specifying-row-names-when-reading-in-a-file