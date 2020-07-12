# gettingandcleaningdata
Final peer graded assignment for getting and cleaning data course
Anna McWatters

What data has been used for this assignment?

This assignment uses the Human Activity Recognition Using Smartphones Data Set. The Human Activity Recognition database has been created built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors.
More information on this data source can be found at http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
The specific copy of the dataset used for this assignment was downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip on 12/07/2020

What files are contained in this assignment submission?

README.md - this is the file you are reading now

CodeBook.md - this is a code book that describes the variables, the data, and any transformations done to clean up the data

run_analysis.R - this script performs the data preparation and then follows the criteria given in the course project’s definition

    1.  Merges the training and the test sets to create one data set.
    2.  Extracts only the measurements on the mean and standard deviation for each measurement.
    3.  Uses descriptive activity names to name the activities in the data set
    4.  Appropriately labels the data set with descriptive variable names.
    5.  From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
    
FinalUCIdataset.txt - this is the exported final tidy dataset produced by run_analysis.R

How is the data prepared?

The script which prepares the dataset is run_analysis.R

It makes use of the dplyr package and performs the following steps:

  Load the dplyr package
  Download the zipfile for the assignment to a folder clled "UCI HAR Dataset" 
  Then unzip the download
  Load each of the 6 test and train datasets into R into a separate data frame
  Join the test and train datasets using rbind (concatenating by row), and set descriptive fieldnames
      subjecttest and subjecttrain contain the ID of each data subject
      ytest and ytrain contain the ID of each activity measured
      features fieldnames are drawn from the second column of the reference table "features.txt"
  Use cbind to join the three dataframes together (by adding the extra columns) - subject, activity, features
  Identify fields which contain mean or standard deviation data and use these to create a list of fields for a subset, along with the subject and activity label columns
  Create a subset using these column or field names
  Obtain descriptive activity labels from the file “activity_labels.txt” and add them as a new column using merge
  Change the new activity column name from V2 and remove the old activitycode column
  Change the feature column names to be more descriptive
  Change acronyms and abbreviations to the full descriptive words
  Create a 2nd tidy dataset with the average of each variable for each activity and each subject
  Output the data to a text file in the working directory
  
