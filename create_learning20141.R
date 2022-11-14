#hsanez 9.11.2022
#create_learning20141.R
#Creating the data for ch2 analysis
# UH IODS-project, template and data forked from https://github.com/KimmoVehkalahti/IODS-project

# CONTENTS
## 2.0 INSTALL THE REQUIRED PACKAGES FIRST!
## 2.1 Reading data from the web
## 2.2 Scaling variables
## 2.3 Combining variables
## 2.4 Selecting columns
## 2.5 Modifying column names
## 2.6 Excluding observations
## Setting the working directory then saving and reading a new dataset


## 2.0 INSTALL THE REQUIRED PACKAGES FIRST!
# install.packages("GGally")


## 2.1 Reading data from the web

# Read data from webpage to a dataframe
lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

# check the dimensions of the data
dim(lrn14)
## comment on output: This datafile has 183 rows (observations) and 60 columns (variables)

# check the structure of the dataframe
str(lrn14)
## comment on output: There are 59 integer and 1 character type variables

# check the summary of the variables of the dataframe
summary(lrn14)
## comment on output: There seems to be no missing data on the data



## 2.2 Scaling variables

# Create an analysis dataset with select variables (gender, age, attitude, deep, stra, surf, points)
# Check available variables
colnames(lrn14)
## since only gender, Age, Attitude, and Points columns are available, we have to create the other wanted variables as combinations of the variables we have now
# Attitude  Da + Db + Dc + Dd + De + Df + Dg + Dh + Di + Dj
# Use vector division to create a new column `attitude` in the `lrn14` data frame, where each observation of `Attitude` is scaled back to the original scale of the questions, by dividing it with the number of questions.
## This means the new attitude-variable should be Attitude/10

# create column 'attitude' by scaling the column "Attitude" (scaling here means taking the mean = dividing with the number of questions)
lrn14$attitude <- lrn14$Attitude / 10




## 2.3 Combining variables


# Access the dplyr library
library(dplyr)

# questions related to deep, surface and strategic learning
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# select the columns related to deep learning 
deep_columns <- select(lrn14, one_of(deep_questions))
# and create column 'deep' by averaging
lrn14$deep <- rowMeans(deep_columns)

# select the columns related to surface learning 
surface_columns <- select(lrn14, one_of(surface_questions))
# and create column 'surf' by averaging
lrn14$surf <- rowMeans(surface_columns)

# select the columns related to strategic learning 
#strategic_columns <- "change me!"
strategic_columns <- select(lrn14, one_of(strategic_questions))
# and create column 'stra' by averaging
lrn14$stra <- rowMeans(strategic_columns)

# Check dimension
dim(lrn14)



## 2.4 Selecting columns


# access the dplyr library
library(dplyr)

# choose a handful of columns to keep
keep_columns <- c("gender","Age","attitude", "deep", "stra", "surf", "Points")

# select the 'keep_columns' to create a new dataset
learning2014 <- select(lrn14, one_of(keep_columns))

# see the structure of the new dataset
str(learning2014)




## 2.5 Modifying column names


# print out the column names of the data
colnames(learning2014)

# change the name of the second column
colnames(learning2014)[2] <- "age"

# change the name of "Points" to "points"
colnames(learning2014)[7] <- "points"

# print out the new column names of the data
colnames(learning2014)



## 2.6 Excluding observations

# access the dplyr library
library(dplyr)

# select male students
male_students <- filter(learning2014, gender == "M")

# select rows where points is greater than zero
learning2014 <- filter(learning2014, points >0)

# check dimensions
dim(learning2014)


## Setting the working directory then saving and reading a new dataset

# Setting the working directory
setwd("/home/ad/lxhome/h/heisanez/Linux/R_projects/IODS-project")
# check that working directory was set
getwd()

# Save the analysis dataset to the 'data' folder as 'learning2014.csv'
library(readr)
write_csv(learning2014, file="/home/ad/lxhome/h/heisanez/Linux/R_projects/IODS-project/data/learning2014.csv")


# Read saved data as a tibble
lrnv2 <- read_csv("/home/ad/lxhome/h/heisanez/Linux/R_projects/IODS-project/data/learning2014.csv")

str(lrnv2)
head(lrnv2)

