# hsanez
# 15.11.2022
# Course Project IODS
# Assignment 3 - logistic regression, data wrangling part
# Data downloaded 15.11.2022 16:50 EEST from https://archive.ics.uci.edu/ml/machine-learning-databases/00320/
# Datafiles:
## student-mat.csv
## student-por.csv

library(tidyverse)
library(dplyr)
library(ggplot2)

#### 3 ####
# read data
# use read_csv2() since the data has a semicolon as separator
smat <- read_csv2("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/student-mat.csv")
# dimensions of the data -> 395 observations and 33 columns/variables
dim(smat)
# structure of the data -> a lot of doubles and character variables
str(smat)
# first rows of the data -> reading of the data seems successful
head(smat)

# read second data file, separator ";"
spor <-read_csv2("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/student-por.csv")
# dimensions -> 649 observations, 33 columns
dim(spor)
# structure -> mainly doubles and strings
str(spor)
# first rows -> reading successful
head(spor)


#### 4 ####
# list unwanted columns in vector
outvars <- c("failures", "paid", "absences", "G1", "G2", "G3")

# the rest of the columns are common identifiers used for joining the data sets
#setdiff() identify values in vector a that do not occur in vector b
join_cols <- setdiff(colnames(spor), outvars)

# join the two data sets by the selected identifiers and with proper suffixes, inner_join keeps only students present in both datasets
stud <- inner_join(smat, spor, by = join_cols, suffix=c(".mat", ".por"))

# look at the column names of the joined data set
colnames(stud)

# glimpse at the joined data set -> 370 rows, 39 columns
dim(stud)
glimpse(stud)


#### 5 ####
# Remove duplicates

# print column names
colnames(stud)

# create a new data frame with only the joined columns
alc <- select(stud, all_of(join_cols))
colnames(alc);dim(alc)

# print out the columns not used for joining (those that varied in the two data sets)
outvars

# for every column name not used for joining...
for(col_name in outvars) {
  # select two columns from 'stud' with the same original name
  two_cols <- select(stud, starts_with(col_name))
  # select the first column vector of those two columns
  first_col <- select(two_cols, 1)[[1]]
  
  # then, enter the if-else structure!
  # if that first column vector is numeric...
  if(is.numeric(first_col)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[col_name] <- round(rowMeans(two_cols))
  } else { # else (if the first column vector was not numeric)...
    # add the first column vector to the alc data frame
    alc[col_name] <- first_col
  }
}

# glimpse
glimpse(alc)
colnames(alc);dim(alc)
# looking good!


#### 6 ####
# add new column alc_use which is the average of the answers related to weekday and weekend alcohol consumption (both are on Likert scale)
alc <- alc %>% mutate(alc_use = (Dalc + Walc) /2)
# create new column high_use which is TRUE for students for whom 'alc_use' is >2 (FALSE otherwise)
alc <- alc %>% mutate(high_use = alc_use >2)

# initialize a plot of alcohol use
g1 <- ggplot(data = alc, aes(x = alc_use, fill=sex))

# define the plot as a bar plot and draw it
g1 + geom_bar()

# initialize a plot of 'high_use'
g2 <- ggplot(data = alc, aes(x = high_use, col=sex))

# draw a bar plot of high_use by sex
g2 + geom_bar() + facet_wrap("sex")

#### 7 ####
# check data
dim(alc)
str(alc)
# Glimpse -> looking good! 370 observations, 35 variables.
alc %>% slice(1:5)
summary(alc)
glimpse(alc)

#save new dataset to data folder
#write_csv(alc, file="student_alc.csv")

#check it reads correctly
read_csv("student_alc.csv")


# Looking good!-> Data wrangling complete!



