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

#end of project this displays particicpants, activity and the average(mean) of all the metrics

