# samsungDataAnalysis
Step 1
In order to the code to work, the files should be download from the following url. 
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

Step 2
Once the files are downloaded, set the working directory to the downloaded directory files. 
Should be ./UCI HAR Dataset

Step 3
Source the file source("run_analysis.R") attached here in the repo.

The Code
The code in the .R file fullfils the following task: 
## 1. Merges the training and the test sets to create one data set.
Loads training and test data from the features gathered and assign it to a variable called oneDataSet

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
Filter only mean and standard deviation from each measurement and then filter only selected measurement from previous dataset

## 3. Uses descriptive activity names to name the activities in the data set
Use the factor function to assing correct labels to each column of the dataset

## 4. Appropriately labels the data set with descriptive variable names.
Clean feature name special characters

## 5. From the data set in step 4, creates a second, independent tidy data set with 
##    the average of each variable for each activity and each subject.
Using reshape library, create tidy data from previous dataset.
