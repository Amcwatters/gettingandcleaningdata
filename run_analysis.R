## This script is for the assignment of the Getting and Cleaning data module
## "You should create one R script called run_analysis.R that does the following.
##     1. Merges the training and the test sets to create one data set.
##     2. Extracts only the measurements on the mean and standard deviation for each measurement.
##     3. Uses descriptive activity names to name the activities in the data set
##     4. Appropriately labels the data set with descriptive variable names.
##  From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject."

##  load dplyr package
library(dplyr)

##  Download the zipfile for the assignment to a folder clled "UCI HAR Dataset" (creating the folder if it doesn't exist)
##  Then unzip the download
if(!file.exists("./UCI HAR Dataset")){dir.create("./UCI HAR Dataset")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./UCI HAR Dataset/download.zip",method="curl")
unzip(zipfile="./UCI HAR Dataset/download.zip",exdir="./UCI HAR Dataset")

##  Load each of the 6 test and train datasets into R into a separate data frame
subjecttest <- read.table("./UCI HAR Dataset/test/subject_test.txt", header=FALSE)
subjecttrain <- read.table("./UCI HAR Dataset/train/subject_train.txt", header=FALSE)
ytest <- read.table("./UCI HAR Dataset/test/y_test.txt", header=FALSE)
ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt", header=FALSE)
xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt", header=FALSE)
xtest <- read.table("./UCI HAR Dataset/test/X_test.txt", header=FALSE)

## Join the test and train datasets using rbind (concatenating by row), and set descriptive fieldnames
## subjecttest and subjecttrain contain the ID of each data subject
## ytest and ytrain contain the ID of each activity measured
## Features fieldnames are drawn from the second column of the reference table "features.txt"
subject <- rbind(subjecttest, subjecttrain)
names(subject)<-c("subject")
activity <- rbind(ytest, ytrain)
names(activity)<- c("activitycode")
features <- rbind(xtrain, xtest)
featuresnames <- read.table("./UCI HAR Dataset/features.txt", head=FALSE)
names(features)<- featuresnames$V2

## Use cbind to join the three dataframes together (by adding the extra columns) - subject, activity, features
combineddataset <- cbind(subject, activity)
UCIdataset <- cbind(combineddataset, features)

## Identify fields which contain mean or standard deviation data and use these to create a subset
UCIdatasubset  <- UCIdataset %>% select(subject, activitycode, contains("mean"), contains("std"))

## Obtain descriptive activity labels from the file “activity_labels.txt” and add them as a new column using merge
activitylabels <- read.table("./UCI HAR Dataset/activity_labels.txt",header = FALSE)
UCIdatasubset <- merge(UCIdatasubset, activitylabels, by.x = "activitycode",by.y = "V1",all.x = TRUE )

## Change the new activity column name from V2 and remove old activitycode column
UCIdatasubset <- rename(UCIdatasubset, activity=V2)
UCIdatasubset <- UCIdatasubset %>% select(-activitycode)


## Change the feature column names to be more descriptive
## Change acronyms and abbreviations to the full descriptive words
names(UCIdatasubset)<-gsub("^t", "time", names(UCIdatasubset))
names(UCIdatasubset)<-gsub("^f", "frequency", names(UCIdatasubset))
names(UCIdatasubset)<-gsub("Acc", "Accelerometer", names(UCIdatasubset))
names(UCIdatasubset)<-gsub("Gyro", "Gyroscope", names(UCIdatasubset))
names(UCIdatasubset)<-gsub("Mag", "Magnitude", names(UCIdatasubset))
names(UCIdatasubset)<-gsub("BodyBody", "Body", names(UCIdatasubset))

## Create a 2nd tidy dataset with the average of each variable for each activity and each subject
## Output the data to a text file in the working directory
outputdata <- UCIdatasubset %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(outputdata, "FinalUCIDataset.txt", row.name=FALSE)   


