# GetCleanPrjct
In order to create this project I used the following steps:
1) set working directory and create tables/matrices for all of the different files I would be using
2)the data had "test" and "train" data that needed to be combined, all of the data sets had one of each.  I combined consistently using "test" then "train"
3) "X" data was a series of many variables, I needed to label them so that I could have labels, as well as narrow down to the "mean" and "std". The names for the 
  labels were on the 'features.txt' file which I created the table "colhdr" to carry the labels.  Then create a vector from the table and last used the "names" function to
    get all of the column headers assigned
4) Once all of the "x" data was assigned a column header I could narrow down to the "mean OR STD" function, for this I used "grep" function. 
  This also leaves some column headers with "Freq" those were taken out with "-grep" so we only had "mean" or "std"
5) Now I needed to create the columns with the subjects in subject train/test and the activities in the Y test/train data. Then combine with cbind and label the columns.
6) In this part I combined all the "cleaned" data into one large table called "fitwatchinfo"  this basically takes: Subject, Y info, X info.  Y info being the activities.
7) This finishes requirement 3 which it to take the activity numbers and change to the actual activity, "walking" "sitting" etc.  For this I created a vector with the activites, then
  used a loop and gsub to change out all of the activity names 
8) In the last part I summarized the data, by having the mean of all of the "x" data grouped by participant and activity. This gives out put such as (below is a small abbreviation
merely to show how the summary worked): 
 Subject  Actvity BodyAccMean Body Acc STD
  1       Walking     0.2222    -0.929
  1       Standing    0.279     -0.966
  2       Walking     0.276    -0.424
  2       Standing    0.278     -0.987
  
  Below is the code with notes:
setwd("C:/Users/joking/Documents/R/quiz4")

#Assign tables/matrix to the documents
ytest <- read.table("UCIHARDataset/test/y_test.txt")
xtest <- read.table("UCIHARDataset/test/X_test.txt")
subjts <- read.table("UCIHARDataset/test/subject_test.txt")
subjtn <- read.table("UCIHARDataset/train/subject_train.txt")
xtrain <- read.table("UCIHARDataset/train/X_train.txt")
ytrain <- read.table("UCIHARDataset/train/y_train.txt")
colhdr <- read.table("UCIHARDataset/features.txt")

#Combine "X" data with 'rbind' keep a consistent train then test throughout the data set so that the data matches up. 
#Once Xtrain,Xtest combined get the headers from 'features.txt' which is named "colhdr", create a vector then
#assign the names of comgrp to the 

comgrp <- rbind(xtrain, xtest)
colnam <- colhdr[,2]
names(comgrp) <- c(colnam)

#Step2 Narrow down columns in the "x train,test" to only the mean and std:
narrowgrp <- comgrp[(grep(("mean|std"),colnames(comgrp)))]
#get rid of mean"Freq" since that is not on the list:
latest <- narrowgrp[(-grep("Freq", names(narrowgrp),colnames(narrowgrp)))]

##now finish step 1 and combine subject sheets and y sheets with rbind, followed by cbind
subjttl <- rbind(subjtn,subjts)
allys <- rbind(ytrain, ytest)
idgrp <- cbind(subjttl, allys)

#label the new subject and y dataset and then cbind with the x test/train data
names(idgrp) <- c("Subject", "Activity")
fitwatchinfo <- cbind(idgrp,latest)

#Step 3: replace activity numbers with the activity names. First create a vector of label names and then use 
# a loop to run through and change the number to names of labels.
activities <- read.table("UCIHARDataset/activity_labels.txt")
act.labels <- c(activities[,2])

for (i in 1:6){
  fitwatchinfo$Activity <- gsub(i, act.labels[i], fitwatchinfo$Activity)
  }

#Step 5:From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(dplyr)
fitwatchinfo %>%
  group_by(Subject, Activity) %>%
  summarize_all(mean)


